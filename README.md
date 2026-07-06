# 🚀 AWS Resource List - Script

---

<p align="center">
  
![Bash](https://img.shields.io/badge/Bash-Script-121011?style=for-the-badge&logo=gnu-bash)
![AWS CLI](https://img.shields.io/badge/AWS_CLI-v2-FF9900?style=for-the-badge&logo=amazonaws)
![Linux](https://img.shields.io/badge/Linux-Compatible-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Shell](https://img.shields.io/badge/Shell-Automation-4EAA25?style=for-the-badge&logo=gnubash)
![AWS](https://img.shields.io/badge/Amazon_Web_Services-Cloud-FF9900?style=for-the-badge&logo=amazonaws)

</p>

A simple yet powerful **Bash automation script** that lists AWS resources across multiple AWS services using the **AWS CLI**.

Instead of remembering dozens of AWS CLI commands, simply provide the AWS service name and optionally the region to quickly retrieve resource counts and detailed information.

---

## ✨ Features

- ✅ Supports **20+ AWS Services**
- ✅ Displays total resource count
- ✅ Shows resources in **table format**
- ✅ Automatically detects AWS CLI configured region
- ✅ Supports custom AWS regions
- ✅ Colorized terminal output
- ✅ Loading spinner while fetching resources
- ✅ AWS CLI authentication validation
- ✅ Beginner-friendly interface

---

## 📦 Supported AWS Services

| Service | Command |
|----------|----------|
| IAM | `iam` |
| VPC | `vpc` |
| VPC + Subnets + Route Tables + IGW + NAT + NACL | `vpc and more` |
| EC2 | `ec2` |
| EC2 + Security Groups | `ec2 with sg` |
| S3 | `s3` |
| EBS | `ebs` |
| Load Balancer | `elb` or `lb` |
| Load Balancer + Target Groups | `elb with tg` |
| Lambda | `lambda` |
| RDS | `rds` |
| DynamoDB | `dynamodb` |
| SNS | `sns` |
| CodeCommit | `codecommit` |
| CodeBuild | `codebuild` |
| CodeDeploy | `codedeploy` |
| CodePipeline | `codepipeline` |
| ECR | `ecr` |
| ECS | `ecs` |
| EKS | `eks` |
| CloudFormation | `cloudformation` |
| CloudFront | `cloudfront` |
| Route53 | `route53` |
| CloudWatch | `cloudwatch` |

---

## 📋 Prerequisites

Before running the script, ensure you have:

- [**AWS CLI**](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed
- AWS CLI configured
- Valid IAM credentials
- Bash shell
- Linux/macOS environment

Verify installation:

```bash
aws --version
```

Configure AWS CLI:

```bash
aws configure
```

Verify authentication:

```bash
aws sts get-caller-identity
```

---

## 📁 Project Structure

```text
.
├── aws_resource_list.sh
├── spinner.sh
└── README.md
```

---

## ⚙️ Installation

Clone the repository:

```bash
git clone https://github.com/Syed-Dadapeer226/aws_resource_list.git
```

Go to the project directory:

```bash
cd aws_resource_list
```

Give execute permission:

```bash
chmod +x aws_resource_list.sh
chmod +x spinner.sh
```

---

## ▶️ Usage

### Basic Syntax

```bash
./aws_resource_list.sh <aws_service>
```

or

```bash
./aws_resource_list.sh <aws_service> <aws_region>
```

---

## 💻 Execution Examples

### List EC2 instances

```bash
./aws_resource_list.sh ec2
```

---

### List EC2 instances in Mumbai region

```bash
./aws_resource_list.sh ec2 ap-south-1
```

---

### List S3 Buckets

```bash
./aws_resource_list.sh s3
```

---

### List IAM Users

```bash
./aws_resource_list.sh iam
```

---

### List VPC Resources

```bash
./aws_resource_list.sh vpc
```

---

### List Complete VPC Information

```bash
./aws_resource_list.sh "vpc and more"
```

---

### List EC2 with Security Groups

```bash
./aws_resource_list.sh "ec2 with sg"
```

---

### List Load Balancers

```bash
./aws_resource_list.sh elb
```

---

### List Load Balancers with Target Groups

```bash
./aws_resource_list.sh "elb with tg"
```

---

### List Lambda Functions

```bash
./aws_resource_list.sh lambda
```

---

### List RDS Databases

```bash
./aws_resource_list.sh rds
```

---

### List CloudWatch Resources

```bash
./aws_resource_list.sh cloudwatch
```

---

## 🖥 Sample Output

```text
Fetching AWS Account details...

✓ Total EC2 Instances in ap-south-1: 6
⏳ Running Instances: 4

List of EC2 Instances

--------------------------------------------------
| Instance ID | State | Instance Type | Name |
--------------------------------------------------
| i-0a1234567 | Running | t3.medium | WebServer |
| i-0b9876543 | Stopped | t3.micro | TestServer |
--------------------------------------------------
```

---

## ⚡ Error Handling

The script validates:

- AWS CLI installation
- AWS authentication
- Invalid service names
- Incorrect arguments
- Missing AWS credentials

---

## 🌍 Region Support

If no AWS region is provided, the script automatically uses the region configured in:

```text
~/.aws/config
```

Otherwise, specify the region manually:

```bash
./aws_resource_list.sh ec2 us-east-1
```

---

## 🛠 Technologies Used

- Bash Shell Scripting
- AWS CLI
- Linux
- Shell Utilities (awk, printf)
- AWS APIs

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create a feature branch

```bash
git checkout -b feature/new-feature
```

3. Commit your changes

```bash
git commit -m "Added new feature"
```

4. Push to GitHub

```bash
git push origin feature/new-feature
```

5. Open a Pull Request

---

# 📄 License

This project is licensed under the Apache License 2.0.

See the LICENSE file for details.

---

⭐ If you found this project useful, don't forget to **star the repository**.
