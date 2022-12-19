#!/bin/bash

cat <<EOF >> .yarnrc.yml
npmScopes:
  foo:
    npmRegistryServer: 'https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/packages/npm/'
    npmPublishRegistry: 'https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/packages/npm/'

npmRegistries:
  //gitlab.com/api/v4/projects/${CI_PROJECT_ID}/packages/npm/:
    npmAlwaysAuth: true
    npmAuthToken: '${CI_JOB_TOKEN}'
EOF


corepack enable
yarn install


yarn workspace @foxglove/den npm publish

cat .yarnrc.yml

# cd packages/den
# yarn install
# yarn pack
# yarn npm publish --

# cd ../hooks
# yarn pack
# yarn publish

# cd ../log
# yarn pack
# yarn publish

# cd ../studio-base
# yarn pack
# yarn publish
