# Phoenix — Integration Designs

How Phoenix connects **outward** to other systems: the NAI app/backend ecosystem,
external tooling, and standard protocols. Companion to
[`../scenario/`](../scenario/README.md) (which covers the internal re-platform).

Boundary: **scenario/** = how Phoenix is built; **integration/** = what Phoenix
talks to.

## The integration surface

```
                          ┌───────────────────────────┐
                          │          PHOENIX          │
                          │  local API gateway        │
                          │  /v1/chat/completions     │
                          │  /v1/messages  /v1/models │
                          └───┬─────────┬─────────┬────┘
            inbound clients   │         │         │   outbound calls
        ┌─────────────────────┘         │         └─────────────────────┐
        ▼                               ▼                               ▼
  ┌──────────────┐            ┌──────────────────┐           ┌──────────────────┐
  │ Tooling      │            │ NAI ecosystem    │           │ Protocols /      │
  │ Claude Code  │            │ Django backends  │           │ standards        │
  │ OpenAI SDKs  │            │ (health, keytype,│           │ OpenAI API       │
  │ LangChain    │            │  vesper, nai-    │           │ Anthropic API    │
  │ Ollama-style │            │  integrations)   │           │ MCP, HuggingFace │
  └──────────────┘            │ nai_edge_ai      │           └──────────────────┘
                              └──────────────────┘
```

## Sequence

```
  1. Convert ALL of Phoenix to Flutter, strip Qt/QML/C++ UI   → ready to push
  2. Full-stack process  (to be defined later)
  3. ► Fetch + wire nai_edge_ai   ◄  ACTIVE
  4. Then the remaining integration targets below
```

## Integration targets

| Doc | Target | Direction | Status |
|---|---|---|---|
| [`nai-edge-ai.md`](nai-edge-ai.md) | `nai_edge_ai` Flutter package (flutter_gemma) | shared code | **ACTIVE** |
| `nai-backends.md` | Django backends (health, keytype, vesper, nai-integrations) | outbound | TODO |
| `openai-compat.md` | OpenAI API consumers (SDKs, LangChain, Ollama tools) | inbound | TODO |
| `anthropic-compat.md` | Claude Code & Anthropic-SDK tools → GGUF | inbound | TODO |
| `mcp.md` | Model Context Protocol (tools/resources) | both | TODO |
| `huggingface.md` | HuggingFace model catalog + downloads | outbound | TODO |

## Principle

Phoenix exposes **standard wire formats** (OpenAI + Anthropic) so integrations need
**zero custom client code**. Internal NAI integrations reuse the shared Django auth
and the `/api/jobs/<id>` async contract from
[`../scenario/03-django-celery-hybrid.md`](../scenario/03-django-celery-hybrid.md).

> Fill in target docs as integrations are scoped. Each doc = one external system:
> its protocol, auth, data contract, and a worked example.
