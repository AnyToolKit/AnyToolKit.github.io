# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/github_id_rsa
# ssh -T git@github.com

  cd $(git rev-parse --show-toplevel)

  git add .

  git commit -m "test"

  git push -u origin $(git branch | awk '{print $2}')
