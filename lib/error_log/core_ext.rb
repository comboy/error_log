class Object
   

   # Handy way to catch exceptions 
   def catch_error(category='catch_error', options={})
      raise "no block given!" unless block_given?
      begin
         yield
         return false
      rescue Exception => e
         ErrorLog.log(options[:level] || :error, e.to_str,
            :backtrace => e.backtrace,
            :params => options[:params],
            :category => category)
      end
   end

end
