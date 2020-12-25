
CATALINA_OPTS="${CATALINA_OPTS} -Djava.security.egd=file:/dev/./urandom"
CATALINA_OPTS="${CATALINA_OPTS} -Dorg.apache.catalina.startup.ContextConfig.jarsToSkip=*"
CATALINA_OPTS="${CATALINA_OPTS} -Dorg.apache.catalina.startup.TldConfig.jarsToSkip=*"
CATALINA_OPTS="${CATALINA_OPTS} -Dtomcat.util.scan.StandardJarScanFilter.jarsToSkip=*"

CATALINA_OPTS="${CATALINA_OPTS} -javaagent:${CATALINA_BASE}/lib/lucee-external-agent.jar"

CATALINA_OPTS="${CATALINA_OPTS} -Dlucee.preserve.case=true"

# set Lucee config dirs to /srv/www/lucee-server and /srv/www/lucee-web
CATALINA_OPTS="${CATALINA_OPTS} -Dlucee.server.dir=${CATALINA_BASE}"
CATALINA_OPTS="${CATALINA_OPTS} -Dlucee.web.dir=/srv/www/lucee-web"
