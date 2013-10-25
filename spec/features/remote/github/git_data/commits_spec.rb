require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/git/commits
resource 'Commits' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :sha, :string
  has_attribute :url, :string, format: :url
  has_attribute :html_url, :string, format: :url # not documented
  has_attribute :author, :object do
    has_attribute :date, :string, format: :timestamp
    has_attribute :name, :string
    has_attribute :email, :string, format: :email
  end
  has_attribute :committer, :object do
    has_attribute :date, :string, format: :timestamp
    has_attribute :name, :string
    has_attribute :email, :string, format: :email
  end
  has_attribute :message, :string
  has_attribute :tree, :object do
    has_attribute :url, :string, format: :url
    has_attribute :sha, :string
  end
  has_attribute :parents, :array do
    has_attribute :url, :string, format: :url
    has_attribute :html_url, :string, format: :url # not documented
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