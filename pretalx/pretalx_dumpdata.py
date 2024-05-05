#!/var/pretalx/venv/bin/python

import os
import sys

import django
from django.core import management
from django_scopes import scopes_disabled

if __name__ == "__main__":
    # Prevent printing of the pretalx config banner
    # This cmdline arg is read by the pretalx settings module,
    # so it needs to be added before loading Django
    sys.argv.append("--no-pretalx-information")
    # Load Django
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "pretalx.settings")
    django.setup()
    print("Setup done", file=sys.stderr)
    # Dump data
    with scopes_disabled():
        management.call_command('dumpdata', '--all')

    #create_fixture('--all', "/tmp/c")

