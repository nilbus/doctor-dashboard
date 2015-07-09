class Observation
  attr_accessor :display, :id, :value, :units, :comment, :date, :status, :reliability, :code_system, :code, :code_display

  alias_method :key, :code_display

  def initialize(display, id, value, units, comment, date, status, reliability, code_system, code, code_display)
    @display = display
    @id = id
    @value = value
    @units = units
    @comment = comment
    @date = date.try :to_datetime
    @status = status
    @reliability = reliability
    @code_system = code_system
    @code = code
    @code_display = code_display
  end

end
