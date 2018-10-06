#!/bin/bash

git pull && \
bundler exec jekyll build && \
touch docs/.nojekyll && \
git add -A docs/ && \
git commit -a -m "$@" && \
git push && \
git rev-parse HEAD~1 && exit 0

exit 1


