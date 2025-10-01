import os
from typing import Dict, List, Optional, Union, Generator, Any, AsyncGenerator
import asyncio
from indoxrouter import Client
from base_provider import BaseProvider


class IndoxRouterProvider(BaseProvider):
    """A provider interface for interacting with IndoxRouter (LLM Gateway).

    This class provides functionality for working with various LLM providers through
    IndoxRouter using the chat endpoint. It handles model loading, message formatting,
    streaming responses, and BYOK (Bring Your Own Key) support.

    Authentication Flow:
    - User provides IndoxRouter API key: Uses their IndoxRouter account/credits
    - User provides BYOK API key: Uses shared IndoxRouter API key (hidden) for auth,
      but user's own provider API key for requests (user pays provider directly)
    """

    def __init__(
        self, api_key: str, model_name: str, byok_api_key: Optional[str] = None
    ):
        """Initialize a new IndoxRouterProvider instance.

        Args:
            api_key (str): The IndoxRouter API key
            model_name (str): The model name in format "provider/model" (e.g., "openai/gpt-4")
            byok_api_key (str, optional): Your own API key for the provider (BYOK support)
        """
        super().__init__(api_key, model_name)
        self.byok_api_key = byok_api_key

        # Initialize IndoxRouter client
        self.client = Client(api_key=api_key)

        # Test connection on initialization
        try:
            self.client.test_connection()
        except Exception as e:
            print(f"IndoxRouter connection failed: {str(e)}")
            raise

    def format_messages(self, user_prompt: str, system_prompt: str = "") -> List[Dict]:
        """Format messages for the IndoxRouter API format.

        Args:
            user_prompt (str): The user's input message
            system_prompt (str, optional): System instructions. Defaults to empty string.

        Returns:
            List[Dict]: A list of message dictionaries in IndoxRouter's format
        """
        messages = []

        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})

        messages.append({"role": "user", "content": user_prompt})
        return messages

    def complete(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response from IndoxRouter (non-streaming).

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Returns:
            str: The generated response text
        """
        params = {"messages": messages, "model": self.model_name, **kwargs}
        if self.byok_api_key:
            params["byok_api_key"] = self.byok_api_key

        response = self.client.chat(**params)
        return response["data"]

    async def complete_async(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response from IndoxRouter asynchronously.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Returns:
            str: The generated response text
        """
        # Run the synchronous method in a thread pool
        loop = asyncio.get_event_loop()
        return await loop.run_in_executor(None, self.complete, messages, **kwargs)

    def stream(self, messages: List[Dict], **kwargs) -> Generator[str, None, None]:
        """Stream a response from IndoxRouter.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Yields:
            str: Chunks of the generated response text
        """
        params = {
            "messages": messages,
            "model": self.model_name,
            "stream": True,
            **kwargs,
        }

        if self.byok_api_key:
            params["byok_api_key"] = self.byok_api_key

        try:
            stream = self.client.chat(**params)
            for chunk in stream:
                if self.stop_generation:
                    break

                # Extract content from the chunk
                if hasattr(chunk, "choices") and len(chunk.choices) > 0:
                    delta = chunk.choices[0].delta
                    if hasattr(delta, "content") and delta.content:
                        yield delta.content

        except Exception as e:
            print(f"Streaming error: {str(e)}")

    async def stream_async(
        self, messages: List[Dict], **kwargs
    ) -> AsyncGenerator[str, None]:
        """Stream a response from IndoxRouter asynchronously.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Yields:
            str: Chunks of the generated response text
        """
        # Run the synchronous streaming method in a thread pool
        loop = asyncio.get_event_loop()

        def sync_stream():
            return list(self.stream(messages, **kwargs))

        chunks = await loop.run_in_executor(None, sync_stream)
        for chunk in chunks:
            if self.stop_generation:
                break
            yield chunk

    def stop(self):
        """Stop the ongoing generation process."""
        self.stop_generation = True
