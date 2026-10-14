---
name: full-review
description: Doubt-driven review of a change before it ships to production, touches security, or does something you cannot undo. Finds what the change breaks outside the diff and proves the key facts by running code. Use for "full review", "blast radius", "what could this break", "tear this apart", or before a merge or deploy.
---

# Full review

Assume the change is wrong until you prove it is safe. A review that sounds correct has no value until you check it.

## 1. State the intent

Write in one paragraph what the change must do. Use the request, the commits, the PR text and the code. If the intent is not clear, ask before you review.

## 2. Read the tests first

- Do tests exist for the change?
- Do they check behavior, with exact results?
- Do they still pass if the new code returns nothing? If yes, they prove nothing.

## 3. Review on five axes

| Axis | Questions |
|---|---|
| Correctness | Does it match the intent? Empty, null and limit values? Error paths? Race conditions? |
| Simplicity | Can it be shorter? Does each abstraction earn its cost? Dead code, shims or "removed" comments? |
| Architecture | Does it follow existing patterns? Clean boundaries? One owner for each piece of state? |
| Security | Untrusted input, secrets, permissions. Use the `security-hardening` skill if the change touches them. |
| Performance | N+1 queries, unbounded loops or fetches, no pagination, heavy work in hot paths? |

## 4. Look past the diff

A list of callers is not the job. Find the breakage that a search does not show:

- Data shapes that leave the code: API responses, database columns, file and wire formats, other languages that read the same data.
- When code runs: startup, teardown, retries, concurrency, caches.
- Feature flags, config and code two or three steps downstream.
- The library source and its pinned version, not your memory of it.

## 5. Find and prove the key fact

Most risky changes are safe because of one or two facts. Find them. For each fact, say how far you proved it:

1. You said so. This has no value alone.
2. You cited the line (`file:line`).
3. You followed the failure path and showed that it cannot happen.
4. You ran a script or test that calls the real code and fails loudly if you are wrong.
5. You reproduced it in the live app.

Get each key fact to level 4 if it is cheap. Paste the output.

## 6. Get a second view

For a large or high-risk change, ask a separate reviewer: a sub-agent, or a different model if you have one. Give it the intent, the diff and this skill. Issues that two reviewers find on their own are the strongest signal.

## 7. Sort the findings

- **Critical:** blocks the merge. Bug, data loss, security hole.
- **Required:** fix before the merge.
- **Consider:** real, but the fix can cost more than it gives now.
- **Dismissed:** wrong or not relevant, with one line why.

Be direct. Do not call a production bug "a small concern". Do not approve without evidence.

## 8. Before an irreversible step

Before a deploy, migration, delete, force push or public post:

- Know the way back, or say that there is none.
- Get the user's approval for that exact step.

## Report

```
Intent: <one paragraph>
Key fact: <fact>, proved to level <n>: <proof or "unproven">
Critical / Required / Consider: <finding, file:line, why, fix>
Checked and safe: <list>
Before merge: <cheapest test that catches the real risk>
```
