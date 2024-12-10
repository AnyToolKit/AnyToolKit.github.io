cd $(git rev-parse --show-toplevel)

git fetch origin

git reset --hard origin/$(git branch | awk '{print $2}')

git pull origin $(git branch | awk '{print $2}')
