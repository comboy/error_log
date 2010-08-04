
#TODO :would be nice to check first if ApplicationController is defined and if not use ActionController::Base
module ErrorLog
   class Controller < ActionController::Base
      self.view_paths = File.join(ErrorLog.path,'views')
      def index
         @error_logs = ErrorLog::Model.all(:order => 'created_at DESC')
         render :template => '/index'
      end
   end
end

