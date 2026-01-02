#! /bin/bash
homepath=/home/quangtm/personal/projects/40_Day_CKA_Blog

cd $homepath
echo "Enter Day number:"
read number

mkdir "Day$number" || cp ~/Downloads/tmp/notion/"Day$number".zip "Day$number"

cd "Day$number" && rm *.md && unzip "Day$number.zip"
zipfile=$(ls ExportBlock-*.zip)
echo "[+] Unzipping $zipfile ..."
unzip "$zipfile"
rm *.zip

mdfile=$(ls "Day$number"*)
mv "$mdfile" "Day$number.md"
git add "Day$number.md"
git commit -m "chore(\"Day$number\"): update"
git push
cd $homepath