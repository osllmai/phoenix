from typing import Dict, List, Optional, Union, Generator, Any, AsyncGenerator
import asyncio


class BaseProvider:
    """Base class for all provider implementations.

    Provides common functionality and interface that all providers should implement.
    """

    def __init__(self, api_key: str, model_name: str):
        """Initialize the base provider.

        Args:
            api_key: The API key for the provider.
            model_name: The name of the model to use.
        """
        self.model_name = model_name
        self.api_key = api_key
        self.stop_generation = False

    def format_messages(self, user_prompt: str, system_prompt: str = "") -> List[Dict]:
        """Format messages for the provider's API format.

        Args:
            user_prompt: The user's input message.
            system_prompt: System instructions (optional).

        Returns:
            List of message dictionaries in the provider's format.
        """
        messages = []

        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})

        messages.append({"role": "user", "content": user_prompt})
        return messages

    def complete(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response (non-streaming).

        Args:
            messages: The formatted messages.
            **kwargs: Additional parameters to pass to the API.

        Returns:
            The generated response text.
        """
        raise NotImplementedError("Subclasses must implement this method")

    async def complete_async(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response asynchronously.

        Args:
            messages: The formatted messages.
            **kwargs: Additional parameters to pass to the API.

        Returns:
            The generated response text.
        """
        raise NotImplementedError("Subclasses must implement this method")

    def stream(self, messages: List[Dict], **kwargs) -> Generator[str, None, None]:
        """Stream a response.

        Args:
            messages: The formatted messages.
            **kwargs: Additional parameters to pass to the API.

        Yields:
            Chunks of the generated response text.
        """
        raise NotImplementedError("Subclasses must implement this method")

    async def stream_async(
        self, messages: List[Dict], **kwargs
    ) -> AsyncGenerator[str, None]:
        """Stream a response asynchronously.

        Args:
            messages: The formatted messages.
            **kwargs: Additional parameters to pass to the API.

        Yields:
            Chunks of the generated response text.
        """
        raise NotImplementedError("Subclasses must implement this method")

    def stop(self):
        """Stop the ongoing generation process."""
        self.stop_generation = True
