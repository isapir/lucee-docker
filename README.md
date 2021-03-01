# Build Custom Lucee Docker Images

This project allows to build custom Lucee Docker Images based on well known directory structures and configurations of Apache Tomcat and Lucee.  

The build process creates an image with a stage name of "Lucee", which can be used as a standalone image, or to create more complex multi-stage builds.  

The build process creates a Stage Build named "Lucee", using the optional Build time args:

    - LUCEE_VERSION
    - LUCEE_ADMIN_PASSWORD
    - LUCEE_EXTENSIONS
    - CATALINA_OPTS
    - TARGET_ENV

1) Start from [Tomcat 9 with Java 11](https://hub.docker.com/_/tomcat).  The following paths are used inside the image:

```
- CATALINA_HOME: /usr/local/tomcat
- CATALINA_BASE: /srv/www/catalina-base
- LUCEE_SERVER : /srv/www/catalina-base/lucee-server
- LUCEE_WEB    : /srv/www/catalina-base/lucee-web
- BASE_DIR     : /srv/www
- WEBAPP_BASE  : /srv/www/app
- WEBAPP_ROOT  : /srv/www/app/webroot
```

2) The Lucee JAR version `$LUCEE_VERSION` is downloaded from release.lucee.org and saved to the `catalina-base/lib` directory.  

Tip: You may add other required JAR files to `catalina-base/lib` as it is added to the "common" Class Loader, so they will be visible to both Tomcat and Lucee.

Tip: you can use a custom Lucee build by saving the JAR file to `catalina-base/lib` and setting `$LUCEE_VERSION` to "CUSTOM".

3) The contents of `resources/catalina-base` are copied over to `$CATALINA_BASE` in the image, setting defaults and allowing you to add/modify configurations and files as needed.  By default that results in the following directory structure:

```
    catalina-base
    ├── bin
    │   └── setenv.sh
    ├── conf
    │   ├── server.xml
    │   └── web.xml
    ├── lib
    │   └── lucee-external-agent.jar
    ├── lucee-server
    │   ├── context
    │   └── deploy
    └── lucee-web
```

4) The contents of the `app` directory are copied over to `$WEBAPP_BASE`.  The Web Root is expected to be in `app/webroot/`.

Tip: You can add supporting files and subdirectories to the `app` directory, so that they can be utilized by the application without being exposed to the public web.

5) If `$LUCEE_ADMIN_PASSWORD` is set then a password file is created in the well known Lucee path.  The `$LUCEE_ADMIN_PASSWORD` is then reset so that it is not leaked into the environment of the Docker image.

6) The working directory is changed to `$BASE_DIR`.

7) Tomcat is launched with the environment variables `$LUCEE_ENABLE_WARMUP` and `$LUCEE_EXTENSIONS`, so that Lucee does an initial run, creates all required directories and files, and downloads extensions if specified.  Once the warmup completes, Tomcat shuts down.

8) Directory `resources/target-envs/${TARGET_ENV}` is copied into `$CATALINA_BASE` in the image.  This allows to set up different configurations for different target environments, e.g. DEV, STAGING, PROD, etc.

9) If file `catalina-base/bin/addenv.sh` exists it is included from `catalina-base/bin/setenv.sh` when Tomcat starts. 

## docker image build

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

You can add custom files, e.g. Java JAR files, by saving them to the `resources/catalina-base` directory in the appropriate subdirectory per the [Apache Tomcat documentation](https://tomcat.apache.org/tomcat-9.0-doc/index.html), e.g. JAR files would go in `resources/catalina-base/lib`.

### Putting it all together to build a custom image

The following command should be on one line.  It is broken here to multiple lines for readability, using the *nix `\` escape character (the equivalent escape character on Windows is the `^` character).  This example will build an image from Lucee 5.3.7.34-RC, set the Admin password to "changeit", and add the WebSocket extension:

    docker image build .       \
        -t isapir/lucee-538-rc \
        --build-arg LUCEE_ADMIN_PASSWORD=changeit \
        --build-arg LUCEE_VERSION=5.3.7.34-RC     \
        --build-arg LUCEE_EXTENSIONS="3F9DFF32-B555-449D-B0EB5DB723044045;name=WebSocket"

### docker image push

Once you've built the image you can push it to your Docker Hub account (or other repository that you might use).  That is very useful if you want to be able to pull the image from any host machine without having to build it each time.  The command is `docker image push <tag-name>`.  , e.g.:

    docker image push isapir/lucee-538-rc

## docker container run

Once the image is built, or is on Docker Hub, you can run it using the `docker run` command.  At the very least, you will probably want to map some TCP port on the Host machine to port 8080 of the container using the argument `-p <host-port>:8080`.

Another useful option is to give the container a name so that you can refer to it by name rather than by a random hash.  That is done using the `--name <container-name` switch.

The following command would launch a container from the image tagged `isapir/lucee-538-rc`, name it `lucee-8080`, and map port 8080 of the Host to port 8080 of the container:

    docker container run -p 8080:8080 --name lucee-8080 isapir/lucee-538-rc

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
            isapir/lucee-538-rc
