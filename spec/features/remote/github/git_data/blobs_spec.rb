require 'spec_helper'
require 'rspec-api/dsl'
require_relative '../github_helper'

# http://developer.github.com/v3/git/blobs
resource 'Gists' do
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  has_attribute :content, :string
  has_attribute :encoding, :string
  has_attribute :sha, :string
  has_attribute :size, :number, format: :integer
  has_attribute :url, :string, format: :url # undocumented


  get '/repos/:owner/:repo/git/blobs/:sha' do
    request 'Get a Blob', owner: existing(:user), repo: existing(:repo), sha: existing(:blob_sha) do
      respond_with :ok
    end
  end

  # NOTE: wip because the returned object *only* has sha and url! not the rest
  post '/repos/:owner/:repo/git/blobs', wip: true do
    request 'Create a Blob', owner: existing(:user), repo: existing(:repo), content: 'Content of the Blob', encoding: 'utf-8' do
      respond_with :created
    end
  end
end