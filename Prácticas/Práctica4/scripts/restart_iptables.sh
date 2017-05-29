#!/bin/sh

# Borrar todas las configuraciones para empezar desde un estado limpio
iptables -F
iptables -t nat -F
iptables -X

# Bloquear todo el tráfico
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
