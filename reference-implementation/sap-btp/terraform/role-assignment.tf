resource "btp_subaccount_role_collection_assignment" "viewer" {
  subaccount_id        = var.btp_subaccount_id
  role_collection_name = "SAP BTP Platform Probe Viewer"
  user_name            = var.viewer_user_name
  origin               = var.viewer_origin

  depends_on = [
    cloudfoundry_service_instance.xsuaa
  ]
}
