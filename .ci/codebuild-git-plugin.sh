#!/bin/sh

export CI=true

export CI_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)

export CI_GIT_BRANCH="$(git symbolic-ref HEAD --short 2>/dev/null)"
if [ "$CI_GIT_BRANCH" = "" ] ; then
  CI_GIT_BRANCH="$(git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }')";
  export CI_GIT_BRANCH=${CI_GIT_BRANCH#remotes/origin/};
fi

export CI_GIT_CLEAN_BRANCH="$(echo $CI_GIT_BRANCH | tr '/' '.')"
export CI_GIT_ESCAPED_BRANCH="$(echo $CI_GIT_CLEAN_BRANCH | sed -e 's/[]\/$*.^[]/\\\\&/g')"
export CI_GIT_MESSAGE="$(git log -1 --pretty=%B)"
export CI_GIT_AUTHOR="$(git log -1 --pretty=%an)"
export CI_GIT_AUTHOR_EMAIL="$(git log -1 --pretty=%ae)"
export CI_GIT_COMMIT="$(git log -1 --pretty=%H)"
export CI_GIT_SHORT_COMMIT="$(git log -1 --pretty=%h)"
export CI_GIT_TAG="$(git describe --tags --exact-match 2>/dev/null)"
export CI_GIT_MOST_RECENT_TAG="$(git describe --tags --abbrev=0)"

export CI_PULL_REQUEST=false
if [ "${CI_GIT_BRANCH#pr-}" != "$CI_GIT_BRANCH" ] ; then
  export CI_PULL_REQUEST=${CI_GIT_BRANCH#pr-};
fi

export CI_PROJECT=${CI_BUILD_ID%:$CI_LOG_PATH}
export CI_BUILD_URL=https://$AWS_DEFAULT_REGION.console.aws.amazon.com/codebuild/home?region=$AWS_DEFAULT_REGION#/builds/$CI_BUILD_ID/view/new

echo "==> AWS CodeBuild Extra Environment Variables:"
echo "==> CI = $CI"
echo "==> CI_ACCOUNT_ID = $CI_ACCOUNT_ID"
echo "==> CI_GIT_AUTHOR = $CI_GIT_AUTHOR"
echo "==> CI_GIT_AUTHOR_EMAIL = $CI_GIT_AUTHOR_EMAIL"
echo "==> CI_GIT_BRANCH = $CI_GIT_BRANCH"
echo "==> CI_GIT_CLEAN_BRANCH = $CI_GIT_CLEAN_BRANCH"
echo "==> CI_GIT_ESCAPED_BRANCH = $CI_GIT_ESCAPED_BRANCH"
echo "==> CI_GIT_COMMIT = $CI_GIT_COMMIT"
echo "==> CI_GIT_SHORT_COMMIT = $CI_GIT_SHORT_COMMIT"
echo "==> CI_GIT_MESSAGE = $CI_GIT_MESSAGE"
echo "==> CI_GIT_TAG = $CI_GIT_TAG"
echo "==> CI_GIT_MOST_RECENT_TAG = $CI_GIT_MOST_RECENT_TAG"
echo "==> CI_PROJECT = $CI_PROJECT"
echo "==> CI_PULL_REQUEST = $CI_PULL_REQUEST"
