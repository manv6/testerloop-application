set -ex

cd ./overloop-testing-framework-frontend
npm ci
npm run build
cp -a ./package.json ./build
cd -

cd ./overloop-testing-framework-server
npm ci
npm run build
cp -a ./package.json ./dist
cp -a ./src/schema ./dist
cd -

npm ci
