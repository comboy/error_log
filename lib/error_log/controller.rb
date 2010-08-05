
#TODO :would be nice to check first if ApplicationController is defined and if not use ActionController::Base
module ErrorLog
   class Controller < ActionController::Base

      prepend_view_path File.join(ErrorLog.path,'views')

      # FIXME: this layout declaration should not be needed here for default layout
      # however without it, it does not load default layout for some reason
      layout 'application'

      def index
         @error_logs = ErrorLog::Model.all(:order => 'created_at DESC', :conditions => {:viewed => false}).group_by(&:hash)
         render :template => '/index'
      end

      def set_all_viewed
         ErrorLog::Model.update_all(:viewed => true)
         redirect_to :back
      end
   end
end

