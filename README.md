s3ckup
====

Ruby gem/command line tool for Incremental backuping to AWS S3.

My motivation for this was to be used in a backup container for docker. But it's a command line that can be used in any
platform.

It will store a `manifest.yml` file in the root of the bucket, containing all
file names and digests. On backup this file will be matched with a on time
generated one, only updated/new files will be pushed to the bucket, and files
that no longer exists will be deleted.

There's no versioning, but you could use s3 built in versioning.

INSTALLATION
-----------

```
  gem install s3ckup
```


USAGE
-----

```
Usage: s3ckup OPTIONS --folders folder1,folder2,...
    -k, --aws-key-id KEY_ID          AWS key id
    -a, --aws-access-key ACCESS_KEY  AWS access key
    -b, --s3-bucket BUCKET_NAME      S3 bucket name
    -r, --recursive                  Recursive mode
    -v, --verbose                    Verbose
    -f FOLDER1,FOLDER2,FOLDER3...,   Folder list, separated by ','
        --folders
```

Example:

```
s3ckup -k $AWS_KEY -a $AWS_SECRET -b my_backup_bucket -r -f /myapp/uploads,/mydb/data
```

