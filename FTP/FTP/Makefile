all: check

check: Compile Run_Check

install: Run_FTP

remove: Run_RemoveFTP

Compile:
	chmod +x check_file.sh
	chmod +x FTP.sh
	chmod +x re-FTP.sh
Run_Check:
	./check_file.sh
Run_FTP:
	./FTP.sh
Run_RemoveFTP:
	./re-FTP.sh
