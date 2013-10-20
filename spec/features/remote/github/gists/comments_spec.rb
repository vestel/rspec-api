require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/gists/comments/
resource 'GistComments' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :id, :integer
  has_attribute :url, :url
  has_attribute :body, :string
  has_attribute :user, :hash do
    has_attribute :login, :string
    has_attribute :id, :integer
    has_attribute :avatar_url, :url, can_be_nil: true
    has_attribute :gravatar_id, :string, can_be_nil: true
    has_attribute :url, :url
  end
  has_attribute :created_at, :timestamp

  get '/gists/:gist_id/comments', array: true do
    request 'given an existing', gist_id: existing(:gist_id) do
      respond_with :ok
    end

    request 'given an unknown', gist_id: unknown(:gist_id) do
      respond_with :not_found
    end
  end

  get '/gists/:gist_id/comments/:id' do
    request 'given an existing', gist_id: existing(:gist_id), id: existing(:id) do
      respond_with :ok
    end

    request 'given an unknown', gist_id: existing(:gist_id), id: unknown(:id) do
      respond_with :not_found
    end
  end

  post '/gists/:gist_id/comments' do
    request 'given a valid', gist_id: existing(:gist_id), body: 'Just a comment' do
      respond_with :created do |comment|
        expect(comment).to have_field :body, value: 'Just a comment'
      end
    end

    request 'given an invalid', gist_id: existing(:gist_id), body: '' do
      respond_with :unprocessable_entity do |errors|
        expect(errors).to have_field :errors, value: [{"resource"=>"GistComment", "code"=>"missing_field", "field"=>"body"}]
      end
    end
  end
end