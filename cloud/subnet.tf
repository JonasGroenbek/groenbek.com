resource "aws_subnet" "public" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-central-1a"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-central-1b"

  tags = {
    Name = "private-subnet"
  }
}
