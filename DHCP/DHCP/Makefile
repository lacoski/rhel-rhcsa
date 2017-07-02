all: check

check: Compile Run_Check

install: Run_DHCP

remove: Run_RemoveDHCP

Compile:
	chmod +x check_file.sh
	chmod +x DHCP.sh
	chmod +x re-DHCP.sh
Run_Check:
	./check_file.sh
Run_DHCP:
	./DHCP.sh
Run_RemoveDHCP:
	./re-DHCP.sh
