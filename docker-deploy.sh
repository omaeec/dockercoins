#!/bin/sh

branch=2021-11-axia
github_repo=dockercoins
github_user=academiaonline-org
tag=latest

git clone --branch ${branch} --single-branch https://github.com/${github_user}/${github_repo}
cd ${github_repo}

for app in hasher redis rng webui worker
do
docker build -t ${app}:${tag} ${app}
done

for app in hasher rng webui worker
do 
docker network create ${app}
done

cmd=redis-server
entrypoint=/usr/local/bin/docker-entrypoint.sh
image=redis
name=redis
network=webui
restart=always
user=nobody
volume=redis
volume_path=/data/
volume_ops=rw
workdir=/data/
docker run -d --entrypoint ${entrypoint} --name ${name} --network ${network} --read-only --restart ${restart} -u ${user} -v ${volume}:${volume_path}:${volume_ops} -w ${workdir} ${image}:${tag} ${cmd}

docker network connect worker redis

GEM_HOME=/usr/local/bundle
BUNDLE_SILENCE_ROOT_WARNING=1
BUNDLE_APP_CONFIG="$GEM_HOME"
PATH=$GEM_HOME/bin:$PATH
cmd=hasher.rb
entrypoint=/usr/local/bin/ruby
image=hasher
name=hasher
network=hasher
restart=always
user=nobody
volume=${PWD}/hasher/hasher.rb
volume_path=/hasher/hasher.rb
volume_ops=ro
workdir=/hasher/
docker run -d -e GEM_HOME -e BUNDLE_SILENCE_ROOT_WARNING -e BUNDLE_APP_CONFIG -e PATH --entrypoint ${entrypoint} --name ${name} --network ${network} --read-only --restart ${restart} -u ${user} -v ${volume}:${volume_path}:${volume_ops} -w ${workdir} ${image}:${tag} ${cmd}

cmd=rng.py
entrypoint=/usr/local/bin/python
image=rng
name=rng
network=rng
restart=always
user=nobody
volume=${PWD}/rng/rng.py
volume_path=/rng/rng.py
volume_ops=ro
volume_tmp_0=/usr/local/lib/python3.10/collections/__pycache__
volume_tmp_1=/usr/local/lib/python3.10/encodings/__pycache__
volume_tmp_2=/usr/local/lib/python3.10/importlib/__pycache__
volume_tmp_3=/usr/local/lib/python3.10/__pycache__
workdir=/rng/
docker run -d --entrypoint ${entrypoint} --name ${name} --network ${network} --read-only --restart ${restart} -u ${user} -v ${volume}:${volume_path}:${volume_ops} -v ${volume_tmp_0} -v ${volume_tmp_1} -v ${volume_tmp_2} -v ${volume_tmp_3} -w ${workdir} ${image}:${tag} ${cmd}

cmd=worker.py
entrypoint=/usr/local/bin/python
image=worker
name=worker
network=worker
restart=always
user=nobody
volume=${PWD}/worker/worker.py
volume_path=/worker/worker.py
volume_ops=ro
volume_tmp_0=/usr/local/lib/python3.10/collections/__pycache__
volume_tmp_1=/usr/local/lib/python3.10/encodings/__pycache__
volume_tmp_2=/usr/local/lib/python3.10/importlib/__pycache__
volume_tmp_3=/usr/local/lib/python3.10/__pycache__
workdir=/worker/
docker run -d --entrypoint ${entrypoint} --name ${name} --network ${network} --read-only --restart ${restart} -u ${user} -v ${volume}:${volume_path}:${volume_ops} -v ${volume_tmp_0} -v ${volume_tmp_1} -v ${volume_tmp_2} -v ${volume_tmp_3} -w ${workdir} ${image}:${tag} ${cmd}

for network in hasher rng
do
docker network connect ${network} worker
done 

cmd=webui.js
entrypoint=/usr/local/bin/node
image=webui
name=webui
network=webui
restart=always
user=nobody
volume=${PWD}/webui/webui.js
volume_path=/webui/webui.js
volume_files=${PWD}/webui/files/
volume_files_path=/webui/files/
volume_ops=ro
volume_tmp_0=/usr/local/lib/python3.10/collections/__pycache__
volume_tmp_1=/usr/local/lib/python3.10/encodings/__pycache__
volume_tmp_2=/usr/local/lib/python3.10/importlib/__pycache__
volume_tmp_3=/usr/local/lib/python3.10/__pycache__
workdir=/webui/
docker run -d --entrypoint ${entrypoint} --name ${name} --network ${network} --read-only --restart ${restart} -u ${user} -v ${volume}:${volume_path}:${volume_ops} -v ${volume_files}:${volume_files_path}:${volume_ops} -w ${workdir} ${image}:${tag} ${cmd}


