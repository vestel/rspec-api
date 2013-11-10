RSpec API
=========

RSpec API aims to make it easy to document and test [pragmatic RESTful web APIs](http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api).

It is still under development, and you can follow its progress by checking out the code on Github.

More documentation and examples are available at [http://rspec-api.github.io](http://rspec-api.github.io)

[![Build Status](https://travis-ci.org/rspec-api/rspec-api.png?branch=master)](https://travis-ci.org/rspec-api/rspec-api)
[![Code Climate](https://codeclimate.com/github/rspec-api/rspec-api.png)](https://codeclimate.com/github/rspec-api/rspec-api)
[![Coverage Status](https://coveralls.io/repos/rspec-api/rspec-api/badge.png)](https://coveralls.io/r/rspec-api/rspec-api)
[![Dependency Status](https://gemnasium.com/rspec-api/rspec-api.png)](https://gemnasium.com/rspec-api/rspec-api)

A basic example
---------------

RSpec API can help develop and document your own web APIs.
A basic example of running RSpec API locally is provided, comprised of:

* a Ruby on Rails *app* that provides a RESTful API for concerts (in [spec/dummy](https://github.com/rspec-api/rspec-api/tree/master/spec/dummy))
* a *test suite* that verifies the expected behavior of the API (in [spec/features/local/](https://github.com/rspec-api/rspec-api/blob/master/spec/features/local/gigs/gigs_spec.rb))

Run the basic example with the following commands:

    git clone https://github.com/rspec-api/rspec-api.git
    cd rspec-api
    bundle
    bundle exec rake db:migrate
    bundle exec rspec spec/features/local

And you should see all the successful promises matched by the concerts API:

    Concerts
      GET /concerts
        by default
          responds with a status code that
            should be 200
          responds with headers that
            should include 'Content-Type': 'application/json; charset=utf-8'
            should include 'Link' (for pagination)
      ...
      DELETE /concerts/:id
        given an existing id
          responds with a status code that
            should be 204

    Finished in 0.73864 seconds
    151 examples, 0 failures


The GitHub API example
----------------------

RSpec API can help specify and verify promises for remote APIs.
An example of running RSpec API for a remote API is provided in [spec/features/remote](https://github.com/rspec-api/rspec-api/blob/master/spec/features/remote).
The code verifies the expected behavior of a number of endpoints of the [GitHub API](http://developer.github.com):

* Activity resources (events, feeds, notifications, starring, watching)
* Gists resources (gists, gist comments)
* Git data resources (blobs, commits)
* Repository resources (repos)

Before running the example, get a GitHub Personal Access Token:

* Browse to your [GitHub settings](https://github.com/settings/applications)
* Click on 'Create new token' under 'Personal Access Token' (name it as you want)
* Copy the generated token and store it on your machine as the environment variable called `RSPEC_API_GITHUB_TOKEN`:
  * On OSX and bash, accomplish this by running the command `export RSPEC_API_GITHUB_TOKEN=` followed by your pasted key (no spaces after `=`)

Now, run the GitHub API example with the following commands:

    git clone https://github.com/rspec-api/rspec-api.git
    cd rspec-api
    bundle
    bundle exec rspec spec/features/remote

And you should see all the successful promises matched by the GitHub API:

    Events
      GET https://api.github.com/events
        by default
          responds with a status code that
            should be 200
          responds with headers that
            should include 'Content-Type': 'application/json; charset=utf-8'
            should include 'Link' (for pagination)
      ...
      DELETE https://api.github.com/gists/:id/star
        given an existing id 0d7b597d822102148810
          responds with a status code that
            should be 204

    Finished in 1 minute 19.74 seconds
    1237 examples, 1 failure, 4 pending


How to contribute
=================

Don’t hesitate to send me code comments, issues or pull requests through GitHub!
All feedback is appreciated. Thanks :)

