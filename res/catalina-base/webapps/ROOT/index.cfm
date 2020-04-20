<style>
	code.snippet { display: inline-block; padding: 0.5rem; border: 1px solid lightgrey; border-radius: 0.5rem; margin: 0.5rem 0; }
	li           { margin: 0.75rem 0 0.375rem 0; }
	#page        { max-width: 72rem; margin: 0 auto; }
	.path        { font-family: monospace; }
	.cont-path   { background: aqua; }
	.host-path   { background: lawngreen; }
	.footnote    { font-size: 0.875rem; }
</style>

<div id="page">

<cfoutput>
	<h1>Lucee #Server.lucee.version# Running in Docker</h1>

	<ul>
		This is the default page that comes with the Dockerfile.  There are a few options that you can use in order to run your own code:

		<li>Copy your code to the Docker project directory on the host at <span class="path host-path">res/catalina-base/webapps/ROOT</span> and run 
			the docker build command to package your code with the Docker image.  You can also add other
			files to the different Catalina Base directories and files following the standard Tomcat 
			guidelines.  This is often the recommended method for building Docker images for production.</li>

		<li>Map a local directory of the host machine to <span class="path cont-path">/srv/www/webapps/ROOT</span> when you call docker run
			to execute the code from your local directory.  This is useful for development and testing.  You can specify that mapping
			with the following docker run command line argument: 
			<br>
			<code class="snippet">-v &lt;path-to-local-directory&gt;:/srv/www/webapps/ROOT</code></li>
			e.g. to run an application from <span class="path host-path">C:\www</span> pass the argument
			<br> 
			<code class="snippet">-v <span class="path host-path">C:\www</span>:<span class="path cont-path">/srv/www/webapps/ROOT</span></code></li>

		<li>Map a local directory of the host machine to <span class="path cont-path">/srv/www</span> which will work similarly to the previous
			option, but will also allow you to override other files and directories at runtime, e.g. 
			the Tomcat config files, etc.  That local directory should contain a subdirectory <span class="path host-path">webapps/ROOT</span>
			which will contains the Application code.
	</ul>
	
	<table>
		<tr>
			<td>Lucee Server Admin</td>
			<td><a href="/lucee/admin/server.cfm">/lucee/admin/server.cfm</a></td>
		</tr>
		<tr>
			<td>Lucee Server direcotry <sup>*</sup></td>
			<td><span class="path cont-path">#expandPath("{lucee-server}")#</span></td>
		</tr>
		<tr>
			<td>Web Context Admin</td>
			<td><a href="/lucee/admin/web.cfm">/lucee/admin/web.cfm</a></td>
		</tr>
		<tr>
			<td>Web Context direcotry <sup>*</sup></td>
			<td><span class="path cont-path">#expandPath("{lucee-web}")#</span></td>
		</tr>
		<tr><td colspan="2" class="footnote"><sup>*</sup> Directory paths inside the container</td></tr>
	</table>
	<br>
	<br>
</cfoutput>

<cfscript>

dump([
	"now"       : now(),
	"tickCount" : getTickCount(),
	"timezone"  : getTimezone(),
	"locale"    : getLocale(),
	"Server"    : Server,
	"CGI"       : CGI
]);

</cfscript>

</div>