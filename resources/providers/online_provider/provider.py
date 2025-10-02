from typing import Dict, List, Optional, Union, Generator, Any, AsyncGenerator
import asyncio

from indoxrouter_provider import IndoxRouterProvider


class Provider:
    """A unified interface for interacting with various language model providers through IndoxRouter.

    This class provides a consistent interface for working with different language model
    providers through IndoxRouter gateway. It handles model loading, message formatting,
    streaming responses, and BYOK (Bring Your Own Key) support.

    Attributes:
        provider (str): The name of the current provider (e.g., "openai", "mistral")
        model_name (str): The name of the loaded model
        api_key (str): The IndoxRouter API key
        byok_api_key (str): Optional BYOK API key for direct provider access
        provider_instance: The IndoxRouter provider instance
        stop_generation (bool): Flag to control stopping of generation
        providers_config (dict): Configuration settings for supported providers
    """

    def __init__(self, byok_api_key: Optional[str] = None):
        """Initialize a new Provider instance with default values.

        Args:
            byok_api_key (str, optional): Your own API key for direct provider access
        """
        self.provider = None
        self.model_name = None
        self.api_key = None
        self.byok_api_key = byok_api_key
        self.provider_instance = None
        self.stop_generation = False
        self._load_providers_config()

    def _load_providers_config(self):
        """Initialize provider configuration.

        With IndoxRouter, we don't need local JSON configuration files.
        IndoxRouter handles all provider and model validation.
        """
        self.companies_config = []

    def load_model(self, model: str, api_key: str):
        """Initialize IndoxRouter client with the specified model.

        Args:
            model (str): Provider and model in the format "provider/model_name"
                        (e.g., "openai/gpt-4", "anthropic/claude-3-sonnet")
            api_key (str): IndoxRouter API key

        Returns:
            Provider: The current Provider instance for method chaining

        Raises:
            ValueError: If the model format is invalid
        """
        if "/" not in model:
            raise ValueError(
                "Model must be in format 'provider/model_name' (e.g., 'openai/gpt-4')"
            )

        self.provider, self.model_name = model.split("/", 1)
        self.api_key = api_key

        # Create IndoxRouter provider instance
        self.provider_instance = IndoxRouterProvider(
            api_key=self.api_key,
            model_name=model,
            byok_api_key=self.byok_api_key,
        )

        return self

    # def validate_model(self, model: str, api_key: str) -> bool:
    #     """Validate if a model is available through IndoxRouter.

    #     Args:
    #         model (str): Provider and model in the format "provider/model_name"
    #         api_key (str): IndoxRouter API key

    #     Returns:
    #         bool: True if model is valid and available

    #     Raises:
    #         ValueError: If model format is invalid
    #     """
    #     if "/" not in model:
    #         raise ValueError(
    #             "Model must be in format 'provider/model_name' (e.g., 'openai/gpt-4')"
    #         )

    #     provider, model_name = model.split("/", 1)

    #     try:
    #         from indoxrouter import Client

    #         client = Client(api_key=api_key)
    #         model_info = client.get_model_info(provider=provider, model=model_name)
    #         return model_info is not None
    #     except Exception as e:
    #         print(f"Model validation failed: {str(e)}")
    #         return False

    def set_byok_api_key(self, byok_api_key: str):
        """Set the BYOK API key for direct provider access.

        Args:
            byok_api_key (str): Your own API key for the provider
        """
        self.byok_api_key = byok_api_key
        if self.provider_instance:
            self.provider_instance.byok_api_key = byok_api_key

    def stop(self):
        """Stop the ongoing generation process."""
        self.stop_generation = True
        if self.provider_instance:
            self.provider_instance.stop()

    def _filter_parameters(self, kwargs: Dict) -> Dict:
        """Filter kwargs to only include supported parameters.

        Args:
            kwargs (Dict): Dictionary of parameter names and values

        Returns:
            Dict: Filtered dictionary containing only supported parameters
        """
        # With IndoxRouter, we let the gateway handle parameter filtering
        # Just pass through common LLM parameters
        common_params = {
            "temperature",
            "max_tokens",
            "top_p",
            "top_k",
            "frequency_penalty",
            "presence_penalty",
            "stop",
            "stream",
            "min_p",
            "repeat_penalty",
        }

        # Filter to common parameters to avoid passing unsupported ones
        return {k: v for k, v in kwargs.items() if k in common_params}

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
