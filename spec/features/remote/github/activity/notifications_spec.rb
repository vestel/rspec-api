require 'spec_helper'
require_relative '../github_helper'

# http://developer.github.com/v3/activity/notifications/
resource :notification do
  has_attribute :id, type: :string
  has_attribute :repository, type: :object do
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
    has_attribute :description, type: :string
    has_attribute :private, type: :boolean
    has_attribute :fork, type: :boolean
    has_attribute :url, type: {string: :url}
    has_attribute :html_url, type: {string: :url}
  end
  has_attribute :subject, type: :object do
    has_attribute :title, type: :string
    has_attribute :url, type: {string: :url}
    has_attribute :latest_comment_url, type: {string: :url}
    has_attribute :type, type: :string
  end
  has_attribute :reason, type: :string
  has_attribute :unread, type: [:null, :boolean] # NOTE: why null? is it an error?
  has_attribute :updated_at, type: {string: :timestamp}
  has_attribute :last_read_at, type: [:null, string: :timestamp]
  has_attribute :url, type: {string: :url}

  accepts filter: :since, by: :updated_at, compare_with: :>=, value: '2012-10-10T00:00:00Z'

  accepts filter: :all, by: :unread, compare_with: -> all, unread { all == true || unread == true }, value: true
  accepts filter: :participating, by: :reason, compare_with: -> participating, reason { participating == 'false' || ['author', 'mention'].include?(reason) }, value: true

  get '/notifications', collection: true do
    respond_with :ok do |response|
      # TODO: add range to have_attribute
      # expect(response).to have_attribute reason: {range: ['mention', 'author']}
    end
  end

  get '/repos/:owner/:repo/notifications', collection: true do
    respond_with :ok, owner: existing(:user), repo: existing(:repo)
  end

  # NOTE: This works but makes all the other results empty :(
  # put '/notifications' do
  #   respond_with :reset_content
  # end

  put '/repos/:owner/:repo/notifications' do
    respond_with :reset_content, owner: existing(:user), repo: existing(:empty_repo)
  end

  get '/notifications/threads/:id' do
    respond_with :ok, id: existing(:subscribed_thread_id)
  end

  patch '/notifications/threads/:id' do
    respond_with :reset_content, id: existing(:subscribed_thread_id)
  end
end

resource :thread_subscription do
  has_attribute :subscribed, type: :boolean
  has_attribute :ignored, type: :boolean
  has_attribute :reason, type: [:null, :string]
  has_attribute :created_at, type: {string: :timestamp}
  has_attribute :url, type: {string: :url}
  has_attribute :thread_url, type: {string: :url}

  get '/notifications/threads/:id/subscription' do
    respond_with :ok, id: existing(:subscribed_thread_id)
  end

  put '/notifications/threads/:id/subscription' do
    respond_with :ok, id: existing(:subscribed_thread_id), subscribed: true, ignored: false do |response|
      expect(response).to have_attributes subscribed: {value: true}, ignored: {value: false}
    end
  end

  delete '/notifications/threads/:id/subscription' do
    respond_with :no_content, id: volatile(:subscribed_thread_id)
  end
end