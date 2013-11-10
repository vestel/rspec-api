require 'spec_helper'
require 'rspec-api/fixtures/local'
require 'rspec-api/http_clients/local'
require 'rspec-api/dsl'

resource :artist do
  has_attribute :name, type: :string
  has_attribute :website, type: [:null, string: :url]

  accepts_sort 'name', by: :name, verse: :asc
  accepts_sort 'name', by: :name, verse: :asc, sort_if: {verse: 'up'}
  accepts_sort 'name', by: :name, verse: :desc, sort_if: {verse: 'down'}
  accepts_callback :function
  accepts_callback :method

  get '/artists', collection: true do
    respond_with :ok
  end

  delete '/artists/:id' do
    respond_with :no_content, id: existing(:id)
    respond_with :not_found, id: unknown(:id)
  end
end

resource :concert do
  has_attribute :where, type: :string
  has_attribute :year, type: [:null, number: :integer]
  has_attribute :performers, type: {array: attributes_of(:artist)}

  accepts_filter :when, by: :year
  accepts_sort '-time', by: :year, verse: :desc
  accepts_sort 'time', by: :year, verse: :asc
  accepts_sort 'random'
  accepts_page :page

  get '/concerts', collection: true do
    respond_with :ok
  end

  get '/locations/:location/concerts', collection: true do
    respond_with :ok, location: apply(:downcase, to: existing(:where))  do |response, route_params|
      expect(response).to have_attributes where: {value: -> v {v.downcase == route_params[:location]}}
    end
  end

  get '/concerts/:id' do
    respond_with :ok, id: existing(:id)
    respond_with :not_found, id: unknown(:id)
  end

  post '/concerts' do
    respond_with :created, concert: valid(where: 'Austin') do |response|
      expect(response).to have_attributes where: {value: 'Austin'}
    end

    respond_with :unprocessable_entity, concert: invalid(year: 2013) do |response|
      expect(response).to have_attributes where: {value: ["can't be blank"]}
    end
  end

  put '/concerts/:id' do
    respond_with :ok, id: existing(:id), concert: valid(year: 2011) do |response|
      expect(response).to have_attributes year: {value: 2011}
    end

    respond_with :not_found, id: unknown(:id), concert: valid(year: 2011)
  end

  delete '/concerts/:id' do
    respond_with :no_content, id: existing(:id)
    respond_with :not_found, id: unknown(:id)
  end
end