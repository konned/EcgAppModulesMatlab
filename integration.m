function [signal_int] = integration (signal, W)
    N = length(signal);
    signal_int = zeros(1,N);
    for i = W : N
        for j = i-W+1 : i
            signal_int(i) = signal_int(i) + signal(j); 
        end
        signal_int(i) = signal_int(i) / W;
    end
end