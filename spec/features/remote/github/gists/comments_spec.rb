require 'spec_helper'
require_relative '../github_helper'

# http://developer.github.com/v3/gists/comments/
resource :gist_comment do
  has_attribute :id, type: {number: :integer}
  has_attribute :url, type: {string: :url}
  has_attribute :body, type: :string
  has_attribute :user, type: :object do
    has_attribute :login, type: :string
    has_attribute :id, type: {number: :integer}
    has_attribute :avatar_url, type: [:null, string: :url]
    has_attribute :gravatar_id, type: [:null, :string]
    has_attribute :url, type: {string: :url}
  end
  has_attribute :created_at, type: {string: :timestamp}

  get '/gists/:gist_id/comments', collection: true do
    respond_with :ok, gist_id: existing(:gist_id)
    respond_with :not_found, gist_id: unknown(:gist_id)
  end

  get '/gists/:gist_id/comments/:id' do
    respond_with :ok, gist_id: existing(:gist_id), id: existing(:gist_comment_id)
    respond_with :not_found, gist_id: existing(:gist_id), id: unknown(:gist_comment_id)
  end

  post '/gists/:gist_id/comments' do
     respond_with :unprocessable_entity, gist_id: existing(:gist_id), body: '' do |response|
       expect(response).to have_attributes errors: {value: [{resource: "GistComment", code: "missing_field", field: "body"}]}
     end

    respond_with :created, gist_id: existing(:gist_id), body: 'New comment' do |response|
      expect(response).to have_attributes body: {value: 'New comment'}
    end
  end

  patch '/gists/:gist_id/comments/:id' do
    respond_with :ok, gist_id: existing(:gist_id), id: volatile(:gist_comment_id), body: 'bar' do |response|
      expect(response).to have_attributes body: {value: 'bar'}
    end
  end

  delete '/gists/:gist_id/comments/:id' do
    respond_with :no_content, gist_id: existing(:gist_id), id: volatile(:gist_comment_id)
  end
end