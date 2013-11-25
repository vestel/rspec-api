require 'spec_helper'
require_relative '../github_helper'

# http://developer.github.com/v3/gitignore/
resource :gitignore do
  has_attribute :name, type: :string
  has_attribute :source, type: :string

  # This is the only case where returns a collection of strings, not of objects
  # get '/gitignore/templates', collection: true do
  #   respond_with :ok
  # end

  get '/gitignore/templates/:name' do
    respond_with :ok, name: existing(:gitignore_template)
  end
end