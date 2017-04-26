#!/bin/sh

# Borrar todas las configuraciones para empezar desde un estado limpio
iptables -F
iptables -t nat -F
iptables -X
iptables -t nat -X

# Bloquear todo el tráfico
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Permitir cualquier acceso desde localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permitir la conexión por ssh en el puerto 22
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

# Permitir el redireccionamiento entre máquinas
echo 1 > /proc/sys/net/ipv4/ip_forward

# Redireccionamiento HTTP
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.211.55.11:80
iptables -t nat -A POSTROUTING -p tcp -d 10.211.55.11 --dport 80 -j SNAT --to-source 10.211.55.12

# Redireccionamiento HTTPS
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 10.211.55.11:443
iptables -t nat -A POSTROUTING -p tcp -d 10.211.55.11 --dport 443 -j SNAT --to-source 10.211.55.12

# Permitir las conexiones HTTP/HTTPS (80 y 443)
iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT
