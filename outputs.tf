output "tfe_team_token" {
  value     = tfe_team_token.team_token.token
  sensitive = true
}