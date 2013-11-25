require 'spec_helper'
require_relative 'local_helper'

Concert.destroy_all
Concert.find_or_create_by(where: 'Woodstock', year: 1969)
Concert.find_or_create_by(where: 'Newport', year: 1969)
Concert.find_or_create_by(where: 'Woodstock', year: 1994)

# Use existing for multiple non-destructive actions
def existing(field)
  Concert.pluck(field).first
end

# Use volatile for destructive actions
def volatile(field)
  Concert.create(where: 'Coachella', year: 2010).read_attribute field
end

resource :concert do
  adapter :rack, app

  has_attribute :where, type: :string
  has_attribute :year, type: [:null, number: :integer]
  has_attribute :performers, type: :array do
    has_attribute :name, type: :string
    has_attribute :website, type: [:null, string: :url]
  end

  accepts filter: :when, by: :year, value: 1969
  accepts sort: '-time', by: :year, verse: :desc
  accepts sort: 'time', by: :year, verse: :asc
  accepts sort: 'random'
  accepts page: :page

  get '/concerts', collection: true do
    respond_with :ok
  end

  get '/locations/:location/concerts', collection: true do
    respond_with :ok, location: existing(:where).downcase do |response, prefix_params|
      expect(response).to have_attributes where: {value: -> v {v.downcase == prefix_params[:location]}}
    end
  end

  get '/concerts/:id' do
    respond_with :ok, id: existing(:id)
    respond_with :not_found, id: unknown(:id)
  end

  post '/concerts' do
    respond_with :created, concert: {where: 'Austin'} do |response|
      expect(response).to have_attributes where: {value: 'Austin'}
    end

    respond_with :unprocessable_entity, concert: {year: 2013} do |response|
      expect(response).to have_attributes where: {value: ["can't be blank"]}
    end
  end

  put '/concerts/:id' do
    respond_with :ok, id: volatile(:id), concert: {year: 2011} do |response|
      expect(response).to have_attributes year: {value: 2011}
    end

    respond_with :not_found, id: unknown(:id), concert: {year: 2011}
  end

  delete '/concerts/:id' do
    respond_with :no_content, id: volatile(:id)
    respond_with :not_found, id: unknown(:id)
  end
end