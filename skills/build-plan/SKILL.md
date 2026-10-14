---
name: build-plan
description: Break approved work into small phases, each with a check, and build them one at a time. Use after a spec, for any change across more than a few files, or when a task is too big to do in one step.
---

# Build plan

Break the work into small units. Each unit ends in a state that you can check. Do not start the next unit until the current one passes.

## 1. Read before you plan

Do not write code in this step.

- Read the spec and the code that the work touches.
- Find the patterns the code uses now. Reuse them.
- Find what depends on what.
- Write down the risks and the unknowns.

## 2. Slice vertically

Each task gives one complete path that works: data, logic and interface together. Do not build all of one layer first.

```
Bad:  1 all tables, 2 all endpoints, 3 all screens
Good: 1 user can sign up, 2 user can log in, 3 user can add a task
```

Put the tasks with the most risk early, so they fail fast.

## 3. Write each task

```markdown
### Task N: <title>
- Done when: <one to three conditions you can check>
- Check: <exact command or manual step>
- Depends on: <task numbers, or none>
- Files: <likely files>
```

Split a task if one of these is true:

- It touches more than about 5 files.
- It needs more than three "done when" conditions.
- It touches two independent subsystems.

## 4. Add checkpoints

Put a checkpoint after each phase of 2 or 3 tasks:

- All tests pass and the build is clean.
- The main user path works end to end.
- For big work, show the result to the user before the next phase.

Show the full plan to the user before you start.

## 5. Build one unit at a time

For each task:

1. Start from a state that passes.
2. Make one logical change.
3. Run its check. Read the real output.
4. Commit it alone, with a message that says what and why.
5. Go to the next task.

Rules while you build:

- **Simplest thing first.** Three similar lines are better than an abstraction you use once.
- **Touch only the task.** If you see other problems, list them under "Noticed, not changed". Do not fix them.
- **Keep it working.** After each unit, the project builds and all old tests pass.
- **Easy to revert.** You can revert each commit alone. Each migration has a way back.
- **Order commits as proof.** When you can, commit the test that fails first, then the fix.

## 6. When a check fails

Stop. Find the cause in the unit you just changed. Do not build further on a broken state. If the plan was wrong, update it and tell the user.
