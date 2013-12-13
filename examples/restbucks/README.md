# Swagger Sample Application

## Overview

This is an Eiffel project to build a stand-alone server which implements the Swagger spec.  You can find out
more about both the spec and the framework at http://swagger.wordnik.com.  For more information
about Wordnik's APIs, please visit http://developer.wordnik.com.

### To build

You will need these dependencies:
* [EWF](https://github.com/EiffelWebFramework/EWF)
* [JSON](https://github.com/eiffelhub/json)
* [Gobo](https://github.com/gobo-eiffel/gobo)
* [Gobo ECF files](https://github.com/oligot/gobo-ecf)

Just clone the Git repositories (or download the latest release) locally and define the environment variable
EIFFEL_LIBRARY. See also the [EWF Getting Started guide](http://eiffelwebframework.github.io/EWF/getting-started/).

### To run

The server listens on port 9090.

### Testing the server

Once started, you can navigate to http://localhost:9090/api to view the Swagger Resource Listing.
This tells you that the server is up and ready to demonstrate Swagger.

### Using the UI

There is an HTML5-based API tool available in a separate project.  This lets you inspect the API using an
intuitive UI.  You can pull this code from here:  https://github.com/wordnik/swagger-ui

You can then open the dist/index.html file in any HTML5-enabled browser.  Upon opening, enter the
URL of your server in the top-centered input box (default is http://localhost:9090/api).  Click the "Explore"
button and you should see the resources available on the server.
