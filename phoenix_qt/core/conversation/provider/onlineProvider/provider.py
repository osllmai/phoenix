# Define the headers and payload for the API request
import os
from mistralai import Mistral
import sys
import time


if __name__ == "__main__":

    model = ""
    api_key = ""
    prompt = ""

    if len(sys.argv) > 1:
        model = sys.argv[1]
    if len(sys.argv) > 2:
        api_key = sys.argv[2]
    if len(sys.argv) > 3:
        prompt = sys.argv[3]


    client = Mistral(api_key=api_key)

    chat_response = client.chat.complete(
        model = model,
        messages = [
            {
                "role": "user",
                "content": prompt,
            },
        ]
    )

    sys.stdout.write(chat_response.choices[0].message.content)
