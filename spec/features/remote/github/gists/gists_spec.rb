# encoding: UTF-8
require 'github_helper'

# TODO: don't duplicate this code from repos_spec, but require it in some
# way that only loads the attributes, without running the specs
resource :user do
  has_attribute :login, type: :string
  has_attribute :id, type: {number: :integer}
  has_attribute :avatar_url, type: [:null, string: :url]
  has_attribute :gravatar_id, type: [:null, :string]
  has_attribute :url, type: {string: :url}
  has_attribute :html_url, type: {string: :url}          # not documented for index but it's there:
  has_attribute :followers_url, type: {string: :url}     # not documented for index but it's there:
  has_attribute :following_url, type: {string: :url}     # not documented for index but it's there:
  has_attribute :gists_url, type: {string: :url}         # not documented for index but it's there:
  has_attribute :starred_url, type: {string: :url}       # not documented for index but it's there:
  has_attribute :subscriptions_url, type: {string: :url} # not documented for index but it's there:
  has_attribute :organizations_url, type: {string: :url} # not documented for index but it's there:
  has_attribute :repos_url, type: {string: :url}         # not documented for index but it's there:
  has_attribute :events_url, type: {string: :url}        # not documented for index but it's there:
  has_attribute :type, type: :string                     # not documented for index but it's there:
  has_attribute :site_admin, type: :boolean              # not documented for index but it's there:
end


# http://developer.github.com/v3/gists/
resource :gist do
  extend Authorize
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :url, type: {string: :url}
  has_attribute :id, type: :string
  has_attribute :description, type: [:null, :string]
  has_attribute :public, type: :boolean
  has_attribute :user, type: {object: attributes_of(:user)}
  has_attribute :files, type: :object

  # TODO: cannot have nested attributes for now because the KEY changes (and
  # it is the filename), so need new syntax for this
  # has_attribute :files, type: :object do
  #   has_attribute :'ring.erl', type: :object do
  #     has_attribute :size, type: {number: :integer}
  #     has_attribute :filename, :string
  #     has_attribute :raw_url, type: {string: :url}
  #     # has_attribute :type, type: :string                       # not documented for index but it's there:
  #     # has_attribute :language, type: [:null, :string] # not documented for index but it's there:
  #   end
  # end
  has_attribute :comments, type: {number: :integer}
  has_attribute :comments_url, type: {string: :url}
  has_attribute :html_url, type: {string: :url}
  has_attribute :git_pull_url, type: :string # should be url: :public_git (git:// url)
  has_attribute :git_push_url, type: :string # should be url: :private_git (git@ url)
  has_attribute :created_at, type: {string: :timestamp}
  has_attribute :forks_url, type: {string: :url}        # not documented for index but it's there:
  has_attribute :commits_url, type: {string: :url}      # not documented for index but it's there:
  has_attribute :updated_at, type: {string: :timestamp} # not documented for index but it's there:

  accepts_filter :since, by: :updated_at, comparing_with: -> since, updated_at {since <= updated_at}

  get '/users/:user/gists', collection: true do
    request_with user: existing(:user) do
      respond_with :ok
    end
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
    request_with id: existing(:gist_id) do
      respond_with :ok
    end
  end

  post '/gists' do
    request_with valid(public: false, files: {file1: {content: 'txt'}}) do
      respond_with :created do |response|
        condition = -> files {files[:file1][:content] == 'txt'}
        expect(response).to have_attributes files: {value: condition}
      end
    end

    request_with invalid(public: false) do
      respond_with :unprocessable_entity do |response|
        errors = [{resource: "Gist", code: "missing_field", field: "files"}]
        expect(response).to have_attributes errors: {value: errors}
      end
    end
  end

  # Wrong docs, see http://git.io/pke5Ww
  # post '/gists', failing: true do
  #   request_with 'without :public', files: {file1: {content: 'txt'}} do
  #     respond_with :unprocessable_entity # Getting 201 instead
  #   end
  # end

  patch '/gists/:id' do
    request_with id: existing(:gist_id), description: 'Yo!' do
      respond_with :ok do |response|
        expect(response).to have_attributes description: {value: 'Yo!'}
      end
    end

    request_with id: unknown(:gist_id), description: 'Yo!' do
      respond_with :not_found
    end
  end

  put '/gists/:id/star' do
    request_with id: existing(:gist_id) do
      respond_with :no_content
    end
  end

  delete '/gists/:id/star' do
    request_with id: existing(:gist_id) do
      respond_with :no_content
    end
  end

  get '/gists/:id/star' do
    request_with id: existing(:starred_gist_id) do
      respond_with :no_content
    end

    request_with id: existing(:unstarred_gist_id) do
      respond_with :not_found
    end
  end

  post '/gists/:id/forks' do
    request_with id: existing(:someone_elses_gist_id) do
      respond_with :created do |response, route_params|
        expect(response).not_to have_attributes id: {value: route_params[:id]}
      end
    end
  end

  # NOTE: This is the only one missing, because I need to create one first!
  # delete '/gists/:id', wip: true do
  #   request_with 'given an existing', id: existing(:id) do
  #     respond_with :no_content
  #   end
  # end
end