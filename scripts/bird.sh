#!/bin/sh

NODE_COUNT=$1
NODE_IP=$2
cat << EOF > /etc/bird.conf
log syslog { trace, info, remote, warning, error, auth, fatal, bug };
log stderr all;

router id ${NODE_IP}.6; # master internal ip

# push all incoming routes to kernel routing table
protocol kernel {
  persist;            # save routes on bird shutdown
  scan time 2;
  export all;         # export all incoming routes to kernel
  graceful restart;
}

# scan interfaces
protocol device {
  debug { states };
  scan time 2;
}

protocol direct {
  debug { states };
  interface "ens192";  # master internal interface
                       # should be the same as configured
                       # for Calico communication
}

# apply incoming routes to pod subnet
filter main_filter {
      if net ~ 192.168.0.0/16 then accept;
      else reject;
}

# BGP rule template
template bgp bgp_template {
  debug { states };
  description "Connection to BGP peer";
  local as 64512;      # same as Calico host AS
  multihop;            # allow connection to neighbor through router
  gateway recursive;   # allow routes through router
  import filter main_filter; # apply filter
  next hop self;       # advertise our ip as next hop
  source address ${NODE_IP}.6; # master internal ip
  add paths on;        # allow multiple routes to same subnet
  graceful restart;
}

# list of BGP peers (kubernetes nodes)
EOF

for i in $(seq "$NODE_COUNT")
do
NODE_NUMBER=$(expr ${i} + 10)
cat << EOF >> /etc/bird.conf
protocol bgp node$NODE_NUMBER from bgp_template {
  neighbor ${NODE_IP}.$NODE_NUMBER as 64512;
}
EOF
done

systemctl restart bird.service
