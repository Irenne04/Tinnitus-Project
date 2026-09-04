% COPYRIGHT NOTICE:
%  © 2025 Irene Rodríguez Sánchez. Universidad de Salamanca
%           irene.rodsan@usal.es

function sonidoASIO(asio,t_durac,ear,fs,level,lmax,ramp_duration,frequency,soundcardDriver)
% Funcion para hacer sonar una señal, con ASIO
% asio: si se quiere hacer con asio o no 
% t_durac: tiempo de duracion de la señal
% ear: en que oido se quiere la señal (dere; izq; ambos)
% fs: frecuencia de muestreo
% level: nivel al que se quiere tocar la señal (dBSPL)
% lmax: Headphones calibration
% ramp_duration: duracion de la rampa (50ms)
% frequency: frecuencia a la que se toca la señal
% soundcardDriver: info de la soundCard

    % Ejemplo de los datos para hacer comprobacion (descomentar si fuera necesario)
    %asio= false;
    %t_durac=1.5;
    %ear='dere';
    %fs=44100;
    %level=30;
    %lmax=102;
    %ramp_duration=0.05;
    %frequency=500;
    %soundcardDriver=select_SoundCardDriver();

    %clear all

    % Asignamos valores 
    player.asio = asio;
    signal.level = level;
    signal.fs = fs;
    
    % Saca los canales, bits, ... info de la soundCard
    channels = soundcardDriver.channels;
    nbits = soundcardDriver.nbits;
    bufferSize = soundcardDriver.buffersize;
    chL = soundcardDriver.channelLeft; % 1
    chR = soundcardDriver.channelRight; % 2
    soundCard = soundcardDriver.soundcard;
       
    % Comentar o descomentar las siguientes secciones dependiendo de la
    % finalidad
    %% Set the level of the signal (si doy el audio)
    %[signal.signal, signal.fs] = audioread('sentence1.wav'); % Da ya el audio
    %% Para crear yo el audio
    % Crear el vector como [N,1]
    t = (0:1/signal.fs:t_durac)'; % Se traspone porque inicialmente t=[1,N] y en las funciones lo requiero como t=[N,1]
    signal.signal =sin(2 * pi * frequency * t); 
    
    %% Programa normal 
    % Normaliza la amplitud (con la sensibilidad y el nivel al que se quiere dar la señal)
    dB_out=calibrar_dB_HD_280_PRO(ear, frequency, signal.level);
    %[signal] = SetSignalLevel(signal, dB_out, lmax);
    [signal.signal] = SetSignalLevel(signal.signal, dB_out, lmax);

    % Para los plots
    signal1 = signal.signal; % Se guarda para la representacion

    signal.signal = ramp(signal.signal, 1/signal.fs, 'cos', 'updown', ramp_duration);

    % Para los plots
    signal2 = signal.signal; % Se guarda para la representacion 

    % Se toca el audio
    if player.asio % Con asio
        player_input = repmat(zeros(size(signal.signal(:,1))), 1,channels);

        % Para ver que tipo de oido quieres que suene
        switch ear
            case 'dere'
                player_input(:,chL) = zeros(size(signal.signal));
                player_input(:,chR) = signal.signal;
            case 'izq'
                player_input(:,chL) = signal.signal;
                player_input(:,chR) = zeros(size(signal.signal));
            case 'ambos'
                player_input(:,chL) = signal.signal;
                player_input(:,chR) = signal.signal;
            otherwise
                error ('invalid input argument');
        end
     
        % En PlayBlocking se mete en player_input = [dos señales]
        % disp(soundCard{1,1}); % imprime: ASIO 2.0 - ESI UGM192
        nunderrun = PlayBlocking_ASIO(player_input, signal.fs, nbits, bufferSize, soundCard{1,1});
    else % Sin asio

        switch ear
            case 'dere'
                player_input(:,chL) = zeros(size(signal.signal));
                player_input(:,chR) = signal.signal;
            case 'izq'
                player_input(:,chL) = signal.signal;
                player_input(:,chR) = zeros(size(signal.signal));
            case 'ambos'
                player_input(:,chL) = signal.signal;
                player_input(:,chR) = signal.signal;
            otherwise
                error ('invalid input argument');
        end
        
        player_input = audioplayer(player_input, signal.fs, 24); %Controlador de Windows
        playblocking(player_input);
        %pause('on') %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %pause(1);
        %play(player_input);

    end
    
    % Comprobacion de que la señal es correcta (descomentar si fuera necesaria la comprobacion)
    %figure;
    %plot(t,signal1,'r');
    %hold on
    %plot(t,signal2,'b');
    %hold off

    %% Para poner un delay de tiempo despues de sonidoASIO (debe ser despues de la funcion no dentro de esta)
    % Imprime si se da la espera
    %T = timer('TimerFcn',@(~,~)disp('Fired.'),'StartDelay',1);
    %start(T)
    %wait(T)

    % Espera
    %pause('on')
    %pause(1);

end



    


