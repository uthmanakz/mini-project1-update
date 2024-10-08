output "frontend_a_public_ip" {
  value = aws_instance.frontend_a.public_ip
}

output "frontend_b_public_ip" {
  value = aws_instance.frontend_b.public_ip
}

output "backend_a_public_ip" {
  value = aws_instance.backend_a.public_ip
}

output "backend_b_public_ip" {
  value = aws_instance.backend_b.public_ip
}

output "database_a_public_ip" {
  value = aws_instance.database_a.public_ip
}

output "database_b_endpoint" {
  value = aws_db_instance.database_b.endpoint
}
