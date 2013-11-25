require 'spec_helper'
require_relative 'local_helper'

Artist.find_or_create_by(name: 'Madonna', website: 'http://www.madonna.com')
Artist.find_or_create_by(name: 'R.E.M.', website: 'http://www.remhq.com')

# Use volatile for destructive actions
def volatile(field)
  Artist.create!(name: 'Cher', website: 'http://www.cher.com').read_attribute field
end

resource :artist do
  adapter :rack, app

  has_attribute :name, type: :string
  has_attribute :website, type: [:null, string: :url]

  accepts sort: 'name', by: :name, verse: :asc
  accepts sort: 'name', by: :name, verse: :asc, sort_if: {verse: 'up'}
  accepts sort: 'name', by: :name, verse: :desc, sort_if: {verse: 'down'}
  accepts callback: :function
  accepts callback: :method

  get '/artists', collection: true do
    respond_with :ok
  end

  delete '/artists/:id' do
    respond_with :no_content, id: volatile(:id)
    respond_with :not_found, id: unknown(:id)
  end
end