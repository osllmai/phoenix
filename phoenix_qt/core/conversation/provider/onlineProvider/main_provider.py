import os
import sys
import time
from provider import Provider

if __name__ == "__main__":

    sys.stdout.reconfigure(encoding='utf-8')

    model = sys.argv[1]
    api_key = sys.argv[2]
    user_prompt = sys.argv[3]
    stream = bool(int(sys.argv[4]))
    prompt_template = sys.argv[5]
    system_prompt = sys.argv[6]
    temperature = float(sys.argv[7])
    top_k = int(sys.argv[8])
    top_p = float(sys.argv[9])
    min_p = float(sys.argv[10])
    repeat_penalty = float(sys.argv[11])
    prompt_batch_size = int(sys.argv[12])
    max_tokens = int(sys.argv[13])
    repeat_penalty_tokens = int(sys.argv[14])
    context_length = int(sys.argv[15])
    number_of_gpu_layers = int(sys.argv[16])
    stop = False

    client = Provider()
    client.load_model(model=model, api_key=api_key)

    number = 0

    if stream:
        chat_response = client.prompt(user_prompt=user_prompt, system_prompt=system_prompt, stream=stream)

        for chunk in chat_response:
            if number < 20:
                sys.stdout.write(chunk)
                sys.stdout.flush()
            if number == 20:
                sys.stdout.write(chunk)
            number += 1
            # stop = ?
            # if stop == False:
            #     sys.stdout.write(chunk)
            #     sys.stdout.flush()
            # else


    else:
        chat_response = client.prompt(user_prompt=user_prompt, system_prompt=system_prompt, stream=stream)
        sys.stdout.write(chat_response)
