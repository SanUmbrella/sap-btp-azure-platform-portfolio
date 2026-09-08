resource "btp_subaccount_role_collection" "viewer" {
  subaccount_id = var.btp_subaccount_id
  name          = "PlatformProbeViewer"
  description   = "Viewer role collection for the platform probe application."

  roles = [
    {
      name                 = "Viewer"
      role_template_app_id = "platform-probe-${var.cf_space_name}"
      role_template_name   = "Viewer"
    }
  ]
}

resource "btp_subaccount_role_collection_assignment" "viewer" {
  subaccount_id        = var.btp_subaccount_id
  role_collection_name = btp_subaccount_role_collection.viewer.name
  user_name            = var.viewer_user_name
  origin               = var.viewer_origin
}
