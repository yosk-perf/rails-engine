class HelloController < ApplicationController
  def index
  end

  def data
    render json: { a: 1 }
  end

  def show
    Rails.logger.info "log form hello conroller!"
  end
end
