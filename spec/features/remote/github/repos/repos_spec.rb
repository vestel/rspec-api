require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/repos/
resource 'Repos' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :id, :integer
  has_attribute :owner, :hash do
    has_attribute :login, :string
    has_attribute :id, :integer
    has_attribute :avatar_url, :url, can_be_nil: true
    has_attribute :gravatar_id, :string, can_be_nil: true
    has_attribute :url, :url
  end
  has_attribute :name, :string
  has_attribute :full_name, :string
  has_attribute :description, :string, can_be_nil: true
  has_attribute :private, :boolean
  has_attribute :fork, :boolean
  has_attribute :url, :url
  has_attribute :html_url, :url
  has_attribute :clone_url, :url
  has_attribute :git_url, :string # should change URL to accept git://
  has_attribute :ssh_url, :string # should change URL to accept git@
  has_attribute :svn_url, :url
  has_attribute :mirror_url, :string, can_be_nil: true # should change URL to accept git://
  has_attribute :homepage, :url, can_be_nil: true
  has_attribute :language, :string, can_be_nil: true
  has_attribute :forks, :integer
  has_attribute :forks_count, :integer
  has_attribute :watchers, :integer
  has_attribute :watchers_count, :integer
  has_attribute :size, :integer
  has_attribute :master_branch, :string
  has_attribute :open_issues, :integer
  has_attribute :open_issues_count, :integer
  has_attribute :pushed_at, :timestamp, can_be_nil: true
  has_attribute :created_at, :timestamp
  has_attribute :updated_at, :timestamp

  get '/users/:user/repos', array: true do
    request 'given an existing', user: existing(:user) do
      respond_with :ok
    end
  end
end