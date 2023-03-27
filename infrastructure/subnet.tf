resource "aws_subnet" "public" {
  count      = 2
  cidr_block = var.public_subnet_cidr_block
  vpc_id     = aws_vpc.main.id
}

resource "aws_subnet" "private" {
  count      = 2
  cidr_block = var.private_subnet_cidr_block
  vpc_id     = aws_vpc.main.id
}
