
==========
Hypy Intro
==========

Hypy is a fulltext search interface for Python applications.  Use it to index
and search your documents from Python code.

Hypy is based on the estraiernative bindings by Yusuke Yoshida.

The estraiernative bindings are, in turn, based on Hyper Estraier by Mikio
Hirabayashi.


Installation: Ubuntu Users
~~~~~~~~~~~~~~~~~~~~~~~~~~
Hypy is hosted on Launchpad, and has a launchpad PPA.  This is arguably the
easiest way to install the software if you are an Ubuntu user.

Installation
~~~~~~~~~~~~

I. easy_install method
----------------------
With setuptools (Ubuntu: sudo apt-get install python-setuptools), you can
install Hypy without even downloading it first by using "sudo easy_install
hypy".


II. source method
-----------------
You may also build the dependencies from source.  They are:

* hyperestraier runtime (on Ubuntu: sudo apt-get install hyperestraier)
* libestraier headers and object code (on Ubuntu: sudo apt-get install
  libestraier-dev)
* libqdbm headers and object code (on Ubuntu: sudo apt-get install libqdbm-dev)
* Python headers and object code, natch (on Ubuntu: sudo apt-get install
  python-dev)

Then just run "python setup.py build; sudo python setup.py install".
 

Quick Launch
~~~~~~~~~~~~
You can get an instant "oh I get it!" fix by looking inside the "examples"
directory distributed with this software.

- gather.py demonstrates how to index documents into a collection
- search.py demonstrates how to search for documents in an existing collection


Somewhat Less Quick Launch
~~~~~~~~~~~~~~~~~~~~~~~~~~
Unit tests cover 100% of the code in lib.py.  They have docstrings and
comments; look there first if you want to see how to do something obscure,
like attribute comparisons, max and skip searches, etc.


Reference Documentation
~~~~~~~~~~~~~~~~~~~~~~~
`http://goonmill.org/hypy/apidocs/`


Read This! - Unicode
~~~~~~~~~~~~~~~~~~~~
To make the transition to Python 3.0 easier, and because it is a good idea,
Hypy requires Unicode objects in all of its APIs.

WRONG:
>>> d = HDocument(uri='http://pinatas.com/store.html') # byte string!
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/usr/lib/python2.5/site-pacakges/hypy/lib.py", line 291, in __init__
    raise TypeError("Must provide uri as unicode text")
TypeError: Must provide uri as unicode text

RIGHT:
>>> d = HDocument(uri=u'http://pinatas.com/store.html') # unicode :-)
>>> d.addText(u'Ol
>>> d[u'@title'] = u'Pinata Store'  # attributes are also unicode

Because of this change, and some other minor, Python-enhancing differences
between the APIs, I have deliberately renamed all the classes and methods
supported by Hypy, to prevent confusion.  If you know Python and are already
familiar with Hyper Estraier, you should now visit the Hypy reference
documentation to learn the new names of functions.  In general, though,
"est_someclass_foo_bar" takes a byte string in Hyper Estraier, but becomes
"HSomeClass.fooBar" in Hypy and takes Unicode text.


What's not Supported in Hypy vs. Hyper Estraier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Hyper Estraier implements a version of federated search which is supported by
its APIs such as merge, search_meta and eclipse.  If I hear a compelling use case
or receive patches with unit tests, I may add support for these APIs.  This is
not a hard thing to do, I just have no use for it myself, so I am reluctant to
promise to maintain it unless someone else really needs it.


Contributing and Reporting Bugs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Hypy's bug tracker on Launchpad is: `https://bugs.launchpad.net/hypy`

For more information on contributing, including the URL of the source
repository for Hypy, go to: `http://wiki.goonmill.org/DevelopmentCentral`

It bears emphasizing that BUGS WITH REPRODUCIBLE STEPS, PATCHES AND UNIT TESTS
(in that order) GET FIXED SOONER.


License
~~~~~~~
LGPL 2.1

Hypy (c) Cory Dodt, 2008.
estraiernative (c) Yusuke Yoshida.
