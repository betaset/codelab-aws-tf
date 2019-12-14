# This is the bucket all terraform state files will live in.
resource "aws_s3_bucket" "state" {
  bucket = local.tfstate_bucket_name

  # Encrypt all files on server side by default.
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Keep old versions of all objects.
  # This allows reviewing changes.
  versioning {
    enabled = true
  }

  # Remove old versions after 7d.
  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = 7
    }
    abort_incomplete_multipart_upload_days = 2
  }

  tags = local.default_tags
}

# This table will hold all terraform locks.
# This prevents concurrent deployments on a single terraform project.
resource "aws_dynamodb_table" "terraform_state_lock" {
  name = local.tfstate_dynamodb_table

  # minimum read/write capacity is enough
  read_capacity = 1
  write_capacity = 1

  # this
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.default_tags
}
