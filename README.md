Adam Gschwender Resume
======================

Project for managing and deploying my resume.

### Development

Developing on the project assumes you have [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) set up. The project defines two containers:

* An `nginx` container which serves a static HTML website
* A `certbot` container for managing SSL certs (forked from [wmnnd/nginx-certbot](https://github.com/wmnnd/nginx-certbot))

### Running

Before the `nginx` container can run, it will need SSL certificates generated. To do that, run

```
$ make initssl
```

This will generate some dummy certs, which will allow the `nginx` server to start up.

```
$ make start
```

This will start up the `nginx` server in the background. At this point, [localhost](http://localhost) should serve the website. To stop the server, run

```
$ make stop
```

For a full list of commands run `make help`.

### Deploying

To deploy the application, run

```
$ make deploy
```

This will copy the repo to the server, rebuild the containers and reload `nginx`. However, the application suffers from the same problem as the local environment; it's missing the certs. To initialize the certificates for the first time, run

```
$ make deploy.initssl
```

This should not be necessary after the first deployment and the `certbot` should ensure that the certs are kept up-to-date. At this point, [gschwa.com](https://gschwa.com) should be accessible over SSL.
