module AdminPanel
  CRUD = [:create, :new, :edit, :destroy, :move, :update, :change]
  extend ActiveSupport::Concern
  
  included do
    rescue_from LamAuth::LoginRequiredException, :with => :render_login_required
    helper_method :moderator_logged_in?, :admin_action?
    layout :choose_layout
  end
  
  module ClassMethods
    def admin_panel(conditions = {})
      write_inheritable_hash(:admin_panel_conditions, normalize_conditions(conditions))
      before_filter :moderator_required, conditions
    end

    def admin_panel_conditions
      @admin_panel_conditions ||= read_inheritable_attribute(:admin_panel_conditions)
    end  

    def normalize_conditions(conditions)
      conditions.inject({}) {|hash, (key, value)| hash.merge(key => [value].flatten.map {|action| action.to_s})}
    end
  end
  
  module InstanceMethods
    def moderator_logged_in?
      logged_in? && current_user.moderator?
    end

    def moderator_required
      moderator_logged_in? || raise(LamAuth::LoginRequiredException)
    end
    
    def admin_action?
      if conditions = self.class.admin_panel_conditions
        case
          when only = conditions[:only]
            only.include?(action_name)
          when except = conditions[:except]
            !except.include?(action_name)
          else
            true
        end
      else
        false
      end
    end
    
    def render_login_required
      render :file => '_shared/login_required', :layout => 'application', :status => 401
    end
    
    def choose_layout
      admin_action? ? 'admin' : 'application'
    end
  end
end

