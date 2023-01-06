#!/bin/bash

corepack enable
yarn install # this installs some of the dependency projects from @foxglove



echo "Building log"
yarn workspace @foxglove/log prepack
echo "Building hooks"
yarn workspace @foxglove/hooks prepack
echo "Building den"
yarn workspace @foxglove/den prepack

echo "Building packages"
yarn build:packages


# Add the npmScope config to publish to our own repo
cat <<EOF >> .yarnrc.yml
npmScopes:
  foxglove:
    npmRegistryServer: 'https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/packages/npm/'
    npmPublishRegistry: 'https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/packages/npm/'
    npmAlwaysAuth: true
    npmAuthToken: '${CI_JOB_TOKEN}'

EOF

echo "Publishing"
yarn workspace @foxglove/den npm publish
yarn workspace @foxglove/hooks npm publish
yarn workspace @foxglove/log npm publish
yarn workspace @foxglove/studio-base npm publish
