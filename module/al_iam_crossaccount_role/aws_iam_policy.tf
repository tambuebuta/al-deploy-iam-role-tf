// Specify the provider and alternative access details below if needed

//Create IAM role

resource "aws_iam_role" "alertlogic-role" {
  name = "AlertLogic-Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.alert_logic_aws_account_id}:root"
      },
      "Condition": {
        "StringEquals": {"sts:ExternalId": "${var.alert_logic_external_id}"}
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

//Create IAM ploicy

resource "aws_iam_policy" "alertlogic-policy" {
  name        = "al-policy"
  path        = "/"
  description = "Alert Logic  Policy"

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "EnabledDiscoveryOfVariousAWSServices",
			"Resource": "*",
			"Effect": "Allow",
			"Action": [
				"autoscaling:Describe*",
				"cloudformation:DescribeStack*",
				"cloudformation:GetTemplate",
				"cloudformation:ListStack*",
				"cloudfront:Get*",
				"cloudfront:List*",
				"cloudwatch:Describe*",
				"config:DeliverConfigSnapshot",
				"config:Describe*",
				"config:Get*",
				"config:ListDiscoveredResources",
				"cur:DescribeReportDefinitions",
				"directconnect:Describe*",
				"dynamodb:ListTables",
				"ec2:Describe*",
				"elasticbeanstalk:Describe*",
				"elasticache:Describe*",
				"elasticloadbalancing:Describe*",
				"elasticmapreduce:DescribeJobFlows",
				"events:Describe*",
				"events:List*",
				"glacier:ListVaults",
				"guardduty:Get*",
				"guardduty:List*",
				"kinesis:Describe*",
				"kinesis:List*",
				"kms:DescribeKey",
				"kms:GetKeyPolicy",
		        	"kms:GetKeyRotationStatus",
				"kms:ListAliases",
				"kms:ListGrants",
				"kms:ListKeys",
				"kms:ListKeyPolicies",
				"kms:ListResourceTags",
				"lambda:List*",
				"logs:Describe*",
				"rds:Describe*",
				"rds:ListTagsForResource",
				"redshift:Describe*",
				"route53:GetHostedZone",
				"route53:ListHostedZones",
				"route53:ListResourceRecordSets",
				"sdb:DomainMetadata",
				"sdb:ListDomains",
				"sns:ListSubscriptions",
				"sns:ListSubscriptionsByTopic",
				"sns:ListTopics",
				"sns:GetEndpointAttributes",
				"sns:GetSubscriptionAttributes",
				"sns:GetTopicAttributes",
				"s3:ListAllMyBuckets",
				"s3:ListBucket",
				"s3:GetBucketLocation",
				"s3:GetObject",
				"s3:GetBucket*",
				"s3:GetLifecycleConfiguration",
				"s3:GetObjectAcl",
				"s3:GetObjectVersionAcl",
				"tag:GetResources",
				"tag:GetTagKeys"
			]
		},
		{
			"Sid": "EnableInsightDiscovery",
			"Resource": "*",
			"Effect": "Allow",
			"Action": [
				"iam:Get*",
				"iam:List*",
				"iam:GetPolicyVersion",
				"iam:GetPolicy",
				"iam:ListRolePolicies",
				"iam:ListAttachedRolePolicies",
				"iam:ListRoles",
				"iam:GetRolePolicy",
				"iam:GetAccountSummary",
				"iam:GenerateCredentialReport"
			]
		},
		{
			"Sid": "EnableCloudTrailIfAccountDoesntHaveCloudTrailsEnabled",
			"Resource": "*",
			"Effect": "Allow",
			"Action": [
				"cloudtrail:DescribeTrails",
				"cloudtrail:GetEventSelectors",
				"cloudtrail:GetTrailStatus",
				"cloudtrail:ListPublicKeys",
				"cloudtrail:ListTags",
				"cloudtrail:LookupEvents",
				"cloudtrail:StartLogging",
				"cloudtrail:UpdateTrail"
			]
		},
		{
			"Sid": "CreateCloudTrailS3BucketIfCloudTrailsAreBeingSetupByAlertLogic",
			"Resource": "arn:aws:s3:::outcomesbucket-*",
			"Effect": "Allow",
			"Action": [
				"s3:CreateBucket",
				"s3:PutBucketPolicy",
				"s3:DeleteBucket"
			]
		},
		{
			"Sid": "CreateCloudTrailsTopicTfOneWasntAlreadySetupForCloudTrails",
			"Resource": "arn:aws:sns:*:*:outcomestopic",
			"Effect": "Allow",
			"Action": [
				"sns:CreateTopic",
				"sns:DeleteTopic"
			]
		},
		{
			"Sid": "MakeSureThatCloudTrailsSnsTopicIsSetupCorrectlyForCloudTrailPublishingAndSqsSubsription",
			"Resource": "arn:aws:sns:*:*:*",
			"Effect": "Allow",
			"Action": [
				"sns:addpermission",
				"sns:gettopicattributes",
				"sns:listtopics",
				"sns:settopicattributes",
				"sns:subscribe"
			]
		},
		{
			"Sid": "CreateAlertLogicSqsQueueToSubscribeToCloudTrailsSnsTopicNotifications",
			"Resource": "arn:aws:sqs:*:*:outcomesbucket*",
			"Effect": "Allow",
			"Action": [
				"sqs:CreateQueue",
				"sqs:DeleteQueue",
				"sqs:SetQueueAttributes",
				"sqs:GetQueueAttributes",
				"sqs:ReceiveMessage",
				"sqs:DeleteMessage",
				"sqs:GetQueueUrl"
			]
		},
		{
			"Sid": "BeAbleToListSQSForCloudTrail",
			"Resource": "*",
			"Effect": "Allow",
			"Action": [
				"sqs:ListQueues"
			]
		},
		{
			"Sid": "EnableAlertLogicApplianceStateManagement",
			"Resource": "arn:aws:ec2:*:*:instance/*",
			"Effect": "Allow",
			"Condition": {
				"StringEquals": {
					"ec2:ResourceTag/AlertLogic": "Security"
				}
			},
			"Action": [
				"ec2:GetConsoleOutput",
				"ec2:GetConsoleScreenShot",
				"ec2:StartInstances",
				"ec2:StopInstances",
				"ec2:TerminateInstances"
			]
		},
		{
			"Sid": "EnableAlertLogicAutoScalingGroupManagement",
			"Resource": "arn:aws:autoscaling:*:*:autoScalingGroup/*",
			"Effect": "Allow",
			"Condition": {
				"StringEquals": {
					"ec2:ResourceTag/AlertLogic": "Security"
				}
			},
			"Action": [
				"autoscaling:UpdateAutoScalingGroup"
			]
		}
	]
}
EOF
}

//Link policy to role

resource "aws_iam_role_policy_attachment" "alertlogic-role-policy-attachment" {
  role       = "${aws_iam_role.alertlogic-role.name}"
  policy_arn = "${aws_iam_policy.alertlogic-policy.arn}"
}
