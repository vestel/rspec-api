require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/activity/feeds/
resource 'Feeds' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :timeline_url, :string, format: :url
  has_attribute :user_url, :string, format: :url # NOTE: actually a URI Template
  has_attribute :current_user_public_url, :string, format: :url
  # NOTE: Sometimes the following are missing!
  # has_attribute :current_user_url, :string, format: :url
  # has_attribute :current_user_actor_url, :string, format: :url
  # has_attribute :current_user_organization_url
  has_attribute :_links, :object do
    has_attribute :timeline, :object do
      has_attribute :href, :string, format: :url
      has_attribute :type, :string # should add mime-type
    end
    has_attribute :user, :object do
      has_attribute :href, :string, format: :url
      has_attribute :type, :string # should add mime-type
    end
    has_attribute :current_user_public, :object do
      has_attribute :href, :string, format: :url
      has_attribute :type, :string # should add mime-type
    end
    # NOTE: Sometimes the following are missing!
    # has_attribute :current_user, :object do
    #   has_attribute :href, :string, format: :url
    #   has_attribute :type, :string # should add mime-type
    # end
    # has_attribute :current_user_actor, :object do
    #   has_attribute :href, :string, format: :url
    #   has_attribute :type, :string # should add mime-type
    # end
    # has_attribute :current_user_organization, :object do
    #   has_attribute :href, :string, format: :url
    #   has_attribute :type, :string # should add mime-type
    # end
  end

  get '/feeds' do
    request 'List Feeds' do
      respond_with :ok
    end
  end
end