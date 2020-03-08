#!/bin/bash

git pull && \
JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_alt.yml && \
touch docs/.nojekyll && \
echo "alt.candylab.org" > docs/CNAME && \
git add -A docs/ && \
git commit -a -m "$@" && \
git push && \
git rev-parse HEAD~1 && exit 0

exit 1


