# ci-cd-terraform-aws

In this project i created a Terraform file for AWS  contain  

VPC with subnet

Route table and internet gateway

Security group to allow some access and block unwanted access

Elastic IP address 

Ubuntu OS with user data to setup apache server

----------------------------------------------------------
Prerequisite:

U will need to setup your credential for AWS user inside your repo , 

go for: 

Settings ----> secrets and variables ----> Actions ----> New repository secret then create 

1- AWS_ACCESS_KEY_ID

2-AWS_SECRET_ACCESS_KEY

3- AWS_REGION (this one optional) 

Also you have to create an S3 bucket for the workflow and replace the name of the bucket inside the terraform file.
the reson for it is to store the terraform state so it will be easy when you apply the workflow for terraform destroy otherwise
the destroy command won't work on a right way

-------------------------------------------------------------------------------
Workflows:

I made a 2 workflow files: 

1- For initate and apply terraform:

  this one made as auto action and apply direct against the main

2- To destroy the resources if you want:

 this one is a manually action so the action won't work the apply workflow again.

------------------------------------------------
Test

To check your workflow action act success, you will see in Actions Tap  you workflow with a green correct mark.

Also you can go to your AWS account and check the resources created and now you can use the Ubuntu VM to do your tasks.

Also same as for destroying the resources.

 


