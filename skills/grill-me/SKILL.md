---
name: grill-me
description: Interview the user in rounds until a plan, design or idea has no open decisions. Use for "grill me", "grill this", "stress test my plan", or before a small feature when scope, inputs or edge cases are not clear.
metadata:
  track: engineering
  tier: 2
  tagline: Ask until nothing is assumed.
---

# Grill me

Interview the user until you both agree on the same plan. Do not write code during the interview.

## 1. State the intent

Write the goal in one short paragraph. Use the user's words, the code and any linked issue. If you cannot write it, ask for it first.

## 2. Map the decision tree

Each decision opens the decisions that depend on it. The **frontier** is every open decision whose prerequisites are settled. You can ask these now without a guess about an earlier answer.

## 3. Ask one round

Ask the full frontier in one round. Number each question. Give your recommended answer. Write each question so that "yes" accepts your recommendation.

```
**Q1. <title>**: <question, with the choices if there are some>
Recommended: <your answer>

**Q2. <title>**: <question>
Recommended: <your answer>
```

Do not put a question in this round if its answer depends on another question in this round. Ask it in a later round.

## 4. Find facts yourself

Facts are your job. Decisions are the user's job.

- If a question needs a fact from the code, files or tools, look it up. Do not ask the user.
- Use a sub-agent for a slow lookup. Ask the questions that do not depend on it now.

## 5. Repeat

After each round, mark the settled decisions. Find the new frontier. Ask the next round.

## 6. Stop

Stop when the frontier is empty: you visited every branch and assumed nothing silently.

Then write a short summary:

- The goal.
- Each decision and its answer.
- What is out of scope.

Do not start work until the user confirms the summary.
