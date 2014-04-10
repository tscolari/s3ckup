s3up
====

Ruby gem/command line tool for Incremental backuping to AWS S3. 

My motivation for this was to be used in a backup container for docker. But it's a command line that can be used in any
platform. It's already working, but this project still a work in progress


```
Usage: s3up.rb OPTIONS --folders folder1,folder2,...
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
s3up.rb -k $AWS_KEY -a $AWS_SECRET -b my_backup_bucket -r -f /myapp/uploads,/mydb/data
```

