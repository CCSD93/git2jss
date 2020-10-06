#!/bin/bash

# xattr -d -r -v com.apple.quarantine /Applications

xattr -d -v com.apple.quarantine "/Applications/$4"