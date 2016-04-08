# question_1.rb

class SecretFile
  def initialize(secret_data, security_log)
    @data = secret_data
    @log = security_log
  end
  
  def data
    @log.create_log_entry
    @data
  end
end

class SecurityLogger
  def create_log_entry
    # ... implementation omitted ...
  end
end
