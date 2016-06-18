#!/bin/sh

last_rev () {
fossil finfo testfile.txt | grep "branch:" | head -n1 | cut -d' ' -f2 | cut -d'[' -f2 | cut -d']' -f1
}

set -e

mkdir data
cd data
fossil init .fossilDB
fossil open .fossilDB
fossil branch new one trunk
fossil checkout one
echo "a\\n\\nb\\n\\nc\\n\\nd\\n\\ne\\n" > testfile.txt
fossil add testfile.txt
fossil commit -m "branch_one_creation"
fossil branch new two one
fossil checkout two
fossil commit --allow-empty -m "branch_two_creation"
fossil checkout one
perl -pi -e 's/^a/a aa/' testfile.txt
fossil commit -m "line a changed"
a_changed_in_br_one=$(last_rev)
perl -pi -e 's/^b/b bbb/' testfile.txt
fossil commit -m "line b changed"
b_changed_in_br_one=$(last_rev)
perl -pi -e 's/^c/c cccc/' testfile.txt
fossil commit -m "line c changed"
c_changed_in_br_one=$(last_rev)
perl -pi -e 's/^d/d ddddd/' testfile.txt
fossil commit -m "line d changed"
d_changed_in_br_one=$(last_rev)
perl -pi -e 's/^e/e eeeeee/' testfile.txt
fossil commit -m "line e changed"
e_changed_in_br_one=$(last_rev)
fossil checkout two
fossil merge --cherrypick $a_changed_in_br_one
fossil commit -m "line a merged into two"
fossil merge --cherrypick $e_changed_in_br_one
fossil commit -m "line e merged into two"
fossil merge --cherrypick $c_changed_in_br_one
fossil commit -m "line c merged into two"
fossil merge --cherrypick $d_changed_in_br_one
fossil commit -m "line d merged into two"
fossil merge --cherrypick $b_changed_in_br_one
fossil commit -m "line b merged into two"
fossil merge one
fossil commit -m "remainder (whatever that means) merged into two"
