% COPYRIGHT NOTICE:
%  © 2025 Irene Rodríguez Sánchez. Universidad de Salamanca
%           irene.rodsan@usal.es

%% Creacion de un archivo ini para leer datos ocultos de estandares base
% Archivo .ini para calibrar los datos
% Los datos iniciales se han guardado en el Excell: calibrar_HD_280_PRO.xlsx
filename = 'calibrar.ini';

fid = fopen(filename, 'w'); % Abrir archivo en modo escritura
fprintf(fid, '[HD_280_PRO_117]\n'); % Sección General
fprintf(fid, 'x = 100, 200, 500, 750, 1000, 1500, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 11000, 12000\n'); % Orden de frecuencias
fprintf(fid, 'y_dere = 86.4, 88.1, 95.7, 95.0, 94.5, 94.8, 99.0, 94.3, 90.3, 90.9, 92.8, 87.3, 89.8, 88.8, 86.2, 79.1, 78.8\n'); % Orden de frecuencias
fprintf(fid, 'y_izq = 87.7, 88.8, 94.6, 93.5, 94.6, 95.8, 100.1, 94.0, 91.2, 92.3, 92.2, 87.0, 87.2, 88.6, 85.6, 81.1, 83.9\n'); % Orden de frecuencias

fclose(fid); % Cerrar archivo