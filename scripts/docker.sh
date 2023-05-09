set -e

LATEST_SERVER_VERSION=$(npm show @testerloop/server version)
CURRENT_SERVER_VERSION=$(jq -r '.dependencies["@testerloop/server"]' package.json | cut -d'^' -f2)

if [[ $LATEST_SERVER_VERSION != $CURRENT_SERVER_VERSION ]]; then
    npm uninstall @testerloop/server
    npm install @testerloop/server@latest
    echo "Updated @testerloop/server to $LATEST_SERVER_VERSION in package.json"
fi

git submodule update --init --recursive
cd ./testerloop-frontend
git pull origin main
cd ..

IMAGE_NAME=testerloop-app
CONTAINER_NAME=testerloop_app_container

OLD_IMAGE_ID=$(docker images -q $IMAGE_NAME:latest)

if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

docker build --secret id=npmrc,src=.npmrc --no-cache  -t $IMAGE_NAME -f Dockerfile .

if [ "$OLD_IMAGE_ID" ]; then
    docker rmi $OLD_IMAGE_ID
fi

docker run -d --name $CONTAINER_NAME -p 8080:8080 --env-file .env $IMAGE_NAME

echo "Successfully built and deployed new Docker container $CONTAINER_NAME"
