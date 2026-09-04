% COPYRIGHT NOTICE:
%  © 2025 Almudena Eustaquio Martín. Universidad de Salamanca
%           aeustaquio@usal.es


function nUnderruns = PlayBlocking_ASIO(signal, fs, nbits, buffersize, soundcard)
% Plays sound to an ASIO compatible sound card (default: RME Fireface).
% Requires the Matlab audio toolbox.
% The sound is played frame-by-frame. 
% If the signal is shorter than a multipla of the buffersize, zeros are 
% padded to produce an integer number of frames. 
% The latency is correlated to buffersize. 
% Small buffersize may provoke glitches and clicks in the sound. 
% Long framseize ensures stable output from soundcard.
% The buffersize should be equal to the soundcard buffersize for
% optimal performance. Currently, buffersize cannot be obtained from the 
% sound card without user interaction (asiosettings opens the HW dialog).
% Channel capacity for more than two channels is not implemented: 


N_Frames = ceil(length(signal)/buffersize);
N_ZeroPadding = N_Frames*buffersize - length(signal);
signal = [signal' zeros(size(signal,2),N_ZeroPadding)]';
%% Audio object to play and record
% Buffers to read and write blocks (frames) of input and output samples,
% respectively
toOutBuffer = dsp.AsyncBuffer(length(signal));
toInBuffer = dsp.AsyncBuffer(length(signal));
write(toOutBuffer,signal);

% Sound card interface for synchronous playback and recording
nbits_txt = sprintf('%d-bit integer', nbits);
aPR = audioPlayerRecorder('Device', soundcard,...
    'SampleRate',fs,...
    'BitDepth',nbits_txt,...
    'SupportVariableSize',true,...
    'BufferSize', buffersize);

% Streaming playback and acquisition
% Loop ensures internal queues are never saturated
nUnderruns = 0;
nOverruns = 0;
while toOutBuffer.NumUnreadSamples >= buffersize
    % Get a block of input samples
    frameOut = read(toOutBuffer,buffersize);
    
    % Playback and record
    [frameIn,nUnderrunsaux,nOverrunsaux] = aPR(frameOut);
    
    % Store a block of output samples
%     write(toInBuffer,frameIn);
    
    % Check no blocks were dropped in either direction
    if nUnderrunsaux > 0
        nUnderruns = nUnderruns + nUnderrunsaux;
    end
    if nOverrunsaux > 0
        nOverruns = nOverruns + nOverrunsaux;
    end
end
release(aPR);

if nUnderruns > 0
    warning('Audio player queue was underrun by %d samples.\n',nUnderruns);
end
if nOverruns > 0
    fprintf('Audio recorder queue was overrun by %d samples.\n',nOverruns);
end

