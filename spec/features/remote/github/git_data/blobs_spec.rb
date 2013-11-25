require 'spec_helper'
require_relative '../github_helper'

# http://developer.github.com/v3/git/blobs
resource :gist do
  has_attribute :content, type: :string
  has_attribute :encoding, type: :string
  has_attribute :sha, type: :string
  has_attribute :size, type: {number: :integer}
  has_attribute :url, type: {string: :url} # undocumented

  get '/repos/:owner/:repo/git/blobs/:sha' do
    respond_with :ok, owner: existing(:user), repo: existing(:repo), sha: existing(:blob_sha)
  end

  # NOTE: wip because the returned object *only* has sha and url! not the rest
  # post '/repos/:owner/:repo/git/blobs', wip: true do
  #   respond_with :created, owner: existing(:user), repo: existing(:repo), content: 'Content of the Blob', encoding: 'utf-8'
  # end
end