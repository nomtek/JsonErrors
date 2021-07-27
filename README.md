![example workflow](https://github.com/nomtek/JsonErrors/actions/workflows/<WORKFLOW_FILE>/badge.svg)
# JsonErrors

Welcome to Ruby on Rails gem for handling the JSON API errors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_errors'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install json_errors

___
## Usage
### Basic usage

First, run the `json_errors:install` generator:
```
> rails g json_errors:install
      create  config/initializers/json_errors.rb
```

It creates the initializer file with config. Check out the file and uncomment what you need.

Then include `JsonErrors::Rescuer` to your JSON API controller and start raising errors. 
```ruby
class UsersController < ApplicationController
  include JsonErrors::Rescuer

  def create
    user = User.create!(params.require(:name))

    head :created
  end
end
```
Be sure to use error throwing methods everywhere, like `create!`, `save!`, `find_by!`, etc. The gem will rescue from any exception and respond with a properly formatted JSON body with a custom error code.

No need for `rescue_from` or rendering the JSON error body. Every error is rescued, logged, formatted and rendered. The client application will receive a JSON body like this:

```json
{
  "code":1010,
  "message":"The parameter 'name' is missing or value is empty",
  "payload":[]
}
```

### Custom codes

The initializer file defines custom error codes and error dictionary:
```ruby
JsonErrors.configure do |config|
  config.custom_codes = {
    general_error: { code: 1001, http_status: 500 },
    not_found: { code: 1002, http_status: 404 },
    database_error: { code: 1003, http_status: 500 },
    parameter_missing: { code: 1010, http_status: 400 },
    validation_failed: { code: 1020, http_status: 422 },
    internal_server_error: { code: 1000, http_status: 500 }
  }

  config.error_dictionary = {
    ActiveRecord::RecordInvalid => :validation_failed,
    ActionController::ParameterMissing => :parameter_missing,
    ActiveRecord::RecordNotFound => :not_found,
    ActiveRecord::ActiveRecordError => :database_error,
    StandardError => :internal_server_error
  }
end
```

The `custom_codes` hash assigns the error label to the error code and HTTP status code of the response.
So, the error labelled with `:general_error` will be considered as `1001` code under the HTTP `500 Internal Server Error` response.
Codes are customizable. They can be either numeric or string. 

The `error_dictionary` hash defines what error classes are connected to which error codes.

You can create different custom codes and connect them to your error classes. 
Lets say you have authentication and you want to respond with HTTP `403 Forbidden` whenever someone is unauthenticated. You can do it 2 ways:

### **1. By handling custom error class**

Add new label to the `custom_codes`
```ruby
  unauthenticated: { code: 2001, http_status: 403 }
```
and your error class to the `error_dictionary`:
```ruby
Unauthenticated => :unauthenticated
```

Then just raise the error while checking the authentication.

```ruby
Unauthenticated = Class.new(StandardError)

raise Unauthenticated, 'Authentication needed'
```


### **2. By raising error by label**
Add new label to the `custom_codes`
```ruby
  unauthenticated: { code: 2001, http_status: 403 }
```
Then just raise the error while checking the authentication.

```ruby
raise JsonErrors::ApplicationError.unauthenticated('Authentication needed') 
```

Both cases you will get the HTTP `403 Forbidden` response with JSON formatted body:

```json
{
  "code":2001,
  "message":"Authentication needed",
  "payload":[]
}
```
___

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

___
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nomtek/json_errors. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nomtek/json_errors/blob/main/CODE_OF_CONDUCT.md).

___
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

___
## Code of Conduct

Everyone interacting in the JsonErrors project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nomtek/json_errors/blob/main/CODE_OF_CONDUCT.md).
