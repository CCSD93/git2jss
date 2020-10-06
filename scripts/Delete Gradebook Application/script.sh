#!/bin/bash

username=`/usr/bin/logname`

echo Deleting PowerSchool GradeBook Application

if [ -f /Users/$username/.powerschool_gradebook.properties ]; then
    echo Deleting .powerschool_gradebook.properties
    rm -rv /Users/$username/.powerschool_gradebook.properties
fi

if [ -f /Users/$username/.gradebook_userdict.tlx ]; then
    echo Deleting .gradebook_userdict.tlx
    rm -rv /Users/$username/.gradebook_userdict.tlx
fi

if [ -d /Users/$username/Library/caches/Pearson ]; then
    echo Deleting User Library/caches/Pearson
    rm -rv /Users/$username/Library/caches/Pearson
fi

if [ -d /Users/$username/Applications/GradeBook.app ]; then
    echo Deleting User GradeBook.app
    rm -rv /Users/$username/Applications/GradeBook.app
fi

if [ -d /Applications/GradeBook.app ]; then
    echo Deleting System GradeBook.app
    rm -rv /Applications/GradeBook.app
fi
