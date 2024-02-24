provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_kms_key" "my_kms_key" {
  description             = "MyKMSKeyDescription"
  deletion_window_in_days = 7
  policy                  = <<-EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "my_kms_key_alias" {
  name          = "alias/MyKMSKeyAlias"
  target_key_id = aws_kms_key.my_kms_key.id
}
