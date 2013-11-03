require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/activity/watching/
resource :watcher do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :login, type: :string
  has_attribute :id, type: {number: :integer}
  has_attribute :avatar_url, type: [:null, string: :url]
  has_attribute :gravatar_id, type: [:null, :string]
  has_attribute :url, type: {string: :url}

  get '/repos/:owner/:repo/subscribers', array: true do
    request owner: existing(:user), repo: existing(:repo) do
      respond_with :ok
    end

    request owner: existing(:user), repo: unknown(:repo) do
      respond_with :not_found
    end
  end
end

resource :watched_repo do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :id, type: {number: :integer}
  has_attribute :owner, type: :object do
    has_attribute :login, type: :string
    has_attribute :id, type: {number: :integer}
    has_attribute :avatar_url, type: [:null, string: :url]
    has_attribute :gravatar_id, type: [:null, :string]
    has_attribute :url, type: {string: :url}
  end
  has_attribute :name, type: :string
  has_attribute :full_name, type: :string
  has_attribute :description, type: :string
  has_attribute :private, type: :boolean
  has_attribute :fork, type: :boolean
  has_attribute :url, type: {string: :url}
  has_attribute :html_url, type: {string: :url}
  has_attribute :clone_url, type: {string: :url}
  has_attribute :git_url, type: :string # git url
  has_attribute :ssh_url, type: :string # should change URL to accept git@
  has_attribute :svn_url, type: {string: :url}
  has_attribute :mirror_url, type: [:null, :string] # should change URL to accept git://
  has_attribute :homepage, type: [:null, string: :url]
  has_attribute :language, type: [:null, :string]
  has_attribute :forks, type: {number: :integer}
  has_attribute :forks_count, type: {number: :integer}
  has_attribute :watchers, type: {number: :integer}
  has_attribute :watchers_count, type: {number: :integer}
  has_attribute :size, type: {number: :integer}
  has_attribute :master_branch, type: :string
  has_attribute :open_issues, type: {number: :integer}
  has_attribute :open_issues_count, type: {number: :integer}
  has_attribute :pushed_at, type: [:null, string: :timestamp]
  has_attribute :created_at, type: {string: :timestamp}
  has_attribute :updated_at, type: {string: :timestamp}

  get '/users/:user/subscriptions', array: true do
    request 'List repositories being watched', user: existing(:user) do
      respond_with :ok
    end
  end

  get '/user/subscriptions', array: true do
    request 'List repositories being watched by the authenticated user' do
      respond_with :ok
    end
  end
end

resource :repo_subscription do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :subscribed, type: :boolean
  has_attribute :ignored, type: :boolean
  has_attribute :reason, type: [:null, :string]
  has_attribute :created_at, type: {string: :timestamp}
  has_attribute :url, type: {string: :url}
  has_attribute :repository_url, type: {string: :url} # only field different from ThreadSubscriptions

  get '/repos/:owner/:repo/subscription' do
    request 'Get a Repository Subscription', owner: existing(:user), repo: existing(:repo) do
      respond_with :ok
    end
  end

  put '/repos/:owner/:repo/subscription' do
    request 'Set a Repository Subscription', owner: existing(:user), repo: existing(:repo), subscribed: true, ignored: false do
      respond_with :ok do |response|
        expect(response).to have_attributes subscribed: {value: true}, ignored: {value: false}
      end
    end
  end

  # NOTE: This is the only one missing, because I need to create one first!
  delete '/repos/:owner/:repo/subscription', wip: true do
    request 'Delete a Repository Subscription', owner: existing(:user), repo: existing(:repo) do
      respond_with :no_content
    end
  end
end