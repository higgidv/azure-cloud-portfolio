# Project 02: Hybrid Cloud Architecture

## Overview
This project demonstrates enterprise-grade hybrid cloud connectivity between simulated on-premises infrastructure and Azure cloud services using Site-to-Site VPN.

## Architecture Components

### On-Premises Environment (East US)
- **Virtual Network**: 10.0.0.0/16
  - Internal Subnet: 10.0.1.0/24
  - Gateway Subnet: 10.0.255.0/27
- **Domain Controller**: vm-dc01-onprem (10.0.1.10)
  - Windows Server 2022
  - Active Directory Domain Services
  - DNS Services
- **VPN Gateway**: vpngw-onprem (VpnGw1 SKU)
- **Network Security**: nsg-dc-onprem

### Production Cloud Environment (West US 2)  
- **Virtual Network**: 172.16.0.0/16
  - Web Subnet: 172.16.1.0/24
  - Gateway Subnet: 172.16.255.0/27
- **VPN Gateway**: vpngw-prod (VpnGw1 SKU)

### Hybrid Connectivity
- **Site-to-Site VPN**: IPsec tunnel between regions
- **Encryption**: Industry-standard IPsec/IKE protocols
- **Routing**: Dynamic route propagation

## Security Features
- Network Security Groups with least-privilege access
- VPN encrypted tunnel for inter-site communication
- Private IP addressing with no direct internet exposure
- Centralized domain authentication simulation

## Cost Optimization
- B1s VM size for cost efficiency
- VpnGw1 gateway SKU (lowest cost option)
- Scheduled shutdown capabilities for demo environment

## Enterprise Patterns Demonstrated
1. **Hybrid Connectivity**: Secure connection between on-premises and cloud
2. **Network Segmentation**: Proper subnet design and isolation
3. **Identity Integration**: Centralized domain services
4. **Infrastructure as Code**: Complete automation with Terraform
5. **Security Controls**: Defense-in-depth networking
6. **Cost Management**: Resource optimization within budget constraints

## Testing and Validation
- VPN tunnel establishment verification
- Cross-network connectivity testing
- DNS resolution across environments
- Security control validation

This architecture simulates real-world Fortune 500 hybrid cloud patterns while maintaining cost efficiency for demonstration purposes.
