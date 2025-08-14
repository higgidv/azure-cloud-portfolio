# Updated Cost Analysis - Project 02

## Resource Cost Breakdown (Monthly)
- VPN Gateways (2x VpnGw1): ~$12/month
- Domain Controller (B2s): ~$6/month (upgraded from B1s)
- Storage and networking: <$1/month
- **Total: ~$19/month**

## Cost Optimization Notes
- B2s provides much better performance for Windows Server + AD
- Still well within free tier budget (~$181 remaining)
- Can schedule shutdown during non-demo hours to save costs

## Performance Improvement
- 2 vCPU, 4GB RAM vs previous 1 vCPU, 1GB RAM
- Much better user experience for RDP sessions
- Adequate for Active Directory Domain Services
- Suitable for enterprise demonstrations

## Enterprise Justification
- Proper sizing demonstrates understanding of workload requirements
- Shows cost vs performance trade-off decision making
- Realistic sizing for small domain controller in hybrid environment
