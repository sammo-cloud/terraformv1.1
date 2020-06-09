output "management_server_public_ip" {
   value = data.aws_instance.ins_management.public_ip
}

output "member_a_id" {
   value = data.aws_instance.ins_gc_member_a.id
}

output "member_a_public" {
   value = data.aws_network_interface.nic_gc_member_a_public.id
}
