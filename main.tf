module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
}


module "security_group" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id
}


module "ec2" {

  source = "./modules/ec2"

  subnet_id = module.vpc.public_subnet_1_id

  security_group_id = module.security_group.ec2_sg_id
}



module "alb" {

  source = "./modules/alb"

  vpc_id = module.vpc.vpc_id

  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id

  alb_sg_id = module.security_group.alb_sg_id

  instance_id = module.ec2.instance_id
}


/*
module "asg" {

  source = "./modules/asg"

  subnet_ids = [
    module.vpc.public_subnet_1_id,
    module.vpc.public_subnet_2_id
  ]

  security_group_id = module.security_group.ec2_sg_id

  target_group_arn = module.alb.target_group_arn
}
*/




