class HelloController < ApplicationController
  def index
  end

  def show
    Rails.logger.info "log form hello conroller!"
  end
end
