# Deploying versioned static files to s3 (Example)

## Prerequisite Steps

* Clone the repository
* Open deploy.sh and set the desired bucket name (bucketName), and the local path of the cloned repo (localPath)
* It is assumed that aws cli in the local machine is set up with a working account and access to s3
* Add execute permission to deploy.sh

## Sample Usage

```
cd /PATH/TO/WORKINGCOPY/
./deploy.sh v2
```

This will upload the v2 index and assets to the s3, the deployed index.v2.html version will also be renamed to index.html.

## Sample Scenario / Outputs

```
# ./deploy.sh
version needs to be specified as first arguement eg: 'v1' or 'v2'

# ./deploy.sh v4
no files matched with the version specified

# ./deploy.sh v3
index.html for the version specific does not exist: index.v3.html

# ./deploy.sh v2
Deployment of v2 is successful

# ./deploy.sh v1
Deployment of v1 is successful
```
