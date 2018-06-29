#!/usr/bin/env bash

#configuration
bucketName='static-bucket-dubizzle-test'
localPath='/home/ubuntu/dubizzle_exam'

#first arguement as version number
version=$1

#check if version number arguement is specified
[ -z "$version" ] && echo "version needs to be specified as first arguement eg: 'v1' or 'v2'" && exit;

#build the assets list based on the version number that is specified
cd $localPath
listOfFiles="$(find * -type f -name *.$version.jpg -o -name *.$version.css -o -name *.$version.js -o -name *.$version.html)"
listOfFiles=($listOfFiles)

#check if there are assets which matched the version number
[ -z "$listOfFiles" ] && echo "no files matched with the version specified" && exit;

#check if index.html for the specified version exists
[ ! -f "$localPath/index.$version.html"  ] && echo "index.html for the version specific does not exist: index.$version.html" && exit;

#check if bucket exists, create one if it doesn't
if aws s3 ls "s3://$bucketName" 2>&1 | grep -q 'An error occurred'
then
    echo "$bucketName does not exist, creating one.."
    if aws s3 mb s3://$bucketName 2>&1 | grep -q 'An error occurred'
    then
        echo "failed to create $bucketName"
        exit
    fi
fi

#upload to s3
uploadResult=$(aws s3 cp $localPath s3://$bucketName/ --recursive --exclude "*" --include "*.$version.*")
if [[ $uploadResult = '*failed*' ]] || [ -z "$uploadResult" ];
then
    echo "failed to upload to s3"
    exit
fi

# we have reached this point, so it should be safe to rename index.$VERSION.html to index.html
aws s3 mv s3://$bucketName/index.$version.html s3://$bucketName/index.html
echo "Deployment of $version is successful"
