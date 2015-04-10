MOCHA=./node_modules/.bin/mocha
BOX=test/testnet-box
B1_FLAGS=
B2_FLAGS=
B1=-datadir=$(BOX)/1 $(B1_FLAGS)
B2=-datadir=$(BOX)/2 $(B2_FLAGS)
CLAMD=clam-1.4.10/bin/clamd

test:
	$(MAKE) download-clam
	ls clam-1.4.10/bin
	$(MAKE) start
	$(MAKE) stop

download-clam:
	curl http://khashier.com/static/releases/clam-1.4.10-linux64.tar.gz | tar xz

test-ssl-no:
	$(MAKE) start
	sleep 20
	$(MAKE) run-test
	$(MAKE) stop

test-ssl:
	$(MAKE) start-ssl
	sleep 20
	$(MAKE) run-test-ssl
	$(MAKE) stop-ssl
	
start:
	$(CLAMD) $(B1) -daemon
	$(CLAMD) $(B2) -daemon

start-ssl:
	$(MAKE) -C $(BOX) start B1_FLAGS=-rpcssl=1 B2_FLAGS=-rpcssl=1
	
stop:
	$(CLAMD) $(B1) -stop
	$(CLAMD) $(B2) -stop
	@while ps -C clamd > /dev/null; do sleep 1; done

stop-ssl:
	$(MAKE) -C $(BOX) stop B1_FLAGS=-rpcssl=1 B2_FLAGS=-rpcssl=1
	
run-test:
	$(MOCHA) --invert --grep SSL

run-test-ssl:
	$(MOCHA) --grep SSL
	
clean:
	$(MAKE) -C $(BOX) clean

.PHONY: test
