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

for app in hasher redis rng
do 
docker network create ${app}
done

cmd=redis-server
entrypoint=/usr/local/bin/docker-entrypoint.sh
image=redis
name=redis
network=redis
restart=always
user=nobody
volume=redis
volume_path=/data/
volume_ops=rw
workdir=/data/
docker run -d --entrypoint ${entrypoint} --name ${name} --network ${network} --read-only --restart ${restart} -u ${user} -v ${volume}:${volume_path}:${volume_ops} -w ${workdir} ${image}:${tag} ${cmd}

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
