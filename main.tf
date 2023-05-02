provider "aws" {
 region = "ap-south-1"
}
resource "aws_instance" "myserver" {
  ami           = "ami-02eb7a4783e7e9317"
  instance_type = "t2.medium"
  key_name = "mykey"
  vpc_security_group_ids = ["sg-0519210a6ae2c8b17"]
  provisioner "remote-exec" { 
    inline = ["echo 'waituntil ssh is ready'"]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("mykey.pem")
      host  =  aws_instance.myserver.public_ip
    }
  }
  root_block_device {
      	volume_size = 24
      	volume_type = "gp2"
  }
  tags = {
    Name = "prodserver"
  }
  provisioner "local-exec" {
         command = "echo ${aws_instance.myserver.public_ip} > inventory"
        }
}
