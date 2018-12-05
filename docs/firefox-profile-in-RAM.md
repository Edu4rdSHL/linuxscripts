# Perfil de Firefox en RAM

Suponiendo que hay memoria de sobra, colocar la memoria caché de Firefox o el perfil completo en la RAM ofrece ventajas significativas. A pesar de que optar por la ruta parcial es una mejora en sí misma, esto último puede hacer que Firefox sea aún más sensible en comparación con su configuración por defecto. Los beneficios incluyen, entre otros:

    1. Cantidad reducida de lecturas/ escrituras en disco;
    2. Mayor velocidad de respuesta;
    3. Muchas operaciones dentro de Firefox, como la búsqueda rápida y las consultas de historial, son casi instantáneas.

Para ello podemos hacer uso de un tmpfs Sistema de archivos temporal).

Debido a que los datos colocados allí no pueden sobrevivir a un apagado, es necesario un script responsable de la sincronización con la unidad antes del cierre del sistema si se desea la persistencia (lo que es probable en el caso de la reubicación del perfil). Por otro lado, solo la reubicación de la memoria caché es una solución rápida y menos inclusiva que acelerará ligeramente la experiencia del usuario al vaciar la memoria caché de Firefox en cada reinicio.

**Antes de iniciar:**

Realice una copia de seguridad de su perfil actual de Firefox y asegúrese de que solo tendrá uno en el directorio $HOME/.mozilla/firefox. Normalmente los perfiles presentan un nombre similar a xyz.default, para esta guía usaremos como referencia el nombre anterior. Para conocer que perfiles tiene en su equipo, ejecute lo siguiente:

```
$ ls $HOME/.mozilla/firefox |grep *.default
```

Luego haga una copia de seguridad de su perfil con:

```
$ tar zcvfp ~/firefox_profile_backup.tar.gz ~/.mozilla/firefox/xyz.default
```


# **El script que coloca el perfil de Firefox en RAM:**

El script lo encontrarán en este enlace: https://gitlab.com/edu4rdshl/linuxscripts/blob/master/user-bin/firefox-sync, deben crear un archivo dentro de $HOME/.local/bin con el nombre *firefox-sync*, una vez creado deben seguir estos pasos:

Terminar todos los procesos de firefox corriendo:

```
$ killall firefox firefox-bin
```

Darle permisos de ejecución al archivo creado:

```
$ chmod +x ~/.local/bin/firefox-sync
```

Encontrar el nombre del perfil de Firefox:

```
$ ls ~/.mozilla/firefox
```

Ejecutar el binario seguido del nombre del perfil:

```
$ ~/.local/bin/firefox-sync <firefox-profile>
``` 

En nuestro caso que el perfil se llama xyz.default, se ejecutaría este comando:

```
$ ~/.local/bin/firefox-sync xyz.default
```

# **Automatizando la tarea:**

**Mediante systemD**

Los pasos explicados a continuación solo funcionan si su distribución GNU/Linux está usnado SystemD.

Cree un archivo llamado *firefox-profile@.service* dentro del directorio *$HOME/.config/systemd/user*, si el directorio no existe debe crearlo. El archivo debe contener el contenido que se encuentra en este link: https://gitlab.com/edu4rdshl/linuxscripts/blob/master/user/firefox-profile@.service. No olvide reemplazar **YourUsername** con el nombre de usuario que usted tenga en su sistema.

Luego ejecute estos comandos:

```
$ systemctl --user daemon-reload
$ systemctl --user enable firefox-profile@<profile>.service
$ systemctl --user start firefox-profile@<profile>.service 
```
No olvide reemplazar `<profile>` con el nombre de su perfil, en nuestro caso xyz.default.

**Mediante CRON**

Ejecute:

```
crontab -e
```

Añada esta línea para ejecutar el script cada 30 minutos:

`*/30 * * * * ~/.local/bin/firefox-sync`

O esta para hacerlo cada 2 horas:

`0 */2 * * * ~/.local/bin/firefox-sync`

**Para ejecutarlo al hacer login/cerrar sesión:**

Ejecute este comando para añadir las líneas necesarias en *.bash_logout* y *.bash_profile*:

`$ echo '~/.local/bin/firefox-sync' | tee -a ~/.bash_logout ~/.bash_profile >/dev/null`

Con esto finalizamos, no olvides registrarte en nuestro foro: https://foro.securityhacklabs.net, unirte a nuestro servidor de chat Discord en: https://chat.securityhacklabs.net, en él podrás tratar temas de hacking, sistemas operativos y todo lo relacionado con seguridad en general. Las instrucciones para instalar Discord en todas las plataformas las encontrará aquí: https://gitlab.com/sechacklabs/hacking/blob/master/instalacion%20de%20discord.md