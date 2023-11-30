FROM txstatemws/keygenerator as keygen

FROM ubuntu:16.04

RUN apt-get update &&\
	apt-get upgrade -y &&\
	apt-get install tzdata locales -y &&\
	echo America/Chicago > /etc/timezone &&\
	ln -snf /usr/share/zoneinfo/`cat /etc/timezone` /etc/localtime &&\
	locale-gen en_US.UTF-8 &&\
	sed -i -r 's/mesg n \|\| true/test -t 0 \&\& mesg n/g' /root/.profile &&\
	update-locale LANG=en_US.UTF-8 &&\
	apt-get install software-properties-common -y &&\
	apt-add-repository ppa:brightbox/ruby-ng &&\
	apt-get update &&\
	apt-get install -y openssl curl wget git libz-dev libxml2-dev libmysqlclient-dev apache2 apache2-dev build-essential libcurl4-openssl-dev libssl-dev &&\
	wget https://raw.githubusercontent.com/txstate-etc/SSLConfig/master/SSLConfig-TxState.conf -O /etc/apache2/SSLConfig-TxState.conf

	COPY --from=keygen /securekeys/private.key /ssl/localhost.key.pem
	COPY --from=keygen /securekeys/cert.pem /ssl/localhost.cert.pem

# rvm
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &&\
\curl -L https://get.rvm.io | bash -s stable

SHELL [ "/bin/bash", "-l", "-c" ]

# ruby and bundler
RUN rvm install ruby-2.2.4 &&\
    gem install bundler -v 1.10.6

WORKDIR /usr/app

# two step copy is for faster rebuilds. bundle is only run when Gemfile changes
COPY Gemfile ./
COPY Gemfile.lock ./

RUN git config --global url."https://".insteadOf git://

RUN bundle config git.allow_insecure true &&\
    bundle install --without test development &&\
		bundle update mimemagic &&\
    passenger-install-apache2-module -a &&\
    mv /usr/local/rvm/gems/ruby-2.2.4/gems/passenger-6.0.4 /usr/local/lib/

COPY Rakefile ./
COPY Capfile  ./
COPY bin  bin
COPY config config
COPY app/assets app/assets
COPY vendor vendor

#RUN RAILS_ENV=production rake assets:precompile --trace
RUN rake assets:precompile

COPY app app
COPY db db
COPY lib lib
COPY public public
COPY config.ru ./

COPY apache2.conf /etc/apache2/apache2.conf
COPY entrypoint.sh /entrypoint.sh
COPY cmd.sh /cmd.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]
