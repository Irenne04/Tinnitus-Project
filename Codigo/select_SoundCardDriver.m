% COPYRIGHT NOTICE:
%  © 2025 Almudena Eustaquio Martín. Universidad de Salamanca
%           aeustaquio@usal.es


function soundcardDriver = select_SoundCardDriver()

%% ASIO soundcardDriver
deviceWriter = audioDeviceWriter('Driver', 'ASIO');
devices = deviceWriter.getAudioDevices();
if strcmp(devices{1}, 'No audio output device detected')
    devices{1} = 'Default';
end
devices = flip(devices);
% Select 'soundcardDriver'
[deviceIdx,status] = listdlg('PromptString','Select a soundCard.',...
    'SelectionMode','single','ListString',devices, 'ListSize', [400 200]);
if status == 0
    errordlg('Para ejecutar el test es necesario seleccionar una tarjeta de sonido.');
    return;
end
soundcardDriver.soundcard = devices(deviceIdx);
soundcardDriver.channels = max(deviceWriter.ChannelMapping);
soundcardDriver.nbits = 24;
soundcardDriver.buffersize = 1024;
if strfind(soundcardDriver.soundcard{1,1}, 'ASIO')
    soundcardDriver.asio = 1;
else
    soundcardDriver.asio = 0;
    warndlg({'No se usaran controladores ASIO';'Los niveles sonoros y los resultados pueden no ser fiables'}, 'Aviso importante');
    pause(2);
end
soundcardDriver.channelLeft = 1;         % Sound card output left channel (do not change)
soundcardDriver.channelRight = 2;        % Sound card output right channel (do not change)

if deviceIdx == 1
    [status,result] = system('fireface.exe');
    [status,result] = system('TotalMixFX.exe');
end
button = questdlg('Do not forget to set the sound card seetings','Sound card settings','OK','OK');