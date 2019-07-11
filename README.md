# Purchasing Power Parity

- Installation
- Usage
- FAQ
- Contributing

## What is Purchasing Power Parity (PPP)

If you're selling a digital product\* to a global audience, you are missing out on customers because their purchasing power doesn't go as far as yours.

For example, you've self-published a novel--congratulations!--and you've priced it at USD $20. For someone in the USA, that might be a reasonable expense, but for your readers in, say, Brazil, that might make a big dent in their budget.

Wouldn't it be great if you could price your novel so that it costs your international readers about the same, in real terms, as your readers in the US?

That's what we're trying to achieve here with Purchasing Power Parity.

\* You can definitely calculate PPP for a physical product, but digital products are easier to reason about because the cost of production and distribution is, presumably, the same--you don't have to worry about shipping costs, import taxes, the cost of materials in different locales, etc.


## What does this gem do?

Check out the documentation for an example of how you can create a coupon to give your international purchasers a discount.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ppp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ppp

### Important: API dependencies

You'll need to get some API keys. Some of these APIs have low request limits

## Usage

```ruby
Ppp.call(countries: [])
```

### Configuration
```ruby
```

## FAQ

### How is PPP Calculated?

### What are this gem's limitations?
- APIs
- Base currency?

### How can I help?
- Free APIs

### Prior Art
- Robin W and Wes Bos
- Testing JavaScript

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

First, be kind. Please approach this library with the assumtion that I am working in good faith and doing my best with the knowledge that I have. I would love suggestions and input from people who know more about economics than I do, but please do so without calling me a moron 🙂.

Bug reports and pull requests are welcome on GitHub at https://github.com/raquelxmoss/ppp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Ppp project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/raquelxmoss/ppp/blob/master/CODE_OF_CONDUCT.md).
