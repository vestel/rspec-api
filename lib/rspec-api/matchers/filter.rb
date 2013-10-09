RSpec::Matchers.define :be_filtered_by do |json_value, options = {}|
  filtered_attribute = options[:on]
  compare = options[:comparing_with] || Proc.new{|x,y| x == y}

  match do |items|
    if filtered_attribute.nil?
      true
    else
      items.all? do |item|
        # TODO: Don't always use string
        compare.call json_value, item[filtered_attribute.to_s].to_s
      end
    end
  end

  description do
    if filtered_attribute.nil?
      %Q(not be filtered by any specific attribute)
    else
      # TODO: Change description based on operator
      %Q(be filtered by #{filtered_attribute.to_json} => #{json_value})
    end
  end

  failure_message_for_should do |items|
    %Q(should #{description}, but is #{items})
  end
end