function [QAM16_BER_th, QAM16_BER_sim] = QAM16()
signalWidth = 120000;                                                       % length of input signal
M = 16;                                                                     % Number of symbols
Eb = 1;                                                                     % Bit Energy
SNRdB = -2 : 1 : 10;
SNR = 10.^(SNRdB/10);
for i = 1 : length(SNR)
    No = Eb / SNR(i);
    differentBitsCount = 0;
    inputSignal = randi([0 1], 1, signalWidth);                             % Generate a random input bit stream
    
                                                                            % Multiplexer : Serial to Parallel Converter
    firstBit = inputSignal(1:4:end);
    secondBit = inputSignal(2:4:end);
    thirdBit = inputSignal(3:4:end);
    fourthBit = inputSignal(4:4:end);

                                                                % Mapping
                                                                % The first bit determines the sign of the real part : 0 -> +ve, 1 -> -ve
                                                                % The second bit determines the magnitude of the real part : 1 -> 1, 0 -> 3
                                                                % The third bit determines the sign of the imaginary part : 0 -> +ve, 1 -> -ve
                                                                % The fourth bit determines the magnitude of the imaginary part : 1 -> 1, 0 -> 3
    for k = 1 : length(firstBit)
        if(secondBit(k) == 0)                                               % magnitude of the real part
            mappedSignal(k) = 3;
        else
            mappedSignal(k) = 1;
        end
        if (firstBit(k) == 1)                                               % sign of the real part
            mappedSignal(k) = -1 * mappedSignal(k);
        end
                                                                            % magnitude and sign of the imaginary part
        if(thirdBit(k) == 1)
            if (fourthBit(k) == 1)
                mappedSignal(k) = mappedSignal(k) - j;
            else
                mappedSignal(k) = mappedSignal(k) - 3*j;
            end
        else
            if (fourthBit(k) == 1)
                mappedSignal(k) = mappedSignal(k) + j;
            else
                mappedSignal(k) = mappedSignal(k) + 3*j;
            end
        end
    end

    Eavg = sum(abs(mappedSignal).^2) / length(mappedSignal);                % Average Energy of the signal

    %Generate complex AWGN channel
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
            for ii = -3 : 2 : 3
                distance = sqrt(abs(Zr(k) - r)^2 + abs(Zi(k) - ii)^2);
                if (distance < minDistance)
                    minDistance = distance;
                    demappedSignal(k) = r + j * ii;
                end
            end
        end
                                                                            % Demapping
        if (real(demappedSignal(k)) > 0)                                    % first bit : sign of the real part
            decodedSignal(jj) = 0;
        else
            decodedSignal(jj) = 1;
        end

        jj = jj + 1;                                                        % second bit : magnitude of the real part
        if (abs(real(demappedSignal(k))) > 2)
            decodedSignal(jj) = 0;
        else
            decodedSignal(jj) = 1;
        end

        jj = jj + 1;                                                        % third bit : sign of the imaginary part
        if (imag(demappedSignal(k)) > 0)
            decodedSignal(jj) = 0;
        else
            decodedSignal(jj) = 1;
        end
        
        jj = jj + 1;                                                        % fourth bit : magnitude of the imaginary part
        if (abs(imag(demappedSignal(k))) > 2)
            decodedSignal(jj) = 0;
        else
            decodedSignal(jj) = 1;
        end

        jj = jj + 1;
    end
    
    for k = 1 : length(inputSignal)                                         % Decision Device
        if (decodedSignal(k) ~= inputSignal(k))
            differentBitsCount = differentBitsCount + 1;
        end
    end
    QAM16_BER_sim(i) = differentBitsCount / signalWidth;                     % Simulated BER
end
QAM16_BER_th = (3/8) * erfc(sqrt(SNR/2.5));                                  % Theoretical BER

% plotConstellation(mappedSignal, receivedSignal, '16QAM', [-5, 5]);
end