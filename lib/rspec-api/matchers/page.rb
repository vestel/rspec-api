RSpec::Matchers.define :have_pagination_links do |page|
  match do |response_headers|
    if page.nil?
      true
    else
      links = response_headers['Link'] || '' # see http://git.io/CUz3-Q
      rels = links.split(',').map{|link| link[/<.+?>; rel="(.*)"$/, 1]}
      rels.sort == ['first', 'prev']
    end
  end

  description do
    %Q(include 'Link' (for pagination))
  end

  failure_message_for_should do |response_headers|
    %Q(should #{description}, but are #{response_headers})
  end
end