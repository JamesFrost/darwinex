# Darwinex

[![Build Status](https://travis-ci.org/JamesFrost/darwinex.svg?branch=master)](https://travis-ci.org/JamesFrost/darwinex)

Ruby client for the Darwinex API.

## Installation

### Gemfile

```ruby
gem 'darwinex'
```

### Install

```bash
$ gem install darwinex
```

## Usage

Require the client:

```ruby
require 'darwinex/client'
```

Initialise the client:

```ruby
client = Darwinex::Client.new(
  consumer_key: "<consumer key>",
  consumer_secret: "<consumer secret>"
)
```

If you would like to use a custom logger:

```ruby
client = Darwinex::Client.new(
  consumer_key: "<consumer key>",
  consumer_secret: "<consumer secret>",
  logger: Logger.new(STDOUT)
)
```

If you would like to configure the maximum number of API call retries:

```ruby
client = Darwinex::Client.new(
  consumer_key: "<consumer key>",
  consumer_secret: "<consumer secret>",
  max_retries: 10 # Default: 5
)
```

Before you use the client, you must generate a new access token for the client to use:

```ruby
resp = client.refresh_access_token("<refresh token>")

refresh_token = resp["refresh_token"]
```

The client will now be ready for use.

You will need to persist the refresh token returned by `.refresh_access_token` - you will need it the next time you want to generate a new access token.

## Examples

### Investor Accounts

```ruby
client.list_investor_accounts
```

```ruby
client.investor_account("<account id>")
```

```ruby
client.investor_account("<account id>").summary
```

```ruby
client.investor_account("<account id>").leverage
```

```ruby
client.investor_account("<account id>").update_leverage(3)
```

```ruby
buy_order = { long: "eurusd" }

client.investor_account("<account id>").create_buy_order(buy_order)
```

```ruby
sell_order = { long: "eurusd" }

client.investor_account("<account id>").create_sell_order(sell_order)
```

```ruby
# Will create a stopout for all products
client.investor_account("<account id>").create_stopout
```

```ruby
product_name = 'DWC.4.20'

client.investor_account("<account id>").create_stopout(product_name)
```

```ruby
order = {
  'amount' => 215.15,
  'productName' => 'DWC.4.20',
  'quote' => 20.23,
  'side' => 'BUY',
  'type' => 'LESS_THAN_EQUAL',
  'thresholdParameters' => {
    'quoteStopLoss' => 10.05,
    'quoteTakeProfit' => 250.1
  }
}

client.investor_account("<account id>").create_conditional_order(order)
```

```ruby
order_id = 123

order = {
  'amount' => 215.15,
  'productName' => 'DWC.4.20',
  'quote' => 20.23,
  'side' => 'BUY',
  'type' => 'LESS_THAN_EQUAL',
  'thresholdParameters' => {
    'quoteStopLoss' => 10.05,
    'quoteTakeProfit' => 250.1
  }
}

client.investor_account("<account id>").update_conditional_order(order_id, order)
```

```ruby
order_id = 123

client.investor_account("<account id>").delete_conditional_order(order_id)
```

```ruby
client.investor_account("<account id>").current_positions
```

```ruby
product_name = 'DWC.4.20'

client.investor_account("<account id>").current_positions(product_name)
```

```ruby
client.investor_account("<account id>").executed_orders
```

```ruby
options = {
  product_name: 'DWC.4.20',
  page: 2,
  per_page: 10
}

client.investor_account("<account id>").executed_orders(options)
```

```ruby
order_id = 'DWC.4.20'

client.investor_account("<account id>").order(order_id)
```

```ruby
client.investor_account("<account id>").performance_fees
```

```ruby
options = {
  page: 2,
  per_page: 10
}

client.investor_account("<account id>").performance_fees(options)
```

```ruby
product_name = 'DWC.4.20'

client.investor_account("<account id>").product_performance_fees(product_name)
```

```ruby
trade_status = 'open'

client.investor_account("<account id>").trades(trade_status)
```

```ruby
trade_status = 'open'

options = {
  product_name: 'DWC.4.20',
  page: 2,
  per_page: 10
}

client.investor_account("<account id>").trades(trade_status, options)
```

```ruby
trade_id = 'DWC.4.20'

client.investor_account("<account id>").trade(trade_id)
```


### Products

```ruby
client.list_products
```

```ruby
client.product("<product name>")
```

```ruby
client.product("<product name>").candles(from: epoch_timestamp, to: epoch_timestamp)
```

```ruby
client.product("<product name>").candles(resolution: '1m', from: epoch_timestamp, to: epoch_timestamp)
```

```ruby
client.product("<product name>").dxscore
```

```ruby
client.product("<product name>").badges
```

```ruby
client.product("<product name>").close_strategy
```

```ruby
client.product("<product name>").duration_consistency
```

```ruby
client.product("<product name>").experience
```

```ruby
client.product("<product name>").losing_consistency
```

```ruby
client.product("<product name>").market_correlation
```

```ruby
client.product("<product name>").performance
```

```ruby
client.product("<product name>").open_strategy
```

```ruby
client.product("<product name>").capacity
```

```ruby
client.product("<product name>").quotes
```

```ruby
client.product("<product name>").quotes(from: epoch_timestamp, to: epoch_timestamp)
```

```ruby
client.product("<product name>").risk_stability
```

```ruby
client.product("<product name>").winning_consistency
```

```ruby
client.product("<product name>").order_divergence
```

```ruby
client.product("<product name>").return_divergence
```

```ruby
client.product("<product name>").monthly_divergence
```

```ruby
client.product("<product name>").status
```

```ruby
client.product("<product name>").scores
```

```ruby
badge = "EXPERIENCE"

client.product("<product name>").scores(badge)
```

## Exceptions

All exceptions extend the base exception class `Darwinex::Error`.

### Invalid Credentials

Raised when the consumer key or secret passed to the client are not valid.

### Throttled

Raised when you exceed the [API rate limit](https://help.darwinex.com/api-walkthrough#throttling).

The client will automatically back off and retry throttled API responses until the max retries limit is hit.

### Refresh Token Expired

Raised when `Darwinex::Client#refresh_access_token` is called with a refresh token that has expired.

Refresh tokens are only valid for a short period of time, after which they expire. As such, it's important your application regularly refreshes the access tokens to stop them from expiring.

In order to resolve this issue, you must go to the Darwinex Web console and issue a new refresh token.
