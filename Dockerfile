#syntax=docker/dockerfile:1.2

FROM akorn/luarocks:lua5.4-alpine AS builder

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	dumb-init gcc libc-dev

COPY ./ /src
WORKDIR /src

RUN luarocks --tree /pkgdir/usr/local make
RUN find /pkgdir -type f -exec sed -i -e 's!/pkgdir!!g' {} \;

FROM akorn/luarocks:lua5.4-alpine  AS final

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	dumb-init

LABEL org.opencontainers.image.title="LuaBehave"
LABEL org.opencontainers.image.description="BDD (Behavior-Driven Development) testing framework"
LABEL org.opencontainers.image.authors="Slava Zanko <slavazanko@gmail.com>"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://github.com/slavaz/luabehave/pkgs/container/luabehave"
LABEL org.opencontainers.image.source="https://github.com/slavaz/luabehave"

COPY --from=builder /pkgdir /
RUN luabehave --help

WORKDIR /data

ENTRYPOINT ["luabehave"]
