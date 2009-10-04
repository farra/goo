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

  expose :ping
  def ping(payload)
    "PONG #{payload.inspect}"
  end

  expose :schedule, :increment

  def schedule(interval)
    scheduler.every interval do |job|
      Nanite.request('/counters/increment',nil)
    end
    return "scheduled /counters/increment every #{interval}"
  end

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
