# Run Book

## Create Gateway subnet in vnet and make sure gatewat subnet used for launch-VMS
<img src="./.images/gatewaysubnet.png" alt="virtual network subent create" width="600">

## In Azure Create virtual network gateway & Public IP for configuring with the aws customer gateway
<!-- ![virtual network gateway](./.images/vng1.png) -->
<img src="./.images/vng1.png" alt="virtual network gateway" width="600">
<img src="./.images/vng2.png" alt="virtual network gateway" width="600">

## In AWS Create Virtual private gateways in AWS and attach the vpc.
<img src="./.images/vpg.png" alt="Virtual private gateways" width="600">

<img src="./.images/vpg1.png" alt="Virtual private gateways" width="600">

## In AWS  Create customer gateway  and allow the azure virtual network gateway public ip in the customer gatewat IP address field.
<img src="./.images/customer-gateway.png" alt="customer gateway" width="600">

## In AWS Create VPN connection and associate the customergateway,virtual private gateway.
<img src="./.images/site-to-site-vpn-ipsec.png" alt="VPN connection" width="600">


```bash
    Note:-
    Inthe static ip field mention the azure vnet-cidr Range
```

## In AWS Edit the route table & the Azure Vnet Cide Range & AWS virtual private gateway.
<img src="./.images/route1.png" alt="Route Table" width="600">
<img src="./.images/route2.png" alt="Route Table" width="600">

## In Azure Create Local network gateway
<img src="./.images/aws-tunnel-outsideIP.png" alt="AWS VPN Outside IP" width="600">

<img src="./.images/azure-LNG.png" alt="azure-LNG" width="600">

Note :-
```bash
    In Azure LNG - Address Space(s) Mention the AWS VPC Cidr Range
    In Azure LNG - IP address Mention the AWS VPN-OutsideIP
```
## In Azure Add the Connection(LNG) inthe azure virtaul network gateway 

<img src="./.images/AddLNGConnection-VNG.png" alt="azure-LNG" width="600">

<img src="./.images/connection01.png" alt="azure-LNG" width="600">

<img src="./.images/azure-connection-lng-settings.png" alt="azure-LNG-settings" width="600">

```bash
    01) Attach the Virtual network gateway & Local network gateway & Shared Key(PSK) = MyAzureAWS123 or else v6FqOZJQGjoRQNZJyVS848Gb81paF_SS
    2) You can take  from the site-site-vpn by modify vpn tunnel options and select the outside vpn tunnel ip and look for Pre-shared key and pass it inthe azure connection Pre-shared key.
    3) When you are copying the preshared key from the aws dont modify anything , just copy the key.
```

<img src="./.images/aws-presharekey.png" alt="AWS presharedkey" width="600">


## Check vpn tunneling configuration status in aws if UP tunneling connection is working.
<img src="./.images/vpn-connection-success.png" alt="vpn-connection-success" width="600">

## Creat Virtual machines on AWS and Azure, with respective of vpc and allow the ports in security groups and do tunneling ping wiseversa
<img src="./.images/azure-securitygroup.png" alt="vpn-connection-success" width="600">

### Telnet azure vm private ip with port 22 in aws.
<img src="./.images/aws-to-azure-22portcheck.png" alt="vpn-connection-success" width="600">
Note:-

```bash
    Allow 22 port with aws vpc cidr range inthe azure vm network security groups
```

### Telnet aws vm private ip with port 22 in azure 
<img src="./.images/azure-to-aws-22oirtcheck.png" alt="vpn-connection-success" width="600">

Note:-

```bash
    Allow 22 port with azure vpc cidr range inthe aws vm network security groups
```



