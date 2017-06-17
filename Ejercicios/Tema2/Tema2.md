# SERVIDORES WEB DE ALTAS PRESTACIONES


## Ejercicios Tema 2


### **Hugo Maldonado Cózar**

# <a></a>

### Ejercicio 1
#### Calcular la disponibilidad del sistema si tenemos dos réplicas de cada elemento (en total 3 elementos en cada subsistema).

![Ejercicio 1](./img/ej1.jpg)

# <a></a>
### Ejercicio 2
#### Buscar frameworks y librerías para diferentes lenguajes que permitan hacer aplicaciones altamente disponibles con relativa facilidad.

- **JQuery**. Uno de los frameworks de `Javascript` más utilizados en la actualidad, sobre todo por la facilidad con la que se tratan las estructuras del `DOM` de `HTML`, también por el fácil "bindeo" de los eventos, así como la implementación de muchas funcionalidades que se ven en muchas webs (como por ejemplo la facilidad con la que se desarrolla una llamada en `AJAX` comparada con `Javascriptp` puro). Es compatible con todos los navegadores hoy en día (sobre todo devido a la estandarización que hubo hace tiempo de `Javascript` en el lado del cliente).

- **AngularJS**. Otro de los grandes framework de `Javascript` del lado del cliente. En este caso, el principal desarrollador es `Google` por lo que nos da una cierta seguridad de su funcionamiento y mantenibilidad. Está principalmente desarrollado para una integración muy avanzada con servidores escritos en `nodejs`, aunque no es su única baza a favor. Normalmente se suele utilizar para mantener aplicaciones web en única página donde todo sea comunicación con el servidor a través de este framework, aunque si se enlaza con el desarrollo del servidor con el framework `express` (del que hablaremos más adelante) podemos conseguir una experiencia multipágina con interacción avanzada entre el cliente y el servidor.

- **Laravel**. Framework de `PHP` de código libre bastante utilizado en la actualidad. Algunas de sus principales funcionalidades son facilidad de implementación de mecanismos de autenticación, automatización de tareas, paginación, ORM, sistema de caché de alto rendimiento, sistema de enrutación fácil, asequible y rápido (válido también para arquitecturas `RESTFULL`), encriptación...

- **Docker**. Permite desplegar aplicaciones web (conocidos como contenedores software) de forma automática y sencilla, permitiendo una gran elevada escalabilidad, así como una portabilidad muy fácil de mantener. Cada contenedor se ejecuta de forma independiente.

- **Express**. Es un framework que se introduce junto a `nodejs` para realizar aplicaciones web multipágina o para las diferentes rutas de una API. Es muy sencillo de utilizar, a la vez que es rápido y eficiente, ya que se puede ver como un árbol de rutas en las que hay diferentes niveles, lo que le permite acceder muy rápidamente a las rutas sin mayor cómputo que la búsqueda simplista en un árbol.

- **PM2**. Es un administrador de procesos de `nodejs`. Ya tiene implementado un balanceador de carga que podemos utilizar para la administración de un cluster de servidores escritos en `nodejs`. Nos permite mantener los servidores lanzados en `nodejs` activos siempre, teniendo bastante información sobre su estado, como estadísticas, RAM utilizada, peticiones, recursos disponibles y en uso... Por lo que también facilita las tareas de administración de los sistemas. Además, un sistema (o cluster) lanzado con `PM2` puede reiniciarse en caso de caida por alguna excepción software o fallo en el sistema. También puede lanzar en la misma máquina diferentes instancias del servidor web y utilizar su balanceador para poder hacer más procesamiento en paralelo.

- **Symfony**. Framework de `PHP` para la optimización del desarrollo de aplicaciones web. Está basado en el patrón de diseño MVC (Modelo Vista Controlador). Es un poco restrictivo en cuanto ciertos aspectos, pero en cuanto se usa y se conoce, permite el desarrollo de sistemas altamente escalables con desarrollo mínimo, así como la reutilización de las partes deseadas en otras aplicaciones sin complicación ni duplicidad de código.


# <a></a>
### Ejercicio 3
#### ¿Cómo analizar el nivel de carga de cada uno de los subsistemas en el servidor?

- **Nagios** (Visto en ISE). Es un sistema de monitorización de red, máquinas y servicios. Permite vigilar los equipos (hardware) y los servicios en ejecución que se deseen. Una función interesante es la posibilidad de realizar la monitorización desde fuera, es decir, mediante túneles `SSL` cifrados o `SSH` podemos monitorizar sistemas sin estar físicamente cerca. Así mismo, cuenta con un sistema de alertas que no puede avisar en caso de que se cumplan unas reglas que especifiquemos, por el que no tenemos que estar constantemente atentos. Es de código abierto. También permite conocer los recursos hardware de los nodos de la red (carga CPU, RAM, discos, puertos...). Tiene una arquitectura modular, lo que nos permite aumentar su funcionalidad con distintos módulos sin la necesidad de reinstalar software específico distinto.

- **Munin** (Visto en ISE). También es un sistema de monitorización de servidores. Su principal función es monitorizar constantemente los sistemas y extraer una serie de estadísticas sobre todos y cada uno de los recursos disponibles en las máquinas, así como de los servicios que ofertan. Estas estadísticas son accesibles via Web (por lo que tampoco necesitamos acceder al SO para poder obtener información). También permite la instalación de plugins que aumenten su funcionalidad.

- **Cacti**. Este es otro sistema de monitorización centrado principalmente en el uso de gráficas sobre cada una de las partes de nuestro sistema (CPU, RAM, discos...) y de la red (tanto interna si la hay como externa)

# <a></a>
### Ejercicio 4
#### Buscar ejemplos de balanceadores software y hardware (productos comerciales).

**Balanceadores Software**:

- Nginx

- HAProxy

- Pen

- Pound

- Apache (también puede ser usado como proxy y balanceador)

- Zen Load Balancer

- Amazon ELB

**Balanceadores Hardware**:

- F5 BIG-IP

- Cisco

- Citrix

- Kemp Technologies

- Radware

- Barracuda

- Coyote Point / Fortinet FortiADC

- Resonate
