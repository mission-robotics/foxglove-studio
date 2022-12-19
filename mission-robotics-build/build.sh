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


yarn workspace @foxglove/den npm publish
yarn workspace @foxglove/hooks npm publish
yarn workspace @foxglove/log npm publish
yarn workspace @foxglove/studio-base npm publish
