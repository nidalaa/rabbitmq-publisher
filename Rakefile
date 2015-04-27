# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :rabbitmq do
  task :setup do
    require "bunny"

    connection = Bunny.new
    connection.start
    channel = connection.create_channel

    fanout = channel.fanout("currencies.fanout")
    channel.queue("currencies.quene_1", durable: true).bind("currencies.fanout")
    channel.queue("currencies.quene_2", durable: true).bind("currencies.fanout")
    channel.queue("currencies.quene_3", durable: true).bind("currencies.fanout")

    direct = channel.direct("currencies.direct")
    channel.queue("currencies.aknowledgements", durable: true).bind("currencies.direct", routing_key: 'aknowledgements')

    connection.close
  end
end
