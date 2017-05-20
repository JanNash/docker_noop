#### What

Using this dockerfile, you can build an image that is only 909 kB big:  
```jannnash/noop          0.1.0               044121226051        19 seconds ago      909 kB```

The image is so small because it's a base image built from scratch (that pun is to be blamed on the docker-folks :D), which includes the statically (that's why it's 'so big') compiled version of [noop.c](https://github.com/JanNash/docker-noop/blob/master/noop.c). 

#### Why

Running a container built from this image does obviously not make any sense, so what do you use it for? Now, docker-compose version 3 does not yet support a functionality similar to (or at least similarly simple as) the ```extends```-functionality that could be used in version 2 to get rid of repeated configuration in your compose-file.

I hacked this together because I wanted to share environment variables between some services in the docker-compose file I'm using for a small project. Having to update the same path at 4 different places simply is a pain, so I searched for a way to deduplicate configurations.

On a MacBook Air Early 2015 with a 2.2 i7 and 8G RAM (everything timed once with 'time'),
- building the image takes only quarter of a second
- creating a container from the image takes around .9 of a second
- running the container takes around 2 seconds

The image has a size of 909 kB and a container created from the image has no extra size overhead to the image.

In conclusion, the workaround does not really create any overhead for your docker-compose setup apart from creating some extra containers, which clutter the output of ```docker ps -a```. 

#### How

If anyone wants to elaborate on anchors and references in .yml, feel free to send me a PR with an extended version of this README. Personally, I think, it's fairly simple, so I will let this sample docker-compose configuration speak for itself:

TODO: Add examples for simple string anchors

```
version: '3'


services:
  common-env:
    build:
      context: ./noop
    image: noop
    container_name: common-env
    environment: &foo
      FOO_CONTAINER: foo
    environment: &foo_env
      FOO_CONTAINER_BAZ: baz
    environment: &bar
      BAR_CONTAINER: bar
    environment: &bar_env
      BAR_CONTAINER_BOING: boing

  foo: 
    container_name: foo
    image: debian:jessie-slim
    environment: 
      <<: *foo_env

  bar: 
    container_name: bar
    image: debian:jessie-slim
    environment:
      <<: *bar_env

  klonk:
    image: debian:jessie-slim
    environment:
      <<: *foo
      <<: *bar
      <<: *foo_env
      <<: *bar_env
```
