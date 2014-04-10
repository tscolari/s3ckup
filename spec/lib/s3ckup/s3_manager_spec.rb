require 'spec_helper'

module S3ckup
  describe S3Mananger do
    let(:key_id) { SecureRandom.uuid }
    let(:access_key) { SecureRandom.hex }
    let(:bucket) { "my_backup_bucket" }
    let(:files) { ['file1', 'file2', 'file3'] }
    let(:manifest) { double(:manifest, file_list: files) }
    let(:logger) { Logger.new('/dev/null') }

    subject { S3Mananger.new(key_id, access_key, logger) }

    describe "#fetch_manifest" do
      it "should ask S3Object for the manifest in the bucket" do
        AWS::S3::S3Object.should_receive(:find).with(S3Mananger::MANIFEST_FILE_NAME, bucket)
        subject.fetch_manifest(bucket)
      end
    end

    describe "#upload" do
      before { subject.stub(:open).and_return("") }

      it "should store all files from the manifest" do
        files.each do |file_name|
          AWS::S3::S3Object.should_receive(:store).with(file_name, anything, bucket)
        end
        subject.upload(bucket, manifest)
      end
    end

    describe "#update_manifest" do
      it "should store the manifest" do
        AWS::S3::S3Object.should_receive(:store).with(S3Mananger::MANIFEST_FILE_NAME, anything, bucket)
        subject.update_manifest(bucket, manifest)
      end
    end

    describe "#delete" do
      it "should delete all the files from the manifest" do
        files.each do |file_name|
          AWS::S3::S3Object.should_receive(:delete).with(file_name, bucket)
        end
        subject.delete(bucket, manifest)
      end

    end
  end
end
