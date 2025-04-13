
# creation of postgresql rds database using terrraform


# Files :

1) providers.tf -> used for provider configurations.
2) vars.tf -> used to declare variables used in the resource blocks.
3) terraform.tfvars -> used to define(asiign) values of variables used in the resource blocks.
4) rds.tf -> main file used to define the resources to be created in the target cloud platform.
5) outputs.tf -> used to generate the output after apply operation. 


# Resuources created :

1) VPC  -> all the resources reside in this vpc.
2) Subnets -> 2 subnets within the VPC.
3) Database subnet group -> with 2 subnets created above.
4) Internet gateway -> for public access for the vpc created above.
5) Route -> when a vpc is created , by default main route table is created.
            assign that route table route to internet gateway created above.
6) Security Group -> to allow access to the database created
7) ingress rule -> inside the security group to allow access inside the resource(database)
8) Egress rule -> inside the security group to allow access from the resource(database)
9) Database Parameter group 
10) RDS Database


# Updated needed :

1)  master_password = "*********"  in terraform.tfvars


# Running through terraform :

    terraform init  - initialise

    terraform plan  - check the resources created

    terraform apply  - create the resources

    terraform destroy - destroy the resources