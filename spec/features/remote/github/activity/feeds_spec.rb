require 'github_helper'

# http://developer.github.com/v3/activity/feeds/
resource :feed do
  extend Authorize
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :timeline_url, type: {string: :url}
  has_attribute :user_url, type: {string: :url} # NOTE: actually a URI Template
  has_attribute :current_user_public_url, type: {string: :url}
  # NOTE: Sometimes the following are missing!
  # has_attribute :current_user_url, type: {string: :url}
  # has_attribute :current_user_actor_url, type: {string: :url}
  # has_attribute :current_user_organization_url
  has_attribute :_links, type: :object do
    has_attribute :timeline, type: :object do
      has_attribute :href, type: {string: :url}
      has_attribute :type, type: :string # should add mime-type
    end
    has_attribute :user, type: :object do
      has_attribute :href, type: {string: :url}
      has_attribute :type, type: :string # should add mime-type
    end
    has_attribute :current_user_public, type: :object do
      has_attribute :href, type: {string: :url}
      has_attribute :type, type: :string # should add mime-type
    end
    # NOTE: Sometimes the following are missing!
    # has_attribute :current_user, type: :object do
    #   has_attribute :href, type: {string: :url}
    #   has_attribute :type, type: :string # should add mime-type
    # end
    # has_attribute :current_user_actor, type: :object do
    #   has_attribute :href, type: {string: :url}
    #   has_attribute :type, type: :string # should add mime-type
    # end
    # has_attribute :current_user_organization, type: :object do
    #   has_attribute :href, type: {string: :url}
    #   has_attribute :type, type: :string # should add mime-type
    # end
  end

  get '/feeds' do
    respond_with :ok
  end
end