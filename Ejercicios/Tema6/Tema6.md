# SERVIDORES WEB DE ALTAS PRESTACIONES


## Ejercicios Tema 6


### **Hugo Maldonado Cózar**

# <a></a>

### Ejercicio 1
#### Aplicar con iptables una política de denegar todo el tráfico en una de las máquinas de prácticas. Comprobar el funcionamiento.### Aplicar con iptables una política de permitir todo el tráfico en una de las máquinas de prácticas. Comprobar el funcionamiento.

Hecho y explicado en la [Práctica 4](https://github.com/hugomc92/SWAP/tree/master/Prácticas/Práctica4).

# <a></a>
### Ejercicio 2
#### Comprobar qué puertos tienen abiertos nuestras máquinas, su estado, y qué programa o demonio lo ocupa.

Para saber esta información vamos a utilizar la herramienta **netstat**:

```
$ sudo netstat -antulp
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1226/sshd           
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN      1444/apache2        
tcp        0      0 0.0.0.0:7878            0.0.0.0:*               LISTEN      1458/mysqld         
tcp        0      0 0.0.0.0:5355            0.0.0.0:*               LISTEN      1155/systemd-resolv 
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      1444/apache2        
tcp        0      0 192.168.1.20:22         221.194.47.236:48821    ESTABLISHED 6625/sshd: root [pr 
tcp        0    196 192.168.1.20:22         192.168.1.64:50629      ESTABLISHED 6507/sshd: hugomald 
tcp6       0      0 :::22                   :::*                    LISTEN      1226/sshd           
tcp6       0      0 :::5355                 :::*                    LISTEN      1155/systemd-resolv 
udp        0      0 127.0.0.53:53           0.0.0.0:*                           1155/systemd-resolv 
udp        0      0 0.0.0.0:5355            0.0.0.0:*                           1155/systemd-resolv 
udp6       0      0 :::5355                 :::*                                1155/systemd-resolv
```

Aquí se pueden ver los puertos abiertos (4º columna), el estado (6º columna) y qué programa los tiene en uso(7º columna).

# <a></a>
### Ejercicio 3
#### Buscar información acerca de los tipos de ataques más comunes en servidores web (p.ej. secuestros de sesión). Detallar en qué consisten, y cómo se pueden evitar.

En el [Trabajo de la asignatura](../../Trabajo/Seguridad%20en%20Servidores.pdf) que realizamos, comenté algunos de los ataques más comunes, así como vulnerabilidades, medidas de seguridad, etc.