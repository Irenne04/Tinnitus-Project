% Ruta a la carpeta donde están los archivos
carpeta = '../Resultados/Prueba3_acufenometria_simulada';  
archivos = dir(fullfile(carpeta, '*_Acufenometria_simulada_*.txt'));

% Archivo de salida
archivoSalida = fullfile(carpeta, 'datos_acufenometria_excel.txt');
fid_out = fopen(archivoSalida, 'w');

for i = 1:length(archivos)
    nombre = archivos(i).name;
    ruta = fullfile(carpeta, nombre);
    
    % Leer contenido del archivo
    texto = fileread(ruta);

    % Buscar datos con expresiones regulares
    frec_real   = regexp(texto, 'Frecuencia_acufeno_real:\s*([0-9.]+)', 'tokens');
    spl_real    = regexp(texto, 'dB_SPL_acufeno_real:\s*([0-9.]+)', 'tokens');
    frec_medida = regexp(texto, 'Frecuencia_acufeno_medida:\s*([0-9.]+)', 'tokens');
    spl_medida  = regexp(texto, 'dB_SPL_acufeno_medida:\s*([0-9.]+)', 'tokens');

    % Extraer ID (después del último "_")
    [~, nombreSinExtension, ~] = fileparts(nombre);
    partes = split(nombreSinExtension, '_');
    if ~isempty(partes)
        identificador = partes{end};
    else
        identificador = 'SIN_ID';
    end

    % Validar que todos los campos existen
    if ~isempty(frec_real) && ~isempty(spl_real) && ~isempty(frec_medida) && ~isempty(spl_medida)
        fprintf(fid_out, '%s\t%s\t%s\t%s\t%s\n', ...
            identificador, ...
            frec_real{1}{1}, ...
            frec_medida{1}{1}, ...
            spl_real{1}{1}, ...
            spl_medida{1}{1});
    else
        fprintf('⚠️ Datos incompletos en archivo: %s\n', nombre);
    end
end

fclose(fid_out);
fprintf('✅ Archivo listo para importar en Excel: %s\n', archivoSalida);
