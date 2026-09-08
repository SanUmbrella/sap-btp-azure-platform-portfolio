resource "cloudfoundry_app" "backend" {
  name       = "sap-btp-platform-probe"
  org_name   = data.cloudfoundry_org.selected.name
  space_name = data.cloudfoundry_space.selected.name

  path             = data.archive_file.backend.output_path
  source_code_hash = data.archive_file.backend.output_base64sha256

  buildpacks        = ["nodejs_buildpack"]
  command           = "npm start"
  instances         = 1
  memory            = "128M"
  disk_quota        = "1024M"
  health_check_type = "port"
  stopped           = false

  environment = {
    NODE_ENV = "production"
  }
}

resource "cloudfoundry_app" "approuter" {
  name       = "sap-btp-platform-probe-approuter"
  org_name   = data.cloudfoundry_org.selected.name
  space_name = data.cloudfoundry_space.selected.name

  path             = data.archive_file.approuter.output_path
  source_code_hash = data.archive_file.approuter.output_base64sha256

  buildpacks        = ["nodejs_buildpack"]
  command           = "npm start"
  instances         = 1
  memory            = "128M"
  disk_quota        = "1024M"
  health_check_type = "port"
  stopped           = false
}
