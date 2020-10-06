#!/bin/bash

# xattr -d -r -v com.apple.quarantine /Applications

find /Applications -iname '*.app' -print0 | xargs -0 xattr -d -v com.apple.quarantine