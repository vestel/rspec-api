* Don't ignore the optional block passed to has_attribute
* Do something for action (like DELETE) that require fixtures or cleaners
* Have something for ActiveRecord, otherwise accounts_spec.rb won't run
* Add `accepts_limit` and `accepts_offset`
* Allow regex in `has_attributes /something/` to test gists file names
* make rspec <file>:LINE work
* Textmate Bundle

Spec
----

* Test that send_request caches even when the body has Unicode (that's why we use Marshal serializer)
