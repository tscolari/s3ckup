require 'digest/md5'
require 'yaml'

module S3ckup
  class Manifest
    attr_reader :files

    def initialize(*args)
      if args.first.is_a?(Hash)
        @files = args.first
      else
        @files = create_manifest(Array(args).flatten)
      end
    end

    def to_yaml
      @files.to_yaml
    end

    def file_list
      @files.keys.sort
    end

    def -(manifest)
      raise ArgumentError unless manifest.is_a?(Manifest)
      remaining_files = file_list - manifest.file_list
      remaining_files = @files.clone.keep_if { |file| remaining_files.include?(file) }
      Manifest.new(remaining_files)
    end

    def diff(manifest)
      files_to_upload = @files.to_a - manifest.files.to_a
      Manifest.new(Hash[*files_to_upload.flatten])
    end

    private

    def create_manifest(folders)
      Hash.new.tap do |files|
        folders.each do |folder|
          files.merge! scan_folder(folder)
        end
      end
    end

    def scan_folder(folder)
      Hash.new.tap do |folder_files|
        Dir[folder].each do |file_name|
          if should_backup?(file_name)
            folder_files[file_name] = file_digest(file_name)
          end
        end
      end
    end

    def should_backup?(file_name)
      ! (File.directory?(file_name) ||
       File.symlink?(file_name) ||
       File.socket?(file_name))
    end

    def file_digest(file_name)
      Digest::MD5.file(file_name).hexdigest
    end

  end
end
