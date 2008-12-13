
DNOTIFY=dnotify -q1 -a

start:
	hg serve --daemon --port 28090 --pid-file hgserve.pid

stop:
	kill `cat hgserve.pid`
