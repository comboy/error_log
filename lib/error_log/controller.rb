

require 'haml'

module ErrorLog
  module Controller

    def index

      prepare_opts

      scope = ErrorLog::Model

      scope = scope.where(:category => @errors_category) unless @errors_category.to_s.empty? 

      @error_logs = scope.all(
        :select => 'count(*) as count_all,
           min(created_at) as created_at_first, 
           max(created_at) as created_at_last,
           min(backtrace) as backtrace,
           min(error) as error,
           min(category) as category,
           min(params) as params,
           max(level_id) as level_id,
           error_hash',
        :order => @opts[:sort_by],
        :group => 'error_hash',
        :conditions => {
        :viewed => viewing_archive? 
      })


      @category_counts = ErrorLog::Model.count(
        :conditions => {:viewed => viewing_archive?},
        :group => :category 
      )

      render :template => '/index'
    end

    def set_all_viewed
      ErrorLog::Model.update_all(:viewed => true)
      redirect_to :back
    end

    def delete_all_archived
      ErrorLog::Model.where(:viewed => true).destroy_all
      redirect_to :back
    end

    # set all logs with given error hash viewed
    def set_viewed
      logs = ErrorLog::Model.where(:viewed => false, :error_hash => params[:error_hash])
      logs.update_all(:viewed => true)
      render :update do |page|
        page[params[:row_div_id]].hide
      end
    end

    # destroy all archived logs with given error hash
    def delete
      logs = ErrorLog::Model.where(:viewed => true, :error_hash => params[:error_hash])
      logs.destroy_all
      render :update do |page|
        page[params[:row_div_id]].hide
      end
    end

    protected

    def viewing_archive?
      @opts[:archive] == '1'
    end

    def self.included(klass)
      klass.send(:helper_method,:viewing_archive?)
    end

    def prepare_opts
      sorts = {
        'last' => 'created_at_last DESC',
        'first' => 'created_at_first DESC',
        'count' => 'count_all DESC',
        'level' => 'level_id DESC',
        'level_count' => 'level DESC, count_all DESC'
      }

      @opts = {
        :archive => '0',
        :sort_by => sorts['last'],
        :category => nil
      }

      session[:erlgs_archive] = params[:archive] if params[:archive] 
      @opts[:archive] = session[:erlgs_archive]

      session[:erlgs_sort_by] = params[:sort_by] if params[:sort_by]
      @opts[:sort_by] = sorts[session[:erlgs_sort_by]]

      session[:erlgs_category] = params[:category] if params[:category]
      @opts[:category] = @errors_category = session[:erlgs_category]
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
