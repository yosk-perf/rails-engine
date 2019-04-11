Rails.application.routes.draw do
  get 'hello/index'
  get 'hello/show'
  get 'hello/data'
  mount Yosk::Engine => "/yosk"
end
