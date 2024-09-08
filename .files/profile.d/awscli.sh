command -v aws > /dev/null || return

AWS_CONFIG=${AWS_CONFIG:-"$HOME/.aws/config"}

# ------------------------------
# default region
# ------------------------------
AWS_DEFAULT_REGION="${AWS_REGION}"
[ "${AWS_DEFAULT_REGION}" ] || {
  # AWS_DEFAULT_REGION="$(curl --connect-timeout 1 -fsq http://169.254.169.254/latest/meta-data/placement/region)"
  AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-'us-east-1'}
}
AWS_REGION=$AWS_DEFAULT_REGION
export AWS_DEFAULT_REGION AWS_REGION

# ------------------------------
# create default config (once)
# ------------------------------
[ -f "$AWS_CONFIG" ] && return
mkdir -p "${AWS_CONFIG%/*}"
aws configure set default.s3.signature_version s3v4
aws configure set default.s3.max_queue_size 10000
aws configure set default.s3.multipart_threshold 64mb
aws configure set default.s3.multipart_chunksize 16mb
aws configure set default.s3.max_concurrent_requests 20

