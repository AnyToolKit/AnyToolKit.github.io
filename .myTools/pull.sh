  cd $(git rev-parse --show-toplevel)

  git pull origin $(git branch | awk '{print $2}')
