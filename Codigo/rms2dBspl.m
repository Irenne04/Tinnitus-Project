% RMS2DBSPL calculates the number of dB SPL corresponding to a given RMS 
%   amplitude considering the calibration of the system.
%
%   [L] = rms2dBspl(s,Lmax) transforms scalar RMS amplitude 's' into dB SPL
%   using the formula: l = 20* log10(s/sqrt(2)/ref).
%
%   Input arguments:
%           s:      scalar RMS amplitude. 
% 	        Lmax:	Acoustic sound level (in dB SPL) for a 1-kHz
% 	                digital sinusoidal wave with a peak amplitude of 1.
%                   1/sqrt(2): calibration rms of a pure tone of 1000 Hz and amp = 1
%
%   Output arguments:
%          l:      dB SPL amplitude.
%
% Comments:
%
% References:
%
%
% © Copyright Almudena Eustaquio Martín, University of Salamanca, 2008.
% 
function [l] = rms2dBspl (s, Lmax)

% Check the number of arguments that are passed in.
if (nargin < 2)
   error ('Insufficient arguments');
end
if (nargin > 2)
   error ('Too many arguments');
end

% Calculations.
l = Lmax + 20 .* log10(s.*sqrt(2));