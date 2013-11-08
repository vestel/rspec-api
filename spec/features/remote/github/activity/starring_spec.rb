require 'github_helper'

# http://developer.github.com/v3/activity/starring/
resource :stargazer do
  extend Authorize
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :login, type: :string
  has_attribute :id, type: {number: :integer}
  has_attribute :avatar_url, type: [:null, string: :url]
  has_attribute :gravatar_id, type: [:null, :string]
  has_attribute :url, type: {string: :url}
  has_attribute :html_url, type: {string: :url} # not documented
  has_attribute :followers_url, type: {string: :url} # not documented
  has_attribute :following_url, type: {string: :url} # not documented
  has_attribute :gists_url, type: {string: :url} # not documented
  has_attribute :starred_url, type: {string: :url} # not documented
  has_attribute :subscriptions_url, type: {string: :url} # not documented
  has_attribute :organizations_url, type: {string: :url} # not documented
  has_attribute :repos_url, type: {string: :url} # not documented
  has_attribute :events_url, type: {string: :url} # not documented
  has_attribute :received_events_url, type: {string: :url} # not documented
  has_attribute :type, type: :string # not documented
  has_attribute :site_admin, type: :boolean # not documented

  get '/repos/:owner/:repo/stargazers', collection: true do
    request_with owner: existing(:user), repo: existing(:repo) do
      respond_with :ok
    end
  end

  get '/user/starred/:owner/:repo' do
    request_with owner: existing(:user), repo: existing(:starred_repo) do
      respond_with :no_content
    end

    request_with owner: existing(:user), repo: existing(:unstarred_repo) do
      respond_with :not_found
    end
  end

  put '/user/starred/:owner/:repo' do
    request_with owner: existing(:user), repo: existing(:repo) do
      respond_with :no_content
    end
  end

  delete '/user/starred/:owner/:repo' do
    request_with owner: existing(:user), repo: existing(:repo) do
      respond_with :no_content
    end
  end
end

resource :starred_repo do
  extend Authorize
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
  # has_attribute :master_branch, type: :string # Not always, see http://git.io/0jgFiA
  has_attribute :open_issues, type: {number: :integer}
  has_attribute :open_issues_count, type: {number: :integer}
  has_attribute :pushed_at, type: [:null, string: :timestamp]
  has_attribute :created_at, type: {string: :timestamp}
  has_attribute :updated_at, type: {string: :timestamp}

  accepts_sort 'updated', by: :pushed_at, verse: :asc, sort_if: {direction: 'asc'}
  accepts_sort 'updated', by: :pushed_at, verse: :desc, sort_if: {direction: 'desc'}
  # NOTE: There is an additional sorting 'created' by date that the repos
  #       were starred. Unfortunately, this timestamp is not included in
  #       the result, so there is no way to test it! Would be something like:
  # accepts_sort 'created', extra_fields: {direction: 'asc'}, by: :starred_at, verse: :asc
  # accepts_sort 'created', extra_fields: {direction: 'desc'}, by: :starred_at, verse: :desc

  get '/users/:user/starred', collection: true do
    request_with user: existing(:user) do
      respond_with :ok
    end
  end

  get '/user/starred', collection: true do
    respond_with :ok # by default: sorted by created_at
  end
end