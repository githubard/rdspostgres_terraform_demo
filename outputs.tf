output "dev_rds_vpc" {
   value = aws_vpc.dev-rds-vpc.id  
}

output "dev_rds_subnet1" {
  value = aws_subnet.dev-rds-subnet1.id
}

output "dev_rds_subnet2" {
    value = aws_subnet.dev-rds-subnet2.id
}

output "dev_rds_subnetgroup" {
  value = aws_db_subnet_group.dev-rds-dbsubnetgroup.name
}

output "dev_rds_internetgateway" {
   value = aws_internet_gateway.dev-rds-internetgateway.id
}

output "dev_rds_bosdevdb_parameter_group_name" {
    value = aws_db_parameter_group.dev-rds-bosdevdb-parametergroup.name
}

output "dev_rds_bosdevdb01_id" {
    value = aws_db_instance.dev-rds-bosdevdb.identifier
}
