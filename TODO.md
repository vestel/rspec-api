* Don't have the second `accept_***` override the first one
* Do something for action (like DELETE) that require fixtures or cleaners
* Warn if the app declares matchers with the same name, like `be_filtered_by`
* Have something for ActiveRecord, otherwise accounts_spec.rb won't run
* Add `accepts_limit` and `accepts_offset`
* Allow regex in `has_attributes /something/` to test gists file names
* use ActiveSupport::Autoload
* nest "should include the field" if the attribute is nested
* Don't say 'Ok' if sub-conditions are not run, like page with no page (nil?)
* should `success?` be (200..299).include?(status) ?
* accept type as hashes, e.g.: url: :public_git, or integer: :positive
* nested resource :stargazer, parent: :user do
* has_attribute :user, resource: :user
* a sort with an extra direction parameter, or accepts_direction ?
* make rspec <file>:LINE work
* Textmate Bundle
* Instead of

        get '/concerts', array: true do
          request do
            respond_with :ok
          end
        end
I could have the syntax

        get '/concerts' do
          request do
            respond_with :ok, array: true
          end
        end
except that it wouldn't know to make multiple requests for all the `accepts_`.
So I might need to change the key name `array` to `accepts` or similar.
* I might drop the need for `request do`, and have `respond_with` accepted one
level higher, implicitly inserting a `request do` for a short syntax, e.g.:

        get '/apples' do
          respond_with :ok
        end

Spec
----

* Test that send_request caches even when the body has Unicode (that's why we use Marshal serializer)
