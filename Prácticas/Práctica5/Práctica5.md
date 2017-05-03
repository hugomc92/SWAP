# SERVIDORES WEB DE ALTAS PRESTACIONES


## Práctica 5


### **Hugo Maldonado Cózar**

# <a></a>

Después de la configuración de la práctica 4 tenemos el siguiente esquema:

|        Nombre         |      IP        |
|:---------------------:|:--------------:|
| Ubuntu Server SWAP 1  |  10.211.55.9   |
| Ubuntu Server SWAP 2  |  10.211.55.10  |
| Ubuntu Server SWAP LB |  10.211.55.11  |
| Ubuntu Server SWAP FW |  10.211.55.12  |

## Creación del usuario, base de datos e información en máquina 1

Creación de la base de datos 'contactos':
```
hugomaldonado@ubuntu-server-swap-1:~$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.17-0ubuntu0.16.10.1 (Ubuntu)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database contactos;
Query OK, 1 row affected (0,00 sec)
```

Creación de nuevo usuario y proporcionarle permisos sobre la nueva base de datos:

```
mysql> create user 'hugo' identified by '********';
Query OK, 0 rows affected (0,01 sec)

mysql> grant all privileges on contactos.* to 'hugo';
Query OK, 0 rows affected (0,00 sec)

mysql> exit
Bye

hugomaldonado@ubuntu-server-swap-1:~$ mysql -u hugo -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 5.7.17-0ubuntu0.16.10.1 (Ubuntu)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| contactos          |
+--------------------+
2 rows in set (0,00 sec)
```

Ya tenemos la base de datos creada y un nuevo usuario con acceso sobre ella.

Ahora creamos la nueva tabla en la que introduciremos los datos:

```
mysql> use contactos;
Database changed

mysql> show tables;
Empty set (0,00 sec)

mysql> create table datos(nombre varchar(100), tlf int);
Query OK, 0 rows affected (0,01 sec)

mysql> show tables;
+---------------------+
| Tables_in_contactos |
+---------------------+
| datos               |
+---------------------+
1 row in set (0,00 sec)

mysql> describe datos;
+--------+--------------+------+-----+---------+-------+
| Field  | Type         | Null | Key | Default | Extra |
+--------+--------------+------+-----+---------+-------+
| nombre | varchar(100) | YES  |     | NULL    |       |
| tlf    | int(11)      | YES  |     | NULL    |       |
+--------+--------------+------+-----+---------+-------+
2 rows in set (0,00 sec)
```

Ahora insertamos datos:

```
mysql> insert into datos(nombre,tlf) values ("pepe",95834987);
Query OK, 1 row affected (0,01 sec)

mysql> select * from datos;
+--------+----------+
| nombre | tlf      |
+--------+----------+
| pepe   | 95834987 |
+--------+----------+
1 row in set (0,00 sec)
```

## Clonado manual con mysqldump

Lo primero que hacemos antes de realizar la copia de seguridad, es bloquear la base de datos para que no se escriban datos nuevos para evitar la pérdida de información en la copia de seguridad.

Para ello, antes que nada, tenemos que hacer es otorgar permisos de recarga de tablas al nuevo usuario desde el root:

```
mysql> grant RELOAD on *.* to 'hugo';
Query OK, 0 rows affected (0,00 sec)
```

Se tiene que hacer de forma global a todas las bases de datos, ya que no se permite la otorgación de este permiso de forma local a una base de datos concreta.

Y ahora ya podemos bloquear las tablas:

```
mysql> flush tables with read lock;
Query OK, 0 rows affected (0,01 sec)
```

Ahora procedemos a la copia de seguridad en sí:

