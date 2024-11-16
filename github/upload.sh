cd $(git rev-parse --show-toplevel)

git add .

git commit -m "test"

git push -u origin master
