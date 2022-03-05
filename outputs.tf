output "ec2_complete_public_dns" {
  description = "The public DNS name assigned to the instance."
  value       = module.sorrowset_ec2.*.public_dns
}

output "ec2_complete_public_ip" {
  description = "The public IP address assigned to the instance."
  value       = module.sorrowset_ec2.*.public_ip
}