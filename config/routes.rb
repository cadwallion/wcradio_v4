ActionController::Routing::Routes.draw do |map|
  map.resources :votes
  map.wow_idol '/wow_idol', :controller => 'votes', :action => 'index'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.admin '/admin', :controller => "admin/news"
  map.about '/about', :controller => "home", :action => "about"
  map.contact '/contact', :controller => "home", :action => "contact"
  map.donate '/donate', :controller => "home", :action => "donate"
  map.chat '/chat', :controller => "home", :action => "chat"
  map.clear_cache '/clear_cache', :controller => "admin/shows", :action => "clear_cache"
  map.time_zone  '/time_zone', :controller => "home", :action => "time_zone"
  map.blizzcon 'blizzcon', :controller => "home", :action => "blizzcon"
  map.twitter 'twitter', :controller => "twitter", :action => "index"
  map.timezone '/timezone', :controller => "home", :action => "time_zone"
  
  # forums redirects
  map.forum '/forum/*ext', :controller => "home", :action => "forum_redirect"
  map.forums '/forums/*ext', :controller => "home", :action => "forum_redirect"
  
  map.resources :users
	map.resources :ads, :collection => { :list => :get }
  map.resource :session

	# captcha route
	map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  
  # pagination routing -- used for caching purposes
	map.shows_with_pages 'shows/page/:page', :controller => "shows"
  map.home_with_pages '/page/:page', :controller => "home"
  #map.show_episodes_with_pages '/shows/:show_id/episodes/page/:page', :controller => "episodes"
  map.episodes_with_pages 'episodes/page/:page', :controller => "episodes"
  map.classic_shows_with_pages 'shows/classics/page/:page', :controller => "shows", :action => "classics"
  
  map.namespace :admin do |admin|
  	admin.onair '/onair', :controller => 'shows', :action => 'onair'
    admin.resources :news, :active_scaffold => true
    admin.resources :shows, :active_scaffold => true do |show|
      show.resources :episodes, :active_scaffold => true
    end
  end
    
  map.resources :shows, :collection => {:classics => :get, :news => :get} do |show|
  	show.news 'news/', :controller => "shows", :action => "news"
  	show.news_with_pages 'news/page/:page', :controller => "shows", :action => "news"
  	show.episodes_with_pages 'episodes/page/:page', :controller => "episodes"
    show.resources :episodes
    #show.resources :news
  end
  
  map.resources :news
  map.resources :episodes


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default route
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end