#!/usr/bin/env ruby

require 'aws-sdk'
require 'securerandom'
require 'tempfile'

bucket   = ENV['S3_BUCKET_NAME']

i=0
while true
  i += 1
  filename = SecureRandom.uuid
  tmp_file = Tempfile.new(filename)
  tmp_file.puts("Hey I'm some data!")
  tmp_file.close

  puts "#{i} Uploading s3://#{bucket}/#{filename}..."

  s3 = Aws::S3::Resource.new
  s3.bucket(bucket).object(filename).upload_file(tmp_file.path)

  tmp_file.unlink

  if i >= 1000
    puts "1000 runs without failure - probably an OK AMI"
    puts "PASS"
    exit
  end
end
