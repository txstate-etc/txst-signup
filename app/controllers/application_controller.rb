# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotification::Notifiable
  before_filter :cas_setup
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # this is responible for putting the login ID of the current
  # user into session[ :user ]. It's set up to work with CAS, 
  # but should be easily tweaked to support other login systems.
  protected 
  def authenticate
    return true if session[ :user ]
    
    if session[ :cas_user ]
      user = User.find_or_lookup_by_login(session[ :cas_user ])
      session[ :user ] = user.id if user
    else
      session[:cas_redirect] = request.url
      return false unless CASClient::Frameworks::Rails::Filter.filter( self )
      user = User.find_or_lookup_by_login(session[ :cas_user ]) if session[ :cas_user ] 
      session[ :user ] = user.id if user
    end
    
    if session[:user].blank?
      flash[ :error ] = "Oops! We could not log you in. If you just received your login ID, you may need to wait 24 hours before it's available."
      redirect_to root_url
      return false 
    end
    
    return true
  end

  # hard to generate the login URL in the config file where we set up
  # all the other CAS options
  # So we set it here and put it in a filter
  def cas_setup
    CASClient::Frameworks::Rails::Filter.config[:service_url] = url_for :login
  end
  
  helper_method :current_user
  helper_method :cas_user
  helper_method :authorized?
  private
  def current_user
    @_current_user ||= session[ :user ] && User.find(session[ :user ])
  end

  def cas_user
    session[ :cas_user ]
  end
  
  def authorized?(item=nil)
    current_user && current_user.authorized?(item)
  end
  
  
end
