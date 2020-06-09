output "Admin_UI" {
  value = "https://${aws_eip.eip_TPOT_public.public_dns}:64294/"
}

output "SSH_Access" {
  value = "ssh -i {private_key_file} -p 64295 admin@${aws_eip.eip_TPOT_public.public_dns}"
}

output "Web_UI" {
  value = "https://${aws_eip.eip_TPOT_public.public_dns}:64297/"
}

