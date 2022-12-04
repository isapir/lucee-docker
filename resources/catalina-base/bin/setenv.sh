
CATALINA_OPTS="${CATALINA_OPTS} -XshowSettings:vm"

CATALINA_OPTS="${CATALINA_OPTS} -Djava.security.egd=file:/dev/./urandom"
CATALINA_OPTS="${CATALINA_OPTS} -Dorg.apache.catalina.startup.ContextConfig.jarsToSkip=*"
CATALINA_OPTS="${CATALINA_OPTS} -Dorg.apache.catalina.startup.TldConfig.jarsToSkip=*"
CATALINA_OPTS="${CATALINA_OPTS} -Dtomcat.util.scan.StandardJarScanFilter.jarsToSkip=*"

CATALINA_OPTS="${CATALINA_OPTS} -javaagent:${CATALINA_BASE}/lib/lucee-external-agent.jar"

# set Tomcat webroot via server.xml Service/Engine/Host/Context#docBase
CATALINA_OPTS="${CATALINA_OPTS} -Dserver.webroot=${SERVER_WEBROOT}"

CATALINA_OPTS="${CATALINA_OPTS} -Dlucee.preserve.case=true"

# set Lucee lucee.server.dir config to /srv/www/lucee-server
if [[ ${CATALINA_OPTS} != *"lucee.server.dir"* ]]; then

    echo "lucee.server.dir is not set in CATALINA_OPTS"
    CATALINA_OPTS="${CATALINA_OPTS} -Dlucee.server.dir=${CATALINA_BASE}"
else

    echo "lucee.server.dir is set in CATALINA_OPTS"
fi

# set Lucee lucee.web.dir config to /srv/www/lucee-web only if it does not exist
if [[ ${CATALINA_OPTS} != *"lucee.web.dir"* ]]; then

    echo "lucee.web.dir is not set in CATALINA_OPTS"
    CATALINA_OPTS="${CATALINA_OPTS} -Dlucee.web.dir=${CATALINA_BASE}/lucee-web"
else

    echo "lucee.web.dir is set in CATALINA_OPTS"
fi


# if file /srv/www/catalina-base/bin/addenv.sh exists then include it
ENV_INCLUDE_FILE=/srv/www/catalina-base/bin/addenv.sh
if [ -f $ENV_INCLUDE_FILE ]; then
    # set default to export variables
    set -a

    echo "Including file $ENV_INCLUDE_FILE"
    . $ENV_INCLUDE_FILE

    # unset default to export variables
    set +a
fi
