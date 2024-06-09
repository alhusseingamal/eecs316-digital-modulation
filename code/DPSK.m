function [DPSK_BER_th, DPSK_BER_sim] = DPSK()
signalWidth = 120000;                                                       % length of input signal
M = 2;                                                                      % Number of symbols
Eb = 1;                                                                     % Bit Energy
SNRdB = -2 : 1 : 10;
SNR = 10.^(SNRdB/10);
for i = 1 : length(SNR)
    No = Eb / SNR(i);
    differentBitsCount = 0;
    inputSignal = randi([0 1], 1, signalWidth + 1);                         % Generate a random input bit stream
                                                                % Note that DPSK requires one extra (reference) bit for differential encoding
                                                                            % Mapping : DPSK Differential Mapping
    mappedSignal(1) = inputSignal(1);
    for h = 2 : signalWidth + 1
        mappedSignal(h) = xor(mappedSignal(h-1), inputSignal(h - 1));
    end
                                                                            % Modulation
    mappedSignal = 2 * mappedSignal - 1;
    
    Eavg = sum(abs(mappedSignal).^2) / length(mappedSignal);                % Average Energy of the signal

                                                                            % Generate complex AWGN channel
    NI = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise In-phase component
    NQ = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise Quadrature component
    channelNoise = NI + j * NQ;
    
    receivedSignal = mappedSignal + channelNoise;                           % Received Signal
                                                                            % Demodulation 
    for k = 1 : signalWidth + 1
        demodulatedSignal(k) = receivedSignal(k) > 0;
    end
                                                                            % Handling the first bit separately
    Z_prime(1) = demodulatedSignal(1) > 0.5;
    Z(1) = Z_prime(1);
    
    for k = 1 : signalWidth
        Z_prime(k + 1) = demodulatedSignal(k + 1) > 0.5;                    % Demapping
        Z(k) = xor(Z_prime(k), Z_prime(k + 1));
        if ((Z(k) > 0.5 && inputSignal(k) == 0) || (Z(k) < 0.5 && inputSignal(k) == 1)) % Decision Device
            differentBitsCount = differentBitsCount + 1;
        end
    end
    DPSK_BER_sim(i) = differentBitsCount / signalWidth;                     % Simulated BER
end
DPSK_BER_th = erfc(sqrt(SNR)) - (1/2) * erfc(sqrt(SNR)).^2;                 % Theoretical BER

% plotConstellation(mappedSignal, receivedSignal, 'DPSK', [-2, 2]);
end