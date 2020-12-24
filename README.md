# Build Custom Lucee Docker Images

## Build

The minimum you have to do in order to build a Docker image is to switch to the project directory and run the following
command (where `.` means the current directory):

    docker image build .
    
It is often useful to tag the image so that you can refer to it later by name rather than a hash.  To do that, pass the argument `-t <tag-name>`

Other useful arguments that the Dockerfile can be passed by using the `--build-arg` switch to set Environment variables to the build process:

### LUCEE_ADMIN_PASSWORD

This will set the Lucee Admin password to the value passed

### LUCEE_VERSION

This must be a full version number, including the modifier suffix if one exist, e.g. `-SNAPSHOT`, `-BETA`, `-RC`, etc.  You can see the available versions on the [Lucee Download page](https://download.lucee.org/).

You may also build a CUSTOM version by setting the LUCEE_VERSION environment variable to "CUSTOM" and placing a Lucee JAR file in the `resources/catalina-base/lib/` directory.

### LUCEE_EXTENSIONS

This argument will download the specified extensions at build time so that you don't have to wait for them when running the container.  The value is a comma separated list where each element is a semi-colon separated list that starts with the extension unique identifier, followed by optional name, label, and version (if not specified then the most recent version of the extension will be used).

### CATALINA_OPTS

Use CATALINA_OPTS to set Java options and system properties. 

### Adding Files to the Image

You can add your application code to the `app` directory.  All of the files in that directory are for the sake of example only and can be safely deleted.

You can add custom files, e.g. Java JAR files, by saving them to the `res/catalina-base` directory in the appropriate subdirectory per the [Apache Tomcat documentation](https://tomcat.apache.org/tomcat-9.0-doc/index.html), e.g. JAR files would go in `res/catalina-base/lib`.

### Putting it all together to build a custom image

The following command should be on one line.  It is broken here to multiple lines for readability, using the *nix `\` escape character (the equivalent escape character on Windows is the `^` character).  This example will build an image from Lucee 5.3.7.34-RC, set the Admin password to "changeit", and add the WebSocket extension:

    docker image build .       \
        -t isapir/lucee-537-rc \
        --build-arg LUCEE_ADMIN_PASSWORD=changeit \
        --build-arg LUCEE_VERSION=5.3.7.34-RC     \
        --build-arg LUCEE_EXTENSIONS="3F9DFF32-B555-449D-B0EB5DB723044045;name=WebSocket"

### Push

Once you've built the image you can push it to your Docker Hub account (or other repository that you might use).  That is very useful if you want to be able to pull the image from any host machine without having to build it each time.  The command is `docker push <tag-name>`.  , e.g.:

    docker push isapir/lucee-537-rc

## Run

Once the image is built, or is on Docker Hub, you can run it using the `docker run` command.  At the very least, you will probably want to map some TCP port on the Host machine to port 8080 of the container using the argument `-p <host-port>:8080`.

Another useful option is to give the container a name so that you can refer to it by name rather than by a random hash.  That is done using the `--name <container-name` switch.

The following command would launch a container from the image tagged `isapir/lucee-537-rc`, name it `lucee-8080`, and map port 8080 of the Host to port 8080 of the container:

    docker container run -p 8080:8080 --name lucee-8080 isapir/lucee-537-rc

You can also pass Environment variables to the container using the `-e` switch, for example `-e LUCEE_PRESERVE_CASE=true` will preserve the CaSe of variables and unquoted struct keys.  You can similarly pass other options to Lucee.

Please note that the image name has to be the last argument, so all switches must come before it.

### Mapping a Host Directory

A very useful option, especially when developing or testing code, is to map a directory from the Host machine to the container.  Mapping a directory is done using the `-v <directory-on-host>:<directory-in-container>` switch.

If you want to use the settings from the image, and only map the application code to the container, then map it to `/srv/www/webapps/ROOT`.  For example, if you application code on the host machine is at `C:\www` then you can map it with `-v C:\www:/srv/www/webapps/ROOT`.

If you want to map a Catalina Base directory structure which can set options to Tomcat and the JVM, you can map it to `/srv/www` in the container.  Just be sure to have a subdirectory at `webapps/ROOT` with your application code.

The following example will launch a container with the name "lucee-8080", set the LUCEE_PRESERVE_CASE option, map port 8080 from the host, and map the directory `/workspace/src/lucee-docker-test` to the container's `/srv/www/webapps/ROOT` directory.  As in the build example, the `\` escape character are used in order to break the command into multiple lines so that it's more readable, but in general the whole command should be on one line: 

    docker container run            \
        -p 8080:8080                \
        -e LUCEE_PRESERVE_CASE=true \
        -v /workspace/src/lucee-docker-test:/srv/www/webapps/ROOT \
        --name lucee-8080 \
            isapir/lucee-537-rc
