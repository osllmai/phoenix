import json
import os
from typing import Dict, List, Optional, Union, Generator, Any, AsyncGenerator
import asyncio
from openai import OpenAI, AsyncOpenAI
from mistralai import Mistral


class Provider:
    """A unified interface for interacting with various language model providers.

    This class provides a consistent interface for working with different language model
    providers (e.g., OpenAI, Mistral). It handles model loading, message formatting,
    and both synchronous and asynchronous generation of responses.

    Attributes:
        provider (str): The name of the current provider (e.g., "openai", "mistral")
        model_name (str): The name of the loaded model
        api_key (str): The API key for the current provider
        client: The synchronous client instance for the provider
        async_client: The asynchronous client instance for the provider
        stop_generation (bool): Flag to control stopping of generation
        providers_config (dict): Configuration settings for supported providers
    """

    def __init__(self):
        """Initialize a new Provider instance with default values."""
        self.provider = None
        self.model_name = None
        self.api_key = None
        self.client = None
        self.async_client = None
        self.stop_generation = False
        self._load_providers_config()

    def _load_providers_config(self):
        """Load provider configurations from the providers.json file.

        The configuration file contains information about supported models and
        parameters for each provider.

        Raises:
            FileNotFoundError: If providers.json is not found
            json.JSONDecodeError: If providers.json is not valid JSON
        """
        config_path = os.path.join(os.path.dirname(__file__), "provider.json")
        with open(config_path, "r") as f:
            self.providers_config = json.load(f)

    def _validate_model(self, provider, model_name):
        """Validate that the requested model is supported by the provider.

        Args:
            provider (str): The name of the provider to validate
            model_name (str): The name of the model to validate

        Raises:
            ValueError: If the provider is not supported or the model is not
                supported by the provider
        """
        if provider not in self.providers_config:
            raise ValueError(f"Unsupported provider: {provider}")

        supported_models = self.providers_config[provider].get("supported_models", [])
        if model_name not in supported_models:
            raise ValueError(f"Model {model_name} is not supported by {provider}")

    def load_model(self, model: str, api_key: str):
        """Initialize the appropriate client based on the provider and model.

        Args:
            model (str): Provider and model in the format "provider/model_name"
            api_key (str): API key for the provider

        Returns:
            Provider: The current Provider instance for method chaining

        Raises:
            ValueError: If the provider is not supported
        """
        self.provider, self.model_name = model.split("/")
        self.api_key = api_key

        # Validate the model
        self._validate_model(self.provider, self.model_name)

        if self.provider == "openai":
            self.client = OpenAI(api_key=self.api_key)
            self.async_client = AsyncOpenAI(api_key=self.api_key)
        elif self.provider == "mistral":
            self.client = Mistral(api_key=self.api_key)
        else:
            raise ValueError(f"Unsupported provider: {self.provider}")

        return self

    def stop(self):
        """Stop the ongoing generation process.

        This method sets the stop_generation flag to True, which will cause any
        ongoing streaming generation to stop at the next iteration.
        """
        self.stop_generation = True

    def _format_messages_openai(
        self, user_prompt: str, system_prompt: str = ""
    ) -> List[Dict]:
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

    def _format_messages_mistral(
        self, user_prompt: str, system_prompt: str = ""
    ) -> List[Dict]:
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

    def _filter_parameters(self, kwargs: Dict) -> Dict:
        """Filter kwargs to only include supported parameters for the current provider.

        Args:
            kwargs (Dict): Dictionary of parameter names and values

        Returns:
            Dict: Filtered dictionary containing only supported parameters
        """
        if self.provider in self.providers_config:
            supported_params = (
                self.providers_config[self.provider]
                .get("supported_parameters", {})
                .keys()
            )
            return {k: v for k, v in kwargs.items() if k in supported_params}
        return kwargs

    def prompt(
        self,
        user_prompt: str,
        system_prompt: str = "",
        stream: bool = False,
        **kwargs,
    ) -> Union[str, Generator[str, None, None]]:
        """Generate a response using the selected model.

        This method handles both streaming and non-streaming generation modes.

        Args:
            user_prompt (str): The user's input message
            system_prompt (str, optional): System instructions. Defaults to empty string.
            stream (bool, optional): Whether to stream the response. Defaults to False.
            **kwargs: Additional model parameters (temperature, top_p, etc.)

        Returns:
            Union[str, Generator[str, None, None]]: Either a complete response string
                or a generator that yields response chunks

        Raises:
            ValueError: If no model has been loaded or the provider is not supported
        """
        if not self.client:
            raise ValueError("No model loaded. Call load_model() first.")

        self.stop_generation = False
        filtered_kwargs = self._filter_parameters(kwargs)

        if self.provider == "openai":
            messages = self._format_messages_openai(user_prompt, system_prompt)

            if stream:
                return self._stream_openai(messages, **filtered_kwargs)
            else:
                return self._complete_openai(messages, **filtered_kwargs)

        elif self.provider == "mistral":
            # Convert messages to Mistral format
            mistral_messages = self._format_messages_mistral(user_prompt, system_prompt)

            if stream:
                return self._stream_mistral(mistral_messages, **filtered_kwargs)
            else:
                return self._complete_mistral(mistral_messages, **filtered_kwargs)

        else:
            raise ValueError(f"Unsupported provider: {self.provider}")

    async def prompt_async(
        self,
        user_prompt: str,
        system_prompt: str = "",
        stream: bool = False,
        **kwargs,
    ) -> Union[str, AsyncGenerator[str, None]]:
        """Generate a response asynchronously using the selected model.

        This is the asynchronous version of the prompt method.

        Args:
            user_prompt (str): The user's input message
            system_prompt (str, optional): System instructions. Defaults to empty string.
            stream (bool, optional): Whether to stream the response. Defaults to False.
            **kwargs: Additional model parameters (temperature, top_p, etc.)

        Returns:
            Union[str, AsyncGenerator[str, None]]: Either a complete response string
                or an async generator that yields response chunks

        Raises:
            ValueError: If no model has been loaded or the provider is not supported
        """
        if not self.async_client:
            raise ValueError("No model loaded. Call load_model() first.")

        self.stop_generation = False
        filtered_kwargs = self._filter_parameters(kwargs)

        if self.provider == "openai":
            messages = self._format_messages_openai(user_prompt, system_prompt)

            if stream:
                return await self._stream_openai_async(messages, **filtered_kwargs)
            else:
                return await self._complete_openai_async(messages, **filtered_kwargs)

        elif self.provider == "mistral":
            # Convert messages to Mistral format
            mistral_messages = self._format_messages_mistral(user_prompt, system_prompt)

            if stream:
                return await self._stream_mistral_async(
                    mistral_messages, **filtered_kwargs
                )
            else:
                return await self._complete_mistral_async(
                    mistral_messages, **filtered_kwargs
                )

        else:
            raise ValueError(f"Unsupported provider: {self.provider}")

    def _complete_openai(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response using OpenAI's API.

        Args:
            messages (List[Dict]): List of formatted message dictionaries
            **kwargs: Additional parameters for the API call

        Returns:
            str: The generated response text
        """
        response = self.client.chat.completions.create(
            model=self.model_name, messages=messages, **kwargs
        )
        return response.choices[0].message.content

    async def _complete_openai_async(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response using OpenAI's API asynchronously.

        Args:
            messages (List[Dict]): List of formatted message dictionaries
            **kwargs: Additional parameters for the API call

        Returns:
            str: The generated response text
        """
        response = await self.async_client.chat.completions.create(
            model=self.model_name, messages=messages, **kwargs
        )
        return response.choices[0].message.content

    def _stream_openai(
        self, messages: List[Dict], **kwargs
    ) -> Generator[str, None, None]:
        """Stream a response using OpenAI's API.

        Args:
            messages (List[Dict]): List of formatted message dictionaries
            **kwargs: Additional parameters for the API call

        Yields:
            str: Chunks of the generated response text

        Note:
            The generation can be stopped by setting stop_generation to True
        """
        response = self.client.chat.completions.create(
            model=self.model_name, messages=messages, stream=True, **kwargs
        )

        for chunk in response:
            if self.stop_generation:
                response.close()
                break

            if chunk.choices[0].delta.content:
                yield chunk.choices[0].delta.content

    async def _stream_openai_async(
        self, messages: List[Dict], **kwargs
    ) -> AsyncGenerator[str, None]:
        """Stream a response using OpenAI's API asynchronously.

        Args:
            messages (List[Dict]): List of formatted message dictionaries
            **kwargs: Additional parameters for the API call

        Yields:
            str: Chunks of the generated response text

        Note:
            The generation can be stopped by setting stop_generation to True
        """
        response = await self.async_client.chat.completions.create(
            model=self.model_name, messages=messages, stream=True, **kwargs
        )

        async for chunk in response:
            if self.stop_generation:
                await response.aclose()
                break

            if chunk.choices[0].delta.content:
                yield chunk.choices[0].delta.content

    def _complete_mistral(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response using Mistral's API.

        Args:
            messages (List[Dict]): List of formatted message dictionaries
            **kwargs: Additional parameters for the API call

        Returns:
            str: The generated response text
        """
        response = self.client.chat.complete(
            model=self.model_name, messages=messages, **kwargs
        )
        return response.choices[0].message.content

    async def _complete_mistral_async(self, messages: List[Dict], **kwargs) -> str:
        """Generate a complete response using Mistral's API asynchronously.

        Args:
            messages (List[Dict]): List of formatted message dictionaries
            **kwargs: Additional parameters for the API call

        Returns:
            str: The generated response text
        """
        response = await self.client.chat.complete_async(  # Updated method name
            model=self.model_name, messages=messages, **kwargs
        )
        return response.choices[0].message.content

    def _stream_mistral(
        self, messages: List[Dict], **kwargs
    ) -> Generator[str, None, None]:
        """Stream a response using Mistral's API.

        Args:
            messages (List[Dict]): List of formatted message dictionaries
            **kwargs: Additional parameters for the API call

        Yields:
            str: Chunks of the generated response text

        Note:
            The generation can be stopped by setting stop_generation to True
        """
        response = self.client.chat.stream(
            model=self.model_name, messages=messages, **kwargs
        )

        for chunk in response:
            if self.stop_generation:
                break
            if chunk.data.choices[0].delta.content:
                yield chunk.data.choices[0].delta.content

    async def _stream_mistral_async(
        self, messages: List[Dict], **kwargs
    ) -> AsyncGenerator[str, None]:
        """Stream a response using Mistral's API asynchronously.

        Args:
            messages (List[Dict]): List of formatted message dictionaries
            **kwargs: Additional parameters for the API call

        Yields:
            str: Chunks of the generated response text

        Note:
            The generation can be stopped by setting stop_generation to True
        """
        async for chunk in self.client.chat.stream_async(  # Updated method name
            model=self.model_name, messages=messages, **kwargs
        ):
            if self.stop_generation:
                break
            if chunk.data.choices[0].delta.content:
                yield chunk.data.choices[0].delta.content
