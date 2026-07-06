#!/bin/bash

############################################################################################################################
# Description: This script used to list aws resources
# Author: DevOps Team/Syed Dadapeer
# Version: 0.0.1
#
# Below are the services that are supported by this script:
# 1. IAM
# 2. VPC (for "Subnets + Route Table + IGW + NAT": type "VPC and more")
# 3. EC2 (along with Security Groups)
# 4. S3
# 5. EBS
# 6. LoadBalancer (along with Target Groups)
# 7. Lambda
# 8. RDS
# 9. DynamoDB
# 10. SNS
# 11. CodeCommiit
# 12. CodeBuild
# 13. CodeDeploy
# 14. CodePipeline
# 15. ECR
# 16. ECS
# 17. EKS
# 18. CloudFormation
# 19. CloudFront
# 20. Route 53
# 21. CloudWatch
#
# The script will prompt the user to enter the AWS region and the service for which the resources need to be listed.
#
# Usage: ./aws_resource_list.sh <aws_service> <aws_region>
# Example: ./aws_resource_list.sh ec2 us-east-1
#
# Note: If you don't mention/specify aws region. By default, it will take from AWS CLI configured region.
############################################################################################################################

source ./spinner.sh

spinner_start "Fetching AWS Account details..."

# Check if the required number of arguments are passed
if [[ $# -ne 1 && $# -ne 2 ]]; then
  spinner_stop "fail" && \
  printf "\e[31m👉 Usage: ./aws_resource_lish.sh <aws_service> <aws_region> \e[0m \n"
  printf "\e[33m👍 Example:\e[0m ./aws_resource_lish.sh ec2 ap-south-1 \n"
  printf "\e[36mℹ️ If you don't mention/specify aws region. By default, it will take from AWS CLI configured region.\e[0m \n"
  exit 1
fi

# Assign the arguments to variables and convert the service to lowercase
aws_service=${1,,}

DEFAULT_REGION=$(cat /home/$USER/.aws/config | awk  'NR==2 { print $3 }')
aws_region=${2:-$DEFAULT_REGION}

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
  spinner_stop "fail" && \
  printf "\e[31m💔 AWS CLI is not installed. Please install the AWS CLI and try again.\e[0m\n"
  printf "\e[34m⬇️ Install AWS CLI:\e[0m https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html \n"
	exit 1
fi

# Check if the AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
  spinner_stop "fail" && \
  printf "\e[31m🤷‍♂️ AWS CLI is not authenticated. Please run 'aws configure'.\e[0m \n"
  exit 1
fi

spinner_stop "done"

case $aws_service in
  iam)
      spinner_start "Fetching AWS Service (IAM)..."
      IAM_COUNT=$(aws iam list-users --region $aws_region --query "length(Users)" --output text)
      spinner_stop
      printf "\e[32m✓ Total IAM users in $aws_region:\e[0m $IAM_COUNT\n"
      printf "\e[36m📋 List of IAM in $aws_region: \e[0m\n"
      aws iam list-users --region $aws_region --output table --no-cli-pager
      ;;
  vpc)
      spinner_start "Fetching AWS Service (VPC)..."
      VPC_COUNT=$(aws ec2 describe-vpcs --region $aws_region --query "length(Vpcs)" --output text)
      spinner_stop
      printf "\e[32m✓ Total VPC's in $aws_region:\e[0m $VPC_COUNT\n"
      printf "\e[36m📋 List of VPC in $aws_region: \e[0m\n"
      aws ec2 describe-vpcs --region $aws_region --output table --no-cli-pager
      printf "\e[36mℹ️ For more details about VPC along with \"Subnets, Route Table, IGW, NAT, NACLs\" type:\e[0m \"VPC and more\" \n"
      ;;
  "vpc and more")
      spinner_start "Fetching AWS Service (VPC and more)..."
      VPC_COUNT=$(aws ec2 describe-vpcs --region $aws_region --query "length(Vpcs)" --output text)
      VPC_SUBNETS=$(aws ec2 describe-subnets --region $aws_region --query "length(Subnets)" --output text)
      VPC_ROUTE_TABLE=$(aws ec2 describe-route-tables --region $aws_region --query "length(RouteTables)" --output text)
      VPC_IGW=$(aws ec2 describe-internet-gateways --region $aws_region --query "length(InternetGateways)" --output text)
      VPC_NAT=$(aws ec2 describe-nat-gateways --region $aws_region --query "length(NatGateways)" --output text)
      VPC_NACL=$(aws ec2 describe-network-acls --region $aws_region --query "length(NetworkAcls)" --output text)
      spinner_stop
      printf "\e[32m✓ Total VPC's in $aws_region:\e[0m $VPC_COUNT\n"
      printf "\e[32m✓ Total Subnets in $aws_region:\e[0m $VPC_SUBNETS\n"
      printf "\e[32m✓ Total Route Table in $aws_region:\e[0m $VPC_ROUTE_TABLE\n"
      printf "\e[32m✓ Total IGW in $aws_region:\e[0m $VPC_IGW\n"
      printf "\e[32m✓ Total NAT in $aws_region:\e[0m $VPC_NAT\n"
      printf "\e[32m✓ Total Network ACLs in $aws_region:\e[0m $VPC_NACL\n"
      printf "\e[36m📋 List of VPC and more in $aws_region: \e[0m\n"
      printf "\e[35m1️⃣  [VPC]\e[0m\n"
      aws ec2 describe-vpcs --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [Subnets]\e[0m\n"
      aws ec2 describe-subnets --region $aws_region --output table --no-cli-pager
      printf "\e[35m3️⃣  [Route Table]\e[0m\n"
      aws ec2 describe-route-tables --region $aws_region --output table --no-cli-pager
      printf "\e[35m4️⃣  [IGW]\e[0m\n"
      aws ec2 describe-internet-gateways --region $aws_region --output table --no-cli-pager
      printf "\e[35m5️⃣  [NAT]\e[0m\n"
      aws ec2 describe-nat-gateways --region $aws_region --output table --no-cli-pager
      printf "\e[35m6️⃣  [Network ACLs]\e[0m\n"   
      aws ec2 describe-network-acls --region $aws_region --output table --no-cli-pager
      ;;
  ec2)
      spinner_start "Fetching AWS Service (EC2)..."
      EC2_TOTAL=$(aws ec2 describe-instances --region $aws_region --query "length(Reservations[].Instances[])" --output text)
      EC2_RUNNING=$(aws ec2 describe-instances --region $aws_region --filters "Name=instance-state-name,Values=running" --query "length(Reservations[].Instances[])" --output text)
      spinner_stop
      printf "\e[32m✓ Total EC2 Instances in $aws_region:\e[0m $EC2_TOTAL\n"
      printf "\e[32m⏳ Running Instances in $aws_region:\e[0m $EC2_RUNNING\n"
      printf "\e[36m📋 List of EC2 in $aws_region: \e[0m\n"
      aws ec2 describe-instances --region $aws_region --output table --no-cli-pager
      printf "\e[36mℹ️ For more details about EC2 along with Security Groups\" type:\e[0m \"EC2 with SG\" \n"
      ;;
  "ec2 with sg")
      spinner_start "Fetching AWS Service (EC2 along with Security Groups)..."
      EC2_TOTAL=$(aws ec2 describe-instances --region $aws_region --query "length(Reservations[].Instances[])" --output text)
      EC2_RUNNING=$(aws ec2 describe-instances --region $aws_region --filters "Name=instance-state-name,Values=running" --query "length(Reservations[].Instances[])" --output text)
      EC2_SG=$(aws ec2 describe-security-groups --region $aws_region --query "length(SecurityGroups)" --output text)
      spinner_stop
      printf "\e[32m✓ Total EC2 Instances in $aws_region:\e[0m $EC2_TOTAL\n"
      printf "\e[32m⏳ Running Instances in $aws_region:\e[0m $EC2_RUNNING\n"
      printf "\e[32m𑗐 Security Groups in $aws_region:\e[0m $EC2_SG\n"
      printf "\e[36m📋 List of EC2 along with Security Groups in $aws_region: \e[0m\n"
      printf "\e[35m1️⃣  [EC2]\e[0m\n"
      aws ec2 describe-instances --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [Security Groups]\e[0m\n"
      aws ec2 describe-security-groups --region $aws_region --output table --no-cli-pager
      ;;
  s3)
      spinner_start "Fetching AWS Service (S3)..."
      S3_COUNT=$(aws s3api list-buckets --region $aws_region --query "length(Buckets)" --output text)
      spinner_stop
      printf "\e[32m✓ Total S3 Buckets in $aws_region:\e[0m $S3_COUNT\n"
      printf "\e[36m📋 List of S3 Buckets in $aws_region: \e[0m\n"
      aws s3api list-buckets --region $aws_region --output table --no-cli-pager
      ;;
  ebs)
      spinner_start "Fetching AWS Service (EBS)..."
      EBS_COUNT=$(aws ec2 describe-volumes --region $aws_region --query "length(Volumes)" --output text)
      spinner_stop
      printf "\e[32m✓ Total EBS in $aws_region:\e[0m $EBS_COUNT\n"
      printf "\e[36m📋 List of EBS in $aws_region: \e[0m\n"
      aws ec2 describe-volumes --region $aws_region --output table --no-cli-pager
      ;;
  elb | lb)
      spinner_start "Fetching AWS Service (ELB)..."
      ELB_COUNT=$(aws elbv2 describe-load-balancers --region $aws_region --query "length(LoadBalancers)" --output text)
      spinner_stop
      printf "\e[32m✓ Total ELB in $aws_region:\e[0m $ELB_COUNT\n"
      printf "\e[36m📋 List of ELB in $aws_region: \e[0m\n"
      aws elbv2 describe-load-balancers --region $aws_region --output table --no-cli-pager
      printf "\e[36mℹ️ For more details about ELB along with Target Groups\" type:\e[0m \"ELB with tg\" \n"
      ;;
  "elb with tg")
      spinner_start "Fetching AWS Service (ELB with Target Group)..."
      ELB_COUNT=$(aws elbv2 describe-load-balancers --region $aws_region --query "length(LoadBalancers)" --output text)
      TG_COUNT=$(aws elbv2 describe-target-groups --region $aws_region --query "length(TargetGroups)" --output text)
      spinner_stop
      printf "\e[32m✓ Total ELB in $aws_region:\e[0m $ELB_COUNT\n"
      printf "\e[32m✓ Total Target Groups in $aws_region:\e[0m $TG_COUNT\n"
      printf "\e[36m📋 List of ELB along with Target Groups in $aws_region: \e[0m\n"
      printf "\e[35m1️⃣  [ELB]\e[0m\n"
      aws elbv2 describe-load-balancers --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [Target Groups]\e[0m\n"
      aws elbv2 describe-target-groups --region $aws_region --output table --no-cli-pager
      ;;
  lambda)
      spinner_start "Fetching AWS Service (Lambda)..."
      LAMBDA_COUNT=$(aws lambda list-functions --region $aws_region --query "length(Functions)" --output text)
      spinner_stop
      printf "\e[32m✓ Total Lambda in $aws_region:\e[0m $LAMBDA_COUNT\n"
      printf "\e[36m📋 List of Lambda in $aws_region: \e[0m\n"
      aws lambda list-functions --region $aws_region --output table --no-cli-pager
      ;;
  rds)
      spinner_start "Fetching AWS Service (RDS)..."
      RDS_COUNT=$(aws rds describe-db-instances --region $aws_region --query "length(DBInstances)" --output text)
      spinner_stop
      printf "\e[32m✓ Total RDS in $aws_region:\e[0m $RDS_COUNT\n"
      printf "\e[36m📋 List of RDS in $aws_region: \e[0m\n"   
      printf "\e[35m1️⃣  [DB Instances]\e[0m\n"
      aws rds describe-db-instances --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [DB Clusters]\e[0m\n"
      aws rds describe-db-clusters --region $aws_region --output table --no-cli-pager
      ;;
  dynamodb)
      spinner_start "Fetching AWS Service (DynamoDB)..."
      DYNAMODB_COUNT=$(aws dynamodb list-tables --region $aws_region --query "length(TableNames)" --output text)
      spinner_stop
      printf "\e[32m✓ Total DynamoDB in $aws_region:\e[0m $DYNAMODB_COUNT\n"
      printf "\e[36m📋 List of DynamoDB in $aws_region: \e[0m\n"
      aws dynamodb list-tables --region $aws_region --output table --no-cli-pager
      ;;
  sns)
      spinner_start "Fetching AWS Service (SNS)..."
      SNS_COUNT=$(aws sns list-topics --region $aws_region --query "length(Topics)" --output text)
      spinner_stop
      printf "\e[32m✓ Total SNS in $aws_region:\e[0m $SNS_COUNT\n"
      printf "\e[36m📋 List of SNS in $aws_region: \e[0m\n"
      printf "\e[35m1️⃣  [SNS Topics]\e[0m\n"
      aws sns list-topics --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [SNS Subscriptions]\e[0m\n"
      aws sns list-subscriptions --region $aws_region --output table --no-cli-pager
      ;;
  codecommit)
      spinner_start "Fetching AWS Service (CodeCommit)..."
      CC_COUNT=$(aws codecommit list-repositories --region $aws_region --query "length(repositories)" --output text)
      spinner_stop
      printf "\e[32m✓ Total CodeCommit in $aws_region:\e[0m $CC_COUNT\n"
      printf "\e[36m📋 List of CodeCommit in $aws_region: \e[0m\n"
      aws codecommit list-repositories --region $aws_region --output table --no-cli-pager
      ;;
  codebuild)
      spinner_start "Fetching AWS Service (CodeBuild)..."
      CB_COUNT=$(aws codebuild list-projects --region $aws_region --query "length(projects)" --output text)
      spinner_stop
      printf "\e[32m✓ Total CodeBuild in $aws_region:\e[0m $CB_COUNT\n"
      printf "\e[36m📋 List of CodeBuild in $aws_region: \e[0m\n"
      aws codebuild list-projects --region $aws_region --output table --no-cli-pager
      ;;
  codedeploy)
      spinner_start "Fetching AWS Service (CodeDeploy)..."
      CD_COUNT=$(aws deploy list-applications --region $aws_region --query "length(applications)" --output text)
      spinner_stop
      printf "\e[32m✓ Total CodeDeploy in $aws_region:\e[0m $CD_COUNT\n"
      printf "\e[36m📋 List of CodeDeploy in $aws_region: \e[0m\n"
      printf "\e[35m[Applications]\e[0m\n"
      aws deploy list-applications --region $aws_region --output table --no-cli-pager
      printf "\e[36mℹ️ To list CodeDeploy \"Deployment Groups\" run below command:\e[0m \n"
      printf "aws deploy list-deployment-groups --application-name <APP_NAME> --region <REGION> \n"
      ;;
  codepipeline)
      spinner_start "Fetching AWS Service (CodePipeline)..."
      CP_COUNT=$(aws codepipeline list-pipelines --region $aws_region --query "length(pipelines)" --output text)
      spinner_stop
      printf "\e[32m✓ Total CodePipeline in $aws_region:\e[0m $CP_COUNT\n"
      printf "\e[36m📋 List of CodePipeline in $aws_region: \e[0m\n"
      aws codepipeline list-pipelines --region $aws_region --output table --no-cli-pager
      ;;
  ecr)
      spinner_start "Fetching AWS Service (ECR)..."
      ECR_PRIVATE_COUNT=$(aws ecr describe-repositories --region $aws_region --query 'length(repositories)' --output text)
      ECR_PUBLIC_COUNT=$(aws ecr-public describe-repositories --region us-east-1 --query 'length(repositories)' --output text)
      spinner_stop
      printf "\e[32m✓ Total ECR Private Repositories in $aws_region:\e[0m $ECR_PRIVATE_COUNT\n"
      printf "\e[32m✓ Total ECR Public Repositories in $aws_region:\e[0m $ECR_PUBLIC_COUNT\n"
      printf "\e[36m📋 List of ECR in $aws_region: \e[0m\n"
      printf "\e[35m1️⃣  [Private Repositories]\e[0m\n"
      aws ecr describe-repositories --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [Public Repositories]\e[0m\n"
      aws ecr-public describe-repositories --region us-east-1 --output table --no-cli-pager
      printf "\e[36mℹ️ Note: \"ecr-public\" operations are available only in the \"us-east-1\" region.\e[0m \n"
      ;;
  ecs)
      spinner_start "Fetching AWS Service (ECS)..."
      ECS_CLUSTERS_COUNT=$(aws ecs list-clusters --region $aws_region --query "length(clusterArns)" --output text)
      spinner_stop
      printf "\e[32m✓ Total ECS Clusters in $aws_region:\e[0m $ECS_CLUSTERS_COUNT \n"
      printf "\e[36m📋 List of ECS Clusters in $aws_region: \e[0m\n"
      aws ecs list-clusters --region $aws_region --output table --no-cli-pager
      printf "\e[36mℹ️ To list ECS Services & Tasks run below commands:\e[0m \n"
      printf "aws ecs list-services --cluster <CLUSTER_NAME> --region <REGION> \n"
      printf "aws ecs list-tasks --cluster <CLUSTER_NAME> --region <REGION> \n"
      ;;
  eks)
      spinner_start "Fetching AWS Service (EKS)..."
      EKS_CLUSTERS_COUNT=$(aws eks list-clusters --region $aws_region --query "length(clusters)" --output text)
      spinner_stop
      printf "\e[32m✓ Total EKS Clusters in $aws_region:\e[0m $EKS_CLUSTERS_COUNT \n"
      printf "\e[36m📋 List of EKS Clusters in $aws_region: \e[0m\n"
      aws eks list-clusters --region $aws_region --output table --no-cli-pager
      printf "\e[36mℹ️ To list EKS Node groups run below command:\e[0m \n"
      printf "aws eks list-nodegroups --cluster-name <CLUSTER_NAME> --region <REGION> \n"
      ;;
  cloudformation)
      spinner_start "Fetching AWS Service (CloudFormation)..."
      CF_STACK_COUNT=$(aws cloudformation list-stacks --region $aws_region --stack-status-filter CREATE_COMPLETE ROLLBACK_COMPLETE UPDATE_COMPLETE UPDATE_ROLLBACK_COMPLETE --query "length(StackSummaries)" --output text)
      spinner_stop
      printf "\e[32m✓ Total CloudFormation Stacks in $aws_region:\e[0m $CF_STACK_COUNT \n"
      printf "\e[36m📋 List of CloudFormation Stacks in $aws_region: \e[0m\n"
      printf "\e[35m1️⃣  [Stacks]\e[0m\n"
      aws cloudformation list-stacks --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [Stack Details]\e[0m\n"
      aws cloudformation describe-stacks --region $aws_region --output table --no-cli-pager
      ;;
  cloudfront)
      spinner_start "Fetching AWS Service (CloudFront)..."
      CF_COUNT=$(aws cloudfront list-distributions --region $aws_region --query "DistributionList.Quantity" --output text)
      spinner_stop
      printf "\e[32m✓ Total CloudFront in $aws_region:\e[0m $CF_COUNT \n"
      printf "\e[36m📋 List of CloudFront in $aws_region: \e[0m\n"
      printf "\e[35m1️⃣  [Distributions]\e[0m\n"
      aws cloudfront list-distributions --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [Origin Access Controls]\e[0m\n"
      aws cloudfront list-origin-access-controls --region $aws_region --output table --no-cli-pager
      ;;
  route53)
      spinner_start "Fetching AWS Service (Route 53)..."
      r53_COUNT=$(aws route53 list-hosted-zones --region $aws_region --query "length(HostedZones)" --output text)
      spinner_stop
      printf "\e[32m✓ Total Route 53 in $aws_region:\e[0m $r53_COUNT \n"
      printf "\e[36m📋 List of Route 53 in $aws_region: \e[0m\n"
      printf "\e[35m1️⃣  [Hosted Zones]\e[0m\n"
      aws route53 list-hosted-zones --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [Health Checks]\e[0m\n"
      aws route53 list-health-checks --region $aws_region --output table --no-cli-pager
      ;;
  cloudwatch)
      spinner_start "Fetching AWS Service (CloudWatch)..."
      CLOUDWATCH_ALARMS=$(aws cloudwatch describe-alarms --region $aws_region --query "length(MetricAlarms)" --output text)
      CLOUDWATCH_LG=$(aws logs describe-log-groups --region $aws_region --query "length(logGroups)" --output text)
      CLOUDWATCH_DASHBOARDS=$(aws cloudwatch list-dashboards --region $aws_region --query "length(DashboardEntries)" --output text)
      spinner_stop
      printf "\e[32m✓ Total CloudWatch Alarms in $aws_region:\e[0m $CLOUDWATCH_ALARMS \n"
      printf "\e[32m✓ Total CloudWatch Log Groups in $aws_region:\e[0m $CLOUDWATCH_LG \n"
      printf "\e[32m✓ Total CloudWatch Dashboards in $aws_region:\e[0m $CLOUDWATCH_DASHBOARDS \n"
      printf "\e[36m📋 List of CloudWatch in $aws_region: \e[0m\n"
      printf "\e[35m1️⃣  [Alarms]\e[0m\n"
      aws cloudwatch describe-alarms --region $aws_region --output table --no-cli-pager
      printf "\e[35m2️⃣  [Log Groups]\e[0m\n"
      aws logs describe-log-groups --region $aws_region --output table --no-cli-pager
      printf "\e[35m3️⃣  [Dashboards]\e[0m\n"
      aws cloudwatch list-dashboards --region $aws_region --output table --no-cli-pager
      ;;
  *)  
      printf "\e[33m⚠️  Invalid service. Please enter a valid service.\e[0m \n"
      exit 1
      ;;
esac
