
##############################################################################
#
#  Copyright (C) 2017-2018 Dr Adam S. Candy.
#  
#  CaribbeanWatch:  Up-to-date daily mean surface currents of the
#                   regional Caribbean Sea. By @adamcandy, TU Delft with
#                   NIOZ using data assimilation MercatorOcean, CMEMS_EU.
#  
#                   Web: https://candylab.org/caribbeanwatch
#  
#                   Contact: Dr Adam S. Candy, adam@candylab.org
#  
#  This file is part of the CaribbeanWatch project.
#  
#  Please see the AUTHORS file in the main source directory for a full list
#  of contributors.
#  
#  CaribbeanWatch is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#  
#  CaribbeanWatch is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#  
#  You should have received a copy of the GNU Lesser General Public License
#  along with CaribbeanWatch. If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

# DockerFile for a webpage development container
ARG jobid="[undefined]"
ARG repo="shingleproject/Shingle"
ARG branch="master"

# Use a Xenial base image
FROM ubuntu:xenial

# This DockerFile is looked after by
MAINTAINER Adam Candy <adam@candylab.org>

# Install required packages
RUN apt-get update && apt-get install -y \
        ruby \
				ruby-dev \
				make \
        build-essential \
				zlib \
				git

# Add a user
RUN adduser --disabled-password --gecos "" webdev 

# Switch user
USER webdev
WORKDIR /home/webdev

# Setup SSH
# https://stackoverflow.com/questions/23391839/clone-private-git-repo-with-dockerfile
# ssh-keygen -q -t rsa -N '' -f candylab-updater
RUN mkdir /home/webdev/.ssh/
RUN echo "IdentityFile /home/webdev/.ssh/candylab-updater" >> /home/webdev/.ssh/config
RUN echo "StrictHostKeyChecking no" >> /home/webdev/.ssh/config
COPY --chown=webdev:webdev candylab-updater /home/webdev/.ssh/
RUN chmod 600 /home/webdev/.ssh/config
RUN chmod 600 /home/webdev/.ssh/candylab-updater

# Set up git:
RUN git config --global user.email "adam@candylab.org" 
RUN git config --global user.name "Adam Candy"

# Make a copy of the project
RUN mkdir /home/webdev/src/
RUN mkdir /home/webdev/src/web/
RUN git clone --depth 1 git@github.com:adamcandy/candylab.org.git /home/webdev/src/web/candylab/

ENV PATH /home/webdev/src/web/candylab:/home/webdev/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GEM_HOME /home/webdev/gems
ENV JOBID "${jobid}"
RUN echo "${jobid}"
RUN echo "$branch"
RUN echo "https://github.com/${repo}"

RUN gem install jekyll bundler

WORKDIR /home/webdev/src/web/candylab/

RUN bundler install

RUN bundler exec jekyll build
RUN touch docs/.nojekyll

RUN git pull
RUN git add -A docs/
RUN git commit -a -m "Automatic update to static site from travis (updater), jobid: ${jobid}"
RUN git push
RUN git rev-parse HEAD~1

#RUN make

