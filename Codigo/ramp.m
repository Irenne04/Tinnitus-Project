% RAMP_COLUM A function for 'ramping' a signal.
%
% function [y] = ramp_colum (x, dt, sin_or_cos, up_or_down, ramp_duration)
%
%   Input arguments:
%           x:              The signal to be ramped.
%           dt:             Sampling period (s).
%           sin_or_cos: 	Selects type of ramp: 
%                           'sin': applies a sine ramp,
%                           'cos': applies a raised-cosine ramp,
%           up_or_down:     Selects whether the signal is to be ramped up, down or both:
%                           'up____', 'down__' or 'updown'.
%           ramp_duration:	Duration of the ramps (s).
%
%   Output:
%           y:				The ramped signal.
%
% Comments:
%       The function applies a ramp both to single-row, and single-colum
%       signals.  It returns an error if the size of a matrix is nonsingleton
%       in both dimensions.
%
% References:
%
%
% © Copyright Almudena Eustaquio Martín, University of Salamanca, 2007.
% 

function [y] = ramp(x, dt, sin_or_cos, up_or_down, ramp_duration)

% Check the number of arguments that are passed in.

if (nargin < 5)
    error ('Insufficient arguments');
end
if (nargin > 5)
    error ('Too many arguments');
end

% Apply ramps only if ramp_duration > 0.
if ramp_duration > 0

    % Check input arguments common to all conditions.

    if dt <= 0
        error ('the sampling period (dt) must be > 0');
    end

    % Start processing.

    signal_length = length(x);
    signal_duration = signal_length * dt;

    if ramp_duration > signal_duration
        error ('ramp is longer than signal');
    end

    t_ramp = 0:dt:ramp_duration;
    ramp_length = length(t_ramp);

    % Calculate ramp envelopes.
    switch sin_or_cos
        case 'sin'
            T = 4.0 * ramp_duration; % period of the ramp.
            arg = 2.0 * pi * t_ramp / T;
            sinrampup = sin(arg);
            sinrampdown = sin(arg + pi/2.0);
        case 'cos'
            T = 2.0 * ramp_duration; % period of the ramp.
            arg = 2.0 * pi * t_ramp / T;
            cosrampup = (1 + cos(arg + pi)) / 2.0;
            cosrampdown = (1 + cos(arg)) / 2.0;
        otherwise
            error ('invalid input argument');
    end

    y = x;

    % Check whether input is in a row or a colum. If it is a
    % column then, used transposed of the calculated envelope.
    [n,m] = size(x);
    if (n > 1) & (m == 1)
        switch sin_or_cos
            case 'sin'
                sinrampup = sinrampup';
                sinrampdown = sinrampdown';
            case 'cos'
                cosrampup = cosrampup';
                cosrampdown = cosrampdown';
        end
    elseif (n > 1) & (m > 1)
        error ('input signal must be a single row or a single column');
    end

    % Apply ramps.
    switch up_or_down

        case 'up____'

            switch sin_or_cos
                case 'sin'
                    y(1:ramp_length) = x(1:ramp_length) .* sinrampup;
                case 'cos'
                    y(1:ramp_length) = x(1:ramp_length) .* cosrampup;
                otherwise
                    error ('invalid input argument');
            end

        case 'down__'

            switch sin_or_cos
                case 'sin'
                    y((signal_length - ramp_length + 1):signal_length) = ...
                        x((signal_length - ramp_length + 1):signal_length) .* sinrampdown;
                case 'cos'
                    y((signal_length - ramp_length + 1):signal_length) = ...
                        x((signal_length - ramp_length + 1):signal_length) .* cosrampdown;
                otherwise
                    error ('invalid input argument');
            end

        case 'updown'

            if ramp_duration > (signal_duration/2)
                error ('ramps are longer than signal');
            end

            switch sin_or_cos
                case 'sin'
                    y(1:ramp_length) = x(1:ramp_length) .* sinrampup;
                    y((signal_length - ramp_length + 1):signal_length) = ...
                        x((signal_length - ramp_length + 1):signal_length) .* sinrampdown;
                case 'cos'
                    y(1:ramp_length) = x(1:ramp_length) .* cosrampup;
                    y((signal_length - ramp_length + 1):signal_length) = ...
                        x((signal_length - ramp_length + 1):signal_length) .* cosrampdown;
                otherwise
                    error ('invalid input argument');
            end
        otherwise
            error ('invalid input argument');
    end

elseif ramp_duration == 0
    y = x;
else
    error('ramp_duration cannot be negative');
end
