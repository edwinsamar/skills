---
name: reproducible-run
description: Run training, evaluation or data jobs so any number can be traced and rerun with one command. Pinned environment, seeds, config, data hash and git SHA in a run manifest; runs that resume after a crash; cluster jobs without polling. Use before a long or expensive run, on a GPU cluster or Slurm, or for "make this reproducible", "rerun", "where did this number come from".
metadata:
  track: ml
  stage: run
  tagline: Every number traces back to one command.
---

# Reproducible run

Each result must point to the exact code, data, config and environment that made it. Then anyone can run it again.

## 1. Pin the environment

- Use a lockfile (`uv.lock`, `poetry.lock`, `requirements.txt` with hashes, or a conda lock).
- Record the Python, CUDA, driver and main library versions.
- For a cluster, use a container image or a module list in the job script.

## 2. Put all settings in one config

- One config file per run. Do not keep a value only in a command line that you typed once.
- The code reads every setting from the config. No hidden defaults that change behavior.
- Set and record seeds for Python, NumPy and the framework. Note which GPU operations are not deterministic.

## 3. Write a run manifest

Each run writes `manifest.json` into its own run folder, at start:

| Field | Example |
|---|---|
| `run_id` | `2026-10-14_baseline_s1` |
| `git_sha` | Commit, plus `dirty: true` if there are local changes |
| `config` | Full resolved config |
| `data` | Path and hash of each input file |
| `env` | Versions from step 1 |
| `host` | Machine, GPU type and count |
| `command` | The exact command that started the run |

Do not start a run from a dirty tree for a result that you will report.

## 4. One folder per run

- Write all outputs into `runs/<run_id>/`: manifest, logs, metrics, checkpoints, predictions.
- Never write over the outputs of a different run.
- Keep the raw predictions. Then you can compute a new metric later without a new run.

## 5. Make runs safe to restart

- Save checkpoints at a fixed interval. Include the optimizer state, the scheduler, the data position and the random state.
- At start, look for a checkpoint for this `run_id`. If there is one, resume from it.
- Ask: "What happens if this runs twice? What happens if it stops at any point?" The correct answer is: "it gets to the same result".

## 6. Use the scheduler, not a poll loop

On a cluster:

- Use job arrays for seeds and arms.
- Chain steps with dependent jobs (for example Slurm `--dependency=afterok:<id>`). Do not keep a loop that checks the queue.
- Set a time limit with margin. Use checkpoint resume to continue after a timeout.
- Copy code to the cluster from a clean commit, and record the commit in the manifest.

## 7. Make a script for each result

- Each table or figure comes from a script that reads `runs/` and writes the output.
- One command makes the result again: `make table2` or `python report.py --runs ...`.
- Do not copy numbers by hand into a paper, slide or issue.

## Check

- Run one short job twice with the same seed. Compare the metrics.
- Stop a run in the middle and start it again. Check that it resumes and ends with the same metrics within noise.
- From the manifest alone, start the run again on a clean checkout.
