# SERVIDORES WEB DE ALTAS PRESTACIONES


## Práctica 2


### **Hugo Maldonado Cózar**

#<a></a>

Después de la configuración de la práctica 1 tenemos el siguiente esquema:

|        Nombre         |      IP        |
|:---------------------:|:--------------:|
| Ubuntu Server SWAP 1  |  10.211.55.9   |
| Ubuntu Server SWAP 2  |  10.211.55.10  |

Lo primero que voy a hacer (que había obviado en la anterior práctica) es seguir la recomendación y activar el usuario `root` en ambas máquinas

```
$ sudo passwd root
Introduzca la nueva contraseña de UNIX: 
Vuelva a escribir la nueva contraseña de UNIX: 
passwd: password updated successfully
```

Al estar usando `Ubuntu Server 16.10` no podemos conectarnos como usuario `root` a través de `ssh`, así que tendremos que modificarlo en la configuración para poder acceder con dicho usuario (también en ambas máquinas).

```
# nano /etc/ssh/sshd_config
```

Cambiar la línea `PermitRootLogin prohibit-password` por `PermitRootLogin yes`. Y reiniciamos el servicio de `ssh`:

```
# service ssh restart
```

Y ahora ya podemos conectarnos por `ssh` con el usuario `root`:

```
$ ssh root@10.211.55.9
root@10.211.55.9's password: 
Welcome to Ubuntu 16.10 (GNU/Linux 4.8.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

Pueden actualizarse 0 paquetes.
0 actualizaciones son de seguridad.



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

root@ubuntu-server-swap-1:~#
```

Como la carpeta en la que vamos a realizar la sincronización entre máquinas (`/var/www`) está restringida, para poder realizar la configuración con el usuario normal (no `root`) tenemos que asignarle permisos con el usuario `root` al usuario normal:


```
root@ubuntu-server-swap-1:~# chown hugomaldonado:hugomaldonado -R /var/www/
```

Y ahora para comprobar que todo ha funcionado vamos a borrar el archivo `index.html` que crea `Apache` por defecto en la carpeta `/var/www/html/` con el usuario normal (`hugomaldonado`) en ambas máquinas para que la sincronización pueda funcionar correctamente.

```
hugomaldonado@ubuntu-server-swap-1:~$ ls /var/www/html/
index.html
hugomaldonado@ubuntu-server-swap-1:~$ rm /var/www/html/index.html
hugomaldonado@ubuntu-server-swap-1:~$ ls /var/www/html/
```

Vemos que efectivamente ha podido borrarlo correctamente, por lo que están los permisos correctamente asignados.

Ahora, vamos a generar las claves públicas y privadas en la máquina 2 (`Ubuntu Server SWAP 2: 10.255.11.10`) y copiarlas en la máquina 1 (`Ubuntu Server SWAP 1: 10.255.11.9`).

```
hugomaldonado@ubuntu-server-swap-2:~$ ssh-keygen -b 4096 -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/hugomaldonado/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/hugomaldonado/.ssh/id_rsa.
Your public key has been saved in /home/hugomaldonado/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:Cpsl0BApFoqrGOHjUZE7ETPgs1dbCcdcXSx0BNZ/Zn4 hugomaldonado@ubuntu-server-swap-2
The key's randomart image is:
+---[RSA 4096]----+
| o=Bo.o...o+*+   |
|=..=+ oo. .o.o   |
|=+..+. o    . .  |
|.o++. o        .+|
|o= .+.. S      +.|
|+.+  * .        E|
|o.  o .         .|
|                 |
|                 |
+----[SHA256]-----+

hugomaldonado@ubuntu-server-swap-2:~$ ls .ssh/
id_rsa  id_rsa.pub  known_hosts
```

Podemos ver que se han creado correctamente. Hemos dejado el `passphrase` vacío, ya que queremos que se pueda identificar sin contraseña.

Ahora vamos a copiar la clave pública a la máquina 1 para permitir el acceso:

```
hugomaldonado@ubuntu-server-swap-2:~$ ssh-copy-id 10.211.55.9
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/hugomaldonado/.ssh/id_rsa.pub"
The authenticity of host '10.211.55.9 (10.211.55.9)' can't be established.
ECDSA key fingerprint is SHA256:5xPEt5mDO0iJXSL6V5TPaIxfgBGC7dzPRXQOlsD0XT0.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
hugomaldonado@10.211.55.9's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh '10.211.55.9'"
and check to make sure that only the key(s) you wanted were added.
```

Y si ahora vamos a la máquina 1:

