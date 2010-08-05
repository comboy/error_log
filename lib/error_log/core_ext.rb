class Object
   def catch_error(category='catch_error', options={})
      raise "no block given!" unless block_given?
      begin
         yield
         return false
      rescue Exception => e
         ErrorLog::Model.create(
           :error => e.to_str,
           :backtrace => e.backtrace,
           :category => category
         )
      end

   end
end
