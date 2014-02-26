#!/bin/sh

echo 'Remove local branch $1'
git branch -D $1

echo 'Remove remote branch $1'
git push origin :$1