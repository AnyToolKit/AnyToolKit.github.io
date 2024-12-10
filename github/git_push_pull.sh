case $1 in
	push)
		cd $(git rev-parse --show-toplevel)

		git add .

		git commit -m "test"

		git push -u origin $(git branch | awk '{print $2}')
		;;
	force_push)
		cd $(git rev-parse --show-toplevel)

		git add .

		git commit -m "test"

		git push -f origin $(git branch | awk '{print $2}')
		;;
	pull)
		cd $(git rev-parse --show-toplevel)

		git pull origin $(git branch | awk '{print $2}')
		;;
	force_pull)
		cd $(git rev-parse --show-toplevel)

		git fetch origin

		git reset --hard origin/$(git branch | awk '{print $2}')

		git pull origin $(git branch | awk '{print $2}')
		;;
	*)
		echo "Usage:"
		echo "$0 push|force_push|pull|force_pull"		
		;;
esac
