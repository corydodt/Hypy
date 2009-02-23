
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

release:
	bash -c '([ -n "$(tag)" ] && true) || (echo "** Use: make tag=xx.xx.xx release"; false)'
	$(MAKE) changelog release-tag purge-build-system debuild-setup purge-build-system pypi-upload

changelog: msg = "This will update your changelog - type in new release notes and update version $(tag).txt. ^C to cancel"
changelog:
	@read -p $(msg) x
	dch -i

release-tag: "This will COMMIT doc/release-notes/$(tag).txt and tag the release, and push changes. ^C to cancel"
release-tag: release-notes
	@read $(msg) x
	hg add doc/release-notes/$(tag).txt
	hg ci -m "releasing $(tag)" doc/release-notes/$(tag).txt debian/changelog
	@echo '!! This fetch might require a merge resolution.  Cancelling the merge will stop the release, but you probably wanted to anyway.'
	hg fetch
	hg tag $(tag)
	hg push

release-notes: msg = "This will update your release notes - type in new release notes and update version $(tag). ^C to cancel"
release-notes:
	@read $(msg) x
	cp doc/release-notes/template.txt doc/release-notes/$(tag).txt
	vim doc/release-notes/$(tag).txt

# remove old versions of hypy to setup for release compliance testing
purge-build-system: msg = "This will REMOVE all system copies of Hypy.  ^C to cancel"
purge-build-system:
	@read $(msg) x
	sudo apt-get remove python-hypy
	sudo rm -rf /usr/lib/python*/[hH]ypy
	sudo rm -rvf /usr/lib/python*/[hH]ypy.pth

debuild-setup: PNAME := python-hypy-"$(tag)"
debuild-setup:
	hg archive -t files RELEASE/$(PNAME)
	cp -v Makefile RELEASE/
	$(MAKE) -C RELEASE debuild

debuild: msg = "This will build a debian package and then INSTALL it.  ^C to cancel"
debuild:
		@read $(msg) x
		tar cvfz $(PNAME).tar.gz $(PNAME)/
		cd $(PNAME) && debuild
		sudo dpkg -i python-hypy*.deb
		$(MAKE) tests
		cd $(PNAME) debuild -S
		dput launchpad 'python-hypy_'${tag}'~ppa1_source.changes'

pypi-upload: msg = "This will UPLOAD your sdist to pypi.  ^C to cancel"
pypi-upload:
	@read $(msg) x
	python setup.py sdist upload
	sudo easy_install hypy
	$(MAKE) tests

clean:
	rm -rf build dist Hypy.egg-info RELEASE
