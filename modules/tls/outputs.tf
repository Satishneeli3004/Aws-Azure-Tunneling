output "public_key_openssh" {
  value = tls_private_key.ssh.public_key_openssh
}