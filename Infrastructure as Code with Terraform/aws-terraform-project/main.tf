provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami = "ami-0c55b159cbfafe10"
  instance_type = "t2.miro"

  user_data = <<-EOF
              #!/bin/bash -y
              yum update -y
              yum install -y httpd
              system start httpd
              system enable httpd
              echo "<h1> deployed via Terraform</h1> var/www/html/index.html
              EOF
            
    tags ={ 
        Name =" TerraformWebServer"
    }

}

resource "aws_lb" "web_load_balancer" {
    name = "web_load_balancer"
    internal = false
    load_balancer_type = "application"
    security_groups =  [aws_security_group.lb_sg-033d40e35d7354685]
    subnets = aws_subnet.pulic[*].id


    enable_deletion_protection= false 

}

resource "aws_route53_record" "web" {
    zone_id = " Z0958884MH9PP5XTBQJK"
    name = "example.com"
    type = "A"

    alias {
      name                   = "aws_lb.web_lb.dns_name"
      zone_id                = aws_lb .web_lb.zone_id
      evaluate_target_health = true

    }  
}