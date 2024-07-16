FROM python:3.12.1-alpine as builder

ENV TZ Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

RUN apk add --no-cache --update musl musl-utils musl-locales tzdata
RUN echo 'export LC_ALL=ru_RU.UTF-8' >> /etc/profile.d/locale.sh && \
  sed -i 's|LANG=C.UTF-8|LANG=ru_RU.UTF-8|' /etc/profile.d/locale.sh

ENV LANGUAGE=ru_RU.UTF-8 LANG=ru_RU.UTF-8 LC_ALL=ru_RU.UTF-8

# RUN apk add --no-cache --update gcc musl-dev postgresql-dev

# Docker API Access issue handling
ARG DOCKER_GID=121
# RUN groupadd -g ${DOCKER_GID} docker
RUN addgroup -g ${DOCKER_GID} docker
# Default group
# RUN groupadd -g 1000 web \
#  && useradd -m --no-log-init -r -g 1000 -u 1000 web \
#  && usermod -aG docker web
RUN adduser -D web
RUN addgroup web docker

USER web

ENV HOME=/home/web
ENV APP_HOME=$HOME/app
ENV PYTHONUSERBASE=$HOME/packages VIRTUAL_ENV=$HOME/.venv
ENV PATH=$PYTHONUSERBASE/bin:$VIRTUAL_ENV/bin:$PATH
RUN mkdir /home/web/app
WORKDIR $APP_HOME

RUN pip completion --bash >> /home/web/.bashrc \
 && python3 -m venv $VIRTUAL_ENV \
 && pip install --user poetry==1.7.1

COPY --chown=web:web pyproject.toml poetry.lock ./
RUN poetry install

RUN mkdir -p /home/web/stash && cp ./poetry.lock /home/web/stash/poetry.lock
COPY --chown=web:web . ./
RUN cp /home/web/stash/*.* ./

# =================================================================================================
# COPY FROM BUILDER TO RUNTIME
# -------------------------------------------------------------------------------------------------
FROM python:3.12.1-alpine as runtime

ENV TZ Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timpoetry package supportpoetry package supportezone

# RUN echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen \
#  && locale-gen
RUN apk add --no-cache --update musl musl-utils musl-locales tzdata
RUN echo 'export LC_ALL=ru_RU.UTF-8' >> /etc/profile.d/locale.sh && \
  sed -i 's|LANG=C.UTF-8|LANG=ru_RU.UTF-8|' /etc/profile.d/locale.sh

ENV LANGUAGE=ru_RU.UTF-8 LANG=ru_RU.UTF-8 LC_ALL=ru_RU.UTF-8

# Dependencies
RUN apk add --no-cache --update postgresql15-client bash curl pgbouncer

RUN adduser -D web
RUN addgroup web

USER web

ENV HOME=/home/web
ENV APP_HOME=$HOME/app
ENV PYTHONUSERBASE=$HOME/packages VIRTUAL_ENV=$HOME/.venv
ENV PATH=$PYTHONUSERBASE/bin:$VIRTUAL_ENV/bin:$PATH
RUN mkdir /home/web/app
WORKDIR $APP_HOME

COPY --chown=web:web --from=builder /home/web/app /home/web/app
COPY --chown=web:web --from=builder /home/web/.venv /home/web/.venv
