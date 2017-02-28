require "open_class_alarm/version"

module OpenClassAlarm
  @status = :disable
  @modules = ObjectSpace.each_object(Module).to_a

  def self.enable
    @status = :enable

    if block_given?
      yield
      disable
    end
  end

  def self.disable
    @status = :disable
  end

  TracePoint.trace(:class) do |tp|
    if @modules.include?(tp.self)
      if @status == :enable && tp.self.instance_of?(Class)
        warn "#{tp.path}:#{tp.lineno} found open class `#{tp.self}'"
      end
    else
      @modules << tp.self
    end
  end
end
