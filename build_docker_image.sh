echo Build started on `date`

for repo in api; do
  echo Building the Docker image of $repo
  docker build -t $repo:latest ./$repo
  echo Build complete $repo
done

echo Build completed on `date`