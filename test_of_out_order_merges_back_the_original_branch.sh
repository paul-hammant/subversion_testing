#!/bin/sh

last_rev () { 
p4 changes -m 1 | cut -d' ' -f2
} 

cd wc

p4 open two/testfile.txt 
perl -pi -e 's/^a/a !!/' two/testfile.txt
p4 submit -d "line a changed again"
a_changed_in_br_two=$(last_rev) 
p4 open two/testfile.txt 
perl -pi -e 's/^b/b !!/' two/testfile.txt
p4 submit -d "line b changed again"
b_changed_in_br_two=$(last_rev) 
p4 open two/testfile.txt 
perl -pi -e 's/^c/c !!/' two/testfile.txt
p4 submit -d "line c changed again"
c_changed_in_br_two=$(last_rev) 
p4 open two/testfile.txt 
perl -pi -e 's/^d/d !!/' two/testfile.txt
p4 submit -d "line d changed again"
d_changed_in_br_two=$(last_rev) 
p4 open two/testfile.txt 
perl -pi -e 's/^e/e !!/' two/testfile.txt
p4 submit -d "line e changed again"
e_changed_in_br_two=$(last_rev)

p4 integrate //depot/two/...@$a_changed_in_br_two,@$a_changed_in_br_two //depot/one/...
p4 resolve -am -Ac one/testfile.txt
p4 submit -d "line a merged into one"
p4 sync
p4 integrate //depot/two/...@$e_changed_in_br_two,@$e_changed_in_br_two //depot/one/...
p4 resolve -am -Ac one/testfile.txt
p4 submit -d "line e merged into one"
p4 sync
p4 integrate //depot/two/...@$c_changed_in_br_two,@$c_changed_in_br_two //depot/one/...
p4 resolve -am -Ac one/testfile.txt
p4 submit -d "line c merged into one"
p4 sync
p4 integrate //depot/two/...@$d_changed_in_br_two,@$d_changed_in_br_two //depot/one/...
p4 resolve -am -Ac one/testfile.txt
p4 submit -d "line d merged into one"
p4 sync
p4 integrate //depot/two/...@$b_changed_in_br_two,@$b_changed_in_br_two //depot/one/...
p4 resolve -am -Ac one/testfile.txt
p4 submit -d "line b merged into one"

p4 sync
echo "Changes Perforce thinks are unmerged, after merge of all the individual commits (out of order)"
p4 interchanges //depot/two/... //depot/one/...
echo "Performing a non cherry-pick merge (should be redundant)..."
p4 integrate //depot/two/... //depot/one/...
p4 resolve -am -Ac one/testfile.txt
echo ".... as indicated by 'No files to submit':"
p4 submit -d  "remainder (whatever that means) merged into two"
echo "As expected, nothing to merge. Let's try another redundant combo - from 'one' to 'two':"
p4 integrate //depot/one/... //depot/two/...
p4 resolve -am -Ac two/testfile.txt
echo "Again, as indicated by 'No files to submit', there was nothing to merge."

