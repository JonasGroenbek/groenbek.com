resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  /*
    This is pointing the Route53 record to the load balancer, 
    but the load balancer itself is associated with subnets that have a route to an internet gateway. 
    That means accessing the load balancer using the domain name, 
    the traffic is routed through the internet gateway and then to the load balancer.
  */
  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
