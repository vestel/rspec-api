Why rspec and not...
--------------------

Because metadata are cool

Why faraday and not...
----------------------

Because it's case-insensitive to the headers keys
Because it returns a format very similar to rack-test
Also see http://lanyrd.com/2012/rubyconf/szpth/

Why not rspec_api_documentation...
----------------------------------

Because of http://git.io/WB4hxg, where it says
"For validating, I think we should skip including it into
rspec_api_documentation. Looking at your code, it looks very application
specific. I personally prefer to use json_spec to validate the JSON looks
exactly like I want, instead of parsing it into a hash and validating
individual keys"