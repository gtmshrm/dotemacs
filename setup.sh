#!/bin/sh

files=(bin config core elisp init.el snippets .eshell-aliases)

mkdir -p ~/.emacs.d

echo "Creating symlinks..."
for file in $files; do
	stow $file -t ~/.emacs.d
done
echo "Done."
