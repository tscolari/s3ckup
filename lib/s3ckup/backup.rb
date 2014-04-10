module S3ckup
  class Backup

    def initialize(key_id, access_key, logger = Logger.new)
      @logger = logger
      @s3_manager = S3Mananger.new(key_id, access_key, @logger)
    end

    def run(bucket_name, folders)
      local_files = Manifest.new(folders.flatten)
      remote_files = @s3_manager.fetch_manifest(bucket_name)
      backup(bucket_name, remote_files, local_files)
    end

    private

    def fetch_remote_manifest(bucket)
      manifest_yml = @s3_manager.fetch_manifest(bucket)
      data = YAML.load(manifest_yml.value)
      Manifest.new(data)
    rescue AWS::S3::NoSuchKey
      Manifest.new({})
    end

    def backup(bucket, remote_files, local_files)
      removed_files = remote_files - local_files
      @s3_manager.delete(bucket, removed_files)

      remote_files = remote_files - removed_files
      files_to_upload = local_files.diff(remote_files)

      @s3_manager.update_manifest(bucket, local_files)
      @s3_manager.upload(bucket, files_to_upload)
    end

  end
end
