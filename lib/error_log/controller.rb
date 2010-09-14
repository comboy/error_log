
module ErrorLog
   module Controller# < ActionController::Base

      def index

         # Rails 2.x compatible finder
         scope = ErrorLog::Model

         unless params[:errors_category].to_s.empty?
            @errors_category = params[:errors_category]
            scope = scope.where(:category => @errors_category)
         end
        
         # FIXME: obviously group by should be done on the database side
         # the problem is, I'm not sure how to do this in the way that would work
         # for all adapters, blah blah CONCLUSION: avoid thousands of errors ;)
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

      def set_viewed
         logs = ErrorLog::Model.where(:viewed => false, :error_hash => params[:error_hash])
         logs.update_all(:viewed => true)
         render :update do |page|
            page[params[:row_div_id]].hide
         end
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
