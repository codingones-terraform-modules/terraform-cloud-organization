resource "tfe_organization" "organization" {
  name  = var.terraform_organization
  email = var.organization_email
}

resource "tfe_workspace" "iam" {
  name         = "iam"
  organization = tfe_organization.organization.name
  tag_names    = ["admin", "iam"]
}

resource "tfe_variable" "iam_deployer_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.organization_iam_deployer_aws_access_key_id
  category     = "env"
  workspace_id = tfe_workspace.iam.id
  description  = "${var.terraform_organization}.iam.deployer access key id"
  sensitive    = true
}

resource "tfe_variable" "iam_deployer_access_key_secret" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.organization_iam_deployer_aws_secret_access_key
  category     = "env"
  workspace_id = tfe_workspace.iam.id
  description  = "${var.terraform_organization}.iam.deployer secret access key"
  sensitive    = true
}

data "tfe_team" "owners" {
  name         = "owners"
  organization = var.terraform_organization

  depends_on = [tfe_organization.organization]
}

resource "tfe_team_token" "team_token" {
  team_id          = data.tfe_team.owners.id
  force_regenerate = true
}

resource "tfe_variable_set" "variables" {
  name         = "variables"
  description  = "Variables accessible to all the workspaces"
  global       = true
  organization = tfe_organization.organization.name

  depends_on = [tfe_organization.organization]
}

resource "tfe_variable" "tfe_team_token" {
  key             = "tfe_team_token"
  value           = tfe_team_token.team_token.token
  category        = "terraform"
  description     = "The organization team api token"
  variable_set_id = tfe_variable_set.variables.id
}

resource "tfe_variable" "organization_variables" {
  for_each = var.terraform_organization_variables

  key             = each.key
  value           = each.value.hcl ? jsonencode(each.value.value) : tostring(each.value.value)
  category        = "terraform"
  description     = each.value.description
  variable_set_id = tfe_variable_set.variables.id
  hcl             = each.value.hcl
  sensitive       = each.value.sensitive
}