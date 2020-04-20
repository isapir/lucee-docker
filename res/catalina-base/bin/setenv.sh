
CATALINA_OPTS="${CATALINA_OPTS} -Djava.security.egd=file:/dev/./urandom"

CATALINA_OPTS="${CATALINA_OPTS} -Dorg.apache.catalina.startup.ContextConfig.jarsToSkip=*"
CATALINA_OPTS="${CATALINA_OPTS} -Dorg.apache.catalina.startup.TldConfig.jarsToSkip=*"
CATALINA_OPTS="${CATALINA_OPTS} -Dtomcat.util.scan.StandardJarScanFilter.jarsToSkip=*"

CATALINA_OPTS="${CATALINA_OPTS} -javaagent:${CATALINA_BASE}/lib/lucee-external-agent.jar"
