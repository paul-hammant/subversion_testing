#!/bin/sh

last_rev () { 
/usr/local/bin/svn up | awk 'NR==2, NF>1{print $NF}' | sed 's/\.//g'
} 

./test_of_out_order_merges_from_one_branch_to_another.sh > /dev/null

cd client_data/wc
perl -pi -e 's/^a/a !!/' two/testfile.txt
/usr/local/bin/svn commit -m "line a changed again"
a_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^b/b !!/' two/testfile.txt
/usr/local/bin/svn commit -m "line b changed again"
b_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^c/c !!/' two/testfile.txt
/usr/local/bin/svn commit -m "line c changed again"
c_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^d/d !!/' two/testfile.txt
/usr/local/bin/svn commit -m "line d changed again"
d_changed_in_br_two=$(last_rev) 
perl -pi -e 's/^e/e !!/' two/testfile.txt
/usr/local/bin/svn commit -m "line e changed again"
e_changed_in_br_two=$(last_rev)
/usr/local/bin/svn merge -c $a_changed_in_br_two svn://127.0.0.1/two one
/usr/local/bin/svn commit -m "line a merged into one"
svn up
/usr/local/bin/svn merge -c $e_changed_in_br_two svn://127.0.0.1/two one
/usr/local/bin/svn commit -m "line e merged into one"
svn up
/usr/local/bin/svn merge -c $c_changed_in_br_two svn://127.0.0.1/two one
/usr/local/bin/svn commit -m "line c merged into one"
svn up
/usr/local/bin/svn merge -c $d_changed_in_br_two svn://127.0.0.1/two one
/usr/local/bin/svn commit -m "line d merged into one"
svn up
/usr/local/bin/svn merge -c $b_changed_in_br_two svn://127.0.0.1/two one
/usr/local/bin/svn commit -m "line b merged into one"
svn up
echo "Mergeinfo, after merge of all the individual commits (out of order)"
svn propget svn:mergeinfo one
echo "Contents of testfile.txt on branch 'one':"
more one/testfile.txt
echo "Contents of testfile.txt on branch 'two' (they are the same, as a result of merges):"
more two/testfile.txt
echo "Attempt redundant merge of branch two into branch one (individual commits are merged already, and files at HEAD revision are idential):"
# --record-only
/usr/local/bin/svn merge svn://127.0.0.1/two one
/usr/local/bin/svn commit -m "remainder (whatever that means) merged into one"
svn up
echo "Mergeinfo, after merge of all the remaining commits (whatever that means)"
svn propget svn:mergeinfo one