Personal website using terraform

To authenciate to ECR

```
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.<region>.amazonaws.com
```

To build and push to ECR

```
docker build -t <image-name>:latest .

docker tag <image-name> <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

docker push <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

```
