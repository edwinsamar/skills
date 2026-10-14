---
name: gpu-benchmark
description: Measure GPU or ML performance correctly before you report a speedup or act on it. Check correctness against a reference, warm up and synchronize, repeat runs, name the limiter with a roofline, and compare only tuned sides. Use for kernels, training or inference throughput, latency, "is this faster", "benchmark", or "optimize this kernel".
metadata:
  track: ml
  stage: perf
  tagline: If you cannot say why it is not twice as fast, you do not know what you measured.
---

# GPU benchmark

A fast wrong result has no value. A speedup that you cannot explain is not a result yet.

## 1. Write the claim first

Write the sentence that you expect to report: "The fused kernel is 1.8x faster than the PyTorch reference at batch 4096 on one H100." The checks below test this sentence.

## 2. Check correctness first

- Compare the output with a simple reference implementation on the same inputs.
- Use a tolerance that fits the data type, for example `rtol=1e-3` for fp16.
- Test edge shapes: size 1, sizes that are not a multiple of the block size, the largest size.
- Test more than one random seed. Do not time a kernel that fails this step.

## 3. Time it correctly

- **Warm up.** Run several iterations before you time. This removes compile, autotune and cache effects.
- **Synchronize.** GPU calls are asynchronous. Use CUDA events, or call `torch.cuda.synchronize()` before you start and stop a timer.
- **Repeat.** Run each side at least 5 times. Alternate the sides (A, B, A, B) so drift affects both. Report the median and the range.
- **Same conditions.** Same GPU, same clocks, same input shapes and dtype, no other jobs on the GPU. Check with `nvidia-smi`.
- **Did the work happen?** Make sure that the code uses the output. Lazy or skipped work gives fast numbers for work that did not run.

## 4. Compare tuned sides only

- Run the baseline the way production runs it: same compile mode, same precision, same batch size, its own best settings.
- If one side uses defaults and the other is tuned, you compared settings, not methods. Tune it and measure again.

## 5. Name the limiter

Ask "why is it not twice as fast?" Get the answer from a profile, not from reading code.

- Profile in a separate run. Do not report numbers from a profiled run.
- Use Nsight Systems for the timeline and Nsight Compute for a kernel, or the PyTorch profiler.
- Calculate the bytes moved and the FLOPs. Compare them with the peak memory bandwidth and peak compute of the GPU (roofline).
  - Near peak bandwidth: memory bound. Reduce bytes moved, fuse kernels.
  - Near peak compute: compute bound. Use tensor cores, a lower precision or less work.
  - Far from both: launch overhead, low occupancy, sync points or the host. Look at the timeline.
- A result above the hardware limit means that you measured something else: a cache, a no-op or a bug.

## 6. Check that it matters

- Measure the end-to-end step too: a training step, a full request or an epoch.
- Give the share of the end-to-end time. A kernel that takes 5 % of a step can make the step at most about 5 % faster.

## 7. Keep or revert

- Measure again the same way as the baseline.
- If the change is inside the run-to-run range, it is "no measurable difference". Revert it.
- Log every attempt, also the reverted ones.

## Report

```
Claim: <sentence>
Correct vs reference: <tolerance, shapes, seeds>
Result: <baseline> -> <new>, median of <n> runs, range <low>-<high>
Limiter: <memory/compute/launch/host>, <% of peak>
End to end: <step time before -> after>
Verdict: faster / slower / no measurable difference / inconclusive
```
