#!/bin/sh

last_rev () { 
hg log | grep "^changeset: " | head -n1 | cut -d':' -f3
} 

set -e

mkdir data
cd data
hg init
echo "a\n\nb\n\nc\n\nd\n\ne\n" > testfile.txt
hg add testfile.txt
hg commit -m "branch_one_creation"
orig_commit=$(last_rev) 
hg branch one
perl -pi -e 's/^a/a aa/' testfile.txt
hg commit -m "line a changed"
a_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^b/b bbb/' testfile.txt
hg commit -m "line b changed"
b_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^c/c cccc/' testfile.txt
hg commit -m "line c changed"
c_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^d/d ddddd/' testfile.txt
hg commit -m "line d changed"
d_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^e/e eeeeee/' testfile.txt
hg commit -m "line e changed"
e_changed_in_br_one=$(last_rev)
# Create a bramch without all those changes
hg update -r $orig_commit
hg branch two

# would love to have custom commit message for cherry-picks 
# but cannot without interactive editor
hg graft -r $a_changed_in_br_one
hg graft -r $e_changed_in_br_one 
hg graft -r $c_changed_in_br_one  
hg graft -r $d_changed_in_br_one  
hg graft -r $b_changed_in_br_one  

# can have custom comit message for merge (inconsistent 
# with chery picks above)
hg merge one
hg commit -m "remainder (whatever that means) merged into two"
