import json
import os
import sys
from typing import Dict, List, Optional, Union, Generator, Any, AsyncGenerator
import asyncio
from openai import OpenAI, AsyncOpenAI
from base_provider import BaseProvider


class DeepseekProvider(BaseProvider):
    """DeepSeek provider implementation that uses OpenAI SDK with custom base URL.

    This provider connects to the DeepSeek API which has a compatible interface
    with the OpenAI API, but uses different endpoints.
    """

    def __init__(self, api_key: str, model_name: str):
        """
        Initialize the DeepSeek provider.

        Args:
            api_key: The API key for DeepSeek.
            model_name: The name of the model to use.
        """
        # Clean up model name if needed (remove any provider prefix)
        if "/" in model_name:
            _, model_name = model_name.split("/", 1)

        self.DEEPSEEK_BASE_URL = "https://api.deepseek.com"
        # Use beta URL for completions
        self.DEEPSEEK_BETA_URL = "https://api.deepseek.com/beta"

        super().__init__(api_key, model_name)

        # Create clients with appropriate base URLs
        self.client = OpenAI(api_key=api_key, base_url=self.DEEPSEEK_BASE_URL)
        self.async_client = AsyncOpenAI(
            api_key=api_key, base_url=self.DEEPSEEK_BASE_URL
        )
        # Create a separate client for beta API (completions)
        self.beta_client = OpenAI(api_key=api_key, base_url=self.DEEPSEEK_BETA_URL)
        self.async_beta_client = AsyncOpenAI(
            api_key=api_key, base_url=self.DEEPSEEK_BETA_URL
        )

    def complete(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response from DeepSeek (non-streaming).

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Returns:
            str: The generated response text
        """
        # Use beta client for completions
        response = self.beta_client.chat.completions.create(
            model=self.model_name, messages=messages, stream=False, **kwargs
        )
        return response.choices[0].message.content

    async def complete_async(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response from DeepSeek asynchronously.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Returns:
            str: The generated response text
        """
        # Use async beta client for completions
        response = await self.async_beta_client.chat.completions.create(
            model=self.model_name, messages=messages, stream=False, **kwargs
        )
        return response.choices[0].message.content

    def stream(self, messages: List[Dict], **kwargs) -> Generator[str, None, None]:
        """Stream a response from DeepSeek.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Yields:
            str: Chunks of the generated response text
        """
        # Use regular client with stream=True
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
        """Stream a response from DeepSeek asynchronously.

        Args:
            messages (List[Dict]): The formatted messages
            **kwargs: Additional parameters to pass to the API

        Yields:
            str: Chunks of the generated response text
        """
        # Use async client with stream=True
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
