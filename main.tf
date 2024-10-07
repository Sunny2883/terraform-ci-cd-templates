module "vpc" {
  source                      = "./Modules/VPC"
  create_public_subnet       = true
  create_private_subnet      = true
  create_private_with_internet_access = true
  vpc_cidr                   = "10.0.0.0/16"
  public_subnet_cidrs        = ["10.0.5.0/24", "10.0.6.0/24"]  
  availability_zones         = ["ap-south-1a", "ap-south-1b"]
  private_subnet_cidrs       = ["10.0.7.0/24", "10.0.8.0/24"]
  
}

module "SG" {
  source = "./Modules/SG"
  vpc_id =  module.vpc.vpc_id
  security_name = "sg"
}

module "database" {
   source                 = "./Modules/Database"
  engine                 = "postgres"
  engine_version         = "12.16"
  vpc_security_group_ids = [module.SG.security_group_id]
  username               = "assign"
  allocated_storage      = 20
  db_name                = "templatedb"
  instance_class         = "db.t3.micro"
  identifier = "template-db-instance"
  is_public= true
  public_subnet_ids = module.vpc.public_subnet_ids_output  # Directly pass the output
  private_subnet_ids = module.vpc.private_subnet_ids_output  # Directly pass the output
  private_internet_subnet_ids = module.vpc.private_internet_subnet_ids  # Directly pass the output
  use_private_internet_access= false
}
 
module "s3" {
  source = "./Modules/S3"
}

module "alb" {
  source = "./Modules/ALB"
  subnets=module.vpc.public_subnet_ids_output
  security_groups=[module.SG.security_group_id]
  use_fargate=false
  vpc_id=module.vpc.vpc_id
}

module "asg" {
  source = "./Modules/ASG"
  image_id                  = "ami-07c0f8a42b483e4cf"
  subnet                    = module.vpc.public_subnet_ids_output
  security_group_id         = module.SG.security_group_id
  load_balancer             = module.alb.alb_arn
  health_check_type         = "EC2"
  desired_capacity          = 2
  asg_name                  = "asg_template"
  min_size                  = 2
  max_size                  = 3
  name                      = ""
  instance_type             = "t2.micro"
  keyname                   = "Project"
  target_group_arn          = module.alb.backend_target_group_arn
  alb_arn                   = module.alb.alb_arn
  user_data                 = filebase64("./userdata.sh")
  use_fargate = false
  iam_instance_profile_name = module.Policy.ecs_instance_profile_name
}
module "Policy" {
  source = "./Modules/Policy"
}

module "cluster" {
  source = "./Modules/Cluster"
  cluster_name                 = "cluster_template"
  family_name                  = "template_family_1"
  container_name                    = "template_task_1"
  memory                       = 256
  cpu                          = 128
  image_url                    = "nginx:latest"
  execution_role_arn           = module.Policy.ecs_task_execution_role_arn
  task_role_arn                = module.Policy.ecs_task_role_arn
  auto_scaling_group_arn       = module.asg.asg_arn
  use_fargate = false
}

module "ecs" {
  source = "./Modules/ECS"
  ecs_service_name = "Service_template"
  desired_count    = 2
  task_definition  = module.cluster.task_definition
  cluster_arn      = module.cluster.cluster_arn
  use_fargate = false
  subnets = module.vpc.public_subnet_ids_output
  security_group_id = module.SG.security_group_id
  ec2_target_group_arn = module.alb.backend_target_group_arn
  fargate_target_group_arn = module.alb.backend_target_group_arn
}

module "cloudFront" {
  source = "./Modules/CloudFront"
  domain_name = "terraform-template-bucket.s3-website.ap-south-1.amazonaws.com"
  acm_certificate_arn="arn:aws:acm:us-east-1:396608771618:certificate/82ed56de-b8be-463e-bf43-1331b018b205"
}