resource "random_string" "master_password" {
  length  = 64
  special = false
}

resource "random_string" "db_password" {
  length  = 64
  special = false
}

resource "random_string" "admin_token" {
  length  = 64
  special = false
}

resource "random_string" "session_secret" {
  length  = 64
  special = false
}
