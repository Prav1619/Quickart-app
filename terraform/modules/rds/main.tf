resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier = var.db_name

  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = var.username
  password = var.password

  db_subnet_group_name = aws_db_subnet_group.this.name
  skip_final_snapshot  = true
}
