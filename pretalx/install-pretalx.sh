#!/bin/bash

python -m venv /var/pretalx/venv
source /var/pretalx/venv/bin/activate
pip install -U pip setuptools wheel gunicorn

# !!!!! NOTE: We patch settings.py for Hebrew, version-specifc !!!!!
pip install --upgrade-strategy eager -U "pretalx[mysql, redis]==2024.1.0"

