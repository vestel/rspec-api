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
    request_with id: existing(:id) do
      respond_with :no_content
    end

    request_with id: unknown(:id) do
      respond_with :not_found
    end
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
  # accepts_page :page
  #
  # get '/concerts', collection: true do
  #   respond_with :ok
  # end

  get '/locations/:location/concerts', collection: true do
    request_with location: apply(:downcase, to: existing(:where)) do
      respond_with :ok do |response, route_params|
        # debugger unless JSON(response.body).all?{|x| x['where'].downcase == route_params[:location]}
        expect(response).to have_attributes where: {value: -> v {v.downcase == route_params[:location]}}
      end
    end
  end

  get '/concerts/:id' do
    request_with id: existing(:id) do
      respond_with :ok
    end

    request_with id: unknown(:id) do
      respond_with :not_found
    end
  end

  post '/concerts' do
    request_with concert: valid(where: 'Austin') do
      respond_with :created do |response|
        expect(response).to have_attributes where: {value: 'Austin'}
      end
    end

    request_with concert: invalid(year: 2013) do
      respond_with :unprocessable_entity do |response|
        expect(response).to have_attributes where: {value: ["can't be blank"]}
      end
    end
  end

  put '/concerts/:id' do
    request_with id: existing(:id), concert: valid(year: 2011) do
      respond_with :ok do |response|
        expect(response).to have_attributes year: {value: 2011}
      end
    end

    request_with id: unknown(:id), concert: valid(year: 2011) do
      respond_with :not_found
    end
  end

  delete '/concerts/:id' do
    request_with id: existing(:id) do
      respond_with :no_content
    end

    request_with id: unknown(:id) do
      respond_with :not_found
    end
  end
end