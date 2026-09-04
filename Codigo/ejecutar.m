% COPYRIGHT NOTICE:
%  © 2025 Irene Rodríguez Sánchez. Universidad de Salamanca
%           irene.rodsan@usal.es

function ejecutar()
%% Inicio del programa donde se analiza si es ASIO o no, y se crea la interfaz grafica
% Llamamos a la funcion externa para detectar tarjetas de sonido con dispositivos ASIO, dar la opcion de selecionarlo; y dar info del pop up
% del sound card settings

% Posteriormente se crea la interfaz gráfica con los controladores,
% desplegables, los botones informativos, ...

% Se hace una funcion para mostrar las diferentes secciones de cada prueba

% Se crean tres funciones para la activacion de cada una de las pruebas (se
% incluyen mensajes de warnings, errores, ...)

% Se hace tambien un boton de stop para las pruebas, que simula el
% presionar CONTROL+C

% Ademas se debe crear una funcion de guardado de los datos, con un switch
% dependiendo de la prueba que se tome. Los datos se guardan en
% datos_prueba.txt, dicho archivo se encuentra en la misma carpeta del
% programa, y solo sirve para traspasar los datos de la spruebas al archivo
% final de guardado

% Finalmente se crean las tres funciones que dan lugar a cada una de las
% pruebas:
% Dentro de estas se procede a pedir los datos necesarios, y plotear y
% muestrear los resultados. Y luego se procede a crear otras tres funciones
% (para cada prueba) donde se plantea el funcionamiento base de cada
% prueba

