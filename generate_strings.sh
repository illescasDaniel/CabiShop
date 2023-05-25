#!/bin/sh

# Make sure Localizable.strings is empty
find ./ -name "*.swift" -print0 | xargs -0 genstrings -a -SwiftUI -o CabiShop/presentation/resources/en.lproj

