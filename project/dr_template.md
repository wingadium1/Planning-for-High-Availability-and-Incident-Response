# Infrastructure

## AWS Zones
Identify your zones here
Primay: us-east-2 (Ohio)
Secondary: us-west-1 (N. California)

## Servers and Clusters

### Table 1.1 Summary
| Asset      | Purpose           | Size                                                                   | Qty                                                             | DR                                                                                                           |
|------------|-------------------|------------------------------------------------------------------------|-----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| EC2 Instances | Application virtual machines which host the e-commerce site | t3.micro | 3 | Deployed in Primary and Secondary AWS regions |
| EKS Cluster Nodes| Node groups of K8S cluster which host the monitoring stack | t3.medium | 2 | Deployed in Primary and Secondary AWS regions |
| VPC | Virtual network | 65,536 IP addresses (/16) | 1  | Deployed in both Primary and Secondary regions, each of which across multiple availability zones |
| ALB | Application load balancer |  | 1 | Deployed in both Primary and Secondary regions |
| RDS Cluster | High-availability Relational database | db.t2.small | 2 | Deployed in both Primary and Secondary regions, each of which across multiple availability zones


### Descriptions

**EC2 Instances:** Run EC2 instances in a cluster that works as an HTTP web server for the e-commerce site. Cluster size should be 3 in each AWS region for HA purposes.

**EKS Cluster Nodes:** Cluster nodes for managed K8S on AWS (EKS), which host the `kube-prometheus-stack` for monitoring purpose. The blackbox exporters is used. Cluster size >=2 in each region for HA purposes.

**VPC:** VPC, which provides a network environment for the 2 above clusters, used a class B virtual network with size /16. One VPC should be set up in each region, which should be across multiple availability zones.

**ALB:** The application load balancer is listening on port 80 (HTTP) for all EC2 instances (backend), and it distributes traffic across the instances for HA purposes and better performance. Due to the HA already being natural of ALB, we need 1 ALB in each region.

**RDS:** In a high-availability database cluster managed by AWS, we will deploy RDS on each region (1 cluster in each), each of which will deploy with additional redundancy across availability zones. The backup retention period is 5 days, and aurora cross-region replication is enabled between each primary and secondary cluster.

## DR Plan
### Pre-Steps:
- Verify the availability of the Terraform code in the Infrastructure as Code (IaC).
- Ensure the Amazon Machine Image (AMI) is available in the secondary region.
- Set up a backend DR S3 bucket in the secondary region.
- Confirm that both the AMI and the S3 bucket have been defined in both zone 1 and zone 2
- From the secondary region directory ./zone2, execute `terraform apply` and follow the prompts to deploy resources in the secondary region.
- Enable Cross-Region Replication and Automate Failover for Aurora RDS
- Setup Route 53 Failover on the primary and secondary ALB, with failover policy.
- Check the health of the RDS cluster and other resources in the AWS Management Console.
- Check the health of the API server
- Check the health of the monitoring cluster


## Steps:
- ### Automatically ###
  - Basically with cross region replication and Automate Failover of RDS and Route 53 Failover on ALB, the system should recovery automatically on secondary region.
- ### Manual failover of RDS cluster
  - The RDS should failover automatically to the secondary region, if not following these steps.
  - Login to AWS portal
  - Select the appropriate region
  - Open RDS Management Console (RDS)
  - Navigate 'Databases'
  - Choose the 'Writer Instance'.
  - Click on 'Actions' and then 'Failover'.
  - Click 'Failover' to initiate the process.
  - Wait or refresh the databases page until the roles of the reader and writer instances are switched.
- ### Failover of application to secondary region.
  - The Route 53 DNS should failover automatically, if not following these steps.
  - Configure the AWS Route 53 DNS service to create a DNS name that can point to the load balancers in both regions.
  - Update the DNS record to point to the secondary region.
  - Manually failover the RDS cluster as detailed above.
  - Implement automatic failover for the RDS cluster using health checks.