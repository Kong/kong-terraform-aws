resource "random_string" "master_password" {
  length  = 32
  special = false
}

resource "random_string" "db_password" {
  length  = 32
  special = false
}

resource "random_string" "admin_token" {
  length  = 32
  special = false
}

resource "random_string" "session_secret" {
  length  = 32
  special = false
}
