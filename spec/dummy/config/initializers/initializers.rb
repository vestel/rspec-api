# Initialize secret token
Gigs::Application.config.secret_key_base = 'ce59524af57fb8ec970b80166f562f04'

# Initialize session store
Gigs::Application.config.session_store :cookie_store, key: '_gigs_session'

# Include gems
require 'kaminari'
require 'kaminari/models/active_record_extension'
ActiveRecord::Base.send :include, Kaminari::ActiveRecordExtension
require 'jbuilder'
require 'api-pagination'