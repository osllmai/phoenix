import json
import os
import sys
from typing import Dict, List, Optional, Union, Generator, Any, AsyncGenerator
import asyncio

from openai_provider import OpenAIProvider
from mistral_provider import MistralProvider
from deepseek_provider import DeepseekProvider


class Provider:
    """A unified interface for interacting with various language model providers.

    This class provides a consistent interface for working with different language model
    providers (e.g., OpenAI, Mistral). It handles model loading, message formatting,
    and both synchronous and asynchronous generation of responses.

    Attributes:
        provider (str): The name of the current provider (e.g., "openai", "mistral")
        model_name (str): The name of the loaded model
        api_key (str): The API key for the current provider
        provider_instance: The specific provider instance (OpenAI or Mistral)
        stop_generation (bool): Flag to control stopping of generation
        providers_config (dict): Configuration settings for supported providers
    """

    def __init__(self):
        """Initialize a new Provider instance with default values."""
        self.provider = None
        self.model_name = None
        self.api_key = None
        self.provider_instance = None
        self.stop_generation = False
        self._load_providers_config()

    def get_runtime_path(self, filename):
        """
        Returns the correct absolute path for a given file based on execution context.

        :param filename: Name of the file (e.g., "company.json")
        :return: Absolute path to the file
        """
        if getattr(sys, "frozen", False):  # If running as a PyInstaller executable
            base_path = (
                sys._MEIPASS
            )  # Temporary folder where PyInstaller extracts files
        else:  # If running as a normal Python script
            base_path = os.path.dirname(os.path.abspath(__file__))

        return os.path.join(base_path, filename)

    def _load_providers_config(self):
        """Load provider configurations from the company.json file.

        The configuration file contains information about supported models and
        parameters for each provider.

        Raises:
            FileNotFoundError: If company.json is not found
            json.JSONDecodeError: If company.json is not valid JSON
        """
        config_path = self.get_runtime_path("company.json")

        with open(config_path, "r") as f:
            self.companies_config = json.load(f)

    def _validate_model(self, provider, model_name):
        """Validate that the requested model is supported by the provider.

        Args:
            provider (str): The name of the provider to validate
            model_name (str): The name of the model to validate

        Raises:
            ValueError: If the provider is not supported or the model is not
                supported by the provider
        """
        # Find the provider in the companies list
        provider_config = next(
            (comp for comp in self.companies_config if comp["name"] == provider), None
        )

        if not provider_config:
            raise ValueError(f"Unsupported provider: {provider}")

        # Only validate for online models
        if provider_config["type"] != "OnlineModel":
            raise ValueError(f"Provider {provider} is not an online model provider")

        # Load the models file for this provider
        models_file_path = self.get_runtime_path(provider_config["file"])

        try:
            with open(models_file_path, "r") as f:
                models_data = json.load(f)

            # Check if the model exists in the models list
            supported_models = [
                model["modelName"] for model in models_data if model.get("modelName")
            ]
            if model_name not in supported_models:
                raise ValueError(f"Model {model_name} is not supported by {provider}")

        except FileNotFoundError:
            raise ValueError(f"Models file not found for provider: {provider}")
        except json.JSONDecodeError:
            raise ValueError(f"Invalid models file for provider: {provider}")

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

        if self.provider == "Openai":
            self.provider_instance = OpenAIProvider(
                api_key=self.api_key, model_name=self.model_name
            )
        elif self.provider == "Mistral":
            self.provider_instance = MistralProvider(
                api_key=self.api_key, model_name=self.model_name
            )
        elif self.provider == "Deepseek":
            self.provider_instance = DeepseekProvider(
                api_key=self.api_key, model_name=self.model_name
            )
        else:
            raise ValueError(f"Unsupported provider: {self.provider}")

        return self

    def stop(self):
        """Stop the ongoing generation process."""
        self.stop_generation = True
        if self.provider_instance:
            self.provider_instance.stop()

    def _filter_parameters(self, kwargs: Dict) -> Dict:
        """Filter kwargs to only include supported parameters for the current provider.

        Args:
            kwargs (Dict): Dictionary of parameter names and values

        Returns:
            Dict: Filtered dictionary containing only supported parameters
        """
        # Find the provider in the companies list
        provider_config = next(
            (comp for comp in self.companies_config if comp["name"] == self.provider),
            None,
        )

        if provider_config and "supported_parameters" in provider_config:
            supported_params = provider_config["supported_parameters"].keys()
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
        if not self.provider_instance:
            raise ValueError("No model loaded. Call load_model() first.")

        self.stop_generation = False
        filtered_kwargs = self._filter_parameters(kwargs)

        # Format messages using the provider-specific formatter
        messages = self.provider_instance.format_messages(user_prompt, system_prompt)

        if stream:
            return self.provider_instance.stream(messages, **filtered_kwargs)
        else:
            return self.provider_instance.complete(messages, **filtered_kwargs)

    async def prompt_async(
        self,
        user_prompt: str,
        system_prompt: str = "",
        stream: bool = False,
        **kwargs,
    ) -> Union[str, AsyncGenerator[str, None]]:
        """Generate a response using the selected model asynchronously.

        This method handles both streaming and non-streaming generation modes.

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
        if not self.provider_instance:
            raise ValueError("No model loaded. Call load_model() first.")

        self.stop_generation = False
        filtered_kwargs = self._filter_parameters(kwargs)

        # Format messages using the provider-specific formatter
        messages = self.provider_instance.format_messages(user_prompt, system_prompt)

        if stream:
            return self.provider_instance.stream_async(messages, **filtered_kwargs)
        else:
            return await self.provider_instance.complete_async(
                messages, **filtered_kwargs
            )
