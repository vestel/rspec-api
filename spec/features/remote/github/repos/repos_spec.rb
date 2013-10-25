require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/repos/
resource 'Repos' do
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
  has_attribute :description, :string, can_be_nil: true
  has_attribute :private, :boolean
  has_attribute :fork, :boolean
  has_attribute :url, :string, format: :url
  has_attribute :html_url, :string, format: :url
  has_attribute :clone_url, :string, format: :url
  has_attribute :git_url, :string # should change URL to accept git://
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

  get '/users/:user/repos', array: true do
    request 'List user repositories', user: existing(:user) do
      respond_with :ok
    end
  end
end