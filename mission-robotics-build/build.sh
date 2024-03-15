#!/bin/bash

yarn set version stable
yarn install # this installs some of the dependency projects from @foxglove


echo "Building log"
yarn workspace @foxglove/log prepack
echo "Building hooks"
yarn workspace @foxglove/hooks prepack
echo "Building den"
yarn workspace @foxglove/den prepack

echo "Building packages"
yarn build:packages

yarn config set npmScopes.foxglove.npmRegistryServer "https://npm.pkg.github.com"
yarn config set npmScopes.foxglove.npmAlwaysAuth true

yarn config set npmScopes.foxglove.npmAuthToken ${NPM_AUTH_TOKEN}

echo "Publishing"
yarn workspace @foxglove/den npm publish
yarn workspace @foxglove/hooks npm publish
yarn workspace @foxglove/log npm publish
yarn workspace @foxglove/studio-base npm publish
