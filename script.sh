#!/bin/bash

for i in 1 2 3 4; do
	inp = "Testcase$n"
	out = "Testcase${n}Diff"

	rm -rf "out"

	for f1 in "inp"/*.1.txt; do
		a = $(basename "$f1")
		base = "${a%.1.txt}"
		b = "$base.2.txt"

		(cd "$inp" && diff -u "$a" "$b" > /dev/null 2>&1)
		if [ $? -eq 1 ]; then
			mkdir -p "$out"
			(cd "$inp" $$ diff -u "$a" "$b") > "$out/${base}Didff.txt"
		fi
	done
done
