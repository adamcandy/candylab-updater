#!/bin/bash

git pull && \
BUNDLE_GEMFILE=assets/dev/Gemfile JEKYLL_ENV=production bundle exec --gemfile=assets/dev/Gemfile jekyll build --config assets/data/config.yml,assets/data/alt.yml && \
touch docs/.nojekyll && \
echo "alt.candylab.org" > docs/CNAME && \
git add -A docs/ && \
git commit -a -m "$@" && \
git push && \
git rev-parse HEAD~1 && exit 0

exit 1


