function [BFSK_BER_th, BFSK_BER_sim] = BFSK()
signalWidth = 120000;                                                       % length of input signal
M = 2;                                                                      % Number of symbols
Eb = 1;                                                                     % Bit Energy
SNRdB = -2 : 1 : 10;
SNR = 10.^(SNRdB/10);
for i = 1 : length(SNR)
    No = Eb / SNR(i);
    differentBitsCount = 0;
    inputSignal = randi([0 1], 1, signalWidth);                             % Generate a random input bit stream
    mappedSignal = inputSignal + j * (~inputSignal);                        % Mapping : Frequency mapping: 1 -> 1, 0 -> j
    
    Eavg = sum(abs(mappedSignal).^2) / length(mappedSignal);                % Average Energy of the signal
    
                                                                            % Generate complex AWGN channel
    NI = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise In-phase component
    NQ = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise Quadrature component
    channelNoise = NI + j * NQ;
    
    receivedSignal = mappedSignal + channelNoise;                           % Received Signal

    for k = 1 : signalWidth
        Z(k) = real(receivedSignal(k))-imag(receivedSignal(k));             % Demodulation
        if ((Z(k) > 0 && inputSignal(k) == 0) || (Z(k) < 0 && inputSignal(k) == 1)) % Decision Device
            differentBitsCount = differentBitsCount + 1;
        end
    end
    BFSK_BER_sim(i) = differentBitsCount / signalWidth;                     % Simulated BER
end
BFSK_BER_th = (1/2) * erfc(sqrt(SNR/2));                                    % Theoretical BER

% plotConstellation(mappedSignal, receivedSignal, 'BFSK', [-3, 3]);
end 