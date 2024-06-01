# Remove all Docker containers, including stopped ones
docker rm $(docker ps -a -q)

# Build the Docker images as defined in the docker-compose.yml file
docker-compose build

# Start the Docker containers in detached mode (in the background)
docker-compose up -d

# Remove the results.txt file if it exists
rm -rf results.txt

# Print a message to the console
echo "remove results.txt"

# Run the rewrite_test.sh script and redirect its output to results.txt
./test_cases.sh > results.txt

# Stop and remove the Docker containers defined in the docker-compose.yml file
docker-compose down