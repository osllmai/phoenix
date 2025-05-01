import json
import os
import sys
from typing import Dict, List, Optional, Union, Generator, Any, AsyncGenerator
import asyncio
from mistralai import Mistral
from base_provider import BaseProvider


class MistralProvider(BaseProvider):
    """A provider interface for interacting with Mistral models.

    This class provides functionality for working with Mistral models,
    handling model loading, message formatting, and both synchronous and
    asynchronous generation of responses.
    """

    def __init__(self, api_key: str, model_name: str):
        """Initialize a new MistralProvider instance.

        Args:
            api_key (str): The API key for Mistral
            model_name (str): The name of the Mistral model to use
        """
        super().__init__(api_key, model_name)
        self.client = Mistral(api_key=api_key)
        self.stop_generation = False

    def format_messages(self, user_prompt: str, system_prompt: str = "") -> List[Dict]:
        """Format messages for the Mistral API format.

        Args:
            user_prompt (str): The user's input message
            system_prompt (str, optional): System instructions. Defaults to empty string.

        Returns:
            List[Dict]: A list of message dictionaries in Mistral's format
        """
        messages = []

        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})

        messages.append({"role": "user", "content": user_prompt})
        return messages

    def complete(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response from Mistral (non-streaming).

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Returns:
            str: The generated response text
        """
        # Use client.chat.complete as per the official documentation
        response = self.client.chat.complete(
            model=self.model_name, messages=messages, **kwargs
        )
        return response.choices[0].message.content

    async def complete_async(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response from Mistral asynchronously.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Returns:
            str: The generated response text
        """
        # Wrap the synchronous call in an asynchronous context
        loop = asyncio.get_event_loop()
        return await loop.run_in_executor(
            None, lambda: self.complete(messages, **kwargs)
        )

    def stream(self, messages: List[Dict], **kwargs) -> Generator[str, None, None]:
        """Stream a response from Mistral.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Yields:
            str: Chunks of the generated response text
        """
        # Use client.chat.stream as per the official documentation
        stream = self.client.chat.stream(
            model=self.model_name, messages=messages, **kwargs
        )
        try:
            for chunk in stream:
                if self.stop_generation:
                    break
                if chunk.choices[0].delta.content:
                    yield chunk.choices[0].delta.content
        finally:
            if self.stop_generation:
                stream.close()

    async def stream_async(
        self, messages: List[Dict], **kwargs
    ) -> AsyncGenerator[str, None]:
        """Stream a response from Mistral asynchronously.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Yields:
            str: Chunks of the generated response text
        """
        # Use client.chat.stream_async as per the official documentation
        stream = await self.client.chat.stream_async(
            model=self.model_name, messages=messages, **kwargs
        )
        async for chunk in stream:
            if self.stop_generation:
                break
            if chunk.data.choices[0].delta.content:
                yield chunk.data.choices[0].delta.content

    def stop(self):
        """Stop the ongoing generation process."""
        self.stop_generation = True
