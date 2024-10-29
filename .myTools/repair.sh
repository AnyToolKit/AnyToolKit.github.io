eval "$(ssh-agent -s)"

ssh-add ~/.ssh/github_id_rsa

ssh -T git@github.com
