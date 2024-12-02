all: vcs  verdi
#---------------------------------------------------------------
filelist:
	find ../ -name "*.v" -o -name "*.sv" > ./filelist.f

vcs:
	vcs -R -full64 +v2k -fsdb +define+FSDB -sverilog -f filelist.f -l run.log

#---------------------------------------------------------------

verdi:
	verdi -sv -f filelist.f -ssf tb.fsdb  &
#---------------------------------------------------------------
clean:
	rm -rf csrc DVEfiles novas* *.log simv* *fsdb* ucli.key *.vpd verdiLog