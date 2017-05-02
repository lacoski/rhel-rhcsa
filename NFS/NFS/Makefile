all: check

check: Compile Run_Check

install: Run_NFS

remove: Run_RemoveNFS

Compile:
	chmod +x check_file.sh
	chmod +x NFS.sh
	chmod +x re-NFS.sh
Run_Check:
	./check_file.sh
Run_NFS:
	./NFS.sh
Run_RemoveNFS:
	./re-NFS.sh
