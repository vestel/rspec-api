require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/git/commits
resource 'Commits' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :sha, :string
  has_attribute :url, :url
  has_attribute :html_url, :url # not documented
  has_attribute :author, :hash do
    has_attribute :date, :timestamp
    has_attribute :name, :string
    has_attribute :email, :email
  end
  has_attribute :committer, :hash do
    has_attribute :date, :timestamp
    has_attribute :name, :string
    has_attribute :email, :email
  end
  has_attribute :message, :string
  has_attribute :tree, :hash do
    has_attribute :url, :url
    has_attribute :sha, :string
  end
  has_attribute :parents, :array do
    has_attribute :url, :url
    has_attribute :html_url, :url # not documented
    has_attribute :sha, :string
  end

  get '/repos/:owner/:repo/git/commits/:sha' do
    request 'Get a Commit', owner: existing(:user), repo: existing(:repo), sha: existing(:commit_sha) do
      respond_with :ok
    end
  end

  # TODO: Add optional parameters, committer, author, etc
  post '/repos/:owner/:repo/git/commits' do
    request 'Post a Commit', owner: existing(:user), repo: existing(:repo), tree: existing(:tree_sha), message: 'Testing commit' do
      respond_with :created
    end
  end
end