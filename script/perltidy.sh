#!/usr/bin/env sh
LIB=$1
FILES=$(find $LIB -name "*.pm" -printf "%p\n")

for i in $FILES; do
    e=$(perltidy -pro=./.perltidyrc $i -st | diff $i -)
    [ $? -eq 0 ] || { echo not tidy $i; exit 1; }
done
