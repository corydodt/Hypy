# Hypy

Hypy is a fulltext search interface for Python applications.  Use it to index
and search your documents from Python code.

Hypy is based on the estraiernative bindings by Yusuke Yoshida.

The estraiernative bindings are, in turn, based on Hyper Estraier by Mikio
Hirabayashi.

## README

### Installation: Non-Ubuntu

You will need to (a) install Hyper Estraier, then (b) install Hypy.

#### Installing Hyper Estraier from Source

Instructions for building and [installing Hyper Estraier](http://hyperestraier.sourceforge.net/intro-en.html#installation) can be found on
that site.  It is a standard configure/make/make install process, but you must
make sure to download all the required files.  See the Hyper Estraier
installation page for details.


#### Then: Install Hypy with pip

```
pip install hypy
```

### Quick Start

You can get an instant "oh I get it!" fix by looking inside the "examples"
directory distributed with this software.

Index documents into a collection (see [gather.py](https://github.com/corydodt/Hypy/blob/master/examples/gather.py) for the complete program):

```
...
db = HDatabase()
db.open('casket', 'w')
# create a document object
doc = HDocument(uri=u'http://estraier.gov/example.txt')
...
```

Search for documents in an existing collection (see [search.py](https://github.com/corydodt/Hypy/blob/master/examples/search.py) for the
complete program):

```
...
# create a search condition object
cond = HCondition(u'lull*')
# get the result of search
result = db.search(cond)
# iterate the result
for doc in result:
...
```


### Hey, I need Even More Examples

OK.

Here are [even more examples](https://github.com/corydodt/Hypy/blob/master/doc/examples.md).


### Read This! - Unicode

Hypy requires Unicode objects in all of its APIs.

*WRONG*
```

  >>> d = HDocument(uri='http://pinatas.com/store.html') # byte string!
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    File "/usr/lib/python2.5/site-pacakges/hypy/lib.py", line 291, in __init__
      raise TypeError("Must provide uri as unicode text")
  TypeError: Must provide uri as unicode text
```

*RIGHT*
```

  >>> d = HDocument(uri=u'http://pinatas.com/store.html') # unicode :-)
  >>> d.addText(u'Olé')
  >>> d[u'@title'] = u'Piñata Store'  # attributes are also unicode
```

Because of this change, and some other minor, Python-enhancing differences
between the APIs, I have deliberately renamed all the classes and methods
supported by Hypy, to prevent confusion.  If you know Python and are already
familiar with Hyper Estraier, you should now visit the [API docs](api/) to learn
the new names of functions.  In general, though, "est_someclass_foo_bar" takes
a byte string in Hyper Estraier, but becomes "HSomeClass.fooBar" in Hypy and
takes Unicode text.

### What's not Supported in Hypy vs. Hyper Estraier

Hyper Estraier implements a version of federated search which is supported by
its APIs such as merge, search_meta and eclipse.  If I hear a compelling use case
or receive patches with unit tests, I may add support for these APIs.  This is
not a hard thing to do, I just have no use for it myself, so I am reluctant to
promise to maintain it unless someone else really needs it.


### License

LGPL 2.1

Hypy (c) Cory Dodt, 2018.

estraiernative (c) Yusuke Yoshida.
