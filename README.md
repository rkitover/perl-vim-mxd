# vim-perl

This is the aggregation of all the various Perl-related syntax and
helper files for Perl 5 and Perl 6.

# Installation

You can install vim-perl using

* Pathogen and git submodules
* Vundle
* [VAM](https://github.com/MarcWeber/vim-addon-manager)

They were all tested and work: please read the related documentation on the related sites.

The legacy method is to install just do a "make install" and you'll get the
.vim files all installed in your ~/.vim directory.

# Getting Help

Any bug reports/feature requests/patches should be directed to the [vim-perl group](https://groups.google.com/group/vim-perl).

When reporting bugs in the highlighting of items, please include an example file as well
as a screenshot demonstrating the problem.

# FAQ

## Curly braces inside of regexes/strings are considered when I use %

(See also [GH #86](https://github.com/vim-perl/vim-perl/issues/86))

Vim itself only considers double quotes in this scenario; the matchit plugin, however,
can deal with this scenario and vim-perl's files are set up to work with it should you
choose to use it.

## Can you add highlighting for Moose, Try::Tiny, Test::More, etc, keywords?

We have syntax "extensions" under the contrib directory; you can find custom highlighting
for these sorts of things there.

# Contributing

If you would like to contribute to vim-perl (which would be greatly appreciated!), you may find
the `build-corpus.pl` and `verify-corpus.pl` scripts of use.  What I do is drop the sources
for `Moose`, `Data::Printer`, and `Regexp::Debugger` in the corpus directory and use the scripts
to make sure my changes don't cause regressions in highlighting and folding.

xoxo,<br />
eiro,<br />
Andy (andy@petdance.com)
