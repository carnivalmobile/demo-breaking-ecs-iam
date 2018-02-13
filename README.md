# Update

The cause of this issue has been identified and explained at:
https://github.com/aws/amazon-ecs-agent/issues/1231

The summary is that the ECS Agent version 1.17.0 introduced rate limiting on
the credentials endpoint used for ECS containers. This can break some poorly
coded applications (like this demo) which is fetching the credentials
constantly and hitting the rate limit.


# About

This project demonstrates a bug with Amazon ECS preventing the Ruby SDK from
authenticating properly on some occasions. We found this issue in our
environment specifically in relation to S3 file uploads, so this demo script
reproduces that exact design.

The script simply loops uploading a file until it encounters the bug and crashes
causing pager duty alarms and emotional distress for the engineer, the kind of
which can only be cured with a stiff drink.

We first detected the fault after upgrading to the ECS agent 1.17.0 using AWS
AMI amzn-ami-2017.09.h-amazon-ecs-optimized (ami-5e414e24) but does not occur on
earlier images, such as amzn-ami-2017.09.e-amazon-ecs-optimized (ami-13401669).

At this time, have not investigated the root cause of the issue, but rather have
been able to build this POC tool that allows the fault to be reproduced.

    1 Uploading s3://example/530b1815-01dc-4add-b89a-4db0cf3da660...
    2 Uploading s3://example/251ea219-c480-4857-94cb-0736a2a66ac8...
    3 Uploading s3://example/0949cec1-e6fa-4a3a-b4bc-2d2da5a6a024...
    4 Uploading s3://example/31efdb30-1a60-4243-b4c6-0d46ea09fe57...
    5 Uploading s3://example/1c78dbbc-aa01-42c7-994a-8b06ece260c5...
    6 Uploading s3://example/e0a3c434-25e7-4a36-85e0-ca193c90b546...
    7 Uploading s3://example/238a685d-325b-4925-8b52-751847534681...
    8 Uploading s3://example/e1561427-16d0-444a-ad78-4e884fc5ab28...
    9 Uploading s3://example/b83e9cd4-f54c-499b-a038-445d8a30d115...
    10 Uploading s3://example/de1fdd18-1b92-46e9-8961-f6fd670148c5...
    11 Uploading s3://example/d5183b91-3b21-412f-b370-7d53408e7479...
    12 Uploading s3://example/18ea17df-8ed5-4572-bb32-ecfcf92eb06d...
    13 Uploading s3://example/e23bcdc7-5105-4ae0-8e16-74737b2fc093...
    14 Uploading s3://example/cdfe7b07-0e7e-489a-b560-1299734f25bb...
    15 Uploading s3://example/57a6e6eb-3858-4e25-a5d0-371198cf79d3...
    16 Uploading s3://example/e9c88ff3-1077-4aea-b120-27068a3be9c6...
    17 Uploading s3://example/66d1d4fc-1a46-4266-9936-0920d5d82117...
    18 Uploading s3://example/7a787d9b-5034-453f-a6ad-645f654bf4db...
    19 Uploading s3://example/d6d1b7b0-c503-4ead-911b-c9dda4225715...
    bundler: failed to load command: demo.rb (demo.rb)
    Aws::Errors::MissingCredentialsError: unable to sign request without credentials set
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/request_signer.rb:104:in `require_credentials'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_request_signer.rb:14:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_host_id.rb:14:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/xml/error_handler.rb:8:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/helpful_socket_errors.rb:10:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_request_signer.rb:65:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_redirects.rb:15:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/retry_errors.rb:89:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_dualstack.rb:32:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_accelerate.rb:49:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_md5s.rb:31:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_expect_100_continue.rb:21:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_bucket_name_restrictions.rb:12:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_bucket_dns.rb:31:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/rest/handler.rb:7:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/user_agent.rb:12:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/seahorse/client/plugins/endpoint.rb:41:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/param_validator.rb:21:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/seahorse/client/plugins/raise_response_errors.rb:14:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_sse_cpk.rb:19:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_dualstack.rb:24:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/s3_accelerate.rb:34:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/jsonvalue_converter.rb:20:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/idempotency_token.rb:18:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/aws-sdk-core/plugins/param_converter.rb:20:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/seahorse/client/plugins/response_target.rb:21:in `call'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/seahorse/client/request.rb:70:in `send_request'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-core-2.10.129/lib/seahorse/client/base.rb:207:in `block (2 levels) in define_operation_methods'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-resources-2.10.129/lib/aws-sdk-resources/services/s3/file_uploader.rb:42:in `block in put_object'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-resources-2.10.129/lib/aws-sdk-resources/services/s3/file_uploader.rb:49:in `open_file'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-resources-2.10.129/lib/aws-sdk-resources/services/s3/file_uploader.rb:41:in `put_object'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-resources-2.10.129/lib/aws-sdk-resources/services/s3/file_uploader.rb:34:in `upload'
    /demo/vendor/bundle/ruby/2.3.0/gems/aws-sdk-resources-2.10.129/lib/aws-sdk-resources/services/s3/object.rb:252:in `upload_file'
    demo.rb:20:in `<top (required)>'



# What's in this repo?

This repo provides:

1. Dockerfile for building a simple container that creates files in S3 non-stop
   until it crashes with the `unable to sign request without credentials set`
   error.

2. CFN stack for creating an ECS Task with an IAM role.




# Building

    docker build . -t demo-breaking-ecs-iam


# Deploying

    # Create an S3 bucket - in the same region as ECS cluster that will be
    # running the container.
    echo "You shouldn't need me to tell you how to create an S3 bucket here..."

    # Upload to ECR
    export ACCOUNTID=`aws sts get-caller-identity | jq -r '.Account'`
    docker tag demo-breaking-ecs-iam:latest ${ACCOUNTID}.dkr.ecr.us-east-1.amazonaws.com/demo-breaking-ecs-iam:latest
    docker push ${ACCOUNTID}.dkr.ecr.us-east-1.amazonaws.com/demo-breaking-ecs-iam:latest

    # Create an ECS Task    
    aws cloudformation \
    create-stack \
    --stack-name "demo-breaking-ecs-iam" \
    --template-body file://ecs-task-setup.yaml \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM  \
    --parameters \
    ParameterKey=BucketName,ParameterValue=example

    # Create an ECS cluster using EC2 with AMI ami-5e414e24
    echo "No I didn't do this for you, write your own damn CFN stack for this."


# Executing

The CFN stack will create a Task Definition called `demo-breaking-ecs-iam`.
Provided that you've also uploaded a build of the container to ECR, it will be
ready to run.

1. Use the AWS API and/or console to run a once-off task.

2. The job will run until it crashes from the error, or until it runs to
   successful completion (1,000 successful files).

3. All output will go to CloudWatch logs - check there to see if successful or
   crashed run.

4. In our experience, the fault tends to occur almost immediately. If running on
   a working AMI, the script will run till it hits 1,000 uploads and then
   reports PASS.


# Other Notes

1. All testing performed in `us-east-1`
2. Reproduced on `c5.xlarge` and `c5.2xlarge`
3. ECS cluster inside private VPC.
4. Reproduced using AMI amzn-ami-2017.09.h-amazon-ecs-optimized (ami-5e414e24) with no modifications.
