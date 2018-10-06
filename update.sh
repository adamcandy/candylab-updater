#!/bin/bash

bundler exec jekyll build && \
touch docs/.nojekyll && \
git pull && \
git add -A docs/ && \
git commit -a -m "Automatic update to static site from travis (updater), jobid $@" && \
git push && \
git rev-parse HEAD~1 && exit 0

exit 1


