---
# Terraform Multi-Instance Web Application Deployment

Welcome to this documentary on deploying a scalable web application architecture on Amazon Web Services (AWS) using Terraform. This project serves as a foundational blueprint for provisioning a simple, yet robust, multi-tier environment, demonstrating the power of Infrastructure as Code.
---

## The Vision: A Scalable Web Architecture

Imagine a world where your web application can handle varying loads, where components are separated for better security and management. This project brings that vision to life with a foundational setup:

- **A Dedicated Network (VPC):** Your application resides within its own isolated virtual network in AWS, providing a secure and controlled environment.
- **Load Balancing with Nginx:** A central Nginx server acts as a reverse proxy, distributing incoming web traffic evenly across your application servers, ensuring no single server is overloaded.
- **Multiple Application Servers:** Two backend EC2 instances serve your application content, providing redundancy and the ability to scale. If one goes down, the other can continue serving requests.

```
+----------------+          +-----------------------+
|  Internet User | ---------> | Nginx Load Balancer   |
+----------------+          |  (EC2 Instance)       |
                               +-----------+-----------+
                                           |
                                           | HTTP (Port 80)
                                           |
                   +-----------------------+-----------------------+
                   |                                               |
                   V                                               V
        +-------------------+                             +-------------------+
        | App Server 1      |                             | App Server 2      |
        | (EC2 Instance)    |                             | (EC2 Instance)    |
        +-------------------+                             +-------------------+
```

This architecture is designed for simplicity in demonstration, yet it lays the groundwork for more complex, highly available systems.

---

## Behind the Scenes: What Terraform Provisions

Terraform, our infrastructure orchestrator, meticulously crafts each component in AWS:

- **Virtual Private Cloud (VPC):** A new, isolated network with a specified CIDR block.
- **Public Subnet:** A segment within the VPC where our instances will reside, allowing them to communicate with the internet.
- **Internet Gateway:** The bridge connecting our VPC to the public internet.
- **Route Table & Association:** Rules to direct traffic from our subnet to the Internet Gateway.
- **Security Groups:**
  - One for the **Nginx Load Balancer**, permitting inbound HTTP (port 80) from anywhere and SSH (port 22) for administrative access.
  - Another for the **Application Servers**, allowing inbound HTTP (port 80) _only from the Nginx Load Balancer's security group_, and SSH (port 22) for management. This demonstrates a key security principle of least privilege.
- **EC2 Instances:**
  - **One Nginx Load Balancer instance:** Configured with user data to install Nginx and set up a basic reverse proxy to the application servers.
  - **Two Application Server instances:** Each configured with user data to install Apache and serve a unique "Hello from App Server X!" page, allowing you to observe the load balancing in action.

---

## Embarking on the Deployment: Your Journey

Before you begin, ensure you have the necessary tools and access:

### Prerequisites

- **AWS Account:** An active AWS account with appropriate permissions.
- **AWS CLI Configured:** Your AWS Command Line Interface (CLI) should be installed and configured with your credentials and default region (e.g., `us-east-1` or `ap-south-1`). Terraform leverages these credentials.
- **Terraform Installed:** The Terraform CLI must be installed on your local machine.
- **EC2 Key Pair:** You must have an existing EC2 Key Pair in your chosen AWS region. The project is configured to use `my-ec2-keypair` by default, but you can update the `variables.tf` file if your key pair has a different name.

### Deployment Steps

1.  **Clone the Repository:**
    Start by getting the project code onto your local machine.

2.  **Navigate to the Project Directory:**
    Open your terminal and change into the project folder.

3.  **Initialize Terraform:**
    This command prepares your working directory, downloading the necessary AWS provider plugin.

    ```bash
    terraform init
    ```

4.  **Review the Deployment Plan:**
    Before making any changes to your AWS account, always review what Terraform intends to do. This command shows you a detailed outline of all resources that will be created, modified, or destroyed.

    ```bash
    terraform plan
    ```

    Carefully examine the output to ensure it matches your expectations (e.g., it should show 3 EC2 instances, a VPC, security groups, etc.).

5.  **Apply the Configuration:**
    If the plan looks good, proceed with applying the configuration. Terraform will then provision all the resources in your AWS account. You'll be prompted to confirm this action.

    ```bash
    terraform apply
    ```

    Type `yes` when prompted and press Enter. This process will take a few minutes.

---

## Witnessing the Application: Verification

Once `terraform apply` completes successfully, Terraform will output key information about your deployment:

- **Nginx Load Balancer Public IP:** The public IP address of your load balancer.
- **Application Server Public IPs:** A list of public IP addresses for your individual application servers.

You can also retrieve these outputs at any time by running:

```bash
terraform output
```

### Testing the Web Application

1.  **Open your web browser.**
2.  **Navigate to the Nginx Load Balancer's Public IP:** In the address bar, type `http://<NGINX_LB_PUBLIC_IP_ADDRESS>` (replace with the actual IP from `terraform output`).
3.  **Observe Load Balancing:**
    You should see a page displaying either "Hello from App Server 1!" or "Hello from App Server 2!". Refresh your browser multiple times, and you'll witness Nginx distributing requests between your two backend servers.

You can also SSH into the instances using their public IPs and your key pair if you wish to inspect them directly (e.g., `ssh -i /path/to/your/keypair.pem ec2-user@<INSTANCE_PUBLIC_IP>`).

![image](https://github.com/user-attachments/assets/01507442-7206-4571-9aad-7b027cde8d1d)

---

## The Cleanup: Dismantling the Infrastructure

When you're finished experimenting, it's crucial to tear down the resources to avoid incurring unnecessary AWS costs.

1.  **Destroy the Infrastructure:**
    From your project directory, execute the following command:

    ```bash
    terraform destroy
    ```

    Terraform will display a plan of all the resources it's about to delete. Type `yes` when prompted and press Enter to confirm.

2.  **Verify in AWS Console:**
    After the command completes, log into your AWS Management Console and verify that all the EC2 instances are terminated and other network resources (VPC, Security Groups, etc.) have been removed.

---
