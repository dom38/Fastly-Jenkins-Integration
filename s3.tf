resource "aws_s3_bucket" "cached_bucket" {

    acl    = "public-read"

}

output "bucket_endpoint" {

  value = "${aws_s3_bucket.cached_bucket.bucket_domain_name}"
  
}