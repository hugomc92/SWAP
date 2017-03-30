# SERVIDORES WEB DE ALTAS PRESTACIONES


## Práctica 3


### **Hugo Maldonado Cózar**

# <a></a>

Después de la configuración de la práctica 2 y de la instalación y configuración de la máquina que vamos a usar como balanceador de carga tenemos el siguiente esquema:

|        Nombre         |      IP        |
|:---------------------:|:--------------:|
| Ubuntu Server SWAP 1  |  10.211.55.9   |
| Ubuntu Server SWAP 2  |  10.211.55.10  |
| Ubuntu Server SWAP LB |  10.211.55.11  |

Lo primero que voy a hacer es deshabilitar el servicio de `rsync` que estaba lanzado en la máquina 2 (Ubuntu Server SWAP 2) sincronizándose con la máquina 1 (Ubuntu Server SWAP 1) para que podamos ver más fácilmente cómo el balanceo de carga que vamos a realizar se está ejecutando correctamente.

```
hugomaldonado@ubuntu-server-swap-2:~$ sudo nano /etc/crontab
```

Y comentamos la línea que realizaba la sincronización: 

```
#*  *  *  *  *  hugomaldonado   rsync -avz --delete -e ssh hugomaldonado@10.211.55.9:/var/www/ /var$
```

### Balanceo de carga con nginx

Lo primero es instalar el servidor `nginx` que vamos a utilizar primero para el balanceo de carga en la máquina que vamos a utilizar como balanceador:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo apt install nginx
```

Para probar que se ha instalado correctamente probamos acceder desde el navegador del anfitrión:

![Nginx](./img/nginx.png)

Luego ya tenemos funcionando sin problema el servidor `nginx` que ahora mismo está funcionando como servidor web.

Vamos a configurarlo para que deje de actuar como servidor web y actúe como balanceador de carga para las otras dos máquinas que ya tenemos creadas.

Lo primero es configurar es el fichero para establecer el balanceo de carga:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo nano /etc/nginx/conf.d/default.conf
```

Ésta es la configuración que he establecido para el funcionamiento del balanceador de carga:


```
upstream webServers {
        server 10.211.55.9;
        server 10.211.55.10;
}

server{
        listen 80;
        server_name LoadBalancer;

        access_log /var/log/nginx/LoadBalancer.access.log;
        error_log /var/log/nginx/LoadBalancer.error.log;
        root /var/www/;

        location / {
                proxy_pass http://webServers;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; proxy_http_version 1.1;
                proxy_set_header Connection "";
        }
}
```

Ahora hay que deshabilitar la opción de que funcione como servidor web:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo nano /etc/nginx/nginx.conf 
```

Y comentamos la línea:

```
#include /etc/nginx/sites-enabled/*;
```

Ahora reiniciamos el servicio de `nginx` establecer la nueva configuración:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo service nginx restart
```

Ahora vamos a probar el funcionamiento, tanto por `curl` desde la terminal del anfitrión como directamente desde el navegador:

```
cvi037074:~ hugomaldonado$ curl 10.211.55.11
<HTML>
<BODY>
       SERVER 1. Esto funciona :)
</BODY>
</HTML>
cvi037074:~ hugomaldonado$ curl 10.211.55.11
<HTML>
<BODY>
       SERVER 2. Esto funciona :)
</BODY>
</HTML>
```

Ya estamos viendo que mediante `curl` funciona perfectamente.

![Nginx](./img/nginxLB1.png)

![Nginx](./img/nginxLB2.png)

Vemos que está funcionando correctamente, ya que al utilizar el algoritmo de Round Robin, la primera petición va hacia la primera máquina, y la segunda petición a la segunda.

### Balanceo de carga con haproxy

Lo primero que vamos a hacer es deshabilitar `nginx` para que el balanceo pase a hacerlo `haproxy`, para ello simplemente vamos a parar el servicio:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo service nginx stop
```

Y ahora vamos a realizar una petición para corroborar que efectivamente se ha parado el servicio:

```
cvi037074:~ hugomaldonado$ curl 10.211.55.11
curl: (7) Failed to connect to 10.211.55.11 port 80: Connection refused
```

Por lo que ya tenemos claro que `nginx` no está corriendo actualmente.

Vamos a proceder con la instalación del software `haproxy`:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo apt install haproxy
```

Ahora vamos a configurar el servicio para que actúe como balanceador entre nuestras dos máquinas:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo nano /etc/haproxy/haproxy.cfg 
```

Y la configuración que he establecido ha sido:

```
global
        daemon
        maxconn 256

defaults
        mode http
        timeout connect 4000
        timeout client 42000
        timeout server 43000

frontend http-in 
        bind *:80
        default_backend servers

backend servers
        server m1 10.211.55.9:80 maxconn 32
        server m2 10.211.55.10:80 maxconn 32
```

Una vez lo tenemos configurado vamos a reiniciar el servicio de `haproxy` para que coja la nueva configuración y empiece a actuar como balanceador:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo service haproxy restart
```

Y ya lo tenemos funcionando, vamos a comprobarlo del mismo modo que comprobé el balanceador con `nginx`, es decir, mediante curl y mediante el navegador:

