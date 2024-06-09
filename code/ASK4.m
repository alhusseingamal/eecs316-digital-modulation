function [ASK4_BER_th, ASK4_BER_sim] = ASK4()
signalWidth = 120000;                                                       % length of input signal
M = 4;                                                                      % Number of symbols
Eb = 1;                                                                     % Bit Energy
SNRdB = -2 : 1 : 10;    
SNR = 10.^(SNRdB/10);
for i = 1 : length(SNR)
    No = Eb / SNR(i);
    differentBitsCount = 0;
    inputSignal = randi([0 1], 1, signalWidth);                             % Generate a random input bit stream

                                                                            % Multiplexer : Serial to Parallel Converter
    OddBits = inputSignal(1:2:end);
    EvenBits = inputSignal(2:2:end);
                                                                            % Mapping (Biploar 4-ASK): 00, 10, 11, 01
                                                                            % OddBit determines the the magnitude of the signal
                                                                            % EvenBit determines the sign of the signal
    for k = 1 : length(OddBits)
        if (OddBits(k) == 0)
            mappedSignal(k) = 3;
        else
            mappedSignal(k) = 1;
        end
        if (EvenBits(k) == 0)
            mappedSignal(k) = mappedSignal(k) * -1;
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
        if((Zr(k) > 0 && EvenBits(k) == 0) || (Zr(k) < 0 && EvenBits(k) == 1))
            differentBitsCount = differentBitsCount + 1;
        end
        if((Zr(k) > -2 && Zr(k) < 2 && OddBits(k) == 0) || ((Zr(k) < -2 || Zr(k) > 2) && OddBits(k) == 1))
            differentBitsCount = differentBitsCount + 1;
        end
    end
    ASK4_BER_sim(i) = differentBitsCount / signalWidth;                     % Simulated BER
end
ASK4_BER_th = (3/8) * erfc(sqrt(SNR/2.5));                                  % Theoretical BER 

% plotConstellation(mappedSignal, receivedSignal, '4ASK', [-5, 5]);
end 