```
hugomaldonado@ubuntu-server-swap-1:~$ sudo mysqldump contactos -u hugo -p > ~/contactos_dump1.sql
[sudo] password for hugomaldonado: 
Enter password: 

hugomaldonado@ubuntu-server-swap-1:~$ ls
contactos_dump1.sql

hugomaldonado@ubuntu-server-swap-1:~$ cat contactos_dump1.sql 
-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: contactos
-- ------------------------------------------------------
-- Server version	5.7.17-0ubuntu0.16.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `datos`
--

DROP TABLE IF EXISTS `datos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datos` (
  `nombre` varchar(100) DEFAULT NULL,
  `tlf` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datos`
--

LOCK TABLES `datos` WRITE;
/*!40000 ALTER TABLE `datos` DISABLE KEYS */;
INSERT INTO `datos` VALUES ('pepe',95834987);
/*!40000 ALTER TABLE `datos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-26 19:10:07
```

Y ahora ya podemos desbloquear las tablas:

```
mysql> unlock tables;
Query OK, 0 rows affected (0,00 sec)
```

Ahora vamos a la máquina 2 y nos traemos el fichero creado para clonar la base de datos:

```
hugomaldonado@ubuntu-server-swap-2:~$ sftp hugomaldonado@10.211.55.9
Connected to 10.211.55.9.
sftp> ls
contactos_dump1.sql      
sftp> get contactos_dump1.sql 
Fetching /home/hugomaldonado/contactos_dump1.sql to contactos_dump1.sql
/home/hugomaldonado/contactos_dump1.sql                              100% 1858     2.0MB/s   00:00    
sftp> exit

hugomaldonado@ubuntu-server-swap-2:~$ ls
contactos_dump1.sql

hugomaldonado@ubuntu-server-swap-2:~$ cat contactos_dump1.sql 
-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: contactos
-- ------------------------------------------------------
-- Server version	5.7.17-0ubuntu0.16.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `datos`
--

DROP TABLE IF EXISTS `datos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datos` (
  `nombre` varchar(100) DEFAULT NULL,
  `tlf` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datos`
--

LOCK TABLES `datos` WRITE;
/*!40000 ALTER TABLE `datos` DISABLE KEYS */;
INSERT INTO `datos` VALUES ('pepe',95834987);
/*!40000 ALTER TABLE `datos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-26 19:10:07
```

Vamos a crear el mismo usuario que hemos creado anteriormente en la máquina 2 y la base de datos (ya que `mysqldump` no crea la base de datos) de la misma forma que se explicó anteriormente.

```
hugomaldonado@ubuntu-server-swap-2:~$ mysql -u hugo -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.7.17-0ubuntu0.16.10.1 (Ubuntu)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| contactos          |
+--------------------+
2 rows in set (0,00 sec)
```

Y ahora procedemos a la importación de los datos de la copia de seguridad que acabamos de traernos de la máquina 1:

```
hugomaldonado@ubuntu-server-swap-2:~$ mysql -u hugo -p contactos < contactos_dump1.sql
Enter password: 
hugomaldonado@ubuntu-server-swap-2:~$ mysql -u hugo -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 5.7.17-0ubuntu0.16.10.1 (Ubuntu)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| contactos          |
+--------------------+
2 rows in set (0,00 sec)

mysql> use contactos;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+---------------------+
| Tables_in_contactos |
+---------------------+
| datos               |
+---------------------+
1 row in set (0,00 sec)

mysql> describe datos;
+--------+--------------+------+-----+---------+-------+
| Field  | Type         | Null | Key | Default | Extra |
+--------+--------------+------+-----+---------+-------+
| nombre | varchar(100) | YES  |     | NULL    |       |
| tlf    | int(11)      | YES  |     | NULL    |       |
+--------+--------------+------+-----+---------+-------+
2 rows in set (0,00 sec)

mysql> select * from datos;
+--------+----------+
| nombre | tlf      |
+--------+----------+
| pepe   | 95834987 |
+--------+----------+
1 row in set (0,00 sec)
```

Y como se puede comprobar ya está toda la información de la copia de seguridad en la máquina 2.

## Clonado automático maestro esclavo

Partimos de las bases de datos clonadas manualmente en el apartado anterior.

En la máquina 1 (que funcionará como maestro) comentamos en el fichero `/etc/mysql/mysql.conf.d/mysqld.cnf` la línea (poniéndole un # delante) para que escuche a un servidor:

```
#bind-address           = 127.0.0.1
```

Establecemos el identificador del servidor (en el mismo fichero):

```
server-id               = 1
```

Activamos el registro binario:

```
log_bin                 = /var/log/mysql/mysql-bin.log
```

Guardamos el fichero y reiniciamos el servicio:

```
hugomaldonado@ubuntu-server-swap-1:~$ sudo service mysql restart
```

En el cliente hacemos las mismas configuraciones, cambio el id por 2.

Ahora, en el maestro, creamos un usuario esclavo para que realice la replicación dándole los permisos necesarios:

```
hugomaldonado@ubuntu-server-swap-1:~$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.7.17-0ubuntu0.16.10.1-log (Ubuntu)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create user esclavo identified by 'esclavo';
Query OK, 0 rows affected (0,00 sec)

mysql> GRANT REPLICATION SLAVE ON *.* TO 'esclavo'@'%' IDENTIFIED BY 'esclavo';
Query OK, 0 rows affected, 1 warning (0,00 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0,01 sec)

mysql> flush tables;
Query OK, 0 rows affected (0,00 sec)

```

Volvemos a bloquear las tablas:

```
mysql> flush tables with read lock;
Query OK, 0 rows affected (0,00 sec)
```

Comprobamos la configuración en el maestro:

```
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000001 |      980 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0,00 sec)
```

Ahora, en la máquina esclava, cambiamos la configuración del maestro:

```
mysql> CHANGE MASTER TO MASTER_HOST='10.211.55.9', MASTER_USER='esclavo', MASTER_PASSWORD='esclavo', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS= 980, MASTER_PORT=3306;
Query OK, 0 rows affected, 2 warnings (0,02 sec)
```

Y arrancamos el esclavo:

```
mysql> start slave;
Query OK, 0 rows affected (0,01 sec)
```

Ahora desbloqueamos las tablas en el maestro:

```
mysql> unlock tables;
Query OK, 0 rows affected (0,00 sec)
```

Comprobamos el estado del esclavo:

```
mysql> show slave status;
+----------------+-------------+-------------+-------------+---------------+------------------+---------------------+---------------------------------------+---------------+-----------------------+------------------+-------------------+-----------------+---------------------+--------------------+------------------------+-------------------------+-----------------------------+------------+------------+--------------+---------------------+-----------------+-----------------+----------------+---------------+--------------------+--------------------+--------------------+-----------------+-------------------+----------------+-----------------------+-------------------------------+---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------+----------------+-----------------------------+------------------+--------------------------------------+----------------------------+-----------+---------------------+--------------------------------------------------------+--------------------+-------------+-------------------------+--------------------------+----------------+--------------------+--------------------+-------------------+---------------+----------------------+--------------+--------------------+
| Slave_IO_State | Master_Host | Master_User | Master_Port | Connect_Retry | Master_Log_File  | Read_Master_Log_Pos | Relay_Log_File                        | Relay_Log_Pos | Relay_Master_Log_File | Slave_IO_Running | Slave_SQL_Running | Replicate_Do_DB | Replicate_Ignore_DB | Replicate_Do_Table | Replicate_Ignore_Table | Replicate_Wild_Do_Table | Replicate_Wild_Ignore_Table | Last_Errno | Last_Error | Skip_Counter | Exec_Master_Log_Pos | Relay_Log_Space | Until_Condition | Until_Log_File | Until_Log_Pos | Master_SSL_Allowed | Master_SSL_CA_File | Master_SSL_CA_Path | Master_SSL_Cert | Master_SSL_Cipher | Master_SSL_Key | Seconds_Behind_Master | Master_SSL_Verify_Server_Cert | Last_IO_Errno | Last_IO_Error                                                                                                                                                                                                                                                                                                                        | Last_SQL_Errno | Last_SQL_Error | Replicate_Ignore_Server_Ids | Master_Server_Id | Master_UUID                          | Master_Info_File           | SQL_Delay | SQL_Remaining_Delay | Slave_SQL_Running_State                                | Master_Retry_Count | Master_Bind | Last_IO_Error_Timestamp | Last_SQL_Error_Timestamp | Master_SSL_Crl | Master_SSL_Crlpath | Retrieved_Gtid_Set | Executed_Gtid_Set | Auto_Position | Replicate_Rewrite_DB | Channel_Name | Master_TLS_Version |
+----------------+-------------+-------------+-------------+---------------+------------------+---------------------+---------------------------------------+---------------+-----------------------+------------------+-------------------+-----------------+---------------------+--------------------+------------------------+-------------------------+-----------------------------+------------+------------+--------------+---------------------+-----------------+-----------------+----------------+---------------+--------------------+--------------------+--------------------+-----------------+-------------------+----------------+-----------------------+-------------------------------+---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------+----------------+-----------------------------+------------------+--------------------------------------+----------------------------+-----------+---------------------+--------------------------------------------------------+--------------------+-------------+-------------------------+--------------------------+----------------+--------------------+--------------------+-------------------+---------------+----------------------+--------------+--------------------+
|                | 10.211.55.9 | esclavo     |        3306 |            60 | mysql-bin.000001 |                 501 | ubuntu-server-swap-2-relay-bin.000002 |           320 | mysql-bin.000001      | No               | Yes               |                 |                     |                    |                        |                         |                             |          0 |            |            0 |                 501 |             542 | None            |                |             0 | No                 |                    |                    |                 |                   |                |                  NULL | No                            |          1236 | Got fatal error 1236 from master when reading data from binary log: 'binlog truncated in the middle of event; consider out of disk space on master; the first event 'mysql-bin.000001' at 501, the last event read from '/var/log/mysql/mysql-bin.000001' at 123, the last byte read from '/var/log/mysql/mysql-bin.000001' at 520.' |              0 |                |                             |                1 | 059ea0e4-0410-11e7-90a2-001c42476e9e | /var/lib/mysql/master.info |         0 |                NULL | Slave has read all relay log; waiting for more updates |              86400 |             | 170426 19:32:55         |                          |                |                    |                    |                   |             0 |                      |              |                    |
+----------------+-------------+-------------+-------------+---------------+------------------+---------------------+---------------------------------------+---------------+-----------------------+------------------+-------------------+-----------------+---------------------+--------------------+------------------------+-------------------------+-----------------------------+------------+------------+--------------+---------------------+-----------------+-----------------+----------------+---------------+--------------------+--------------------+--------------------+-----------------+-------------------+----------------+-----------------------+-------------------------------+---------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------+----------------+-----------------------------+------------------+--------------------------------------+----------------------------+-----------+---------------------+--------------------------------------------------------+--------------------+-------------+-------------------------+--------------------------+----------------+--------------------+--------------------+-------------------+---------------+----------------------+--------------+--------------------+
1 row in set (0,00 sec)

```

Ahora vamos a introducir datos en el maestro para ver si se replican correctamente en el esclavo:

```
mysql> insert into datos(nombre,tlf) values ("hugasdfo2",123123);
Query OK, 1 row affected (0,01 sec)

mysql> select * from datos;
+-----------+----------+
| nombre    | tlf      |
+-----------+----------+
| pepe      | 95834987 |
| hugo2     |   123123 |
| hugasdfo2 |   123123 |
+-----------+----------+
5 rows in set (0,00 sec)
```

Y vemos como está funcionando correctamente en el esclavo:

```
mysql> select * from datos;
+-----------+----------+
| nombre    | tlf      |
+-----------+----------+
| pepe      | 95834987 |
| hugo2     |   123123 |
| hugasdfo2 |   123123 |
+-----------+----------+
3 rows in set (0,00 sec)
```

## Clonado automático maestro maestro

Para realizar la configuración maestro maestro, la configuración es la misma que hemos realizado en el apartado anterior, haciendo que la máquina 2 pase a ser también maestra, y que la máquina1 pase a ser también esclava.

Para ello, creamos el usuario esclavo igual que anteriormente en la máquina 2 y le damos los permisos descritos anteriormente.

Al mostrar el estado del maestro en la máquina anterior esclava:

```
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000004 |     2425 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0,00 sec)
```

Por lo que en la máquina anteriormente maestro ejecutamos la siguiente sentencia:

```
mysql> CHANGE MASTER TO MASTER_HOST='10.211.55.10', MASTER_USER='esclavo', MASTER_PASSWORD='esclavo', MASTER_LOG_FILE='mysql-bin.000004', MASTER_LOG_POS= 2425, MASTER_PORT=3306;
Query OK, 0 rows affected, 2 warnings (0,01 sec)
```

Y ya tenemos lista la configuración maestro maestro, es decir, en el momento en que en alguna de las dos se escriba, actualice o borre información, se replicará en la otra al instante:

**Máquina 1**

```
mysql> select * from datos;
+--------+---------+
| nombre | tlf     |
+--------+---------+
| hugo   |     123 |
| hugo   |    1234 |
| hugo   |   12345 |
| hugo   |  123456 |
| hugo   | 1234567 |
+--------+---------+
4 rows in set (0,00 sec)

mysql> insert into datos values('hugo', 1234567);
Query OK, 1 row affected (0,01 sec)
```

**Máquina 2**

```
mysql> select * from datos;
+--------+---------+
| nombre | tlf     |
+--------+---------+
| hugo   |     123 |
| hugo   |    1234 |
| hugo   |   12345 |
| hugo   |  123456 |
| hugo   | 1234567 |
+--------+---------+
4 rows in set (0,00 sec)
```

**Máquina 1**

```
mysql> insert into datos values ('hugo', 12345678);
Query OK, 1 row affected (0,00 sec)

mysql> select * from datos;
+--------+----------+
| nombre | tlf      |
+--------+----------+
| hugo   |      123 |
| hugo   |     1234 |
| hugo   |    12345 |
| hugo   |   123456 |
| hugo   |  1234567 |
| hugo   | 12345678 |
+--------+----------+
6 rows in set (0,00 sec)
```

**Máquina 2**

```
mysql> select * from datos;
+--------+----------+
| nombre | tlf      |
+--------+----------+
| hugo   |      123 |
| hugo   |     1234 |
| hugo   |    12345 |
| hugo   |   123456 |
| hugo   |  1234567 |
| hugo   | 12345678 |
+--------+----------+
6 rows in set (0,00 sec)

mysql> insert into datos values('hugo', 123456789);
Query OK, 1 row affected (0,00 sec)

mysql> select * from datos;
+--------+-----------+
| nombre | tlf       |
+--------+-----------+
| hugo   |       123 |
| hugo   |      1234 |
| hugo   |     12345 |
| hugo   |    123456 |
| hugo   |   1234567 |
| hugo   |  12345678 |
| hugo   | 123456789 |
+--------+-----------+
7 rows in set (0,00 sec)
```

**Máquina 1**

```
mysql> select * from datos;
+--------+-----------+
| nombre | tlf       |
+--------+-----------+
| hugo   |       123 |
| hugo   |      1234 |
| hugo   |     12345 |
| hugo   |    123456 |
| hugo   |   1234567 |
| hugo   |  12345678 |
| hugo   | 123456789 |
+--------+-----------+
7 rows in set (0,00 sec)
```

Y como podemos observar está funcionando perfectamente.