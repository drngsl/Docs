1. Build docker image for dlrn
docker build -t dlrn .

2. Create dlrn docker container
docker run -ti --cap-add SYS_ADMIN  --privileged dlrn bash

3. Build Rpm package for OpenStack component
docker exec -ti 2fa739cbbf53 dlrn --config-file projects.ini --info-repo ../rdoinfo --dev --package-name openstack-nova
