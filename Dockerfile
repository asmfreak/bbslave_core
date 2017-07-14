# bslave_core -- builbot slave core for DockerLatentWorker and builbot_travis
# Copyright 2017 Pavel Pletenev <cpp.create@gmail.com>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
FROM ubuntu:xenial

RUN apt-get update && apt-get install -y git sudo \
   python-dev \
   python-pip 
RUN pip install buildbot-slave
RUN groupadd -r buildbot && useradd -r -g buildbot -G sudo buildbot && echo "buildbot:buildbot" | chpasswd && echo "buildbot ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
RUN mkdir /buildslave && chown buildbot:buildbot /buildslave 
COPY create_run_slave.sh /
RUN chmod 777 /create_run_slave.sh
USER buildbot 
WORKDIR /buildslave 
ENTRYPOINT ["/create_run_slave.sh"]
CMD ["start", "--nodaemon"]
