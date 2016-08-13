output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.main.cidr_block}"
}

output "public_subnet_cidrs" {
  value = "${join(",", aws_subnet.public.*.cidr_block)}"
}

output "private_subnet_cidrs" {
  value = "${join(",", aws_subnet.private.*.cidr_block)}"
}

output "public_subnet_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private_subnet_ids" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "db_subnet_group_id" {
  value = "${aws_db_subnet_group.main.id}"
}

output "db_subnet_group_arn" {
  value = "${aws_db_subnet_group.main.arn}"
}

output "elasticache_subnet_group_id" {
  value = "${aws_elasticache_subnet_group.main.id}"

}

output "main_route_table_id" {
  value = "${aws_route_table.main.id}"
}
