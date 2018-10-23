
DATE=`date "+%Y%m%d %H%M"`

default: update

update:
	git pull
	git commit -a --allow-empty -m "Build triggered at $(DATE)"
	git push

