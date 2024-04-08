FROM alpine:latest AS build1
COPY alpine-minirootfs-3.19.1-x86_64.tar /
RUN mkdir -p /rootfs && tar -xf /alpine-minirootfs-3.19.1-x86_64.tar -C /rootfs

FROM scratch AS node_build
COPY --from=build1 /rootfs /

WORKDIR /app
COPY index.js .
COPY package.json .
ARG VERSION
ENV APP_VER=production.${VERSION:-v1.0}
RUN apk add --no-cache nodejs npm

ENV PORT=3000

CMD ["node", "index.js"]

FROM nginx:latest
COPY --from=node_build /app /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:80/healthcheck || exit 1

EXPOSE 80
