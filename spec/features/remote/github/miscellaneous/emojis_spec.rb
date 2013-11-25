require 'spec_helper'
require_relative '../github_helper'

# http://developer.github.com/v3/emojis/
resource :emoji do
  get '/emojis' do
    respond_with :ok
  end
end