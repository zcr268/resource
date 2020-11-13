FROM node:12

ENV NODE_ENV production
ENV TZ Asia/Shanghai

EXPOSE 8888

ENV WORKDIR /app

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["$WORKDIR", "npm", "start"]