# Install Subversion via homebrew.

```
brew install subversion
```

### Subversion 1.9.2

This isn't in the homebrew repo. After install of subversion via homebrew, edit /usr/local/Library/Formula/subversion.rb. Change three lines near the top to ...

```
url "https://www.apache.org/dyn/closer.cgi?path=subversion/subversion-1.9.2.tar.bz2"
  mirror "https://archive.apache.org/dist/subversion/subversion-1.9.2.tar.bz2"
  sha256 "023da881139b4514647b6f8a830a244071034efcaad8c8e98c6b92393122b4eb"
```

... and delete the devel section near line 15. Then run:

```
brew upgrade subversion
```

See [paulhammant.com/2015/09/25/subversion-merge-limitations/](http://paulhammant.com/2015/09/25/subversion-merge-limitations/) for more details.
