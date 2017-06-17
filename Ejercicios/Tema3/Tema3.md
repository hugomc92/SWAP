# SERVIDORES WEB DE ALTAS PRESTACIONES


## Ejercicios Tema 3


### **Hugo Maldonado Cózar**

# <a></a>

### Ejercicio 1
#### Buscar con qué órdenes de terminal o herramientas gráficas podemos configurar bajo Windows y bajo Linux el enrutamiento del tráfico de un servidor para pasar el tráfico desde una subred a otra.

En **Linux** tenemos software para realizar el enrutamiento como **route**

Normalmente tenemos que activar la opción del enrutamiento entre redes dentro del sistema operativo (en muchas distros no viene activado por defecto). Una forma sencilla de realizarlo es:

```
$ sudo echo "1" > /proc/sys/net/ipv4/ip_forward
```

Aunque esto al reinciar la máquina podría desactivarse por lo que lo podemos incluir cono script que se ejecuta al arrancar el sistema.

En **Windows** tenemos una herramienta propia del SO llamada **Enrutamiento y servicio remoto** que nos permite realizar estas funciones. Además tenemos más software para realizar estas funciones como **netsh**, **WinBox**

# <a></a>
### Ejercicio 2
#### Buscar con qué órdenes de terminal o herramientas gráficas podemos configurar bajo Windows y bajo Linux el filtrado y bloqueo de paquetes.

En **Linux** el software por terminal más común para el filtrado y bloqueo de paquetes es **iptables**.

También hay muchos programas que trabajan sobre **iptables** de forma gráfica como **netfilter**.

En **Windows** podemos realizar el bloqueo y filtrado de paquetes con el mismo servicio del SO que realizamos el enrutamiento, **Enrutamiento y servicio remoto**. También podemos utilizar el propio cortafuegos de  Windows para realizar estas tareas. Aparte también disponemos de otros software para hacerlo como **IPSec**