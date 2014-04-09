require 'spec_helper'
require 'pry'

module S3up
  describe Manifest do

    context "Initization" do
      context "with folders list" do
        it "should scan the folders given" do
          manifest = Manifest.new("./spec/fixtures/**/*", "./spec/fixtures/backup_here/**/*")
          manifest.file_list.should_not be_empty
        end

        it "should accept one folder only too" do
          manifest = Manifest.new("./spec/fixtures/**/*")
          manifest.file_list.should_not be_empty
        end
      end

      context "with hash of files" do
        it "should load forward the hash to the file list" do
          manifest = Manifest.new({"file1" => "123", "file2" => "222", "file3" => "333"})
          manifest.file_list.should eq(["file1", "file2", "file3"])
        end
      end
    end

    context "Manifest operations" do
      let(:manifest1) { Manifest.new({"file1" => "123", "file2" => "222", "file3" => "333"}) }
      let(:manifest2) { Manifest.new({"file1" => "111", "file2" => "222", "file5" => "555", "file6" => "666"}) }

      context "manifest subtraction" do
        it "should return a manifest with the extra files only" do
          result = manifest2 - manifest1
          result.file_list.should eq(["file5", "file6"])
        end
      end

      context "manifest diff" do
        it "should return a manifest with the difference between 2 manifests" do
          result = manifest2.diff(manifest1)
          result.file_list.should eq(["file1", "file5", "file6"])
        end
      end
    end

  end
end
