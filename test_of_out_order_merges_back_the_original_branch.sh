#!/bin/sh

last_rev () { 
git log | grep "^commit " | head -n1 | cut -d' ' -f2
} 

./test_of_out_order_merges_from_one_branch_to_another.sh > /dev/null

cd data
git checkout two
perl -pi -e 's/^a/a !!/' testfile.txt
git commit -am "line a changed again"
a_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^b/b !!/' testfile.txt
git commit -am "line b changed again"
b_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^c/c !!/' testfile.txt
git commit -am "line c changed again"
c_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^d/d !!/' testfile.txt
git commit -am "line d changed again"
d_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^e/e !!/' testfile.txt
git commit -am "line e changed again"
e_changed_in_br_two=$(last_rev)
git checkout one
git cherry-pick --no-commit $a_changed_in_br_two 
git commit -m "line a merged into one"
git cherry-pick --no-commit $e_changed_in_br_two 
git commit -m "line e merged into one"
git cherry-pick --no-commit $c_changed_in_br_two 
git commit -m "line c merged into one"
git cherry-pick --no-commit $d_changed_in_br_two 
git commit -m "line d merged into one"
git cherry-pick --no-commit $b_changed_in_br_two 
git commit -m "line b merged into one"
echo "Contents of testfile.txt on branch 'one':"
more testfile.txt
git checkout two
echo "Contents of testfile.txt on branch 'two' (they are the same, as a result of merges):"
more testfile.txt
git checkout one
echo "Attempt redundant merge of branch two into branch one (individual commits are merged already, and files at HEAD revision are idential):"
git merge two  --no-commit
git commit -m "remainder (whatever that means) merged into one"
