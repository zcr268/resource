FROM node:12

ENV NODE_ENV production
ENV TZ Asia/Shanghai

EXPOSE 8888

ENV WORKDIR /app

COPY docker/pz-map/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/app", "npm", "start"]
