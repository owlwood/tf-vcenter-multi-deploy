## MY FIRST TERRAFORM ADVENTURE!

N-Tier Sample Application with Load Balancer, Security Groups, FWaaS, and Scheduler Hints


## FWaaS
FWaaS-WIP
- Allow only 80/443 to web
- Allows only 22 to bastion
- Allows only 3306 from web to db
- Allows all egress
   - ToDo
       - Tighten ingress to specific networks
       - Tighten egress
       - Tighten server to server and subnet to subnet

## Load Balancer
Web Load Balancer
- Listens on port 80
- Attached to all web servers
- Configured round robin
  - ToDo
      - Create Load Balancers for App and DB

## Instances and SG

Bastion
- bastion_secgroup_1 accepts traffic on port 22 for management
  - ToDo
      - Apply Locked Down Image

Web
- web_secgroup_1 accepts traffic on port 22 only from bastion network for management
- web_secgroup_1 accepts traffic on port 80/443 for webserver
- Scheduler hint added to attempt to keep on separate hardware
- Installs apache
- Installs PHP
- Creates PHP DB Query/Insert Page http://IPname/db-modify.php?access=1234
  - ToDo
      - Connect to App Server instead of db

App
- Currently Unused
- App_secgroup_1 accepts traffic on port 22 for management
  - ToDo
    - Make Appservers connect to DB instead of web

DB
- db_secgroup_1 accepts traffic on port 22 from bastion network for management
- db_secgroup_1 accepts traffic on port 3306 from web server subnet
- Scheduler hint added to attempt to keep on separate hardware
- Installs MariaDB and runs initial config
- Creates DB and Table

run `tf-creds.sh` first as follows ". tf-creds.sh"

run `build.sh` to build

run `destroy.sh` to destroy

connect to Load_Balancer_IP
  - http://IPname //refresh to see each hostname displayed
  - http://IPname/test.php //verify php is working
  - http://IPname/db-modify.php?access=1234 //show off connection to MariaDB
