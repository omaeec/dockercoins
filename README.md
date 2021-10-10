# dockercoins
```
github_branch=2021-10
github_repository=dockercoins
github_username=academiaonline
```
```
git clone https://github.com/${github_username}/${github_repository}
cd ${github_repository}/
git checkout ${github_branch}
```
```
for app in hasher rng webui worker
do
  docker build --file ${app}/Dockerfile --tag ${github_username}/${github_repository}:${github_branch}-${app} .
done
```
```
for app in hasher redis rng
do
  docker network create ${app}
done
```
```
docker volume create redis
```
```
docker run --detach --name redis --network redis --read-only --restart always --volume redis:/data/:rw library/redis:alpine
```
```
docker run --detach --entrypoint ruby --name hasher --network hasher --read-only --restart always --volume ${PWD}/hasher/hasher.rb:/hasher.rb:ro ${github_username}/${github_repository}:${github_branch}-hasher hasher.rb
```
```
docker run --detach --entrypoint python --name rng --network rng --read-only --restart always --volume /usr/local/lib/python3.10/http/__pycache__/ --volume /usr/local/lib/python3.10/__pycache__/ --volume ${PWD}/rng/rng.py:/rng.py:ro ${github_username}/${github_repository}:${github_branch}-rng rng.py
```
```
docker run --detach --entrypoint python --name worker --network redis --read-only --restart always --volume /usr/local/lib/python3.10/distutils/__pycache__/ --volume ${PWD}/worker/worker.py:/worker.py:ro ${github_username}/${github_repository}:${github_branch}-worker worker.py
```
```
for network in hasher rng
do
  docker network connect ${network} worker
done
```
```
docker run --detach --entrypoint node --name webui --network redis --publish 8080 --read-only --restart always --volume ${PWD}/webui/webui.js:/webui.js:ro --volume ${PWD}/webui/files/:/files/:ro ${github_username}/${github_repository}:${github_branch}-webui webui.js
```
