require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/activity/starring/
resource 'Stargazers' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :login, :string
  has_attribute :id, :number, format: :integer
  has_attribute :avatar_url, :string, format: :url, can_be_nil: true
  has_attribute :gravatar_id, :string, can_be_nil: true
  has_attribute :url, :string, format: :url
  has_attribute :html_url, :string, format: :url # not documented
  has_attribute :followers_url, :string, format: :url # not documented
  has_attribute :following_url, :string, format: :url # not documented
  has_attribute :gists_url, :string, format: :url # not documented
  has_attribute :starred_url, :string, format: :url # not documented
  has_attribute :subscriptions_url, :string, format: :url # not documented
  has_attribute :organizations_url, :string, format: :url # not documented
  has_attribute :repos_url, :string, format: :url # not documented
  has_attribute :events_url, :string, format: :url # not documented
  has_attribute :received_events_url, :string, format: :url # not documented
  has_attribute :type, :string # not documented
  has_attribute :site_admin, :boolean # not documented

  get '/repos/:owner/:repo/stargazers', array: true do
    request 'List Stargazers', owner: existing(:user), repo: existing(:repo) do
      respond_with :ok
    end
  end

  get '/user/starred/:owner/:repo' do
    request 'Check if you are starring a starred repository', owner: existing(:user), repo: existing(:starred_repo) do
      respond_with :no_content
    end

    request 'Check if you are starring an unstarred repository', owner: existing(:user), repo: existing(:unstarred_repo) do
      respond_with :not_found
    end
  end

  put '/user/starred/:owner/:repo' do
    request 'Star a repository', owner: existing(:user), repo: existing(:repo) do
      respond_with :no_content
    end
  end

  delete '/user/starred/:owner/:repo' do
    request 'Unstar a repository', owner: existing(:user), repo: existing(:repo) do
      respond_with :no_content
    end
  end
end

resource 'StarredRepos' do
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

  # TODO: a sort with an extra direction: parameter!
  # accepts_sort :created, on: :created_at
  # accepts_sort :updated, on: :updated_at
  #
  # GIGS could be this
  # accepts_sort 'created', on: :created_at, verse: :asc
  # accepts_sort '-created', on: :created_at, verse: :desc
  #
  # and GITHUB could be this
  # accepts_sort :created, on: :created_at, verse: :desc
  # accepts_sort :created, on: :created_at, verse: :asc

  get '/users/:user/starred', array: true do
    request 'List repositories being starred', user: existing(:user) do
      respond_with :ok
    end
  end

  get '/user/starred', array: true do
    request 'List repositories being starred by the authenticated user' do
      respond_with :ok # by default: sorted by created_at
    end
  end
end