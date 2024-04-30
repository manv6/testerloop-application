set -e

echo REACT_APP_AWS_REGION=$AWS_REGION > testerloop-frontend/.env
echo REACT_APP_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID >> testerloop-frontend/.env
echo REACT_APP_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY >> testerloop-frontend/.env
echo REACT_APP_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN >> testerloop-frontend/.env

echo REACT_APP_AWS_REGION=$AWS_REGION > .env
echo REACT_APP_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID >> .env
echo REACT_APP_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY >> .env
echo REACT_APP_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN >> .env

echo 'testerloop-frontend/.env and .env created' 
