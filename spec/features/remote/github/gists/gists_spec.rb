require 'spec_helper'
require_relative '../github_helper'

# http://developer.github.com/v3/gists/
resource :gist do
  has_attribute :url, type: {string: :url}
  has_attribute :id, type: :string
  has_attribute :description, type: [:null, :string]
  has_attribute :public, type: :boolean
  has_attribute :user, type: :object do
    has_attribute :login, type: :string
    has_attribute :id, type: {number: :integer}
    has_attribute :avatar_url, type: [:null, string: :url]
    has_attribute :gravatar_id, type: [:null, :string]
    has_attribute :url, type: {string: :url}
    has_attribute :html_url, type: {string: :url}          # not documented
    has_attribute :followers_url, type: {string: :url}     # not documented
    has_attribute :following_url, type: {string: :url}     # not documented
    has_attribute :gists_url, type: {string: :url}         # not documented
    has_attribute :starred_url, type: {string: :url}       # not documented
    has_attribute :subscriptions_url, type: {string: :url} # not documented
    has_attribute :organizations_url, type: {string: :url} # not documented
    has_attribute :repos_url, type: {string: :url}         # not documented
    has_attribute :events_url, type: {string: :url}        # not documented
    has_attribute :type, type: :string                     # not documented
    has_attribute :site_admin, type: :boolean              # not documented
  end
  # TODO: cannot have nested attributes for now because the KEY changes (and
  # it is the filename), so need new syntax for this
  # has_attribute :files, type: :object do
  #   has_attribute :'ring.erl', type: :object do
  #     has_attribute :size, type: {number: :integer}
  #     has_attribute :filename, :string
  #     has_attribute :raw_url, type: {string: :url}
  #     # has_attribute :type, type: :string              # not documented
  #     # has_attribute :language, type: [:null, :string] # not documented
  #   end
  # end
  has_attribute :comments, type: {number: :integer}
  has_attribute :comments_url, type: {string: :url}
  has_attribute :html_url, type: {string: :url}
  has_attribute :git_pull_url, type: :string
  has_attribute :git_push_url, type: :string
  has_attribute :created_at, type: {string: :timestamp}
  has_attribute :forks_url, type: {string: :url}        # not documented
  has_attribute :commits_url, type: {string: :url}      # not documented
  has_attribute :updated_at, type: {string: :timestamp} # not documented

  accepts filter: :since, by: :updated_at, compare_with: :>=, value: '2012-10-10T00:00:00Z'

  get '/users/:user/gists', collection: true do
    respond_with :ok, user: existing(:user)
  end

  get '/gists', collection: true do
    respond_with :ok
  end

  get '/gists/public', collection: true do
    respond_with :ok
  end

  get '/gists/starred', collection: true do
    respond_with :ok
  end

  get '/gists/:id' do
    respond_with :ok, id: existing(:gist_id)
  end

  post '/gists' do
    respond_with :created, public: false, files: {file1: {content: 'txt'}} do |response|
      condition = -> files {files[:file1][:content] == 'txt'}
      expect(response).to have_attributes files: {value: condition}
    end

    respond_with :unprocessable_entity, public: false do |response|
      errors = [{resource: "Gist", code: "missing_field", field: "files"}]
      expect(response).to have_attributes errors: {value: errors}
    end
  end

  # Wrong docs, see http://git.io/pke5Ww  # Getting 201 instead
  # post '/gists', failing: true do
  #   respond_with :unprocessable_entity, files: {file1: {content: 'txt'}}
  # end

  patch '/gists/:id' do
    respond_with :ok, id: volatile(:gist_id), description: 'bar' do |response|
      expect(response).to have_attributes description: {value: 'bar'}
    end
  
    respond_with :not_found, id: unknown(:gist_id), description: 'bar'
  end
  
  put '/gists/:id/star' do
    respond_with :no_content, id: volatile(:unstarred_gist_id)
  end

  delete '/gists/:id/star' do
    respond_with :no_content, id: volatile(:starred_gist_id)
  end

  get '/gists/:id/star' do
    respond_with :no_content, id: existing(:starred_gist_id)
    respond_with :not_found, id: existing(:unstarred_gist_id)
  end

  post '/gists/:id/forks' do
    respond_with :created, id: existing(:someone_elses_gist_id) do |response, prefix_params|
      expect(response).not_to have_attributes id: {value: prefix_params[:id]}
    end
  end

  delete '/gists/:id' do
    respond_with :no_content, id: volatile(:gist_id)
  end

  post '/gists' do
    respond_with :created, public: false, files: {file1: {content: 'foo'}} do |response|
      condition = -> files {files[:file1][:content] == 'foo'}
      expect(response).to have_attributes files: {value: condition}
    end
  end
end