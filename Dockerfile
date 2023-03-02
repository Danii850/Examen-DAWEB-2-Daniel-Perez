# Creamos la imagen a partir de la imagen oficial de tomcat desde DockerHub
FROM tomcat:latest

# Declaramos dos variables de entorno uno para CATALINA_BASE Y OTRO PARA CATALINA_HOME
ENV CATALINA_BASE=/usr/local/tomcat
ENV CATALINA_HOME=/usr/local/tomcat

# Creamos el directorio /urs/local
RUN mkdir -p /usr/local/tomcat

# Le damos los permisos de ejecución a todos los usuarios al script de catalina.sh
RUN chmod 755 $CATALINA_HOME/bin/catalina.sh

# Copiamos los context.xml a la ruta del contenedor y borrando los que vienen por defecto (esto lo hacemos para a la hora de entrar
# en un botón de Server status no nos salga una pantalla de error y nos salga un cuadro para logearnos)

COPY host-manager/META-INF/context.xml $CATALINA_HOME/webapps.dist/host-manager/META-INF/context.xml
COPY manager/META-INF/context.xml $CATALINA_HOME/webapps.dist/manager/META-INF/context.xml

# Copiamos el fichero tomcat-users.xml al contenedor,machacando el que viene por defecto

COPY tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml

# Creamos los usuarios para poder acceder a los botones de Server status, Manager status y Host manager
RUN useradd -p admin admin
RUN useradd -p robot robot

# Copiamos la aplicación desde nuestro equipo al directorio webapps del contenedor
COPY sample.war $CATALINA_HOME/webapps.dist

# Ponemos como escucha el puerto 8080
EXPOSE 8080/tcp

# Ejecutamos el script catalina.sh para iniciar el servidor de tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]