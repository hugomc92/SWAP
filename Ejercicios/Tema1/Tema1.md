# SERVIDORES WEB DE ALTAS PRESTACIONES


## Ejercicios Tema 1


### **Hugo Maldonado Cózar**

# <a></a>

#### Buscar información sobre las tareas o servicios web para los que se usan más los siguientes programas:

- **Apache**

	Apache es un gran servidor web, modular, extensible completamente libre, de código abierto y con licencia GPL. Una de sus mayores supremacias es el ser multiplataforma, lo que implica que al estar disponible para distintos sistemas operativos hace que sea el software de servidor web más usado en la actualidad, además también de su gran comunidad, lo que hace que la resolución de problemas sea algo sencillo en la búsqueda de la solución.
	
	El uso más común es el del servicio de sistemas web, tanto estáticos como dinámicos. Otro gran uso es el de proporcionar acceso a otro tipo de aplicaciones web desarrolladas cuyas peticiones primero son gestionadas por Apache.
	
	Es muy conocido también por la facilidad de integración con otras aplicaciones de servicios importantes como `Perl`, `PHP`, `MySQL`, `Python`...

- **nginx**

	Nginx es otro de los grandes servidores HTTP que podemos encontrar. Se relacina más con los servidores de altas prestaciones, es decir, es muy ligero, utiliza poca memoria, tiene un bajo consumo y ofrece un gran rendimiento y se suele escoger para aplicaciones en las que el tiempo de respuesta es importante.
	
	Este gran rendimiento es debido, en gran medida, a que nginx está escrito completamente en `C`, con todas las ventajas que eso conlleva.
	
	También incluye otro tipo de servicios como de correo electrónico (mediante `IMAP` y `POP`).
	
	Otro de los grandes usos de nginx es la posibilidad de utilizarlo como proxy inverso, es decir, podemos utilizar este software para realizar un desvío del tráfico ajustado según unos parámetros, por lo que entre otras cosas, nos permite realizar balanceo de carga entre distintas máquinas.
	
	Además, nginx permite almacenar en caché de forma muy eficiente datos estáticos (imágenes, hojas de estilos, javascript del cliente...) para ser accedidos de forma mucho más rápida durante las peticiones.
	
	Podemos ver algunas comparativas que nos demuestran que ngninx es uno de los servidores web de mayor rendimiento:
	
	![image1](./img/http_memory_bench.jpg)
	
	![image2](./img/http_request_bench.jpg)
	
- **thttpd**

	Es un servidor web de código libre enfocado principalmente en UNIX.
	
	Es simple, seguro, pequeño, rápido y portátil.
	
	Utiliza lo mínimo para dar soporte a un servidor HTTP.
	
	Se suele utilizar para entornos que requieren velocidad de acceso rápida (sobre datos fácilmente manipulables y no muy extensos en tamaño) y para máquinas con hardware limitado que con otros servidores esté más sobrecargado.

- **Cherokee**

	Cherokee es otro servidor web multiplataforma, ligero, libre y disponible bajo la licencia GNU. Principalmente enfocado hacia la rapidez y plena funcionalidad.
	
	Al igual que nginx está escrito completamente en `C`.
	
	Al igual que Apache, es modular, lo que quiere decir que soporta un gran número de complementos para aumentar sus funcionalidades.
	
	Puede usarse para configurar servidores virutales, redireccionamiento dinámico, lo que lo hace propenso a usarse como balanceador de carga al igual que nginx, también puede usarse como sistema embebido...
	
	Surgió con la idea de dar una alternativa a los grandes software de servidores web, pero siendo más ligero al mismo tiempo que ofrecía las mismas (o casi las mismas) funcionalidades. Esta idea inicial es lo que le permite ejecutarse de forma eficiente en hardware limitado, además de ejecutarse con mucho rendimiento con software más específico para servidores web.

- **node.js**

	Nodejs es un motor de javascript de lado del servidor. Es un intérprete que cambia el concepto de cómo un servidor debería trabajar.
	
	La principal idea que llevo a su desarrollo fue permitir a los programadores el diseño y desarrollo de aplicaciones altamente escalables con código que maneje de forma muy eficiente millones de peticiones simultáneas en una única máquina física (se disparan eventos dentro del proceso de node, que implica que se generen hebras muy optimizadas para su resolución por cada petición recibida manejando muy pocos recursos para su utilización).
	
	Es un sistema muy muy rápido y consume muy pocos recursos, además de no bloquearse en la E/S de los datos al ser principalmente asíncrono (se deja la opción a los programadores de formar la sincronía si los datos deben ser tratados secuencialmente).
	
	Es usado principalemente para aplicaciones web que tienen la necesidad de tiempo real por su gran capacidad de manejar de forma óptima (o casi óptima) los recursos ante las peticiones, también para aplicaciones que necesitan manejo de eventos tipo PUSH (el servidor puede iniciar la conexión o la "conversación" con el cliente ante algún evento sin que éste le esté preguntando constantemente). Aunque uno de sus principales usos es la de la programación de APIs de tipo REST.