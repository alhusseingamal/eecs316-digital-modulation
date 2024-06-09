function [QAM4_BER_th, QAM4_BER_sim] = QAM4()
signalWidth = 120000;                                                       % length of input signal
M = 4;                                                                      % Number of symbols
Eb = 1;                                                                     % Bit Energy
SNRdB = -2 : 1 : 10;
SNR = 10.^(SNRdB/10);
for i = 1 : length(SNR)
    No = Eb / SNR(i);
    differentBitsCount = 0;    
    inputSignal = randi([0 1], 1, signalWidth);                             % Generate a random input bit stream
    inputSignal = 2 * inputSignal - 1;                                      % Polar NRZ Encoding (0 -> -1, 1 -> 1)
                                                                            % Multiplexer : Serial to Parallel Converter
    OddBits = inputSignal(1:2:end);
    EvenBits = inputSignal(2:2:end);
                                                                            % Mapping -> [1+j, 1-j, -1-j, -1+j]
    mappedSignal = OddBits + j * EvenBits;                                  % OddBits -> Real part, EvenBits -> Imaginary part

    Eavg = sum(abs(mappedSignal).^2) / length(mappedSignal);                % Average Energy of the signal

                                                                            % Generate complex AWGN channel
    NI = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise In-phase component
    NQ = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise Quadrature component
    channelNoise = NI + j * NQ;
    
    receivedSignal = mappedSignal + channelNoise;                           % Received Signal                    

    for k = 1 : length(receivedSignal)
        Zr(k) = real(receivedSignal(k));                                    % Demodulation
        Zi(k) = imag(receivedSignal(k));
        if ((Zr(k) > 0 && OddBits(k) == -1) || (Zr(k) < 0 && OddBits(k) == 1))  % Decision Device
            differentBitsCount = differentBitsCount + 1;
        end
        if ((Zi(k) > 0 && EvenBits(k) == -1) || (Zi(k) < 0 && EvenBits(k) == 1))
            differentBitsCount = differentBitsCount + 1;
        end
    end
    QAM4_BER_sim(i) = differentBitsCount / length(inputSignal);      % Simulated BER
end
QAM4_BER_th = (1/2) * erfc(sqrt(SNR));       % Theoretical BER

% plotConstellation(mappedSignal, receivedSignal, '4QAM', [-3, 3]);
end