% RMS Calculates the Root Mean Square value of the signal x
% 
% y=rms(x,dim)
%
%   Input arguments:
%           x:      Input signal. 
% 	        dim:	Dimension for calculate RMS.
%
%   Output arguments:
%           y:      Output signal.
% 
% © Copyright Almudena Eustaquio Martín, University of Salamanca, 2008.

function [y] = rms (x,dim)

% By default, rms is calculated along rows; i.e., it is assumed that
% time runs vertically.
if nargin < 2
    dim = 1;
end

[m,n] = size(x);
sumxsqr = sum(x.*x,dim);
if dim == 1
    y = sqrt(sumxsqr ./ m);
elseif dim == 2
    y = sqrt(sumxsqr ./ n);
end
