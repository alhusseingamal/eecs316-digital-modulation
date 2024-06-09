function [OOK_BER_th, OOK_BER_sim] = OOK()
signalWidth = 120000;                                                       % length of input signal
M = 2;                                                                      % Number of symbols
Eb = 1;                                                                     % Bit Energy
SNRdB = -2 : 1 : 10;
SNR = 10.^(SNRdB/10);
for i = 1 : length(SNR)
    No = Eb / SNR(i);
    differentBitsCount = 0;
    inputSignal = randi([0 1], 1, signalWidth);                             % Generate a random input bit stream
    mappedSignal = inputSignal;                                             % OOK Mapping : On-Off Keying (0 -> 0, 1 -> 1)
    
    Eavg = sum(abs(mappedSignal).^2) / length(mappedSignal);                % Average Energy of the signal    
                                                                            % Generate complex AWGN channel
    NI = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise In-phase component
    NQ = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise Quadrature component
    channelNoise = NI + j * NQ;
    
    receivedSignal = mappedSignal + channelNoise;                           % Received Signal

    for k = 1 : length(receivedSignal)
        Zr(k) = real(receivedSignal(k)) > 0.5;                              % Demodulation and Demapping (1 -> 1, 0 -> 0)
        if (Zr(k) ~= inputSignal(k))                                        % Decision Device
            differentBitsCount = differentBitsCount + 1;
        end 
    end
    OOK_BER_sim(i) = differentBitsCount / signalWidth;                      % Simulated BER
end
OOK_BER_th = (1/2) * erfc(sqrt(SNR/2));                                     % Theoretical BER
% plotConstellation(mappedSignal, receivedSignal, 'OOK', [-2, 2]);
end