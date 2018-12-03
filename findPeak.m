function [A, B] = findPeak (signal, threshold)
    A = [];
    B = [];
    if (length(signal) > 2)
        for i = 2:length(signal)-1
            if(signal(i) > signal(i-1) & signal(i) > signal(i+1) & signal(i) > threshold)
                A(end+1) = signal(i);
                B(end+1) = i;
        end
    end
end