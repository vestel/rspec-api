require 'spec_helper'
require 'rspec-api/dsl'
require_relative 'gigs_helper'

resource :artist do
  has_attribute :name, type: :string
  has_attribute :website, type: [:null, string: :url]

  accepts_callback :function
  accepts_callback :method

  get '/artists', array: true do
    request '' do
      respond_with :ok
    end
  end

  delete '/concerts/:id' do
    request 'given an unknown', id: unknown(:id) do
      respond_with :not_found
    end
  end
end

def attributes_of(resource)
  RSpec.world.example_groups.find{|x| x.rspec_api[:resource_name] == resource}.rspec_api[:attributes]
end

resource :concert do
  has_attribute :where, type: :string
  has_attribute :year, type: [:null, number: :integer]
  has_attribute :performers, type: {array: attributes_of(:artist)}

  accepts_filter :where, by: :where
  accepts_filter :when, by: :year
  accepts_sort '-time', by: :year, verse: :desc
  accepts_sort 'time', by: :year, verse: :asc
  accepts_sort 'random'
  accepts_page :page

  get '/concerts', array: true do
    request '' do
      respond_with :ok
    end
  end

  get '/locations/:location/concerts', array: true do
    request 'given an existing', location: apply(:downcase, to: existing(:where)) do
      respond_with :ok do |response, url_params|
        expect(response).to have_attributes where: {value: -> v {v.downcase == url_params[:location]}}
      end
    end
  end

  get '/concerts/:id' do
    request 'given an existing', id: existing(:id) do
      respond_with :ok
    end

    request 'given an unknown', id: unknown(:id) do
      respond_with :not_found
    end
  end

  post '/concerts' do
    request 'given a valid', concert: {where: 'Austin'} do
      respond_with :created do |response|
        expect(response).to have_attributes where: {value: 'Austin'}
      end
    end

    request 'given an invalid', concert: {year: 2013} do
      respond_with :unprocessable_entity do |response|
        expect(response).to have_attributes where: {value: ["can't be blank"]}
      end
    end
  end

  put '/concerts/:id' do
    request 'given an existing', id: existing(:id), concert: {year: 2011} do
      respond_with :ok do |response|
        expect(response).to have_attributes year: {value: 2011}
      end
    end

    request 'given an unknown', id: unknown(:id), concert: {year: 2011} do
      respond_with :not_found
    end
  end

  delete '/concerts/:id' do
    request 'given an existing', id: existing(:id) do
      respond_with :no_content
    end

    request 'given an unknown', id: unknown(:id) do
      respond_with :not_found
    end
  end
end