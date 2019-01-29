resource "aws_s3_bucket" "cached_bucket" {

    acl    = "public-read"

}
resource "aws_s3_bucket_object" "object1" {

    bucket = "${aws_s3_bucket.cached_bucket.id}"
    key    = "js-0.1.js"
    source = "js-0.1.js"
    etag   = "${md5(file("js-0.1.js"))}"
    acl = "public-read"

}

resource "aws_s3_bucket_object" "object2" {

    bucket = "${aws_s3_bucket.cached_bucket.id}"
    key    = "js-0.2.js"
    source = "js-0.2.js"
    etag   = "${md5(file("js-0.2.js"))}"
    acl = "public-read"


}
output "bucket_endpoint" {

  value = "${aws_s3_bucket.cached_bucket.bucket_domain_name}"

}