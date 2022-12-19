#!/bin/bash

cat <<EOF >> .yarnrc.yml
npmScopes:
  foxglove:
    npmRegistryServer: 'https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/packages/npm/'
    npmPublishRegistry: 'https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/packages/npm/'
    npmAlwaysAuth: true
    npmAuthToken: '${CI_JOB_TOKEN}'

EOF


corepack enable
yarn install

echo "Building log"
yarn workspace @foxglove/log prepack
echo "Building hooks"
yarn workspace @foxglove/hooks prepack
echo "Building den"
yarn workspace @foxglove/den prepack

echo "Building packages"
yarn build:packages

echo "Publishing"
yarn workspace @foxglove/den npm publish
yarn workspace @foxglove/hooks npm publish
yarn workspace @foxglove/log npm publish
yarn workspace @foxglove/studio-base npm publish
