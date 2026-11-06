overall=0

for n in 1 2 3 4; do
    src="Testcase$n"
    out="Testcase${n}Diff"
    ok=1
    any_diff=0

    if [ -d "$src" ]; then
        for f1 in "$src"/*.1.txt; do
            [ -f "$f1" ] || continue
            a=$(basename "$f1")
            base="${a%.1.txt}"
            b="$base.2.txt"
            [ -f "$src/$b" ] || continue
            outfile="$out/${base}Diff.txt"

            (cd "$src" && diff -u "$a" "$b" > /dev/null 2>&1)
            status=$?

            if [ $status -eq 1 ]; then
                any_diff=1
                if [ ! -f "$outfile" ]; then
                    echo "missing $outfile" >&2
                    ok=0
                elif ! (cd "$src" && diff -u "$a" "$b") | cmp -s - "$outfile"; then
                    echo "wrong contents in $outfile" >&2
                    ok=0
                fi
            elif [ $status -eq 0 ]; then
                if [ -e "$outfile" ]; then
                    echo "unexpected $outfile (pair is identical)" >&2
                    ok=0
                fi
            else
                echo "diff failed for $src/$a $src/$b" >&2
                ok=0
            fi
        done
    fi

    if [ $any_diff -eq 1 ] && [ ! -d "$out" ]; then
        echo "missing directory $out" >&2
        ok=0
    elif [ $any_diff -eq 0 ] && [ -e "$out" ]; then
        echo "$out should not exist (no differences)" >&2
        ok=0
    fi

    if [ $ok -eq 1 ]; then
        echo "Testcase$n: PASS"
    else
        echo "Testcase$n: FAIL"
        overall=1
    fi
done

exit $overall
