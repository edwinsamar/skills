---
name: spec
description: Write a short spec before code for a big or unclear feature, a new module, or a change across many files. Use when requirements are vague, when "spec", "design this" or "write it up first" is asked, or before the plan skill.
---

# Spec

Write what we build and how we know it works, before any code. The user approves the spec before you start.

## 1. Ground the problem

- Read the code that the change touches. Know how it works now, not only the file names.
- If the design changes who owns what, find out why the current shape exists. That reason is a constraint.
- Skip this step only for new work that has no system around it.

## 2. Write your assumptions

Write every assumption before the spec. Do not fill a gap silently.

```
ASSUMPTIONS:
1. <assumption>
2. <assumption>
Correct me now, or I continue with these.
```

If many decisions are open, use the `grill-me` skill first.

## 3. Turn wishes into success criteria

Change each vague requirement into a condition that you can check.

```
REQUIREMENT: "Make the dashboard faster"
SUCCESS CRITERIA:
- First load is less than 2.5 s.
- No layout shift during load.
```

## 4. Design it twice

Sketch at least two different shapes for the solution. A different shape is a different structure, not a small change to one shape. For each shape, write the main types, signatures and module boundaries. Use stub bodies.

Compare the shapes:

- Which hides more complexity behind a smaller public surface?
- Which is correct when a person or agent changes one file and sees only that file?
- Which is smaller?

Pick one. Write why in two or three sentences.

## 5. Write the spec

Keep it to one page if you can.

```markdown
# Spec: <name>

## Goal
<What and why. Who uses it.>

## Success criteria
<Conditions you can check.>

## Design
<Chosen shape: types, signatures, modules. Why this shape, and the shape you rejected.>

## Commands
<Build, test, lint and run commands, with flags.>

## Boundaries
- Always: <...>
- Ask first: <schema changes, new dependencies, CI changes, ...>
- Never: <commit secrets, delete failing tests, ...>

## Out of scope
<...>

## Open questions
<...>
```

## 6. Get approval

Show the spec to the user. Do not write production code until the user approves it. Then use the `plan` skill.

## Keep the spec current

- If a decision changes during the work, update the spec first. Then change the code.
- If the work gives the same type of workaround again and again, the design is wrong. Stop. Update the spec from step 4. Make the new design smaller than the old one.
