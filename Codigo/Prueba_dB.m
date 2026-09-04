% Comprobacion
dB_acu = 52;
dB_level_real = 35;
ear_fun = 'dere';

% Valor aleatorio
function valor = numero_aleatorio_35_55()
    valor = 35 + (55 - 35) * rand();
end
valor = numero_aleatorio_35_55();


% Figura 1
figure();

f = (250:50:8000)';
vector1 = zeros(length(f),1);
vector2 = zeros(length(f),1);
vector3 = zeros(length(f),1);
vector4 = zeros(length(f),1);
for i=1:length(f)
    out1=calibrar_dB_HD_280_PRO(ear_fun, f(i), dB_level_real);
    out2=calibrar_dB_HD_280_PRO(ear_fun, f(i), dB_acu);
    vector1(i) =  out1;
    vector2(i) = dB_level_real;
    vector3(i) = out2;
    vector4(i) = dB_acu;
end

plot(f, vector1, 'r', 'DisplayName', 'salida 1');
hold on
plot(f, vector2, 'm', 'DisplayName', 'dB deseado');
plot(f, vector3, 'b', 'DisplayName', 'salida 2 ACU');
plot(f, vector4, 'c', 'DisplayName', 'dB deseado ACU');
hold off


% Figura 2
figure();

freq1 = 6000;
freq2 = 1000;

f = (30:1:60)'; %dB
vector1 = zeros(length(f),1);
vector2 = zeros(length(f),1);
vector3 = zeros(length(f),1);
vector4 = zeros(length(f),1);
for i=1:length(f)
    out1=calibrar_dB_HD_280_PRO(ear_fun, freq1, f(i));
    out2=calibrar_dB_HD_280_PRO(ear_fun, freq2, f(i));
    vector1(i) =  out1;
    vector2(i) = f(i);
    vector3(i) = out2;
    vector4(i) = f(i);
end

plot(f, vector1, 'r', 'DisplayName', 'salida 1 freq 1');
hold on
plot(f, vector2, 'm', 'DisplayName', 'dB deseado freq1');
plot(f, vector3, 'b', 'DisplayName', 'salida 2 freq2');
plot(f, vector4, 'c', 'DisplayName', 'dB deseado freq2');
hold off