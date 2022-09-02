#!/bin/bash
#
#	pull_all
#	Perry Kivolowitz
#	Carthage College Computer Science
#	Placed in public domain.
#

function Process() {
	#echo Process called with $@
	local d
	for d in $@
	do
		if [ -d ${d} ]; then
			if [ ${d:0:1} == "_" ]; then
				# To prevent descending into a directory, prepend its name with an underscore.
				continue
			fi
			if [ -e ${d}/.git ]; then
				pushd $d > /dev/null 2>&1
				echo $d
				if git pull | tee /tmp/git.out | grep -q 'Already up to date.'
				then
					:
				else
					cat /tmp/git.out
				fi
				popd > /dev/null 2>&1
			else
				echo ">>>>> Descending into:" ${d}
				pushd ${d} > /dev/null 2>&1
				Process *
				echo "<<<<< Rising from:" ${d}
				popd  > /dev/null 2>&1
			fi
		fi
	done
}

me=`pwd`/`basename $0`
folder='*'
if [ $# -eq 1 ]
then
	folder=$1/*
fi


Process ${folder}

rm -f /tmp/git.out
