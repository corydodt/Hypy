#
from inspect import cleandoc

from setuptools import setup, Extension


__version__ = '1.0.0'


ext = Extension("_estraiernative",
                ["estraiernative.c"],
                libraries=["estraier"],
                include_dirs=["/usr/include/estraier", "/usr/include/qdbm"],
                )

setup(
    name="Hypy",
    description='Pythonic wrapper for Hyper Estraier',
    author='Yusuke YOSHIDA',
    author_email='usk@nrgate.jp',
    maintainer='Cory Dodt',
    maintainer_email='pypi@spam.goonmill.org',
    url='https://github.com/corydodt/Hypy',
    download_url='https://github.com/corydodt/Hypy/archive/release-%s.tar.gz' % __version__,
    version=__version__,
    ext_modules=[ext],
    zip_safe=False,
    packages=['src/hypy'],

    classifiers=[
      'Development Status :: 4 - Beta',
      'Environment :: Console',
      'Environment :: Web Environment',
      'Intended Audience :: Developers',
      'License :: OSI Approved :: GNU Library or Lesser General Public License (LGPL)',
      'Operating System :: POSIX',
      'Programming Language :: Python',
      'Topic :: Software Development :: Libraries',
      'Topic :: Internet :: WWW/HTTP :: Indexing/Search',
      ],
    extras_require={
        'dev': [
            'pytest>=3.0.2',
            'pytest-cov>=2.5.1',
            'pytest-flakes>=2.0.0',
            'tox',
            'twine',
        ],
    },
    install_requires=['six']
)
