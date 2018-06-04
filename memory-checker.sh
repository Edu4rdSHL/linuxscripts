#!/usr/bin/bash
#Este script muestra que aplicaciones consumen más RAM y CPU en tu equipo.

ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem|head
