cat > TESTING.md << 'EOF'
# Hybrid Infrastructure Testing Guide

## Prerequisites
- VPN tunnels established and connected
- Domain controller fully deployed and configured
- Network security groups properly configured

## Test Procedures

### 1. VPN Connectivity Test
```bash
# Check VPN connection status
az network vpn-connection show \
  --resource-group rg-hybrid-demo-onprem-eastus \
  --name conn-onprem-to-prod \
  --query connectionStatus

# Expected: "Connected"