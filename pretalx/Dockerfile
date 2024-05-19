# syntax=docker/dockerfile:1.3-labs

FROM python:3.11-slim

RUN apt update && \
    apt install -y build-essential default-mysql-client nodejs npm \
                   default-libmysqlclient-dev libssl-dev gettext \
		   pkgconf redis-server && \
    apt clean

RUN adduser pretalx --disabled-password --home /var/pretalx

COPY pretalx.cfg /etc/pretalx/pretalx.cfg
RUN chmod 600 /etc/pretalx/pretalx.cfg && \
    chown -R pretalx:pretalx /etc/pretalx

# For use in the "init" container
COPY init.sh init-mysql.sql /root/init/
RUN chmod +x /root/init/init.sh
COPY install-pretalx.sh /var/pretalx/
RUN chmod +x /var/pretalx/install-pretalx.sh
RUN npm install i18next-conv -g

# Periodic tasks
COPY periodic.sh make_nomedia_backup.sh pretalx_dumpdata.py /root/tasks/
RUN chmod +x /root/tasks/*

USER pretalx
WORKDIR /var/pretalx
RUN ./install-pretalx.sh
# Custom settings.py to include Hebrew
COPY settings.py venv/lib/python3.11/site-packages/pretalx/settings.py
RUN venv/bin/python -m pretalx makemessages -l he
RUN venv/bin/python -m pretalx makemessages -l he -d djangojs
# Copy modified translation files
WORKDIR /var/pretalx/venv/lib/python3.11/site-packages/
COPY --chown=pretalx:pretalx ./pretalx-locale-he pretalx/locale/he
COPY --chown=pretalx:pretalx ./calendar.io/he.js pretalx/static/vendored/fullcalendar/
# COPY --chown=pretalx:pretalx ./schedule-editor-node_modules-he pretalx/frontend/schedule-editor/node_modules/he
WORKDIR /var/pretalx
RUN venv/bin/python -m pretalx rebuild


# EXPOSE 8345

USER pretalx
CMD /var/pretalx/venv/bin/gunicorn pretalx.wsgi \
    --name pretalx --workers 5 --max-requests 1200  \
    --max-requests-jitter 50 --log-level=info --bind=0.0.0.0:8345