%
%
    % Funcion para que al cerrar pregunte si se quieren guardar los datos
    % de manera automatica.
    function FuncionCierre(src, ~)
        respuesta = questdlg('¿Deseas guardar los datos antes de cerrar?', ...
                             'Guardar datos', ...
                             'Sí', 'No', 'Cancelar', ...
                             'Cancelar');
        switch respuesta
            case 'Sí'
                % Codigo para guardar los datos
                callbackExplorarGuardar([], []); 
                disp('Guardando datos...');
                % Cierra la figura después de guardar
                delete(src);
    
            case 'No'
                % Cierra sin guardar
                delete(src);
    
            case 'Cancelar'
                % No hace nada, simplemente no cierra la figura
                disp('Cierre cancelado.');
        end
    end

    soundcardDriver = select_SoundCardDriver();
    % Para sacar si es ASIO o no (1: ASIO; 0: no ASIO)
    asio = soundcardDriver.asio;

    fig = uifigure('Name', 'TinniT_US_play_3: Pantalla controlador','WindowStyle','modal', 'NumberTitle', 'off', ...
            'CloseRequestFcn', @FuncionCierre,'Position', [50, 0, 1000, 700]);
    stop_simulation = false; % reiniciamos los valores del flag
    
    %% Panel de PACIENTE
    % Recuadro de PACIENTE
    p_paciente = uipanel(fig, 'Title', '', 'FontSize', 12, ...
                'BackgroundColor', '#bedcdc', 'Position', [50 450 400 200]);
    uicontrol(fig, 'Style', 'text', 'String', 'PACIENTE', ...
          'FontSize', 12, 'FontWeight', 'bold', ... 
          'BackgroundColor', '#d6f8ff', ...
          'Position', [55 635 100 20]); % Ajusta posición sobre el panel [x y ancho alto]
    
    % Nombre/ID del paciente
    uilabel(p_paciente, 'Text', 'Nombre/ID:', 'Position', [50, 130, 100, 20],'FontSize', 11);
    paciente_ID = uieditfield(p_paciente, 'text', 'Position', [160, 130, 150, 20],'FontSize', 11);

    % Edad del paciente 
    uilabel(p_paciente, 'Text', 'Edad:', 'Position', [50, 100, 100, 20],'FontSize', 11);
    paciente_edad = uieditfield(p_paciente, 'numeric', 'Position', [160, 100, 150, 20],'FontSize', 11);

    % Sexo del paciente
    uilabel(p_paciente, 'Text', 'Sexo:', 'Position', [50, 70, 100, 20],'FontSize', 11);
    paciente_sexo = uidropdown(p_paciente, 'Items', {'Hombre', 'Mujer'}, 'Position', [160, 70, 150, 20],'FontSize', 11);

    % Observaciones del paciente
    uilabel(p_paciente, 'Text', 'Observaciones:', 'Position', [50, 40, 100, 20],'FontSize', 11);
    paciente_observaciones = uieditfield(p_paciente, 'text', 'Position', [160, 40, 150, 20],'FontSize', 11);
    
    %% Panel de USUARIO
    % Recuadro de usuario
    p_usuario = uipanel(fig, 'Title', '', 'FontSize', 12, ...
                'BackgroundColor', '#bedcdc', 'Position', [500 550 400 100]);
    uicontrol(fig, 'Style', 'text', 'String', 'USUARIO', ...
          'FontSize', 12, 'FontWeight', 'bold', ... 
          'BackgroundColor', '#d6f8ff', ...
          'Position', [505 635 100 20]); % Ajusta posición sobre el panel
   
    % ID del usuario
    uilabel(p_usuario, 'Text', 'ID/Usuario:', 'Position', [50, 50, 100, 20],'FontSize', 11);
    usuario_ID = uieditfield(p_usuario, 'text', 'Position', [160, 50, 150, 20],'FontSize', 11);

    % Fecha del usuario
    uilabel(p_usuario, 'Text', 'Fecha:', 'Position', [50, 20, 100, 20],'FontSize', 11);

    % Funciones para poner el calendario
    function actualizarCajaTexto(datePicker, cajaTexto)
        % Obtener la fecha seleccionada en el calendario
        fecha = datePicker.Value;
        % Actualizar el valor de la caja de texto con la nueva fecha
        cajaTexto.Value = datestr(fecha, 'dd-mm-yyyy');
    end
    
    % Obtener la fecha de hoy
    fechaHoy = datetime('today');

    % Crear la caja de texto para mostrar la fecha
    usuario_fecha = uieditfield(p_usuario, 'text', ...
        'Position', [160, 20, 150, 20], ...
        'Value', datestr(fechaHoy, 'dd-mm-yyyy'), ...  % Mostrar la fecha de hoy
        'Editable', 'off');  % Hacer que no sea editable manualmente

    % Crear el selector de fecha 
    datePicker = uidatepicker(p_usuario, ...
        'Position', [320, 20, 18, 20], ...
        'Visible', 'on', ...
        'ValueChangedFcn', @(src, event) actualizarCajaTexto(src, usuario_fecha)); % Se usa para funciones anonimas: donde src es el objeto que ha disparado el evento; el usuario_fecha es el evento; y al lado de pone la funcion a usar cuando disparamos el evento
    
    %% Panel de TIPO DE PRUEBA (TP)
    % Recuadro de TP
    p_prueba = uipanel(fig, 'Title', '', 'FontSize', 12, ...
                'BackgroundColor', '#bedcdc', 'Position', [50 250 400 150]);
    uicontrol(fig, 'Style', 'text', 'String', 'TIPO DE PRUEBA', ...
          'FontSize', 12, 'FontWeight', 'bold', ... 
          'BackgroundColor', '#d6f8ff', ...
          'Position', [55 385 175 20]); % Ajusta posición sobre el panel
    
    % Desplegable de TP
    tipo_prueba = uidropdown(p_prueba, 'Items', {'...', 'Audiometría', 'Acufenometría real', 'Acufenometría simulación'}, ...
                             'Position', [50, 80, 300, 25],'FontSize', 12, ...
                             'ValueChangedFcn', @(src, event) mostrarOpcionesPrueba(asio,soundcardDriver,fig, src));

    % Botón de Stop
    uibutton(p_prueba, 'push', 'Text', 'Stop', 'Position', [220, 20, 100, 30], 'FontSize', 12, 'BackgroundColor','#fc7171',...
             'ButtonPushedFcn', @(btn, event) stopSimulacion(fig));

    %% Panel de OPCIONES SEGÚN PRUEBA (OP) / Parametros de control
    % Recuadro de OP
    p_opciones = uipanel(fig, 'Title', '', 'FontSize', 12, ...
                'BackgroundColor', '#bedcdc', 'Position', [50 50 850 150]);
    p_opciones_title = uicontrol(fig, 'Style', 'text', 'String', 'PARÁMETROS DE PRUEBA', ...
          'FontSize', 12, 'FontWeight', 'bold', ... 
          'BackgroundColor', '#d6f8ff', ...
          'Position', [55 185 250 20]); % Ajusta posición sobre el panel
     
    % Inicialmente lo escondo el panel de parametros
    p_opciones.Visible = 'off';
    p_opciones_title.Visible = 'off';

    % Funcion para crear el uialert que me de la info de los parametros
    % Para la simulacion 1 = hipoacusia
    %'Duración entre señales (ISI): valor de tiempo que se deja entre un sonido y otro (inter-stimulus-interval). Se propone un valor mínimo, y otro máximo para el intervalo de valores de ISI. Se pretende variar el valor de ISI para cada trial, pues se evita que se haga la tarea de manera mecánica.\n\n' ...
    function mostrarAlerta1(fig) 
        uialert(fig, sprintf(['Tiempo de duración: es el tiempo de duración de la señal del sonido que se reproduce. Debe estar en un rango de [0.1, 10]s.\n\n', ...
            'Tipo de cascos: se escoge el modelo de cascos que se usa en las pruebas (recomendable usar los cascos con los que se ha calibrado el programa).\n\n', ...
            'Nivel dB inicial: valor en dB SPL con el que comienza la prueba. Este valor ha de variarse si se trabaja con la serie descendente o ascendente.\n\n', ...
            'Promedio de trials: número de veces que se repite la búsqueda del umbral del nivel de intensidad para una misma frecuencia (se debe poner un valor mayor que uno para obtener fiabilidad de los datos).\n\n', ...
            'Forma de recorrer los dB: es la forma en la que se quiere recorrer el intervalo de dB (de manera ascendente o descendente).\n']), ...
                'Información sobre los parámetros', 'Icon', 'info');
    end

    % Para las simulaciones 2 y 3 = acufenometrias
    %'Porcentaje de Hz: porcentaje de aceptación para el ancho de banda de cada frecuencia.\n\n' ...
    function mostrarAlerta23(fig) 
        uialert(fig, sprintf(['Tiempo de duración: es el tiempo de duración de la señal del sonido que se reproduce. Debe estar en un rango de [0.1, 10]s.\n\n', ...
            'Tipo de cascos: se escoge el modelo de cascos que se usa en las pruebas (recomendable usar los cascos con los que se ha calibrado el programa).\n\n', ...
            'Nivel dB inicial: valor en dB SPL con el que comienza la simulación de la búsqueda de la frecuencia del acúfeno (un valor superior a 50 dB SPL se considera muy alta y damos señal de aviso). Se recomienda introducir el valor obtenido del umbral del paciente que se dio en la prueba de la audiometría tonal.\n\n', ...
            'Frecuencia baja: la mínima frecuencia con la que se empieza la prueba para la serie ascendente.\n\n', ...
            'Frecuencia alta: la máxima frecuencia con la que se empieza la prueba para la serie descendente.\n']), ...
                'Información sobre los parámetros', 'Icon', 'info');
    end

    function mostrarAlerta3(fig) 
        uialert(fig, sprintf(['Tiempo de duración: es el tiempo de duración de la señal del sonido que se reproduce. Debe estar en un rango de [0.1, 10]s.\n\n', ...
            'Tipo de cascos: se escoge el modelo de cascos que se usa en las pruebas (recomendable usar los cascos con los que se ha calibrado el programa).\n\n', ...
            'La señal simulada se escucha por...: se puede escuchar por el mismo oído (ipsilateral) en donde se hace la medida del acúfeno simulado, o por el oído contrario (contralateral).\n\n', ...
            'Nivel dB inicial: valor en dB SPL con el que comienza la simulación de la búsqueda de la frecuencia del acúfeno (un valor superior a 50 dB SPL se considera muy alta y damos señal de aviso). Se recomeinda introducir el valor obtenido del umbral del paciente que se dio en la prueba de la audiometría tonal.\n\n', ...
            'Frecuencia baja: la mínima frecuencia con la que se empiza la prueba para la serie ascendente.\n\n', ...
            'Frecuencia alta: la máxima frecuencia con la que se empieza la prueba para la serie descendente.\n']), ...
                'Información sobre los parámetros', 'Icon', 'info');
    end

    % Botón de informacion de tipo de paramtros de control
    boton_ayuda1=uicontrol(fig,'Style', 'pushbutton', 'String', '?','FontSize', 14, 'FontWeight', 'bold', ... 
          'BackgroundColor', '#06e8fe', 'Position', [860, 160, 30, 30], ...
              'Callback', @(src, event) mostrarAlerta1(fig));

    % Botón de informacion de tipo de paramtros de control
    boton_ayuda23=uicontrol(fig,'Style', 'pushbutton', 'String', '?','FontSize', 14, 'FontWeight', 'bold', ... 
          'BackgroundColor', '#06e8fe', 'Position', [860, 160, 30, 30], ...
              'Callback', @(src, event) mostrarAlerta23(fig));

    % Botón de informacion de tipo de paramtros de control
    boton_ayuda3=uicontrol(fig,'Style', 'pushbutton', 'String', '?','FontSize', 14, 'FontWeight', 'bold', ... 
          'BackgroundColor', '#06e8fe', 'Position', [860, 150, 30, 30], ...
              'Callback', @(src, event) mostrarAlerta3(fig));

    % Lo hacemos no visible al inicio
    boton_ayuda1.Visible = 'off';
    boton_ayuda23.Visible = 'off';
    boton_ayuda3.Visible = 'off';

    %% Panel de informacion 
    % Recuadro de datos
    p_info = uipanel(fig, 'Title', '', 'FontSize', 12, ...
                'BackgroundColor', '#c8cdcd', 'Position', [500 250 400 80]);
   
    % Desplegable de tipo de prueba 1
    p_info_11=uilabel(p_info, 'Text', 'Audiometría: Se realiza primero la audiometría del oído izquierdo. Esta consiste', 'Position', [20, 33, 380, 60],'FontSize', 10);
    p_info_12=uilabel(p_info, 'Text', 'en presentar una serie de frecuencias que irán variando en intensidad (dB SPL)' , 'Position', [20, 20, 370, 60],'FontSize', 10);
    p_info_13=uilabel(p_info, 'Text', 'acotando el intervalo de dB en el que el usuario deja de escuchar el sonido.', 'Position', [20, 7, 370, 60],'FontSize', 10);
    p_info_14=uilabel(p_info, 'Text', 'Se toman tonos puros para esta práctica. Tras realizar la audiometría de', 'Position', [20, -6, 370, 60],'FontSize', 10);
    p_info_15=uilabel(p_info, 'Text', 'ambos oídos se calcúla el PTA.', 'Position', [20, -19, 370, 60],'FontSize', 10);

    % Desplegable de tipo de prueba 2
    p_info_21=uilabel(p_info, 'Text', 'Acufenometría: Se realiza la prueba en el oído que se escoja (ipsilateral', 'Position', [20, 33, 380, 60],'FontSize', 10);
    p_info_22=uilabel(p_info, 'Text', 'o contralateral). Si presentara en ambos oídos, entonces se realiza para ambos.' , 'Position', [20, 20, 370, 60],'FontSize', 10);
    p_info_23=uilabel(p_info, 'Text', 'Se dan dos series (ascendente y descendente), donde se pregunta al participante', 'Position', [20, 7, 370, 60],'FontSize', 10);
    p_info_24=uilabel(p_info, 'Text', 'si es más aguda o grave la frecuencia presentada que la de su acúfeno. Posteriormente,', 'Position', [20, -6, 370, 60],'FontSize', 10);
    p_info_25=uilabel(p_info, 'Text', 'mediante unos botones se intenta igualar la intensidad de su tinitus.', 'Position', [20, -19, 370, 60],'FontSize', 10);

    % Desplegable de tipo de prueba 3
    p_info_31=uilabel(p_info, 'Text', 'Acufenometría prueba: Se realiza la prueba en el oído que se elija.', 'Position', [20, 33, 380, 60],'FontSize', 10);
    p_info_32=uilabel(p_info, 'Text', 'Se pedirá introducir la frecuencia y la intensidad del tinitus' , 'Position', [20, 20, 370, 60],'FontSize', 10);
    p_info_33=uilabel(p_info, 'Text', 'a presentar. El procedimiento es el mismo al de una prueba de acufenometría,', 'Position', [20, 7, 370, 60],'FontSize', 10);
    p_info_34=uilabel(p_info, 'Text', 'salvo el hecho de que el paciente no presentaría el acúfeno, sino', 'Position', [20, -6, 370, 60],'FontSize', 10);
    p_info_35=uilabel(p_info, 'Text', 'que se le simula.', 'Position', [20, -19, 370, 60],'FontSize', 10);

    % Inicialmente lo escondo el panel de parametros
    p_info.Visible = 'off'; % basta con esconder solo el recuadro al que estan asociados
    
   %% Panel de DATOS
    % Recuadro de datos
    p_datos = uipanel(fig, 'Title', '', 'FontSize', 12, ...
                'BackgroundColor', '#bedcdc', 'Position', [500 350 400 150]);
    uicontrol(fig, 'Style', 'text', 'String', 'GUARDAR RESULTADOS', ...
          'FontSize', 12, 'FontWeight', 'bold', ... 
          'BackgroundColor', '#d6f8ff', ...
          'Position', [505 485 200 20]); % Ajusta posición sobre el panel
    
    % Línea de separación
    p_datos_linea = uipanel(p_datos, 'Title', '', 'FontSize', 12, ...
                'Position', [5 75 390 5]);

    % Desplegable de tipo de archivo
    uilabel(p_datos, 'Text', 'Tipo de archivo:', 'Position', [50, 40, 100, 20],'FontSize', 11);
    datos_tipo_archivo = uidropdown(p_datos, 'Items', {'txt', 'csv'}, 'Position', [160, 40, 150, 20],'FontSize', 11);

    % Obtiene el Escritorio como ruta por defecto
    %programDirectory = fullfile(getenv('USERPROFILE'), 'Desktop');  % Para Windows
    %if ~isfolder(programDirectory)  % Compatibilidad Unix/Mac
        %programDirectory = fullfile(getenv('HOME'), 'Desktop');
    %end
    % Ruta de la carpeta donde está esta función
    %programDirectory = fileparts(mfilename('fullpath'));
    programDirectory = pwd;
    programDirectory = fileparts(programDirectory);

    % Ruta a la carpeta ../Programa (una por encima de donde está esta función)
    %programDirectory = fullfile(programDirectory, '..');
    
    % Obtén el directorio donde se encuentra el archivo del script actual
    %programDirectory = fileparts(mfilename('fullpath'));
    
    % Crear un campo de texto editable para mostrar la ruta del programa
    datos_ruta = uicontrol(p_datos, ...
                    'Style', 'edit', ...
                    'String', programDirectory, ...
                    'Position', [130, 10, 180, 20], ...
                    'BackgroundColor', 'white', ...
                    'FontSize', 10, ...
                    'Tag', 'rutaBloque', ...
                    'HorizontalAlignment', 'left', ...
                    'Enable', 'inactive'); % <<< Esto es lo importante
    datos_ruta.Enable = 'off';

   
    % Función para abrir el explorador de archivos y actualizar la ruta
    function nuevaRuta = abrirExplorador(rutaActual)
        if nargin < 1 || isempty(rutaActual)
            rutaActual = pwd; % Si no se pasa ruta, usa el directorio actual
        end
        nuevaRuta = uigetdir(rutaActual, 'Seleccionar nueva ruta');
    end
    
    % Función que guarda datos en la ruta seleccionada
    % Callback unificado para el botón de "Explorar/Guardar datos"
    function callbackExplorarGuardar(btn, ~)
        % Obtiene el Escritorio como ruta por defecto
        %dic = fullfile(getenv('USERPROFILE'), 'Desktop');  % Para Windows
        %if ~isfolder(dic)  % Compatibilidad Unix/Mac
            %dic = fullfile(getenv('HOME'), 'Desktop');
        %end
        % Ruta de la carpeta donde está esta función
        dic = pwd;
        dic = fileparts(dic);
    
        % Ruta a la carpeta ../Programa (una por encima de donde está esta función)
        %dic = fullfile(dic, '..');
    
        % Busca a la carpeta
        % Ruta completa a la carpeta "Resultados"
        datosPruebasPath = fullfile(dic, 'Resultados');

        % Usar como directorio inicial si la carpeta existe
        if isfolder(datosPruebasPath)
            nuevaRuta = dic;
        else
            rutaActual = datos_ruta.String;
            nuevaRuta = abrirExplorador(rutaActual);
        end
        % Abrir diálogo para seleccionar ruta usando la ruta actual
        %rutaActual = datos_ruta.String;
        %nuevaRuta = abrirExplorador(rutaActual);

        % Crear carpeta "datos_pruebas" en la ruta seleccionada
        rutaFinal = fullfile(nuevaRuta, 'Resultados');
        if ~exist(rutaFinal, 'dir')
            mkdir(rutaFinal);
        end

        if nuevaRuta ~= 0
            % Actualizar el campo de texto con la nueva ruta
            datos_ruta.String = rutaFinal;
            % Guardar datos en la ruta nueva
            % Crear una estructura con los datos de control
            datos_control = struct(...
                'Paciente_ID', paciente_ID.Value, ...
                'Paciente_Edad', paciente_edad.Value, ...
                'Paciente_Sexo', paciente_sexo.Value, ...
                'Paciente_Observaciones', paciente_observaciones.Value, ...
                'Usuario_ID', usuario_ID.Value, ...
                'Usuario_Fecha', usuario_fecha.Value, ...
                'Tipo_Prueba', tipo_prueba.Value ...
            );
        
            % Obtener el tipo de prueba seleccionada
            prueba_seleccionada = tipo_prueba.Value;
            %prueba_seleccionada = guardarDatosSimulacion(datos_ruta.String);

            switch prueba_seleccionada
                case 'Audiometría'
                    % Crear carpeta "datos_pruebas" en la ruta seleccionada
                    rutaFinal2 = fullfile(rutaFinal, 'Prueba1_audiometria_tonal');
                    if ~exist(rutaFinal2, 'dir')
                        mkdir(rutaFinal2);
                    end
                case 'Acufenometría real'
                    % Crear carpeta "datos_pruebas" en la ruta seleccionada
                    rutaFinal2 = fullfile(rutaFinal, 'Prueba2_acufenometria_real');
                    if ~exist(rutaFinal2, 'dir')
                        mkdir(rutaFinal2);
                    end
                case 'Acufenometría simulación'
                    % Crear carpeta "datos_pruebas" en la ruta seleccionada
                    rutaFinal2 = fullfile(rutaFinal, 'Prueba3_acufenometria_simulada');
                    if ~exist(rutaFinal2, 'dir')
                        mkdir(rutaFinal2);
                    end
            end

            % Actualizar el campo de texto con la nueva ruta
            datos_ruta.String = rutaFinal2;
            aa = guardarDatosSimulacion(datos_ruta.String);

            % -- Crear una alerta modal para recuperar el foco --
            %uialert(fig, 'Datos guardados correctamente.', 'Guardado', 'Icon', 'success');
            msgbox('Datos guardados correctamente.', 'Guardado', 'help');
        end
        
        % Para reforzar el foco
        %figure(fig);  % <<< Asegura que 'fig' sea la ventana activa
        %drawnow;      % <<< Refresca la GUI para que el cambio sea inmediato
    end
    
    % Crear el botón "Explorar y Guardar datos"
    uibutton(p_datos, 'push', 'Text', 'Explorar y Guardar datos', ...
             'Position', [125, 90, 150, 25], 'FontSize', 12, ...
             'ButtonPushedFcn', @callbackExplorarGuardar);

    % Crear un campo de texto editable para mostrar la ruta del programa
    datos_ruta = uicontrol(p_datos,'Style', 'edit', 'String', programDirectory, 'Position', [130, 10, 180, 20], ...
                      'BackgroundColor', 'white', 'FontSize', 10, 'Tag', 'rutaBloque', ...
                      'HorizontalAlignment', 'left', 'Callback', @(src, event) abrirExplorador(src));

    % Texto para ruta (no tocar, solo dice donde se guarda)
    uilabel(p_datos, 'Text', 'Ruta:', 'Position', [50, 10, 100, 20],'FontSize', 11);

    %% Variables para almacenar datos de simulación
    datos_simulacion1 = struct();
    datos_simulacion2 = struct();
    datos_simulacion3 = struct();
    
    %% Función para mostrar opciones según prueba seleccionada
    function mostrarOpcionesPrueba(asio,soundcardDriver,fig, dropdown)
        % Limpiar el panel de opciones antes de mostrar nuevas opciones
        delete(p_opciones.Children);

        % EL valor del desplegable se guarda en la variable valor
        valor = dropdown.Value;
        switch valor
            case 'Audiometría' 
                % Aparece el menu informativo
                p_info.Visible = 'on';
                p_info_11.Visible = 'on';
                p_info_12.Visible = 'on';
                p_info_13.Visible = 'on';
                p_info_14.Visible = 'on';
                p_info_15.Visible = 'on';
                boton_ayuda1.Visible = 'on';
                boton_ayuda23.Visible = 'off';
                boton_ayuda3.Visible = 'off';

                p_info_21.Visible = 'off';
                p_info_22.Visible = 'off';
                p_info_23.Visible = 'off';
                p_info_24.Visible = 'off';
                p_info_25.Visible = 'off';

                p_info_31.Visible = 'off';
                p_info_32.Visible = 'off';
                p_info_33.Visible = 'off';
                p_info_34.Visible = 'off';
                p_info_35.Visible = 'off';

                % Titulo de la prueba a realizar
                titleText = uilabel(p_opciones, ...
                 'Text', 'Prueba de Hipoacúsia - Audiometría', ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'Position', [275, 130, 500, 20]); % [x, y, ancho, alto]

                % Parametros de acufeno_medicion
                % Tiempo de duracion
                uilabel(p_opciones, 'Text', 'Tiempo de duración:', 'Position', [50, 85, 130, 20]);
                t_durac = uieditfield(p_opciones, 'numeric', 'Position', [190, 70, 60, 20], 'Value', 1.5); % Valor predeterminado
                uilabel(p_opciones, 'Text', 's', 'Position', [255, 70, 130, 20]);
               
                % Sensibilidad / OFFSET
                uilabel(p_opciones, 'Text', 'Tipo de cascos:', 'Position', [50, 45, 130, 20]);
                offset_dB_SPL = uidropdown(p_opciones, 'Items', {'HD280PRO', 'HD26PRO'}, 'Position', [170, 20, 100, 20],'FontSize', 11);

                % Llamar al ini con los datos
                config = read_ini('../ini/config.ini');
                
                % Tomar el valor del offset
                offset_dB_SPL = config.Tipo_casos.(offset_dB_SPL.Value);

                % Línea de separación
                p_datos_linea = uipanel(p_opciones, 'Title', '', 'FontSize', 12, ...
                'Position', [290 5 5 105]);
                
                % Duracion señal
                %uilabel(p_opciones, 'Text', 'Intervalo entre estímulos (ISI):', 'Position', [320, 85, 180, 20]);
                %uilabel(p_opciones, 'Text', '(', 'Position', [340, 60, 130, 20]);
                %duration = uieditfield(p_opciones, 'numeric', 'Position', [350, 60, 60, 20], 'Value', 0.25, 'ValueDisplayFormat', '%.2f');
                %uilabel(p_opciones, 'Text', '-', 'Position', [450, 60, 130, 20]);
                %duration2 = uieditfield(p_opciones, 'numeric', 'Position', [490, 60, 60, 20], 'Value', 1, 'ValueDisplayFormat', '%.2f');
                %uilabel(p_opciones, 'Text', ')', 'Position', [553, 60, 130, 20]);
                %uilabel(p_opciones, 'Text', 's', 'Position', [560, 60, 130, 20]);
                % Nivel de dB inicial
                duration = config.Audio.ISI_ini;
                duration2 = config.Audio.ISI_fin;
                uilabel(p_opciones, 'Text', 'Nivel de inicial en dB SPL:', 'Position', [320, 60, 150, 20]);
                dB_start = uieditfield(p_opciones, 'numeric', 'Position', [490, 40, 60, 20], 'Value', 10, 'ValueDisplayFormat', '%.0f');
                uilabel(p_opciones, 'Text', 'dB SPL', 'Position', [555, 40, 130, 20]);
                % Nivel de dB final
                

                % Línea de separación
                p_datos_linea = uipanel(p_opciones, 'Title', '', 'FontSize', 12, ...
                'Position', [600 5 5 105]);

                % Promedio de trials
                uilabel(p_opciones, 'Text', 'Promedio de trials:', 'Position', [620, 85, 200, 20]);
                promedio = uieditfield(p_opciones, 'numeric', 'Position', [730, 70, 60, 20], 'Value', 3, 'ValueDisplayFormat', '%.0f');

                % Inversion de forma de calcular los promedios
                uilabel(p_opciones, 'Text', 'Forma de recorrer los dB:', 'Position', [620, 45, 300, 20]);
                inversion = uidropdown(p_opciones, 'Items', {'Ascendente', 'Descendente'}, 'Position', [700, 20, 100, 20],'FontSize', 11);

                % Leer el archivo de configuración                
                % Acceder a los datos leídos
                fs = config.General.fs;
                dB_step = config.Audio.pasodB1;
                %dB_step = config.Audio.pasodB2; % Dependiendo del paso que se quiera
     
                % Botón de iniciar simulaicon
                uibutton(p_prueba, 'push', 'Text', 'Start', 'Position', [70, 20, 100, 30], 'FontSize', 12, 'BackgroundColor', '#7ae8a5', ...
             'ButtonPushedFcn', @(btn, event) startSimulacion1(asio,soundcardDriver,fig, t_durac, fs, duration, duration2,offset_dB_SPL,dB_start,dB_step,promedio,inversion,paciente_edad));
            
            case 'Acufenometría real'
                % Oculatamos el menu informativo para el primer programa
                p_info.Visible = 'on';
                p_info_11.Visible = 'off';
                p_info_12.Visible = 'off';
                p_info_13.Visible = 'off';
                p_info_14.Visible = 'off';
                p_info_15.Visible = 'off';

                p_info_21.Visible = 'on';
                p_info_22.Visible = 'on';
                p_info_23.Visible = 'on';
                p_info_24.Visible = 'on';
                p_info_25.Visible = 'on';
                boton_ayuda1.Visible = 'off';
                boton_ayuda23.Visible = 'on';
                boton_ayuda3.Visible = 'off';

                p_info_31.Visible = 'off';
                p_info_32.Visible = 'off';
                p_info_33.Visible = 'off';
                p_info_34.Visible = 'off';
                p_info_35.Visible = 'off';
                            
                % Titulo de la prueba a realizar  
                titleText = uilabel(p_opciones, ...
                 'Text', 'Acufenometría real - Medición del acúfeno del participante', ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'Position', [275, 130, 800, 20]); % [x, y, ancho, alto]

                % Parametros de acufeno_medicion
                % Tiempo de duracion
                uilabel(p_opciones, 'Text', 'Tiempo de duración:', 'Position', [50, 85, 130, 20]);
                t_durac = uieditfield(p_opciones, 'numeric', 'Position', [190, 70, 60, 20], 'Value', 1.5); % Valor predeterminado
                uilabel(p_opciones, 'Text', 's', 'Position', [255, 70, 130, 20]);
               
                % Sensibilidad / OFFSET
                uilabel(p_opciones, 'Text', 'Tipo de cascos:', 'Position', [50, 45, 130, 20]);
                offset_dB_SPL = uidropdown(p_opciones, 'Items', {'HD280PRO', 'HD26PRO'}, 'Position', [170, 20, 100, 20],'FontSize', 11);

                % Llamar al ini con los datos
                config = read_ini('../ini/config.ini');
                
                % Tomar el valor del offset
                sensibilidad = config.Tipo_casos.(offset_dB_SPL.Value);

                % Línea de separación
                p_datos_linea = uipanel(p_opciones, 'Title', '', 'FontSize', 12, ...
                'Position', [290 5 5 105]);
                
                % Duracion señal
                %uilabel(p_opciones, 'Text', 'Duración señal:', 'Position', [320, 80, 130, 20]);
                %duration = uieditfield(p_opciones, 'numeric', 'Position', [490, 80, 60, 20], 'Value', 0.01, 'ValueDisplayFormat', '%.2f');
                %uilabel(p_opciones, 'Text', 's', 'Position', [555, 80, 130, 20]);
                duration = config.General.duration;

                % Porcentaje de aceptacion de Hz
                %uilabel(p_opciones, 'Text', 'Porcentaje de aceptación Hz:', 'Position', [320, 65, 170, 20]);
                %error_freq = uieditfield(p_opciones, 'numeric', 'Position', [490, 65, 60, 20], 'Value', 0.01, 'ValueDisplayFormat', '%.2f');
                %uilabel(p_opciones, 'Text', '%', 'Position', [555, 56, 130, 20]);

                % Nivel de dB
                uilabel(p_opciones, 'Text', 'Nivel sonoro inicial:', 'Position', [320, 60, 150, 20]);
                dB_level = uieditfield(p_opciones, 'numeric', 'Position', [490, 35, 60, 20], 'Value', 20, 'ValueDisplayFormat', '%.0f');
                uilabel(p_opciones, 'Text', 'dB SPL', 'Position', [555, 35, 130, 20]);

                % Línea de separación
                p_datos_linea = uipanel(p_opciones, 'Title', '', 'FontSize', 12, ...
                'Position', [600 5 5 105]);

                % Frecuencias que enfrento
                uilabel(p_opciones, 'Text', 'Frecuencias que enfrento:', 'Position', [620, 72, 200, 20]);

                % Frecuencia baja
                uilabel(p_opciones, 'Text', 'Frecuencia baja:', 'Position', [620, 50, 130, 20]);
                freq1 = uieditfield(p_opciones, 'numeric', 'Position', [730, 50, 60, 20], 'Value', 250, 'ValueDisplayFormat', '%.0f');
                uilabel(p_opciones, 'Text', 'Hz', 'Position', [800, 50, 130, 20]);

                % Frecuencia alta
                uilabel(p_opciones, 'Text', 'Frecuencia alta:', 'Position', [620, 20, 130, 20]);
                freq2 = uieditfield(p_opciones, 'numeric', 'Position', [730, 20, 60, 20], 'Value', 8000, 'ValueDisplayFormat', '%.0f');
                uilabel(p_opciones, 'Text', 'Hz', 'Position', [800, 20, 130, 20]);

                % Leer el archivo de configuración                
                % Acceder a los datos leídos
                fs = config.General.fs;

                % Botón de iniciar simulacion
                uibutton(p_prueba, 'push', 'Text', 'Start', 'Position', [70, 20, 100, 30], 'FontSize', 12, 'BackgroundColor', '#7ae8a5', ...
             'ButtonPushedFcn', @(btn, event) startSimulacion2(asio,soundcardDriver,fig, t_durac, fs, sensibilidad, duration, dB_level, freq1, freq2));

            case 'Acufenometría simulación'
                % Oculatamos el menu informativo para el primer programa
                p_info.Visible = 'on';
                p_info_11.Visible = 'off';
                p_info_12.Visible = 'off';
                p_info_13.Visible = 'off';
                p_info_14.Visible = 'off';
                p_info_15.Visible = 'off';

                p_info_21.Visible = 'off';
                p_info_22.Visible = 'off';
                p_info_23.Visible = 'off';
                p_info_24.Visible = 'off';
                p_info_25.Visible = 'off';

                p_info_31.Visible = 'on';
                p_info_32.Visible = 'on';
                p_info_33.Visible = 'on';
                p_info_34.Visible = 'on';
                p_info_35.Visible = 'on';
                boton_ayuda1.Visible = 'off';
                boton_ayuda23.Visible = 'off';
                boton_ayuda3.Visible = 'on';

                % Titulo de la prueba a realizar
                titleText = uilabel(p_opciones, ...
                 'Text', 'Acufenometría simulación - Medición mediante la simulación del acúfeno para un normoyente', ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'Position', [275, 130, 1000, 20]); % [x, y, ancho, alto]
                
                % Parametros de acufeno_medicion
                    % Tiempo de duracion
                uilabel(p_opciones, 'Text', 'Tiempo de duración:', 'Position', [50, 85, 130, 20]);
                t_durac = uieditfield(p_opciones, 'numeric', 'Position', [190, 70, 60, 20], 'Value', 1.5); % Valor predeterminado
                uilabel(p_opciones, 'Text', 's', 'Position', [255, 70, 130, 20]);
               
                % Sensibilidad / OFFSET
                uilabel(p_opciones, 'Text', 'Tipo de cascos:', 'Position', [50, 45, 130, 20]);
                offset_dB_SPL = uidropdown(p_opciones, 'Items', {'HD280PRO', 'HD26PRO'}, 'Position', [170, 20, 100, 20],'FontSize', 11);

                % Llamar al ini con los datos
                config = read_ini('../ini/config.ini');
                
                % Tomar el valor del offset
                sensibilidad = config.Tipo_casos.(offset_dB_SPL.Value);

                % Línea de separación
                p_datos_linea = uipanel(p_opciones, 'Title', '', 'FontSize', 12, ...
                'Position', [290 5 5 105]);
                
                    % Como simular el acufeno
                uilabel(p_opciones, 'Text', 'Medir en el oído:', 'Position', [320, 80, 130, 20]);
                simular_en = uidropdown(p_opciones, 'Items', {'Ipsilateral', 'Contralateral'}, 'Position', [490, 80, 100, 20],'FontSize', 11);
                %simular_en_value = simular_en.Value;
                duration = config.General.duration;

                    % Porcentaje de aceptacion de Hz
                %uilabel(p_opciones, 'Text', 'Porcentaje de aceptación Hz:', 'Position', [320, 50, 170, 20]);
                %error_freq = uieditfield(p_opciones, 'numeric', 'Position', [490, 50, 60, 20], 'Value', 0.01, 'ValueDisplayFormat', '%.2f');
                %uilabel(p_opciones, 'Text', '%', 'Position', [555, 50, 130, 20]);
                    % Nivel de dB
                uilabel(p_opciones, 'Text', 'Nivel sonoro inicial:', 'Position', [320, 20, 150, 20]);
                dB_level = uieditfield(p_opciones, 'numeric', 'Position', [490, 20, 60, 20], 'Value', 20, 'ValueDisplayFormat', '%.0f');
                uilabel(p_opciones, 'Text', 'dB SPL', 'Position', [555, 20, 130, 20]);

                % Línea de separación
                p_datos_linea = uipanel(p_opciones, 'Title', '', 'FontSize', 12, ...
                'Position', [600 5 5 105]);

                    % Frecuencias que enfrento
                uilabel(p_opciones, 'Text', 'Frecuencias que enfrento:', 'Position', [620, 72, 200, 20]);
                    % Frecuencia baja
                uilabel(p_opciones, 'Text', 'Frecuencia baja:', 'Position', [620, 50, 130, 20]);
                freq1 = uieditfield(p_opciones, 'numeric', 'Position', [730, 50, 60, 20], 'Value', 250, 'ValueDisplayFormat', '%.0f');
                uilabel(p_opciones, 'Text', 'Hz', 'Position', [800, 50, 130, 20]);
                    % Frecuencia alta
                uilabel(p_opciones, 'Text', 'Frecuencia alta:', 'Position', [620, 20, 130, 20]);
                freq2 = uieditfield(p_opciones, 'numeric', 'Position', [730, 20, 60, 20], 'Value', 8000, 'ValueDisplayFormat', '%.0f');
                uilabel(p_opciones, 'Text', 'Hz', 'Position', [800, 20, 130, 20]);

                % Leer el archivo de configuración                
                % Acceder a los datos leídos
                fs = config.General.fs;

                % Botón de iniciar simulacion
                uibutton(p_prueba, 'push', 'Text', 'Start', 'Position', [70, 20, 100, 30], 'FontSize', 12, 'BackgroundColor', '#7ae8a5', ...
             'ButtonPushedFcn', @(btn, event) startSimulacion3(simular_en,asio,soundcardDriver,fig, t_durac, fs, sensibilidad, duration, dB_level, freq1, freq2));
                
            otherwise
                % Ocualtamos los menus
                p_opciones.Visible = 'off';
                p_opciones_title.Visible = 'off';
                boton_ayuda1.Visible = 'off';
                boton_ayuda23.Visible = 'off';
                boton_ayuda3.Visible = 'off';

                p_info.Visible = 'off';
                p_info_11.Visible = 'off';
                p_info_12.Visible = 'off';
                p_info_13.Visible = 'off';
                p_info_14.Visible = 'off';
                p_info_15.Visible = 'off';

                p_info_21.Visible = 'off';
                p_info_22.Visible = 'off';
                p_info_23.Visible = 'off';
                p_info_24.Visible = 'off';
                p_info_25.Visible = 'off';

                p_info_31.Visible = 'off';
                p_info_32.Visible = 'off';
                p_info_33.Visible = 'off';
                p_info_34.Visible = 'off';
                p_info_35.Visible = 'off';

                return;
        end
        p_opciones.Visible = 'on';
        p_opciones_title.Visible = 'on';

    end
    
    %% Funciones para iniciar la simulación
    function startSimulacion1(asio,soundcardDriver,fig, t_durac, fs, duration,duration2,offset_dB_SPL,dB_start,dB_step,promedio,inversion,paciente_edad)
        % Funcion para la simulacion de la hipoacusia
        % Guardar datos de control en un archivo .txt
        %guardarDatosControl();
        
        % Iniciar la simulación según el tipo de prueba
        % Parametros a definir
        t_durac_value = t_durac.Value;
        fs_value = fs;
        offset_dB_SPL_value = offset_dB_SPL;
        duration_value = duration;
        duration_value2 = duration2;
        dB_start_value = dB_start.Value;
        %dB_end_value = dB_end.Value;
        dB_step_value = dB_step;
        promedio_value = promedio.Value;
        inversion_value = inversion.Value;

        % Warnings
        if paciente_edad.Value>154 % ;)
            uialert(fig, sprintf('Creo que el paciente es demasiado mayor para el estudio. ;)'), ...
                'Advertencia', 'Icon', 'warning');
            %return;
        end

        config = read_ini('../ini/config.ini');

        % Acceder a los datos leídos
        ramp_duration = config.Audio.rampa_tiempo;
        seguro = config.Audio.seguro;

        if t_durac_value>10 || t_durac_value<2*ramp_duration % tiempo de duracion (se tiene en cuenta la duracion de la rampa en la señal 50ms)
            uialert(fig, sprintf('El valor del tiempo de duración no debe exceder los 11 s, ni bajar de los %s s.',num2str(2*ramp_duration)), ...
                'Advertencia', 'Icon', 'warning');
            return; % Se pone para que no siga ejecutando y se reinicie la orden anterior
        end

        if dB_start_value<=-20||dB_start_value>seguro % el paso deberia ser de uno en uno en dB
            uialert(fig, sprintf('El valor incial en dBSPL no puede ser menor que -20 dBSPL, o mayor que el valor del seguro auditivo.'), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        %if (dB_end_value<0||dB_step_value>seguro)||(dB_end_value<dB_start_value) % el paso deberia ser de uno en uno en dB
            %uialert(fig, sprintf('El valor final en dBSPL no puede ser negativo, mayor que el valor de seguridad auditivo, o menor que el valor inicial.'), ...
             %   'Advertencia', 'Icon', 'warning');
            %return;
        %end

        if duration_value<0.03 % duracion de la señal en la parte de dB (se pone 0.03 para que no vaya con retardo la deteccion d ela señal)
            uialert(fig, sprintf('Debe ser mayor que cero el tiempo entre estímulos y que 0,03.'), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end
        if duration_value2>10||duration_value2<duration_value % duracion de la señal en la parte de dB (se pone 0.03 para que no vaya con retardo la deteccion d ela señal)
            uialert(fig, sprintf('Debe ser menor que diez segundos.'), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        if offset_dB_SPL_value<94 % OFFSET aclarar que la precision no es buena
            uialert(fig, sprintf('Los cascos utilizados no tienen buena precisión.'), ...
                'Advertencia', 'Icon', 'warning');
            %return; % se le quita pues no es tan importante, solo manda el mensaje pero no me restringe el que no siga ejecutando
        end
        %if offset_dB_SPL_value<0 % OFFSET aclarar que la precision no es buena
            %uialert(fig, sprintf('La presición de los cascos no puede ser negativa.'), ...
                %'Advertencia', 'Icon', 'warning');
            %return; % se le quita pues no es tan importante, solo manda el mensaje pero no me restringe el que no siga ejecutando
        %end

        if promedio_value==1 % promedio de trials
            uialert(fig, sprintf('El número de promedios no debe ser uno, sino se pierde precisión.'), ...
                'Advertencia', 'Icon', 'warning');
            %return;
        end
        if promedio_value<=0 % promedio de trials
            uialert(fig, sprintf('El número de promedios no puede ser negativo.'), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        if promedio_value>10 % promedio de trials
            uialert(fig, sprintf('El número de promedios no debe superar los 10 trials.'), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end
                  
        % Lógica para la prueba de Hipoacúsia
        disp('Iniciando prueba de Audiometría');

        %Para poner la logica de la forma de recorrer
        if strcmp(inversion_value,'Ascendente')
            inversion_v = true;
        elseif strcmp(inversion_value,'Descendente')
            inversion_v = false;
        end

        datos_simulacion1 = hipoacusia(asio,soundcardDriver,inversion_v,promedio_value,offset_dB_SPL_value,t_durac_value,fs_value,dB_start_value,dB_step_value,duration_value,duration_value2);
    end
    function startSimulacion2(asio,soundcardDriver,fig, t_durac, fs, sensibilidad, duration, dB_level, freq1, freq2)
        % Funcion para la simulacion de la acufenos medicion    
        % Guardar datos de control en un archivo .txt
        %guardarDatosControl();
        
        % Parametros a definir
        t_durac_value = t_durac.Value;
        fs_value = fs;
        sensibilidad_value = sensibilidad;
        duration_value = duration;
        %error_freq_value = error_freq.Value;
        dB_level_value = dB_level.Value;
        freq1_value = freq1.Value;
        freq2_value = freq2.Value;

        config = read_ini('../ini/config.ini');

        % Acceder a los datos leídos
        ramp_duration = config.Audio.rampa_tiempo;
        seguro = config.Audio.seguro;
                
        % Warnings
        if freq2_value*2>fs_value || fs_value<0 % para las frecuencias de muestreo
            uialert(fig, sprintf('El valor no puede ser menor que %d.\n Sino la señal no se puede recuperar totalmente.', freq2_value*2), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        if freq2_value>12000 || freq2_value<freq1_value % para las frecuencias de muestreo
            uialert(fig, sprintf('No es una frecuencia válida. El rango válido es (freq_1, 12000).'), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        if freq1_value<125||freq1_value>freq2_value  % para las frecuencias de muestreo
            uialert(fig, sprintf('No es una frecuencia válida. El rango válido es (125, freq_2).'), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        config = read_ini('../ini/config.ini');

        % Acceder a los datos leídos
        ramp_duration2 = config.Audio.rampa_tiempo2;

        if t_durac_value>10 || t_durac_value<2*ramp_duration2 % tiempo de duracion
            uialert(fig, sprintf('El valor del tiempo de duración no debe exceder los 11 s, ni bajar de los %s s.',num2str(2*ramp_duration2)), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        if sensibilidad_value<94 % OFFSET aclarar que la precision no es buena
            uialert(fig, sprintf('Los cascos utilizados no tienen buena precisión.'), ...
                'Advertencia', 'Icon', 'warning');
        end
        %if sensibilidad_value<0 % OFFSET aclarar que la precision no es buena
            %uialert(fig, sprintf('La presición de los cascos no debe ser menor que cero.'), ...
                %'Advertencia', 'Icon', 'warning');
            %return
        %end

        %if error_freq_value>100 || error_freq<0% % de aceptacion de Hz
            %uialert(fig, sprintf('La presición de la frecuencia no es buena.'), ...
            %    'Advertencia', 'Icon', 'warning');
            %return; 
        %end

        %if duration_value<0% duracion de la señal en la parte de dB
            %uialert(fig, sprintf('Debe dar un valor positivo de tiempo entre estímulos. Se aconjesa que sea por debajo de 0.03 s.'), ...
                %'Advertencia', 'Icon', 'warning');
            %return;
        %end

        if dB_level_value>seguro || dB_level_value<0 % duracion de la señal en la parte de dB
            uialert(fig, sprintf('El valor inicial de dB es muy alto, o negativo (recuerde que se trabaja con dBSPL). Se recomienda que el valor inicial en dBSPL se tome superior a la perdida de la prueba de Audiometría.'), ...
                'Advertencia', 'Icon', 'warning');
            return; 
        end

        % Lógica para la prueba de Acúfenos medición
        disp('Iniciando prueba de Acufenometría real');

        datos_simulacion2 = simularAcufenosMedicion(fig,asio,soundcardDriver,t_durac_value, fs_value, sensibilidad_value, duration_value, dB_level_value, freq1_value, freq2_value);
    end
                
    function startSimulacion3(simular_en,asio,soundcardDriver,fig, t_durac, fs, sensibilidad, duration, dB_level, freq1, freq2)
        % Funcion para la simulacion de la acufenos prueba
        % Lógica para la prueba de Acúfenos prueba

        % Guardar datos de control en un archivo .txt
        %guardarDatosControl();

        % Parametros a definir
        t_durac_value = t_durac.Value;
        fs_value = fs;
        sensibilidad_value = sensibilidad;
        duration_value = duration;
        %error_freq_value = error_freq.Value;
        dB_level_value = dB_level.Value;
        freq1_value = freq1.Value;
        freq2_value = freq2.Value;

        config = read_ini('../ini/config.ini');

        % Acceder a los datos leídos
        ramp_duration = config.Audio.rampa_tiempo;
        seguro = config.Audio.seguro;

        % Warnings
        if freq2_value*2>fs_value || fs_value<0 % para las frecuencias de muestreo
            uialert(fig, sprintf('El valor no puede ser menor que %d.\n Sino la señal no se puede recuperar totalmente.', freq2_value*2), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        config = read_ini('../ini/config.ini');

        % Acceder a los datos leídos
        ramp_duration2 = config.Audio.rampa_tiempo2;
        if t_durac_value>10 || t_durac_value<2*ramp_duration2 % tiempo de duracion 
            uialert(fig, sprintf('El valor del tiempo de duración no debe exceder los 11 s, ni bajar de los %s s.',num2str(2*ramp_duration2)), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        if sensibilidad_value<94 % OFFSET aclarar que la precision no es buena
            uialert(fig, sprintf('Los cascos no tienen buena precisión.'), ...
                'Advertencia', 'Icon', 'warning');
        end
        %if sensibilidad_value<0 % OFFSET aclarar que la precision no es buena
            %uialert(fig, sprintf('La presición de los cascos no debe ser negativa.'), ...
                %'Advertencia', 'Icon', 'warning');
            %return
        %end

        %if error_freq_value>100 || error_freq<0% % de aceptacion de Hz
            %uialert(fig, sprintf('La presición de la frecuencia no es buena.'), ...
            %    'Advertencia', 'Icon', 'warning');
            %return; 
        %end

        if freq2_value>12000 || freq2_value<freq1_value % para las frecuencias de muestreo
            uialert(fig, sprintf('No es una frecuencia válida. El rango válido es (freq_1, 12000).'), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        if freq1_value<125||freq1_value>freq2_value  % para las frecuencias de muestreo
            uialert(fig, sprintf('No es una frecuencia válida. El rango válido es (125, freq_2).'), ...
                'Advertencia', 'Icon', 'warning');
            return;
        end

        %if duration_value<0% duracion de la señal en la parte de dB
            %uialert(fig, sprintf('Debe dar un valor positivo de tiempo entre estímulos. Se aconjesa que sea por debajo de 0.03 s.'), ...
                %'Advertencia', 'Icon', 'warning');
            %return;
        %end

        if dB_level_value>seguro || dB_level_value<0 % duracion de la señal en la parte de dB
            uialert(fig, sprintf('El valor inicial de dB es muy alto, o negativo (recuerde que se trabaja con dBSPL). Se recomienda que el valor inicial en dBSPL se tome superior a la perdida de la prueba de Audiometría.'), ...
                'Advertencia', 'Icon', 'warning');
            return; 
        end

        % Logica para la prueba 3: acufenometria prueba
        disp('Iniciando prueba de Acufenometría simulación');

        switch simular_en.Value
            case 'Ipsilateral'
                mismo = 1;
            case 'Contralateral'
                mismo = 0;
        end

        datos_simulacion3 = acufenometria_prueba(mismo,asio,soundcardDriver,fs_value,t_durac_value,sensibilidad_value,freq1_value,freq2_value,dB_level_value,duration_value);
    end
    
    %% Función para detener la simulación (hace lo mismo que el CONTROL+C en la pantalla)
    function stopSimulacion(fig)
        stop_simulation = true;

        % Alerta de deteccion de simulacion
        uialert(fig, sprintf('Prueba detenida.'), ...
                    'Detención de la prueba...', 'Icon', 'error');
        
        % Se manda señal de error por la pantalla de Matlab
        error('Error : Se ha detenido la ejecución.'); 
    end
    
    %% Datos de la simulacion junto con los de control
    function prueba_seleccionada = guardarDatosSimulacion(rutaGuardado)
    % Se asume que estas variables están definidas en el workspace o se
    % pasan de alguna forma: tipo_prueba, datos_tipo_archivo, fig, 
    % datos_simulacion1, datos_simulacion2, datos_simulacion3.

    % Crear una estructura con los datos de control
        datos_control = struct(...
            'Paciente_ID', paciente_ID.Value, ...
            'Paciente_Edad', paciente_edad.Value, ...
            'Paciente_Sexo', paciente_sexo.Value, ...
            'Paciente_Observaciones', paciente_observaciones.Value, ...
            'Usuario_ID', usuario_ID.Value, ...
            'Usuario_Fecha', usuario_fecha.Value, ...
            'Tipo_Prueba', tipo_prueba.Value ...
        );
    
        % Obtener el tipo de prueba seleccionada
        prueba_seleccionada = tipo_prueba.Value;
        
        % Poner la hora
        t = clock;
        hora = t(4);  % Hora
        minuto = t(5); % Minutos
        segundo = t(6); % Segundos
        fecha_str = datestr(datetime('now'), 'yy_mm_dd_');
        identificador = paciente_ID.Value;
        varName1 = sprintf([fecha_str '_%02dh_%02dm_%02ds_Audiometria_' identificador], hora, minuto, round(segundo));
        varName2 = sprintf([fecha_str '_%02dh_%02dm_%02ds_Acufenometria_real_' identificador], hora, minuto, round(segundo));
        varName3 = sprintf([fecha_str '_%02dh_%02dm_%02ds_Acufenometria_simulada_' identificador], hora, minuto, round(segundo));

        % Definir el nombre del archivo base según la prueba
        switch prueba_seleccionada
            case 'Audiometría'
                if ~isempty(fieldnames(datos_simulacion1))
                    if strcmp(datos_tipo_archivo.Value, 'txt')
                        nombreArchivo = fullfile(rutaGuardado, [varName1, '.txt']);
                    elseif strcmp(datos_tipo_archivo.Value, 'csv')
                        nombreArchivo = fullfile(rutaGuardado, [varName1, '.csv']);
                    end

                    %Llamar al .ini para poder sacar los datos de prueba de
                    %cada simulacion
                    datos_prueba = read_ini('datos_prueba.txt');
                
                    % Tomar el valor del offset
                    t_durac_ini = datos_prueba.Datos_prueba.t_durac;
                    offset_dB_SPL_ini = datos_prueba.Datos_prueba.offset_dB_SPL;
                    duration_ini = datos_prueba.Datos_prueba.duration;
                    duration_ini2 = datos_prueba.Datos_prueba.duration2;
                    % Valores de niveles
                    dB_start_ini = datos_prueba.Datos_prueba.dB_start;
                    dB_inicial_ini = datos_prueba.Datos_prueba.dB_inicial;
                    %dB_end_ini = datos_prueba.Datos_prueba.dB_end;
                    promedio_ini = datos_prueba.Datos_prueba.promedio;
                    inversion_ini = datos_prueba.Datos_prueba.inversion;
                    fs_ini = datos_prueba.Datos_prueba.fs;
                    dB_step_ini = datos_prueba.Datos_prueba.dB_step;
                    observa_ini = datos_prueba.Datos_prueba.Observa;
                    t1_ini = datos_prueba.Datos_prueba.t1;
 
                    % Se guardan los datos
                    campos = fieldnames(datos_simulacion1);
                    fid = fopen(nombreArchivo, 'w','n', 'UTF-8'); % Pornelo para que no de caracteres extraños
                    fprintf(fid, '[Datos de control]\n\n'); % Sección General
                    fprintf(fid, 'Paciente ID: %s\n', datos_control.Paciente_ID);
                    fprintf(fid, 'Paciente Edad: %f\n', datos_control.Paciente_Edad);
                    fprintf(fid, 'Paciente Sexo: %s\n', datos_control.Paciente_Sexo);
                    fprintf(fid, 'Paciente Observaciones: %s\n\n', datos_control.Paciente_Observaciones);
                    fprintf(fid, 'Usuario ID: %s\n', datos_control.Usuario_ID);
                    fprintf(fid, 'Usuario Fecha: %s\n', datos_control.Usuario_Fecha);
                    fprintf(fid, 'Tipo de Prueba: %s\n', datos_control.Tipo_Prueba);

                    fprintf(fid, '\n\n\n[Parametros de la prueba]\n\n'); % Sección General
                    fprintf(fid, 'Tipo de duración del tono: %s s\n', num2str(t_durac_ini));
                    fprintf(fid, 'Sensibilidad de los cascos: %s dBSPL\n', num2str(offset_dB_SPL_ini));
                    fprintf(fid, 'ISI (inter-stimulus-interval): (%s - %s) s\n', num2str(duration_ini),num2str(duration_ini2));
                    fprintf(fid, 'Nivel en dBHL para el audiograma: %s dBHL\n', num2str(dB_start_ini));
                    fprintf(fid, 'Nivel en dBSPL incial para la audiometria: %s dBSPL\n', num2str(dB_inicial_ini));
                    %fprintf(fid, 'Nivel en dBSPL final para el audiograma: %s dBSPL\n', num2str(dB_end_ini));
                    fprintf(fid, 'Número de promedios que se hacen para una misma frecuencia: %s\n', num2str(promedio_ini));
                    fprintf(fid, 'Forma de recorrer el intervalo de dBSPL: %s\n', inversion_ini);
                    fprintf(fid, 'Frecuencia de muestreo: %s Hz\n', num2str(fs_ini));
                    fprintf(fid, 'Paso entre dBSPL: %s dBSPL\n', num2str(dB_step_ini));
                    fprintf(fid, 'Observaciones realizadas tras la prueba: %s\n', char(observa_ini));    

                    fprintf(fid, '\n\n\n\n[Resultados de la prueba]\n\n'); % Sección General
                    for i = 1:length(campos)
                        fprintf(fid, '%s: %s\n', campos{i}, num2str(datos_simulacion1.(campos{i})));
                    end
                    fclose(fid);
                    figure(fig);
                    
                    % Mensaje de confirmación
                    %uialert(fig, sprintf('Datos de la simulación guardados en:\n%s', nombreArchivo), ...
                        %'Guardado...', 'Icon', 'info');
                    disp(['Datos de la prueba guardados en: ' nombreArchivo]);
                else
                    % Poner que el mensaje aparezca cuando se haya hecho un
                    % aprueba
                    t2=clock();
                    if t2>t1_ini
                        msgbox('No hay datos de prueba para guardar.', 'Error', 'error');
                    end
                end
                
            case 'Acufenometría real'
                if ~isempty(fieldnames(datos_simulacion2))
                    if strcmp(datos_tipo_archivo.Value, 'txt')
                        nombreArchivo = fullfile(rutaGuardado, [varName2, '.txt']);
                    elseif strcmp(datos_tipo_archivo.Value, 'csv')
                        nombreArchivo = fullfile(rutaGuardado, [varName2, '.csv']);
                    end
                    
                    %Llamar al .ini para poder sacar los datos de prueba de
                    %cada simulacion
                    datos_prueba = read_ini('datos_prueba.txt');
                
                    % Tomar el valor del offset
                    t_durac_ini = datos_prueba.Datos_prueba.t_durac;
                    sensibilidad_ini = datos_prueba.Datos_prueba.sensibilidad;
                    %duration_ini = datos_prueba.Datos_prueba.duration;
                    %error_freq_ini = datos_prueba.Datos_prueba.error_freq;
                    dB_level_ini = datos_prueba.Datos_prueba.dB_level;
                    freq1_ini = datos_prueba.Datos_prueba.freq1;
                    freq2_ini = datos_prueba.Datos_prueba.freq2;
                    fs_ini = datos_prueba.Datos_prueba.fs;
                    observa_ini = datos_prueba.Datos_prueba.Observa;
                    t1_ini = datos_prueba.Datos_prueba.t1;
                    indice_seleccionado = datos_prueba.Datos_prueba.indice_seleccionado;
                    indice_seleccionado = double(indice_seleccionado);
                    if indice_seleccionado==1
                        serie_ascen_izq = datos_prueba.Datos_prueba.Serie_ascendente_izq;
                        serie_descen_izq = datos_prueba.Datos_prueba.Serie_descendente_izq;
                        iter_serie_ascen_izq = datos_prueba.Datos_prueba.Iteraciones_serie_ascendente_izq;
                        iter_serie_descen_izq = datos_prueba.Datos_prueba.Iteraciones_serie_descendente_izq;
                        serie_ascen_dere = datos_prueba.Datos_prueba.Serie_ascendente_dere;
                        serie_descen_dere = datos_prueba.Datos_prueba.Serie_descendente_dere;
                        iter_serie_ascen_dere = datos_prueba.Datos_prueba.Iteraciones_serie_ascendente_dere;
                        iter_serie_descen_dere = datos_prueba.Datos_prueba.Iteraciones_serie_descendente_dere;
                        octava_dere = datos_prueba.Datos_prueba.Octava_dere;
                        octava_izq = datos_prueba.Datos_prueba.Octava_izq;
                        freq_sele_izq = datos_prueba.Datos_prueba.Freq_sele_izq;
                        freq_sele_dere = datos_prueba.Datos_prueba.Freq_sele_dere;
                    else
                        serie_ascen = datos_prueba.Datos_prueba.Serie_ascendente;
                        serie_descen = datos_prueba.Datos_prueba.Serie_descendente;
                        iter_serie_ascen = datos_prueba.Datos_prueba.Iteraciones_serie_ascendente;
                        iter_serie_descen = datos_prueba.Datos_prueba.Iteraciones_serie_descendente;
                        octava = datos_prueba.Datos_prueba.Octava;
                        freq_sele = datos_prueba.Datos_prueba.Freq_sele;
                    end
                    
                    % Se guardan los datos
                    campos = fieldnames(datos_simulacion2);
                    fid = fopen(nombreArchivo, 'w','n', 'UTF-8'); % Pornelo para que no de caracteres extraños
                    fprintf(fid, '[Datos de control]\n\n'); % Sección General
                    fprintf(fid, 'Paciente ID: %s\n', datos_control.Paciente_ID);
                    fprintf(fid, 'Paciente Edad: %f\n', datos_control.Paciente_Edad);
                    fprintf(fid, 'Paciente Sexo: %s\n', datos_control.Paciente_Sexo);
                    fprintf(fid, 'Paciente Observaciones: %s\n\n', datos_control.Paciente_Observaciones);
                    fprintf(fid, 'Usuario ID: %s\n', datos_control.Usuario_ID);
                    fprintf(fid, 'Usuario Fecha: %s\n', datos_control.Usuario_Fecha);
                    fprintf(fid, 'Tipo de Prueba: %s\n', datos_control.Tipo_Prueba);

                    fprintf(fid, '\n\n\n[Parametros de la prueba]\n\n'); % Sección General
                    fprintf(fid, 'Tipo de duración del tono: %s s\n', num2str(t_durac_ini));
                    fprintf(fid, 'Sensibilidad de los cascos: %s dBSPL\n', num2str(sensibilidad_ini));
                    %fprintf(fid, 'ISI (inter-stimulus-interval): %s\n', num2str(duration_ini));
                    %%%%%%%%
                    %fprintf(fid, 'Tasa de aceptación para las frecuencias: %s\n', num2str(error_freq_ini));
                    fprintf(fid, 'Nivel inicial en dBSPL: %s dBSPL\n', num2str(dB_level_ini));
                    fprintf(fid, 'Frecuencia 1: %s Hz\n', num2str(freq1_ini));
                    fprintf(fid, 'Frecuencia 2: %s Hz\n', num2str(freq2_ini));
                    fprintf(fid, 'Frecuencia de muestreo: %s Hz\n', num2str(fs_ini));
                    fprintf(fid, 'Observaciones realizadas tras la prueba: %s\n', char(observa_ini));
                    if indice_seleccionado==1
                        fprintf(fid, 'Serie ascendente para el oído izquierdo: %s\n', (serie_ascen_izq));
                        fprintf(fid, 'Serie descendente para el oído izquierdo: %s\n', (serie_descen_izq));
                        fprintf(fid, 'Número de pasos dados en la serie ascendente del oído izquierdo: %s\n', num2str(iter_serie_ascen_izq));
                        fprintf(fid, 'Número de pasos dados en la serie ascendente del oído izquierdo: %s\n', num2str(iter_serie_descen_izq));
                        fprintf(fid, 'Serie ascendente para el oído derecho: %s\n', num2str(serie_ascen_dere));
                        fprintf(fid, 'Serie descendente para el oído derecho: %s\n', num2str(serie_descen_dere));
                        fprintf(fid, 'Número de pasos dados en la serie ascendente del oído derecho: %s\n', num2str(iter_serie_ascen_dere));
                        fprintf(fid, 'Número de pasos dados en la serie descendente del oído derecho: %s\n', num2str(iter_serie_descen_dere));
                        %fprintf(fid, 'Octava seleccionada del oído derecho: %s\n', num2str(octava_dere));
                        %fprintf(fid, 'Octava seleccionada del oído izquierdo: %s\n', num2str(octava_izq));
                        fprintf(fid, 'Frecuencia seleccionada con el método en el oído izquierdo: %s\n', num2str(freq_sele_izq));
                        fprintf(fid, 'Frecuencia seleccionada con el método en el oído derecho: %s\n', num2str(freq_sele_dere));
                    else
                        fprintf(fid, 'Serie ascendente: %s\n', num2str(serie_ascen));
                        fprintf(fid, 'Serie descendente: %s\n', num2str(serie_descen));
                        fprintf(fid, 'Número de pasos dados en la serie ascendente: %s\n', num2str(iter_serie_ascen));
                        fprintf(fid, 'Número de pasos dados en la serie ascendente: %s\n', num2str(iter_serie_descen));
                        %fprintf(fid, 'Octava seleccionada: %s\n', num2str(octava));
                        fprintf(fid, 'Frecuencia seleccionada con el método: %s\n', num2str(freq_sele));
                    end

                    fprintf(fid, '\n\n\n\n[Resultados de la prueba]\n\n'); % Sección General
                    for i = 1:length(campos)
                        fprintf(fid, '%s: %s\n', campos{i}, num2str(datos_simulacion2.(campos{i})));
                    end
                    fclose(fid);
                    figure(fig);

                    %uialert(fig, sprintf('Datos de la simulación guardados en:\n%s', nombreArchivo), ...
                        %'Guardado...', 'Icon', 'info');
                    disp(['Datos de la prueba guardados en: ' nombreArchivo]);
                else
                    % Poner que el mensaje aparezca cuando se haya hecho un
                    % aprueba
                    t2=clock();
                    if t2>t1_ini
                        msgbox('No hay datos de prueba para guardar.', 'Error', 'error');
                    end
                end
                
            case 'Acufenometría simulación'
                if ~isempty(fieldnames(datos_simulacion3))
                    if strcmp(datos_tipo_archivo.Value, 'txt')
                        nombreArchivo = fullfile(rutaGuardado, [varName3, '.txt']);
                    elseif strcmp(datos_tipo_archivo.Value, 'csv')
                        nombreArchivo = fullfile(rutaGuardado, [varName3, '.csv']);
                    end

                    %Llamar al .ini para poder sacar los datos de prueba de
                    %cada simulacion
                    datos_prueba = read_ini('datos_prueba.txt');
                
                    % Tomar el valor del offset
                    t_durac_ini = datos_prueba.Datos_prueba.t_durac;
                    sensibilidad_ini = datos_prueba.Datos_prueba.sensibilidad;
                    mismo_ini = datos_prueba.Datos_prueba.mismo;
                    %error_freq_ini = datos_prueba.Datos_prueba.error_freq;
                    dB_level_ini = datos_prueba.Datos_prueba.dB_level;
                    freq1_ini = datos_prueba.Datos_prueba.freq1;
                    freq2_ini = datos_prueba.Datos_prueba.freq2;
                    fs_ini = datos_prueba.Datos_prueba.fs;
                    observa_ini = datos_prueba.Datos_prueba.Observa;
                    t1_ini = datos_prueba.Datos_prueba.t1;
                    serie_ascen = datos_prueba.Datos_prueba.Serie_ascendente;
                    serie_descen = datos_prueba.Datos_prueba.Serie_descendente;
                    iter_serie_ascen = datos_prueba.Datos_prueba.Iteraciones_serie_ascendente;
                    iter_serie_descen = datos_prueba.Datos_prueba.Iteraciones_serie_descendente;
                    octava = datos_prueba.Datos_prueba.Octava;
                    freq_sele = datos_prueba.Datos_prueba.Freq_sele;
                    
                    % Se guardan los datos
                    campos = fieldnames(datos_simulacion3);
                    fid = fopen(nombreArchivo, 'w','n', 'UTF-8'); % Pornelo para que no de caracteres extraños
                    fprintf(fid, '[Datos de control]\n\n'); % Sección General
                    fprintf(fid, 'Paciente ID: %s\n', datos_control.Paciente_ID);
                    fprintf(fid, 'Paciente Edad: %f\n', datos_control.Paciente_Edad);
                    fprintf(fid, 'Paciente Sexo: %s\n', datos_control.Paciente_Sexo);
                    fprintf(fid, 'Paciente Observaciones: %s\n\n', datos_control.Paciente_Observaciones);
                    fprintf(fid, 'Usuario ID: %s\n', datos_control.Usuario_ID);
                    fprintf(fid, 'Usuario Fecha: %s\n', datos_control.Usuario_Fecha);
                    fprintf(fid, 'Tipo de Prueba: %s\n', datos_control.Tipo_Prueba);

                    fprintf(fid, '\n\n\n[Datos de prueba]\n\n'); % Sección General
                    fprintf(fid, 'Tipo de duración del tono: %s s\n', num2str(t_durac_ini));
                    fprintf(fid, 'Sensibilidad de los cascos: %s dBSPL\n', num2str(sensibilidad_ini));
                    disp(mismo_ini);
                    if mismo_ini==1
                        fprintf(fid, 'Simulación en el mismo oído (ipsilateral) en el que se mide\n');
                    elseif mismo_ini==0
                        fprintf(fid, 'Simulación en el oído contrario (contralateral) en el que se mide\n');
                    end
                    %%%%%%%%%%%
                    %fprintf(fid, 'Tasa de aceptación para las frecuencias: %s\n', num2str(error_freq_ini));
                    fprintf(fid, 'Nivel inicial en dBSPL: %s dBSPL\n', num2str(dB_level_ini));
                    fprintf(fid, 'Frecuencia 1: %s Hz\n', num2str(freq1_ini));
                    fprintf(fid, 'Frecuencia 2: %s Hz\n', num2str(freq2_ini));
                    fprintf(fid, 'Frecuencia de muestreo: %s Hz\n', num2str(fs_ini));
                    fprintf(fid, 'Observaciones realizadas tras la prueba: %s\n', char(observa_ini));
                    fprintf(fid, 'Serie ascendente: %s\n', num2str(serie_ascen));
                    fprintf(fid, 'Serie descendente: %s\n', num2str(serie_descen));
                    fprintf(fid, 'Número de pasos dados en la serie ascendente: %s\n', num2str(iter_serie_ascen));
                    fprintf(fid, 'Número de pasos dados en la serie ascendente: %s\n', num2str(iter_serie_descen));
                    %fprintf(fid, 'Octava seleccionada: %s\n', num2str(octava));
                    fprintf(fid, 'Frecuencia seleccionada con el método: %s\n', num2str(freq_sele));

                    fprintf(fid, '\n\n\n\n[Datos prueba medidos]\n\n'); % Sección General
                    for i = 1:length(campos)
                        fprintf(fid, '%s: %s\n', campos{i}, num2str(datos_simulacion3.(campos{i})));
                    end
                    fclose(fid);
                    figure(fig);
                    
                    %uialert(fig, sprintf('Datos de la simulación guardados en:\n%s', nombreArchivo), ...
                        %'Guardado...', 'Icon', 'info');
                    disp(['Datos de la prueba guardados en: ' nombreArchivo]);
                else
                    % Poner que el mensaje aparezca cuando se haya hecho un
                    % aprueba
                    t2=clock();
                    if t2>t1_ini
                        msgbox('No hay datos de prueba para guardar.', 'Error', 'error');
                    end
                end
            otherwise
                msgbox('Seleccione un tipo de prueba válido.');
                return;
        end
    end
        
    %% Función para simular Acúfenos Medición
    function datos1 = simularAcufenosMedicion(fig,asio,soundcardDriver,t_durac,fs,sensibilidad,duration,dB_level,freq1,freq2)
        % Lista de opciones para el desplegable de eleccion de tipo de acufeno (asocia el primero a ==1; la segunda opcion como ==2, ...)
        opciones = {'Bilateral', 'Unilateral: Oído izquierdo', 'Unilateral: Oído derecho'};
        
        % Establecer el tamaño de la lista dentro del cuadro de diálogo
        listSize = [200, 100];  % [ancho, alto] en píxeles
        
        % Mostrar cuadro de diálogo con lista de opciones
        [indice_seleccionado, ok] = listdlg('ListString', opciones, ...
                                            'SelectionMode', 'single', ...
                                            'PromptString', '¿Donde quiere medir el acúfeno?', ...
                                            'Name', 'Tipo acúfeno', ...
                                            'ListSize', listSize);  % Controla el tamaño de la lista
        
        % Verificar si el usuario seleccionó algo
        if ok == 1
            disp(['Opción seleccionada: ', opciones{indice_seleccionado}]);
        else
            disp('No se seleccionó ninguna opción.');
            return;
        end

        % Crear la ventana principal
        figi = uifigure('Name', 'Medición del Acúfeno','WindowStyle','modal', 'Position', [100 100 600 400]);
    
        % Recuadros de color
        p_cuadro = uipanel(figi, 'Title', '', 'FontSize', 12, ...
            'BackgroundColor', '#7bd3f7', 'Position', [20 220 560 160], 'Visible', 'off');

        p_cuadro2 = uipanel(figi, 'Title', '', 'FontSize', 12, ...
            'BackgroundColor', '#7bd3f7', 'Position', [20 20 560 180], 'Visible', 'off');
    
        % Mostrar los elementos de la nueva pantalla
        p_cuadro.Visible = 'on';
        p_cuadro2.Visible = 'on';

        % Función de callback para cerrar la figura
        function cerrarFigura(figi) % Si cierro no se guardan los datos
            % Mostrar el cuadro de confirmación
            choice = questdlg('¿Estás seguro de que quieres cerrar la figura?', ...
                'Confirmar cierre', 'Aceptar', 'Cancelar', 'Cancelar');
        
            % Dependiendo de la elección, tomar acción
            switch choice
                case 'Aceptar'
                    disp('Cerrando la interfaz...');
                    % Definir CloseRequestFcn para devolver el foco (cierra la figura, es como CLOSE)
                    %figi.CloseRequestFcn = @(src, event) onChildClosed(src);
                    close(figi);  % Cerrar la figura si el usuario acepta
                    figure(fig);
                case 'Cancelar'
                    disp('Operación cancelada. La figura no se cerrará.');
                    % No hacer nada, simplemente retornar y no cerrar la figura
                otherwise
                    disp('Operación cancelada. La figura no se cerrará.');
            end
        end

        % Función para guardar los graficos
        % Función para guardar los graficos
        function guardarImagen(ax)
            % Ruta de la carpeta donde está esta función
            direct = pwd;
            direct = fileparts(direct);
        
            % Ruta a la carpeta ../Programa (una por encima de donde está esta función)
            %direct = fullfile(direct, '..');
            
            % Obtiene el Escritorio como ruta por defecto
            %direct = fullfile(getenv('USERPROFILE'), 'Desktop');  % Para Windows
            %if ~isfolder(direct)  % Compatibilidad Unix/Mac
                %direct = fullfile(getenv('HOME'), 'Desktop');
            %end

            % Abrir diálogo para seleccionar ruta usando la ruta actual
            rutaActual = direct;
            
    
            % Crear carpeta "datos_pruebas" en la ruta seleccionada
            rutaFinal = fullfile(rutaActual, 'Resultados');
            
            if ~exist(rutaFinal, 'dir')
                mkdir(rutaFinal);
            end

            % Crear carpeta "datos_pruebas" en la ruta seleccionada
            rutaFinal2 = fullfile(rutaFinal, 'Prueba2_acufenometria_real');
            if ~exist(rutaFinal2, 'dir')
                mkdir(rutaFinal2);
            end

            %nuevaRuta = abrirExplorador(rutaFinal2);

            % Seleccionar el archivo y el formato
            [file, ~] = uiputfile({'*.png';'*.jpg';'*.pdf'}, 'Guardar imagen como', rutaActual);
            
            if isequal(file, 0)
                disp('Guardado cancelado.');
            else
                % Guardar el gráfico usando exportgraphics
                filename = fullfile(rutaFinal2, file);
                if isvalid(ax)
                    exportgraphics(ax, filename, 'Resolution', 300);
                else
                    disp('El axes no es válido al intentar exportar.');
                end
                disp(['Imagen guardada en: ', filename]);
            end
        end
   

        % Para hacer promedio en sonoridad
        flag_promedio = 0;
        %%% Lee el valor de promedios que hace para la intensidad
        config = read_ini('../ini/config.ini');
        % Acceder a los datos leídos
        number_promedio = config.Audio.promedio;



        % Lógica para simular el acúfeno según el tipo seleccionado
        if indice_seleccionado == 1 % Bilateral
            % Simulacion del oido izquierdo
            uialert(figi, sprintf('Prueba del oído izquierdo.'), ...
                'Inicio de la prueba...', 'Icon', 'info');
            ear = false;
            uialert(figi, sprintf('Presione los botones "Escuchar Sonido" para escuchar el sonido.\n Presione "Mi tinnitus es más GRAVE" o "Mi tinnitus es más AGUDO" para elegir si el sonido de "Escuchar Sonido" es más agudo o grave que su tinnitus.'), ...
            'Inicio de la prueba...', 'Icon', 'info');
            
            %(333)
            dB_level_real_fin_izq = 0;
            while flag_promedio<number_promedio
                if flag_promedio>0
                    % Se pasan los valores de freq_old determinados la prueba anterior
                    freq_fin = freq_izq;
                    dB_fin = dB_level_izq;
                    % Se hace para guardar las frecuencias y  que no se
                    % vaya
                    if flag_promedio==1
                        freq1_list_guarda = freq1_list1;
                        freq2_list_guarda = freq2_list1;
                        iter_ascen_guarda = iter_ascen1;
                        iter_descen_guarda = iter_descen1;
                    end
                elseif flag_promedio==0
                    freq_fin = 0;
                    dB_fin = 0;
                end
                [freq_izq, dB_level_izq,freq1_list1, freq2_list1,iter_ascen1, iter_descen1,flag_promedio_resul] = medir_acufeno3(dB_fin,freq_fin,flag_promedio, asio,soundcardDriver,figi, ear, t_durac, fs, sensibilidad, freq1, freq2, dB_level);
                flag_promedio = flag_promedio_resul;
                % Se promedia la intensidad
                dB_level_real_fin_izq = dB_level_real_fin_izq + dB_level_izq/3;
            % (333) 
            end

            % Promediamos la intensidad
            dB_level_izq = dB_level_real_fin_izq;
            % Se guardan bien los valores
            freq1_list1 = freq1_list_guarda;
            freq2_list1 = freq2_list_guarda;
            iter_ascen1 = iter_ascen_guarda;
            iter_descen1 = iter_descen_guarda;

            %[freq_izq, dB_level_izq,freq1_list1, freq2_list1,iter_ascen1, iter_descen1] = medir_acufeno(asio,soundcardDriver,figi, ear, t_durac, fs, sensibilidad, freq1, freq2, dB_level);

            % Simulacion del oido dercho
            uialert(figi, sprintf('Prueba del oído derecho.'), ...
                'Inicio de la prueba...', 'Icon', 'info');
            ear = true;
            uialert(figi, sprintf('Presione los botones "Escuchar Sonido" para escuchar el sonido.\n Presione "Mi tinnitus es más GRAVE" o "Mi tinnitus es más AGUDO" para elegir si el sonido de "Escuchar Sonido" es más agudo o grave que su tinnitus.'), ...
            'Inicio de la prueba...', 'Icon', 'info');

            %(333)
            dB_level_real_fin_dere = 0;
            flag_promedio = 0; % se inicializan valores
            while flag_promedio<number_promedio
                if flag_promedio>0
                    % Se pasan los valores de freq_old determinados la prueba anterior
                    freq_fin = freq_dere;
                    dB_fin = dB_level_dere;
                    % Se hace para guardar las frecuencias y  que no se
                    % vaya
                    if flag_promedio==1
                        freq1_list_guarda = freq1_list2;
                        freq2_list_guarda = freq2_list2;
                        iter_ascen_guarda = iter_ascen2;
                        iter_descen_guarda = iter_descen2;
                    end
                elseif flag_promedio==0
                    freq_fin = 0;
                    dB_fin = 0;
                end
                [freq_dere, dB_level_dere,freq1_list2, freq2_list2,iter_ascen2, iter_descen2,flag_promedio_resul] = medir_acufeno3(dB_fin,freq_fin,flag_promedio, asio,soundcardDriver,figi, ear, t_durac, fs, sensibilidad, freq1, freq2, dB_level);
                flag_promedio = flag_promedio_resul;
                % Se promedia la intensidad
                dB_level_real_fin_dere = dB_level_real_fin_dere + dB_level_dere/3;
            % (333) 
            end

            % Promediamos la intensidad
            dB_level_dere = dB_level_real_fin_dere;
            % Se guardan bien los valores
            freq1_list2 = freq1_list_guarda;
            freq2_list2 = freq2_list_guarda;
            iter_ascen2 = iter_ascen_guarda;
            iter_descen2 = iter_descen_guarda;

            %[freq_dere, dB_level_dere,freq1_list2, freq2_list2,iter_ascen2, iter_descen2] = medir_acufeno(asio,soundcardDriver,figi, ear, t_durac, fs, sensibilidad, freq1, freq2, dB_level);

            % Guardamos los datos
            datos1 = struct(...
                'Frecuencia_Izquierdo', freq_izq, ...
                'dB_Izquierdo', dB_level_izq, ...
                'Frecuencia_Derecho', freq_dere, ...
                'dB_Derecho', dB_level_dere, ...
                'Tipo_acufeno', 'Bilateral' ...
            );

            % Alertas de informacion
            uialert(figi, sprintf('Prueba finalizada. Presione "Guardar resultados" en la pantalla de control para guardar los datos.'), ...
            'Fin de la prueba...', 'Icon', 'info');

            uialert(figi, sprintf('Prueba finalizada.\nFrecuencia del acufeno oído izquierdo %.0f Hz\nNivel de dB SPL del acufeno oído izquierdo %.0f dB\nFrecuencia del acufeno oído derecho %.0f Hz\nNivel de dB SPL del acufeno oído derecho %.0f dB', ...
                freq_izq, dB_level_izq, freq_dere, dB_level_dere), ...
                'Fin de la prueba...', 'Icon', 'info');

            % Apagamos para crear la grafica
            p_cuadro2.Visible = 'off';
            p_cuadro.Visible = 'off';

            % Crear un botón para cerrar la figura
            btn2 = uibutton(figi, 'push', 'Text', 'Cerrar', 'Position', [260 10 80 30], 'FontSize', 14,'BackgroundColor', '#ff6060',...
                'ButtonPushedFcn', @(btn2, event) cerrarFigura(figi));         

            % Representación gráfica
            % Se pone un tiempo corto para la representacion
            %t = 0:1/fs:duration; % Tiempo
            %signal_izq = 10^((dB_level_izq - sensibilidad) / 20) * sin(2 * pi * freq_izq * t);
            %signal_dere = 10^((dB_level_dere - sensibilidad) / 20) * sin(2 * pi * freq_dere * t);
        
           % Crear un uiaxes dentro de la UI
            app.UIAxes = uiaxes(figi, 'Position', [50 50 800 300]);
            
            % Configurar el eje X como logarítmico
            set(app.UIAxes, 'XScale', 'log');
            
            % Limitar los ejes para que se vea bien
            min_lim = min(freq1_list1(1),freq1_list2(1));
            max_lim = max(freq2_list1(1),freq2_list2(1));
            xlim(app.UIAxes, [min_lim-50 max_lim+500]);
            xticks(app.UIAxes, [250 500 1000 2000 4000 8000]);
            
            % Preparar iteradores según tamaño de las listas
            iter_a1 = 1:length(freq1_list1); 
            iter_d1 = 1:length(freq2_list1); 
            iter_a2 = 1:length(freq1_list2); 
            iter_d2 = 1:length(freq2_list2);
            
            hold(app.UIAxes, 'on');
            
            % === RELLENAR áreas bajo las curvas con transparencia ===
            
            % Serie ascendente oído izquierdo
            fill(app.UIAxes, [freq1_list1 freq1_list1(end) freq1_list1(1)], ...
                 [iter_a1 0 0], ...
                 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            
            % Serie descendente oído izquierdo
            fill(app.UIAxes, [freq2_list1 freq2_list1(end) freq2_list1(1)], ...
                 [iter_d1 0 0], ...
                 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            
            % Serie ascendente oído derecho
            fill(app.UIAxes, [freq1_list2 freq1_list2(end) freq1_list2(1)], ...
                 [iter_a2 0 0], ...
                 'c', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            
            % Serie descendente oído derecho
            fill(app.UIAxes, [freq2_list2 freq2_list2(end) freq2_list2(1)], ...
                 [iter_d2 0 0], ...
                 'm', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            
            % === Ahora graficamos las curvas con marcadores ===
            if iter_ascen1>iter_descen1
                iter1 = iter_ascen1;
            else
                iter1 = iter_descen1;
            end

            if iter_ascen2>iter_descen2
                iter2 = iter_ascen2;
            else
                iter2 = iter_descen2;
            end

            if iter2>iter1
                iter =iter2;
            else
                iter = iter1;
            end

            iter_vector = 1:iter;
            freq1 = sqrt(freq1_list1(end)*freq2_list1(end));
            freq2 = sqrt(freq1_list2(end)*freq2_list2(end));

            vector_freq2 = freq2 * ones(1, iter);
            vector_freq_dere = freq_dere * ones(1, iter);

            vector_freq1 = freq1 * ones(1, iter);
            vector_freq_izq = freq_izq * ones(1, iter);

            %plot(app.UIAxes, vector_freq_izq, iter_vector, 'yellow--', 'LineWidth', 1.5);
            plot(app.UIAxes, vector_freq1, iter_vector, '--', 'Color', [0.75, 1, 0],'LineWidth', 1.5);
            %plot(app.UIAxes, vector_freq_dere, iter_vector, '--', 'Color', [1, 0.5, 0], 'LineWidth', 1.5);
            plot(app.UIAxes, vector_freq2, iter_vector, '--', 'Color', [1, 0.4, 0.7],'LineWidth', 1.5);

            plot(app.UIAxes, freq1_list1, iter_a1, 'b-o', 'MarkerSize', 6, 'LineWidth', 1.5);
            plot(app.UIAxes, freq2_list1, iter_d1, 'r-s', 'MarkerSize', 6, 'LineWidth', 1.5);
            plot(app.UIAxes, freq1_list2, iter_a2, 'c-o', 'MarkerSize', 6, 'LineWidth', 1.5);
            plot(app.UIAxes, freq2_list2, iter_d2, 'm-s', 'MarkerSize', 6, 'LineWidth', 1.5);           
            
            hold(app.UIAxes, 'off');
            
            % Mejorar la presentación
            title(app.UIAxes, 'Representación de la serie ascendente y descendente');
            ylabel(app.UIAxes, 'Número de iteraciones');
            xlabel(app.UIAxes, 'Frecuencia (Hz)');
            legend(app.UIAxes, {'Serie ascendente oído izquierdo', ...
                                'Serie descendente oído izquierdo', ...
                                'Serie ascendente oído derecho', ...
                                'Serie descendente oído derecho', 'Freq seleccionada izquierrda', ...
                                 'Freq seleccionada derecha'}, 'Location', 'eastoutside');
            ylim(app.UIAxes, [1, iter+1]);
            grid(app.UIAxes, 'on');

    
            % Crear el botón de guardar
            btnGuardar = uicontrol(figi,'Style', 'pushbutton', 'String', 'Guardar', ...
                           'Position', [430 10 80 30], ...
                           'FontSize', 12, 'BackgroundColor', '#3dfe98',...
                           'Callback', @(~,~) guardarImagen(app.UIAxes));
               
        elseif indice_seleccionado == 2 % Unilateral izquierdo
            ear = false;
            % Simulacion del oido izquierdo
            uialert(figi, sprintf('Prueba del oído izquierdo.'), ...
                'Inicio de la prueba...', 'Icon', 'info');
            uialert(figi, sprintf('Presione los botones "Escuchar Sonido" para escuchar el sonido.\n Presione "Mi tinnitus es más GRAVE" o "Mi tinnitus es más AGUDO" para elegir si el sonido de "Escuchar Sonido" es más agudo o grave que su tinnitus.'), ...
            'Inicio de la prueba...', 'Icon', 'info');

            %(333)
            dB_level_real_fin = 0;
            while flag_promedio<number_promedio
                if flag_promedio>0
                    % Se pasan los valores de freq_old determinados la prueba anterior
                    freq_fin = freq_old;
                    %disp('freq fin');
                    %disp(freq_fin);
                    dB_fin = dB_level_real;
                    %disp('dB fin');
                    %disp(dB_fin);
                    % Se hace para guardar las frecuencias y  que no se
                    % vaya
                    if flag_promedio==1
                        freq1_list_guarda = freq1_list;
                        freq2_list_guarda = freq2_list;
                        iter_ascen_guarda = iter_ascen;
                        iter_descen_guarda = iter_descen;
                    end
                elseif flag_promedio==0
                    freq_fin = 0;
                    dB_fin = 0;
                end
                [freq_old, dB_level_real,freq1_list, freq2_list,iter_ascen, iter_descen,flag_promedio_resul] = medir_acufeno3(dB_fin,freq_fin,flag_promedio,asio,soundcardDriver,figi, ear, t_durac, fs, sensibilidad, freq1, freq2, dB_level);
                flag_promedio = flag_promedio_resul;
                %disp('freq final de old');
                %disp(freq_old);

                % Se promedia la intensidad
                %disp('dB final de real y promedio');
                dB_level_real_fin = dB_level_real_fin + dB_level_real/3;
                %disp(dB_level_real);
            % (333)
            end

            % Se promedia la intensidad
            dB_level_real = dB_level_real_fin;
            %disp('dB final promedio');
            %disp(dB_level_real);
            % Se guardan bien los valores
            freq1_list = freq1_list_guarda;
            freq2_list = freq2_list_guarda;
            iter_ascen = iter_ascen_guarda;
            iter_descen = iter_descen_guarda;


            %[freq_old, dB_level_real,freq1_list, freq2_list,iter_ascen, iter_descen] = medir_acufeno(asio,soundcardDriver,figi, ear, t_durac, fs, sensibilidad, freq1, freq2, dB_level);

            % Guardar datos
            %figi.UserData = struct(); % Asegurar que es una estructura
            %figi.UserData.Frecuencia_Izquierdo = freq_old;
            %figi.UserData.dB_Izquierdo = dB_level_real;

            datos1 = struct(...
                'Frecuencia_Izquierdo', freq_old, ...
                'dB_Izquierdo', dB_level_real, ...
                'Tipo_acufeno', 'Unilateral_Oido_izquierdo' ...
            );

            % Alertas de informacion
            uialert(figi, sprintf('Prueba finalizada. Presione "Guardar resultados" en la pantalla de control para guardar los datos.'), ...
            'Fin de la prueba...', 'Icon', 'info');

            uialert(figi, sprintf('Prueba finalizada.\nFrecuencia del acufeno oído izquierdo %.0f Hz\nNivel de dB SPL del acufeno oído izquierdo %.0f dB', ...
                freq_old, dB_level_real), ...
                'Fin de la prueba...', 'Icon', 'info');

            % Empezamos con la grafica 
            p_cuadro2.Visible = 'off';
            p_cuadro.Visible = 'off';

            % Crear un botón para cerrar la figura
            btn2 = uibutton(figi, 'push', 'Text', 'Cerrar', 'Position', [260 10 80 30], 'FontSize', 14,'BackgroundColor', '#ff6060',...
                'ButtonPushedFcn', @(btn2, event) cerrarFigura(figi));

            % Representación gráfica
            %t = 0:1/fs:duration; % Tiempo
            %signal = 10^((dB_level_real - sensibilidad) / 20) * sin(2 * pi * freq_old * t);

            % Crear un uiaxes dentro de la UI
            app.UIAxes = uiaxes(figi, 'Position', [50 50 500 300]);
            
            % Configurar el eje X como logarítmico
            set(app.UIAxes, 'XScale', 'log');
            
            % Limitar los ejes para que se vea bien
            xlim(app.UIAxes, [freq1_list(1)-50 freq2_list(1)+500]);
            xticks(app.UIAxes, [250 500 1000 2000 4000 8000]);
            
            % Preparar iteradores según tamaño de las listas
            iter_a = 1:length(freq1_list); 
            iter_d = 1:length(freq2_list); 
            
            hold(app.UIAxes, 'on');
            
            % === RELLENAR áreas bajo las curvas con transparencia ===
            
            % Serie ascendente oído izquierdo
            fill(app.UIAxes, [freq1_list freq1_list(end) freq1_list(1)], ...
                 [iter_a 0 0], ...
                 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            
            % Serie descendente oído izquierdo
            fill(app.UIAxes, [freq2_list freq2_list(end) freq2_list(1)], ...
                 [iter_d 0 0], ...
                 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

            
            % === Ahora graficamos las curvas con marcadores ===
            if iter_ascen>iter_descen
                iter = iter_ascen;
            else
                iter = iter_descen;
            end
            iter_vector = 1:iter; 
            freq = sqrt(freq1_list(end)*freq2_list(end));
            vector_freq = freq * ones(1, iter);

            vector_freq_old = freq_old * ones(1, iter);
            %plot(app.UIAxes, vector_freq_old, iter_vector, 'yellow--', 'LineWidth', 1.5);
            plot(app.UIAxes, vector_freq, iter_vector, 'magenta--', 'LineWidth', 1.5);
            plot(app.UIAxes, freq1_list, iter_a, 'b-o', 'MarkerSize', 6, 'LineWidth', 1.5);
            plot(app.UIAxes, freq2_list, iter_d, 'r-s', 'MarkerSize', 6, 'LineWidth', 1.5);
               
            hold(app.UIAxes, 'off');
            
            % Mejorar la presentación
            title(app.UIAxes, 'Representación de la serie ascendente y descendente');
            ylabel(app.UIAxes, 'Número de iteraciones');
            xlabel(app.UIAxes, 'Frecuencia (Hz)');
            legend(app.UIAxes, {'Serie ascendente', ...
                                'Serie descendente', 'Freq seleccionada'}, 'Location', 'best');
            ylim(app.UIAxes, [1, iter+1]);
            grid(app.UIAxes, 'on');

            % Crear el botón de guardar
            btnGuardar = uicontrol(figi,'Style', 'pushbutton', 'String', 'Guardar', ...
                           'Position', [430 10 80 30], ...
                           'FontSize', 12, 'BackgroundColor', '#3dfe98',...
                           'Callback', @(~,~) guardarImagen(app.UIAxes));

        elseif indice_seleccionado == 3 % Unilateral derecho
            % Smulacion del oido dercho
            ear = true;
            uialert(figi, sprintf('Prueba del oído derecho.'), ...
                'Inicio de la prueba...', 'Icon', 'info');
            uialert(figi, sprintf('Presione los botones "Escuchar Sonido" para escuchar el sonido.\n Presione "Mi tinnitus es más GRAVE" o "Mi tinnitus es más AGUDO" para elegir si el sonido de "Escuchar Sonido" es más agudo o grave que su tinnitus.'), ...
            'Inicio de la prueba...', 'Icon', 'info');

            %(333)
            dB_level_real_fin = 0;
            while flag_promedio<number_promedio
                if flag_promedio>0
                    % Se pasan los valores de freq_old determinados la prueba anterior
                    freq_fin = freq_old;
                    %disp('freq fin');
                    %disp(freq_fin);
                    dB_fin = dB_level_real;
                    %disp('dB fin');
                    %disp(dB_fin);
                    % Se hace para guardar las frecuencias y  que no se
                    % vaya
                    if flag_promedio==1
                        freq1_list_guarda = freq1_list;
                        freq2_list_guarda = freq2_list;
                        iter_ascen_guarda = iter_ascen;
                        iter_descen_guarda = iter_descen;
                    end
                elseif flag_promedio==0
                    freq_fin = 0;
                    dB_fin = 0;
                end
                [freq_old, dB_level_real,freq1_list, freq2_list,iter_ascen, iter_descen,flag_promedio_resul] = medir_acufeno3(dB_fin,freq_fin,flag_promedio,asio,soundcardDriver,figi, ear, t_durac, fs, sensibilidad, freq1, freq2, dB_level);
                flag_promedio = flag_promedio_resul;
                %disp('freq final de old');
                %disp(freq_old);

                % Se promedia la intensidad
                %disp('dB final de real y promedio');
                dB_level_real_fin = dB_level_real_fin + dB_level_real/3;
                %disp(dB_level_real);
            % (333)
            end

            % Se promedia la intensidad
            dB_level_real = dB_level_real_fin;
            %disp('dB final promedio');
            %disp(dB_level_real);
            % Se guardan bien los valores
            freq1_list = freq1_list_guarda;
            freq2_list = freq2_list_guarda;
            iter_ascen = iter_ascen_guarda;
            iter_descen = iter_descen_guarda;

            %[freq_old, dB_level_real,freq1_list, freq2_list,iter_ascen, iter_descen] = medir_acufeno(asio,soundcardDriver,figi, ear, t_durac, fs, sensibilidad, freq1, freq2, dB_level);

            % Guardar datos 
            datos1 = struct(...
                'Frecuencia_Izquierdo', freq_old, ...
                'dB_Izquierdo', dB_level_real, ...
                'Tipo_acufeno', 'Unilateral_Oido_derecho' ...
            );

            % Alertas de informacion
            uialert(figi, sprintf('Prueba finalizada. Presione "Guardar resultados" en la pantalla de control para guardar los datos.'), ...
            'Fin de la prueba...', 'Icon', 'info');

            uialert(figi, sprintf('Prueba finalizada.\nFrecuencia del acufeno oído izquierdo %.0f Hz\nNivel de dB SPL del acufeno oído izquierdo %.0f dB', ...
                freq_old, dB_level_real), ...
                'Fin de la prueba...', 'Icon', 'info');

            % Se empiza a graficar
            p_cuadro2.Visible = 'off';
            p_cuadro.Visible = 'off';

            % Crear un botón para cerrar la figura
            btn2 = uibutton(figi, 'push', 'Text', 'Cerrar', 'Position', [260 10 80 30], 'FontSize', 14,'BackgroundColor', '#ff6060',...
                'ButtonPushedFcn', @(btn2, event) cerrarFigura(figi));

            % Representación gráfica
            %t = 0:1/fs:duration; % Tiempo
            %signal = 10^((dB_level_real - sensibilidad) / 20) * sin(2 * pi * freq_old * t);

            % Crear un uiaxes dentro de la UI
            app.UIAxes = uiaxes(figi, 'Position', [50 50 500 300]);
            
            % Configurar el eje X como logarítmico
            set(app.UIAxes, 'XScale', 'log');
            
            % Limitar los ejes para que se vea bien
            xlim(app.UIAxes, [freq1_list(1)-50 freq2_list(1)+500]);
            xticks(app.UIAxes, [250 500 1000 2000 4000 8000]);
            
            % Preparar iteradores según tamaño de las listas
            iter_a = 1:length(freq1_list); 
            iter_d = 1:length(freq2_list); 
            
            hold(app.UIAxes, 'on');
            
            % === RELLENAR áreas bajo las curvas con transparencia ===
            
            % Serie ascendente oído izquierdo
            fill(app.UIAxes, [freq1_list freq1_list(end) freq1_list(1)], ...
                 [iter_a 0 0], ...
                 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            
            % Serie descendente oído izquierdo
            fill(app.UIAxes, [freq2_list freq2_list(end) freq2_list(1)], ...
                 [iter_d 0 0], ...
                 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

            
            % === Ahora graficamos las curvas con marcadores ===
            if iter_ascen>iter_descen
                iter = iter_ascen;
            else
                iter = iter_descen;
            end
            iter_vector = 1:iter; 
            freq = sqrt(freq1_list(end)*freq2_list(end));
            vector_freq = freq * ones(1, iter);

            vector_freq_old = freq_old * ones(1, iter);
            %plot(app.UIAxes, vector_freq_old, iter_vector, 'yellow--', 'LineWidth', 1.5);
            plot(app.UIAxes, vector_freq, iter_vector, 'magenta--', 'LineWidth', 1.5);
            plot(app.UIAxes, freq1_list, iter_a, 'b-o', 'MarkerSize', 6, 'LineWidth', 1.5);
            plot(app.UIAxes, freq2_list, iter_d, 'r-s', 'MarkerSize', 6, 'LineWidth', 1.5);
               
            hold(app.UIAxes, 'off');
            
            % Mejorar la presentación
            title(app.UIAxes, 'Representación de la serie ascendente y descendente');
            ylabel(app.UIAxes, 'Número de iteraciones');
            xlabel(app.UIAxes, 'Frecuencia (Hz)');
            legend(app.UIAxes, {'Serie ascendente', ...
                                'Serie descendente',  'Freq seleccionada'}, 'Location', 'best');
            ylim(app.UIAxes, [1, iter+1]);
            xlim(app.UIAxes, [freq1_list(1)-50 freq2_list(1)+500]);
            grid(app.UIAxes, 'on');

            % Crear el botón de guardar
            btnGuardar = uicontrol(figi,'Style', 'pushbutton', 'String', 'Guardar', ...
                           'Position', [430 10 80 30], ...
                           'FontSize', 12, 'BackgroundColor', '#3dfe98',...
                           'Callback', @(~,~) guardarImagen(app.UIAxes));

        end

        % Crear un cuadro de diálogo para escribir un mensaje
        prompt = {'Escribe una observación...'};
        dlg_title = 'Obvervaciones a realizar de la prueba';
        num_lines = 10;
        respuesta = inputdlg(prompt, dlg_title, num_lines);

        % Forzar el foco y visibilidad de figi (uifigure)
        %figi.Visible = 'on';  % Asegura que esté visible
        %drawnow;
        %figi.Position = figi.Position;  % Truco para que Windows lo considere "activo"
        %figure(figi);

        % Guardar los datos en un txt para luego arbrirlos
        filename = 'datos_prueba.txt';
        fid = fopen(filename, 'w','n', 'UTF-8'); % Abrir archivo en modo escritura
        fprintf(fid, '[Datos_prueba]\n'); % Sección General
        fprintf(fid, 't_durac = %1f\n',t_durac); 
        fprintf(fid, 'sensibilidad = %0f\n',sensibilidad);
        fprintf(fid, 'duration = %3f\n',duration);
        %fprintf(fid, 'error_freq = %0f\n',error_freq);
        fprintf(fid, 'dB_level = %0f\n',dB_level);
        fprintf(fid, 'freq1 = %0f\n',freq1);
        fprintf(fid, 'freq2 = %0f\n',freq2);
        fprintf(fid, 'fs = %0f\n',fs);
        fprintf(fid, 'Observa = %s\n',respuesta{:});
        t1=clock;
        fprintf(fid, 't1 = %f\n',t1);
        indice_seleccionado = double(indice_seleccionado);
        fprintf(fid, 'indice_seleccionado = %s\n',indice_seleccionado);

        if indice_seleccionado ==1
            % Para representar el grafico de las elecciones de frecuencias
            if iscell(freq1_list1) %para pasarlo a array si es celda (como esta planteado es solo array)
                freq1_list1 = cell2mat(freq1_list1);
            end
            if iscell(freq2_list1)
                freq2_list1 = cell2mat(freq2_list1);
            end
            fprintf(fid, 'Serie_ascendente_izq = %s\n', num2str(freq1_list1));
            fprintf(fid, 'Serie_descendente_izq = %s\n', num2str(freq2_list1));
            fprintf(fid, 'Iteraciones_serie_ascendente_izq = %0f\n',iter_ascen1);
            fprintf(fid, 'Iteraciones_serie_descendente_izq = %0f\n',iter_descen1);

            if iscell(freq1_list2) %para pasarlo a array si es celda (como esta planteado es solo array)
                freq1_list2 = cell2mat(freq1_list2);
            end
            if iscell(freq2_list1)
                freq2_list2 = cell2mat(freq2_list2);
            end
            fprintf(fid, 'Serie_ascendente_dere = %s\n', num2str(freq1_list2));
            fprintf(fid, 'Serie_descendente_dere = %s\n', num2str(freq2_list2));
            fprintf(fid, 'Iteraciones_serie_ascendente_dere = %0f\n',iter_ascen2);
            fprintf(fid, 'Iteraciones_serie_descendente_dere = %0f\n',iter_descen2);
        else
            % Para representar el grafico de las elecciones de frecuencias
            if iscell(freq1_list) %para pasarlo a array si es celda (como esta planteado es solo array)
                freq1_list = cell2mat(freq1_list);
            end
            if iscell(freq2_list)
                freq2_list = cell2mat(freq2_list);
            end
            fprintf(fid, 'Serie_ascendente = %s\n', num2str(freq1_list));
            fprintf(fid, 'Serie_descendente = %s\n', num2str(freq2_list));
            fprintf(fid, 'Iteraciones_serie_ascendente = %0f\n',iter_ascen);
            fprintf(fid, 'Iteraciones_serie_descendente = %0f\n',iter_descen);
        end
        % Octava confusion
        if indice_seleccionado==1
            fprintf(fid, 'Octava_dere = %s\n', num2str(freq_dere));
            fprintf(fid, 'Octava_izq = %s\n', num2str(freq_izq));
            freq_list_izq = sqrt(freq1_list1(end)*freq2_list1(end));
            freq_list_dere = sqrt(freq1_list2(end)*freq2_list2(end));
            fprintf(fid, 'Freq_sele_izq = %s\n', num2str(freq_list_izq));
            fprintf(fid, 'Freq_sele_dere = %s\n', num2str(freq_list_dere));
        else
            fprintf(fid, 'Octava = %s\n', num2str(freq_old));
            freq_list = sqrt(freq1_list(end)*freq2_list(end));
            fprintf(fid, 'Freq_sele = %s\n', num2str(freq_list));
        end

        fclose(fid); % Cerrar archivo
        figure(fig); 

        % Función de MEDIR EL ACUFENO
        function [freq_old, dB_level_real,freq1_list, freq2_list,iter_ascen, iter_descen,flag_promedio_resul] = medir_acufeno3(dB_fin,freq_fin,flag_promedio,asio,soundcardDriver,figi, ear, t_durac, fs, sensibilidad, freq1, freq2, dB_level)

            % Se ponnen las funciones fuera
            %% Octava confusion
            function selectedFreq = createSoundSelectionDialog(freq_old)
                % Inicializamos la variable de salida
                selectedFreq = [];
                
                % Crear figura emergente como modal
                d = uifigure('Name', 'Octava confusión: Selecciona un sonido', 'Position', [500 500 500 300]);
                d.WindowStyle = 'modal';
                
                % Posiciones X para los tres bloques
                xpos = [100, 250, 380];
            
                % Frecuencias diferentes para cada sonido
                frequencies = [freq_old/2, freq_old, 2*freq_old];  % Ajusta las frecuencias como desees
                
                % Callback para reproducir sonido de comparación
                function playReferenceSound()
                    sonidoASIO(asio, t_durac, ear_fun, fs, dB_level_real, sensibilidad, ramp_duration, freq_old, soundcardDriver);
                end
            
                % Callback para reproducir los sonidos candidatos
                function playSound(freq)
                    sonidoASIO(asio, t_durac, ear_fun, fs, dB_level_real, sensibilidad, ramp_duration, freq, soundcardDriver);
                end
            
                % Callback para cerrar la ventana y devolver la frecuencia seleccionada
                function closeWindow(selectedIndex)
                    selectedFreq = frequencies(selectedIndex); % Se guarda la frecuencia elegida
                    uiresume(d); % Cierra la ventana
                    delete(d);   % Elimina la ventana
                    figure(fig); 
                end
            
                % Texto superior
                uilabel(d, ...
                    'Text', {
                        'Pulse el botón "Sonido". Presione los botones "Sonido 1,2,3"'}, ...
                    'Position', [20 230 460 100], ...
                    'FontSize', 14, ...
                    'HorizontalAlignment', 'center');
                uilabel(d, ...
                    'Text', {
                        'para ver cuál de los tres se parece más al escuchado en el botón de'}, ...
                    'Position', [20 210 460 100], ...
                    'FontSize', 14, ...
                    'HorizontalAlignment', 'center');
                uilabel(d, ...
                    'Text', {
                        '"Sonido". Pulse el botón "Seleccionar Sonido", del "Sonido 1,2,3"'}, ...
                    'Position', [20 190 460 100], ...
                    'FontSize', 14, ...
                    'HorizontalAlignment', 'center');
                uilabel(d, ...
                    'Text', {
                        'que más se haya parecido al escuchado en "Sonido".'}, ...
                    'Position', [20 170 460 100], ...
                    'FontSize', 14, ...
                    'HorizontalAlignment', 'center');
            
                % Botón superior "Sonido" (referencia)
                uibutton(d, 'Text', 'Sonido', ...
                    'Position', [200 160 100 30], ...
                    'ButtonPushedFcn', @(btn, event) playReferenceSound());
            
                % Botones "Sonido 1-3" para reproducir sonidos de comparación
                for i = 1:3
                    uibutton(d, 'Text', ['Sonido ', num2str(i)], ...
                        'Position', [xpos(i)-40, 120, 100, 22], ...
                        'ButtonPushedFcn', @(btn, event) playSound(frequencies(i)));
                end
            
                % Botones "Seleccionar 1-3" para elegir la opción
                for i = 1:3
                    uibutton(d, 'Text', ['Seleccionar', num2str(i)], ...
                        'Position', [xpos(i)-40, 80, 100, 30], ...
                        'ButtonPushedFcn', @(btn, event) closeWindow(i));
                end
            
                % Espera hasta que el usuario haga una selección
                uiwait(d);
            end

            % (333)Parámetros iniciales
            if flag_promedio==0

    
                sonido_selec = false; % Flag para la selección de los sonidos 1 (false) y 2 (true)           
            
                % Para que cambie de color según el oído
                if ear 
                    p_cuadro.BackgroundColor = '#f77d7b';
                    p_cuadro2.BackgroundColor = '#f77d7b';
                else 
                    p_cuadro.BackgroundColor = '#7bd3f7';
                    p_cuadro2.BackgroundColor = '#7bd3f7';
                end
            
                % Limpiar los paneles antes de agregar nuevos elementos
                delete(p_cuadro.Children);
                delete(p_cuadro2.Children);
            
                % Crear nuevas etiquetas y botones
                cartel=uilabel(p_cuadro, 'Text', {'¿Su tinnitus es más grave o', 'más agudo que el sonido que ha escuchado?'}, 'Position', [30, 85, 500, 50],'HorizontalAlignment', 'center','FontSize', 16, 'Visible', 'on');
                freq1Label = uilabel(p_cuadro, 'Position', [60 130 400 30], 'FontSize', 12,'Text', ['Frecuencia: ' num2str(freq1) ' Hz'], 'Visible', 'on');
                serieLabel = uilabel(p_cuadro, 'Position', [375 130 500 30], 'FontSize', 12,'Text', 'Serie: Asendente', 'Visible', 'on');
            
                % Botones para reproducir sonidos
    
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
    
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
    
                % Acceder a los datos leídos
                n_octavas = config.General.Octavas_division;
                ramp_duration = config.Audio.rampa_tiempo;
    
                % Boton de play para escuchar el sonido propuesto
                playSound1Btn = uibutton(p_cuadro, 'push', 'Text', 'Escuchar Sonido', 'Position', [205 45 150 30], ...
                    'ButtonPushedFcn', @(btn, event) sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq1,soundcardDriver), 'Visible', 'on');
                %noear_button = uibutton(p_cuadro, 'push', 'Text', sprintf('Ya no distingo\nlos sonidos'), 'Position', [230 35 90 50], 'BackgroundColor', '#c2d2d2',...
                    %'Visible', 'on');
                %playSound2Btn = uibutton(p_cuadro, 'push', 'Text', 'Escuchar Sonido 2', 'Position', [345 65 150 30], ...
                    %'ButtonPushedFcn', @(btn, event) sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq2,soundcardDriver), 'Visible', 'on');
            
                % Botones para selección del usuario
                selectSound1Btn = uibutton(p_cuadro, 'push', 'Text', 'Mi tinnitus es más GRAVE', 'Position', [50 15 150 30], 'Visible', 'on');
                selectSound2Btn = uibutton(p_cuadro, 'push', 'Text', 'Mi tinnitus es más AGUDO', 'Position', [370 15 150 30], 'Visible', 'on');
            
                % Botón para finalizar
                finishBtn = uibutton(p_cuadro2, 'push', 'Text', 'Finalizar', 'Position', [370 30 100 30], 'Enable', 'off');
            
                % Botón para play
                playBtn = uibutton(p_cuadro2, 'push', 'Text', 'Play', 'Position', [200 30 100 30], 'Enable', 'off');
            
                % Botón para detener
                detenerBtn = uibutton(p_cuadro2, 'push', 'Text', 'Detener', 'Position', [60 30 100 30], 'Enable', 'off');
            
                % Botones para ajustar decibelios (inactivos al inicio)
                increase1dBBtn = uibutton(p_cuadro2, 'push', 'Text', '+2 dB', 'Position', [50 100 100 30], 'Enable', 'off');
                decrease1dBBtn = uibutton(p_cuadro2, 'push', 'Text', '-2 dB', 'Position', [150 100 100 30], 'Enable', 'off');
                increase10dBBtn = uibutton(p_cuadro2, 'push', 'Text', '+5 dB', 'Position', [330 100 100 30], 'Enable', 'off');
                decrease10dBBtn = uibutton(p_cuadro2, 'push', 'Text', '-5 dB', 'Position', [430 100 100 30], 'Enable', 'off');
            
                % Variables internas
                freq_old = 0;
                dB_level_real = dB_level;
                stop_simulation = false;
                sonido_on = true;
                stop_sonido = false;
            
                % Callbacks
                selectSound1Btn.ButtonPushedFcn = @select_sound1;
                selectSound2Btn.ButtonPushedFcn = @select_sound2;
                playSound1Btn.ButtonPushedFcn = @play_s1;
                %playSound2Btn.ButtonPushedFcn = @play_s2;
                %noear_button.ButtonPushedFcn = @fin_sonido;
                finishBtn.ButtonPushedFcn = @finalizar;
                playBtn.ButtonPushedFcn = @play;
                detenerBtn.ButtonPushedFcn = @detener;
                increase1dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(2);
                decrease1dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(-2);
                increase10dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(5);
                decrease10dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(-5);
    
       
                % Bucle principal de búsqueda de la frecuencia
                % Trabajamos con OCTAVAS
                %function flag = octavas(freq1,freq2, error_freq)
                    %flag = false;
                    %error_freq1 = freq1 * error_freq;
                    %error_freq2 = freq2 * error_freq; % error de la frecuencia promedio geometrico
                    %if ((freq2-error_freq2)<freq1)||((freq1+error_freq1)>freq2)
                        %flag = true;
                    %end
                %end
    
                %flag = octavas(freq1,freq2, error_freq);
    
                % Flags para cambiar el tipo de serie (descendente o
                % ascendente)
                ascendente = true; % se empieza por la serie ascendente
                %descendente = false;
    
                % Flags para decir cuando termino de hacer cada serie
                flag_ascen = false; % desactivo ambas banderas pues no tengo inversion
                flag_descen = false;
    
                % Flag para poner solo un mensaje
                ban_men_1 = 0;
                ban_men_2 = 0;
    
                % Flags para determinar si se da inversion
                agudo = true; % flag para la serie descendente (debe ser false para dar inversion)
                grave = true; % flag para la serie ascendente (debe ser false para dar inversion)
    
                % Inicializo los contadores
                iter_ascen = 1;
                iter_descen = 1;
    
                % Inicializo las listas
                freq1_list = [];
                freq2_list = [];
                % Valores de las frecuencias extremo 
                freq1_list(iter_ascen) = freq1;
                freq2_list(iter_descen) = freq2;
    
                while (stop_sonido==false) || ((flag_descen==false)||(flag_ascen==false))
                    uiwait(figi); % Esperar a que el usuario seleccione una opción
     
                    if ascendente
                        if ~flag_ascen 
                            % Cambio de etiquetas 
                            freq1Label.Text = ['Frecuencia: ', num2str(freq2, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                            serieLabel.Text = 'Serie: Descendente';
    
                            if flag_descen
                                % Cambio de etiquetas 
                                freq1Label.Text = ['Frecuencia: ', num2str(freq1, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                serieLabel.Text = 'Serie: Ascendente';
                            end
    
                            freq_nueva_ascen = freq1/n_octavas  + freq1; % renombramos la frecuencia de la serie ascenddente (un sexto de octava por encima)
                            
                            if ~sonido_selec
                                flag_ascen = true; % bandera para que se acabe toda la serie
                                %ascendente = false; % bandera para que cambie a la otra serie
                            else
                                iter_ascen = iter_ascen + 1; % Cuento el numero de iteraciones
                                freq1 = freq_nueva_ascen; % Cambio la frecuencia
                                freq1_list(end+1) = freq1; % Guardo la frecuencia en una lista
                            end
    
                            if flag_descen
                                % Cambio de etiquetas 
                                freq1Label.Text = ['Frecuencia: ', num2str(freq1, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                serieLabel.Text = 'Serie: Ascendente';
                            end
    
                        end
                        
                        if ~flag_descen
                            % Pongo la bandera para que salte a la otra serie
                            ascendente = false;
                        end
                    else
                        if ~flag_descen
                            % Cambio de etiquetas 
                            freq1Label.Text = ['Frecuencia: ', num2str(freq1, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                            serieLabel.Text = 'Serie: Ascendente';
    
                            if flag_ascen
                                % Cambio de etiquetas 
                                freq1Label.Text = ['Frecuencia: ', num2str(freq2, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                serieLabel.Text = 'Serie: Descendente';
                            end
    
                            freq_nueva_descen = freq2 - freq2/n_octavas ; % renombramos la frecuencia de la serie descendiente 
                            
                            if sonido_selec % (agudo, salimos)
                                flag_descen = true; % bandera para que se acabe toda la serie
                                %ascendente = false; % bandera para que cambie a la otra serie
                            else % (grave) mantenemos
                                iter_descen = iter_descen + 1; % Cuento el numero de iteraciones
                                freq2 = freq_nueva_descen; % Cambio la frecuencia
                                freq2_list(end+1) = freq2; % Guardo la frecuencia en una lista
                            end
                            
                            if flag_ascen
                                % Cambio de etiquetas 
                                freq1Label.Text = ['Frecuencia: ', num2str(freq2, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                serieLabel.Text = 'Serie: Descendente';
                            end
    
                        end
    
                        if ~flag_ascen
                            % Pongo la bandera para que salte a la otra serie
                            ascendente = true;     
                        end
                    end
    
                    % LIMITES
                    % Poner limite para las frecuencias para no pasar la frecuencia
                    % del otro extremo
                    if (freq2_list(1)<freq1) % Limite para la serie ascendente
                        % Si paso de 8000 (caso inicial) entonces cortar serie
                        % y mandar mensaje de error
                        flag_ascen = true; % bandera para que se acabe toda la serie
                        if ban_men_1==0
                            hh = msgbox('Se ha superado el valor extremo de la serie ascendente. Por favor, aumente el valor de "frecuencia alta" en la pantalla de controlador para poder realizar la prueba correctamente para sus valores.','Error', 'error');
                            uiwait(hh);
                            ban_men_1 = ban_men_1 + 1;
                            % Definir CloseRequestFcn para devolver el foco (cierra la figura, es como CLOSE)
                            %figi.CloseRequestFcn = @(src, event) onChildClosed(src);
                            close(figi);
                            figure(fig); 
                        end
                    elseif (freq1_list(1)>freq2) % Limite para la serie descendente
                        % Si paso por debajo de 250 (caso inicial) entonces cortar serie
                        flag_descen = true; % bandera para que se acabe toda la serie
                        if ban_men_2 ==0
                            hh = msgbox('Se ha superado el valor extremo de la serie descendente. Por favor, disminuya el valor de "frecuencia baja" en la pantalla de controlador para poder realizar la prueba correctamente para sus valores.','Error', 'error');
                            uiwait(hh);
                            ban_men_2 = ban_men_2 + 1;
                            % Definir CloseRequestFcn para devolver el foco (cierra la figura, es como CLOSE)
                            %figi.CloseRequestFcn = @(src, event) onChildClosed(src);
                            close(figi);
                            figure(fig); 
                        end
                    end
    
                    % Condicion para hacer la media geometrica en vez de
                    % guardar el valor de freq_old
                    if stop_sonido %|| flag
                        freq_old = sqrt(freq1*freq2);
                    end
    
                    if ((flag_ascen==true)&&(flag_descen==true))
                        break;
                    end
    
                end
    
                % Guarda la frecuencia como la media geometrica de las dos
                % frecuencias de cada serie
                if ((flag_ascen==true)&&(flag_descen==true))
                    freq_old = sqrt(freq1*freq2);
                end
            
                %% Actualización de los valores de frecuencia y dB para la segunda parte
                freqLabel = uilabel(p_cuadro2, 'Position', [125 150 200 30], 'Text', ['Frecuencia: ' num2str(freq_old, '%.1f') ' Hz']);
                dBLabel = uilabel(p_cuadro2, 'Position', [300 150 200 30], 'Text', ['Nivel: ' num2str(dB_level_real, '%.0f') ' dB SPL']);
            
                % Activar botones de ajuste de decibelios
                increase1dBBtn.Enable = 'on';
                selectSound1Btn.Enable = 'off';
                selectSound2Btn.Enable = 'off';
                playSound1Btn.Enable = 'off';
                %playSound2Btn.Enable = 'off';
                %noear_button.Enable = 'off';
                decrease1dBBtn.Enable = 'on';
                increase10dBBtn.Enable = 'on';
                decrease10dBBtn.Enable = 'on';
                finishBtn.Enable = 'on';
                playBtn.Enable = 'on';
                detenerBtn.Enable = 'on';
    
                % Quitar de visible
                freq1Label.Visible = 'off';
                serieLabel.Visible = 'off';
                cartel.Visible = 'off';
                cartel=uilabel(p_cuadro, 'Text', {'Deternime la intensidad del su tinnitus'}, 'Position', [30, 85, 500, 50],'HorizontalAlignment', 'center','FontSize', 16, 'Visible', 'on');
            
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
                % Acceder a los datos leídos
                ramp_duration = config.Audio.rampa_tiempo;
                ramp_duration2 = config.Audio.rampa_tiempo2;
                seguro_dB = config.Audio.seguro;
                inicio_dB = config.Audio.dB_ini;
                % Ponemos un contador
    
    
                % Hacer un if para cuando se pase la octava de 12000, no se
                % haga la tercera opcion
                if (ban_men_1>0) || (ban_men_2>0)
                    % Si esto ocurre, entonces se ha dado corte de las series
                    % porque no se ha podido alcanzar el valor deseado, se
                    % cierra todo
                    error('Se ha cortado la serie, se pide variar los valores de las frecuencias baja o alta de la pantalla de control para poder realizar la prueba.');
                end
    
                
                
                % QUITO LA OCTAVA CONFUSION
                % Uso de la función 
                %if (ban_men_1==0) && (ban_men_2==0) % Si se da corte por que no se ha alcanzado el valor deseado, se sale de todo y no deja que se de lo de octava confusion
                    %freq_old = createSoundSelectionDialog(freq_old);
                %end
    
            % (333) si se cumple entonces no se hace
    
            elseif flag_promedio>0
                % Ajustamos frecuencia
                freq_old = freq_fin; % Damos la frecuencia obtenida antes
                % Ajustamos intensidad
                dB_level_real = dB_fin;
                % Ponemos banderas
                stop_sonido = true; % Para que entre en el if de la segunda parte
                flag_ascen = true;
                flag_descen = true;
                % Se hace para que no salga vacio
                freq1_list = [];
                freq2_list = [];
                iter_ascen = 0;
                iter_descen = 0;
    
                %% Resto del codigo
                %sonido_selec = false; % Flag para la selección de los sonidos 1 (false) y 2 (true)           
        
                % Para que cambie de color según el oído
                if ear 
                    p_cuadro.BackgroundColor = '#f77d7b';
                    p_cuadro2.BackgroundColor = '#f77d7b';
                else 
                    p_cuadro.BackgroundColor = '#7bd3f7';
                    p_cuadro2.BackgroundColor = '#7bd3f7';
                end
            
                % Limpiar los paneles antes de agregar nuevos elementos
                delete(p_cuadro.Children);
                delete(p_cuadro2.Children);
            
                % Crear nuevas etiquetas y botones
                cartel=uilabel(p_cuadro, 'Text', {'Deternime la intensidad del su tinnitus'}, 'Position', [30, 85, 500, 50],'HorizontalAlignment', 'center','FontSize', 16, 'Visible', 'on');
                %freq1Label = uilabel(p_cuadro, 'Position', [60 130 400 30], 'FontSize', 12,'Text', ['Frecuencia: ' num2str(freq1) ' Hz'], 'Visible', 'on');
                %serieLabel = uilabel(p_cuadro, 'Position', [375 130 500 30], 'FontSize', 12,'Text', 'Serie: Asendente', 'Visible', 'on');
            
                % Botones para reproducir sonidos
    
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
    
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
    
                % Acceder a los datos leídos
                n_octavas = config.General.Octavas_division;
                ramp_duration = config.Audio.rampa_tiempo;
    
                % Boton de play para escuchar el sonido propuesto
                playSound1Btn = uibutton(p_cuadro, 'push', 'Text', 'Escuchar Sonido', 'Position', [205 45 150 30], ...
                    'ButtonPushedFcn', @(btn, event) sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq1,soundcardDriver), 'Visible', 'on');
                playSound1Btn.Enable = 'off';
                %noear_button = uibutton(p_cuadro, 'push', 'Text', sprintf('Ya no distingo\nlos sonidos'), 'Position', [230 35 90 50], 'BackgroundColor', '#c2d2d2',...
                    %'Visible', 'on');
                %playSound2Btn = uibutton(p_cuadro, 'push', 'Text', 'Escuchar Sonido 2', 'Position', [345 65 150 30], ...
                    %'ButtonPushedFcn', @(btn, event) sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq2,soundcardDriver), 'Visible', 'on');
            
                % Botones para selección del usuario
                selectSound1Btn = uibutton(p_cuadro, 'push', 'Text', 'Mi tinnitus es más GRAVE', 'Position', [50 15 150 30], 'Visible', 'on');
                selectSound2Btn = uibutton(p_cuadro, 'push', 'Text', 'Mi tinnitus es más AGUDO', 'Position', [370 15 150 30], 'Visible', 'on');
                selectSound1Btn.Enable = 'off';
                selectSound2Btn.Enable = 'off';
            
                % Botón para finalizar
                finishBtn = uibutton(p_cuadro2, 'push', 'Text', 'Finalizar', 'Position', [370 30 100 30], 'Enable', 'off');
            
                % Botón para play
                playBtn = uibutton(p_cuadro2, 'push', 'Text', 'Play', 'Position', [200 30 100 30], 'Enable', 'off');
            
                % Botón para detener
                detenerBtn = uibutton(p_cuadro2, 'push', 'Text', 'Detener', 'Position', [60 30 100 30], 'Enable', 'off');
            
                % Botones para ajustar decibelios (inactivos al inicio)
                increase1dBBtn = uibutton(p_cuadro2, 'push', 'Text', '+2 dB', 'Position', [50 100 100 30], 'Enable', 'off');
                decrease1dBBtn = uibutton(p_cuadro2, 'push', 'Text', '-2 dB', 'Position', [150 100 100 30], 'Enable', 'off');
                increase10dBBtn = uibutton(p_cuadro2, 'push', 'Text', '+5 dB', 'Position', [330 100 100 30], 'Enable', 'off');
                decrease10dBBtn = uibutton(p_cuadro2, 'push', 'Text', '-5 dB', 'Position', [430 100 100 30], 'Enable', 'off');
            
                % Variables internas
                %freq_old = 0;
                %dB_level_real = dB_level;
                stop_simulation = false;
                sonido_on = true;
                stop_sonido = false;
            
                % Callbacks
                selectSound1Btn.ButtonPushedFcn = @select_sound1;
                selectSound2Btn.ButtonPushedFcn = @select_sound2;
                playSound1Btn.ButtonPushedFcn = @play_s1;
                %playSound2Btn.ButtonPushedFcn = @play_s2;
                %noear_button.ButtonPushedFcn = @fin_sonido;
                finishBtn.ButtonPushedFcn = @finalizar;
                playBtn.ButtonPushedFcn = @play;
                detenerBtn.ButtonPushedFcn = @detener;
                increase1dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(2);
                decrease1dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(-2);
                increase10dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(5);
                decrease10dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(-5);
    
    
               
            
                %% Actualización de los valores de frecuencia y dB para la segunda parte
                freqLabel = uilabel(p_cuadro2, 'Position', [125 150 200 30], 'Text', ['Frecuencia: ' num2str(freq_old, '%.1f') ' Hz']);
                dBLabel = uilabel(p_cuadro2, 'Position', [300 150 200 30], 'Text', ['Nivel: ' num2str(dB_level_real, '%.0f') ' dB SPL']);
            
                % Activar botones de ajuste de decibelios
                increase1dBBtn.Enable = 'on';
                selectSound1Btn.Enable = 'off';
                selectSound2Btn.Enable = 'off';
                playSound1Btn.Enable = 'off';
                %playSound2Btn.Enable = 'off';
                %noear_button.Enable = 'off';
                decrease1dBBtn.Enable = 'on';
                increase10dBBtn.Enable = 'on';
                decrease10dBBtn.Enable = 'on';
                finishBtn.Enable = 'on';
                playBtn.Enable = 'on';
                detenerBtn.Enable = 'on';
    
                % Quitar de visible
                %freq1Label.Visible = 'off';
                %serieLabel.Visible = 'off';
                %cartel.Visible = 'off';
                %cartel=uilabel(p_cuadro, 'Text', {'Deternime la intensidad del su tinnitus'}, 'Position', [30, 85, 500, 50],'HorizontalAlignment', 'center','FontSize', 16, 'Visible', 'on');
            
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
                % Acceder a los datos leídos
                ramp_duration = config.Audio.rampa_tiempo;
                ramp_duration2 = config.Audio.rampa_tiempo2;
                seguro_dB = config.Audio.seguro;
                inicio_dB = config.Audio.dB_ini;
                % Ponemos un contador
    
    
            end

            %% Determinación del nivel de dB (búsqueda del nivel de dB)
            if ((flag_ascen==true)&&(flag_descen==true))|| (stop_sonido==true)
                    %uialert(figi, sprintf('Presione los botones "+/- 2 dB" o "+/- 5 dB" para variar la intensidad de la señal y hacer que se parezca a su acúfeno.'), ...
                %'Inicio de la prueba...', 'Icon', 'info');
                % Funcion para tocar continuo (toca frame by frame), en este caso t_durac es la rapidez de respuesta.
                % Tipo_prueba: puede ser 3 simula el acufeno en cuestion
                % asio dice si es prueba de sonido con ASIO o con windows.
                % Aunque no estemos con la prueba3, se debe introducir la frecuencia y los
                % dB del acufeno como si simulara, datos aleatorios, o cero.

                % Pone la etiqueta que es
                uialert(figi, ...
                    sprintf(['TRIAL %d: Presione los botones "+/- 2 dB" o "+/- 5 dB" ' ...
                             'para variar la intensidad de la señal y hacer que se parezca a su acúfeno. ' ...
                             'Se realizan varios trials para promediar la intensidad resultante.'], flag_promedio+1), ...
                    sprintf('Inicio de la prueba (trial %d)', flag_promedio+1), ...
                    'Icon', 'info');
                
                % Asignamos valores / para cambio de notación
                level = dB_level_real;  % Nivel dinámico que puede cambiar
                lmax = sensibilidad;
                frequency = freq_old;
                
                % Configuración de la tarjeta de sonido
                channels = soundcardDriver.channels;
                nbits = soundcardDriver.nbits;
                buffersize = soundcardDriver.buffersize;
                chL = soundcardDriver.channelLeft; % 1
                chR = soundcardDriver.channelRight; % 2
                soundcard = soundcardDriver.soundcard;
                
                if asio
                % Configurar el reproductor de audio (se saca fuera para crearlo solo una vez)
                nbits_txt = sprintf('%d-bit integer', nbits);
                aPR = audioPlayerRecorder('Device', soundcard{1,1},...
                                          'SampleRate', fs,...
                                          'BitDepth', nbits_txt,...
                                          'SupportVariableSize', true,...
                                          'BufferSize', buffersize);
                end
                % Se inicializa para quitar la rampa de los demas sonidos intermedios
                idx = 0;
                % Bucle principal
                while  ~stop_simulation%~finishBtn.UserData % (lo primero es para el codigo normal, lo segundo para el run_sonido)  %~stop_simulation
                    % Actualizar etiquetas dinámicamente
                    freqLabel.Text = ['Frecuencia: ' num2str(freq_old, '%.0f') ' Hz'];
                    dBLabel.Text = ['Nivel de dB SPL: ' num2str(dB_level_real, '%.0f') ' dB'];
                    
                    if sonido_on
                        % Generar la señal para el frame actual
                        t = (0:1/fs:t_durac)';  % Vector de tiempo para el frame actual
                        signal = sin(2 * pi * freq_old * t);  % Señal sinusoidal
                        %%% Acufeno simulado
                        %%%signal_acu = sin(2 * pi * freq_acu * t);  % Señal sinusoidal

                        % Aplicar el nivel dinámico (level puede cambiar en cada iteración)
                        dB_out=calibrar_dB_HD_280_PRO(ear_fun, freq_old, dB_level_real);
                        signal = SetSignalLevel(signal, dB_out, lmax);
                        %signal = SetSignalLevel(signal, dB_level_real, lmax);
                        %%% Acufeno simulado
                        %%%signal_acu = SetSignalLevel(signal_acu, dB_acu, lmax);
                    
                        % GUardamos la señal sin rampa
                        signal_sin = signal; % señal de por medio sin rampa para ASIO
                        %%% Acufeno simulado
                        %%%signal_acu_sin = signal_acu; % señal sin rampa (para ASIO) del acufeno
                    
                        % Aplicar rampa de subida/bajada
                        signal = ramp(signal, 1/fs, 'cos', 'updown', ramp_duration); % señal inicial con rampa normal
                        signal_noasio_medio = ramp(signal, 1/fs, 'cos', 'updown', ramp_duration2); % señal de por medio con mas rampa para NO ASIO
                        %%% Acufeno simulado
                        %%%signal_acu = ramp(signal_acu, 1/fs, 'cos', 'updown', ramp_duration); % señal inicial con rampa normal pra NO ASIO acu
                        %%%signal_acu_noasio_medio = ramp(signal_acu, 1/fs, 'cos', 'updown', ramp_duration2); %señal con mas rampa para acu NO ASIO
                        
                    
                        % Reproducir con o sin ASIO
                        if asio
                            % Preparar la señal para la tarjeta de sonido (canales izquierdo/derecho)
                            player_input = repmat(zeros(size(signal(:,1))), 1, channels);
                            player_input_sin = repmat(zeros(size(signal_sin(:,1))), 1, channels);
                            switch ear_fun
                                case 'dere' % Se mide por el derecho
                                    player_input(:, chR) = signal;
                                    player_input_sin(:, chR) = signal_sin;
                                    %%% Acufeno simulado
                                    %%%player_input(:, chL) = signal_acu;
                                    %%%player_input_sin(:, chL) = signal_acu_sin;
                                case 'izq' % Se mide por el izquierdo
                                    player_input(:, chL) = signal;
                                    player_input_sin(:, chL) = signal_sin;
                                    %%% Acufeno simulado
                                    %%%player_input(:, chR) = signal_acu;
                                    %%%player_input_sin(:, chR) = signal_acu_sin;
                                case 'ambos' % Caso no util pero da sonido por ambos
                                    %%% Acufeno simulado
                                    player_input(:, chL) = signal;%+signal_acu;
                                    player_input(:, chR) = signal;%+signal_acu;
                                    player_input_sin(:, chR) = signal_sin;%+signal_acu_sin;
                                    player_input_sin(:, chL) = signal_sin;%+signal_acu_sin;
                                otherwise
                                    error('invalid input argument');
                            end
                    
                            % Reproducir el frame actual
                            if idx==0 || stop_simulation==true % COn rampa ramp_duration1
                                [~, nUnderruns, nOverruns] = aPR(player_input);  % Reproduce el frame con rampa
                            else  % Sin rampa
                                [~, nUnderruns, nOverruns] = aPR(player_input_sin); % Reproduce sin rampa
                            end

                            % Verificar underruns/overruns
                            if nUnderruns > 0
                                warning('Audio player queue was underrun by %d samples.\n', nUnderruns);
                            end
                            if nOverruns > 0
                                fprintf('Audio recorder queue was overrun by %d samples.\n', nOverruns);
                            end

                        else
                            switch ear_fun
                                case 'dere' % Se mide por el derecho
                                    % Comentar para el caso de la prueba 3
                                    player_input = [zeros(size(signal)),signal];
                                    player_input_sin = [zeros(size(signal_noasio_medio)),signal_noasio_medio];
                                    %%% Acufeno simulado
                                    % Descomentar para el caso de al prueba 3
                                    %%%player_input_acu = [signal_acu,signal];
                                    %%%player_input_sin_acu = [signal_acu_noasio_medio,signal_noasio_medio];
                                case 'izq' % Se mide por el izquierdo
                                    player_input = [signal,zeros(size(signal))];
                                    player_input_sin = [signal_noasio_medio,zeros(size(signal_noasio_medio))];
                                    %%% Acufeno simulado
                                    %%%player_input_acu = [signal,signal_acu];
                                    %%%player_input_sin_acu = [signal_noasio_medio,signal_acu_noasio_medio];
                                case 'ambos' % Caso no util pero da sonido por ambos
                                    player_input = [signal,signal];
                                    player_input_sin = [signal_noasio_medio,signal_noasio_medio];
                                    %%% Acufeno simulado
                                    %%%player_input_acu = [signal+signal_acu,signal+signal_acu];
                                    %%%player_input_sin_acu = [signal_noasio_medio+signal_acu_noasio_medio,signal_noasio_medio+signal_acu_noasio_medio];
                                otherwise
                                    error('invalid input argument');
                            end
                            % Reproducir el frame actual dependiendo de si es inicial o no el frame
                            if idx==0 || stop_simulation==true % Rampa de ramp_duration1
                                sound(player_input,fs);
                                %%% Acufeno simulado
                                %%%sound(player_input_acu,fs);
                                pause(t_durac-ramp_duration2); %duration = t_durac - ramp_duration
                            else 
                                sound(player_input_sin,fs); % Rampa de ramp_duration2
                                %%% Acufeno simulado
                                %%%sound(player_input_sin_acu,fs);
                                pause(t_durac-ramp_duration2); %duration = t_durac - ramp_duration
                            end
                        end
                                      
                        % Permitir que MATLAB procese eventos de la interfaz gráfica
                        drawnow;
                    
                        % Pausa breve para permitir interacción con la GUI
                        %pause(t_durac-ramp_duration2); % Ponerlo por debajo de la escucha del SH
                    end
                
                    % Actualizar etiquetas dinámicamente
                    freqLabel.Text = ['Frecuencia: ' num2str(freq_old, '%.0f') ' Hz'];
                    dBLabel.Text = ['Nivel de dB SPL: ' num2str(dB_level_real, '%.0f') ' dB'];

                    % Condicion de seguridad
                    if dB_level_real>=seguro_dB
                        stop_simulation = true;
                        warning('Se ha alcanzado la máxima intesidad en dB SPL.')
                    end
                
                    % Se pone contador para determinar cuando hay rampa
                    idx = idx +1;
                    drawnow;
                end
                

                %%
                if asio
                    release(aPR); % (Meter fuera del while) Se libera el sonido (si lo quito no hace nada con respecto a la latencia)
                end

            end

            % (333) Y se iguala para poder tomar el valor final como el
            % (333) promedio
            %dB_level_real = dB_level_real_fin;
            flag_promedio = flag_promedio + 1;
            %disp(flag_promedio);
            flag_promedio_resul = flag_promedio;

            %end
            % (333) final del if del flag_promedio
            



            % Callback para finalizar la simulación
            function finalizar(~, ~)
                stop_simulation = true;
            end

            % Funcion para parar cuando se escuche igual
            function fin_sonido(~, ~)
                stop_sonido = true;
                uiresume(figi);
            end
        
            % Callback para ajustar los niveles de decibelios
            function adjust_dB(change)
                dB_level_real = dB_level_real + change;
            end
        
            % Callback para seleccionar Sonido 1 (GRAVE)
            function select_sound1(~, ~)
                %freq_old = freq1;
                sonido_selec = false;
                uiresume(figi);
            end
        
            % Callback para seleccionar Sonido 2 (AGUDO)
            function select_sound2(~, ~)
                %freq_old = freq2;
                sonido_selec = true;
                uiresume(figi);
            end
        
            % Callback para seleccionar play
            function play(~, ~)
                sonido_on = true;
                %uiresume(fig);
            end
        
            % Callback para seleccionar detener
            function detener(~, ~)
                sonido_on = false;
                %uiresume(fig);
            end
        
            % Callback para reproducir Sonido 1
            function play_s1(~, ~)
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
                % Acceder a los datos leídos
                ramp_duration = config.Audio.rampa_tiempo;

                if ascendente %(se pone el valor de la serie ascendente en la freq1)
                    sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq1,soundcardDriver)
                else %(se pone el valor de la serie descendente en la freq1)
                    sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq2,soundcardDriver)
                end

                
            end
        
            % Callback para reproducir Sonido 2
            function play_s2(~, ~)
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
                % Acceder a los datos leídos
                ramp_duration = config.Audio.rampa_tiempo;

                sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq2,soundcardDriver)
            end
        end
    end
    %% Función para simular Audiometria
    function datos = hipoacusia(asio,soundcardDriver,inversion,promedios,offset_dB_SPL,t_durac,fs,dB_start,dB_step,duration,duration2)
        % Inicialización de variables       
        config = read_ini('../ini/config.ini');

        seguro_dB = config.Audio.seguro;
        % Se va a usar para el audiograma inicial
        % dB_start se usara para eel inicion de la prueba
        inicio_dB = config.Audio.dB_ini; % para el audiograma
        min_dB = config.Audio.min_dB; %valor minimo para la prueba descendente

        % Acceder a los datos leídos
        freq_order = config.General.freq_order; % Es un vector
        frequencies = [freq_order(1),freq_order(2),freq_order(3),freq_order(4),freq_order(5),freq_order(6)];
        dB_values_izq = zeros(1, length(frequencies)); % Vector para almacenar los valores de dB SPL (oído izquierdo)
        dB_values_dere = zeros(1, length(frequencies)); % Vector para almacenar los valores de dB SPL (oído derecho)
        current_frequency_idx = 1; % Índice de la frecuencia actual
        stop_simulation = false; % Flag para detener la simulación
        cambio_frequency = false; % Flag para cambiar de frecuencia
        play_flag = false; % Flag para comenzar
        ear = false; % Flag para el oído que se simula (false = izquierdo, true = derecho)
        reiniciar_flag = false; % Flag para reiniciar todo
        k = 0; % Índice para finalizar toda la simulación después de pasar del oído izquierdo (k=0) al oído derecho (k=1)
        index = 0; % Flag de promedios
        
        % Rango de dB SPL (desde -dB_start dB SPL hasta el nivel máximo definido por el offset, ponemos 94 dB SPL)
        %dB_end = seguro_dB; % Nivel máximo de dB SPL (para no danar)
        % Se establece un nuevo valor por seguridad
        %if dB_end>seguro_dB
            %msgbox('El sonido umbral superior supera el valor de seguridad auditiva.','Error', 'error');
        dB_end = seguro_dB;
        dB_inicial = dB_start;
        %end
        %dB_inicial = dB_start; % Valor inicial para empezar la hipoacusia
    
        % Crear la ventana principal de la GUI
        hFig = uifigure('Name', 'Prueba de Señal', 'WindowStyle','modal','NumberTitle', 'off', 'Position', [300, 300, 600, 400]);

        % Recuadro del color del oido que se simula en el momento (se
        % empieza por el izquierdo)
        p_cuadro = uipanel(hFig, 'Title', '', 'FontSize', 12, ...
                'BackgroundColor', '#7bd3f7', 'Position', [10 160 580 220],'Visible','on');
        
        % Separdor
        p_cuadro2 = uipanel(p_cuadro, 'Title', '', 'FontSize', 12, ...
                'Position', [20 150 540 5],'Visible','on');
    
        % Mostrar la frecuencia actual
        hFrequencyText = uicontrol(p_cuadro,'Style', 'text', 'BackgroundColor', '#7bd3f7','Position', [50, 90, 500, 30], 'FontSize', 12, ...
            'String', sprintf('Frecuencia actual: %d Hz', frequencies(current_frequency_idx)),'Visible','on');
    
        % Mostrar los dB actuales
        hDbText = uicontrol(p_cuadro,'Style', 'text','BackgroundColor', '#7bd3f7', 'Position', [50, 20, 500, 30], 'FontSize', 12, 'String', ['Nivel: ' num2str(dB_inicial, '%.0f') ' dB SPL'],'Visible','on');
    
        % Mostrar el oído actual
        hEarText = uicontrol(p_cuadro,'Style', 'text', 'BackgroundColor', '#7bd3f7','Position', [50, 170, 500, 30], 'FontSize', 14, ...
            'String', sprintf('Oído: %s', getEarText(ear)),'Visible','on');
    
        % Botón para detener la simulación
        hStopButton = uicontrol(hFig,'Style', 'pushbutton', 'BackgroundColor', '#ff8e8c','Position', [50, 80, 150, 30], 'String', 'Detener', ...
            'Callback', @stopButtonCallback);
    
        % Botón para comenzar con la siguiente frecuencia
        hNextButton = uicontrol(hFig,'Style', 'pushbutton', 'BackgroundColor', '#a6ff8c','Position', [250, 80, 150, 30], 'String', 'Play', ...
            'Enable', 'on', 'Callback', @nextButtonCallback);
    
        % Botón para reiniciar
        hReiniciarButton = uicontrol(hFig,'Style', 'pushbutton', 'Position', [450, 80, 100, 30], 'String', 'Reiniciar', ...
            'Callback', @reiniciarCallback);
    
        % Mensaje para indicar que se empieza con la simulación
        if inversion % Asscendente
            uialert(hFig, sprintf('La prueba comienza con el oído izquierdo. Recuerde que tras iniciar comenzará a sonar la primera frecuencia aumentando su intensidad gradualmente. Cuando empiece a escuchar el sonido pulse "detener". Posteriormente, puede volver a pulsar "play" para continuar con la presentanción de más sonidos de la prueba.'), ...
                'Inicio de la prueba...', 'Icon', 'info');
        else
            uialert(hFig, sprintf('La prueba comienza con el oído izquierdo. Recuerde que tras iniciar comenzará a sonar la primera frecuencia disminuye su intensidad gradualmente. Cuando deje de escuchar el sonido pulse "detener". Posteriormente, puede volver a pulsar "play" para continuar con la presentanción de más sonidos de la prueba.'), ...
                'Inicio de la prueba...', 'Icon', 'info');
        end
    
        % Lógica principal de la simulación
        while current_frequency_idx <= length(frequencies)
            current_frequency = frequencies(current_frequency_idx);
            stop_simulation = false;

            % cuando se le da al play empeiza la secuencia
            if play_flag 

                % Condicion para recorrer de forma ascendente o descendente el intervalo de dB
                if inversion % Ascendente (para inversion = true) 

                    % Bucle para incrementar el nivel de dB SPL (valor mas
                    % bajo en SPL es el cero)
                    for dB_current = dB_inicial:dB_step:dB_end
            
                        % Actualizar el texto de los dB, frecuencia y oído
                        set(hFrequencyText, 'String', sprintf('Frecuencia actual: %d Hz', current_frequency));
                        set(hDbText, 'String', sprintf('Nivel: %.0f dB SPL', dB_current));
                        set(hEarText, 'String', sprintf('Oído: %s', getEarText(ear)));

                        % Selecion del oido en el que se hace sonar la señal
                        if ear
                            ear_fun = 'dere';
                        else
                            ear_fun = 'izq';
                        end
                        % Introducir el dato de la rampa
                        config = read_ini('../ini/config.ini');
                        % Acceder a los datos leídos
                        ramp_duration = config.Audio.rampa_tiempo;
                        sonidoASIO(asio,t_durac,ear_fun,fs,dB_current,offset_dB_SPL,ramp_duration,current_frequency,soundcardDriver);
            
                        % Pausa para simular aumento gradual
                        % Se pone un intervalo
                        tempo = (duration2-duration)*rand+duration;
                        pause(tempo);
            
                        % Detener si el usuario presiona el botón "Detener"
                        if stop_simulation
                            % Sumamos al indice del numero de trials
                            %dB_current = dB_current -2;
                            set(hDbText, 'String', sprintf('Nivel: %.0f dB SPL', dB_current));
                            index=index+1;
                            break;
                        end
                    end
                else % Descendente (para inversion = false)
                    
                    % Bucle para incrementar el nivel de dB SPL
                    for dB_current = dB_inicial:-dB_step:min_dB % valor muy bajo si lo deja
            
                        % Actualizar el texto de los dB, frecuencia y oído
                        set(hFrequencyText, 'String', sprintf('Frecuencia actual: %d Hz', current_frequency));
                        set(hDbText, 'String', sprintf('Nivel: %.0f dB SPL', dB_current));
                        set(hEarText, 'String', sprintf('Oído: %s', getEarText(ear)));

                        if ear
                            ear_fun = 'dere';
                        else
                            ear_fun = 'izq';
                        end
                        % Introducir el dato de la rampa
                        config = read_ini('../ini/config.ini');
                        % Acceder a los datos leídos
                        ramp_duration = config.Audio.rampa_tiempo;
                        sonidoASIO(asio,t_durac,ear_fun,fs,dB_current,offset_dB_SPL,ramp_duration,current_frequency,soundcardDriver);
            
                        % Pausa para simular aumento gradual
                        % Se pone un intervalo
                        tempo = (duration2-duration)*rand+duration;
                        pause(tempo);
            
                        % Detener si el usuario presiona el botón "Detener"
                        if stop_simulation
                            % Sumamos al indice del numero de trials
                            %dB_current = dB_current +2;
                            set(hDbText, 'String', sprintf('Nivel: %.0f dB SPL', dB_current));
                            index=index+1;
                            break;
                        end
                    end
                end
                 
                % Guardar los resultados para cada oído (teniendo en cuenta que se hace el promedio de cada trial)
                if ear
                    dB_values_dere(current_frequency_idx) = dB_values_dere(current_frequency_idx) + dB_current / promedios;
                else
                    dB_values_izq(current_frequency_idx) = dB_values_izq(current_frequency_idx) + dB_current / promedios;
                end
    
                % Habilitar el botón "Play" para la siguiente frecuencia
                set(hNextButton, 'Enable', 'on');
            end
            
            % Esperar a que el usuario haga clic en "Play"
            waitfor(hNextButton, 'Enable', 'off');
            
            
            % Cambiar a la siguiente frecuencia
            if cambio_frequency && stop_simulation && index == promedios
                current_frequency_idx = current_frequency_idx + 1;
                index=0; % Inicializar el numero de trials
            end
        
            % Cambiar de oído cuando se complete el oído izquierdo
            if current_frequency_idx > length(frequencies) && k <= 0
                ear = true; % Pasamos a oido derecho
                index=0; % Inicializar el numero de trials
                play_flag = false; % Habilitamos que el boton play (el flag)
                set(hNextButton, 'Enable', 'on');
                uialert(hFig, sprintf('La prueba del oído derecho comienza.'), ...
                'Inicio de la prueba...', 'Icon', 'info');
                current_frequency_idx = 1; % Inicializamos las fercuencias
        
                % Ponerlo de color rojo para el oído derecho
                p_cuadro.BackgroundColor = '#f77d7b';
                hFrequencyText.BackgroundColor = '#f77d7b';
                hDbText.BackgroundColor = '#f77d7b';
                hEarText.BackgroundColor = '#f77d7b';
                % Cambiar el texto
                set(hFrequencyText, 'String', sprintf('Frecuencia actual: %d Hz', frequencies(1)));
                set(hDbText, 'String', sprintf('Nivel: %.0f dB SPL', dB_current));
                set(hEarText, 'String', sprintf('Oído: %s', getEarText(ear)));
        
                k = k + 1; % Contador para terminar la simulacion para k=2
            end
        
            % Finalizar la simulación después de completar ambos oídos
            if k == 2
                current_frequency_idx = length(frequencies) + 1;
            end
        
            % Reiniciar la simulación si se presiona el botón "Reiniciar"
            if reiniciar_flag
                current_frequency_idx = 1;
                index=0;
                ear = false;
                reiniciar_flag = false;
            end
        end

    
        %% PTA: Pure Tone Average (quitamos las frecuencias extremo)
        % Cálculo de la pérdida auditiva 
        perdida_izq = mean(dB_values_izq(2:5)); % Promedio de las frecuencias 500, 1k, 2k, 4k Hz
        perdida_dere = mean(dB_values_dere(2:5)); % Promedio de las frecuencias 500, 1k, 2k, 4k Hz
    
        % Criterio para la pérdida auditiva
        %if abs(perdida_izq - perdida_dere) > 40 % diferencia entre las perdidas de ambos oidos
            if perdida_dere < perdida_izq % https://www.audifonos.es/blog/como-calcular-mi-porcentaje-de-perdida-auditiva
                perdida = (perdida_izq   + perdida_dere * 5)/6; % se sigue el criterio de AAOO: American Academy of Ophtalmology and Otolaryngology (AAOO)
            else
                perdida = (perdida_izq * 5 + perdida_dere)/6;
            end
        %else
            %perdida = perdida_izq * 0.5 + perdida_dere * 0.5;
        %end
        
        % Datos guardados en una estructura
        datos = struct(...
                'dB_SPL_oido_izquierdo', dB_values_izq, ...
                'dB_SPL_oido_derecho', dB_values_dere, ...
                'Perdida_auditiva_PTA', perdida ...
        );

        % Mostrar los resultados en un cuadro de mensaje
        uialert(hFig, sprintf('Prueba finalizada.\n Umbral auditiva total: %.1f dB SPL', ...
            perdida), ...
                'Fin prueba...', 'Icon', 'info');
        % Imrpimimos los valores
        disp('Datos obtenidos:'); ...
        disp('Nivel umbral en dB SPL:');
        disp(perdida);
        % Quito lo visible
        p_cuadro2.Visible = 'off';
        p_cuadro.Visible = 'off';
        hStopButton.Visible = 'off';
        hNextButton.Visible = 'off';
        hReiniciarButton.Visible = 'off';

        % Función de callback para cerrar la figura
        function cerrarFigura(hFig)
            % Mostrar el cuadro de confirmación
            choice = questdlg('¿Estás seguro de que quieres cerrar la figura?', ...
                'Confirmar cierre', 'Aceptar', 'Cancelar', 'Cancelar');

            % Dependiendo de la elección, tomar acción
            switch choice
                case 'Aceptar'
                    disp('Cerrando la interfaz...');
                    close(hFig);  % Cerrar la figura si el usuario acepta
                    figure(fig); 
                case 'Cancelar'
                    disp('Operación cancelada. La figura no se cerrará.');
                    % No hacer nada, simplemente retornar y no cerrar la figura
                otherwise
                    disp('Operación cancelada. La figura no se cerrará.');
            end
        end

        % Función para guardar los graficos
        function guardarImagen(ax)
            % Ruta de la carpeta donde está esta función
            direct = pwd;
            direct = fileparts(direct);
        
            % Ruta a la carpeta ../Programa (una por encima de donde está esta función)
            %direct = fullfile(direct, '..');

            % Obtiene el Escritorio como ruta por defecto
            %direct = fullfile(getenv('USERPROFILE'), 'Desktop');  % Para Windows
            %if ~isfolder(direct)  % Compatibilidad Unix/Mac
                %direct = fullfile(getenv('HOME'), 'Desktop');
            %end

            % Abrir diálogo para seleccionar ruta usando la ruta actual
            rutaActual = direct;
            
    
            % Crear carpeta "datos_pruebas" en la ruta seleccionada
            rutaFinal = fullfile(rutaActual, 'Resultados');
            
            if ~exist(rutaFinal, 'dir')
                mkdir(rutaFinal);
            end

            % Crear carpeta "datos_pruebas" en la ruta seleccionada
            rutaFinal2 = fullfile(rutaFinal, 'Prueba1_audiometria_tonal');
            if ~exist(rutaFinal2, 'dir')
                mkdir(rutaFinal2);
            end

            %nuevaRuta = abrirExplorador(rutaFinal2);

            % Seleccionar el archivo y el formato
            [file, ~] = uiputfile({'*.png';'*.jpg';'*.pdf'}, 'Guardar imagen como', rutaActual);
            
            if isequal(file, 0)
                disp('Guardado cancelado.');
            else
                % Guardar el gráfico usando exportgraphics
                filename = fullfile(rutaFinal2, file);
                if isvalid(ax)
                    exportgraphics(ax, filename, 'Resolution', 300);
                else
                    disp('El axes no es válido al intentar exportar.');
                end
                disp(['Imagen guardada en: ', filename]);
            end
        end

        % Crear un botón para cerrar la figura
        btn2 = uibutton(hFig, 'push', 'Text', 'Cerrar', 'Position', [150 10 80 30], 'FontSize', 14,'BackgroundColor', '#ff6060',...
            'ButtonPushedFcn', @(btn2, event) cerrarFigura(hFig));

        % Crear un uiaxes dentro de la UI
        app.UIAxes = uiaxes(hFig, 'Position', [50 50 500 300]);

        % Graficar en el uiaxes
        % Sort sirve para ordenar el array
        [frequencies_sorted, idx] = sort(frequencies, 'ascend');
        % Reordenar dB_values usando el mismo índice
        dB_values_sorted_izq = dB_values_izq(idx);
        dB_values_sorted_dere = dB_values_dere(idx);
        % Para pasar a dBHL
        perdida_izq = relaciondBHL(frequencies_sorted, dB_values_sorted_izq);
        perdida_dere = relaciondBHL(frequencies_sorted, dB_values_sorted_dere);

        semilogx(app.UIAxes, frequencies_sorted, perdida_izq, '-x', 'Color', 'b', 'LineWidth', 1.5, 'MarkerSize', 8); % Oido izquierdo
        hold(app.UIAxes, 'on'); % Mantener el gráfico para superponer más plots
        semilogx(app.UIAxes, frequencies_sorted, perdida_dere, '-o', 'Color', 'r', 'LineWidth', 1.5, 'MarkerSize', 8); % Oido derecho

        % Definir la zona a colorear ([x1,x2,x3,x4],[y1,y2,y3,y4], donde va de abajo-izq -> abajo-dere -> arriba-dere -> arriba-izq)
        % Se busca el maximo y minimo en frequencies
        [v_max,i_max] = max(frequencies);
        [v_min,i_min] = min(frequencies);
        %xZona = [frequencies(i_max) frequencies(i_min) frequencies(i_min) frequencies(i_max)]; % Esquinas del área sombreada
        xZona = [8500 200 200 8500]; % Esquinas del área sombreada
        % Se considera perdida con 25dBHL (OMS)
        yZona = [25 25 -10 -10]; % Normalizado segun el offset que tengamos

        % Pintar la zona con color translúcido
        fill(app.UIAxes, xZona, yZona, 'g', 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Rojo con 30% de opacidad

        % Liberar el hold después de agregar los gráficos
        hold(app.UIAxes, 'off'); 
        app.UIAxes.YDir = 'reverse'; % Invierte el eje Y (más abajo = mayor valor)
        app.UIAxes.XAxisLocation = 'top'; % Mueve los números del eje X arriba
        
        % Añadir etiquetas y título
        title(app.UIAxes, 'Audiograma de ambos oídos');
        % Para poner el nombre en el eje de los numeros
        xticks(app.UIAxes, [250 500 1000 2000 4000 8000])
        xticklabels(app.UIAxes, {'250','500','1000','2000','4000','8000'})
        xlabel(app.UIAxes, 'Frecuencias (Hz)');
        ylabel(app.UIAxes, 'dB HL');
        % Abajo a la izquierda
        legend(app.UIAxes, {'Oído izquierdo', 'Oído derecho'},'Location', 'southwest'); % Agregar leyenda
        % FIJAR LOS EJES (estilo de presentacion)
        ylim(app.UIAxes, [-10, 60]);
        xlim(app.UIAxes, [200, 8500]);
        %ylim(app.UIAxes, [inicio_dB-20, dB_end-20]);
        %xlim(app.UIAxes, [min(frequencies)-1000, max(frequencies)]+500);
        grid(app.UIAxes, 'on'); % Activar la cuadrícula para mejor visualización

        % Crear el botón de guardar
        btnGuardar = uicontrol(hFig,'Style', 'pushbutton', 'String', 'Guardar', ...
                           'Position', [330 10 80 30], ...
                           'FontSize', 12, 'BackgroundColor', '#3dfe98',...
                           'Callback', @(~,~) guardarImagen(app.UIAxes));

        % Crear un cuadro de diálogo para escribir un mensaje
        prompt = {'Escribe una observación...'};
        dlg_title = 'Obvervaciones a realizar de la prueba';
        num_lines = 10;
        respuesta = inputdlg(prompt, dlg_title, num_lines);

        % Forzar el foco y visibilidad de figi (uifigure)
        %hFig.Visible = 'on';  % Asegura que esté visible
        %drawnow;
        %hFig.Position = hFig.Position;  % Truco para que Windows lo considere "activo"
        %figure(hFig);

        % Escribir en un fichero .ini para luego leerlo y
        % escribirlo en otro fichero de datos
        filename = 'datos_prueba.txt';
        fid = fopen(filename, 'w','n', 'UTF-8'); % Abrir archivo en modo escritura
        fprintf(fid, '[Datos_prueba]\n'); % Sección General
        fprintf(fid, 't_durac = %1f\n',t_durac); 
        fprintf(fid, 'offset_dB_SPL = %0f\n',offset_dB_SPL);
        fprintf(fid, 'duration = %3f\n',duration);
        fprintf(fid, 'duration2 = %3f\n',duration2);
        fprintf(fid, 'dB_start = %0f\n',inicio_dB);
        % Poner valores de inicio y fin de la prueba que incluyo en la
        % pantalla controlador y poner errores
        fprintf(fid, 'dB_inicial = %f\n',dB_inicial);
        %fprintf(fid, 'dB_end = %f\n',dB_end);
        fprintf(fid, 'promedio = %0f\n',promedios);
        if inversion
            fprintf(fid, 'inversion = Ascendente\n');
        else
            fprintf(fid, 'inversion = Descendente\n');
        end
        fprintf(fid, 'fs = %0f\n',fs);
        fprintf(fid, 'dB_step = %0f\n',dB_step);
        fprintf(fid, 'Observa = %s\n',respuesta{:});
        t1=clock;
        fprintf(fid, 't1 = %f\n',t1);
        fclose(fid); % Cerrar archivo
        figure(fig); 
    
        % Callbacks
        function stopButtonCallback(~, ~)
            stop_simulation = true;
        end
    
        function nextButtonCallback(~, ~)
            set(hNextButton, 'Enable', 'off');
            cambio_frequency = true;
            play_flag = true;
        end
    
        function reiniciarCallback(~, ~)
            reiniciar_flag = true;
        end
        
    end
    
    % Función auxiliar para obtener el texto del oído
    function earText = getEarText(ear)
        if ear
            earText = 'Derecho';
        else
            earText = 'Izquierdo';
        end
    end

   %% Funcion para simular la acufenometria prueba
   function datos1 = acufenometria_prueba(mismo,asio,soundcardDriver,fs,t_durac,sensibilidad,freq1,freq2,dB_level,duration)
        detener = false; % Flag para parar la simulación del acufeno propuesto

        % Lista de opciones para el desplegable donde se quiere presentar el acufeno (==1 es para el primer elemento, y ==2 para el segundo)
        opciones = {'Oído izquierdo', 'Oído derecho'};

        % Establecer el tamaño de la lista dentro del cuadro de diálogo
        listSize = [200, 100];  % [ancho, alto] en píxeles
        
        % Mostrar cuadro de diálogo con lista de opciones
        [indice_seleccionado, ok] = listdlg('ListString', opciones, ...
                                            'SelectionMode', 'single', ...
                                            'PromptString', 'Seleccione donde simular el acúfeno:', ...
                                            'Name', 'Tipo acúfeno', ...
                                            'ListSize', listSize);  % Controla el tamaño de la lista
        
        % Verificar si el usuario seleccionó algo
        if ok == 1
            disp(['Opción seleccionada: ', opciones{indice_seleccionado}]);
        else
            disp('No se seleccionó ninguna opción.');
            return;
        end

        % Pedir Frecuencia del acufeno
        freq_acu = inputdlg({'Ingrese la frecuencia del acúfeno:'}, 'Entrada', [1 50], {'250'}); 
        % Si esta vacio el elemento se sale
        if isempty(freq_acu)
            return;
        end
        if freq_acu{1}<20 % tipo cell variable se usa variable{}
            return;
        end
        if freq_acu{1}>20000 % tipo cell variable se usa variable{}
            return;
        end
        % Se pasa a valor numerico
        freq_acu = str2double(freq_acu{1});
        % Condicion para que sea positivo
        % Comprobamos si es entrada valida
        if isnan(freq_acu) || freq_acu <= 0 % Validar entrada
            uialert(fig, 'Valor inválido. Introduzca un número positivo.', 'Error', 'Icon', 'warning');
            return;
        end

        % Pedir dB del acufeno
        dB_acu = inputdlg({'Ingrese el nivel de intensidad (dB SPL) del acúfeno:'}, 'Entrada', [1 50], {'20'}); 
        % Si esta vacio el elemento se sale
        if isempty(dB_acu) 
            return;
        end
        % Se pasa a valor numerico
        dB_acu = str2double(dB_acu{1}); % Convertir a número
        % Comprobamos si es entrada valida
        if isnan(dB_acu) || dB_acu <= 0||dB_acu>60 % Validar entrada
            uialert(fig, 'Valor inválido. Introduzca un número positivo o menor.', 'Error', 'Icon', 'warning');
            return;
        end

        % Crear la ventana principal
        figi = uifigure('Name', 'Prueba del Acúfeno', 'WindowStyle','modal','Position', [100 100 600 400]);
    
        % Recuadros de color
        p_cuadro = uipanel(figi, 'Title', '', 'FontSize', 12, ...
            'BackgroundColor', '#7bd3f7', 'Position', [20 220 560 160], 'Visible', 'off');
    
        p_cuadro2 = uipanel(figi, 'Title', '', 'FontSize', 12, ...
            'BackgroundColor', '#7bd3f7', 'Position', [20 20 560 180], 'Visible', 'off');
       
        % Mostrar los elementos de la nueva pantalla
        p_cuadro.Visible = 'on';
        p_cuadro2.Visible = 'on';

        % Función de callback para cerrar la figura
        function cerrarFigura(figi) % Si cierro no se guardan los datos
            % Mostrar el cuadro de confirmación
            choice = questdlg('¿Estás seguro de que quieres cerrar la figura?', ...
                'Confirmar cierre', 'Aceptar', 'Cancelar', 'Cancelar');
        
            % Dependiendo de la elección, tomar acción
            switch choice
                case 'Aceptar'
                    disp('Cerrando la interfaz...');
                    close(figi);  % Cerrar la figura si el usuario acepta
                    figure(fig); 
                case 'Cancelar'
                    disp('Operación cancelada. La figura no se cerrará.');
                    % No hacer nada, simplemente retornar y no cerrar la figura
                otherwise
                    disp('Operación cancelada. La figura no se cerrará.');
            end
        end

        % Función para guardar los graficos
        % Función para guardar los graficos
        function guardarImagen(ax)
            % Ruta de la carpeta donde está esta función
            direct = pwd;
            direct = fileparts(direct);
        
            % Ruta a la carpeta ../Programa (una por encima de donde está esta función)
            %direct = fullfile(direct, '..');

            % Obtiene el Escritorio como ruta por defecto
            %direct = fullfile(getenv('USERPROFILE'), 'Desktop');  % Para Windows
            %if ~isfolder(direct)  % Compatibilidad Unix/Mac
                %direct = fullfile(getenv('HOME'), 'Desktop');
            %end

            % Abrir diálogo para seleccionar ruta usando la ruta actual
            rutaActual = direct;
            
    
            % Crear carpeta "datos_pruebas" en la ruta seleccionada
            rutaFinal = fullfile(rutaActual, 'Resultados');
            
            if ~exist(rutaFinal, 'dir')
                mkdir(rutaFinal);
            end

            % Crear carpeta "datos_pruebas" en la ruta seleccionada
            rutaFinal2 = fullfile(rutaFinal, 'Prueba3_acufenometria_simulada');
            if ~exist(rutaFinal2, 'dir')
                mkdir(rutaFinal2);
            end

            %nuevaRuta = abrirExplorador(rutaFinal2);

            % Seleccionar el archivo y el formato
            [file, ~] = uiputfile({'*.png';'*.jpg';'*.pdf'}, 'Guardar imagen como', rutaActual);
            
            if isequal(file, 0)
                disp('Guardado cancelado.');
            else
                % Guardar el gráfico usando exportgraphics
                filename = fullfile(rutaFinal2, file);
                if isvalid(ax)
                    exportgraphics(ax, filename, 'Resolution', 300);
                else
                    disp('El axes no es válido al intentar exportar.');
                end
                disp(['Imagen guardada en: ', filename]);
            end
        end
    
        % Imprimir que ejecuta
        disp('Ejecutando de la prueba...');
        flag_promedio = 0;
        %%% Lee el valor de promedios que hace para la intensidad
        config = read_ini('../ini/config.ini');
        % Acceder a los datos leídos
        number_promedio = config.Audio.promedio;


        if (indice_seleccionado == 1) % Acufeno en el oído izquierdo (medición en el derecho)           
            % Acufeno en el oído izquierdo
        
            % Medición del oído derecho
            if mismo==0
                ear = true;
                uialert(figi, sprintf('Prueba del oído derecho.'), ...
            'Inicio de la prueba...', 'Icon', 'info');
            elseif mismo==1
                ear = false;
                uialert(figi, sprintf('Prueba del oído izquierdo.'), ...
            'Inicio de la prueba...', 'Icon', 'info');
            end

            uialert(figi, sprintf('Presione los botones "Escuchar Sonido 1" o " Escuchar Sonido 2" para escuchar el sonido.\n Presione "Selccionar Sonido 1" o "Seleccionar Sonido 2" para elegir el sonido que más se parezca a su acúfeno.'), ...
            'Inicio de la prueba...', 'Icon', 'info');
            %(333)
            dB_level_real_fin = 0;
            while flag_promedio<number_promedio
                if flag_promedio>0
                    % Se pasan los valores de freq_old determinados la prueba anterior
                    freq_fin = freq_old;
                    dB_fin = dB_level_real;
                    % Se hace para guardar las frecuencias y  que no se
                    % vaya
                    if flag_promedio==1
                        freq1_list_guarda = freq1_list;
                        freq2_list_guarda = freq2_list;
                        iter_ascen_guarda = iter_ascen;
                        iter_descen_guarda = iter_descen;
                    end
                elseif flag_promedio==0
                    freq_fin = 0;
                    dB_fin = 0;
                end
                [freq_old, dB_level_real,freq1_list, freq2_list,iter_ascen, iter_descen,flag_promedio_resul] = medir_acufeno3(dB_fin,freq_fin,flag_promedio, mismo,freq_acu,dB_acu,asio,soundcardDriver,ear, sensibilidad,freq1,freq2,t_durac,dB_level,fs);
                flag_promedio = flag_promedio_resul;
                % Se promedia la intensidad
                dB_level_real_fin = dB_level_real_fin + dB_level_real/3;
            % (333) 
            end

            % Promediamos la intensidad
            dB_level_real = dB_level_real_fin;
            % Se guardan bien los valores
            freq1_list = freq1_list_guarda;
            freq2_list = freq2_list_guarda;
            iter_ascen = iter_ascen_guarda;
            iter_descen = iter_descen_guarda;

            % Guardado de datos
            datos1 = struct(...
                    'Frecuencia_acufeno_real', freq_acu, ...
                    'dB_SPL_acufeno_real', dB_acu, ...
                    'Frecuencia_acufeno_medida', freq_old, ...
                    'dB_SPL_acufeno_medida', dB_level_real, ...
                    'Acufeno_real', 'Oido_izquierdo'...
            );
        
            % Paramos la reproducción del acufeno cuando terminemos la medición
            uialert(figi, sprintf('Prueba finalizada. Presione "Guardar datos" en la pantalla de control para guardar los datos.'), ...
            'Fin de la prueba...', 'Icon', 'info');
            clear player;  % Detenemos el sonido aquí
        
            % Muestra de los resultados
            uialert(figi, sprintf('Prueba finalizada.\nFrecuencia del acufeno real %.0f Hz\nNivel de dB SPL del acufeno real %.0f dB\nFrecuencia del acufeno medido %.0f Hz\nNivel de dB SPL del acufeno medido %.0f dB', ...
                freq_acu, dB_acu, freq_old, dB_level_real), ...
            'Fin de la prueba...', 'Icon', 'info');

            p_cuadro2.Visible = 'off';
            p_cuadro.Visible = 'off';

            % Crear un botón para cerrar la figura
            btn2 = uibutton(figi, 'push', 'Text', 'Cerrar', 'Position', [260 10 80 30], 'FontSize', 14,'BackgroundColor', '#ff6060',...
                'ButtonPushedFcn', @(btn2, event) cerrarFigura(figi));

            % Representación gráfica
            %t = 0:1/fs:duration; % Tiempo
            %signal_medida = 10^((dB_level_real - sensibilidad) / 20) * sin(2 * pi * freq_old * t);
            %signal_acu = 10^((dB_acu - sensibilidad) / 20) * sin(2 * pi * freq_acu * t);

            % Crear un uiaxes dentro de la UI
            app.UIAxes = uiaxes(figi, 'Position', [50 50 500 300]);

            % Configurar el eje X como logarítmico
            set(app.UIAxes, 'XScale', 'log');
            
            % Limitar los ejes para que se vea bien
            xlim(app.UIAxes, [freq1_list(1)-50 freq2_list(1)+500]);
            xticks(app.UIAxes, [250 500 1000 2000 4000 8000]);
            
            % Preparar iteradores según tamaño de las listas
            iter_a = 1:length(freq1_list); 
            iter_d = 1:length(freq2_list); 
            
            hold(app.UIAxes, 'on');
            
            % === RELLENAR áreas bajo las curvas con transparencia ===
            
            % Serie ascendente oído izquierdo
            fill(app.UIAxes, [freq1_list freq1_list(end) freq1_list(1)], ...
                 [iter_a 0 0], ...
                 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            
            % Serie descendente oído izquierdo
            fill(app.UIAxes, [freq2_list freq2_list(end) freq2_list(1)], ...
                 [iter_d 0 0], ...
                 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

            
            % === Ahora graficamos las curvas con marcadores ===
            if iter_ascen>iter_descen
                iter = iter_ascen;
            else
                iter = iter_descen;
            end
            iter_vector = 1:iter; 
            freq = sqrt(freq1_list(end)*freq2_list(end));
            vector_freq = freq * ones(1, iter);
            vector_freq_acu = freq_acu * ones(1, iter);

            vector_freq_old = freq_old * ones(1, iter);
            %plot(app.UIAxes, vector_freq_old, iter_vector, 'yellow--', 'LineWidth', 1.5);
            plot(app.UIAxes, vector_freq, iter_vector, 'magenta--', 'LineWidth', 1.5);
            plot(app.UIAxes, vector_freq_acu, iter_vector, '--', 'Color', [0.75, 1, 0], 'LineWidth', 1.5);
            plot(app.UIAxes, freq1_list, iter_a, 'b-o', 'MarkerSize', 6, 'LineWidth', 1.5);
            plot(app.UIAxes, freq2_list, iter_d, 'r-s', 'MarkerSize', 6, 'LineWidth', 1.5);
            ylim(app.UIAxes, [1, iter+1]);   
            hold(app.UIAxes, 'off');
            
            % Mejorar la presentación
            title(app.UIAxes, 'Representación de la serie ascendente y descendente');
            ylabel(app.UIAxes, 'Número de iteraciones');
            xlabel(app.UIAxes, 'Frecuencia (Hz)');
            legend(app.UIAxes, {'Serie ascendente', ...
                                'Serie descendente', 'Freq seleccionada', 'Frecuencia del acúfeno'}, 'Location', 'best');
            
            grid(app.UIAxes, 'on');

            % Crear el botón de guardar
            btnGuardar = uicontrol(figi,'Style', 'pushbutton', 'String', 'Guardar', ...
                           'Position', [430 10 80 30], ...
                           'FontSize', 12, 'BackgroundColor', '#3dfe98',...
                           'Callback', @(~,~) guardarImagen(app.UIAxes));
        
        elseif (indice_seleccionado == 2) % Acufeno en el oído derecho (medición en el izquierdo)           
            % Acufeno en el oído derecho
        
            % Medición del oído izquierdo
            if mismo==0
                ear = false;
                uialert(figi, sprintf('Prueba del oído izquierdo.'), ...
            'Inicio de la prueba...', 'Icon', 'info');
            elseif mismo==1
                ear = true;
                uialert(figi, sprintf('Prueba del oído derecho.'), ...
            'Inicio de la prueba...', 'Icon', 'info');
            end
      
            uialert(figi, sprintf('Presione los botones "Escuchar Sonido 1" o " Escuchar Sonido 2" para escuchar el sonido.\n Presione "Selccionar Sonido 1" o "Seleccionar Sonido 2" para elegir el sonido que más se parezca a su acúfeno.'), ...
            'Inicio de la prueba...', 'Icon', 'info');
            %(333)
            dB_level_real_fin = 0;
            while flag_promedio<number_promedio
                if flag_promedio>0
                    % Se pasan los valores de freq_old determinados la prueba anterior
                    freq_fin = freq_old;
                    %disp('freq fin');
                    %disp(freq_fin);
                    dB_fin = dB_level_real;
                    %disp('dB fin');
                    %disp(dB_fin);
                    % Se hace para guardar las frecuencias y  que no se
                    % vaya
                    if flag_promedio==1
                        freq1_list_guarda = freq1_list;
                        freq2_list_guarda = freq2_list;
                        iter_ascen_guarda = iter_ascen;
                        iter_descen_guarda = iter_descen;
                    end
                elseif flag_promedio==0
                    freq_fin = 0;
                    dB_fin = 0;
                end
                [freq_old, dB_level_real,freq1_list, freq2_list,iter_ascen, iter_descen,flag_promedio_resul] = medir_acufeno3(dB_fin,freq_fin,flag_promedio,mismo,freq_acu,dB_acu,asio,soundcardDriver,ear, sensibilidad,freq1,freq2,t_durac,dB_level,fs);
                flag_promedio = flag_promedio_resul;
                %disp('freq final de old');
                %disp(freq_old);

                % Se promedia la intensidad
                %disp('dB final de real y promedio');
                dB_level_real_fin = dB_level_real_fin + dB_level_real/3;
                %disp(dB_level_real);
            % (333)
            end

            % Se promedia la intensidad
            dB_level_real = dB_level_real_fin;
            %disp('dB final promedio');
            %disp(dB_level_real);
            % Se guardan bien los valores
            freq1_list = freq1_list_guarda;
            freq2_list = freq2_list_guarda;
            iter_ascen = iter_ascen_guarda;
            iter_descen = iter_descen_guarda;

            % Guardado de datos
            datos1 = struct(...
                    'Frecuencia_acufeno_real', freq_acu, ...
                    'dB_SPL_acufeno_real', dB_acu, ...
                    'Frecuencia_acufeno_medida', freq_old, ...
                    'dB_SPL_acufeno_medida', dB_level_real, ...
                    'Acufeno_real', 'Oido_derecho'...
            );
       
            % Paramos la reproducción del acufeno cuando terminemos la medición
            uialert(figi, sprintf('Prueba finalizada. Presione "Guardar resultados" en la pantalla de control para guardar los datos.'), ...
            'Fin de la prueba...', 'Icon', 'info');
            clear player;  % Detenemos el sonido aquí
        
            % Muestra de los resultados
            uialert(figi, sprintf('Prueba finalizada.\nFrecuencia del acufeno real %.0f Hz\nNivel de dB SPL del acufeno real %.0f dB\nFrecuencia del acufeno medido %.0f Hz\nNivel de dB SPL del acufeno medido %.0f dB', ...
                freq_acu, dB_acu, freq_old, dB_level_real), ...
            'Fin de la prueba...', 'Icon', 'info');

            p_cuadro2.Visible = 'off';
            p_cuadro.Visible = 'off';

            % Crear un botón para cerrar la figura
            btn2 = uibutton(figi, 'push', 'Text', 'Cerrar', 'Position', [260 10 80 30], 'FontSize', 14,'BackgroundColor', '#ff6060',...
                'ButtonPushedFcn', @(btn2, event) cerrarFigura(figi));
        
            % Representación gráfica
            %t = 0:1/fs:duration; % Tiempo
            %signal_medida = 10^((dB_level_real - sensibilidad) / 20) * sin(2 * pi * freq_old * t);
            %signal_acu = 10^((dB_acu - sensibilidad) / 20) * sin(2 * pi * freq_acu * t);

            % Crear un uiaxes dentro de la
            % UI
            app.UIAxes = uiaxes(figi, 'Position', [50 50 500 300]);

            % Configurar el eje X como logarítmico
            set(app.UIAxes, 'XScale', 'log');
            
            % Limitar los ejes para que se vea bien
            xlim(app.UIAxes, [freq1_list(1)-50 freq2_list(1)+500]);
            xticks(app.UIAxes, [250 500 1000 2000 4000 8000]);
            
            % Preparar iteradores según tamaño de las listas
            iter_a = 1:length(freq1_list); 
            iter_d = 1:length(freq2_list); 
            
            hold(app.UIAxes, 'on');
           
            
            % === RELLENAR áreas bajo las curvas con transparencia ===
            
            % Serie ascendente oído izquierdo
            fill(app.UIAxes, [freq1_list freq1_list(end) freq1_list(1)], ...
                 [iter_a 0 0], ...
                 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
            
            % Serie descendente oído izquierdo
            fill(app.UIAxes, [freq2_list freq2_list(end) freq2_list(1)], ...
                 [iter_d 0 0], ...
                 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

            
            % === Ahora graficamos las curvas con marcadores ===
            if iter_ascen>iter_descen
                iter = iter_ascen;
            else
                iter = iter_descen;
            end
            iter_vector = 1:iter; 
            freq = sqrt(freq1_list(end)*freq2_list(end));
            vector_freq = freq * ones(1, iter);
            vector_freq_acu = freq_acu * ones(1, iter);

            vector_freq_old = freq_old * ones(1, iter);
            %plot(app.UIAxes, vector_freq_old, iter_vector, 'yellow--', 'LineWidth', 1.5);
            plot(app.UIAxes, vector_freq, iter_vector, 'magenta--', 'LineWidth', 1.5);
            plot(app.UIAxes, vector_freq_acu, iter_vector, '--', 'Color', [0.75, 1, 0], 'LineWidth', 1.5);
            plot(app.UIAxes, freq1_list, iter_a, 'b-o', 'MarkerSize', 6, 'LineWidth', 1.5);
            plot(app.UIAxes, freq2_list, iter_d, 'r-s', 'MarkerSize', 6, 'LineWidth', 1.5);
            ylim(app.UIAxes, [1, iter+1]);   
            hold(app.UIAxes, 'off');
            
            % Mejorar la presentación
            title(app.UIAxes, 'Representación de la serie ascendente y descendente');
            ylabel(app.UIAxes, 'Número de iteraciones');
            xlabel(app.UIAxes, 'Frecuencia (Hz)');
            legend(app.UIAxes, {'Serie ascendente', ...
                                'Serie descendente',  'Freq seleccionada', 'Frecuencia del acúfeno'}, 'Location', 'best');
            
            grid(app.UIAxes, 'on');

            % Crear el botón de guardar
            btnGuardar = uicontrol(figi,'Style', 'pushbutton', 'String', 'Guardar', ...
                           'Position', [430 10 80 30], ...
                           'FontSize', 12, 'BackgroundColor', '#3dfe98',...
                           'Callback', @(~,~) guardarImagen(app.UIAxes));
        end

        % Crear un cuadro de diálogo para escribir un mensaje
        prompt = {'Escribe una observación...'};
        dlg_title = 'Obvervaciones a realizar de la prueba';
        num_lines = 10;
        respuesta = inputdlg(prompt, dlg_title, num_lines);

        % Forzar el foco y visibilidad de figi (uifigure)
        %figi.Visible = 'on';  % Asegura que esté visible
        %drawnow;
        %figi.Position = figi.Position;  % Truco para que Windows lo considere "activo"
        %figure(figi);

        % Guardar los datos en un txt para luego arbrirlos
        filename = 'datos_prueba.txt';
        fid = fopen(filename, 'w','n', 'UTF-8'); % Abrir archivo en modo escritura
        fprintf(fid, '[Datos_prueba]\n'); % Sección General
        fprintf(fid, 't_durac = %1f\n',t_durac); 
        fprintf(fid, 'sensibilidad = %0f\n',sensibilidad);
        %fprintf(fid, 'duration = %3f\n',duration);
        % Cambio de variables
        if mismo==1
            mismo_f = true;
        elseif mismo ==0
            mismo_f = false;
        end
        fprintf(fid, 'mismo = %s\n',mismo_f);
        %fprintf(fid, 'error_freq = %0f\n',error_freq);
        fprintf(fid, 'dB_level = %0f\n',dB_level);
        fprintf(fid, 'freq1 = %0f\n',freq1);
        fprintf(fid, 'freq2 = %0f\n',freq2);
        fprintf(fid, 'fs = %0f\n',fs);
        fprintf(fid, 'Observa = %s\n',respuesta{:});
        t1=clock;
        fprintf(fid, 't1 = %f\n',t1);

        % Para representar el grafico de las elecciones de frecuencias
        if iscell(freq1_list) %para pasarlo a array si es celda (como esta planteado es solo array)
            freq1_list = cell2mat(freq1_list);
        end
        if iscell(freq2_list)
            freq2_list = cell2mat(freq2_list);
        end
        fprintf(fid, 'Serie_ascendente = %s\n', num2str(freq1_list));
        fprintf(fid, 'Serie_descendente = %s\n', num2str(freq2_list));
        fprintf(fid, 'Iteraciones_serie_ascendente = %0f\n',iter_ascen);
        fprintf(fid, 'Iteraciones_serie_descendente = %0f\n',iter_descen);

        % Octava confusion
        fprintf(fid, 'Octava = %s\n', num2str(freq_old));
        freq_list = sqrt(freq1_list(end)*freq2_list(end));
        fprintf(fid, 'Freq_sele = %s\n', num2str(freq_list));


        fclose(fid); % Cerrar archivo
        figure(fig); 
                
       function [freq_old, dB_level_real,freq1_list, freq2_list,iter_ascen, iter_descen,flag_promedio_resul] = medir_acufeno3(dB_fin,freq_fin,flag_promedio,mismo,freq_acu,dB_acu,asio,soundcardDriver,ear, sensibilidad,freq1,freq2,t_durac,dB_level,fs)
            
            % Las funciones deben ir fuera
            % Función para activar la bandera de Sonido 1
            function play_s1(~, ~)
                play_s1_flag_tocar = true;  % Activar la bandera de Sonido 1
                s1_start_time = tic;   % Iniciar el temporizador para Sonido 1
                drawnow;
            end
          %% Octava confusion
            function selectedFreq = createSoundSelectionDialog(freq_old)
                % Inicializamos la variable de salida
                selectedFreq = [];
                
                % Crear figura emergente como modal
                d = uifigure('Name', 'Octava confusión: Selecciona un sonido', 'Position', [500 500 500 300]);
                d.WindowStyle = 'modal';
                
                % Posiciones X para los tres bloques
                xpos = [100, 250, 380];
            
                % Frecuencias diferentes para cada sonido
                frequencies = [freq_old/2, freq_old, 2*freq_old];  % Ajusta las frecuencias como desees
                
                % Callback para reproducir sonido de comparación
                function playReferenceSound()
                    sonidoASIO(asio, t_durac, ear_fun, fs, dB_level_real, sensibilidad, ramp_duration, freq_old, soundcardDriver);
                end
            
                % Callback para reproducir los sonidos candidatos
                function playSound(freq)
                    sonidoASIO(asio, t_durac, ear_fun, fs, dB_level_real, sensibilidad, ramp_duration, freq, soundcardDriver);
                end
            
                % Callback para cerrar la ventana y devolver la frecuencia seleccionada
                function closeWindow(selectedIndex)
                    selectedFreq = frequencies(selectedIndex); % Se guarda la frecuencia elegida
                    uiresume(d); % Cierra la ventana
                    delete(d);   % Elimina la ventana
                    figure(fig); 
                end
            
                % Texto superior
                uilabel(d, ...
                    'Text', {
                        'Pulse el botón "Sonido". Presione los botones "Sonido 1,2,3"'}, ...
                    'Position', [20 230 460 100], ...
                    'FontSize', 14, ...
                    'HorizontalAlignment', 'center');
                uilabel(d, ...
                    'Text', {
                        'para ver cuál de los tres se parece más al escuchado en el botón de'}, ...
                    'Position', [20 210 460 100], ...
                    'FontSize', 14, ...
                    'HorizontalAlignment', 'center');
                uilabel(d, ...
                    'Text', {
                        '"Sonido". Pulse el botón "Seleccionar Sonido", del "Sonido 1,2,3"'}, ...
                    'Position', [20 190 460 100], ...
                    'FontSize', 14, ...
                    'HorizontalAlignment', 'center');
                uilabel(d, ...
                    'Text', {
                        'que más se haya parecido al escuchado en "Sonido".'}, ...
                    'Position', [20 170 460 100], ...
                    'FontSize', 14, ...
                    'HorizontalAlignment', 'center');
            
                % Botón superior "Sonido" (referencia)
                uibutton(d, 'Text', 'Sonido', ...
                    'Position', [200 160 100 30], ...
                    'ButtonPushedFcn', @(btn, event) playReferenceSound());
            
                % Botones "Sonido 1-3" para reproducir sonidos de comparación
                for i = 1:3
                    uibutton(d, 'Text', ['Sonido ', num2str(i)], ...
                        'Position', [xpos(i)-40, 120, 100, 22], ...
                        'ButtonPushedFcn', @(btn, event) playSound(frequencies(i)));
                end
            
                % Botones "Seleccionar 1-3" para elegir la opción
                for i = 1:3
                    uibutton(d, 'Text', ['Seleccionar', num2str(i)], ...
                        'Position', [xpos(i)-40, 80, 100, 30], ...
                        'ButtonPushedFcn', @(btn, event) closeWindow(i));
                end
            
                % Espera hasta que el usuario haga una selección
                uiwait(d);
            end

            
            % (333)Parámetros iniciales
            if flag_promedio==0
                sonido_selec = false; % Flag para la selección de los sonidos 1 (false) y 2 (true)
    
                % Para que cambie de color según el oído
                if ear 
                    p_cuadro.BackgroundColor = '#f77d7b';
                    p_cuadro2.BackgroundColor = '#f77d7b';
                else 
                    p_cuadro.BackgroundColor = '#7bd3f7';
                    p_cuadro2.BackgroundColor = '#7bd3f7';
                end
            
                % Limpiar los paneles antes de agregar nuevos elementos
                delete(p_cuadro.Children);
                delete(p_cuadro2.Children);
          
                % Crear nuevas etiquetas y botones
                cartel=uilabel(p_cuadro, 'Text', {'¿Su tinnitus es más grave o', 'más agudo que el sonido que ha escuchado?'}, 'Position', [30, 85, 500, 50],'HorizontalAlignment', 'center','FontSize', 16, 'Visible', 'on');
                freq1Label = uilabel(p_cuadro, 'Position', [60 130 400 30], 'FontSize', 12,'Text', ['Frecuencia: ' num2str(freq1) ' Hz'], 'Visible', 'on');
                serieLabel = uilabel(p_cuadro, 'Position', [375 130 500 30], 'FontSize', 12,'Text', 'Serie: Asendente', 'Visible', 'on');
            
                % Botones para reproducir sonidos
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
                % Acceder a los datos leídos
                ramp_duration = config.Audio.rampa_tiempo;
                n_octavas = config.General.Octavas_division;
                seguro_dB = config.Audio.seguro;
                inicio_dB = config.Audio.dB_ini;
    
                % Boton de play para escuchar el sonido propuesto
                playSound1Btn = uibutton(p_cuadro, 'push', 'Text', 'Escuchar Sonido', 'Position', [205 45 150 30], ...
                    'ButtonPushedFcn', @(btn, event) sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq1,soundcardDriver), 'Visible', 'on');
                %noear_button = uibutton(p_cuadro, 'push', 'Text', sprintf('Ya no distingo\nlos sonidos'), 'Position', [230 35 90 50], 'BackgroundColor', '#c2d2d2',...
                    %'Visible', 'on');
                %playSound2Btn = uibutton(p_cuadro, 'push', 'Text', 'Escuchar Sonido 2', 'Position', [345 65 150 30], ...
                    %'ButtonPushedFcn', @(btn, event) sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq2,soundcardDriver), 'Visible', 'on');
            
                % Botones para selección del usuario
                selectSound1Btn = uibutton(p_cuadro, 'push', 'Text', 'Mi tinnitus es más GRAVE', 'Position', [50 15 150 30], 'Visible', 'on');
                selectSound2Btn = uibutton(p_cuadro, 'push', 'Text', 'Mi tinnitus es más AGUDO', 'Position', [370 15 150 30], 'Visible', 'on');
            
                % Botón para finalizar
                finishBtn = uibutton(p_cuadro2, 'push', 'Text', 'Finalizar', 'Position', [370 30 100 30], 'Enable', 'off');
            
                % Botón para play
                playBtn = uibutton(p_cuadro2, 'push', 'Text', 'Play', 'Position', [200 30 100 30], 'Enable', 'off');
            
                % Botón para detener
                detenerBtn = uibutton(p_cuadro2, 'push', 'Text', 'Detener', 'Position', [60 30 100 30], 'Enable', 'off');
            
                % Botones para ajustar decibelios (inactivos al inicio)
                increase1dBBtn = uibutton(p_cuadro2, 'push', 'Text', '+2 dB', 'Position', [50 100 100 30], 'Enable', 'off');
                decrease1dBBtn = uibutton(p_cuadro2, 'push', 'Text', '-2 dB', 'Position', [150 100 100 30], 'Enable', 'off');
                increase10dBBtn = uibutton(p_cuadro2, 'push', 'Text', '+5 dB', 'Position', [330 100 100 30], 'Enable', 'off');
                decrease10dBBtn = uibutton(p_cuadro2, 'push', 'Text', '-5 dB', 'Position', [430 100 100 30], 'Enable', 'off');
                
                % Variables internas
                freq_old = 0;
                dB_level_real = dB_level;
                stop_simulation = false;
                sonido_on = true;
                stop_sonido = false;
    
            
                % Callbacks
                selectSound1Btn.ButtonPushedFcn = @select_sound1;
                selectSound2Btn.ButtonPushedFcn = @select_sound2;
                playSound1Btn.ButtonPushedFcn = @play_s1;
                %playSound2Btn.ButtonPushedFcn = @play_s2;
                %noear_button.ButtonPushedFcn = @fin_sonido;
                finishBtn.ButtonPushedFcn = @finalizar;
                playBtn.ButtonPushedFcn = @play;
                detenerBtn.ButtonPushedFcn = @detener;
                increase1dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(2);
                decrease1dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(-2);
                increase10dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(5);
                decrease10dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(-5);
            
                %% Funcion para tocar continuo (toca frame by frame), en este caso t_durac es la rapidez de respuesta.
                % Tipo_prueba: puede ser 3 simula el acufeno en cuestion
                % asio dice si es prueba de sonido con ASIO o con windows.
                % Aunque no estemos con la prueba3, se debe introducir la frecuencia y los
                % dB del acufeno como si simulara, datos aleatorios, o cero.
                
                % Asignamos valores / para cambio de notación
                level = dB_level_real;  % Nivel dinámico que puede cambiar
                lmax = sensibilidad;
    
                % Configuración de la tarjeta de sonido
                channels = soundcardDriver.channels;
                nbits = soundcardDriver.nbits;
                buffersize = soundcardDriver.buffersize;
                chL = soundcardDriver.channelLeft; % 1
                chR = soundcardDriver.channelRight; % 2
                soundcard = soundcardDriver.soundcard;

                % Para que solo se cree con ASIO
                if asio
                    % Configurar el reproductor de audio (se saca fuera para crearlo solo una vez)
                    nbits_txt = sprintf('%d-bit integer', nbits);
                    aPR = audioPlayerRecorder('Device', soundcard{1,1},...
                                              'SampleRate', fs,...
                                              'BitDepth', nbits_txt,...
                                              'SupportVariableSize', true,...
                                              'BufferSize', buffersize);
                end
    
                % Se inicializa para quitar la rampa de los demas sonidos intermedios
                idx = 0;
    
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
                % Acceder a los datos leídos
                ramp_duration = config.Audio.rampa_tiempo;
                ramp_duration2 = config.Audio.rampa_tiempo2;
    
                % Variables para controlar la reproducción de Sonido 1 y Sonido 2
                play_s1_flag = false;  % Bandera para Sonido 1
                %play_s2_flag = false;  % Bandera para Sonido 2
                play_s1_flag_tocar = false;  % Bandera para Sonido 1 para que toque
                %play_s2_flag_tocar = false;  % Bandera para Sonido 2 para que toque
                s1_start_time = 0;     % Tiempo de inicio de Sonido 1
                %s2_start_time = 0;     % Tiempo de inicio de Sonido 2
    
                
               
                
                % Función para activar la bandera de Sonido 2
                %function play_s2(~, ~)
                    %play_s2_flag_tocar = true;  % Activar la bandera de Sonido 2
                    %s2_start_time = tic;   % Iniciar el temporizador para Sonido 2
                    %drawnow;
                %end
    
    
                %%%%% CREACION DE VALORES ALEATORIOS
                % Valor propuesto
                %v1 = rand();
                %v1 = 0.7431;
                %valor = 25 + (60 - 25) * v1;
                %disp(v1);
                %v2 = rand();
                %v2 = 0.3922;
                %valor1 = 250 + (8000 - 250) * v2;
                %disp(v2);
                %valor1 = 6000;
                %disp('Valores');
                %disp(valor);
                %disp(valor1);
    
    
                % Preasignacion de variables
                t = (0:1/fs:t_durac)';  % Vector de tiempo para el frame actual
                %%% Acufeno simulado
                signal_acu = sin(2 * pi * freq_acu * t);  % Señal sinusoidal
    
                % Aplicar el nivel dinámico (level puede cambiar en cada iteración)
                %%% Acufeno simulado
                dB_out=calibrar_dB_HD_280_PRO(ear_fun, freq_acu, dB_acu);
                signal_acu = SetSignalLevel(signal_acu, dB_out, lmax);
                %signal_acu = SetSignalLevel(signal_acu, dB_acu, lmax);
            
                % GUardamos la señal sin rampa
                %%% Acufeno simulado
                signal_acu_sin = signal_acu; % señal sin rampa (para ASIO) del acufeno
            
                % Aplicar rampa de subida/bajada
                %%% Acufeno simulado
                signal_acu = ramp(signal_acu, 1/fs, 'cos', 'updown', ramp_duration); % señal inicial con rampa normal pra NO ASIO acu
                signal_acu_noasio_medio = ramp(signal_acu, 1/fs, 'cos', 'updown', ramp_duration2); %señal con mas rampa para acu NO ASIO
    
                % Bucle principal de búsqueda de la frecuencia
                % Trabajamos con OCTAVAS
                %function flag = octavas(freq1,freq2, error_freq)
                    %flag = false;
                    %error_freq1 = freq1 * error_freq;
                    %error_freq2 = freq2 * error_freq; % error de la frecuencia promedio geometrico
                    %if ((freq2-error_freq2)<freq1)||((freq1+error_freq1)>freq2)
                        %flag = true;
                    %end
                %end
    
                %flag = octavas(freq1,freq2, error_freq);
    
                % Flags para cambiar el tipo de serie (descendente o
                % ascendente)
                ascendente = true; % se empieza por la serie ascendente
                %descendente = false;
    
                % Flags para decir cuando termino de hacer cada serie
                flag_ascen = false; % desactivo ambas banderas pues no tengo inversion
                flag_descen = false;
    
                % Bandera para poner solo un mensaje 
                ban_men_1 = 0;
                ban_men_2 = 0;
    
                % Flags para determinar si se da inversion
                agudo = true; % flag para la serie descendente (debe ser false para dar inversion)
                grave = true; % flag para la serie ascendente (debe ser false para dar inversion)
    
                % Inicializo los contadores
                iter_ascen = 1;
                iter_descen = 1;
    
                % Inicializo las listas
                freq1_list = [];
                freq2_list = [];
                % Valores de las frecuencias extremo 
                freq1_list(iter_ascen) = freq1;
                freq2_list(iter_descen) = freq2;
            %end
    
                % Bucle principal de búsqueda de la frecuencia
                while (((flag_descen==false)||(flag_ascen==false)) || stop_simulation) && (stop_sonido==false)
                    %uiwait(fig); % Esperar a que el usuario seleccione una opción
                
                    % Verificar si se debe reproducir Sonido 1 o Sonido 2
                    if play_s1_flag_tocar
                        if ascendente
                            % Generar la señal de Sonido 1
                            signal_s1 = sin(2 * pi * freq1 * t);  % Señal sinusoidal de Sonido 1
                            dB_out=calibrar_dB_HD_280_PRO(ear_fun, freq1, level);
                            signal_s1 = SetSignalLevel(signal_s1, dB_out, lmax);
                            %signal_s1 = SetSignalLevel(signal_s1, level, lmax);  % Aplicar nivel dinámico
                            signal_s1 = ramp(signal_s1, 1/fs, 'cos', 'updown', ramp_duration);  % Aplicar rampa  
                            drawnow;
                        else
                            % Generar la señal de Sonido 2
                            signal_s2 = sin(2 * pi * freq2 * t);  % Señal sinusoidal de Sonido 2
                            dB_out=calibrar_dB_HD_280_PRO(ear_fun, freq2, level);
                            signal_s2 = SetSignalLevel(signal_s2, dB_out, lmax);
                            %signal_s2 = SetSignalLevel(signal_s2, level, lmax);  % Aplicar nivel dinámico
                            signal_s2 = ramp(signal_s2, 1/fs, 'cos', 'updown', ramp_duration);  % Aplicar rampa
                            drawnow;
                        end
                        drawnow;
                        % Verificar si ha pasado el tiempo de duración de Sonido 1
                        if toc(s1_start_time) >= t_durac
                            drawnow;
                            play_s1_flag_tocar = false;  % Desactivar la bandera de Sonido 1
                        end
                    end
                    drawnow;
                
                    %if play_s2_flag_tocar
                        % Generar la señal de Sonido 2
                        %signal_s2 = sin(2 * pi * freq2 * t);  % Señal sinusoidal de Sonido 2
                        %dB_out=calibrar_dB_HD_280_PRO(ear_fun, freq2, level);
                        %signal_s2 = SetSignalLevel(signal_s2, dB_out, lmax);
                        %signal_s2 = SetSignalLevel(signal_s2, level, lmax);  % Aplicar nivel dinámico
                        %signal_s2 = ramp(signal_s2, 1/fs, 'cos', 'updown', ramp_duration);  % Aplicar rampa
                        %drawnow;
                        % Verificar si ha pasado el tiempo de duración de Sonido 2
                        %if toc(s2_start_time) >= t_durac
                            %drawnow;
                            %play_s2_flag_tocar = false;  % Desactivar la bandera de Sonido 2
                        %end 
                    %end
    
                    if stop_simulation
                        error('Program terminated for a specific reason');
                    end
    
                
                    % Reproducir la señal combinada
                    if asio
                        % Preparar la señal para la tarjeta de sonido (canales izquierdo/derecho)
                        player_input = repmat(zeros(size(signal_acu(:,1))), 1, channels);
                        player_input_sin = repmat(zeros(size(signal_acu_sin(:,1))), 1, channels);
                        switch ear_fun
                            case 'dere'
                                if mismo==1
                                    if play_s1_flag_tocar && ascendente
                                        signal_acu_mix = signal_acu + signal_s1;
                                        signal_acu_sin_mix = signal_acu_sin +signal_s1;
                                    elseif play_s1_flag_tocar && ~ascendente
                                        signal_acu_mix = signal_acu + signal_s2;
                                        signal_acu_sin_mix = signal_acu_sin +signal_s2;
                                    else
                                        signal_acu_mix = signal_acu;
                                        signal_acu_sin_mix = signal_acu_sin;
                                    end   
                                    player_input(:, chR) = signal_acu_mix;
                                    player_input_sin(:, chR) = signal_acu_sin_mix;
                                elseif mismo==0
                                    if play_s1_flag_tocar && ascendente
                                        player_input(:, chR) = signal_s1;
                                        player_input_sin(:, chR) = signal_s1;
                                    elseif play_s1_flag_tocar && ~ascendente
                                        player_input(:, chR) = signal_s2;
                                        player_input_sin(:, chR) = signal_s2;
                                    end
                                    player_input(:, chL) = signal_acu;
                                    player_input_sin(:, chL) = signal_acu_sin;
                                end
                            case 'izq'
                                if mismo==1
                                    if play_s1_flag_tocar && ascendente
                                        signal_acu_mix = signal_acu + signal_s1;
                                        signal_acu_sin_mix = signal_acu_sin +signal_s1;
                                    elseif play_s1_flag_tocar && ~ascendente
                                        signal_acu_mix = signal_acu + signal_s2;
                                        signal_acu_sin_mix = signal_acu_sin +signal_s2;
                                    else
                                        signal_acu_mix = signal_acu;
                                        signal_acu_sin_mix = signal_acu_sin;
                                    end
                                    player_input(:, chL) = signal_acu_mix;
                                    player_input_sin(:, chL) = signal_acu_sin_mix;
                                elseif mismo==0
                                    if play_s1_flag_tocar && ascendente
                                        player_input(:, chL) = signal_s1;
                                        player_input_sin(:, chL) = signal_s1;
                                    elseif play_s1_flag_tocar && ~ascendente
                                        player_input(:, chL) = signal_s2;
                                        player_input_sin(:, chL) = signal_s2;
                                    end
                                    player_input(:, chR) = signal_acu;
                                    player_input_sin(:, chR) = signal_acu_sin;
                                end
                            case 'ambos'
                                if play_s1_flag_tocar && ascendente
                                    signal_acu_mix = signal_acu + signal_s1;
                                    signal_acu_sin_mix = signal_acu_sin +signal_s1;
                                elseif play_s1_flag_tocar && ~ascendente
                                    signal_acu_mix = signal_acu + signal_s2;
                                    signal_acu_sin_mix = signal_acu_sin +signal_s2;
                                else
                                    signal_acu_mix = signal_acu;
                                    signal_acu_sin_mix = signal_acu_sin;
                                end
                                player_input(:, chL) = signal_acu_mix;
                                player_input(:, chR) = signal_acu_mix;
                                player_input_sin(:, chL) = signal_acu_sin_mix;
                                player_input_sin(:, chR) = signal_acu_sin_mix;
                            otherwise
                                error('invalid input argument');
                        end
                        % restablecemos valores
                        signal_s1 = 0; % restablecemos valores
                        signal_s2 = 0; 
                        signal_acu_mix = signal_acu;
                        signal_acu_sin_mix = signal_acu_sin;
    
                        if idx==0 || ((flag_descen==false)||(flag_ascen==false))
                            % Reproducir el frame actual
                            [~, nUnderruns, nOverruns] = aPR(player_input);  % Reproduce el frame
                        else
                            % Reproducir el frame actual
                            [~, nUnderruns, nOverruns] = aPR(player_input_sin);  % Reproduce el frame
                        end
                    else
                        switch ear_fun
                            case 'dere' % Se mide por el derecho
                                if mismo==1 % se mide y simula por el mismo oido
                                    if play_s1_flag_tocar && ascendente
                                        signal_acu_mix = signal_acu + signal_s1;
                                        signal_acu_noasio_medio_mix = signal_acu_noasio_medio +signal_s1;
                                    elseif play_s1_flag_tocar && ~ascendente
                                        signal_acu_mix = signal_acu + signal_s2;
                                        signal_acu_noasio_medio_mix = signal_acu_noasio_medio +signal_s2;
                                    else
                                        signal_acu_mix = signal_acu;
                                        signal_acu_noasio_medio_mix = signal_acu_noasio_medio;
                                    end
                                    player_input_acu = [zeros(size(signal_acu_mix)),signal_acu_mix];
                                    player_input_sin_acu = [zeros(size(signal_acu_noasio_medio_mix)),signal_acu_noasio_medio_mix];
                                elseif mismo==0
                                    if play_s1_flag_tocar && ascendente
                                        player_input_acu = [signal_acu,signal_s1];
                                        player_input_sin_acu = [signal_acu_noasio_medio,signal_s1];
                                    elseif play_s1_flag_tocar && ~ascendente
                                        player_input_acu = [signal_acu,signal_s2];
                                        player_input_sin_acu = [signal_acu_noasio_medio,signal_s2];
                                    else
                                        player_input_acu = [signal_acu,zeros(size(signal_acu))];
                                        player_input_sin_acu = [signal_acu_noasio_medio,zeros(size(signal_acu_noasio_medio))];
                                    end
                                end
                            case 'izq' % Se mide por el izquierdo
                                if mismo==1 % se mide y simula por el mismo oido
                                    if play_s1_flag_tocar && ascendente
                                        signal_acu_mix = signal_acu + signal_s1;
                                        signal_acu_noasio_medio_mix = signal_acu_noasio_medio +signal_s1;
                                    elseif play_s1_flag_tocar && ~ascendente
                                        signal_acu_mix = signal_acu + signal_s2;
                                        signal_acu_noasio_medio_mix = signal_acu_noasio_medio +signal_s2;
                                    else
                                        signal_acu_mix = signal_acu;
                                        signal_acu_noasio_medio_mix = signal_acu_noasio_medio;
                                    end
                                    player_input_acu = [signal_acu_mix,zeros(size(signal_acu_mix))];
                                    player_input_sin_acu = [signal_acu_noasio_medio_mix,zeros(size(signal_acu_noasio_medio_mix))];
                                elseif mismo==0
                                    if play_s1_flag_tocar && ascendente
                                        player_input_acu = [signal_s1,signal_acu];
                                        player_input_sin_acu = [signal_s1,signal_acu_noasio_medio];
                                    elseif play_s1_flag_tocar && ~ascendente
                                        player_input_acu = [signal_s2,signal_acu];
                                        player_input_sin_acu = [signal_s2,signal_acu_noasio_medio];
                                    else
                                        player_input_acu = [zeros(size(signal_acu)),signal_acu];
                                        player_input_sin_acu = [zeros(size(signal_acu_noasio_medio)),signal_acu_noasio_medio];
                                    end
                                end
                            case 'ambos' % Caso no util pero da sonido por ambos
                                if play_s1_flag_tocar && ascendente
                                    signal_acu_mix = signal_acu + signal_s1;
                                    signal_acu_noasio_medio_mix = signal_acu_noasio_medio +signal_s1;
                                elseif play_s1_flag_tocar && ~ascendente
                                    signal_acu_mix = signal_acu + signal_s2;
                                    signal_acu_noasio_medio_mix = signal_acu_noasio_medio +signal_s2;
                                else
                                    signal_acu_mix = signal_acu;
                                    signal_acu_noasio_medio_mix = signal_acu_noasio_medio;
                                end
                                %%% Acufeno simulado
                                player_input_acu = [signal_acu_mix,signal_acu_mix];
                                player_input_sin_acu = [signal_acu_noasio_medio_mix,signal_acu_noasio_medio_mix];
                            otherwise
                                error('invalid input argument');
                        end
                        % Reproducir el frame actual dependiendo de si es inicial o no el frame
                        if idx==0 || stop_simulation==true % Rampa de ramp_duration1
                            %%% Acufeno simulado
                            sound(player_input_acu,fs);
                            if play_s1_flag_tocar
                                pause(t_durac-ramp_duration); %duration = t_durac - ramp_duration
                            else
                                pause(t_durac-ramp_duration2); %duration = t_durac - ramp_duration
                            end
                        else 
                            %%% Acufeno simulado
                            sound(player_input_sin_acu,fs);
                            if play_s1_flag_tocar
                                pause(t_durac-ramp_duration); %duration = t_durac - ramp_duration
                            else
                                pause(t_durac-ramp_duration2); %duration = t_durac - ramp_duration
                            end
                        end
                        drawnow;
                    end
                
                    % Permitir que MATLAB procese eventos de la interfaz gráfica
                    drawnow;
    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
                    if (play_s1_flag==true) && (stop_sonido==false)
                        % Calcular la nueva frecuencia
                        drawnow;
    
                        if ascendente
                            if ~flag_ascen 
                                % Cambio de etiquetas 
                                freq1Label.Text = ['Frecuencia: ', num2str(freq2, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                serieLabel.Text = 'Serie: Descendente';
                                drawnow;
        
                                if flag_descen
                                    % Cambio de etiquetas 
                                    freq1Label.Text = ['Frecuencia: ', num2str(freq1, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                    serieLabel.Text = 'Serie: Ascendente';
                                    drawnow;
                                end
        
                                freq_nueva_ascen = freq1/n_octavas + freq1; % renombramos la frecuencia de la serie ascenddente (un sexto de octava por encima)
                                drawnow;
                                
                                if ~sonido_selec
                                    flag_ascen = true; % bandera para que se acabe toda la serie
                                    %ascendente = false; % bandera para que cambie a la otra serie
                                    drawnow;
                                else
                                    iter_ascen = iter_ascen + 1; % Cuento el numero de iteraciones
                                    freq1 = freq_nueva_ascen; % Cambio la frecuencia
                                    freq1_list(end+1) = freq1; % Guardo la frecuencia en una lista
                                    drawnow;
                                end
        
                                if flag_descen
                                    % Cambio de etiquetas 
                                    freq1Label.Text = ['Frecuencia: ', num2str(freq1, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                    serieLabel.Text = 'Serie: Ascendente';
                                    drawnow;
                                end
        
                            end
                            
                            if ~flag_descen
                                % Pongo la bandera para que salte a la otra serie
                                ascendente = false;
                            end
                        elseif ~ascendente 
                            if ~flag_descen
                                % Cambio de etiquetas 
                                freq1Label.Text = ['Frecuencia: ', num2str(freq1, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                serieLabel.Text = 'Serie: Ascendente';
        
                                if flag_ascen
                                    % Cambio de etiquetas 
                                    freq1Label.Text = ['Frecuencia: ', num2str(freq2, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                    serieLabel.Text = 'Serie: Descendente';
                                end
        
                                freq_nueva_descen = freq2 - freq2/n_octavas; % renombramos la frecuencia de la serie descendiente 
                                
                                if sonido_selec % (agudo, salimos)
                                    flag_descen = true; % bandera para que se acabe toda la serie
                                    %ascendente = false; % bandera para que cambie a la otra serie
                                    drawnow;
                                else % (grave) mantenemos
                                    iter_descen = iter_descen + 1; % Cuento el numero de iteraciones
                                    freq2 = freq_nueva_descen; % Cambio la frecuencia
                                    freq2_list(end+1) = freq2; % Guardo la frecuencia en una lista
                                    drawnow;
                                end
                                
                                if flag_ascen
                                    % Cambio de etiquetas 
                                    freq1Label.Text = ['Frecuencia: ', num2str(freq2, '%.0f') 'Hz']; % Mantenemos la misma etiqueta
                                    serieLabel.Text = 'Serie: Descendente';
                                    drawnow;
                                end
        
                            end
        
                            if ~flag_ascen
                                % Pongo la bandera para que salte a la otra serie
                                ascendente = true;     
                            end
                        end
    
                        % Se debe apagar las banderas para que no se esté dando
                        % todo el rato este calculo en el bucle sin que se de
                        % al boton
                        play_s1_flag = false;
                        %play_s2_flag = false;
    
                        % Condicion para comprobar si esta dentro del ancho de
                        % banda
                        %flag = octavas(freq1, freq2, error_freq);
        
                        % Condicion para hacer la media geometrica en vez de
                        % guardar el valor de freq_old
                        %if stop_sonido || flag
                            %freq_old = sqrt(freq1*freq2);
                        %end
                        drawnow;
                    end
    
                    % LIMITES
                    % Poner limite para las frecuencias para no pasar la frecuencia
                    % del otro extremo
                    drawnow;
                    if (freq2_list(1)<freq1) % Limite para la serie ascendente
                        drawnow;
                        % Si paso de 8000 (caso inicial) entonces cortar serie
                        % y mandar mensaje de error
                        flag_ascen = true; % bandera para que se acabe toda la serie
                        if ban_men_1==0
                            drawnow;
                            msgbox('Se ha superado el valor extremo de la serie ascendente. Por favor, aumente el valor de "frecuencia alta" en la pantalla de controlador para poder realizar la prueba correctamente para sus valores.','Error', 'error');
                            ban_men_1 = ban_men_1 + 1;
                        end
                    elseif (freq1_list(1)>freq2) % Limite para la serie descendente
                        drawnow;
                        % Si paso por debajo de 250 (caso inicial) entonces cortar serie
                        flag_descen = true; % bandera para que se acabe toda la serie
                        if ban_men_2 ==0
                            drawnow;
                            msgbox('Se ha superado el valor extremo de la serie descendente. Por favor, disminuya el valor de "frecuencia baja" en la pantalla de controlador para poder realizar la prueba correctamente para sus valores.','Error', 'error');
                            ban_men_2 = ban_men_2 + 1;
                        end
                    end
    
                    % Condicion para hacer la media geometrica en vez de
                    % guardar el valor de freq_old
                    if stop_sonido %|| flag
                        freq_old = sqrt(freq1*freq2);
                    end
    
                    if ((flag_ascen==true)&&(flag_descen==true))
                        break;
                    end
    
                    % Contador
                    idx = idx +1;
                    drawnow;
                end
    
                % Liberar el reproductor de audio al finalizar
                if asio
                    release(aPR);
                end
                drawnow;
                
                % Guarda la frecuencia como la media geometrica de las dos
                % frecuencias de cada serie
                if ((flag_ascen==true)&&(flag_descen==true))
                    freq_old = sqrt(freq1*freq2);
                end
            
                %% Actualización de los valores de frecuencia y dB para la segunda parte
                freqLabel = uilabel(p_cuadro2, 'Position', [125 150 200 30], 'Text', ['Frecuencia: ' num2str(freq_old, '%.1f') ' Hz']);
                dBLabel = uilabel(p_cuadro2, 'Position', [300 150 200 30], 'Text', ['Nivel de dB SPL: ' num2str(dB_level_real, '%.0f') ' dB']);
            
                % Activar botones de ajuste de decibelios
                increase1dBBtn.Enable = 'on';
                selectSound1Btn.Enable = 'off';
                selectSound2Btn.Enable = 'off';
                playSound1Btn.Enable = 'off';
                %playSound2Btn.Enable = 'off';
                %noear_button.Enable = 'off';
                decrease1dBBtn.Enable = 'on';
                increase10dBBtn.Enable = 'on';
                decrease10dBBtn.Enable = 'on';
                finishBtn.Enable = 'on';
                playBtn.Enable = 'on';
                detenerBtn.Enable = 'on';
            
                % Quitar de visible
                freq1Label.Visible = 'off';
                serieLabel.Visible = 'off';
                cartel.Visible = 'off';
                cartel=uilabel(p_cuadro, 'Text', {'Deternime la intensidad del su tinnitus'}, 'Position', [30, 85, 500, 50],'HorizontalAlignment', 'center','FontSize', 16, 'Visible', 'on');
    
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
                % Acceder a los datos leídos
                ramp_duration = config.Audio.rampa_tiempo;
                ramp_duration2 = config.Audio.rampa_tiempo2;

            % (333) si se cumple entonces no se hace

            elseif flag_promedio>0
                % Ajustamos frecuencia
                freq_old = freq_fin; % Damos la frecuencia obtenida antes
                % Ajustamos intensidad
                dB_level_real = dB_fin;
                % Ponemos banderas
                stop_sonido = true; % Para que entre en el if de la segunda parte
                flag_ascen = true;
                flag_descen = true;
                % Se hace para que no salga vacio
                freq1_list = [];
                freq2_list = [];
                iter_ascen = 0;
                iter_descen = 0;

                %% Resto del codigo

                %sonido_selec = false; % Flag para la selección de los sonidos 1 (false) y 2 (true)
    
                % Para que cambie de color según el oído
                if ear 
                    p_cuadro.BackgroundColor = '#f77d7b';
                    p_cuadro2.BackgroundColor = '#f77d7b';
                else 
                    p_cuadro.BackgroundColor = '#7bd3f7';
                    p_cuadro2.BackgroundColor = '#7bd3f7';
                end
            
                % Limpiar los paneles antes de agregar nuevos elementos
                delete(p_cuadro.Children);
                delete(p_cuadro2.Children);
          
                % Crear nuevas etiquetas y botones
                cartel=uilabel(p_cuadro, 'Text', {'Deternime la intensidad del su tinnitus'}, 'Position', [30, 85, 500, 50],'HorizontalAlignment', 'center','FontSize', 16, 'Visible', 'on');
                %freq1Label = uilabel(p_cuadro, 'Position', [60 130 400 30], 'FontSize', 12,'Text', ['Frecuencia: ' num2str(freq_old) ' Hz'], 'Visible', 'on');
                %serieLabel = uilabel(p_cuadro, 'Position', [375 130 500 30], 'FontSize', 12,'Text', 'Serie: Asendente', 'Visible', 'on');
            
                % Botones para reproducir sonidos
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
                % Acceder a los datos leídos
                ramp_duration = config.Audio.rampa_tiempo;
                n_octavas = config.General.Octavas_division;
                seguro_dB = config.Audio.seguro;
                inicio_dB = config.Audio.dB_ini;
    
                % Boton de play para escuchar el sonido propuesto
                playSound1Btn = uibutton(p_cuadro, 'push', 'Text', 'Escuchar Sonido', 'Position', [205 45 150 30], ...
                    'ButtonPushedFcn', @(btn, event) sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq1,soundcardDriver), 'Visible', 'on');
                playSound1Btn.Enable = 'off';
                %noear_button = uibutton(p_cuadro, 'push', 'Text', sprintf('Ya no distingo\nlos sonidos'), 'Position', [230 35 90 50], 'BackgroundColor', '#c2d2d2',...
                    %'Visible', 'on');
                %playSound2Btn = uibutton(p_cuadro, 'push', 'Text', 'Escuchar Sonido 2', 'Position', [345 65 150 30], ...
                    %'ButtonPushedFcn', @(btn, event) sonidoASIO(asio,t_durac,ear_fun,fs,dB_level,sensibilidad,ramp_duration,freq2,soundcardDriver), 'Visible', 'on');
            
                % Botones para selección del usuario
                selectSound1Btn = uibutton(p_cuadro, 'push', 'Text', 'Mi tinnitus es más GRAVE', 'Position', [50 15 150 30], 'Visible', 'on');
                selectSound2Btn = uibutton(p_cuadro, 'push', 'Text', 'Mi tinnitus es más AGUDO', 'Position', [370 15 150 30], 'Visible', 'on');
                selectSound1Btn.Enable = 'off';
                selectSound2Btn.Enable = 'off';

            
                % Botón para finalizar
                finishBtn = uibutton(p_cuadro2, 'push', 'Text', 'Finalizar', 'Position', [370 30 100 30], 'Enable', 'on');
            
                % Botón para play
                playBtn = uibutton(p_cuadro2, 'push', 'Text', 'Play', 'Position', [200 30 100 30], 'Enable', 'on');
            
                % Botón para detener
                detenerBtn = uibutton(p_cuadro2, 'push', 'Text', 'Detener', 'Position', [60 30 100 30], 'Enable', 'on');
            
                % Botones para ajustar decibelios (inactivos al inicio)
                increase1dBBtn = uibutton(p_cuadro2, 'push', 'Text', '+2 dB', 'Position', [50 100 100 30], 'Enable', 'on');
                decrease1dBBtn = uibutton(p_cuadro2, 'push', 'Text', '-2 dB', 'Position', [150 100 100 30], 'Enable', 'on');
                increase10dBBtn = uibutton(p_cuadro2, 'push', 'Text', '+5 dB', 'Position', [330 100 100 30], 'Enable', 'on');
                decrease10dBBtn = uibutton(p_cuadro2, 'push', 'Text', '-5 dB', 'Position', [430 100 100 30], 'Enable', 'on');

                % Mensaje informatico
                %uialert(fig, sprintf('Presione los botones "+/- 2 dB" o "+/- 5 dB" para variar la intensidad de la señal y hacer que se parezca a su acúfeno. Se realizan varios trials para promediar la intensidad resultante.'), ...
            %'Inicio de la prueba...', 'Icon', 'info');
                
                % Variables internas
                %freq_old = 0;
                %dB_level_real = dB_level;
                stop_simulation = false;
                sonido_on = true;
                stop_sonido = false;
    
            
                % Callbacks
                selectSound1Btn.ButtonPushedFcn = @select_sound1;
                selectSound2Btn.ButtonPushedFcn = @select_sound2;
                playSound1Btn.ButtonPushedFcn = @play_s1;
                %playSound2Btn.ButtonPushedFcn = @play_s2;
                %noear_button.ButtonPushedFcn = @fin_sonido;
                finishBtn.ButtonPushedFcn = @finalizar;
                playBtn.ButtonPushedFcn = @play;
                detenerBtn.ButtonPushedFcn = @detener;
                increase1dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(2);
                decrease1dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(-2);
                increase10dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(5);
                decrease10dBBtn.ButtonPushedFcn = @(btn, event) adjust_dB(-5);
            

   
     
                %% Actualización de los valores de frecuencia y dB para la segunda parte
                freqLabel = uilabel(p_cuadro2, 'Position', [125 150 200 30], 'Text', ['Frecuencia: ' num2str(freq_old, '%.1f') ' Hz']);
                dBLabel = uilabel(p_cuadro2, 'Position', [300 150 200 30], 'Text', ['Nivel de dB SPL: ' num2str(dB_level_real, '%.0f') ' dB']);
            
                % Activar botones de ajuste de decibelios
                increase1dBBtn.Enable = 'on';
                selectSound1Btn.Enable = 'off';
                selectSound2Btn.Enable = 'off';
                playSound1Btn.Enable = 'off';
                %playSound2Btn.Enable = 'off';
                %noear_button.Enable = 'off';
                decrease1dBBtn.Enable = 'on';
                increase10dBBtn.Enable = 'on';
                decrease10dBBtn.Enable = 'on';
                finishBtn.Enable = 'on';
                playBtn.Enable = 'on';
                detenerBtn.Enable = 'on';
            
                % Quitar de visible
                %freq1Label.Visible = 'off';
                %serieLabel.Visible = 'off';
                %cartel.Visible = 'off';
                %cartel=uilabel(p_cuadro, 'Text', {'Deternime la intensidad del su tinnitus'}, 'Position', [30, 85, 500, 50],'HorizontalAlignment', 'center','FontSize', 16, 'Visible', 'on');
    
                % Selecion del oido en el que se hace sonar la señal
                if ear
                    ear_fun = 'dere';
                else
                    ear_fun = 'izq';
                end
                % Introducir el dato de la rampa
                config = read_ini('../ini/config.ini');
                % Acceder a los datos leídos
                ramp_duration = config.Audio.rampa_tiempo;
                ramp_duration2 = config.Audio.rampa_tiempo2;

            end
    
            
                
                % Uso de la función
                % QUITO LA OCTAVA CONFUSION
                % Uso de la función 
                %if (ban_men_1==0) && (ban_men_2==0) % Si se da corte por que no se ha alcanzado el valor deseado, se sale de todo y no deja que se de lo de octava confusion
                    %freq_old = createSoundSelectionDialog(freq_old);
                %end
    
                % (333) si se cumple entonces no se hace
            %end


            %% Determinación del nivel de dB (búsqueda del nivel de dB)
            if ((flag_ascen==true)&&(flag_descen==true))|| (stop_sonido==true)
                % Condicion para hacer la media geometrica en vez de
                % guardar el valor de freq_old
                %if stop_sonido
                    %freq_old = sqrt(freq1*freq2);
                %end

                % Pone la etiqueta que es
                uialert(figi, ...
                    sprintf(['TRIAL %d: Presione los botones "+/- 2 dB" o "+/- 5 dB" ' ...
                             'para variar la intensidad de la señal y hacer que se parezca a su acúfeno. ' ...
                             'Se realizan varios trials para promediar la intensidad resultante.'], flag_promedio+1), ...
                    sprintf('Inicio de la prueba (trial %d)', flag_promedio+1), ...
                    'Icon', 'info');

                % Funcion para tocar continuo (toca frame by frame), en este caso t_durac es la rapidez de respuesta.
                % Tipo_prueba: puede ser 3 simula el acufeno en cuestion
                % asio dice si es prueba de sonido con ASIO o con windows.
                % Aunque no estemos con la prueba3, se debe introducir la frecuencia y los
                % dB del acufeno como si simulara, datos aleatorios, o cero.
                
                % Asignamos valores / para cambio de notación
                level = dB_level_real;  % Nivel dinámico que puede cambiar
                lmax = sensibilidad;
                frequency = freq_old;
                
                % Configuración de la tarjeta de sonido
                channels = soundcardDriver.channels;
                nbits = soundcardDriver.nbits;
                buffersize = soundcardDriver.buffersize;
                chL = soundcardDriver.channelLeft; % 1
                chR = soundcardDriver.channelRight; % 2
                soundcard = soundcardDriver.soundcard;
                
                if asio
                    % Configurar el reproductor de audio (se saca fuera para crearlo solo una vez)
                    nbits_txt = sprintf('%d-bit integer', nbits);
                    aPR = audioPlayerRecorder('Device', soundcard{1,1},...
                                              'SampleRate', fs,...
                                              'BitDepth', nbits_txt,...
                                              'SupportVariableSize', true,...
                                              'BufferSize', buffersize);
                end

                
                % Metemos valor aleatorio
                %function valor = numero_aleatorio_35_55()
                %%%%%% CREACION DE VALORES ALEATORIOS
                %end
                %valor = numero_aleatorio_35_55();
                
                


                %%%%% (333) Se repite varias veces para poder hacer promedio de la
                % (333) intensidad sonora y encontrar una mejor aproximacion a la
                % (333) sonoridad
                % (333) Se fija el valor final de dB_level_real_fin a cero
                %dB_level_real_fin = 0;
                %flag_promedio = 0;
                %while flag_promedio<3    
    
                % Se inicializa para quitar la rampa de los demas sonidos intermedios
                idx = 0;
                % Bucle principal
                while  ~stop_simulation%~finishBtn.UserData % (lo primero es para el codigo normal, lo segundo para el run_sonido)  %~stop_simulation
                    if sonido_on
                        % Generar la señal para el frame actual
                        t = (0:1/fs:t_durac)';  % Vector de tiempo para el frame actual
                        signal = sin(2 * pi * freq_old * t);  % Señal sinusoidal
                        %%% Acufeno simulado
                        signal_acu = sin(2 * pi * freq_acu * t);  % Señal sinusoidal
                        

                        % Aplicar el nivel dinámico (level puede cambiar en cada iteración)
                        dB_out=calibrar_dB_HD_280_PRO(ear_fun, freq_old, dB_level_real);
                        signal = SetSignalLevel(signal, dB_out, lmax);
                        %signal = SetSignalLevel(signal, dB_level_real, lmax);
                        %%% Acufeno simulado
                        dB_out1=calibrar_dB_HD_280_PRO(ear_fun, freq_acu, dB_acu);
                        signal_acu = SetSignalLevel(signal_acu, dB_out1, lmax);
                        %signal_acu = SetSignalLevel(signal_acu, dB_acu, lmax);
                                
                    
                        % GUardamos la señal sin rampa
                        signal_sin = signal; % señal de por medio sin rampa para ASIO
                        %%% Acufeno simulado
                        signal_acu_sin = signal_acu; % señal sin rampa (para ASIO) del acufeno
                        
                        % Comprobacion
                        %disp('Nivel al que quiero que suene acu');
                        %disp(dB_acu);
                        %disp(dB_out1);
                        %disp('Nivel al que quiero que suene sonido');
                        %disp(dB_level_real);
                        %disp(dB_out);
  

                        % Aplicar rampa de subida/bajada
                        signal = ramp(signal, 1/fs, 'cos', 'updown', ramp_duration); % señal inicial con rampa normal
                        signal_noasio_medio = ramp(signal, 1/fs, 'cos', 'updown', ramp_duration2); % señal de por medio con mas rampa para NO ASIO
                        %%% Acufeno simulado
                        signal_acu = ramp(signal_acu, 1/fs, 'cos', 'updown', ramp_duration); % señal inicial con rampa normal pra NO ASIO acu
                        signal_acu_noasio_medio = ramp(signal_acu, 1/fs, 'cos', 'updown', ramp_duration2); %señal con mas rampa para acu NO ASIO
                        
                        
                        % Cambio de variables
                        if mismo==1
                            mismo_f = true;
                        elseif mismo ==0
                            mismo_f = false;
                        end

                        % Reproducir con o sin ASIO
                        if asio
                            % Preparar la señal para la tarjeta de sonido (canales izquierdo/derecho)
                            player_input = repmat(zeros(size(signal(:,1))), 1, channels);
                            player_input_sin = repmat(zeros(size(signal_sin(:,1))), 1, channels);
                            switch ear_fun
                                case 'dere' % Se mide por el derecho
                                    if mismo_f % Se mide y se simula por el mismo odio
                                        player_input(:, chR) = signal+signal_acu;
                                        player_input_sin(:, chR) = signal_sin+signal_acu_sin;
                                    else
                                        player_input(:, chR) = signal;
                                        player_input_sin(:, chR) = signal_sin;
                                        %%% Acufeno simulado
                                        player_input(:, chL) = signal_acu;
                                        player_input_sin(:, chL) = signal_acu_sin;
                                    end
                                case 'izq' % Se mide por el izquierdo
                                    if mismo_f % Se mide y se simula por el mismo odio
                                        player_input(:, chL) = signal+signal_acu;
                                        player_input_sin(:, chL) = signal_sin+signal_acu_sin;
                                    else
                                        player_input(:, chL) = signal;
                                        player_input_sin(:, chL) = signal_sin;
                                        %%% Acufeno simulado
                                        player_input(:, chR) = signal_acu;
                                        player_input_sin(:, chR) = signal_acu_sin;
                                    end
                                case 'ambos' % Caso no util pero da sonido por ambos
                                    %%% Acufeno simulado
                                    player_input(:, chL) = signal+signal_acu;
                                    player_input(:, chR) = signal+signal_acu;
                                    player_input_sin(:, chR) = signal_sin+signal_acu_sin;
                                    player_input_sin(:, chL) = signal_sin+signal_acu_sin;
                                otherwise
                                    error('invalid input argument');
                            end
                    
                            % Reproducir el frame actual
                            if idx==0 || stop_simulation==true % COn rampa ramp_duration1
                                [~, nUnderruns, nOverruns] = aPR(player_input);  % Reproduce el frame con rampa
                            else  % Sin rampa
                                [~, nUnderruns, nOverruns] = aPR(player_input_sin); % Reproduce sin rampa
                            end

                            % Verificar underruns/overruns
                            if nUnderruns > 0
                                warning('Audio player queue was underrun by %d samples.\n', nUnderruns);
                            end
                            if nOverruns > 0
                                fprintf('Audio recorder queue was overrun by %d samples.\n', nOverruns);
                            end

                        else
                            switch ear_fun
                                case 'dere' % Se mide por el derecho
                                    if mismo_f % se mide y simula por el mismo oido
                                        player_input_acu = [zeros(size(signal)),signal+signal_acu];
                                        player_input_sin_acu = [zeros(size(signal_noasio_medio)),signal_noasio_medio+signal_acu_noasio_medio];
                                    else
                                        player_input_acu = [signal_acu,signal];
                                        player_input_sin_acu = [signal_acu_noasio_medio,signal_noasio_medio];
                                    end
                                case 'izq' % Se mide por el izquierdo
                                    if mismo_f % se mide y simula por el mismo oido
                                        player_input_acu = [signal+signal_acu,zeros(size(signal))];
                                        player_input_sin_acu = [signal_noasio_medio+signal_acu_noasio_medio,zeros(size(signal_noasio_medio))];
                                    else
                                        player_input_acu = [signal,signal_acu];
                                    player_input_sin_acu = [signal_noasio_medio,signal_acu_noasio_medio];
                                    end
                                case 'ambos' % Caso no util pero da sonido por ambos
                                    %%% Acufeno simulado
                                    player_input_acu = [signal+signal_acu,signal+signal_acu];
                                    player_input_sin_acu = [signal_noasio_medio+signal_acu_noasio_medio,signal_noasio_medio+signal_acu_noasio_medio];
                                otherwise
                                    error('invalid input argument');
                            end
                            % Reproducir el frame actual dependiendo de si es inicial o no el frame
                            if idx==0 || stop_simulation==true % Rampa de ramp_duration1
                                %%% Acufeno simulado
                                sound(player_input_acu,fs);
                                pause(t_durac-ramp_duration2); %duration = t_durac - ramp_duration
                            else 
                                %%% Acufeno simulado
                                sound(player_input_sin_acu,fs);
                                pause(t_durac-ramp_duration2); %duration = t_durac - ramp_duration
                            end
                        end
                                      
                        % Permitir que MATLAB procese eventos de la interfaz gráfica
                        drawnow;
                    
                        % Pausa breve para permitir interacción con la GUI
                        %pause(t_durac-ramp_duration2); % Ponerlo por debajo de la escucha del SH
                    end
                
                    % Actualizar etiquetas dinámicamente
                    freqLabel.Text = ['Frecuencia: ' num2str(freq_old, '%.0f') ' Hz'];
                    dBLabel.Text = ['Nivel de dB SPL: ' num2str(dB_level_real, '%.0f') ' dB'];

                    % Condicion de seguridad
                    if dB_level_real>=seguro_dB
                        stop_simulation = true;
                        warning('Se ha alcanzado la máxima intesidad en dB SPL.')
                    end
                
                    % Se pone contador para determinar cuando hay rampa
                    idx = idx +1;
                    drawnow;
                end
                

                %%
                if asio
                    release(aPR); % (Meter fuera del while) Se libera el sonido (si lo quito no hace nada con respecto a la latencia)
                end
                drawnow;



                % (333) Se pone tambien que se haga la media
                %dB_level_real_fin =dB_level_real_fin + dB_level_real/3;


            end
            
            % (333) Y se iguala para poder tomar el valor final como el
            % (333) promedio
            %dB_level_real = dB_level_real_fin;
            flag_promedio = flag_promedio + 1;
            %disp(flag_promedio);
            flag_promedio_resul = flag_promedio;

            %end

            
            % Callback para finalizar la simulación
            function finalizar(~, ~)
                    stop_simulation = true; % se finaliza todo
            end
        
            % Callback para ajustar los niveles de decibelios
            function adjust_dB(change)
                dB_level_real = dB_level_real + change;
            end

            % Funcion para parar cuando se escuche igual
            function fin_sonido(~, ~)
                stop_sonido = true;
                uiresume(figi);
            end
        
            % Callback para seleccionar Sonido 1 (GRAVE)
            function select_sound1(~, ~)
                %freq_old = freq1;
                sonido_selec = false;
                play_s1_flag = true;
                uiresume(figi);
            end
        
            % Callback para seleccionar Sonido 2 (AGUDO)
            function select_sound2(~, ~)
                %freq_old = freq2;
                sonido_selec = true;
                play_s1_flag = true;
                uiresume(figi);
            end
        
            % Callback para seleccionar play
            function play(~, ~)
                sonido_on = true;
                %uiresume(fig);
            end
        
            % Callback para seleccionar detener
            function detener(~, ~)
                sonido_on = false;
                %uiresume(fig);
            end
        

        end
    end


end