require 'arduino_firmata'
require 'pry'

class TemperatureSensor
  attr_reader :arduino

  DIGITAL_PINS = [2, 3, 4]
  MAX_VALUE = 1024
  MAX_VOLTAGE = 5
  MIlI_VOLT = 1000
  SENSOR_PIN = 0
  TEMP_OFFSET = 500
  TEMP_MULTIPLIER = 0.1
  TEMP_MIN = 20
  TEMP_MAX = 35
  PIEZO_PIN = 6
  LOW_PITCH = 50
  HIGH_PITCH = 124

  def initialize()
    @arduino = ArduinoFirmata.connect
  end

  def sensor_value
    @arduino.analog_read SENSOR_PIN
  end

  def convert_to_voltage (value)
    (sensor_value.to_f / MAX_VALUE.to_f) * MAX_VOLTAGE
  end

  def voltage_to_degrees (voltage)
    (voltage * MIlI_VOLT ) * TEMP_MULTIPLIER
  end

  def temperature
    voltage = convert_to_voltage(sensor_value)
    voltage_to_degrees(voltage)
  end

  def reset_pins
    DIGITAL_PINS.each do |pin|
      @arduino.digital_write pin, false
    end
  end

  def control_LEDs
    reset_pins
    # binding.pry
    if temperature < TEMP_MIN
      @arduino.digital_write(DIGITAL_PINS[0], true)
      @arduino.analog_write(PIEZO_PIN, LOW_PITCH)
    elsif  temperature >  TEMP_MAX
      @arduino.digital_write(DIGITAL_PINS[1], true)
      @arduino.analog_write(PIEZO_PIN, HIGH_PITCH)
    else
      @arduino.digital_write(DIGITAL_PINS[2], true)
    end
  end

end

temperature = TemperatureSensor.new()
temperature.control_LEDs



