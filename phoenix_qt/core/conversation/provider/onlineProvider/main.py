# Define the headers and payload for the API request
import os
from test import MockProvider

# from provider import Provider
import sys
import time


if __name__ == "__main__":

    model = ""
    api_key = ""
    prompt = ""
    stream = True
    user_prompt = ""
    system_prompt = ""

    # if len(sys.argv) > 1:
    #     model = sys.argv[1]
    # if len(sys.argv) > 2:
    #     api_key = sys.argv[2]
    # if len(sys.argv) > 3:
    #     prompt = sys.argv[3]

    ## For Test
    client = MockProvider()
    client.load_model("openai/gpt-3.5-turbo")

    if stream:
        print("\nStreaming response: ", end="")
        chat_response = client.prompt(user_prompt="Tell me a joke", stream=True)

        for chunk in chat_response:
            print(chunk, end="", flush=True)
    else:
        # Test regular prompt
        response = client.prompt(
            user_prompt="Hello, how are you?",
            system_prompt="You are a helpful assistant.",
        )
        print("Regular response:", response)

    ## If not Test , Comment Test part, Comment import mock and uncommect import provider
    # client = Provider()
    # client.load_model(model=model, api_key=api_key)

    # if stream:
    #     chat_response = client.prompt(user_prompt=user_prompt, system_prompt=system_prompt, stream=stream)

    #     for chunk in chat_response:
    #         sys.stdout.write(chunk, end="", flush=True)
    # else:
    #     chat_response = client.prompt(user_prompt=user_prompt, system_prompt=system_prompt, stream=stream)
    #     sys.stdout.write(chat_response)
