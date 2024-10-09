# meta-gitlab-self-hosted

This script downloads all repositories from the gitlab self hosted workspace 
and adds it to [meta](https://github.com/mateodelnorte/meta).

Why:
---
 - to execute scripts on child repositories
 - to execute git commands on child repositories
 - to keep the repositories up-to-date locally and search globally across the entire codebase
 - to be able to work as a mono-repository
 
How that works?
---
### Install meta
 ```console
yarn global add meta # or npm install -g meta
 ```

### Init repository list 
To init or refresh repository list, execute the init.sh script

To usage, you need to obtain some environment from your bitbucket account.

 ```
export GITLAB_DOMAIN=<gitlab url>
# https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html 
export GITLAB_TOKEN=<gitlab app password>
./init.sh
```

Useful commands
---
 - clone all repositories
   ```
   meta git update
   ```

- pull all repositories
  ```
  meta git pull
  ```

 - check status in each git repository
   ```
   meta git status
   ```
   
 - execute a command on child repositories
   ```
   meta exec pwd
   ```
   
 - find all project which uses kafka-clients
   ```
   ag -l kafka-clients ./**/pom.xml
   ```
   
More information:
https://github.com/mateodelnorte/meta

