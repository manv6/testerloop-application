set -ex

pushd ./overloop-testing-framework-frontend
npm ci
npm run build
cp -a ./package.json ./build
popd

pushd ./overloop-testing-framework-server
npm ci
npm run build
cp -a ./package.json ./dist
cp -a ./src/schema ./dist
popd

npm ci
