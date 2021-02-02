terraform {
  backend "remote" {
    organization = "a-cubed"

    workspaces {
      name = "terraform-cloud"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

#resource "aws_instance" "ubuntu" {
#  ami           = "ami-07744b6c7178930b5"
#  instance_type = "t2.micro"
#  vpc_security_group_ids = ["sg-095f5ba93a8b4ec65"]
#  subnet_id = "subnet-0dfd29e22b7493479"
#}

resource "aws_key_pair" "ssh_key" {
  key_name   = "macos"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "amz" {
  key_name      = aws_key_pair.ssh_key.key_name
  ami           = "ami-0c5b0e963f3f41645"
  instance_type = "t2.micro"

  connection {
    type        = "ssh"
    user        = "centos"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install epel-release -y && sudo yum update -y",
      "sudo yum -y install nginx docker",
      "sudo systemctl start nginx",
      "sudo systemctl start docker"
    ]
  }
}

output "pub_address" {
  value = "${aws_instance.amz.public_ip}"
}
output "priv_address" {
  value = "${aws_instance.amz.private_ip}"
}


