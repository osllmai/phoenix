import json
import os
import sys
from typing import Dict, List, Optional, Union, Generator, Any, AsyncGenerator
import asyncio
from openai import OpenAI, AsyncOpenAI
from base_provider import BaseProvider


class OpenAIProvider(BaseProvider):
    """A provider interface for interacting with OpenAI models.

    This class provides functionality for working with OpenAI models,
    handling model loading, message formatting, and both synchronous and
    asynchronous generation of responses.
    """

    def __init__(self, api_key: str, model_name: str):
        """Initialize a new OpenAIProvider instance.

        Args:
            api_key (str): The API key for OpenAI
            model_name (str): The name of the OpenAI model to use
        """
        super().__init__(api_key, model_name)
        self.client = OpenAI(api_key=api_key)
        self.async_client = AsyncOpenAI(api_key=api_key)

    def format_messages(self, user_prompt: str, system_prompt: str = "") -> List[Dict]:
        """Format messages for the OpenAI API format.

        Args:
            user_prompt (str): The user's input message
            system_prompt (str, optional): System instructions. Defaults to empty string.

        Returns:
            List[Dict]: A list of message dictionaries in OpenAI's format
        """
        messages = []

        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})

        messages.append({"role": "user", "content": user_prompt})
        return messages

    def complete(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response from OpenAI (non-streaming).

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Returns:
            str: The generated response text
        """
        response = self.client.chat.completions.create(
            model=self.model_name, messages=messages, stream=False, **kwargs
        )
        return response.choices[0].message.content

    async def complete_async(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response from OpenAI asynchronously.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Returns:
            str: The generated response text
        """
        response = await self.async_client.chat.completions.create(
            model=self.model_name, messages=messages, stream=False, **kwargs
        )
        return response.choices[0].message.content

    def stream(self, messages: List[Dict], **kwargs) -> Generator[str, None, None]:
        """Stream a response from OpenAI.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Yields:
            str: Chunks of the generated response text
        """
        stream = self.client.chat.completions.create(
            model=self.model_name, messages=messages, stream=True, **kwargs
        )
        for chunk in stream:
            if self.stop_generation:
                break
            if chunk.choices[0].delta.content:
                yield chunk.choices[0].delta.content

    async def stream_async(
        self, messages: List[Dict], **kwargs
    ) -> AsyncGenerator[str, None]:
        """Stream a response from OpenAI asynchronously.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Yields:
            str: Chunks of the generated response text
        """
        stream = await self.async_client.chat.completions.create(
            model=self.model_name, messages=messages, stream=True, **kwargs
        )
        async for chunk in stream:
            if self.stop_generation:
                break
            if chunk.choices[0].delta.content:
                yield chunk.choices[0].delta.content

    def stop(self):
        """Stop the ongoing generation process."""
        self.stop_generation = True
