class Medication
  attr_accessor :id, :value, :status, :prescriber, :written_date, :dosage_value, :dosage_units, :dosage_text, :dispense_quantity, :dispense_repeats, :coding_system, :code

  alias_method :key, :value
  alias_method :date, :written_date

  def initialize(id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code)
    @id = id
    @value = value
    @status = status
    @prescriber = prescriber
    @written_date = written_date.try :to_datetime
    @dosage_value = dosage_value
    @dosage_units = dosage_units
    @dosage_text = dosage_text
    @dispense_quantity = dispense_quantity
    @dispense_repeats = dispense_repeats
    @coding_system = coding_system
    @code = code
  end

end
