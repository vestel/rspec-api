require 'spec_helper'
require 'rspec-api/dsl'
require_relative 'gigs_helper'

resource 'Concerts' do
  has_attribute :where, :string
  has_attribute :year, :integer, can_be_nil: true
  has_attribute :performers, :array do
    has_attribute :name, :string
    has_attribute :website, :url, can_be_nil: true
  end

  accepts_filter :when, on: :year

  accepts_sort :time, on: :year

  accepts_page :page

  get '/concerts', array: true do
    request '' do
      respond_with :ok
    end
  end

  get '/locations/:location/concerts', array: true do
    request 'given an existing', location: apply(:downcase, to: existing(:where)) do
      respond_with :ok do |concerts, request_params|
        expect(concerts).to have_fields :where, value: request_params[:location], after: :downcase
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
      respond_with :created do |concert|
        expect(concert).to have_field :where, value: 'Austin'
      end
    end

    request 'given an invalid', concert: {year: 2013} do
      respond_with :unprocessable_entity do |errors|
        expect(errors).to have_field :where, value: ["can't be blank"]
      end
    end
  end

  put '/concerts/:id' do
    request 'given an existing', id: existing(:id), concert: {year: 2011} do
      respond_with :ok do |concert|
        expect(concert).to have_field :year, value: 2011
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