function [PSK8_BER_th, PSK8_BER_sim] = PSK8()
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
                                                                    % 8-PSK Mapping : starting counter clockwise from 0 degrees
                                                                    % 0   degrees -> 111 : 7
                                                                    % 45  degrees -> 110 : 6
                                                                    % 90  degrees -> 010 : 2
                                                                    % 135 degrees -> 011 : 3
                                                                    % 180 degrees -> 001 : 1
                                                                    % 225 degrees -> 000 : 0
                                                                    % 270 degrees -> 100 : 4
                                                                    % 315 degrees -> 101 : 5
                                                                    
    realPart = [cos(5*pi/4), cos(pi), cos(pi/2), cos(3*pi/4), cos(3*pi/2), cos(7*pi/4), cos(pi/4), cos(0)];
    imagPart = [sin(5*pi/4), sin(pi), sin(pi/2), sin(3*pi/4), sin(3*pi/2), sin(7*pi/4), sin(pi/4), sin(0)];
    complexSymbol = complex(realPart, imagPart);
    for k = 1 : length(firstBit)
        symbolDecimalValue = firstBit(k) * 2^2 + secondBit(k) * 2^1 + thirdBit(k) * 2^0;
        mappedSignal(k) = complexSymbol(symbolDecimalValue + 1);     % Indexing starts from 1 in MATLAB, so we add 1 to the symbolDecimalValue
    end
    
    Eavg = sum(abs(mappedSignal).^2) / length(mappedSignal);                % Average Energy of the signal
    
                                                                            % Generate complex AWGN channel
    NI = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise In-phase component
    NQ = sqrt((No/2) * (Eavg/log2(M))) * randn(1, length(mappedSignal));    % Noise Quadrature component
    channelNoise = NI + j * NQ;
    
    receivedSignal = mappedSignal + channelNoise;                           % Received Signal
                                                                            % Demodulation
    for k = 1 : length(receivedSignal)
        Zr(k) = real(receivedSignal(k));
        Zi(k) = imag(receivedSignal(k));
        minDistance = 1000000;
        for l = 1 : length(complexSymbol)                                   % Decision Device
            distanceSquared(l) = abs(Zr(k) - real(complexSymbol(l)))^2 + abs(Zi(k) - imag(complexSymbol(l)))^2; % we do not need to take the square root to find the minimum distance
            if distanceSquared(l) < minDistance
                minDistance = distanceSquared(l);
                demappedSymbol = complexSymbol(l);                          % Detected symbol
            end
        end
        detectedSymbol = find(complexSymbol == demappedSymbol) - 1;         % Indexing starts from 1 in MATLAB, so we subtract 1 to get the detected symbol index
        detectedSymbol = dec2bin(detectedSymbol, 3) - '0';                  % Demapping
        if detectedSymbol(1) ~= firstBit(k)
            differentBitsCount = differentBitsCount + 1;
        end
        if detectedSymbol(2) ~= secondBit(k)
            differentBitsCount = differentBitsCount + 1;
        end
        if detectedSymbol(3) ~= thirdBit(k)
            differentBitsCount = differentBitsCount + 1;
        end
    end
    PSK8_BER_sim(i) = differentBitsCount / length(inputSignal);             % Simulated BER
end
PSK8_BER_th = (1/log2(M)) * erfc(sqrt(log2(M) * SNR) * sin(pi/M));          % Theoretical BER

% plotConstellation(mappedSignal, receivedSignal, '8PSK', [-2, 2]);
end