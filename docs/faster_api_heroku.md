#1600% faster app requests with Rails on Heroku

```
    rainbows
    em-http-request
    eventmachine
    unicorn
    rails
    heroku
```

Using rainbows! and em-http-request resulted in a 1600% performance increase compared to using unicorn and net_http. (For the use case described below)

###Situation

-    You have an app that does a lot of calls to a 3rd party API. This is often the case with facebook apps for example.
-    You want to host it on heroku (one dyno preferred, so it's free)

###Problem

-    You want to call the 3rd party API from your controller and render the response
-    Even if you are using unicorn to forks several worker processes, they will be blocked and waiting for a response from Facebook (or any other potentially slow API) most of the time.

###Solution: Use EventMachine and Rainbows!

Here is a quick outline on how to get you up and running with Rainbows! and em-http-requests on heroku.

We will be using the following gems: Gemfile

```ruby
gem 'rainbows'
gem 'em-http-request'
gem "faraday"
```

`app/controllers/async_controller.rb`

```ruby
class AsyncController < ApplicationController
  def index
    conn = Faraday.new "http://slowapi.com" do |con|
      con.adapter :em_http
    end
    resp = conn.get '/delay/1'
    resp.on_complete {
      @res = resp.body 
      render
      request.env['async.callback'].call(response)
    }
    throw :async
end
```

`app/views/async/index.html.erb`

```ruby
<%= @res %>
```ruby

`config/rainbow.rb`

```ruby
worker_processes 3
timeout 30
preload_app true

Rainbows! do
  use :EventMachine
end

before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
```

`config/routes.rb`

```ruby
match 'async_test' =>   'async#index'
```ruby

`Procfile`

```ruby
web: bundle exec rainbows -p $PORT -c ./config/rainbows.rb
```

it is also a good idea to set `config.threadsafe!` in your Rails environment configuration

### Finalize

-    Deploy to heroku
-    Run a benchmark, e.g. the following: 
`ab -n 600 -c 200 http://mycoolasync.herokuapp.com/async_test`

-    Enjoy how fast it is

### Some results

I set up a test app on heroku and ran ab -n 600 -c 200 http://mycoolasync.herokuapp.com/async_test

Result:

-    Old-school method: 183 second
-    Evented method: 11 seconds

Detailed results for old-school synchronous requests

Using non-evented http request by settting con.adapter :net_http in app/controllers/async_controller.rb

```
Document Path:          /async_test
Document Length:        2755 bytes

Concurrency Level:      100
Time taken for tests:   183.373 seconds
Complete requests:      600
Write errors:           0
Non-2xx responses:      516
Total transferred:      652495 bytes
HTML transferred:       541903 bytes
Requests per second:    3.27 [#/sec] (mean)
Time per request:       30562.206 [ms] (mean)
Time per request:       305.622 [ms] (mean, across all concurrent requests)
Transfer rate:          3.47 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      101  175 260.7    109    1239
Processing:  1270 28308 5571.9  30115   30978
Waiting:     1146 28156 5882.4  30115   30665
Total:       1376 28484 5582.8  30224   32203
```

Detailed Results for new and fancy evented request method

Ensured by settting con.adapter :em_http in app/controllers/async_controller.rb

```
Document Path:          /async_test
Document Length:        2758 bytes

Concurrency Level:      100
Time taken for tests:   11.118 seconds
Complete requests:      600
Write errors:           0
Total transferred:      1734330 bytes
HTML transferred:       1655686 bytes
Requests per second:    53.97 [#/sec] (mean)
Time per request:       1853.048 [ms] (mean)
Time per request:       18.530 [ms] (mean, across all concurrent requests)
Transfer rate:          152.33 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      101  194 283.0    114    1263
Processing:  1136 1485 416.1   1341    3558
Waiting:     1135 1453 346.2   1339    3159
Total:       1250 1679 472.5   1505    3669
```

###Some final words

I wanted to have a link-baity title once. So here we are with a very unscientific 1600%. You'll be the judge - I think with the right test setting this number could be much much higher. If you replicated this and achieved a better result - let me know. I'll update this post and give you credit.

Cheers, your friend _dommmel_

> https://coderwall.com/dommmel
> https://coderwall.com/p/5cafjw

-----

## Rainbows! - Unicorn for sleepy apps and slow clients

Rainbows! is an HTTP server for sleepy Rack applications. It is based
on Unicorn, but designed to handle applications that expect long
request/response times and/or slow clients.

For Rack applications not heavily bound by slow external network
dependencies, consider Unicorn instead as it simpler and easier to
debug.

If you’re on a small system, or write extremely tight and reliable
code and don’t want multiple worker processes, check out Zbatery, too.
Zbatery can use all the crazy network concurrency options of Rainbows!
in a single worker process.

http://rainbows.rubyforge.org/

## EM-HTTP-Request

Async (EventMachine) HTTP client, with support for:

Asynchronous HTTP API for single & parallel request execution
Keep-Alive and HTTP pipelining support
Auto-follow 3xx redirects with max depth
Automatic gzip & deflate decoding
Streaming response processing
Streaming file uploads
HTTP proxy and SOCKS5 support
Basic Auth & OAuth
Connection-level & Global middleware support
HTTP parser via http_parser.rb
Works wherever EventMachine runs: Rubinius, JRuby, MRI

https://github.com/igrigorik/em-http-request