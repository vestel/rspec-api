require 'spec_helper'
require 'rspec-api/resource'

describe 'accepts' do
  extend RSpecApi::Resource

  context ':sort' do
    accepts sort: :place, by: :location

    get '/' do
      sort = metadata[:rspec_api_params][:extra_requests].first
      it { expect(sort[:params]).to eq sort: :place }
      it { expect(sort[:expect]).to eq sort: {by: :location} }
    end
  end

  context ':filter' do
    accepts filter: :active, by: :enabled, value: true

    get '/' do
      filter = metadata[:rspec_api_params][:extra_requests].first
      it { expect(filter[:params]).to eq active: true }
      it { expect(filter[:expect]).to eq filter: {by: :enabled, value: true} }
    end
  end

  context ':page' do
    accepts page: :p

    get '/' do
      page = metadata[:rspec_api_params][:extra_requests].first
      it { expect(page[:params]).to eq p: 2 }
      it { expect(page[:expect]).to eq page_links: true }
    end
  end

  context ':callback' do
    accepts callback: :alert

    get '/' do
      callback = metadata[:rspec_api_params][:extra_requests].first
      it { expect(callback[:params]).to eq alert: 'anyCallback' }
      it { expect(callback[:expect]).to eq callback: 'anyCallback' }
    end
  end
end