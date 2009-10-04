class CountsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index
    @count = Count.first
    if @count.nil?
      @count = Count.new (:total => 0)
      @count.save
    end
  end

  def create
    increment
  end

  def update
    increment
  end

  def schedule
    interval = params[:count][:interval]+"s"
    Nanite.request('/counters/schedule',interval)
    redirect_to :action => :index
  end

  def async_increment
    Nanite.request('/counters/increment',nil) do |res|
      Rails.logger.info "Finished increment => #{res}"
    end
    respond_to do |wants|
      wants.html {redirect_to :action => :index}
      wants.js   {render :text => '{"requested":true' }
    end
  end

  private

  def increment
    @count = Count.first
    @count.total += 1
    @count.save
    respond_to do |wants|
      wants.html {redirect_to :action => :index}
      wants.js   {render :text => '{"total":'+@count.total.to_s+'}' }
    end
  end
  

end
