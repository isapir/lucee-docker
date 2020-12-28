# This directory must have a subdirectory named webroot with the application code

The application code should be in a subdirectory of this directory, named webroot.
## It is otherwise safe to delete the contents of this directory.

This directory contains a subdirectory named webroot with a the sample "welcome" page and resources of the project.  

You can delete its contents and replace it with your app's code if you want to package it with the Docker image at build time.

This actual code should go into "webroot/", and any supporting code that should be kept outside the webroot can be placed in this directory.