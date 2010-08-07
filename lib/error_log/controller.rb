
module ErrorLog
   module Controller# < ActionController::Base

      def index

         # Rails 2.x compatible finder
         scope = ErrorLog::Model

         unless params[:errors_category].to_s.empty?
            @errors_category = params[:errors_category]
            scope = scope.where(:category => @errors_category)
         end
         
         @error_logs = scope.all(
            :order => 'created_at DESC', 
            :conditions => {
               :viewed => false
            }
         ).group_by(&:error_hash)

         @category_counts = ErrorLog::Model.count(
            :conditions => {:viewed => false},
            :group => :category 
         )

         render :template => '/index'
      end

      def set_all_viewed
         ErrorLog::Model.update_all(:viewed => true)
         redirect_to :back
      end

   end
end

class ActionController::Base

   rescue_from Exception, :with => :error_log_rescue

   def self.error_logs
      append_view_path File.join(ErrorLog.path,'views')
      self.send(:include,ErrorLog::Controller) 
   end

   def error_log_rescue(e)
      err = ErrorLog::Model.new(
        :error => e.to_str,
        :backtrace => e.backtrace,
        :category => 'rails'
      )
      err.save
      raise e 
   end

end
