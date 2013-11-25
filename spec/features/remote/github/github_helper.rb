require 'rspec-api'

alias :rspec_api_resource :resource

def resource(name, args = {}, &block)
  rspec_api_resource name, args do
    host 'https://api.github.com'
    throttle 1
    authorize_with token: ENV['RSPEC_API_GITHUB_TOKEN']
    instance_exec &block
  end
end

# Use existing for multiple non-destructive actions
def existing(field)
  case field
  when :org then 'rspec-api'
  when :user then 'rspecapi'
  when :owner then 'rspecapi'
  when :assignee then 'rspecapi'
  when :repo then 'guinea-pig' # has heads, tails, pull, notes
  when :empty_repo then 'rspec-core' # does not have notifications heads, tails, pull, notes
  when :starred_repo then 'rspec-expectations'
  when :unstarred_repo then 'rspec-core'
  when :subscribed_repo then 'guinea-pig'
  when :unsubscribed_repo then 'jbuilder'
  when :subscribed_thread_id then '20946477'
  when :unsubscribed_thread_id then '20410951'
  when :gist_id then '7175672'
  when :gist_comment_id then '937901'
  when :starred_gist_id then 'e202e2fb143c54e5139a'
  when :unstarred_gist_id then '8f2ef7e69ab79084d833'
  when :someone_elses_gist_id then '4685e0bebbf05370abd6'
  when :blob_sha then 'f32932f7c927d86f57f56d703ac2ed100ceb0e47'
  when :commit_sha then 'c98a37ea3b2759d0c43fb8abfa9abd3146938790'
  when :tree_sha then 'ebca91692290192f50acc307af9fe26b2eab4274'
  when :ref then 'heads/master'
  when :gitignore_template then 'C'
  end
end

def tmp(field)
  case field
  when :id then '921225'
  # NOTE: The following are confusing: they are used for filters, not value
  # For instance, it's not that we must have an object with the following
  # updated_at, we just use it for the since filter
  when :updated_at then '2013-10-31T09:53:00Z' # TODO use helpers
  # NOTE: Here's the confusion: :unread is used for the :all filter, but
  # it has the reverse meaning: ?all=false will only show unread='true'
  when :unread then 'false' # TODO use helpers
  # NOTE: Here's more confusion: :reason is a string, but this is used for
  # the boolean parameter participating:
  # ?participating=true (default), only show reason = 'mention' or 'author'
  # ?participating=false, show all reasons
  when :reason then 'true' # TODO use helpers
  end
end

# Use volatile for destructive actions
def volatile(field)
  extend RSpecApi::HttpClient
  case field
  when :subscribed_thread_id
    existing(:unsubscribed_thread_id).tap do |thread_id|
      route = "/notifications/threads/#{thread_id}/subscription"
      request = rspec_api_params.merge action: :put, route: route, body: {subscribed: true, ignored: false}
      response = send_request request
    end
  when :unstarred_repo
    existing(:starred_repo).tap do |repo|
      route = "user/starred/#{existing :user}/#{repo}"
      request = rspec_api_params.merge action: :delete, route: route
      response = send_request request
    end
  when :starred_repo
    existing(:unstarred_repo).tap do |repo|
      route = "user/starred/#{existing :user}/#{repo}"
      request = rspec_api_params.merge action: :put, route: route
      response = send_request request
    end
  when :subscribed_repo
    existing(:unsubscribed_repo).tap do |repo|
      route = "/repos/#{existing :user}/#{repo}/subscription"
      request = rspec_api_params.merge action: :put, route: route, body: {subscribed: true, ignored: false}
      response = send_request request
    end
  when :unsubscribed_repo
    existing(:subscribed_repo).tap do |repo|
      route = "/repos/#{existing :user}/#{repo}/subscription"
      request = rspec_api_params.merge action: :delete, route: route
      response = send_request request
    end
  when :gist_id
    route = "/gists"
    request = rspec_api_params.merge action: :post, route: route, body: {files: {file1: {content: 'foo'}}}
    response = send_request request
    JSON(response.body)['id']
  when :gist_comment_id
    route = "/gists/#{existing :gist_id}/comments"
    request = rspec_api_params.merge action: :post, route: route, body: {body: 'foo'}
    response = send_request request
    JSON(response.body)['id']
  when :starred_gist_id
    existing(:unstarred_gist_id).tap do |gist_id|
      route = "/gists/#{gist_id}/star"
      request = rspec_api_params.merge action: :put, route: route
      response = send_request request
    end
  when :unstarred_gist_id
    existing(:starred_gist_id).tap do |gist_id|
      route = "/gists/#{gist_id}/star"
      request = rspec_api_params.merge action: :delete, route: route
      response = send_request request
    end
  end
end

# Use unknown for invalid values
def unknown(field)
end

