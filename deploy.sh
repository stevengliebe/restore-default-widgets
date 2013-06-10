#! /bin/bash
# A modified version of a modified version of deploy.sh.
# This updates WordPress.org SVN repo from Git repo.
# 
# Credit:
# http://speakinginbytes.com/2012/10/wordpress-plugin-deployment-script/
# https://github.com/deanc/wordpress-plugin-git-svn

# main config
PLUGINSLUG="restore-default-widgets"
CURRENTDIR=`pwd`
MAINFILE="restore-default-widgets.php" # this should be the name of your main php file in the wordpress plugin

# svn config
SVNPATH="/tmp/$PLUGINSLUG" # path to a temp SVN repo. No trailing slash required and don't add trunk.
SVNURL="http://plugins.svn.wordpress.org/restore-default-widgets" # Remote SVN repo on wordpress.org, with no trailing slash
SVNUSER="stevengliebe" # your svn username

# Let's begin...
echo 
echo ".........................................."
echo 
echo "Preparing to deploy wordpress plugin"
echo 
echo ".........................................."
echo 

# Get version
VERSION=`grep "^Stable tag" "$CURRENTDIR/readme.txt" | awk -F' ' '{print $3}'`
echo "readme.txt version: $VERSION"

echo 
echo "Creating local copy of SVN repo..."
rm -fr $SVNPATH/ # remove old tmp
svn co $SVNURL $SVNPATH

echo "Exporting the HEAD of master from git to the trunk of SVN..."
git checkout-index -a -f --prefix=$SVNPATH/trunk/

echo "Ignoring GitHub-specific and deployment script..."
svn propset svn:ignore "deploy.sh
README.md
.git
.gitignore" "$SVNPATH/trunk/"

echo "Moving _wporg-assets..."
mkdir $SVNPATH/assets/
mv $SVNPATH/trunk/_wporg-assets/* $SVNPATH/assets/
svn add $SVNPATH/assets/
svn delete --force $SVNPATH/trunk/_wporg-assets

echo "Changing directory to SVN..."
cd $SVNPATH/trunk/
# Add all new files that are not set to be ignored
svn status | grep -v "^.[ \t]*\..*" | grep "^?" | awk '{print $2}' | xargs svn add
echo "Committing to trunk..."
svn commit --username=$SVNUSER -m "Uploading version $VERSION"

echo "Creating new SVN tag and committing it..."
cd $SVNPATH
svn copy trunk/ tags/$VERSION/
cd $SVNPATH/tags/$VERSION
svn commit --username=$SVNUSER -m "Tagging version $VERSION"

echo "Updating WordPress.org plugin repo assets and committing..."
cd $SVNPATH/assets/
svn add *
svn commit --username=$SVNUSER -m "Updating repo assets"

echo "Removing temporary directory $SVNPATH..."
rm -fr $SVNPATH/

echo "*** FINISHED ***"