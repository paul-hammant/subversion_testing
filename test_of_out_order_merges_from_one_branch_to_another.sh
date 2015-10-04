#!/bin/sh

last_rev () { 
p4 changes -m 1 | cut -d' ' -f2
} 

set -e

../fast_perforce_setup/create-admin-account-and-more-security-stuff.sh

# working copy directroy 'wc' was made by the above script
# mkdir wc
cd wc
export P4PORT=ssl:localhost:1666
p4 trust -f
p4 sync
mkdir one
echo "a\n\nb\n\nc\n\nd\n\ne\n" > one/testfile.txt
p4 add one/testfile.txt
p4 submit -d  "branch_one_creation"

#echo "Branch:	one_to_two\nOwner:	paul\nOptions:	unlocked\nView:\n	//depot/one/... //depot/two/...\n" > .p4_branch
#p4 branch -i one_to_two < .p4_branch
#rm .p4_branch
p4 integrate //depot/one/... //depot/two/...

# p4 integrate //depot/one/...@1,@1 //depot/two/...
p4 submit -d  "branch_two_creation"

p4 open one/testfile.txt 
perl -pi -e 's/^a/a aa/' one/testfile.txt
p4 submit -d  "line a changed"
a_changed_in_br_one=$(last_rev) 
p4 open one/testfile.txt 
perl -pi -e 's/^b/b bbb/' one/testfile.txt
p4 submit -d  "line b changed"
b_changed_in_br_one=$(last_rev) 
p4 open one/testfile.txt 
perl -pi -e 's/^c/c cccc/' one/testfile.txt
p4 submit -d  "line c changed"
c_changed_in_br_one=$(last_rev) 
p4 open one/testfile.txt 
perl -pi -e 's/^d/d ddddd/' one/testfile.txt
p4 submit -d  "line d changed"
d_changed_in_br_one=$(last_rev) 
p4 open one/testfile.txt 
perl -pi -e 's/^e/e eeeeee/' one/testfile.txt
p4 submit -d  "line e changed"
e_changed_in_br_one=$(last_rev)

p4 integrate //depot/one/...@$a_changed_in_br_one,@$a_changed_in_br_one //depot/two/...
p4 resolve -am -Ac two/testfile.txt
p4 submit -d  "line a merged into two"
p4 sync
p4 integrate //depot/one/...@$e_changed_in_br_one,@$e_changed_in_br_one //depot/two/...
p4 resolve -am -Ac two/testfile.txt
p4 submit -d  "line e merged into two"
p4 sync
p4 integrate //depot/one/...@$c_changed_in_br_one,@$c_changed_in_br_one //depot/two/...
p4 resolve -am -Ac two/testfile.txt
p4 submit -d  "line c merged into two"
p4 sync
p4 integrate //depot/one/...@$d_changed_in_br_one,@$d_changed_in_br_one //depot/two/...
p4 resolve -am -Ac two/testfile.txt
p4 submit -d  "line d merged into two"
p4 sync
p4 integrate //depot/one/...@$b_changed_in_br_one,@$b_changed_in_br_one //depot/two/...
p4 resolve -am -Ac two/testfile.txt
p4 submit -d  "line b merged into two"
p4 sync

echo "Changes Perforce thinks are unmerged, after merge of all the individual commits (out of order)"
p4 interchanges //depot/one/... //depot/two/...
echo "Performing a non cherry-pick merge (should be redundant)..."
p4 integrate //depot/one/... //depot/two/...
p4 resolve -am -Ac two/testfile.txt
echo ".... as indicated by 'No files to submit':"
p4 submit -d  "remainder (whatever that means) merged into two"