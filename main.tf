// Specify the provider and alternative access details below if needed

provider "aws" {
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "${var.aws_cred_file}"
  region                  = "${var.aws_region}"
  version                 = ">= 1.6"
}

provider "template" {
  version = "~> 1.0"
}

module "alertlogic_seamless_role" {
  source = "module/al_iam_crossaccount_role"
  alert_logic_aws_account_id = "${var.alert_logic_aws_account_id}"
  alert_logic_external_id = "${var.alert_logic_external_id}"
}
