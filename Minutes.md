### Kun Kin y Jose Vargas

Van a trabajar en una branch aparte para hacerle pruebas al procesador uniciclo con diferentes imágenes y de diferentes tamaños (dentro del rango definido por el profe). Preferiblemente que Jose haga las pruebas.

Jose: Hacer el driver del teclado/mouse (el que sea más fácil y seguro de poder sacarlo a tiempo). Ayudar con lo que tiene asignado Kun y probar el driver en la integración completa.

Kun: va a integrar el procesador con la VGA y algunos switches en un solo módulo y sintetizar todo eso para cargarlo en la FPGA.

La idea es que al ejecutar el programa, en la VGA se muestra la imagen original, si con los switches se establece el cuadrante de la imagen y se activa el switch que permite procesar, en la VGA se muestra el resultado de la interpolación del cuadrante.

Notas: La selección del cuadrante con los switches se debe guardar en la tercer línea de la memoria (las primeras dos líneas son para el ancho y largo de la imagen).

El procesador funciona apenas se activa o levanta el switch dedicado para ello.

Se debe tomar en cuenta lo que mencionó el profe de usar una memoria con dos buses o puertos. Lo más seguro es que se deba quitar el módulo de memoria que hice por la memoria de Quartus y cargarle los datos con el .mif en lugar del comando readmemh.



Adicional (no prioritario por ahora): Debe haber un switch que permita hacer reset, es decir, volver a poner en la VGA la imagen original, que se permita de nuevo seleccionar con los switches el cuadrante y activar de nuevo el procesador.

### Jessica Espinoza 

Hacer un pdf de una página con el green card del ISA. Investigar exactamente qué debe llevar o preguntarle al profe para salir de dudas. Se puede basar en el green card de la documentación oficial de RISC-V y las tablas hechas en el Excel.

Esperar por el boceto de la Micro arquitectura Pipeline y pasar el diseño a Fitma.

Avanzar con todo lo solicitado en la documentación, Emanuel puede colaborar en las secciones que involucran el diseño del ISA y la Micro arquitectura.

Colaborar con Kun y José Vargas.


### Emanuel Marín

Diseñar e implementar el Pipeline