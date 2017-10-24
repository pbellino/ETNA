# ETNA

## Caracterización de detectores neutrónicos

En este repositorio estarán todos los archivos necesarios para realizar la experiencia de caracterización de detectores neutrónicos para la Escuela de Técnicas Neutrónicas Aplicadas.

Los archivos aquí subidos pueden ser ejecutados con el software [Octave](https://www.gnu.org/software/octave/) (recomendado, de distribución gratuita) o con [Matlab](https://es.mathworks.com/). Todos los scripts son ejemplos mínimos de las tareas que se tendrán que hacer durante la experiencia. Se dan dos archivos de espectros similares a los que se obtendrán de las mediciones. 

Los archivos de los espectros con que se trabajarán están en formato .CNF (Canberra Nuclear Files) y son archivos binarios pensados para ser leidos con el software de Canberra Genie2000. Los scripts aquí incluidos sólo leen la parte más relevante de dichos archivos. 

La idea es que una vez que se entienda qué hace cada script, luego pueda ser modificado en base a lo que se quiera calcular y/o graficar a partir de los espectros medidos.

### Contenido del repositorio

Algunos archivos están pensados para que sean modificados y adaptados a lo que se quiera hacer. Otros, en cambio, son funciones auxiliares requeridos parar que los otros scripts funcionen. Estos últimos no requieren que sean modificados.

1. Archivos para ser modificados

  * `graficar_espectros.m`: Graficar uno o varios espectros leyendo directamente los archivos .CNF
  * `resolución_picos.m`: Realiza un ajuste Gaussiano a los picos indicados del espectro, calculando su valor medio, FWHM y resolución.
  * `plateau.m'`: Construye la curva de de contaje discriminado en función del voltaje aplicado para obtener la curva de plateau del detector.

2. Archivos que no necesitan modificarse

  * `M98.CNF` y `M99.CNF`: Ejemplo de dos espectros similares a los que se obtendrán en la experiencia. Fueron obtenidos con un multicanal de 8192 canales (posteriormente se seleccionaron 4096)
  * `lee_cnf`: Función que lee los archivos .CNF
  * `resampleo.m`: Función para agrupar los canales y mejorar la estadística del conteo.
  
Se trató de que todos los archivos tuvieran los comentarios necesarios en cada instrucción para que fueran fáciles de leer y que se entendiera qué es lo que se hace en cada parte del código. Muchas cosas pueden hacerse de forma más eficiente, pero se prefirió priorizar la claridad.

### Otras opciones

Para aquellos que nunca hayan utilizado el software Octave y/o Matlab, también está la opción que trabajen con cualquier otro software para graficación y análisis de datos: [Python](https://www.python.org/), [Origin](http://www.originlab.com/Origin), alguna planilla de cálculo ([LibreOffice Calc](https://es.libreoffice.org/descubre/calc/), por ejemplo), etc.

Para ello necesitarán tener en versión texto los datos de los espectros contenidos en el archivo `.CNF`. Yo tengo un script en python que realiza dicha tarea y lo pueden obtener de [este repositorio](https://github.com/pbellino/CNFreader). De todas formas, al momento de procesar los espectros, se les ofrecerán los archivos .CNF ya convertidos para que puedan trabajar sin inconvenientes con el software que prefieran.

### Contacto

Cualquier problema o error que se encuentre al utilizar estos archivos no duden en comunicarse conmigo (Pablo Bellino) <pbellino@gmail.com>
