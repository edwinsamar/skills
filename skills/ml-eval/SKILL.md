---
name: ml-eval
description: Build or check an ML or LLM evaluation so its numbers are real. Frozen eval set, leakage checks, confidence intervals, slices, and a calibrated LLM judge. Use when you report a model metric, compare models or prompts, use an LLM as a judge, or for "evaluate", "eval set", "is this number right".
metadata:
  track: ml
  stage: eval
  tagline: A metric without a CI and a leakage check is a guess.
---

# ML eval

An eval number is useful only when you know two things. What does it measure? How much can it move by chance?

## 1. Freeze the eval set

- Save the eval set as a file. Record its hash, its size and how you selected it.
- Do not change it during the work. If you must change it, give it a new version name and run all models again.
- Keep a separate holdout that you use only for the final report.

## 2. Check for leakage

Check each item. Write what you found.

- **Overlap:** no eval item, or near copy of it, is in the training data. Check by ID and by text or feature hash.
- **Entity:** no user, customer or document is in both train and eval.
- **Time:** the model does not see data from after the eval period.
- **Target:** no feature is a copy of the label or is set after the label.
- **Contamination (LLMs):** the eval items are not public benchmark items that the model saw in pre-training.

A result that is too good is a leakage alarm. Find the cause before you report it.

## 3. Report the metric with its uncertainty

- Give the value, the unit and the eval set size: "accuracy 71 % on 412 items".
- Add a 95 % confidence interval. Use a bootstrap over items, or over groups if items are not independent.
- To compare two models, bootstrap the paired difference on the same items. The comparison is real only if its CI excludes 0.
- Report each seed and the spread, not only the mean.

## 4. Look at slices

- Break the metric down by the slices that matter: class, customer, language, length, source.
- Show the size of each slice. Do not draw a conclusion from a slice with few items.
- A good average can hide a slice that fails. Name the worst slice.

## 5. Explain the number

Before you trust a number, ask:

- **Did every item run?** Count errors, timeouts, empty outputs and parse failures. Score them as failures, not as missing.
- **What else can it measure?** Formatting, length, position, caching or a default answer. Rule out each one with a test.
- **Why is it not higher?** Read 20 failures by hand. Sort them into causes. The biggest cause is the next task.

## 6. LLM as a judge

- Write the rubric as clear pass/fail checks, not a 1 to 10 scale.
- Label a sample by hand (50 items or more). Run the judge on it. Report agreement with the human labels, for example Cohen's kappa.
- Do not use the judge until agreement is acceptable. Write down the threshold before you measure it.
- Hide which model made the output. Randomize the order in pairwise comparisons.
- Keep the judge model and prompt fixed for all arms.

## Report

```
Eval set: <name, version, hash, n>
Leakage checks: <each check: result>
Metric: <value> [95 % CI <low>, <high>], seeds: <values>
Diff vs baseline: <value> [CI], paired bootstrap
Worst slice: <slice, n, value>
Judge agreement: <kappa, n> (if a judge is used)
Errors counted: <n>
```
