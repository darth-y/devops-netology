```
route-views>sh ip rou 84.47.128.244
Routing entry for 84.47.128.0/22
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 01:05:28 ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 01:05:28 ago
      Route metric is 0, traffic share count is 1
      AS Hops 2
      Route tag 6939
      MPLS label: none
```
```
route-views>show bgp 84.47.128.244
BGP routing table entry for 84.47.128.0/22, version 3537519635
Paths: (23 available, best #22, table default)
  Not advertised to any peer
  Refresh Epoch 1
  4901 6079 31133 8641, (aggregated by 8641 77.94.160.1)
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE016C769A8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 1299 8641, (aggregated by 8641 77.94.160.3)
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 1299:30000 57866:100 57866:101 57866:501
      path 7FE13A076148 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 8641, (aggregated by 8641 77.94.160.3)
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      Community: 174:21101 174:22005 53767:5000
      path 7FE0EFAB6028 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 31133 8641, (aggregated by 8641 77.94.160.1)
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      path 7FE1441D23A8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 20764 20764 20764 20764 20764 20764 20764 8641, (aggregated by 8641 77.94.160.2)
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      path 7FE04A631980 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 174 8641, (aggregated by 8641 77.94.160.3)
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      Community: 3257:8070 3257:30155 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE030546598 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 2
  8283 1299 8641, (aggregated by 8641 77.94.160.3)
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin incomplete, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 1299:30000 8283:1 8283:101 8283:103
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x24
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001 0000 205B 0000 0005
              0000 0003
      path 7FE121023280 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 20764 8641, (aggregated by 8641 77.94.160.2)
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:901 3356:2065 3549:2581 3549:30840 20764:3002 20764:3011 20764:3021
      path 7FE0D97FAE88 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 20764 8641, (aggregated by 8641 77.94.160.2)
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:901 3356:2065 20764:3002 20764:3011 20764:3021
      path 7FE03EE6AB08 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 3491 8641, (aggregated by 8641 77.94.160.3)
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      Community: 101:20300 101:22100 3491:300 3491:311 3491:9001 3491:9080 3491:9081 3491:9087 3491:60040 3491:60050 3491:60150 3491:61110 3491:62210 3491:62220
      path 7FE0D9B73C50 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 3491 8641, (aggregated by 8641 77.94.160.3)
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external, atomic-aggregate
      path 7FE0BEEA0960 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 8641, (aggregated by 8641 77.94.160.2)
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      path 7FE0D63BCFD8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  2497 12389 8641, (aggregated by 8641 77.94.160.3)
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      path 7FE040F0E648 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 3
  3303 6939 8641, (aggregated by 8641 77.94.160.2)
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      Community: 3303:1006 3303:1021 3303:1030 3303:3067 6939:7324 6939:8276 6939:9002
      path 7FE0529ED748 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 12389 8641, (aggregated by 8641 77.94.160.3)
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      Community: 2516:1050 7660:9001
      path 7FE018832738 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 1299 8641, (aggregated by 8641 77.94.160.3)
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      Community: 7018:5000 7018:37232
      path 7FE00142C758 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 12552 8641, (aggregated by 8641 77.94.160.2)
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      Community: 12552:12000 12552:12600 12552:12601 12552:22000
      Extended Community: 0x43:100:1
      path 7FE12B7EB220 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1221 4637 31133 8641, (aggregated by 8641 77.94.160.1)
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      path 7FE02548DF90 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 1273 12389 8641, (aggregated by 8641 77.94.160.3)
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      path 7FDFFBD65888 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 1299 8641, (aggregated by 8641 77.94.160.3)
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin incomplete, metric 10, localpref 100, valid, external, atomic-aggregate
      Community: 3257:8794 3257:30052 3257:50001 3257:54900 3257:54901
      path 7FE14E573C10 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 3910 3356 20764 8641, (aggregated by 8641 77.94.160.2)
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external, atomic-aggregate
      path 7FE142055408 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 8641, (aggregated by 8641 77.94.160.2)
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external, atomic-aggregate, best
      path 7FE0B6656328 RPKI State valid
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  19214 174 8641, (aggregated by 8641 77.94.160.3)
    208.74.64.40 from 208.74.64.40 (208.74.64.40)
      Origin incomplete, localpref 100, valid, external, atomic-aggregate
      Community: 174:21101 174:22005
      path 7FE169FF0028 RPKI State valid
      rx pathid: 0, tx pathid: 0
```