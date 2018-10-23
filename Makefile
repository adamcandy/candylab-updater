
DATE=`date "+%Y%m%d %H%M"`
ifeq ($(VER),)
VER := (unknown)
endif

default: update

update:
	git pull
	git commit -a --allow-empty -m "Build $(VER) triggered at $(DATE)"
	git push

