echo Build and push started on `date`
echo Building the Docker image...

REPO=$(aws ecr describe-repositories --repository-names practice --output text --query "repositories[0].repositoryUri")
IMAGE=$REPO

for repo in api; do
  docker tag "${repo}:latest" "${REPO}/${repo}:latest"
  docker push "${REPO}/${repo}:latest"
done

echo Push completed on `date`

echo Writing image definitions file...
cat <<__JSON__ > imagedefinitions.json
[
  {"name": "api", "imageUri": "${REPO}/api:latest"},
]
__JSON__