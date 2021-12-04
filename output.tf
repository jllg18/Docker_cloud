output "PublicIp" {
  value = aws_instance.docker-voting.public_ip
}

output "key_name" {
  value = aws_key_pair.dockervot.key_name
}

output "key_pem" {
  value = tls_private_key.Dockervot1.private_key_pem
  sensitive = true
  }

output "key_fingerpint" {
  value = aws_key_pair.dockervot.fingerprint
}