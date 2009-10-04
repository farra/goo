$:.unshift *Dir.glob(File.dirname(__FILE__)+"/../../../vendor/plugins/nanite-rails*/lib/")
require 'nanite/rails'
require 'rufus/scheduler'
require 'open-uri'
require 'fileutils'
require 'net/https'
require 'uri'

module NaniteAgent

class Counter
  include Nanite::Actor

  # TODO !!! change this to your localhost, or whatever
  INCREMENT_URL = "http://goo.local/count.js"
  ASYNC_URL = "http://goo.local/count/async_increment.js"

  expose :ping
  def ping(payload)
    "PONG #{payload.inspect}"
  end

  expose :schedule, :increment
  
  # schedule a job to regularly have the rails app
  # send a Nanite request to increment.
  # Order of messages:
  #   - rails /schedule action sends schedule request to nanite
  #   - every [interval] nanite sends HTTP post to rails app
  #   - the rails app responds to post by sending Nanite request to increment
  #   - nanite responds to request by sending a post to increment
  #   - rails app increments the count
  # convoluted, yes, but it exercises the whole chain to ensure it all works
  def schedule(interval)
    scheduler.every interval do |job|
      retrieve ASYNC_URL
    end
    return "scheduled /counters/increment every #{interval}"
  end

  # increment the count by posting to the web application
  def increment(payload)
    retrieve INCREMENT_URL
  end

  private

  def scheduler
    @scheduler ||= Rufus::Scheduler.start_new
  end

  def retrieve(path)
    buffer = String.new
    Nanite::Log.debug "Retrieving: #{path}"
    uri = URI.parse(path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.start {
      http.request_post(uri.path,nil) {|res|
        buffer = res.body
      }
    }
    return buffer
  end

end

end
