<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">

		<title>Lucee <cfset echo(Server.lucee.version)></title>

		<link rel="stylesheet" href="/res/css/bootstrap.min.css">

		<style>
			code.snippet { display: inline-block; padding: 0.5rem; border: 1px solid lightgrey; border-radius: 0.5rem; margin: 0.5rem 0; }
			li           { margin: 0.75rem 0 0.375rem 0; }
			#page        { max-width: 72rem; margin: 0 auto; }
			.bg-lucee    { background-color: rgb(1, 121, 138); color: white; }
			.path        { font-family: monospace; }
			.cont-path   { background: aqua; }
			.host-path   { background: lawngreen; }
		</style>		
	</head>
	<body>

<div id="page">

<cfoutput>
	<h1 class="bg-lucee text-center p-3">
		<img src="/res/images/lucee-logo-1-color-white.png" class="align-text-bottom" style="height: 60px;">
		#Server.lucee.version# running in
		<img src="/res/images/docker-logo-white-rgb_horizontal.png" class="align-text-bottom" style="height: 60px;">		
	</h1>

	<ul>
		<p>This is the default CFML script that comes with the <a href="https://github.com/isapir/lucee-docker" target="_blank">lucee-docker</a> project.  You can see the source code of the script in the project's directory at <a href="https://github.com/isapir/lucee-docker/blob/master/app/index.cfm" target="_blank"><span class="path host-path">app/index.cfm</span></a>, and it is copied into the container at <span class="path cont-path">#getCurrentTemplatePath()#</span>.</p>
			
		<p>The page was generated at #listGetAt(now(), 2, "'")# #getTimezoneInfo().shortName#.</p>

		<p>To run your own code, you can do one of the following:</p>

		<li>
			<p>Map a local directory of the host machine when launching the container.  This is very useful during development as changes to your code will be immediately reflected in the running application:</p>
			<ul>
				<li>Use the <code>-v</code> argument to mount the host's directory to the container's <span class="path cont-path">/srv/www/webapps/ROOT</span>, e.g. if your application code is on the host at <span class="path host-path">C:\www</span>, you would use the following argument when you execute <code>docker run</code>:
				
					<br>
					<code class="snippet">-v <span class="path host-path">C:\www</span>:<span class="path cont-path">/srv/www/webapps/ROOT</span></code></li>
				</li>
				<li>Make sure that the Docker has permission to access the directory</li>

				<p>Tip: If you need to add/override the Tomcat configuration, you can map a local directory of the host machine to the container at <span class="path cont-path">/srv/www</span> and include in it the Catalina Base files per the Tomcat documentation, and ensure that your application code is in a subdirectoy <code>webapps/ROOT</code>. 
				</p>
			</ul>
		</li>

		<li>
			<p>Package your application code with the Docker image at build time.  This is the recommended option for production use:</p>
			<ul>
				<li>Delete the contents of the <span class="path host-path">app</span> directory of lucee-docker project</li>
				
				<li>Copy your application code into the <span class="path host-path">app</span> directory</li>
				
				<li>Run the <code>docker build</code> command to package your code with the Docker image</li>

				<p>Tip: You can also add other files to the different Catalina Base directories into the <span class="path host-path">resources/catalina-base</span> and files following the standard <a href="https://tomcat.apache.org/" target="_blank">Apache Tomcat</a> documentation.</p>
			</ul>
		</li>
	</ul>
	
	<table class="m-5">
		<tr>
			<td>Lucee Server Admin UI</td>
			<td><a href="/lucee/admin/server.cfm">/lucee/admin/server.cfm</a></td>
		</tr>
		<tr>
			<td>Lucee Server direcotry <sup>*</sup></td>
			<td><span class="path cont-path">#expandPath("{lucee-server}")#</span></td>
		</tr>
		<tr>
			<td>Web Context Admin UI</td>
			<td><a href="/lucee/admin/web.cfm">/lucee/admin/web.cfm</a></td>
		</tr>
		<tr>
			<td>Web Context direcotry <sup>*</sup></td>
			<td><span class="path cont-path">#expandPath("{lucee-web}")#</span></td>
		</tr>
		<tr><td colspan="2" class="small"><sup>*</sup> Directory paths inside the container</td></tr>
	</table>
	<br>
	<br>
</cfoutput>

<cfset dump([
	"now"          : now(),
	"tickCount"    : getTickCount(),
	"timezoneInfo" : getTimezoneInfo(),
	"localeInfo"   : getLocaleInfo(),
	"CGI"          : CGI,
	"Server"       : Server
])>

</div><!--- id=page !--->

</body>
</html>
