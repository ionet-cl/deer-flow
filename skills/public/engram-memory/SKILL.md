---
name: engram-memory
description: Persistent memory management using Engram. Load this skill BEFORE any deep research, technical investigation, or multi-step task to recall previous findings and avoid redundant web searches. Save distilled findings proactively to memory to minimize token bloat across agent turns.
---

# Engram Memory & Token-Efficient Research

## Overview

This skill provides persistent memory recall and extraction using Engram. It eliminates redundant token consumption by recalling previously investigated topics, decisions, and system findings before initiating fresh web searches or repetitive analysis.

## Core Directives for Autonomous Subagents

### 1. Memory Recall First (Before Searching)
- **Rule:** Before running `web_search`, `web_fetch`, or deep research on any concept, framework, tool, or system architecture, call `mem_search` with the target keywords.
- **Why:** If the topic was previously researched or decided, reuse the existing observation instead of fetching and reading multiple web pages. This saves thousands of tokens per research step.
- **Follow-up:** If `mem_search` returns relevant observation IDs, use `mem_get_observation` to retrieve the untruncated content.

### 2. Proactive Distillation & Save (After Discoveries)
- **Rule:** When an investigation produces a concrete finding, benchmark result, root-cause explanation, or architectural decision, call `mem_save` immediately.
- **Format:** Keep saved content dense, concise, and structured:
  - **What**: One sentence describing what was found or done.
  - **Why**: The technical motivation or problem driving it.
  - **Where**: Affected components, URLs, or files.
  - **Learned**: Gotchas, performance findings, or non-obvious details.
- **Token Impact:** Storing distilled facts allows subsequent agents and future sessions to load clean insights rather than re-ingesting raw web pages.

### 3. Session End Summarization
- Before completing a complex research or multi-step task, call `mem_session_summary` using the structured format (Goal, Instructions, Discoveries, Accomplished, Next Steps, Relevant Files).
- This guarantees full context persistence across threads without relying on ballooning conversation logs.
