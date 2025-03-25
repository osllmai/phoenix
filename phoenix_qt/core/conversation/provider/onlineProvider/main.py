# Define the headers and payload for the API request
import os
from test import MockProvider
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

    client = MockProvider()
    client.load_model("openai/gpt-3.5-turbo")

    chat_response = client.prompt(
        user_prompt="Hello, how are you?", system_prompt="You are a helpful assistant."
    )
    if stream:
        for chunk in chat_response:
            # sys.stdout.write(chunk, end="", flush=True)
            print(chunk, end="", flush=True)
    else:
        # sys.stdout.write(chat_response)
        print("Regular response:", chat_response)
