#!/bin/sh

last_rev () { 
git log | grep "^commit " | head -n1 | cut -d' ' -f2
} 

set -e

mkdir data
cd data
git init
echo "a\n\nb\n\nc\n\nd\n\ne\n" > testfile.txt
git add testfile.txt
git commit -m "branch_one_creation"
git branch -m  one
git branch two
git checkout two
# git commit -m "branch_two_creation" <-- unecessary in Git
git checkout one
perl -pi -e 's/^a/a aa/' testfile.txt
git commit -am "line a changed"
a_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^b/b bbb/' testfile.txt
git commit -am "line b changed"
b_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^c/c cccc/' testfile.txt
git commit -am "line c changed"
c_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^d/d ddddd/' testfile.txt
git commit -am "line d changed"
d_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^e/e eeeeee/' testfile.txt
git commit -am "line e changed"
e_changed_in_br_one=$(last_rev)
git checkout two
git cherry-pick --no-commit $a_changed_in_br_one
git commit -am "line a merged into two"
git cherry-pick --no-commit $e_changed_in_br_one 
git commit -am "line e merged into two"
git cherry-pick --no-commit $c_changed_in_br_one  
git commit -am "line c merged into two"
git cherry-pick --no-commit $d_changed_in_br_one  
git commit -am "line d merged into two"
git cherry-pick --no-commit $b_changed_in_br_one  
git commit -am "line b merged into two"
git merge one --no-commit
git commit -m "remainder (whatever that means) merged into two"
