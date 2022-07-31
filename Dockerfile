# This is saying that our image will be based off the ruby:2.6 image
FROM ruby:2.6

# The apt-get update command tells the package manager to download the latest package information
# The -yqq option is a combination of the -y option, which says to answer “yes” to any prompts
# The -qq option, which enables “quiet” mode to reduce the printed output.
RUN apt-get update -yqq

# The apt-get install command installs Node.js, a prerequisite for running Rails.
# The --no-install-recommends says not to install other recommended but nonessential packages
RUN apt-get install -yqq --no-install-recommends nodejs

# Server require webpacked but it need to install Yarn to work #
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn --no-install-recommends -y

# This tells Docker to copy all the files from our local, current directory ( . ) into
# /usr/src/app on the filesystem of the new image. Since our local, current directory
# is our Rails root, effectively we’re saying, “Copy our Rails app into the container at /usr/src/app .” 
# The source path on our local machine is always relative to where the Dockerfile is located.
COPY . /usr/src/app/

# uses it to set /usr/src/app as the working directory:
WORKDIR /usr/src/app

RUN bundle install
RUN yarn install --check-files
RUN bundle exec rails webpacker:install 
