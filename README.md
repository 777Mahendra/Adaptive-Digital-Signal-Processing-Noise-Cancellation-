Project Theme: DSP Systems that Learn, aka Adaptive DSP: This course has focused primarily

on linear, time-invariant systems. As discussed in the class, there are several practical scenarios where time-
invariance does not hold, e.g., in systems that learn an unknown (and often time-varying) vector (e.g., the

impulse response of an unknown system). We will explore this idea through noise cancellation algorithms
widely deployed in noise-canceling ear/headphones. You will design simple DSP algorithms for such noise
cancelers, exploring classical methods (e.g., fixed filters) and/or adaptive filters (loosely put, ”linear” machine
learning methods) as needed to achieve the design objective below.

Problem Statement: You are given a file external noise.txt containing the sound sequence w(n) reach-
ing the headphone cup (see figure). The file noisy speech.txt consists of a clean speech signal s(n)

contaminated by the leakage noise v(n) coming through the cup. Using just these two signals, design a

programmable, selective noise canceller (see figure, orange). Its output ˆv(n) is needs to contain unde-
sirable noise components that are to be ”pre-subtracted” from s(n) and fed to a speaker. The leakage noise

v(n) adds back this undesired noise, resulting in completely removing undesirable noise!



Noise Composition:
• The external sound w(n) and its leakage v(n) may contain one or more tone-like noise sources with
time-varying amplitudes and programmable frequencies. The user supplies these frequencies.
• The external sounds may contain non-tonal sounds that may be non-stationary.
• The user should be able to enable or disable tonal noise suppression separately from other external
sounds suppression.


Design Objective:
• The residual noise sequence is difference between leakage noise v(n) and the cancelled noise ˆv(n) (see
figure). It is this residual noise needs to meet certain criteria.
• In the full suppression mode, ˆv(n) must cancel all components of v(n) while preserving the speech
signal s(n) as much as possible.
• In the partial suppression mode, the tonal noise components of v(n) are to be retained post-cancellation,
while the non-tonal external sounds are to be suppressed.
• For full suppression, the algorithm should maximize post-cancellation Signal-to-Noise Ratio (SNR) (as
measured over the entire duration of the speech sample) with respect to the pre-cancellation SNR. The
clean speech signal s(n) in a file clean speech.txt is provided for SNR measurement purposes. SNR
gains of ∼15 dB or better are possible depending on your design in the full suppression mode.
• For partial suppression, you are required to show the near absence of non-tonal noise after the learning
algorithm converges. You are expected to propose one or more metrics to measure this and justify
their use.


Design Guidelines:
• All signals are sampled at 44.1 kHz.
• You may want to assume that the tonal noise power is the same or more about the non-tonal noise
power. Both of them are typically larger than the average clean speech power.
• To mimic real-time processing, you cannot assume the all the samples in the file are available at once;
rather, the design should ideally buffer some input samples to produce each output sample in ˆv(·).
The size of this input buffer should be as small as possible to reduce latency and computation burden,
while providing significant noise suppression.
• After a change in noise conditions, noise suppression should return to the target suppression level as
soon as possible.
Note: The files mentioned above are only to assist you in system design. Our final design should:

1. Have programmable frequencies for tonal interference. The number of locations should be at least one,
with the upper limit depending on your design.
2. Not make any assumptions about the frequency content of the clean speech signal or the non-tonal
noise signals, except that 44.1 kHz is above their Nyquist rate.
3. Function with other speech and/or external sound files.



Useful Concepts:
• Basics of: Discrete Time Stochastic Processes, Wiener Filter, the Gradient Descent Algorithm, Least
Mean Square (LMS) and the Normalized LMS Algorithms.
• Basics of discrete time stochastic processes will be covered in classroom lectures. You are encouraged
to read up the rest using the very accessible resources below.
• Some topics such as gradient descent and optimality in the MSE sense may be familiar to you from a
machine learning course. LMS is very close to stochastic gradient algorithms encountered in basic ML
courses.
