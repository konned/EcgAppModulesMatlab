function [signal_filtered] = myfilter(signal, h)
    signal_filtered = conv(signal, h, 'same');
end