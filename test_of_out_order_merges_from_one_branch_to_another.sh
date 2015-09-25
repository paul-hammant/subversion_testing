#!/bin/sh

last_rev () { 
/usr/local/bin/svn up | awk 'NR==2, NF>1{print $NF}' | sed 's/\.//g'
} 

mkdir client_data
cd client_data
/usr/local/bin/svn co svn://127.0.0.1/ wc
cd wc
mkdir one
echo "a\n\nb\n\nc\n\nd\n\ne\n" > one/testfile.txt
/usr/local/bin/svn add one
/usr/local/bin/svn commit -m "branch_one_creation"
/usr/local/bin/svn copy svn://127.0.0.1/one two
/usr/local/bin/svn commit -m "branch_two_creation"
perl -pi -e 's/^a/a aa/' one/testfile.txt
/usr/local/bin/svn commit -m "line a changed"
a_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^b/b bbb/' one/testfile.txt
/usr/local/bin/svn commit -m "line b changed"
b_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^c/c cccc/' one/testfile.txt
/usr/local/bin/svn commit -m "line c changed"
c_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^d/d ddddd/' one/testfile.txt
/usr/local/bin/svn commit -m "line d changed"
d_changed_in_br_one=$(last_rev) 
perl -pi -e 's/^e/e eeeeee/' one/testfile.txt
/usr/local/bin/svn commit -m "line e changed"
e_changed_in_br_one=$(last_rev)
/usr/local/bin/svn merge -c $a_changed_in_br_one svn://127.0.0.1/one two
/usr/local/bin/svn commit -m "line a merged into two"
svn up
/usr/local/bin/svn merge -c $e_changed_in_br_one svn://127.0.0.1/one two
/usr/local/bin/svn commit -m "line e merged into two"
svn up
/usr/local/bin/svn merge -c $c_changed_in_br_one svn://127.0.0.1/one two
/usr/local/bin/svn commit -m "line c merged into two"
svn up
/usr/local/bin/svn merge -c $d_changed_in_br_one svn://127.0.0.1/one two
/usr/local/bin/svn commit -m "line d merged into two"
svn up
/usr/local/bin/svn merge -c $b_changed_in_br_one svn://127.0.0.1/one two
/usr/local/bin/svn commit -m "line b merged into two"
svn up
echo "Mergeinfo, after merge of all the individual commits (out of order)"
svn propget svn:mergeinfo two
/usr/local/bin/svn merge svn://127.0.0.1/one two
/usr/local/bin/svn commit -m "remainder (whatever that means) merged into two"
svn up
echo "Mergeinfo, after merge of all the remaining commits (whatever that means)"
svn propget svn:mergeinfo two