
start:
	hg serve --daemon --port 28090 --pid-file hgserve.pid

stop:
	kill `cat hgserve.pid`

website:
	rst2html --stylesheet-path=doc/docutils.css README.txt \
		/var/www/goonmill.org/hypy/index.tsw
	rst2html --stylesheet-path=doc/docutils.css doc/examples.txt \
		/var/www/goonmill.org/hypy/examples.tsw
	pydoctor --add-package hypy --project-name="Hypy" \
		--project-url="http://goonmill.org/hypy/" \
		--make-html \
		--html-output=/var/www/goonmill.org/hypy/apidocs
	bash -c 'cd /var/www/goonmill.org/hypy/apidocs; for f in *.html; do mv $$f $${f/\.html/\.tsw}; done'
	cd /var/www/goonmill.org/hypy/apidocs; for f in *.tsw; do \
		sed -r -i 's/href="([.a-zA-Z_-]*?)\.html/href="\1.tsw/g' $$f; done
	cp doc/apidocs.css /var/www/goonmill.org/hypy/apidocs/

tests:
	python -m hypy.test_lib

release: msg = "** Use: make tag=xx.xx.xx release"
release:
	@bash -c '([ -n "$(tag)" ] && true) || (echo $(msg); false)'
	-mkdir -p RELEASE
	$(MAKE) RELEASE/dch-done.txt RELEASE/release-tag-done.txt RELEASE/debuild-done.txt RELEASE/pypi-upload-done.txt

RELEASE/dch-done.txt: msg = "This will update your changelog - type in new release notes and update version $(tag).txt. ^C to cancel"
RELEASE/dch-done.txt:
	@read -p $(msg) x
	-@./commit-popup
	dch -i
	touch $@

RELEASE/release-tag-done.txt: msg = "This will COMMIT hypy/copyright.py and doc/release-notes/$(tag).txt and tag the release, and push changes. ^C to cancel"
RELEASE/release-tag-done.txt: doc/release-notes/$(tag).txt
	@read -p $(msg) x
	python updatecopyright.py $(tag)
	hg add doc/release-notes/$(tag).txt
	hg ci -m "releasing $(tag)" hypy/copyright.py doc/release-notes/$(tag).txt debian/changelog
	@echo '!! This fetch might require a merge resolution.  Cancelling the merge will stop the release, but you probably wanted to anyway.'
	hg fetch
	hg tag $(tag)
	hg push
	touch $@

doc/release-notes/$(tag).txt: msg = "This will update your release notes - type in new release notes and update version $(tag). ^C to cancel"
doc/release-notes/$(tag).txt:
	@read -p $(msg) x
	cp doc/release-notes/template.txt doc/release-notes/$(tag).txt
	vim doc/release-notes/$(tag).txt

# remove old versions of hypy to setup for release compliance testing
define purge-build-system
@read -p "This will REMOVE all system copies of Hypy.  ^C to cancel" x
sudo apt-get remove python-hypy
sudo rm -rf /usr/lib/python*/[hH]ypy
sudo rm -rvf /usr/lib/python*/[hH]ypy.pth
endef

RELEASE/debuild-done.txt: PNAME := python-hypy-"$(tag)"
RELEASE/debuild-done.txt:
	$(purge-build-system)
	-rm -rf RELEASE/$(PNAME) RELEASE/python-hypy*
	hg archive -t files RELEASE/$(PNAME)
	cp -v Makefile RELEASE/
	$(MAKE) -C RELEASE PNAME=$(PNAME) debuild
	touch $@

debuild: msg = "This will build a debian package and then INSTALL it.  ^C to cancel"
debuild:
		@read -p $(msg) x
		tar cvfz $(PNAME).tar.gz $(PNAME)/
		cd $(PNAME) && debuild
		sudo dpkg -i python-hypy*.deb
		$(MAKE) tests
		cd $(PNAME) && debuild -S
		dput launchpad 'python-hypy_'${tag}'~ppa1_source.changes'

RELEASE/pypi-upload-done.txt: msg = "This will UPLOAD your sdist to pypi.  ^C to cancel"
RELEASE/pypi-upload-done.txt:
	$(purge-build-system)
	@read -p $(msg) x
	python setup.py sdist upload
	# change directories so easy_install doesn't pick up the local 'hypy'
	# directory
	cd RELEASE && sudo easy_install hypy
	python -c 'from hypy import __version__ as v; assert v=="'$(tag)'"'
	$(MAKE) tests
	touch $@

clean:
	rm -rf build dist Hypy.egg-info RELEASE _temp_db
