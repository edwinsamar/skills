---
name: experiment-design
description: Design an ML experiment before you run it. Set the hypothesis, the baseline, the arms and the pass bar first, so the result cannot move the goal. Use before a training run, an ablation, a model or prompt comparison, or for "will X improve Y", "try this idea", "A/B this model".
metadata:
  track: ml
  stage: design
  tagline: Set the pass bar before the run, not after it.
---

# Experiment design

Decide what counts as success before you see a number. After the run, you only compare the result with the bar.

## 1. Write the hypothesis

Write one sentence: "<change> improves <metric> on <data> by at least <amount>, because <reason>."

If you cannot name the reason, write that the experiment is exploratory. Exploratory results need a second, confirmatory run before you act on them.

## 2. Pick the baseline

- The baseline is the best simple thing that exists now: the current model, a heuristic or a well-tuned standard method.
- Tune the baseline as much as the new arm. An untuned baseline gives no result.
- Run the baseline in the same code, data and budget as the new arm.

## 3. Set the pass bar

Write these before the run, in the experiment notes:

| Item | Example |
|---|---|
| Primary metric | Mean absolute error on the frozen test set |
| Pass bar | At least 10 % lower error than the baseline |
| Noise floor | The 95 % CI of the difference must not include 0 |
| Guard metrics | Latency and cost must not get worse by more than 5 % |
| Budget | 3 seeds per arm, 8 GPU hours in total |

One primary metric only. More metrics give more chances to find a "win" by luck.

## 4. Define the arms

- Each arm differs from the baseline in one thing. If an arm changes two things, you cannot say which one helped.
- Give each arm a short name and a one-line description.
- Use the same seeds, data split and budget for each arm.
- Run several seeds. Report the spread, not only the best seed.

## 5. Protect the test set

- Split the data before you look at it: train, validation, test.
- Tune on validation only. Touch the test set once, for the final numbers.
- Split by the unit that must not leak: user, customer, document or time. A random row split leaks when one entity has many rows.

## 6. Start small

Run each arm on a small slice first. Check that the loss goes down, the outputs make sense and the logging works. Then start the full run. Use the `reproducible-run` skill for the run itself.

## 7. Read the result against the bar

| Outcome | Report |
|---|---|
| Passes the bar, CI excludes 0 | PASS. Name the size and the CI. |
| Better, but under the bar or CI includes 0 | FAIL. "No change that we can measure." |
| Worse | FAIL, with the size. |

- A FAIL is a result. Write it down with the same care as a PASS.
- Do not move the bar after the run. If the bar was wrong, say so, set a new bar and run again.
- If two ideas that share one assumption both fail, test the assumption before the next idea.

## Report

```
Hypothesis: <sentence>
Bar: <metric, threshold, set on date>
Arms: <name: change>
Result: <arm: value, CI, seeds> -> PASS / FAIL
Next: <one action>
```
