#! /bin/bash
sudo yum install epel-release -y  
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
device=$(lsblk -dp | awk '{print $1}' | tail -1);
web_dir="/var/www/html"
if [ -b "$device" ];
   then sudo mkfs.xfs $device && sudo mkdir -p $web_dir && sudo mount $device $web_dir && echo "$device  $web_dir  xfs  defaults  0  0" | sudo tee -a /etc/fstab ;
   else echo "Not Exist" >> /tmp/logfile
fi
echo "<h1>Hello AWS World</h1>" | sudo tee  $web_dir/index.html
sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"
sudo restorecon -R -v /var/www/html