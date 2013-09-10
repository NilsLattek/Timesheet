class ApplicationController < ActionController::Base
  protect_from_forgery

  # rails 4 fix for cancan: https://github.com/ryanb/cancan/issues/835#issuecomment-18663815
  before_filter do
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    if not user_signed_in?
      redirect_to new_user_session_url
    else
      redirect_to root_url, :alert => exception.message
    end
  end
end
