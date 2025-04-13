resource "aws_vpc" "dev-rds-vpc" {          // create a vpc for database deployment
    cidr_block = var.vpc_cidr_blocks
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "dev-rds-vpc"
    }
}

resource "aws_subnet" "dev-rds-subnet1"{     // create subnet 1 in the vpc , i/p vpc id created above
    vpc_id = "${aws_vpc.dev-rds-vpc.id}"
    cidr_block = var.subnet1_cidr_blocks
    availability_zone = var.subnet1_availbility_zone
    tags = {
      Name = "dev-rds-subnet1"
    }
}

resource "aws_subnet" "dev-rds-subnet2"{    // create subnet 2 in the vpc , i/p vpc id created above
    vpc_id = "${aws_vpc.dev-rds-vpc.id}"
    cidr_block = var.subnet2_cidr_blocks
    availability_zone = var.subnet2_availbility_zone
    tags = {
      Name = "dev-rds-subnet2"
    }
}

resource "aws_db_subnet_group" "dev-rds-dbsubnetgroup" {   // create database subnet group , i/p 2 subnet ids created above
    name = "dev-rds-dbsubnetgroup"
    subnet_ids = ["${aws_subnet.dev-rds-subnet1.id}","${aws_subnet.dev-rds-subnet2.id}"] 
}

resource "aws_internet_gateway" "dev-rds-internetgateway" {  // create a internet gateway for public access 
      vpc_id = "${aws_vpc.dev-rds-vpc.id}"                   // i/p vpc id created above
      tags = {
        Name = "dev-rds-internetgateway"
      }
  }

resource "aws_route" "dev-rds-routetable-route" {               // when creating vpc default(main) route table is created
    route_table_id = aws_vpc.dev-rds-vpc.main_route_table_id    // assign that main route table to the route
    destination_cidr_block = "0.0.0.0/0"                        
    gateway_id = aws_internet_gateway.dev-rds-internetgateway.id  // i/p internet gateway id created above
  
}

resource "aws_security_group" "dev-rds-securitygroup" {  // create security group for the database
    name = "dev-rds-securitygroup"                       // i/p vpc id created above
    vpc_id = "${aws_vpc.dev-rds-vpc.id}"
}

resource "aws_vpc_security_group_ingress_rule" "dev-rds-securitygroup_ingressrule" {   // create ingress rule to allow postgres
       security_group_id = "${aws_security_group.dev-rds-securitygroup.id}"            // port 5432 from IPs
       from_port = 5432                                                                // i/p security group id created above
       to_port = 5432                                                                  // i/p my local ip address
       ip_protocol = "tcp"
       cidr_ipv4 = "58.84.60.14/32" 
}

resource "aws_vpc_security_group_egress_rule" "dev-rds-securitygroup_egressrule" {   // create egress rule to allow all
       security_group_id = "${aws_security_group.dev-rds-securitygroup.id}"          // i/p security group id created above
       cidr_ipv4 = "0.0.0.0/0" 
       ip_protocol = "-1"
}

resource "aws_db_parameter_group" "dev-rds-bosdevdb-parametergroup-v15" {   // create database parrameter group 
    name = "dev-rds-bosdevdb-parametergroup-v15"                           // for postgres 15 version
    family = "postgres15"
    parameter {
       name = "shared_preload_libraries"
       value = "pg_stat_statements,pg_cron,pgaudit"
       apply_method = "pending-reboot"
    }
    parameter {
      name = "pgaudit.role"
      value = "rds_pgaudit"
      apply_method = "immediate"
    }

}

resource "aws_db_parameter_group" "dev-rds-bosdevdb-parametergroup-v16" { // create database parrameter group
    name = "dev-rds-bosdevdb-parametergroup-v16"                          // for postgres 16 version
    family = "postgres16"
    parameter {
       name = "shared_preload_libraries"
       value = "pg_stat_statements,pg_cron,pgaudit"
       apply_method = "pending-reboot"
    }
    parameter {
      name = "pgaudit.role"
      value = "rds_pgaudit"
      apply_method = "immediate"
    }
}

resource "aws_db_instance" "dev-rds-bosdevdb" {     // create postgres rds database 
    identifier = "bosdevdb01"                       
    allocated_storage = 20
    engine = var.engine
    engine_version = var.engine_version
    instance_class = var.instance_class
    parameter_group_name = "${aws_db_parameter_group.dev-rds-bosdevdb-parametergroup-v15.name}"  // i/p parameter group name
    apply_immediately = true                                                                     // created above
    db_name = "bosdb"
    db_subnet_group_name = "${aws_db_subnet_group.dev-rds-dbsubnetgroup.name}"  // i/p database subnet group name
    username = var.master_username                                              // created above
    password = var.master_password
    publicly_accessible = true
    skip_final_snapshot = true
    vpc_security_group_ids = ["${aws_security_group.dev-rds-securitygroup.id}"]  // i/p security group id 
    allow_major_version_upgrade = true                                           // created above
}