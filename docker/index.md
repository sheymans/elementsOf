---
title:                             Elements of Docker Containers
author: Stijn Heymans
date:                             23 April 2020
---

# Introduction

Docker containers are often presented as magic -- _"don't you dare persisting
anything in a container, it will be lost forever!"_. In this article, I will
show that containers are not magic by going through the lifecycle of an app
running on your laptop to an app running in a container on your laptop (the
so-called _containerizing_ of an app).  I will build an image from the app,
publish the image, and run that image in a container, all the while showing you
the basic commands of manipulating images, containers, and volumes.

You can download the demo code I wrote for this article on
[github](https://github.com/sheymans/elementsOf/tree/master/docker/demo).  The
demo is a Javascript app, but there's so little code it should not cause too
many side effects when consumed in moderation.

Finally, I used the book [Docker Deep Dive](https://www.goodreads.com/book/show/39933970-docker-deep-dive)by Nigel Poulton as a reference.


# The Demo App

There's nothing quite like a toy example that is absolutely nothing like you
will ever encounter in the real world, and I did my utter best to not
disappoint.  I'll use the web framework
[Express](expressjs.com) for [node](nodejs.org) to write an app that says `Hi`,
clearly a step down from `Hello World`.

This is the Javascript file `hi.js`:

~~~js
// Initialize your express app
const express = require('express');
const app = express();

// Tell your app that any GET should be resulting in a `Hi` returned to the user
app.get('/', (request, result) => result.send('Hi'));

// Your app will be listening on port 8111 and it
// will announce this on the console when you start it
app.listen(8111, () => console.log('hi: listening on port 8111'));
~~~

As I'm using `express`, I have a `package.json`[^packagejson] file that contains `express` as a dependency:

~~~json
{
  "name": "hi",
  "version": "1.0.0",
  "author": "Stijn Heymans",
  "dependencies": {
    "express": "^4.17.1"
  }
}
~~~

To make sure I can run this app, I install that `express` dependency as follows:

~~~bash
npm install
~~~

I use the node package manager [npm](https://www.npmjs.com/) to do that. `npm`
looks at the `package.json` file, it sees that there's a dependency
`express` and installs `express` into the directory `node_modules/`.

To start the app, type:

~~~bash
node hi.js
~~~

You can navigate to http://localhost:8111 to be said `Hi` to. Isn't it wonderful to have friends like that?

These were some of the assumptions I made and the steps I took to run this app on a laptop[^laptop] :

- the laptop allows for installing and running software such as `npm` and `node`.  For example, its Operating System (OS) is Linux or Mac OS X
- `npm` is installed, to, in turn, install the required dependencies of your app (`express`)
- `npm install` was run from the command-line to install dependencies such as `express`
- `node` was installed to actually run the application
- `node hi.js` was run from the command-line

If you want to install and run your app on another laptop (or, on an [EC2
instance](https://en.wikipedia.org/wiki/Amazon_Elastic_Compute_Cloud)), similar
assumptions hold and you need to install the same packages as well as execute
similar commands.  _"Well, of course, I would not repeat these steps, I'd put
them all in a little script so I just have to run the script"_. You would. But
you'd be forgetting that a laptop and an EC2 instance are very different
things. You'd probably want scripts per different OS at the
minimum. For example, installing `npm` and `node` requires different steps,
depending on the OS you're installing them on.

What if instead of doing these steps manually (and the steps being different
depending on your OS), you could package your app while specifying:

- a small OS System to install the app on, for example [alpine](https://alpinelinux.org/)
- an installation of `npm` and `node` layered on that
- instructions to install your application (`npm install`)
- instructions to run your application (`node hi.js`)

In other words, what if you could define a small container based on the above
specification that you can run anywhere where such containers can run?


::: warning
WARNING: Obligatory Container on a Ship Reference
A container is a standard packaging solution that you can fill with any stuff,
you can put it on a ship and send it off anywhere in the world.

:::
# Containerizing the App

To containerize the app, I use [docker](docker.com). In this article, I'll refer to a _Docker
container_ as a synonym of a _container_. Before I can run the app in a
container, I need an _image_.  Explaining in precise terms what an _image_ is,
is beyond my abilities. My mental definition is that an image is an
abstract specification of the OS as well as anything needed to run the app.
The image can be _understood_ by `docker` when it needs to run your
application.  Compare this to other abstractions in Computer Science:

- a _Java class_ specifies the behavior of an instance of that class
- a _`jar` file_ packages up your Java application and can then be run by the Java runtime.
- a Linux ISO image packages up the Linux OS: you can download the image, install the image, and run the Linux OS on your laptop once it's installed
- a Python script specifies which instructions to run for the Python interpreter

These comparisons are imperfect, but all have the aspect of a specification of
all its resources (the `image`) that can then be run/executed on a machine.

In the previous section, I summarized the aspects that I want to specify for the demo app:

- a small OS to start from, for example [alpine](https://alpinelinux.org/)
- an installation of `npm` and `node` layered on that so we can install our app (`npm`) and run our app (`node`)
- instructions to install the application (`npm install`)
- instructions to run the application (`node hi.js`)

I can write up that informal specification in a format that `docker`
understands so it can build an `image` based on it.  Specifications to build
docker images are in a file named `Dockerfile`. Conceptually, they are similar
to `package.json` files: `package.json` files specify your application's
dependencies, and a `Dockerfile` specifies the dependencies the app has from an
OS perspective (what OS does the app assume, what should be installed on the OS
to be able to run the app).


::: warning
Tip
The directory on your laptop where your `Dockerfile` exists is
called the _build-context_.

:::
I want the app to be layered on the [Linux alpine OS
system](https://alpinelinux.org/) -- a small Linux, about 4MB,
compared to Ubuntu which is more than 100MB -- so the first line of the
`Dockerfile` is:

~~~
FROM alpine
~~~

Next, I need an installation of `npm` and `node` layered over that:

~~~
RUN apk add --update nodejs nodejs-npm
~~~

`apk add --update nodejs nodejs-npm` is the command you run on alpine to
install `node` and `npm` (see
[apk](https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management)). If I
would have picked a different image to start from, I might have needed a
different install command. The important part of this line is `RUN`. `RUN` runs
whatever comes after it and will build a new layer in the image. In this case,
the new layer will have an installation of `node` and `npm`.

I then specify that I want to copy all the files from the build-context (the
directory on your laptop that has your `Dockerfile`) into a root directory
`/src` of the new image I'm creating. Thus, `docker` will copy over `hi.js` and
`package.json` into a root directory `/src`.  Intuitively, our image of course
needs the source files for our demo app in order to be able to run it.

~~~
COPY . /src
~~~

The `.` is the current directory (i.e., where the `Dockerfile` lives, the
_build-context_). This `COPY` command will create a new layer in the resulting
image.

To summarize, at this point I have specified that I need an image
consisting of a Linux OS (`alpine`), that I need to install `node` and `npm`
into that image, and that I want to copy the app's source code into the
directory `/src` on the image. Next, I want to use `npm` to install the app.
For this, I'll specify that the `/src` directory needs to be the _current_
working directory and that I want to execute `npm install`:

~~~
WORKDIR /src
RUN npm install
~~~

`WORKDIR` changes the working directory to `/src` and you already know the
`RUN` command: it just executes `npm install` . The latter will
like it did on your laptop, look for `package.json`, find your
dependencies (`express`) and install those.

Almost there. Indicate how to run the application:

~~~
ENTRYPOINT ["node", "./hi.js"]
~~~

This command determines which application to run when we `run` the container. Note that
I did not use `RUN` for this; `RUN` adds a new image layer, whereas
`ENTRYPOINT` just adds metadata and appears only once in the `Dockerfile` to
indicate _this is what you run once the container is ready to be run_.

We indicate with `EXPOSE` that our app is running on port `8111`:

~~~
EXPOSE 8111
~~~

To round it off, we add some more metadata to the image:

~~~
LABEL maintainer="ben@ny.com"
~~~

This is the whole `Dockerfile`:

~~~
FROM alpine
RUN apk add --update nodejs nodejs-npm
COPY . /src
WORKDIR /src
RUN npm install
ENTRYPOINT ["node", "./hi.js"]
EXPOSE 8111
LABEL maintainer="ben@ny.com"
~~~

I can then use this `Dockerfile` to build an image:

~~~bash
 docker image build -t hi:latest .
~~~

Dissecting this command:

- `docker`: the `docker` program that we use to build images, run images, etc
- `image`: tell `docker` that what we're doing involves images (there's also `docker container` to indicate that you're working with containers)
- `build`: build an image
- `-t hi:latest`: we're *t*agging an image with name `hi` and with tag `latest`. A tag can be used to identify different versions of your software (tag `v1` for example)
- `.`: don't forget the `.`. The `.` stands for _look into your current directory for the Dockerfile_.


::: warning
Tip
`-t` indeed stands for _tag_ and not _target_ (there's a `--target` option as well)

:::
After running that command, I can check whether there's now an image available using `ls`:

~~~
docker image ls
~~~

Dissecting that command:

- `docker`: the `docker` program
- `image`: we're dealing with images
- `ls`: the listing command

This will give as output something like:

~~~
REPOSITORY     TAG       IMAGE ID            CREATED             SIZE
hi             latest    5d3095b79194        5 minutes ago       57.2MB
~~~

This shows our created image with repository name `hi`, tag `latest`, and
image id `5d3095b79194` -- the image id will be different on your machine.

Sometimes you'd just want the `IMAGE ID`s, for example, to pipe
them to another command. For that situation, you can use `--format`. The `--format` option uses [Go
templates](https://golang.org/pkg/text/template/) to extract the data you want
to see formatted. For example, let's say I want to see the size:

~~~
docker image ls --format "{{.Size}}"
~~~

This will show:

~~~
57.2MB
~~~

To see the image ids, you might try:

~~~
docker image ls --format "{{.ImageId}}"
~~~

This unfortunately gives you the error:

~~~
Template parsing error: template: :1:2: executing "" at <.ImageId>: can't evaluate field ImageId in type formatter.imageContext
~~~

While `docker image ls` shows `IMAGE ID` as a column name, that's not how
you can access this field. There's a
[hint](https://docs.docker.com/config/formatting/) on how you can see the
attributes that you can actually use in `--format`:

~~~
docker image ls --format "{{json .}}"
~~~

This will make a json out of _everything_ and will show:

~~~
{"Containers":"N/A","CreatedAt":"2020-03-25 08:11:44 -0700 PDT","CreatedSince":"2 days ago","Digest":"\u003cnone\u003e","ID":"5d3095b79194","Repository":"hi","SharedSize":"N/A","Size":"57.2MB","Tag":"latest","UniqueSize":"N/A","VirtualSize":"57.23MB"}
~~~

From that you can see that the `IMAGE ID` is actually the value of an attribute `ID`. Trying that,

~~~
docker image ls --format "{{.ID}}"
~~~

will give you `5d3095b79194`.

Finally, have a closer look at the created image:

~~~
docker image inspect 5d3095b79194
~~~

You'll see the label `maintainer`, the entrypoint `node ./hi.js`, and the
different layers with different ids that were created as part of this image
(recall that each `RUN` created a different layer).  I encourage you to spend
some quality time with that `docker image inspect` output. I did not spend time
explaining layers in an image, but you can [dig in more here if you'd
like](https://medium.com/@jessgreb01/digging-into-docker-layers-c22f948ed612).

# Publishing the Image

I created an image locally on my laptop. Usually, if you want other users to be
able to use your image, you can upload it to the [Docker
Hub](https://hub.docker.com/). After you uploaded your image to a Docker Hub
repository, other developers can then _pull_ it. Have a look at this
[tutorial](https://ropenscilabs.github.io/r-docker-tutorial/04-Dockerhub.html)
if you'd like to see some of the steps involved, because that's all I'll say
about publishing your image.

# Running the Container

With that image `hi:latest`, I can create a running instance (aka container).
Where before my commands started with `docker image` for image manipulation,
I'll in this section mostly use `docker container` to manipulate containers:

~~~
docker container run -d hi:latest
~~~

This command starts the container in detached/background mode (hence the `-d`)
and uses the image `hi:latest` to instantiate the container. Since I
specified that this container should be running `node ./hi.js` using the
`ENTRYPOINT` statement in the `Dockerfile`, I expect to see this app running
when I _jump into_ the container.

Before getting into detail of the prosaic _jumping into_ containers, I need to
know what the ID or name of the freshly started container is:

~~~
docker container ls
~~~

This is the output of that command:

~~~
CONTAINER ID      IMAGE      COMMAND         CREATED        STATUS        PORTS     NAMES
885288159d28      hi:latest  "node ./hi.js"  2 minutes ago  Up 2 minutes  8111/tcp  boring_dijkstra
~~~

The running container has ID `885288159d28` and name `boring_dijkstra`.  I did
not specify a name when running the container, so I got a random
`boring_dijkstra`. You can define your own container name using the `--name`
option: `docker container run --name exciting_dijkstra -d hi:latest`. The output
further shows that my container is executing the command `node ./hi.js` which is
exactly what I specified in `Dockerfile`.

Now that I have the name of the running container, I can do some _jumping
into_:

~~~
docker container exec -it boring_dijkstra sh
~~~


::: warning
Tip
I used the the container's name, `boring_dijkstra`, but I can also use its ID `885288159d28`

:::
After executing that command, I see a shell prompt appear ( on a blue Monday, maybe even
a  &#128026;[^shell] ) and if I check what processes are running in this
container using <a href="https://en.wikipedia.org/wiki/Ps_(Unix)">`ps`</a>, I indeed
see the `node` app:

~~~
/src # ps
PID   USER     TIME  COMMAND
  1   root     0:00  node ./hi.js
 32   root     0:00  sh
 37   root     0:00  ps
~~~

I also see the shell `sh` running which is the command we executed as part of `docker container
exec -it boring_dijkstra sh` and of course `ps` which is the command we just
ran in that shell.

Let's analyze the command `docker container exec -it boring_dijkstra sh`:

- `docker container`: you're executing docker and it involves containers (in contrast to `image` or `volume`, see later for `volume`)
- `exec`: you're going to execute a command in the container. What command? `sh`.
- `boring_dijkstra`: the container you're executing the command `sh` in
- `-it`: `-t` is short for `--tty` and attaches you to a terminal in the container. `-i` is to make input and output from the container flow to your terminal on your docker host (your laptop). You almost always see `-i` and `-t` used together as `-it`. Try out `-t` on its own in the previous command and try pressing `return`. Nothing happens as the output of the container is not flowing to the output of your laptop terminal. I find it most useful to think of `-it` as _interactive_ mode versus `-d` for _detached_ mode (the container runs but you're not _in it_).
- `sh`: the command you're executing on your container

The documentation on
[exec](https://docs.docker.com/engine/reference/commandline/exec/) as well as
this [stackoverflow
article](https://stackoverflow.com/questions/22272401/what-does-it-mean-to-attach-a-tty-std-in-out-to-dockers-or-lxc)
on interactive mode have more details.

By _jumping into_ the container, I confirmed the app is running. As I wrote
this app, I know that it runs on port `8111`.  Indeed in `hi.js` I wrote:

~~~
app.listen(8111, () => console.log('hi: listening on port 8111'));
~~~

In the `Dockerfile`, I also exposed that port:

~~~
EXPOSE 8111
~~~

In contrast to what the all-caps-look-at-me `EXPOSE` hints at, this does not
make the port `8111` _reachable_. It is _documentation_ for other engineers
reading your `Dockerfile` indicating that your service listens to this port
(`8111`).  To make the port `8111` reachable from outside your container, say
from your laptop, you have to publish it with the `-p` option.

Before using the `-p` option, `stop` and `rm` the running container (which was
not started with `-p`):

~~~bash
docker container stop boring_dijkstra
docker container rm boring_dijkstra
~~~

Then start a container based on the `hi:latest` image but this time map the
Docker host's port `8000` (your laptop) to `8111` port. For
reading-left-to-right oriented cultures, this is roughly from outward to inward
(left to right).

~~~
docker container run -d -p 8000:8111 hi:latest
~~~

After this you can navigate to `localhost:8000` on your browser and see `Hi`.
Note that going to `localhost:8111` in your browser will give an error as
`8111` is exposed in your container, but not your `localhost` (your laptop).

Before diving into persistence, let's look into these `stop` and `rm` commands
we executed before starting a new container.

What's the difference between `stop` and `rm`? If you remove (`rm`) a
container, you can no longer start it or refer to it using its name. Neither
will a `docker container ls -a` show your container.  Anything your application
wrote (for example, to `/tmp`, any logs, anything) is gone. It's gone.

If you `stop` a container, you merely suspend it. After stopping a container,
you can restart it with `docker container start your_container_name`. After
starting it again, whatever you wrote to `/tmp` before stopping it, is still
there. Your app will not be running if the container is stopped. For example, if
you stop your container with `docker container stop your_container_name`,
navigating to `localhost:8000` will give an error.  Restarting the container on
the other hand, brings `localhost:8000` back to life.

# Persistence

Mention _persistence_ in the context of docker or
[kubernetes](https://kubernetes.io/) and everyone gets upset.

What is persistence? Persistence is the _ability for data to stay around_:

- if your app writes data to a database table, your data is persisted in the database even when your app is no longer running
- if you open a text editor write text in a file and save the file, your data is persisted in the file

The database example is usually uncontroversial in the context of containers:
your app can write data to a database table from within the container as
long as the database table exists outside of your container.  More
controversial is writing to the container's file system, for example when your
app writes logs to a file.  The key idea to remember is that if your data is
written to a location (database table, disk location) that has a _lifecyle_
independent of your container, you're good: your data will persist as long as
that location exists.  Your pet rat is not going to die when your container
dies. Their lives are not tied together (unless you keep your pet rat in a
container).

_Volumes_ are the _magic_ that allows docker to write to the file-system in a
persistent manner: the written word will persist long after the container is
gone.

Before I explain volumes, I'd like you to think of what type of persistence to
a file-system we already have without using volumes.  I can have my app that
runs in a container write to `/tmp` without issues while the container is
running. I can even `stop` the container (suspending it, as we saw above) and
when I come back to this container, the data I wrote to `/tmp` is still there.
Only when I `rm` the container, that data in `/tmp` would be gone as `rm` is
wiping away the file-system of the container.

The key to volumes is that they live and die outside of your container's life
cycle. They're an abstraction of storage: I can write to a volume, I can read
from a volume, so the app can write its logs to a volume. If I have these 2
independent entities: a volume that I can write to/read from and a container
that potentially could be doing that writing and reading, how do I connect
those? I'd mount the volume to a directory on the container.  If the
container has a directory `/logs`, I can mount the volume to the directory
`/logs`. After that mounting, anything written to the `/logs` directory will be
written to the volume, everything read from `/logs` will actually be read from
the volume.

This is how to create a volume:

~~~
docker volume create dramatic_vol
~~~

Similar to the above, where we had `docker image` for image manipulation and
`docker container` for container manipulation, we have `docker volume` for
volume manipulation. I can check whether the freshly created volume is indeed there
with `ls`:

~~~
docker volume ls
~~~

I attach `dramatic_vol` to a container (based on the image `hi:latest` as before):

~~~
docker container run -d --mount target=/src,source=dramatic_vol hi:latest
~~~

The name of that container can be found as usual with `ls`:

~~~
$ docker container ls
CONTAINER ID    IMAGE       COMMAND          CREATED          STATUS           PORTS      NAMES
0abd6c82cee2    hi:latest   "node ./hi.js"   54 seconds ago   Up 52 seconds    8111/tcp   laughing_pike
~~~

Inspect that `laughing_pike` container:

~~~
docker container inspect laughing_pike
~~~

The output of that command contains this snippet:

~~~
 "Mounts": [
            {
                "Type": "volume",
                "Name": "dramatic_vol",
                "Source": "/var/lib/docker/volumes/dramatic_vol/_data",
                "Destination": "/src",
                "Driver": "local",
                "Mode": "z",
                "RW": true,
                "Propagation": ""
            }
        ],
~~~

The volume `dramatic_vol` is part of the mounts. It indicates
where the data for that volume actually lives on my laptop
(`/var/lib/docker/volumes/dramatic_vol/_data`) and it indicates to what
directory _in the container_ it is tied: `/src`.  Recall that anything
written to `/src` by my app in the container is written to the volume
(and you could check that out at `/var/lib/docker/volumes/dramatic_vol/_data`).

If you `stop` and `rm` the container, none of the data on the volume is
removed.
It is persistent.

# Conclusion

I showed you how to build an image out of your app (how to _containerize_ it),
how to run a container based on that image, and how to use volumes to persist
the data that your app writes beyond the life cycle of the container.  I
limited this article to what I consider the elements and I left out discussions
on [storage drivers](https://docs.docker.com/storage/storagedriver/select-storage-driver/), [tags](https://docs.docker.com/engine/reference/commandline/tag/), [docker swarm](https://docs.docker.com/engine/swarm/), [docker networking](https://docs.docker.com/network/), [`docker-compose`](https://docs.docker.com/compose/), and much, much
more.

# Endnotes

[^packagejson]: A `package.json` file describes your application (for
example, any package dependencies) so that `npm` (which can be used to build
your application) knows _how_ to build it. You can read about it
[here](https://nodejs.org/en/knowledge/getting-started/npm/what-is-the-file-package-json/).

[^laptop]: In this article, I will mostly refer to your _laptop_ but you could be working on a
desktop computer, or be logged in into an EC2 instance.

[^shell]: Of course [not](https://en.wikipedia.org/wiki/Unix_shell), but I admire your outlook on life.


<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-12447521-1"></script>
  window.dataLayer = window.dataLayer || [];

  function gtag() {
    dataLayer.push(arguments);
  }

  gtag('js', new Date());

  gtag('config', 'UA-12447521-1');
</script>