```
hugomaldonado@ubuntu-server-swap-1:~$ ls .ssh/
authorized_keys

hugomaldonado@ubuntu-server-swap-1:~$ cat .ssh/authorized_keys 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtUIAm+FcfvWo0RfpxxEV4Mz5l6YZ1iyP+c+GDJE/6RCBkbx/1YV4HjVnnlq5i12ySHyqZn/eHqnD2iACW+N6jh/tIXgxtU+139SAtTUuTSEVW2IeoGUSA603BeQUzsBPtbOPCyBSbYhbqcSU8eVmJpv1uR4cchJtTFC94kE4fQKbIHCld1SBk6sSzNtwqg366dsEise3XAeSy7dFbv/ghI6sqEbEYiq/6ar1pxIZYJPLV8BWukmjQSUQ98A1SBeQrLBQehEWfRFWHMYx3mv30+k086+dI0mU1OUB4x0e2r1syz01PIJogHAtKNlOOo6PaDJTqmN6wxBt4xOm60DqDymWgtskFUlfidcFX0MoMYtwpFYastubdomi0DQypjy2iP0seUYn0b0nnAS3kLHrO1+7zYQTjY1FKUeZqS3cXGEo6qmGvu54conbojJqGfKrX5MzofKDPVNlMt6LVtnqn5QRzwmUawvZj97Ka8JFXhVUCeU1ou3+k1jL8EU4NXkJsTsw1c2QZXQRv3/SLHui5SjDjkj7xoZaCgsrbi0iRkkWS8XGtWhoaidDtkTMIzMluOioMsp65LE/bx2pcv749pSf2H0d1S5MFkFerWi6stJg3eUklRPPwee+30lbcunsE4s9ozVQqhZFMOn/FIVgRIZ2eRyEcPeJgQNDaQm5YKQ== hugomaldonado@ubuntu-server-swap-2
```

Podemos ver como se ha añadido correctamente la clave pública del usuario `hugomaldonado` (no `root`) en la lista de las claves autorizadas.

Ahora podemos conectarnos por `ssh` sin necesidad de introducir la contraseña:

```
hugomaldonado@ubuntu-server-swap-2:~$ ssh hugomaldonado@10.211.55.9
Welcome to Ubuntu 16.10 (GNU/Linux 4.8.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

Pueden actualizarse 0 paquetes.
0 actualizaciones son de seguridad.


Last login: Wed Mar 15 18:57:54 2017 from 10.211.55.2
```

Ahora vamos a probar la sincronización con `RSync` directamente desde el terminal para comprobar que funciona antes de programar la tarea con `cron`:

```
hugomaldonado@ubuntu-server-swap-2:~$ rsync -avz --delete -e ssh hugomaldonado@10.211.55.9:/var/www/ /var/www/
receiving incremental file list

sent 21 bytes  received 96 bytes  234.00 bytes/sec
total size is 0  speedup is 0.00
```

Como podemos observar, la sincronización funciona perfectamente.

Ahora vamos a crear los dos ficheros en ambas máquinas.

**Máquina 1**

```
hugomaldonado@ubuntu-server-swap-1:~$ nano /var/www/html/index.html

hugomaldonado@ubuntu-server-swap-1:~$ cat /var/www/html/index.html 
<HTML>
<BODY>
       SERVER 1. Esto funciona :)
</BODY>
</HTML>
```

**Máquina 2**

```
hugomaldonado@ubuntu-server-swap-2:~$ nano /var/www/html/index.html

hugomaldonado@ubuntu-server-swap-2:~$ cat /var/www/html/index.html 
<HTML>
<BODY>
       SERVER 2. Esto funciona :)
</BODY>
</HTML>
```

Desde la máquina anfitrión, vamos a traernos con `CURL` ambos ficheros de ambas máquinas:

```
cvi037185:~ hugomaldonado$ curl http://10.211.55.9/
<HTML>
<BODY>
       SERVER 1. Esto funciona :)
</BODY>
</HTML>
cvi037185:~ hugomaldonado$ curl http://10.211.55.10/
<HTML>
<BODY>
       SERVER 2. Esto funciona :)
</BODY>
</HTML>
```

Como podemos ver, ambos ficheros son accesibles y muestran su contenido acorde a lo configurado.

Ahora vamos a programar la tarea con `cron` para poder automatizarla. Para ello modificamos con el usuario `root` el fichero `/etc/crontab` y añadimos la siguiente línea:

```
*  *  *  *  *   hugomaldonado   rsync -avz --delete -e ssh hugomaldonado@10.211.55.9:/var/www/ /var/www/
```

Y vamos a volver a traernos los ficheros de ambas máquinas con `curl` para ver cómo se ha producido la sincronización:

```
cvi037185:~ hugomaldonado$ curl http://10.211.55.10/
<HTML>
<BODY>
       SERVER 1. Esto funciona :)
</BODY>
</HTML>
```