resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}
resource "tls_self_signed_cert" "example" {
  key_algorithm   = tls_private_key.example.algorithm
  private_key_pem = tls_private_key.example.private_key_pem

  validity_period_hours = 128


  early_renewal_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
  dns_names = ["alphav1.ga", "dev.alphav1.ga"]
  subject {
    common_name  = "alphav1.ga"
    organization = "360 Ace Tech, Inc"
  }
}