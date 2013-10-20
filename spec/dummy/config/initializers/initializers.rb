# All initializers in one file (for compactness)

# Initialize secret token
Gigs::Application.config.secret_key_base = 'ce59524af57fb8ec970b80166f562f0483cde7f16322b31762c6caa051d8c16b1ffc14006641097ab09afff6d45744d61760deb7fb9855ea72587d99918b6a66'

# Initialize session store
Gigs::Application.config.session_store :cookie_store, key: '_gigs_session'

# Include gems
require 'kaminari'
require 'kaminari/models/active_record_extension'
ActiveRecord::Base.send :include, Kaminari::ActiveRecordExtension
require 'jbuilder'
require 'api-pagination'