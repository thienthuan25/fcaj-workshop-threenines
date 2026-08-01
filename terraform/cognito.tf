resource "aws_cognito_user_pool" "dashboard" {
  name = "${var.project_name}-dashboard-users"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # Dashboard chỉ dành cho user do quản trị viên tạo.
  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }
}

resource "aws_cognito_user_pool_client" "dashboard" {
  name         = "${var.project_name}-dashboard-web"
  user_pool_id = aws_cognito_user_pool.dashboard.id

  generate_secret = false
  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]

  # Hosted UI sử dụng OAuth authorization-code flow. Public browser client
  # không có client secret; frontend tạo PKCE verifier cho mỗi lần đăng nhập.
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls = [
    "https://${aws_cloudfront_distribution.web.domain_name}/"
  ]
  logout_urls = [
    "https://${aws_cloudfront_distribution.web.domain_name}/"
  ]
}

# Amazon Cognito managed login (Hosted UI) domain.
resource "aws_cognito_user_pool_domain" "dashboard" {
  domain       = "${var.project_name}-${data.aws_caller_identity.current.account_id}"
  user_pool_id = aws_cognito_user_pool.dashboard.id
}