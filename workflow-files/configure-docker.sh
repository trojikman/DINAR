set -ex
DIR="`dirname \"$0\"`"

REF=${GITHUB_BASE_REF:-${GITHUB_REF}}
BRANCH=${REF##*/}
REPO_NAME=${GITHUB_REPOSITORY##*/}
IMAGE_CODE=$REPO_NAME:$BRANCH
IMAGE_DB=${GITHUB_REPOSITORY}/dinar-db-$IMAGE_CODE
IMAGE_ODOO=${GITHUB_REPOSITORY}/dinar-odoo-$IMAGE_CODE
IMAGE_ODOO_BASE=$IMAGE_ODOO-base
REGISTRY=docker.pkg.github.com
REGISTRY_USERNAME="${GITHUB_ACTOR}"
REGISTRY_PASSWORD="$1"

ODOO_VERSION="$(echo $BRANCH | python $DIR/branch2odoo_version.py)"
echo "ODOO_VERSION=$ODOO_VERSION"

echo "DB_VERSION=10" >> $GITHUB_ENV
echo "ODOO_VERSION=$ODOO_VERSION" >> $GITHUB_ENV
echo "IMAGE_CODE=$IMAGE_CODE" >> $GITHUB_ENV
echo "IMAGE_DB=$IMAGE_DB" >> $GITHUB_ENV
echo "IMAGE_ODOO=$IMAGE_ODOO" >> $GITHUB_ENV
echo "IMAGE_ODOO_BASE=$IMAGE_ODOO_BASE" >> $GITHUB_ENV
echo "REGISTRY=${REGISTRY}" >> $GITHUB_ENV
echo "REGISTRY_USERNAME=${REGISTRY_USERNAME}" >> $GITHUB_ENV
echo "REGISTRY_PASSWORD=${REGISTRY_PASSWORD}" >> $GITHUB_ENV

# authenticate
if [ ! -z "$REGISTRY_PASSWORD" ]; then
    echo "$REGISTRY_PASSWORD" | docker login -u "$REGISTRY_USERNAME" --password-stdin "$REGISTRY"
fi
