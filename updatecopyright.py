"""
Overwrite copyright.py when doing a release
"""
import sys
from string import Template
import datetime
import os.path
from mercurial import ui, hg, commands

def run(argv=None):
    if argv is None:
        argv = sys.argv[:]

    ver = argv[1]

    releaseDate = datetime.date.today().isoformat()

    d = os.path.abspath(os.path.dirname(__file__))
    hgui = ui.ui(quiet=True)
    hgui.pushbuffer()
    hgrepo = hg.repository(ui=hgui, path=d)
    commands.identify(hgui, hgrepo)
    rev = hgui.popbuffer().strip()

    module = Template('''"""
Hypy is copyright (c) 2009 Cory Dodt.

GENERATED FILE -- DO NOT EDIT
"""
from datetime import date

author = "Cory Dodt"
releaseDate = "$releaseDate"
releaseRevision = "$rev"
__version__ = "$ver"
''')
    f = open(d + '/hypy/copyright.py', 'w')
    f.write(
            module.substitute(releaseDate=releaseDate,
                rev=rev,
                ver=ver,
                ))
    return 0

if __name__ == '__main__':
    sys.exit(run())
