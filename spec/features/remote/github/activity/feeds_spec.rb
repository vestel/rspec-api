require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/activity/feeds/
resource 'Feeds' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :timeline_url, :url
  has_attribute :user_url, :url # NOTE: actually a URI Template
  has_attribute :current_user_public_url, :url
  # NOTE: Sometimes the following are missing!
  # has_attribute :current_user_url, :url
  # has_attribute :current_user_actor_url, :url
  # has_attribute :current_user_organization_url
  has_attribute :_links, :hash do
    has_attribute :timeline, :hash do
      has_attribute :href, :url
      has_attribute :type, :string # should add mime-type
    end
    has_attribute :user, :hash do
      has_attribute :href, :url
      has_attribute :type, :string # should add mime-type
    end
    has_attribute :current_user_public, :hash do
      has_attribute :href, :url
      has_attribute :type, :string # should add mime-type
    end
    # NOTE: Sometimes the following are missing!
    # has_attribute :current_user, :hash do
    #   has_attribute :href, :url
    #   has_attribute :type, :string # should add mime-type
    # end
    # has_attribute :current_user_actor, :hash do
    #   has_attribute :href, :url
    #   has_attribute :type, :string # should add mime-type
    # end
    # has_attribute :current_user_organization, :hash do
    #   has_attribute :href, :url
    #   has_attribute :type, :string # should add mime-type
    # end
  end

  get '/feeds' do
    request 'List Feeds' do
      respond_with :ok
    end
  end
end