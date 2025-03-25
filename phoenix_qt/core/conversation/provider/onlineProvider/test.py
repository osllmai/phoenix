import json
import os
import time
import asyncio
from typing import Dict, List, Optional, Union, Generator, Any, AsyncGenerator
from unittest.mock import MagicMock

# Import the Provider class
from provider import Provider


class MockProvider(Provider):
    """A simplified mock version of the Provider class for UI testing"""

    def __init__(self):
        super().__init__()
        # No need to load the actual config
        self.providers_config = {
            "openai": {"supported_models": ["gpt-3.5-turbo", "gpt-4"]},
            "mistral": {"supported_models": ["mistral-tiny", "mistral-medium"]},
        }
        self.provider = None
        self.model_name = None
        self.api_key = None
        self.client = None
        self.async_client = None
        self.stop_generation = False

    def load_model(self, model: str, api_key: str = "mock-api-key"):
        """Simplified load_model that just sets the provider and model name"""
        self.provider, self.model_name = model.split("/")
        self.api_key = api_key
        return self

    def prompt(
        self,
        user_prompt: str,
        system_prompt: str = "",
        stream: bool = False,
        **kwargs,
    ) -> Union[str, Generator[str, None, None]]:
        """
        Simplified prompt method that returns either a string or a generator
        based on the stream parameter
        """
        if stream:
            return self._mock_stream(user_prompt, system_prompt, **kwargs)
        else:
            return self._mock_response(user_prompt, system_prompt, **kwargs)

    async def prompt_async(
        self,
        user_prompt: str,
        system_prompt: str = "",
        stream: bool = False,
        **kwargs,
    ) -> Union[str, AsyncGenerator[str, None]]:
        """Simplified async prompt method"""
        if stream:
            return self._mock_stream_async(user_prompt, system_prompt, **kwargs)
        else:
            await asyncio.sleep(0.1)  # Small delay to simulate async
            return self._mock_response(user_prompt, system_prompt, **kwargs)

    def stop(self):
        """Stop the generation process"""
        self.stop_generation = True

    def _mock_response(
        self, user_prompt: str, system_prompt: str = "", **kwargs
    ) -> str:
        """Generate a mock response based on the prompt and model"""
        model_info = f"{self.provider}/{self.model_name}"
        return f"Mock response from {model_info} for prompt: '{user_prompt}'"

    def _mock_stream(
        self, user_prompt: str, system_prompt: str = "", **kwargs
    ) -> Generator[str, None, None]:
        """Generate a mock streaming response"""
        model_info = f"{self.provider}/{self.model_name}"
        response = (
            f"Mock streaming response from {model_info} for prompt: '{user_prompt}'"
        )

        # Split the response into words for streaming
        words = response.split()

        for word in words:
            if self.stop_generation:
                break
            yield word + " "
            time.sleep(0.05)  # Small delay between words

    async def _mock_stream_async(
        self, user_prompt: str, system_prompt: str = "", **kwargs
    ) -> AsyncGenerator[str, None]:
        """Generate a mock async streaming response"""
        model_info = f"{self.provider}/{self.model_name}"
        response = f"Mock async streaming response from {model_info} for prompt: '{user_prompt}'"

        # Split the response into words for streaming
        words = response.split()

        for word in words:
            if self.stop_generation:
                break
            yield word + " "
            await asyncio.sleep(0.05)  # Small delay between words


# # Simple example of how to use the MockProvider
# def main():
#     provider = MockProvider()

#     # Test loading a model
#     provider.load_model("openai/gpt-3.5-turbo")

#     # Test regular prompt
#     response = provider.prompt(
#         user_prompt="Hello, how are you?", system_prompt="You are a helpful assistant."
#     )
#     print("Regular response:", response)

#     # Test streaming prompt
#     print("\nStreaming response: ", end="")
#     stream = provider.prompt(user_prompt="Tell me a joke", stream=True)

#     for chunk in stream:
#         print(chunk, end="", flush=True)

#     print("\n\nDone!")


# if __name__ == "__main__":
#     main()
