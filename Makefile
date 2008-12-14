
DNOTIFY=dnotify -q1 -a

start:
	hg serve --daemon --port 28090 --pid-file hgserve.pid

stop:
	kill `cat hgserve.pid`

website:
	rst2html README.txt /var/www/goonmill.org/hypy/index.tsw
	pydoctor --add-package hypy --project-name="Hypy" \
		--project-url="http://goonmill.org/hypy/" \
		--make-html \
		--html-output=/var/www/goonmill.org/hypy/apidocs
	bash -c 'cd /var/www/goonmill.org/hypy/apidocs; for f in *.html; do mv $$f $${f/\.html/\.tsw}; done'
	cd /var/www/goonmill.org/hypy/apidocs; for f in *.tsw; do \
		sed -r -i 's/href="([.a-zA-Z_-]*?)\.html/href="\1.tsw/g' $$f; done
	cp apidocs.css /var/www/goonmill.org/hypy/apidocs/
