data "archive_file" "backend" {
  type        = "zip"
  source_dir  = "${path.module}/../application"
  output_path = "${path.module}/.build/backend.zip"

  excludes = [
    "node_modules",
    "node_modules/**",
    ".git",
    ".git/**",
    "*.log"
  ]

  output_file_mode = "0666"
}

data "archive_file" "approuter" {
  type        = "zip"
  source_dir  = "${path.module}/../approuter"
  output_path = "${path.module}/.build/approuter.zip"

  excludes = [
    "node_modules",
    "node_modules/**",
    ".git",
    ".git/**",
    "*.log"
  ]

  output_file_mode = "0666"
}
