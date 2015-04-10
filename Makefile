MOCHA=./node_modules/.bin/mocha
BOX=test/testnet-box
B1_FLAGS=
B2_FLAGS=
B1=-datadir=$(BOX)/1 $(B1_FLAGS)
B2=-datadir=$(BOX)/2 $(B2_FLAGS)
CLAM_VERSION=1.4.10
CLAMD=clam-$(CLAM_VERSION)/bin/clamd
CLAMD=/Users/daxxog/dev/git/clams/src/clamd

test:
	#$(MAKE) download-clam
	$(MAKE) rename-conf
	#$(MAKE) test-ssl-no
	$(MAKE) sandbox
	#sleep 20
	#$(MAKE) clean
	#$(MAKE) test-ssl

sandbox:
	#$(MAKE) start
	#sleep 20
	node sandbox
	$(MAKE) run-test
	#$(MAKE) stop

rename-conf:
	mv $(BOX)/1/*.conf $(BOX)/1/clam.conf
	mv $(BOX)/2/*.conf $(BOX)/2/clam.conf

download-clam:
	curl http://khashier.com/static/releases/clam-$(CLAM_VERSION)-linux64.tar.gz | tar xz

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
	$(MAKE) start B1_FLAGS=-rpcssl=1 B2_FLAGS=-rpcssl=1
	
stop:
	killall clamd
	sleep 20

stop-ssl:
	$(MAKE) stop
	
run-test:
	$(MOCHA) --invert --grep SSL

run-test-ssl:
	$(MOCHA) --grep SSL
	
clean:
	rm -f $(BOX)/*/peers.dat
	rm -f $(BOX)/*/regtest/clamspeech.txt
	rm -f $(BOX)/*/regtest/*.dat
	rm -f $(BOX)/*/regtest/*.log
	rm -rf $(BOX)/*/regtest/txleveldb
	rm -rf $(BOX)/*/regtest/database

.PHONY: test
