# Arqui1 - Proyecto2
## Minutes

### Reuniones
    Reuniones al menos una vez por semana,  lunes 8pm.


### Python
*1. Crear un programa en Python que permita entender cómo funciona el algoritmo de interpolación bilineal.*

*2. Crear un programa en Python que cargue una imagen a escala de grises, divida dicha imagen en 4x4 cuadrantes y permita seleccionar uno de esos cuadrantes para que le aplique el algoritmo de interpolación bilineal.*


### ARM/RISC-V
*1. Crear un programa en ensamblador ARM o RISC-V que aplique el algoritmo de interpolación bilineal a una matriz pequeña. Poner atención a las operaciones de multiplicación y división que pueden ser de punto flotante. Investigar métodos alternativos como el de suma y restas sucesivas. La idea es usar instrucciones y modos de direccionamiento sencillos del lenguaje.*

*2. Intentar realizar el programa con instrucciones más especializadas. Evaluar ambas soluciones.*

    Fecha inicio: Jueves 26 de Septiembre.

    Propuesta: Emanuel Marín y Kun Zheng deben realizar por aparte la solución del algoritmo usando ARM o RISC-V. Luego revisar las soluciones y discutirlas para obtener una solución final.

    Fecha límite: Lunes 30 de Septiembre. Debería estar lista la solución final. Validar si es necesario mostrársela al profe.


### ISA

    Fecha inicio: Martes 01 de Octubre.

    Propuesta: A partir del martes Emanuel Marín y Kun Zheng deben empezar a tener reuniones para crear el ISA y dejar listo el green card. Se recomienda que Jessica Espinoza también participe en dichas reuniones. Se puede evaluar la opción de pedir una sala para trabajar en el Learning Commons. Una vez listo el ISA se debe pasar el programa hecho en ARM o RISC-V. También José Vargas.

    Fecha límite: Viernes 04 de Octubre. Tener la aprobación del ISA por parte del profe.
    

### Compilador

    Propuesta: El desarrollo del compilador queda a manos de Jessica Espinoza (por eso la idea que participe en las reuniones del diseño del ISA). Se espera que Kun Zheng colabore con el Análisis Léxico, Sintáctico y Semántico si ya posee dichos conocimientos. Emanuel Marín también puede colaborar más adelante de ser necesario.

    Fecha límite: Tenerlo listo o avanzado antes del desarrollo completo del procesador pipeline para poder realizar pruebas.


### Procesador Pipeline

    Propuesta: El desarrollo de la microarquitectura Pipeline queda a manos de Emanuel Marín. Cuando ya esté definido el ISA, Emanuel tiene una semana para evaluar e indicarle al grupo si necesitará algo de ayuda.

    Fecha límite: Tenerlo listo cuando falte semana y media para entregar el proyecto, para así poder hacer pruebas de integración con más tiempo.


### JTAG

    Propuesta: La implementación, integración y uso del JTAG queda a manos de José Vargas. Preguntarle al profe si es necesario crear desde cero el JTAG o si se puede usar el que Quartus proporciona (ver sección de Platform Design en Quartus). 

    Fecha límite: Tenerlo listo una semana antes de la entrega del proyecto.


### Controlador VGA

    Propuesta: José Vargas y/o Jessica Espinoza queda/an a cargo de desarrollar el controlador VGA, por ahora, en un proyecto aparte. La idea es que dicho controlador lea los datos de memoria y permita:
    - Visualizar la imagen original completa con la división en 4x4 cuadrantes.
    - Poder seleccionar y ver un cuadrante especificado (aún no se ha aplicado el algoritmo de interpolación bilineal).
    - Cargar en memoria el cuadrante al que se le aplicó el algoritmo y visualizarlo.

    Fecha límite: Tenerlo listo semana y media antes de la entrega del proyecto para tener oportunidad de desarrollar el controlador HDMI.


### Controlador HDMI (+20 pts)

    Propuesta: José Vargas y/o Jessica Espinoza queda/an a cargo de desarrollar el controlador HDMI una vez que el de VGA funcione completamente.

    Fecha límite: Tenerlo listo media semana antes de la entrega del proyecto.


### Driver mouse/teclado (+20 pts)

    Propuesta: Emanuel Marín y/o Kun Zheng queda/an a cargo de desarrollar el driver del mouse/teclado

    Fecha límite: Tenerlo listo media semana antes de la entrega del proyecto.


### RGB (+10 pts)

    Propuesta: Poder soportar imágenes a color queda a cargo de Emanuel Marín.

    Fecha límite: Tenerlo listo media semana antes de la entrega del proyecto.

## Desarrolladores
* **Jessica Espinoza** - [Jespinoza1703](https://github.com/Jespinoza1703)
* **Emanuel Marín** - [MarinGE23](https://github.com/MarinGE23)
* **José Vargas** - [JoseAndresVargasTorres](https://github.com/JoseAndresVargasTorres)
* **Kun Zheng** - [kunZhen](https://github.com/kunZhen)
