Rails.application.routes.draw do
  get 'hello/index'
  get 'hello/show'
  mount Yosk::Engine => "/yosk"
end
