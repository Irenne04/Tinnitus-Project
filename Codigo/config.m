% COPYRIGHT NOTICE:
%  © 2025 Irene Rodríguez Sánchez. Universidad de Salamanca
%           irene.rodsan@usal.es

%% Creacion de un archivo ini para leer datos ocultos de estandares base
% Los datos del orden de las frecuencias son estandarizados, asi como
filename = 'config.ini';

fid = fopen(filename, 'w'); % Abrir archivo en modo escritura
fprintf(fid, '[General]\n'); % Sección General
fprintf(fid, 'fs = 44100\n'); % Frecuencia de muestreo
fprintf(fid, 'duration = 0.01\n'); % Duration para representar
fprintf(fid, 'freq_order = 1000, 2000, 4000, 8000, 500, 250\n'); % Orden de frecuencias
fprintf(fid, 'Octavas_division =6\n'); % Tiempo de la envolvente

fprintf(fid, '\n[Tipo_casos]\n'); % Tipo de casos para seleccionar el offset
% OFFSET 
fprintf(fid, 'HD280PRO = 117\n'); % Sensibilidad de los cascos calibrada en el Laboratorio 5 del INCyL
fprintf(fid, 'HD26PRO = 105\n'); % Sensibilidad de los cascos

fprintf(fid, '\n[Audio]\n'); % PArametros de audio
fprintf(fid, 'pasodB1 = 2\n'); % Paso en el nivel sonoro (2 dB)
fprintf(fid, 'pasodB2 = 5\n'); % Paso en el nivel sonoro (5 dB)
fprintf(fid, 'rampa_tiempo =0.05\n'); % Tiempo de la envolvente
fprintf(fid, 'rampa_tiempo2 =0.7\n'); % Tiempo de la envolvente
fprintf(fid, 'seguro =80\n'); % Tiempo de la envolvente
fprintf(fid, 'dB_ini =10\n'); % Tiempo de la envolvente
fprintf(fid, 'min_dB =-20\n'); % Tiempo de la envolvente
fprintf(fid, 'ISI_ini =0.25\n'); % Minimo del intervalo del ISI
fprintf(fid, 'ISI_fin =0.25\n'); % Maximo del intervalo del ISI
fprintf(fid, 'promedio =3\n'); % Promedios que se hacen para la intensidad

fclose(fid); % Cerrar archivo
