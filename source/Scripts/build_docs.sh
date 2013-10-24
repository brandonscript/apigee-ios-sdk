#!/bin/bash
# This script is an adaptation of the one found at http://www.hautelooktech.com/2012/11/07/automate-xcode-documentation/

# SETTING
# location of XCODE docset
#DOCSET_DIR=~/Library/Developer/Shared/Documentation/DocSets/com.apigee.documentation.ios_sdk.docset
DOCSET_DIR=../build/DocSet/com.apigee.documentation.ios_sdk.docset

# location of html code document, generated by headerdoc2html
DOCUMENT_DIR=$DOCSET_DIR/Contents/Resources/Documents
 
# location of templates, Info.plist Nodes.xml
DOCSET_TEMPLATE_DIR=../../Docset
 
# location of our source code, where headerdoc2html will spider through
SOURCE_DIR=../Classes
 
# delete old docset and start from fresh, this will kill XCODE if its running.  good for development only, comment out for production.
rm -rf $DOCSET_DIR
 
# create document directory
mkdir -p $DOCUMENT_DIR
 
# generate html code document for source code.  -j will recognize java comment tag ex. /** */
# https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/usage/usage.html#//apple_ref/doc/uid/TP40001215-CH337-SW2
headerdoc2html -o $DOCUMENT_DIR $SOURCE_DIR
 
# generate main index file. -d will generate Tokens.xml for us.
#
# http://opensource.apple.com/source/headerdoc/
# https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/usage/usage.html#//apple_ref/doc/uid/TP40001215-CH337-SW1
#
gatherheaderdoc -d $DOCUMENT_DIR
 
# copy required template files for apple docset
cp $DOCSET_TEMPLATE_DIR/Info.plist $DOCSET_DIR/Contents/
cp $DOCSET_TEMPLATE_DIR/Nodes.xml   $DOCSET_DIR/Contents/Resources/
cp $DOCUMENT_DIR/Tokens.xml         $DOCSET_DIR/Contents/Resources/
 
# create and validate apple docset indexes
XCODE_PATH="/Applications"
$XCODE_PATH/Xcode.app/Contents/Developer/usr/bin/docsetutil index -verbose -debug $DOCSET_DIR
$XCODE_PATH/Xcode.app/Contents/Developer/usr/bin/docsetutil validate -verbose -debug $DOCSET_DIR

# delete all empty directories from $DOCUMENT_DIR
find $DOCUMENT_DIR -type d -empty -exec rmdir {} \; > /dev/null 2> /dev/null

