---
name: tdd
description: Write a failing test first, then make it pass, for new logic or a bug fix. Use for "TDD", "failing test", "regression test", a small feature with clear behavior, or a bug with a cheap local test path.
---

# TDD

Make the wanted behavior a test that fails. Then write the code that makes it pass.

## The cycle

1. **Red.** Write one small test for one behavior. Run it. It must fail, and for the correct reason. A test that passes at once proves nothing.
2. **Green.** Write the minimum code to make the test pass. Run it again.
3. **Clean up.** Improve names and remove repetition. Do not change behavior. Run the tests after each step.
4. Repeat for the next behavior.

## Bug fixes

Do not start with the fix.

1. Find the wanted behavior, the current behavior and the smallest way to show the bug.
2. Pick the narrowest test that the code already uses for that path.
3. Write a test that fails because of the bug. Run it. Make sure it fails for the bug and not for a different reason.
4. Make the smallest fix.
5. Run the new test and then the full suite.

## Write tests that can fail

A test calls the code the way its users do, with one concrete input. It checks the exact result they see.

Rewrite or delete a test if it still passes when every function it calls returns nothing. These shapes usually fail that check:

- A loose check, for example "is defined", "is true", "does not throw" or "greater than 0".
- A check only that a function was called, or not called.
- An expected value that the code under test calculated.
- A test that only repeats a constant, a config default or a prompt string.

Also:

- Check state, not the internal calls. Use real code before mocks. If you use a mock, check the data it got.
- For an "absent" check, also check "present" for a different input.
- Use clear names: `<unit> <does what> when <condition>`.
- Prefer a clear test that repeats some setup over a short test that is hard to read.

## When a test costs too much

Do not force a bad test. A test can need a large new harness, fragile mocks, slow end-to-end setup or production state. Then use the nearest real check: a small script, a command, a browser check or a log check. No new test is better than a bad test.

## Rules

- Do not change a test to match wrong code.
- Do not weaken a check that exists unless the wanted behavior changed and you say why.
- For a flaky bug, make the test deterministic.

## Report

- The test that failed before, and its failure message.
- The test run that passes after.
- If you did not show a failure first, say why and name the check you used.