```
cvi037074:~ hugomaldonado$ curl 10.211.55.11
<HTML>
<BODY>
       SERVER 1. Esto funciona :)
</BODY>
</HTML>
cvi037074:~ hugomaldonado$ curl 10.211.55.11
<HTML>
<BODY>
       SERVER 2. Esto funciona :)
</BODY>
</HTML>
```

Ya estamos viendo que mediante `curl` funciona perfectamente.

![Nginx](./img/haproxyLB1.png)

![Nginx](./img/haproxyLB2.png)

Vemos como de nuevo funciona correctamente.

### Balanceo de carga con pound (u otro software de balanceo)

Lo primero que vamos a hacer es deshabilitar `haproxy` para que el balanceo pase a hacerlo `pound`, para ello simplemente vamos a parar el servicio:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo service haproxy stop
```

Y ahora vamos a realizar una petición para corroborar que efectivamente se ha parado el servicio:

```
cvi037074:~ hugomaldonado$ curl 10.211.55.11
curl: (7) Failed to connect to 10.211.55.11 port 80: Connection refused
```

Por lo que ya tenemos claro que `haproxy` no está corriendo actualmente.

Ahora vamos a instalar `pound`:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo apt install pound
```

Una vez instalado vamos a configurarlo:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo nano /etc/pound/pound.cfg
```

Ésta es la configuración que he establecido:

```
ListenHTTP
        Address 10.211.55.11
        Port    80

        HeadRemove "X-Forwarded-For"

        Service
                BackEnd
                        Address 10.211.55.9
                        Port    80
                End
                BackEnd
                        Address 10.211.55.10
                        Port    80
                End
        End
End
```

Ahora hay que habilitar el funcionamiento:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo nano /etc/default/pound
```

Y cambiar la linea `startup=0` por `startup=1`.

Ahora lanzamos el software como un demonio:

```
hugomaldonado@ubuntu-server-swap-lb:~$ sudo /etc/init.d/pound start
```

Ahora ya debería estar funcionando, vamos a realizar las mismas pruebas que con los otros dos programas:

```
cvi037074:~ hugomaldonado$ curl 10.211.55.11
<HTML>
<BODY>
       SERVER 2. Esto funciona :)
</BODY>
</HTML>
cvi037074:~ hugomaldonado$ curl 10.211.55.11
<HTML>
<BODY>
       SERVER 1. Esto funciona :)
</BODY>
</HTML>
```

Ya estamos viendo que mediante `curl` funciona perfectamente.

![Nginx](./img/poundLB1.png)

![Nginx](./img/poundLB2.png)

Vemos como de nuevo funciona correctamente.

### Comparaciones del funcionamiento de los balanceadores (Apache Benchmark)

Vamos a realizar una comparativa entre los distintos balanceadores de carga que hemos utilizado durante la práctica. Para ello vamos a utilizar `Apache Benchmark` y mediante el siguiente comando vamos a lanzar grandes cargas contra el servidor de balanceo para ver cómo se comporta con cada una de las opciones:

```
$ ab -n 100000 -c 200 10.211.55.11/index.html
```

#### nginx

```
cvi037074:~ hugomaldonado$ ab -n 100000 -c 200 10.211.55.11/index.html
Benchmarking 10.211.55.11 (be patient)

Server Software:        nginx/1.10.1
Server Hostname:        10.211.55.11
Server Port:            80

Document Path:          /index.html
Document Length:        64 bytes

Concurrency Level:      200
Time taken for tests:   35.084 seconds
Complete requests:      100000
Failed requests:        0
Total transferred:      30900000 bytes
HTML transferred:       6400000 bytes
Requests per second:    2850.28 [#/sec] (mean)
Time per request:       70.169 [ms] (mean)
Time per request:       0.351 [ms] (mean, across all concurrent requests)
Transfer rate:          860.09 [Kbytes/sec] received
```

#### haproxy

```
cvi037074:~ hugomaldonado$ ab -n 100000 -c 200 10.211.55.11/index.html

Server Software:        Apache/2.4.18
Server Hostname:        10.211.55.11
Server Port:            80

Document Path:          /index.html
Document Length:        64 bytes

Concurrency Level:      200
Time taken for tests:   38.727 seconds
Complete requests:      100000
Failed requests:        0
Total transferred:      31000000 bytes
HTML transferred:       6400000 bytes
Requests per second:    2582.19 [#/sec] (mean)
Time per request:       77.454 [ms] (mean)
Time per request:       0.387 [ms] (mean, across all concurrent requests)
Transfer rate:          781.72 [Kbytes/sec] received
```

#### pound

```
cvi037074:~ hugomaldonado$ ab -n 100000 -c 200 10.211.55.11/index.html


Server Software:        Apache/2.4.18
Server Hostname:        10.211.55.11
Server Port:            80

Document Path:          /index.html
Document Length:        64 bytes

Concurrency Level:      200
Time taken for tests:   90.562 seconds
Complete requests:      100000
Failed requests:        0
Total transferred:      31000000 bytes
HTML transferred:       6400000 bytes
Requests per second:    1104.21 [#/sec] (mean)
Time per request:       181.125 [ms] (mean)
Time per request:       0.906 [ms] (mean, across all concurrent requests)
Transfer rate:          334.28 [Kbytes/sec] received
```