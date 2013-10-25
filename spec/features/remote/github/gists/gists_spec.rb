# encoding: UTF-8

require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/gists/
resource 'Gists' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :url, :string, format: :url
  has_attribute :id, :string
  has_attribute :description, :string, can_be_nil: true
  has_attribute :public, :boolean
  has_attribute :user, :object do
    has_attribute :login, :string
    has_attribute :id, :number, format: :integer
    has_attribute :avatar_url, :string, format: :url, can_be_nil: true
    has_attribute :gravatar_id, :string, can_be_nil: true
    has_attribute :url, :string, format: :url
    has_attribute :html_url, :string, format: :url          # not documented for index but it's there:
    has_attribute :followers_url, :string, format: :url     # not documented for index but it's there:
    has_attribute :following_url, :string, format: :url     # not documented for index but it's there:
    has_attribute :gists_url, :string, format: :url         # not documented for index but it's there:
    has_attribute :starred_url, :string, format: :url       # not documented for index but it's there:
    has_attribute :subscriptions_url, :string, format: :url # not documented for index but it's there:
    has_attribute :organizations_url, :string, format: :url # not documented for index but it's there:
    has_attribute :repos_url, :string, format: :url         # not documented for index but it's there:
    has_attribute :events_url, :string, format: :url        # not documented for index but it's there:
    has_attribute :type, :string           # not documented for index but it's there:
    has_attribute :site_admin, :boolean    # not documented for index but it's there:
  end
  has_attribute :files, :object

  # TODO: cannot have nested attributes for now because the KEY changes (and
  # it is the filename), so need new syntax for this
  # has_attribute :files, :object do
  #   has_attribute :'ring.erl', :object do
  #     has_attribute :size, :number, format: :integer
  #     has_attribute :filename, :string
  #     has_attribute :raw_url, :string, format: :url
  #     # has_attribute :type, :string                       # not documented for index but it's there:
  #     # has_attribute :language, :string, can_be_nil: true # not documented for index but it's there:
  #   end
  # end
  has_attribute :comments, :number, format: :integer
  has_attribute :comments_url, :string, format: :url
  has_attribute :html_url, :string, format: :url
  has_attribute :git_pull_url, :string # should be url: :public_git (git:// url)
  has_attribute :git_push_url, :string # should be url: :private_git (git@ url)
  has_attribute :created_at, :string, format: :timestamp
  has_attribute :forks_url, :string, format: :url        # not documented for index but it's there:
  has_attribute :commits_url, :string, format: :url      # not documented for index but it's there:
  has_attribute :updated_at, :string, format: :timestamp # not documented for index but it's there:

  accepts_filter :since, on: :updated_at, comparing_with: -> since, updated_at {since <= updated_at}

  get '/users/:user/gists', array: true do
    request 'List a user’s gists', user: existing(:user) do
      respond_with :ok
    end
  end

  get '/gists', array: true do
    request 'List the authenticated user’s gists' do
      respond_with :ok
    end
  end

  get '/gists/public', array: true do
    request 'List all public gists' do
      respond_with :ok
    end
  end

  get '/gists/starred', array: true do
    request 'List the authenticated user’s starred gists' do
      respond_with :ok
    end
  end

  get '/gists/:id' do
    request 'Get a single gist', id: existing(:gist_id) do
      respond_with :ok
    end
  end

  post '/gists' do
    request 'given a valid', public: false, files: {file1: {content: 'txt'}} do
      respond_with :created do |gist|
        expect(gist['files']['file1']).to have_field :content, value: 'txt'
      end
    end

    request 'without :files', public: false do
      respond_with :unprocessable_entity do |errors|
        expect(errors).to have_field :errors, value: [{"resource"=>"Gist", "code"=>"missing_field", "field"=>"files"}]
      end
    end
  end

  post '/gists', failing: true do # Wrong docs, see http://git.io/pke5Ww
    request 'without :public', files: {file1: {content: 'txt'}} do
      respond_with :unprocessable_entity # Getting 201 instead
    end
  end

  patch '/gists/:id' do
    request 'given an existing', id: existing(:gist_id), description: 'Yo!' do
      respond_with :ok do |gist|
        expect(gist).to have_field :description, value: 'Yo!'
      end
    end

    request 'given an unknown', id: unknown(:gist_id), description: 'Yo!' do
      respond_with :not_found
    end
  end

  put '/gists/:id/star' do
    request 'given an existing', id: existing(:gist_id) do
      respond_with :no_content
    end
  end

  delete '/gists/:id/star' do
    request 'given an existing', id: existing(:gist_id) do
      respond_with :no_content
    end
  end

  get '/gists/:id/star' do
    request 'given an existing', id: existing(:starred_gist_id) do
      respond_with :no_content
    end

    request 'given an existing', id: existing(:unstarred_gist_id) do
      respond_with :not_found
    end
  end

  post '/gists/:id/forks' do
    request 'given an existing', id: existing(:someone_elses_gist_id) do
      respond_with :created do |gist, request_params|
        expect(gist['id']).not_to eq request_params['id']
      end
    end
  end

  # NOTE: This is the only one missing, because I need to create one first!
  delete '/gists/:id', wip: true do
    request 'given an existing', id: existing(:id) do
      respond_with :no_content
    end
  end
end