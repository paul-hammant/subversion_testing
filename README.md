# Install Subversion via homebrew.

```
brew install subversion
```

# The test of Subversion

To see the Subvsersion merge-tracking bug:

```
./reset.sh
./server.sh
./test_of_out_order_merges_back_the_original_branch.sh
```

It'll barf at the end with a merge conflict. Last subversion tested 1.9.4

For more info, see the accompanying bog entry: [paulhammant.com/2015/09/25/subversion-merge-limitations/](http://paulhammant.com/2015/09/25/subversion-merge-limitations/)
