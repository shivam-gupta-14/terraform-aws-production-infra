output "vpc_id" {
  value = module.vpc.vpc_id
}



output "ec2_public_ip" {
  value = module.ec2.public_ip
}



output "alb_dns_name" {
  value = module.alb.alb_dns_name
}



