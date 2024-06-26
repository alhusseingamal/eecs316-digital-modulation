# Digital Modulation Schemes Simulation  
## Overview  
This repository contains MATLAB simulations of various digital modulation techniques.
- The aim is to simulate these techniques through an Additive White Gaussian Noise (AWGN) channel, calculate both the simulated and theoretical Bit Error Rate (BER) against the SNR (Eb/No), and visualize the signal constellations.
- For each run, 120,000 input bits are randomly generated and a unit bit energy(Eb) is assumed.  
- For fair comparison between different schemes, the equivalent of a Normalized Symbol Energy Space is achieved by scaling the amount of noise relative to the number of symbols (M) in the modulation scheme.  

## Repository Structure  
The repository is organized into two main folders:  

### 1. code
This folder contains the MATLAB code for the simulation and analysis of different digital modulation techniques. There are 14 files in this folder:  

#### 12 Modulation Techniques:  
- OOK: On-Off Keying  
- BASK: Binary Amplitude Shift Keying  
- 4ASK: 4-Level Amplitude Shift Keying  
- 8ASK: 8-Level Amplitude Shift Keying  
- BPSK: Binary Phase Shift Keying  
- DPSK: Differential Phase Shift Keying  
- QPSK: Quadrature Phase Shift Keying  
- 8PSK: 8-Level Phase Shift Keying  
- 4QAM: 4-Level Quadrature Amplitude Modulation  
- 8QAM: 8-Level Quadrature Amplitude Modulation  
- 16QAM: 16-Level Quadrature Amplitude Modulation  
- BFSK: Binary Frequency Shift Keying  

#### Main Script:  
main.m: This script calls the modulation functions, simulates the transmission through an AWGN channel, calculates the BER, and plots the results.  
#### Plotting Function:  
plotConstellation.m: This function is used to plot the constellation diagrams of the ideal and the actual received signals.  

### 2. figures   
This folder contains the relevant figures for BER and constellation diagrams. Each figure is labeled according to the modulation technique it represents.  

#### ASK  
![ASK Results](https://github.com/alhusseingamal/eecs316-digital-modulation/blob/main/figures/ASK_and_OOK.png)  

#### PSK  
![PSK Results](https://github.com/alhusseingamal/eecs316-digital-modulation/blob/main/figures/PSK.png)  
We notice that, for gray-encoded data, QPSK exhibits the same characteristic BER as BPSK.  
Also, DPSK is worse than BPSK due to incoherent detection.  

#### QAM  
![QAM Results](https://github.com/alhusseingamal/eecs316-digital-modulation/blob/main/figures/QAM.png)  

#### FSK  
![BFSK Results](https://github.com/alhusseingamal/eecs316-digital-modulation/blob/main/figures/BFSK.png)  

#### Overlaid Results  
![Overlaid Results](https://github.com/alhusseingamal/eecs316-digital-modulation/blob/main/figures/ALL.png)  

Refer to the "figures" folder for more.  
