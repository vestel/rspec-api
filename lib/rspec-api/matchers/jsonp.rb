RSpec::Matchers.define :be_a_jsonp do |callback|
  match do |response_body|
    if callback.nil?
      true
    else
      response.body =~ %r[^callback\((.*?)\)$]
    end
  end

  description do
    %Q(be a JSONP callback)
  end

  failure_message_for_should do |response_body|
    %Q(should #{description}, but is #{response_body})
  end
end