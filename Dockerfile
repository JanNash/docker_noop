# VERSION 0.1.0

FROM scratch
MAINTAINER Jan Nash <jnash@jnash.de>

ADD ./noop /
CMD ["/noop"]
