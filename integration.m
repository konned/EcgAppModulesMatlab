function [signal_int] = integration (signal, W1, fs)
    N = length(signal);
    signal_int = zeros(1,N);
    W = floor(W1*fs);
    if (rem(W,2) == 0)
        W = ceil(W1*fs);
    end
    for i = W : N
        for j = i-W+1 : i
            signal_int(i) = signal_int(i) + signal(j); 
        end
        signal_int(i) = signal_int(i) / W;
    end
end