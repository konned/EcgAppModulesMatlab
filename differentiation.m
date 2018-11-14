function [signal_diff] = differentiation (signal)  
    signal_diff = 1/8 .* (-signal(1:(end-4)) - 2.*signal(2:(end-3)) + ...
        2.*signal(4:(end-1)) + signal(5:end));
    signal_diff = [0 0 signal_diff' 0 0];
end