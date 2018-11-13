#!/usr/bin/env bash

echo "Attempting clean up of bucket for" $TRAVIS_BRANCH $TRAVIS_TAG

if [ "$TRAVIS_BRANCH" = "develop" ]
then
  echo "Clearing Dev Bucket Prior To Deployment "
  eval export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_DEV
  eval export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_DEV
  aws s3 rm s3://dev.docs.marketprotocol.io --recursive
elif [[ -v TRAVIS_TAG ]]
then
  echo "Invalidating CloudFront Cache"
  aws configure set preview.cloudfront true
  aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --paths "/*"
  echo "Clearing Production Bucket Prior To Deployment"
  aws s3 rm s3://docs.marketprotocol.io --recursive
else
  echo "No deployment on this branch"
fi
