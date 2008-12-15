
start:
	hg serve --daemon --port 28090 --pid-file hgserve.pid

stop:
	kill `cat hgserve.pid`

website:
	rst2html --stylesheet-path=doc/docutils.css README.txt \
		/var/www/goonmill.org/hypy/index.tsw
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

buildable: VERSION := $(shell hg tags | head -2 | grep -v tip | cut -d\  -f1 || echo '')
buildable: PNAME := python-hypy-"$(VERSION)"
buildable:
	cd ..; cp -a Hypy $(PNAME); \
			cd $(PNAME)/; hg purge --all; rm -rf .hg; \
			cd ..; tar cvfz $(PNAME).tar.gz $(PNAME)/
