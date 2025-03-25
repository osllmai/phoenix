Task: Build a Simple AI Agent
Your goal is to create a Python-based AI agent that interacts with a large language model (LLM) API (e.g., Hugging Face’s transformers or an external API like OpenAI) and performs the following:

Input Processing: The agent takes a user query (a string) and identifies whether it’s a “factual question” (e.g., “What is the capital of France?”) or a “creative task” (e.g., “Write a poem about rain”).
Custom Response Logic:
For factual questions, the agent should cross-check the LLM’s response by implementing a simple keyword-based validation (e.g., checking if key terms align with a small pre-defined knowledge base you create, like a dictionary or list).
For creative tasks, the agent should modify the LLM’s output by enforcing a specific rule, e.g., ensuring every sentence ends with a rhyme or a specific word like “blue.”
Output: The agent returns the processed response and explains its reasoning (e.g., “This was a factual question, validated with X” or “This was a creative task, modified to rhyme”).
Requirements:

Use Python and an LLM library/API of your choice.
Keep the code modular and well-commented.
Avoid directly passing the full task to an LLM to solve—focus on your own logic for classification and modification.
Submit your code and a short explanation (200-300 words) of your approach within [insert deadline, e.g., 3-5 days].
Notes: The task should take a few hours to complete. It’s not meant to be overly complex but should demonstrate your ability to work with LLMs creatively and critically.

Questions
Please respond to the following along with your task submission:

Availability: When could you start if hired?
Salary Expectations: What salary range are you looking for?
Technical Choice: Why did you choose the LLM library/API you used for this task?
Challenge: What was the trickiest part of this task, and how did you address it?
Improvement: If you had more time, what would you add or improve in your agent?
