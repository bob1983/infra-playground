name    = "fleet-sample"
profile = "bob"
region  = "ap-northeast-1"
key_name = "myec2key"

prices  = {
  "default"   = "0.067"
  "m3_medium" = "0.03"
  "c3_large"  = "0.04"
}

instance_types = {
  "m3_medium" = "m3.medium"
  "c3_large"  = "c3.large"
}

vpc_id = "vpc-0586736d"
