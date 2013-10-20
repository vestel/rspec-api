require 'rspec-api/http/remote'

module GithubRoute
  extend ActiveSupport::Concern

  module ClassMethods

    def setup_fixtures
      # nothing to do for now...
    end

    def existing(field)
      case field
      when :user then 'claudiob'
      when :gist_id then '0d7b597d822102148810'
      when :starred_gist_id then '1e31c19a5fb3c5330193'
      when :unstarred_gist_id then '5cf0b36e301262a09b30'
      when :someone_elses_gist_id then 'ca832349ffb06c19d424'
      when :id then '921225'
      when :updated_at then '2013-10-07T10:10:10Z' # TODO use helpers
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