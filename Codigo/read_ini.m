% COPYRIGHT NOTICE:
%  © 2025 Irene Rodríguez Sánchez. Universidad de Salamanca
%           irene.rodsan@usal.es

function config = read_ini(filename)
% Funcion de lectura de los archivos .ini

    %% Abre el archivo para lectura
    fid = fopen(filename, 'r');
    if fid == -1
        error('No se pudo abrir el archivo %s', filename);
    end

    config = struct(); % Estructura para almacenar la configuración
    current_section = ''; % Variable para almacenar la sección actual

    % Lee el archivo línea a línea
    while ~feof(fid)
        line = strtrim(fgetl(fid)); % Lee y elimina espacios en blanco a los extremos
        
        % Ignora líneas vacías o comentarios (puedes usar % o ;)
        if isempty(line) || line(1) == '%' || line(1) == ';'
            continue;
        end
        
        % Detecta una sección (linea que comienza con '[')
        if line(1) == '[' && line(end) == ']'
            current_section = line(2:end-1); % Extrae el nombre de la sección
            config.(current_section) = struct(); % Crea subestructura para esa sección
        else
            % Asume que la línea es del tipo key = value
            tokens = split(line, '=');
            if numel(tokens) >= 2
                key = strtrim(tokens{1});
                % Une el resto (por si hubiera "=" adicionales en el valor)
                value = strtrim(strjoin(tokens(2:end), '='));
                
                % Si el valor contiene comas, intenta convertirlo en vector numérico
                if contains(value, ',')
                    % Separa los valores
                    parts = split(value, ',');
                    % Convierte cada parte a número y forma un vector fila
                    value_num = zeros(1, numel(parts));
                    for i = 1:numel(parts)
                        value_num(i) = str2double(strtrim(parts{i}));
                    end
                    value = value_num;
                else
                    % Intenta convertir a número, si es posible
                    num = str2double(value);
                    if ~isnan(num)
                        value = num;
                    end
                end
                % Guarda en la estructura
                config.(current_section).(key) = value;
            end
        end
    end

    fclose(fid);
end
