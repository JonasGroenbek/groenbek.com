Personal website using terraform

in order to run the website you first need to push it to ECR

docker build -t groenbek_website:latest .

docker tag {your docker image tag} {aws account id}.dkr.ecr.{aws region}.amazonaws.com/{ecr repository}:{your docker image tag}

docker push {your docker image tag} {aws account id}.dkr.ecr.{aws region}.amazonaws.com/{ecr repository}:{your docker image tag}
