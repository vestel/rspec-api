require 'spec_helper'
require_relative '../github_helper'

# http://developer.github.com/v3/repos/
resource :repo do
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
  has_attribute :description, type: [:null, :string]
  has_attribute :private, type: :boolean
  has_attribute :fork, type: :boolean
  has_attribute :url, type: {string: :url}
  has_attribute :html_url, type: {string: :url}
  has_attribute :clone_url, type: {string: :url}
  has_attribute :git_url, type: :string
  has_attribute :ssh_url, type: :string
  has_attribute :svn_url, type: {string: :url}
  has_attribute :mirror_url, type: [:null, :string]
  has_attribute :homepage, type: [:null, :string] # can be an empty string :(
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

  get '/users/:user/repos', collection: true do
    respond_with :ok, user: existing(:user)
  end
end