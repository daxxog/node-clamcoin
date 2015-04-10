MOCHA=./node_modules/.bin/mocha
BOX=test/testnet-box
B1_FLAGS=
B2_FLAGS=
B1=-datadir=$(BOX)/1 $(B1_FLAGS)
B2=-datadir=$(BOX)/2 $(B2_FLAGS)
CLAM_VERSION=1.4.10
CLAMD=clam-$(CLAM_VERSION)/bin/clamd

download-clam:
	curl http://khashier.com/static/releases/clam-$(CLAM_VERSION)-linux64.tar.gz | tar xz

test:
	$(MAKE) download-clam
	$(MAKE) test-ssl-no
	#sleep 20
	#$(MAKE) clean
	#$(MAKE) test-ssl

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
	$(CLAMD) $(B1) &
	$(CLAMD) $(B2) &

start-ssl:
	$(MAKE) start B1_FLAGS=-rpcssl=1 B2_FLAGS=-rpcssl=1
	
stop:
	killall clamd

stop-ssl:
	$(MAKE) stop
	
run-test:
	$(MOCHA) --invert --grep SSL

run-test-ssl:
	$(MOCHA) --grep SSL
	
clean:
	$(MAKE) -C $(BOX) clean

.PHONY: test
