function [ASK8_BER_th, ASK8_BER_sim] = ASK8()
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
                                                                            % Mapping (Biploar 8-ASK) : 110, 100, 000, 010, 011, 001, 101, 111
                                                                            % The first and second bits determine the magnitude of the signal
                                                                            % 11X -> magnitude = 7, 10X -> magnitude = 5
                                                                            % 00X -> magnitude = 3, 01X -> magnitude = 1
                                                                            % The third bit determines the sign of the signal
                                                                            % XX1 -> sign = +ve, XX0 -> sign = -ve
    for K = 1 : length(firstBit)
        if(firstBit(K) == 1 && secondBit(K) == 1)
            mappedSignal(K) = 7;
        elseif(firstBit(K) == 1 && secondBit(K) == 0)
            mappedSignal(K) = 5;
        elseif(firstBit(K) == 0 && secondBit(K) == 0)
            mappedSignal(K) = 3;
        else
            mappedSignal(K) = 1;
        end
        if(thirdBit(K) == 0)
            mappedSignal(K) = -1 * mappedSignal(K);
        end
    end
    Eavg = sum(abs(mappedSignal).^2) / length(mappedSignal);                % Average Energy of the signal
                                                                            % Generate complex AWGN channel
    NI = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise In-phase component
    NQ = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise Quadrature component
    channelNoise = NI + j * NQ;
    
    receivedSignal = mappedSignal + channelNoise;                           % Received Signal
    
    for k = 1 : length(receivedSignal)
        Zr(k) = real(receivedSignal(k));                                    % Demodulation
                                                                            % Decision Device
        if((Zr(k) > 0 && thirdBit(k) == 0) || (Zr(k) < 0 && thirdBit(k) == 1))
            differentBitsCount = differentBitsCount + 1;
        end
        if((abs(Zr(k)) > 4 && firstBit(k) == 0) || (abs(Zr(k)) < 4 && firstBit(k) == 1))
            differentBitsCount = differentBitsCount + 1;
        end
        if((abs(Zr(k)) > 2 && abs(Zr(k)) < 6 && secondBit(k) == 1) || ((abs(Zr(k)) < 2 || abs(Zr(k)) > 6) && secondBit(k) == 0))
            differentBitsCount = differentBitsCount + 1;
        end
    end
    ASK8_BER_sim(i) = differentBitsCount / signalWidth;                     % Simulated BER
end
ASK8_BER_th = (7/24) * erfc(sqrt((9/63) * SNR));                            % Theoretical BER 

% plotConstellation(mappedSignal, receivedSignal, '8ASK', [-10, 10]);
end 