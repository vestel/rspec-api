require 'github_helper'

# http://developer.github.com/v3/emojis/
resource :emoji do
  extend Authorize
  authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']

  get '/emojis' do
    respond_with :ok
  end
end