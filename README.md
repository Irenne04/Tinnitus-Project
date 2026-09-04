# TinniT_US

Sistema de software para la ejecución, calibración y evaluación de pruebas de acufenometría y audiometría en el ámbito clínico, junto con un módulo de revisión bibliográfica sobre el tinnitus.

> ⚠️ **IMPORTANTE:** Los archivos contenidos en la carpeta `TinniT_US` **no deben ser modificados ni movidos** a otro directorio para garantizar la integridad y el correcto funcionamiento del sistema.

---

## 📄 Revisión Bibliográfica (`Tinnitus_Review.pdf`)

El proyecto integra una revisión bibliográfica detallada que abarca los fundamentos, evaluación y tratamiento del tinnitus. La estructura del documento contempla las siguientes secciones principales:

* **Sobre el Tinnitus:** Causas, clasificación/tipos y metodología de estudio.
* **Medida del Tinnitus de Manera Subjetiva:**
  * Cuestionarios estandarizados (THI, TRQ, TFI, TSI, TPFQ, THQ).
  * Escalas Análogas Visuales (VAS).
  * Comparativa entre métodos y planteamiento metodológico de los cuestionarios.
* **Medida del Tinnitus de Manera Objetiva:**
  * Búsqueda de tono (MOA, método adaptativo, clasificación de semejanza, límites, 2AFC).
  * Búsqueda de intensidad (según R. S. Tyler et al., 2007).
  * Enmascaramiento y post-enmascaramiento.
  * Modelos neurofisiológicos de generación del tinnitus.
  * Evaluación clínica: Historia clínica, pruebas/exámenes auditivos y clínicos.
* **Tratamientos para el Tinnitus:**
  * Terapias sonoras (enmascaramiento, enriquecimiento ambiental, audífonos, música, TRT).
  * Psicoterapias, tratamientos farmacológicos, terapias físicas y abordajes quirúrgicos.
* **Impacto Social y Conclusiones.**

---
# Programa de pruebas de acufenometría y audiometría
---

## 🛠️ Requisitos del Sistema

Antes de comenzar, asegúrate de contar con los siguientes elementos:

1. **Software**:
   * **MATLAB** (R2018b o superior recomendado).
   * **Audio Toolbox** de MATLAB (necesario para el manejo de controladores de audio).
2. **Hardware**:
   * Tarjeta de sonido profesional compatible con controladores **ASIO** (Configurado por defecto para **RME Fireface**).
   * Auriculares de prueba calibrados (modelo **Sennheiser HD 280 PRO**).
3. **Controladores**:
   * Driver ASIO correspondiente a la tarjeta de sonido instalada.

---

## 📋 Procedimiento de Uso

### 1. Calibración y Configuración (Solo Desarrolladores / Mantenimiento)
Si es la primera vez que se utiliza el equipo o se han cambiado los auriculares/tarjeta de sonido:
1. Abrir MATLAB y navegar al directorio del proyecto.
2. Ejecutar `calibrar.m` para generar o actualizar el archivo `calibrar.ini`.
3. Ajustar las correspondencias de decibelios con `calibrar_dB_HD_280_PRO.m` apoyándose en la plantilla `calibrar_HD_280_PRO.xlsx`.
4. Si se requiere modificar las frecuencias o valores por defecto de la prueba, ejecutar `dBHL.m` o `config.m` para actualizar los archivos `dBHL.ini` y `config.ini`.

### 2. Ejecución de Pruebas Clínicas (Para Audiólogos)
1. Conectar la tarjeta de sonido ASIO y los auriculares Sennheiser HD 280 PRO al sistema.
2. Abrir MATLAB.
3. Ejecutar el script principal desde la consola de comandos:
   ```matlab
   PROGRAMA_PRINCIPAL_ACUFENOMETRIAS

---

## 🚀 Programa Principal

El programa destinado al uso del audiólogo durante las pruebas es:

- **`PROGRAMA_PRINCIPAL_ACUFENOMETRIAS.m`**

El resto de los archivos `.m` del repositorio actúan como funciones internas y de soporte para este ejecutable base.

---

## ⚙️ Permisos de Desarrollador y Configuración

Para modificar los valores estándar de los parámetros de control, utilice los archivos `.ini` correspondientes:

* **Archivos `.ini`**: Almacenan los valores estándar utilizados en las pruebas (`config.ini`, `dBHL.ini`, `calibrar.ini`).
* **Generadores de configuración**:
  * `config.m` $\rightarrow$ Genera `config.ini` (define los datos de control de las pruebas).
  * `dBHL.m` $\rightarrow$ Genera `dBHL.ini` (almacena las frecuencias empleadas en las pruebas de audiometría, siguiendo los estándares de la AAOO).
  * `calibrar.m` $\rightarrow$ Genera `calibrar.ini` (define los parámetros para la calibración de los auriculares).

---

## 📁 Estructura y Descripción de Archivos

| Archivo | Descripción |
| :--- | :--- |
| `PROGRAMA_PRINCIPAL_ACUFENOMETRIAS.m` | **Programa principal** utilizado por el audiólogo para ejecutar las pruebas. |
| `TinniT_US_play.m` | Programa base de interacción durante las sesiones clínicas. |
| `ejecutar.m` | Ejecuta las distintas pruebas internas (*función interna, no se recomienda modificar*). |
| `calibrar.m` | Crea el archivo `calibrar.ini` con parámetros de calibración. |
| `calibrar_dB_HD_280_PRO.m` | Ajusta los dB deseados a los dB de entrada requeridos para los auriculares Sennheiser HD 280 PRO. |
| `calibrar_HD_280_PRO.xlsx` | Hoja de cálculo auxiliar para el proceso de calibración de auriculares. |
| `config.m` | Crea el archivo `config.ini` para parámetros de control. |
| `dBHL.m` | Crea `dBHL.ini` con frecuencias estandarizadas (AAOO). |
| `datos_prueba.txt` | Archivo temporal para transcribir datos antes de generar el informe final del audiólogo. |
| `gain.m` | Aplica una ganancia en dB a una señal de entrada $x$ *(© 2025 Almudena Eustaquio Martín)*. |
| `PlayBlocking_ASIO.m` | Reproduce audio mediante tarjeta compatible con ASIO (por defecto: RME Fireface). Requiere *Matlab Audio Toolbox* *(© 2025 Almudena Eustaquio Martín)*. |
| `Prueba_dB.m` | Script de prueba rápida para verificación de escucha con funciones personalizadas. |
| `ramp.m` | Aplica una rampa a señales de una sola fila/columna *(© 2007 Almudena Eustaquio Martín)*. |
| `read_ini.m` | Parser para la lectura de archivos de configuración `.ini`. |
| `relaciondBHL.m` | Convierte valores de dB SPL a dB HL para representación gráfica de audiogramas. |
| `rms_usal.m` | Calcula el valor Root Mean Square (RMS) de una señal $x$ *(© 2008 Almudena Eustaquio Martín)*. |
| `rms2dBspl.m` | Convierte amplitud RMS a dB SPL considerando la calibración del sistema *(© 2008 Almudena Eustaquio Martín)*. |
| `select_SoundCardDriver.m` | Detección de dispositivos ASIO conectados *(© 2025 Almudena Eustaquio Martín)*. |
| `SetSignalLevel.m` | Ajusta la amplitud relativa a un valor dB y sensibilidad propuestos *(© 2025 Almudena Eustaquio Martín)*. |
| `sonidoASIO.m` | Función para reproducción de señales mediante controladores ASIO. |

---
