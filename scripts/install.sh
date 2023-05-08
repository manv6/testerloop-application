set -ex

cd ./testerloop-frontend
npm ci
npm run build
cp -a ./package.json ./build
cd -

# npm install $(npm pack ./overloop-testing-framework-server | tail -1)
npm ci
