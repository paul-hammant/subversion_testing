#!/bin/sh

last_rev () { 
hg log | grep "^changeset: " | head -n1 | cut -d':' -f3
} 

./test_of_out_order_merges_from_one_branch_to_another.sh > /dev/null

cd data
hg update two
perl -pi -e 's/^a/a !!/' testfile.txt
hg commit -m "line a changed again"
a_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^b/b !!/' testfile.txt
hg commit -m "line b changed again"
b_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^c/c !!/' testfile.txt
hg commit -m "line c changed again"
c_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^d/d !!/' testfile.txt
hg commit -m "line d changed again"
d_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^e/e !!/' testfile.txt
hg commit -m "line e changed again"
e_changed_in_br_two=$(last_rev)
hg update one

hg graft $a_changed_in_br_two 
hg graft $e_changed_in_br_two 
hg graft $c_changed_in_br_two 
hg graft $d_changed_in_br_two 
hg graft $b_changed_in_br_two 
echo "Contents of testfile.txt on branch 'one':"
more testfile.txt
hg update two
echo "Contents of testfile.txt on branch 'two' (they are the same, as a result of merges):"
more testfile.txt
hg update one
echo "Attempt redundant merge of branch two into branch one (individual commits are merged already, and files at HEAD revision are idential):"
hg merge two 
hg commit -m "remainder (whatever that means) merged into one"
