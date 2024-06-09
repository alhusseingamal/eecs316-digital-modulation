function [QAM8_BER_th, QAM8_BER_sim] = QAM8()
signalWidth = 120000;                                                       % length of input signal
M = 8;                                                                      % Number of symbols
Eb = 1;                                                                     % Bit Energy
SNRdB = -2 : 1 : 10;
SNR = 10.^(SNRdB/10);
for i = 1 : length(SNR)
    No = Eb / SNR(i);
    differentBitsCount = 0;
    inputSignal = randi([0 1], 1, signalWidth);                             % Generate a random input bit stream
                                                                            % Multiplexer : Serial to Parallel Converter
    firstBit = inputSignal(1:3:end);
    secondBit = inputSignal(2:3:end);
    thirdBit = inputSignal(3:3:end);
                                                                    % Mapping -> [3+j, 1+j, -1+j, -3+j, 3-j, 1-j, -1-j, -3-j]
                                                                    % The 1st bit determines the sign of the real part : 1 -> +ve, 0 -> -ve
                                                                    % The 2nd bit determines the magnitude of the real part : 1 -> 1, 0 -> 3
                                                                    % The 3rd bit determines the sign of the imaginary part : 0 -> +ve, 1 -> -ve
                                                                    % The magnitude of the imaginary part is always 1
    for k = 1 : length(firstBit)
        if(secondBit(k) == 0)                                               % magnitude of the real part
            mappedSignal(k) = 3;
        else
            mappedSignal(k) = 1;
        end
        if (firstBit(k) == 0)                                               % sign of the real part
            mappedSignal(k) = -1 * mappedSignal(k);
        end
        if(thirdBit(k) == 1)                                                % magnitude and sign of the imaginary part
            mappedSignal(k) = mappedSignal(k) - j;
        else
            mappedSignal(k) = mappedSignal(k) + j;
        end
    end

    Eavg = sum(abs(mappedSignal).^2) / length(mappedSignal);                % Average Energy of the signal
    
                                                                            % Generate complex AWGN channel
    NI = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise In-phase component
    NQ = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise Quadrature component
    channelNoise = NI + j * NQ;
    
    receivedSignal = mappedSignal + channelNoise;                           % Received Signal
                                                                            % Demodulation
    jj = 1;
    for k = 1 : length(receivedSignal)
        Zr(k) = real(receivedSignal(k));
        Zi(k) = imag(receivedSignal(k));
        minDistance = 1000000;
        for r = -3 : 2 : 3
            for ii = -1 : 2 : 1
                distance = sqrt(abs(Zr(k) - r)^2 + abs(Zi(k) - ii)^2);
                if (distance < minDistance)
                    minDistance = distance;
                    demappedSignal(k) = r + j * ii;
                end
            end
        end
                                                                            % Demapping
        if (real(demappedSignal(k)) > 0)
            decodedSignal(jj) = 1;
        else
            decodedSignal(jj) = 0;
        end
        jj = jj + 1;
        if (abs(real(demappedSignal(k))) == 1)
            decodedSignal(jj) = 1;
        else
            decodedSignal(jj) = 0;
        end
        jj = jj + 1;
        if (imag(demappedSignal(k)) < 0)
            decodedSignal(jj) = 1;
        else
            decodedSignal(jj) = 0;
        end
        jj = jj + 1;
    end
    
    for k = 1 : length(inputSignal)
        if (decodedSignal(k) ~= inputSignal(k))
            differentBitsCount = differentBitsCount + 1;
        end
    end
    QAM8_BER_sim(i) = differentBitsCount / signalWidth;                     % Simulated BER
end
QAM8_BER_th = (5/12) * erfc(sqrt(SNR/2));                                   % Theoretical BER

% plotConstellation(mappedSignal, receivedSignal, '8QAM', [-5, 5]);
end