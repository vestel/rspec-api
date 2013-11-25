require 'spec_helper'
require_relative '../github_helper'

# http://developer.github.com/v3/git/commits
resource :commit do
  has_attribute :sha, type: :string
  has_attribute :url, type: {string: :url}
  has_attribute :html_url, type: {string: :url} # not documented
  has_attribute :author, type: :object do
    has_attribute :date, type: {string: :timestamp}
    has_attribute :name, type: :string
    has_attribute :email, type: {string: :email}
  end
  has_attribute :committer, type: :object do
    has_attribute :date, type: {string: :timestamp}
    has_attribute :name, type: :string
    has_attribute :email, type: {string: :email}
  end
  has_attribute :message, type: :string
  has_attribute :tree, type: :object do
    has_attribute :url, type: {string: :url}
    has_attribute :sha, type: :string
  end
  has_attribute :parents, type: :array do
    has_attribute :url, type: {string: :url}
    has_attribute :html_url, type: {string: :url} # not documented
    has_attribute :sha, type: :string
  end

  get '/repos/:owner/:repo/git/commits/:sha' do
    respond_with :ok, owner: existing(:user), repo: existing(:repo), sha: existing(:commit_sha)
  end

  # TODO: Add optional parameters, committer, author, etc
  post '/repos/:owner/:repo/git/commits' do
    respond_with :created, owner: existing(:user), repo: existing(:repo), tree: existing(:tree_sha), message: 'A commit'
  end
end