require 'rspec-api/http/remote'

module GithubRoute
  extend ActiveSupport::Concern

  module ClassMethods

    def setup_fixtures
      # nothing to do for now...
    end

    def existing(field)
      case field
      when :org then 'rspec-api'
      when :user then 'claudiob'
      when :repo then 'dotfiles'
      when :starred_repo then 'dotfiles'
      when :unstarred_repo then 'cancan'
      when :gist_id then '0d7b597d822102148810'
      when :starred_gist_id then '1e31c19a5fb3c5330193'
      when :unstarred_gist_id then '5cf0b36e301262a09b30'
      when :someone_elses_gist_id then 'ca832349ffb06c19d424'
      when :thread_id then '17915960'
      when :id then '921225'
      # NOTE: The following are confusing: they are used for filters, not value
      # For instance, it's not that we must have an object with the following
      # updated_at, we just use it for the since filter
      when :updated_at then '2013-10-07T10:10:10Z' # TODO use helpers
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

    def unknown(field)
      case field
      when :user then 'not-a-valid-user'
      when :gist_id then 'not-a-valid-gist-id'
      when :id then 'not-a-valid-id'
      end
    end
  end
end

RSpec.configuration.include GithubRoute, rspec_api_dsl: :route