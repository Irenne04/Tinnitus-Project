% COPYRIGHT NOTICE:
%  © 2025 Almudena Eustaquio Martín. Universidad de Salamanca
%           aeustaquio@usal.es

% GAIN apply a gain in dB to an input signal x
%
% [y] = gain(x,dB)
%   Input arguments:
%       x:     Array with the input signal
%       dB:    Gain in dB
%   Output arguments:
%       y:     Array with the output signal

function y = gain(x,dB)
y = x.*(10^(dB/20));
