require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/activity/events/
resource 'Events' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :id, :string
  has_attribute :type, :string
  has_attribute :actor, :hash, can_be_nil: true do
    # has_attribute :id, :integer  # Sometimes it's missing!!
    # has_attribute :login, :string  # Sometimes it's missing!!
    # has_attribute :gravatar_id, :string  # Sometimes it's missing!!
    # e.g. {"url"=>"https://api.github.com/users/", "avatar_url"=>"https://a248.e.akamai.net/assets.github.com/images/gravatars/gravatar-user-420.png"}
    has_attribute :url, :url
    has_attribute :avatar_url, :url
  end
  has_attribute :repo, :hash do
    # has_attribute :id, :integer  # Sometimes it's missing!!
    # e.g. {"name"=>"/", "url"=>"https://api.github.com/repos//"}
    has_attribute :name, :string
    has_attribute :url, :url
  end
  has_attribute :payload, :hash # See http://git.io/Uln6EQ for types
  has_attribute :public, :boolean
  has_attribute :created_at, :timestamp
  # NOTE: Sometimes org is missing (instead of being nil), so cannot test this:
  # has_attribute :org, :hash do
  #   has_attribute :id, :integer
  #   has_attribute :login, :string
  #   has_attribute :gravatar_id, :string, can_be_nil: true
  #   has_attribute :url, :url
  #   has_attribute :avatar_url, :url
  # end

  accepts_page :page

  get '/events', array: true do
    request do
      respond_with :ok
    end
  end

  get '/repos/:owner/:repo/events', array: true do
    request 'given an existing', owner: existing(:user), repo: existing(:repo) do
      respond_with :ok
    end
  end

  # NOTE: :wip because of http://git.io/sPHbWA
  get '/repos/:owner/:repo/issues/events', array: true, wip: true do
    request 'given an existing', owner: existing(:user), repo: existing(:repo) do
      respond_with :ok
    end
  end

  get '/networks/:owner/:repo/events', array: true do
    request 'given an existing', owner: existing(:user), repo: existing(:repo) do
      respond_with :ok
    end
  end

  get '/orgs/:org/events', array: true do
    request 'given an existing', org: existing(:org) do
      respond_with :ok
    end
  end

  get '/users/:user/received_events', array: true do
    request 'given an existing', user: existing(:user) do
      respond_with :ok
    end
  end

  get '/users/:user/received_events/public', array: true do
    request 'given an existing', user: existing(:user) do
      respond_with :ok
    end
  end

  get '/users/:user/events', array: true do
    request 'given an existing', user: existing(:user) do
      respond_with :ok
    end
  end

  get '/users/:user/events/public', array: true do
    request 'given an existing', user: existing(:user) do
      respond_with :ok
    end
  end

  get '/users/:user/events/orgs/:org', array: true do
    request 'given an existing', user: existing(:user), org: existing(:org) do
      respond_with :ok
    end
  end
end