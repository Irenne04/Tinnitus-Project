% COPYRIGHT NOTICE:
%  © 2025 Irene Rodríguez Sánchez. Universidad de Salamanca
%           irene.rodsan@usal.es

function dB_out=calibrar_dB_HD_280_PRO(ear, freq, dB_in)
% Función para calibrar los dB para los cascos HD 280 PRO usando una tarjeta de
% sonido ASIO: UGM192, y dispositivo de procesamiento: Intel(R) Core(TM) i7-4710HQ CPU @ 2.50GHz   2.50 GHz
% Se ha usado una calibración a 94 dBSPL, midiendo en el sonómetro el resultado (calibrando el sonómetro a 94 dBSPL y un 1000 Hz previamente)
% Suponiendo que los cascos tienen la misma sensibilidad para ambos oídos (117 dBSPL). 
% Se ha usado una frecuencia de muestreo de 44100 Hz, y un sonómetro
% implementando un micrófeno en un maniqui de escucha realista (con un soporte de orejas
% para simular las atenuaciones en las diversas frecuencias debido a la
% antomía del oído). Además se ha medido con el mismo micrófeno (para
% evitar variaciones en el dispositivo), solo variando la posición de los
% cascos.
%
% ear: será 'dere' o 'izq'
% freq: frecuencia a la que quiero obtener el sonido
% dB_in: valor que quiero obtener cuando genero la señal en intensidad
% sonora (dBSPL)
% dB_out: valor que debo poner en los parametros del codigo (usando las funciones de Almudena Eustaquio Martín) para que
% emita al valor de dB_in que supongo
%%
% Comprobación (descomentar estas líneas)
%freq = 7000;
%dB_in = 50;
%ear = 'dere';

% Introducir el dato de la rampa
config = read_ini('../ini/calibrar.ini');
% Acceder a los datos leídos
dB_array = config.HD_280_PRO_117.x;
freq_dere = config.HD_280_PRO_117.y_dere;
freq_izq = config.HD_280_PRO_117.y_izq;


% Si es oído derecho o izquierdo
switch ear
    case 'dere'
        % Interpolarción para oído derecho
        dB_interpol = interp1(dB_array, freq_dere, freq); 
    case 'izq'
        % Interpolación para oído izquierdo
        dB_interpol = interp1(dB_array, freq_izq, freq);
end

% Se calcula lo que deberia de poner para que funcione con los dB que
% quiero (se pone 94 porque es a lo que estamos calibrando)
dB_out = dB_in -(dB_interpol - 94);

%% Para la comprobación (descomentar estas líneas)
%figure;
%plot(dB_array,freq_dere,'r');
%hold on
%plot(dB_array,freq_izq,'b');
%hold off
%title('Calibración para ambos oídos a 94 dBSPL');
%xlabel('Frecuencias (HZ)');
%ylabel('Nivel sonoro (dBSPL)');
%legend('Oído derecho','Oído izquierdo');
%disp(dB_out);

end