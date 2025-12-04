🟦 Q1 – VPC Networking (Terraform)
Utkarsh Mishra – AWS Assessment

This task provisions a complete VPC networking architecture using Terraform.
All AWS resources are created with the prefix Utkarsh_Mishra_ as required.

📝 Approach (4–6 Lines)

I created a custom AWS VPC using Terraform and added two public and two private subnets across different Availability Zones.
An Internet Gateway (IGW) was configured for outbound internet access from public subnets.
A NAT Gateway with Elastic IP was created to allow private subnets to reach the internet securely.
Separate route tables were created for public and private subnets and correctly associated.
Finally, terraform apply was used to deploy all resources, and the VPC was verified in the AWS Console.

📁 Folder Structure
Q1_VPC_Networking/
│── main.tf
│── README.md
└── screenshots/
      └── vpc_overview.png.png

📸 AWS Screenshot (Only One Provided)

You uploaded one screenshot:

VPC Overview Screenshot → vpc_overview.png.png
This image contains visible confirmation of:

VPC ID

Subnets

Route tables

IGW

NAT Gateway

Entire resource map in one view

This single screenshot is acceptable because it shows the whole VPC structure.

🧩 Terraform Configuration

The Terraform code used is in:

Q1_VPC_Networking/main.tf


It includes:

VPC

Subnets (2 public, 2 private)

Internet Gateway

NAT Gateway + Elastic IP

Public Route Table

Private Route Table

Route associations

✔️ Terraform Deployment Output

After running:

terraform init
terraform plan
terraform apply


Terraform successfully created:

16 added

0 changed

0 destroyed

AWS Console confirms the created resources.

🧹 Cleanup After Assessment

To avoid AWS charges (especially NAT Gateway):

terraform destroy 
