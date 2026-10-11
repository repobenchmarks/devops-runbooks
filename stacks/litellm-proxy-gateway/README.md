# LiteLLM Proxy in Docker Production Stack

Production-ready OpenAI-compatible API gateway orchestrating local LLM backends (vLLM, Ollama) and cloud fallbacks with automated load balancing, Redis caching, and budget tracking.

Accompanies the technical architecture runbook on [RepoBenchmarks.com](https://www.repobenchmarks.com).

## Quick Start
1. Copy `.env.example` to `.env` and set your secure passwords and API keys.
2. Start the gateway:
   ```bash
   docker compose up -d
   ```
3. Test the liveliness endpoint:
   ```bash
   curl http://localhost:4000/health/liveliness
   ```
