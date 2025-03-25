import os
import sys
import time
from provider import Provider

if __name__ == "__main__":

    model = "mistral/mistral-small"
    api_key = ""
    stream = False
    user_prompt = "tell me about iran"
    system_prompt = "You are a helpful assistant."

    # if len(sys.argv) > 1:
    #     model = sys.argv[1]
    # if len(sys.argv) > 2:
    #     api_key = sys.argv[2]
    # if len(sys.argv) > 3:
    #     prompt = sys.argv[3]

    client = Provider()
    client.load_model(model=model, api_key=api_key)

    if stream:
        chat_response = client.prompt(user_prompt=user_prompt, system_prompt=system_prompt, stream=stream)

        for chunk in chat_response:
            sys.stdout.write(chunk, end="", flush=True)
    else:
        chat_response = client.prompt(user_prompt=user_prompt, system_prompt=system_prompt, stream=stream)
        sys.stdout.write(chat_response)
