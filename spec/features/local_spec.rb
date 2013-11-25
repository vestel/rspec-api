require 'spec_helper'
require 'rspec-api/resource'
require 'rack/test'

app = -> env {[200, {"Content-Type" => "application/json; charset=utf-8"}, ["[]"]] }

describe 'Concerts', rspec_api: true do
  adapter :rack, app

  get '/', collection: true do
    respond_with :ok
  end
end