import os
import sys
import time
import msvcrt  #  Windows-only library
from provider import Provider


def str_to_bool(value):
    """Convert string to boolean."""
    return value.lower() in ["true", "1"]


def stdin_has_data():
    """Check if there is input in stdin on Windows."""
    return msvcrt.kbhit()  #  Works only on Windows


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")

    # Read arguments from C++ process
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

    if stream:
        try:
            chat_response = client.prompt(
                user_prompt=user_prompt,
                system_prompt=system_prompt,
                stream=stream,
                temperature=temperature,
                top_p=top_p,
                max_tokens=max_tokens,
            )

            for chunk in chat_response:
                # Check for stop signal
                if stdin_has_data():
                    stop_str = sys.stdin.read(1).strip()  #  Read only one character
                    if stop_str in ["true", "false"]:
                        stop = str_to_bool(stop_str)
                        print(f"Python received stop flag: {stop}", file=sys.stderr)

                if stop:
                    client.stop()
                    sys.stdout.flush()
                    break

                if client.stop_generation:
                    sys.stdout.flush()
                    break

                sys.stdout.write(chunk)
                sys.stdout.flush()
                time.sleep(0.1)  # Simulate streaming delay

        except Exception as e:
            print(f"Error: {str(e)}", file=sys.stderr)
        finally:
            client.stop_generation = False

    else:
        chat_response = client.prompt(
            user_prompt=user_prompt,
            system_prompt=system_prompt,
            stream=stream,
            temperature=temperature,
            top_p=top_p,
            max_tokens=max_tokens,
        )
        sys.stdout.write(chat_response)
        sys.stdout.flush()
