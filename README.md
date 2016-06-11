# Install Subversion via homebrew.

```
brew install subversion
```

# To see the Subvsersion merge-tracking bug

```
./reset.sh
./server.sh
./test_of_out_order_merges_back_the_original_branch.sh
```

It'll barf at the end with a merge conflict. Last subversion tested 1.9.4

For more info, see the accompanying bog entry: [paulhammant.com/2015/09/25/subversion-merge-limitations/](http://paulhammant.com/2015/09/25/subversion-merge-limitations/)

# Notes:

Rasied at apache -  https://issues.apache.org/jira/browse/SVN-4635

## Mercurial doesn't have the same bug

See the [hg_equivalent](https://github.com/paul-hammant/subversion_testing/tree/hg_equivalent) branch in this repo

## Git doesn't have the same bug

See the [git_equivalent](https://github.com/paul-hammant/subversion_testing/tree/git_equivalent) branch in this repo

## Perforce doesn't have the same bug

See the [p4_equivalent](https://github.com/paul-hammant/subversion_testing/tree/p4_equivalent) branch in this repo
