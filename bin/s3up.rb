#!/usr/bin/env ruby

require 'optparse'
require 'logger'
require_relative '../lib/s3up'

options = {}
folders = []
logger = Logger.new($stdout)
logger.level = Logger::WARN

OptionParser.new do |opts|
  opts.banner = "Usage: s3up.rb OPTIONS --folders folder1,folder2,..."

  opts.on("-k", "--aws-key-id KEY_ID", "AWS key id") do |key_id|
    options[:key_id] = key_id
  end

  opts.on("-a", "--aws-access-key ACCESS_KEY", "AWS access key") do |access_key|
    options[:access_key] = access_key
  end

  opts.on("-b", "--s3-bucket BUCKET_NAME", "S3 bucket name") do |bucket_name|
    options[:bucket] = bucket_name
  end

  opts.on("-r", "--recursive", "Recursive mode") do
    options[:recursive] = true
  end

  opts.on("-v", "--verbose", "Verbose") do
    logger.level = Logger::INFO
  end

  opts.on("-f", "--folders FOLDER1,FOLDER2,FOLDER3...", Array, "Folder list, separated by ','") do |folder_list|
    folder_list.each do |folder|
      if options[:recursive]
        folders << File.join(folder, "**", "*")
      else
        folders << File.join(folder, "*")
      end
    end
  end

end.parse!

S3up::Backup.new(options[:key_id], options[:access_key], logger).
  run(options[:bucket], folders)
