set -e

LATEST_SERVER_VERSION=$(npm show testerloop-server version)
CURRENT_SERVER_VERSION=$(jq -r '.dependencies["testerloop-server"]' package.json | cut -d'^' -f2)

echo "Checking testerloop-server version in package.json"

if [[ $LATEST_SERVER_VERSION != $CURRENT_SERVER_VERSION ]]; then
    echo "$CURRENT_SERVER_VERSION is not the latest version of testerloop-server"
    echo "Updating testerloop-server to $LATEST_SERVER_VERSION"
    npm uninstall testerloop-server
    npm install testerloop-server@latest
    echo "Updated testerloop-server to $LATEST_SERVER_VERSION in package.json"
else
    echo "testerloop-server version is up to date with $LATEST_SERVER_VERSION"
fi

echo "Installing and updating testerloop-frontend submodule"

git submodule update --init --recursive
cd ./testerloop-frontend
git pull origin main
cd ..

IMAGE_NAME=testerloop-app
CONTAINER_NAME=testerloop_app_container

OLD_IMAGE_ID=$(docker images -q $IMAGE_NAME:latest)

if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping and removing old Docker container $CONTAINER_NAME"
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

echo "Building new Docker image $IMAGE_NAME"
docker build --no-cache  -t $IMAGE_NAME -f Dockerfile .

if [ "$OLD_IMAGE_ID" ]; then
    echo "Removing old Docker image $OLD_IMAGE_ID"
    docker rmi $OLD_IMAGE_ID -f
fi

echo "Deploying new Docker container $CONTAINER_NAME"
docker run -d --name $CONTAINER_NAME -p 8080:8080 --env-file .env $IMAGE_NAME

echo "Successfully built and deployed new Docker container $CONTAINER_NAME"
echo "You can now access the app at http://localhost:8080"
