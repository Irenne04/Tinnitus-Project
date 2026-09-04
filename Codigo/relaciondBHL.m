% COPYRIGHT NOTICE:
%  © 2025 Irene Rodríguez Sánchez. Universidad de Salamanca
%           irene.rodsan@usal.es


function perdida = relaciondBHL(frecuencias, dBSPL)
% Funcion correlacion entre dBHL=funcion(frecuencia, dBSPL)
% Funcion utilizada para la representacion de los dBSPL en el audiograma como dBHL
% Creo el archivo
% Se introduce la frecuencia que es, y el nivel al que se deja de escuchar en dBSPL
% La idea es tomar el valor dBSPL dado y restarle el valor base: Niveles de Presión Sonora de Umbral Equivalente de Referencia (RETSPL) 
% Se compara el valor de frecuencia con frecuencias y se saca el RETSPL
% base con el que se compara
% Se toma la relacion entre ambas escalas en dB mediante estandares (para mas informacion consultar la guia del programa)

% Definir el nombre del archivo del cual se toman los datos base
filename = 'dBHL.ini';

% Abrir archivo en modo lectura
fid = fopen(filename, 'r');
if fid == -1
    error('The file cannot be open %s', filename);
end

% Crear un contenedor (mapa) para almacenar pares frecuencia:valor
dBHL_data = containers.Map('KeyType','double','ValueType','double');

% Leer línea por línea
while ~feof(fid)
    linea = fgetl(fid);
    
    % Ignorar líneas vacías o que comiencen con '[' (cabecera)
    if isempty(linea) || linea(1) == '['
        continue;
    end
    
    % Separar la frecuencia y su valor con '='
    partes = strsplit(linea, '=');
    if length(partes) == 2
        % Convertir frecuencia y valor a número y eliminamos espacios
        frec = str2double(strtrim(partes{1}));
        valor = str2double(strtrim(partes{2}));
        
        % Agregar al mapa
        dBHL_data(frec) = valor;
    end
end

% Cerrar el archivo
fclose(fid);

% Opcional: ordenar ambos vectores (frecuencias y dBSPL) en orden creciente de frecuencia.
% Si no se requiere ordenación, se puede trabajar directamente con los vectores originales.
[frecuencias_sorted, idx] = sort(frecuencias);
dBSPL_sorted = dBSPL(idx);

% Inicializar el vector para almacenar la pérdida (dBSPL - dBHL correspondiente)
perdida = zeros(size(frecuencias_sorted));

% Recorrer cada frecuencia del vector ordenado
for i = 1:length(frecuencias_sorted)
    freq = frecuencias_sorted(i);
    % Verificar si la frecuencia existe en el mapa
    if isKey(dBHL_data, freq)
        % Calcular la pérdida para esa frecuencia
        perdida(i) = dBSPL_sorted(i) - dBHL_data(freq);
    else
        error('Frequency %g Hz is not available in the repository data.', freq);
    end
end


end

