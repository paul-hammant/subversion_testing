#!/bin/sh

last_rev () {
fossil finfo testfile.txt | grep "branch:" | head -n1 | cut -d' ' -f2 | cut -d'[' -f2 | cut -d']' -f1
}

./test_of_out_order_merges_from_one_branch_to_another.sh > /dev/null

set -e

cd data
fossil checkout two
perl -pi -e 's/^a/a !!/' testfile.txt
fossil commit -m "line a changed again"
a_changed_in_br_two=$(last_rev)
perl -pi -e 's/^b/b !!/' testfile.txt
fossil commit -m "line b changed again"
b_changed_in_br_two=$(last_rev)
perl -pi -e 's/^c/c !!/' testfile.txt
fossil commit -m "line c changed again"
c_changed_in_br_two=$(last_rev)
perl -pi -e 's/^d/d !!/' testfile.txt
fossil commit -m "line d changed again"
d_changed_in_br_two=$(last_rev)
perl -pi -e 's/^e/e !!/' testfile.txt
fossil commit -m "line e changed again"
e_changed_in_br_two=$(last_rev)
fossil checkout one
fossil merge --cherrypick $a_changed_in_br_two
fossil commit -m "line a merged into one"
fossil merge --cherrypick $e_changed_in_br_two
fossil commit -m "line e merged into one"
fossil merge --cherrypick $c_changed_in_br_two
fossil commit -m "line c merged into one"
fossil merge --cherrypick $d_changed_in_br_two
fossil commit -m "line d merged into one"
fossil merge --cherrypick $b_changed_in_br_two
fossil commit -m "line b merged into one"
echo "Contents of testfile.txt on branch 'one':"
more testfile.txt
fossil checkout two
echo "Contents of testfile.txt on branch 'two' (they are the same, as a result of merges):"
more testfile.txt
fossil checkout one
echo "Attempt redundant merge of branch two into branch one (individual commits are merged already, and files at HEAD revision are idential):"
fossil merge two
fossil commit -m "remainder (whatever that means) merged into one"
