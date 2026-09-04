% COPYRIGHT NOTICE:
%  © 2025 Irene Rodríguez Sánchez. Universidad de Salamanca
%           irene.rodsan@usal.es

%% Creacion de un archivo ini para leer datos ocultos de estandares base
% Datos estandarizados de la equivalencia entre dBSPL y dBHL
filename = 'dBHL.ini';

fid = fopen(filename, 'w'); % Abrir archivo en modo escritura
fprintf(fid, '[dBHL_base]\n'); % Sección General
% Base de datos: ANSI S3.6-2004 (IEC 60318-2 with type 1 adaptor. SennheiserHDA200): https://webstore.ansi.org/standards/asa/ansis32004?srsltid=AfmBOorPfSFIYpGTxUJxeVsG4B1szUffLAuiOOzCbCjT_CaiQli3aC8Q
fprintf(fid, '150 = 30.5\n'); % Frecuencia con su correspondiente nivel de dBSPL
fprintf(fid, '250 = 18\n'); % Frecuencia con su correspondiente nivel de dBSPL
fprintf(fid, '500 = 11\n'); % Frecuencia con su correspondiente nivel de dBSPL
fprintf(fid, '1000 = 5.5\n'); % Frecuencia con su correspondiente nivel de dBSPL
fprintf(fid, '2000 = 4.5\n'); % Frecuencia con su correspondiente nivel de dBSPL
fprintf(fid, '4000 = 9.5\n'); % Frecuencia con su correspondiente nivel de dBSPL
fprintf(fid, '8000 = 17.5\n'); % Frecuencia con su correspondiente nivel de dBSPL
fclose(fid); % Cerrar archivo