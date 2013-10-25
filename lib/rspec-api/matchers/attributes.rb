RSpec::Matchers.define :have_attribute do |name, options = {}|
  name, can_be_nil, type, format = name.to_s, options[:can_be_nil], options[:type], options[:format]

  match do |json|
    Array.wrap(json).all? do |item|
      if (options[:parent_can_be_nil] and item.nil?) || (options[:parent_can_be_empty] and item.empty?)
        true
      elsif can_be_nil
        item.key?(name)
      else
        matches_type?(item[name], type) && matches_format?(item[name], format)
      end
    end
  end

  description do # TODO: add parent name
    type = "#{options[:type]}#{' or nil' if can_be_nil}"
    %Q(include the field #{name.to_json} of type #{type})
  end

  failure_message_for_should do |json|
    %Q(should #{description}, but is #{json})
  end
end

def matches_type?(value, type) # JSON => Ruby type conversion
  case type
    when :number then value.is_a? Numeric # TODO: Double-precision floating-point
    when :array then value.is_a? Array
    when :object then value.is_a? Hash
    when :string then value.is_a? String
    when :null then value.nil?
    when :boolean then [TrueClass, FalseClass].include? value.class
  end
end

def matches_format?(value, format)
  case format
    when :url then value =~ URI::regexp
    when :timestamp then DateTime.iso8601 value rescue false
    when :email then value =~ %r{(?<name>.+?)@(?<host>.+?)\.(?<domain>.+?)}
    else true
  end
end