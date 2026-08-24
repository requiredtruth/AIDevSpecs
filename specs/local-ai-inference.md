# Local AI Inference and Training

## Operating priority

- CPU-only operation is a supported target, not an afterthought.
- Prefer small quantized models and GGUF-compatible local runtimes for constrained machines.
- External model services must be optional when local inference is feasible.
- OpenAI-compatible local endpoints are preferred for interoperability.
- Model files live in a documented reusable model directory rather than being redownloaded per run.

## Runtime controls

Expose and record:

- model path and model-file digest;
- context size;
- thread count and batch size;
- memory/RAM cap and observed peak use;
- prompt tokens, generated tokens, time to first token, and generation tokens/second;
- stop reason and error category;
- runtime and build version.

Do not report a throughput number without a measured run. Separate prompt processing speed from generation speed.

## Model selection and import

- Allow explicit model selection from discovered compatible files.
- Validate file existence, readable metadata, supported architecture, and license/provenance before use or publication.
- A failed model load must not corrupt the saved model bank or active configuration.
- Switching models stops or drains active inference safely and records the new selection.

## Generation UI

- Show queued/running/completed/failed/cancelled state.
- Stream model output in a dedicated view with token counts, speed, and status.
- Start, stop, resume, and cancel must be wired to actual backend state.
- Rejected or invalid structured output never reaches durable product storage.
- When small-model JSON fails validation, return exact bounded feedback and allow a limited repair attempt.

## Training

- Training resumes from explicit checkpoints; bootstrap never silently starts over.
- Record loss, learning rate, step, elapsed time, samples/tokens processed, throughput, memory, and checkpoint identity.
- Keep evaluation data separated and report measured validation behavior.
- Background/infinite training still requires stop, status, checkpoint, and recovery commands.
