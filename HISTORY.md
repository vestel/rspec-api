v0.4.0  - 2013/11/03
--------------------

Extract all the matchers in a separate rspec-api-matchers gem.
Allow resources to be nested in `has_attributes`.
Allow *multiple* `accepts_sort`, `accepts_filter`, `accepts_callback` per resource.
Use symbols, not strings, as resource names (e.g. `:artist`, not `Artists`).
Change the GitHub user for GitHub tests to *rspecapi*
Add GitHub specs for git-data (refs, tags, trees) and issues (assignees)

Might break compatibility since:

* `has_attribute` has a new syntax that accepts nested attributes and resources (see rspec-api-matchers documentation).
* `respond_to` gets the whole response in the block, not just the body
*  resource names must now be singular symbols, not plural strings

v0.3.0  - 2013/10/24
--------------------

Separate JSON type and format in has_attribute.

Might break code like `has_attribute :page, :url`, since this is now
`has_attribute :page, type: {string: :url}`, where the only accepted types
are now the 6 basic JSON types

v0.2.1  - 2013/10/22
--------------------

Fix bug on accept_sort

v0.2.0  - 2013/10/20
--------------------

Include specs for local and remote.

Might break compatibility since it requires both dependencies in the Gemfile
(e.g., might have conflicts with Rails 3)

v0.1.2  - 2013/10/14
--------------------

Support JSONP callbacks

v0.1.1  - 2013/10/10
--------------------

Add PATCH, HTTP Caching, :comparing_with for filters

v0.1.0  - 2013/10/04
--------------------

Removed dependency from rspec-api-documentation

v0.0.3  - 2013/10/03
--------------------

Add 'encoding: UTF-8' for Ruby < 2 compatibility

v0.0.2  - 2013/09/13
--------------------

Helpers extracted from claudiob/gigs