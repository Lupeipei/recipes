###############################
#         DEVELOPMENT         #
###############################

# Procfile for development using the new threaded worker (scheduler, twitter stream and delayed job)
web: bundle exec rails server -p ${PORT-3000} -b ${IP-0.0.0.0}
jobs: bundle exec rails runner bin/threaded.rb

###############################
#         PRODUCTION          #
###############################

# You need to copy or link config/unicorn.rb.example to config/unicorn.rb for both production versions.
# Have a look at the deployment guides, if you want to set up recipes on your server:
# https://github.com/huginn/huginn/doc

# Using the threaded worker (consumes less RAM but can run slower)
# web: bundle exec unicorn -c config/unicorn.rb
# jobs: bundle exec rails runner bin/threaded.rb
