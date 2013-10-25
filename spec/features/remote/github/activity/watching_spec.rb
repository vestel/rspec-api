require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/activity/watching/
resource 'Watchers' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :login, :string
  has_attribute :id, :number, format: :integer
  has_attribute :avatar_url, :string, format: :url, can_be_nil: true
  has_attribute :gravatar_id, :string, can_be_nil: true
  has_attribute :url, :string, format: :url

  get '/repos/:owner/:repo/subscribers', array: true do
    request owner: existing(:user), repo: existing(:repo) do
      respond_with :ok
    end

    request owner: existing(:user), repo: unknown(:repo) do
      respond_with :not_found
    end
  end
end

resource 'WatchedRepos' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :id, :number, format: :integer
  has_attribute :owner, :object do
    has_attribute :login, :string
    has_attribute :id, :number, format: :integer
    has_attribute :avatar_url, :string, format: :url, can_be_nil: true
    has_attribute :gravatar_id, :string, can_be_nil: true
    has_attribute :url, :string, format: :url
  end
  has_attribute :name, :string
  has_attribute :full_name, :string
  has_attribute :description, :string
  has_attribute :private, :boolean
  has_attribute :fork, :boolean
  has_attribute :url, :string, format: :url
  has_attribute :html_url, :string, format: :url
  has_attribute :clone_url, :string, format: :url
  has_attribute :git_url, :string # git url
  has_attribute :ssh_url, :string # should change URL to accept git@
  has_attribute :svn_url, :string, format: :url
  has_attribute :mirror_url, :string, can_be_nil: true # should change URL to accept git://
  has_attribute :homepage, :string, format: :url, can_be_nil: true
  has_attribute :language, :string, can_be_nil: true
  has_attribute :forks, :number, format: :integer
  has_attribute :forks_count, :number, format: :integer
  has_attribute :watchers, :number, format: :integer
  has_attribute :watchers_count, :number, format: :integer
  has_attribute :size, :number, format: :integer
  has_attribute :master_branch, :string
  has_attribute :open_issues, :number, format: :integer
  has_attribute :open_issues_count, :number, format: :integer
  has_attribute :pushed_at, :string, format: :timestamp, can_be_nil: true
  has_attribute :created_at, :string, format: :timestamp
  has_attribute :updated_at, :string, format: :timestamp

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

resource 'RepoSubscriptions' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :subscribed, :boolean
  has_attribute :ignored, :boolean
  has_attribute :reason, :string, can_be_nil: true
  has_attribute :created_at, :string, format: :timestamp
  has_attribute :url, :string, format: :url
  has_attribute :repository_url, :string, format: :url # only field different from ThreadSubscriptions

  get '/repos/:owner/:repo/subscription' do
    request 'Get a Repository Subscription', owner: existing(:user), repo: existing(:repo) do
      respond_with :ok
    end
  end

  put '/repos/:owner/:repo/subscription' do
    request 'Set a Repository Subscription', owner: existing(:user), repo: existing(:repo), subscribed: true, ignored: false do
      respond_with :ok do |subscription|
        expect(subscription).to have_field :subscribed, value: true
        expect(subscription).to have_field :ignored, value: false
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