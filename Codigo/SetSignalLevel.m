% COPYRIGHT NOTICE:
%  © 2025 Almudena Eustaquio Martín. Universidad de Salamanca
%           aeustaquio@usal.es

function [signal_att] = SetSignalLevel(signal, attenuation, Lmax) 

% Set the level of the left signal to level_L
signal_dBspl = rms2dBspl (rms_usal(signal,1), Lmax);
signal_gain = (signal_dBspl - attenuation);
signal_att = gain(signal,-signal_gain);
