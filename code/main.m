clc;
clear all;
close all;
SNRdB = -2 : 1 : 10;
SNR = 10.^(SNRdB/10);

[OOK_BER_th, OOK_BER_sim] = OOK();
[BASK_BER_th, BASK_BER_sim] = BASK();
[ASK4_BER_th, ASK4_BER_sim] = ASK4();
[ASK8_BER_th, ASK8_BER_sim] = ASK8();

[BPSK_BER_th, BPSK_BER_sim] = BPSK();
[DPSK_BER_th, DPSK_BER_sim] = DPSK();
[QPSK_BER_th, QPSK_BER_sim] = QPSK();
[PSK8_BER_th, PSK8_BER_sim] = PSK8();

[QAM4_BER_th, QAM4_BER_sim] = QAM4();
[QAM8_BER_th, QAM8_BER_sim] = QAM8();
[QAM16_BER_th, QAM16_BER_sim] = QAM16();

[BFSK_BER_th, BFSK_BER_sim] = BFSK();


%---------- Plotting the BER ----------%
% Define some additional colors needed for plotting
color1 = [0.8 0.5 0.0];
color2 = [0.6 0.5 0.7];
color3 = [0.5 0.5 0.3];
color4 = [0.5 0.9 0.2];
color5 = [0.2 0.5 0.9];
color6 = [0.1 0.1 0.5];


%%%%%%%%%%%%%% ASK %%%%%%%%%%%%%%

plot(SNRdB, OOK_BER_th, 'Color', color1);
hold on;
plot(SNRdB, OOK_BER_sim, '*', 'Color', color1);
hold on;

plot(SNRdB, BASK_BER_th, 'Color', color2);
hold on;
plot(SNRdB, BASK_BER_sim, '*', 'Color', color2);
hold on;

plot(SNRdB, ASK4_BER_th, 'Color', color3);
hold on;
plot(SNRdB, ASK4_BER_sim, '*', 'Color', color3);
hold on;

plot(SNRdB, ASK8_BER_th, 'Color', color4);
hold on;
plot(SNRdB, ASK8_BER_sim, '*', 'Color', color4);
hold on;

%%%%%%%%%%%%%% QAM %%%%%%%%%%%%%%

plot(SNRdB, QAM4_BER_th, 'r');
hold on;
plot(SNRdB, QAM4_BER_sim, 'r*');
hold on;

plot(SNRdB, QAM8_BER_th, 'g');
hold on;
plot(SNRdB, QAM8_BER_sim, 'g*');
hold on;

plot(SNRdB, QAM16_BER_th, 'b');
hold on;
plot(SNRdB, QAM16_BER_sim, 'b*');
hold on;

%%%%%%%%%%%%%% PSK %%%%%%%%%%%%%%

plot(SNRdB, BPSK_BER_th, 'y');
hold on;
plot(SNRdB, BPSK_BER_sim, 'y*');
hold on;

plot(SNRdB, DPSK_BER_th, 'Color', color5);
hold on;
plot(SNRdB, DPSK_BER_sim, '*', 'Color', color5);
hold on;

plot(SNRdB, QPSK_BER_th, 'm');
hold on;
plot(SNRdB, QPSK_BER_sim, 'm*');
hold on;

plot(SNRdB, PSK8_BER_th, 'c');
hold on;
plot(SNRdB, PSK8_BER_sim, 'c*');
hold on;

%%%%%%%%%%%%%% FSK %%%%%%%%%%%%%%

plot(SNRdB, BFSK_BER_th, 'Color', color6);
hold on;
plot(SNRdB, BFSK_BER_sim, '*', 'Color', color6);
hold on;

xlabel('Eb/No (dB)');
ylabel('BER');
title('Overlaid Results');
set(gca, 'YScale', 'log');
legend('OOK-th', 'OOK-sim', 'BASK-th', 'BASK-sim', '4-ASK-th', '4-ASK-sim', '8-ASK-th', '8-ASK-sim', '4-QAM-th', '4-QAM-sim', '8-QAM-th', '8-QAM8-sim', '16-QAM-th', '16-QAM-sim', 'BPSK-th', 'BPSK-sim', 'DPSK-th', 'DPSK-sim', 'QPSK-th', 'QPSK-sim', '8-PSK-th', '8-PSK-sim', 'BFSK-th', 'BFSK-sim');