all: check

check: Compile Run_Check

install: Run_DNS

remove: Run_RemoveDNS

Compile:
	chmod +x check_file.sh
	chmod +x DNS.sh
	chmod +x re-DNS.sh
Run_Check:
	./check_file.sh
Run_DNS:
	./DNS.sh
Run_RemoveDNS:
	./re-DNS.sh
