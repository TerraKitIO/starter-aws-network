# Declare the data source
data "aws_availability_zones" "main" {}

resource "aws_vpc" "main" {
  cidr_block = "10.${var.vpc_cidr_second_octet}.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-main-gw"
  }
}

resource "aws_route_table" "main" {
  # Main route table, default for new subnets which don't specify their own
  # route table.
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-main-routes"
  }
}

resource "aws_route" "internet" {
  # Provides a route to the internet through the main gateway. This route will
  # be attached to public subnets
  route_table_id = "${aws_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

resource "aws_main_route_table_association" "main" {
  vpc_id = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_vpc_endpoint" "s3" {
  # An endpoint for private traffic routing to Amazon S3. For more information:
  # http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-endpoints.html
  vpc_id = "${aws_vpc.main.id}"
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = ["${aws_route_table.main.id}"]
}

## Subnets

resource "aws_subnet" "public" {
  # Public subnets are subnets that are publicly routable and addressable.  Most
  # starter kit users will leverage these the most.
  count = "${var.num_azs}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.${var.vpc_cidr_second_octet}.${(count.index * 10) + var.public_cidr_third_octet}.0/24"
  availability_zone = "${data.aws_availability_zones.main.names[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name}-public-${data.aws_availability_zones.main.names[count.index]}-subnet"
    Type = "public"
    Env  = "${var.name}"
  }

  depends_on = ["aws_main_route_table_association.main"]
}

resource "aws_subnet" "private" {
  # Private subnets are not internet addressable or routable.
  count = "${var.num_azs}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.${var.vpc_cidr_second_octet}.${(count.index * 10) + var.private_cidr_third_octet}.0/24"
  availability_zone = "${data.aws_availability_zones.main.names[count.index]}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.name}-private-${data.aws_availability_zones.main.names[count.index]}-subnet"
    Type = "public"
    Env  = "${var.name}"
  }

  depends_on = ["aws_main_route_table_association.main"]
}


## Subnet Groups

resource "aws_db_subnet_group" "main" {
  # Database subnet group.
  name = "${var.name}-db-subnets"
  description = "Main DB subnet group for ${var.name}"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  tags {
    Name = "${var.name}-db-subnet-group"
    Env  = "${var.name}"
  }
}

resource "aws_elasticache_subnet_group" "main" {
  # ElasticCache subnet group.
  name = "${var.name}-cache-subnets"
  description = "Main ElasticCache subnet groups"
  subnet_ids = ["${aws_subnet.public.*.id}"]
}
