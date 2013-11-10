require 'github_helper'

# TODO: don't duplicate this code from repos_spec, but require it in some
# way that only loads the attributes, without running the specs
resource :owner do
  has_attribute :login, type: :string
  has_attribute :id, type: {number: :integer}
  has_attribute :avatar_url, type: [:null, string: :url]
  has_attribute :gravatar_id, type: [:null, :string]
  has_attribute :url, type: {string: :url}
end

# http://developer.github.com/v3/gists/comments/
resource :gist_comment do
  extend Authorize
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :id, type: {number: :integer}
  has_attribute :url, type: {string: :url}
  has_attribute :body, type: :string
  has_attribute :user, type: {object: attributes_of(:owner)}
  has_attribute :created_at, type: {string: :timestamp}

  get '/gists/:gist_id/comments', collection: true do
    respond_with :ok, gist_id: existing(:gist_id)
    respond_with :not_found, gist_id: unknown(:gist_id)
  end

  get '/gists/:gist_id/comments/:id' do
    respond_with :ok, gist_id: existing(:gist_id), id: existing(:gist_comment_id)
    respond_with :not_found, gist_id: existing(:gist_id), id: unknown(:gist_comment_id)
  end

  ## OPTION 1 FOR CREATE / EDIT / DESTROY

  # post '/gists/:gist_id/comments' do
  #  respond_with :unprocessable_entity, gist_id: existing(:gist_id), body: '' do |response|
  #    expect(response).to have_attributes errors: {value: [{resource: "GistComment", code: "missing_field", field: "body"}]}
  #  end
  #
  #  respond_with :created, gist_id: existing(:gist_id), body: 'New comment' do |response|
  #    expect(response).to have_attributes body: {value: 'New comment'}
  #  
  #    patch '/gists/:gist_id/comments/:id' do
  #      respond_with :ok, gist_id: existing(:gist_id), id: comment['id'], body: 'Edited comment' do |response|
  #        expect(response).to have_attributes body: {value: 'Edited comment'}
  #  
  #        delete '/gists/:gist_id/comments/:id' do
  #          respond_with :no_content, gist_id: existing(:gist_id), id: comment['id']
  #        end
  #      end
  #    end
  #  end
  #   end
  # end
  #
  # ## OPTION 2 FOR CREATE / EDIT / DESTROY
  # @@ The 'existing(:gist_comment_id)' calls some kind of before that runs the
  # 'Create a comment' unless it's already been run (and not deleted)
  #
  # post '/gists/:gist_id/comments' do
  #   respond_with :created, gist_id: existing(:gist_id), body: 'New comment' do |response|
  #     expect(response).to have_attributes body: {value: 'New comment'}
  #   end
  # end
  #
  # patch '/gists/:gist_id/comments/:id'  do
  #   respond_with :ok, gist_id: existing(:gist_id), id: existing(:gist_comment_id), body: 'Edited comment' do |response|
  #     expect(response).to have_attributes body: {value: 'Edited comment'}
  #   end
  # end
end