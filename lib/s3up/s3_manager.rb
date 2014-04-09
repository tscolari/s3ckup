require 'aws/s3'

module S3up
  class S3Mananger
    MANIFEST_FILE_NAME = 'manifest.yml'

    def initialize(key_id, access_key, logger = Logger.new)
      connect!(key_id, access_key)
      @logger = logger
    end

    def fetch_manifest(bucket)
      manifest = AWS::S3::S3Object.find MANIFEST_FILE_NAME, bucket
      Manifest.new(YAML.load(manifest.value))
    rescue
      @logger.warn("Failed to fetch remote manifest. Ignoring.")
      Manifest.new({})
    end

    def upload(bucket, manifest)
      manifest.file_list.each do |file_name|
        @logger.info("Uploading file: #{file_name}")
        AWS::S3::S3Object.store(file_name, open(file_name), bucket)
      end
    end

    def update_manifest(bucket, manifest)
      @logger.info("Updating remote manifest")
      AWS::S3::S3Object.store(MANIFEST_FILE_NAME, manifest.to_yaml, bucket)
    end

    def delete(bucket, manifest)
      manifest.file_list.each do |file_name|
        @logger.info("Deleting remote file: #{file_name}")
        AWS::S3::S3Object.delete file_name, bucket
      end
    end

    private

    def connect!(key_id, access_key)
      AWS::S3::Base.establish_connection!(
        :access_key_id     => key_id,
        :secret_access_key => access_key
      )
    end

  end
end
