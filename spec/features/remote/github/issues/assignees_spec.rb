require 'github_helper'

# http://developer.github.com/v3/issues/assignees
resource :assignee do
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

  get '/repos/:owner/:repo/assignees', collection: true do
    respond_with :ok, owner: existing(:owner), repo: existing(:repo)
  end

  get '/repos/:owner/:repo/assignees/:assignee' do
    respond_with :no_content, owner: existing(:owner), repo: existing(:repo), assignee: existing(:assignee)
  end

  get '/repos/:owner/:repo/assignees/:assignee' do
    respond_with :not_found, owner: existing(:owner), repo: existing(:repo), assignee: unknown(:assignee)
  end
end