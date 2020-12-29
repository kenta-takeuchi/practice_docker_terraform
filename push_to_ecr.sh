echo Push the Docker image...

echo Logging in to Amazon ECR...
$(aws ecr get-login --region ${AWS_REGION} --no-include-email)

ECR_REPO_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

for repo in api; do
  docker tag "${repo}:latest" "${ECR_REPO_URI}/${repo}:latest"
  docker push "${ECR_REPO_URI}/${repo}:latest"
done

echo Push completed on `date`

echo Writing image definitions file...
printf '[{"name":"api","imageUri":"%s"}]' "${ECR_REPO_URI}/api:latest" > imagedefinitions.json