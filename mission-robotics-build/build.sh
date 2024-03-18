#!/bin/bash

yarn set version 3.6.4 # 3.6.4
yarn install # this installs some of the dependency projects from @foxglove


echo "Building log"
yarn workspace @foxglove/log prepack
echo "Building hooks"
yarn workspace @foxglove/hooks prepack
echo "Building den"
yarn workspace @foxglove/den prepack

echo "Building packages"
echo "::group::Building packages"
yarn build:packages
echo "::endgroup::"

set -e

yarn config set npmRegistryServer "https://missionrobotics.jfrog.io/artifactory/api/npm/mr-npm-prod/"
yarn config set npmScopes.foxglove.npmRegistryServer "https://missionrobotics.jfrog.io/artifactory/api/npm/mr-npm-prod/"
yarn config set npmScopes.foxglove.npmAlwaysAuth true
yarn config set npmScopes.foxglove.npmAuthToken ${JFROG_NPM_TOKEN}

echo "Publishing"
set -e
yarn config
yarn workspace @foxglove/den npm publish
yarn workspace @foxglove/hooks npm publis
yarn workspace @foxglove/log npm publish
yarn workspace @foxglove/studio-base npm publish


# yarn workspace @foxglove/den prepack
# yarn workspace @foxglove/hooks prepack
# yarn workspace @foxglove/log prepack
# yarn workspace @foxglove/studio-base prepack
