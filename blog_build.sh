#! /bin/sh

echo ""
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Build blog with hugo"
echo "Author: LeeLee"
echo "Date: 2022-09-17"
echo "This script is for build blog and commit to git."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo ""

TODAY=$(date)

# build blog
hugo -t fuji

# commit and push build result to github.io
cd public || exit
# shellcheck disable=SC2094
touch date.txt | date >> date.txt
git add .
git commit -m "Publish blog to github.io Date: $TODAY"
git push origin master

# commit and push posting resource
cd ..
git add .
git commit -m "Add posting resource after publishing Date: $TODAY"
git push
