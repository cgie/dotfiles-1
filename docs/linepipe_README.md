# Linepipe

A tool to aid in processing data in a pipeline, making every step easily
testable and benchmarkable.

[![Build Status](https://travis-ci.org/wimdu/linepipe.png?branch=master)](https://travis-ci.org/wimdu/linepipe)

## Installation

Add this line to your application's Gemfile:

    gem 'linepipe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install linepipe

## Usage

Linepipe's DSL consists of 4 different parts:

* `setup`: Optional setup that will be run at the beginning.
* `data`: The input data.
* `step`: As many of these as you want will conform the steps of your
  algorithm. You can optionally provide an `expect` block that will test the
  output right after than particular step.
* `expect`: In development mode, each of these will be run against your final
  output data to ensure its conformity with your expectations.

While developing a processing algorithm, `Linepipe.develop` is your friend. Each
`process` block will be reduced against your data in order, and then each
`expect` block will be run against the final output to ensure that it works.

```ruby
linepipe = Linepipe.develop do
  data {
    %w(foo bar baz)
  }

  step("Upcasing") { |data|
    data.map(&:upcase)
  }.expect('is upcased') { |data|
    data.first == 'FOO'
  } # as you see, each step can have its own expectations that will be tested
    # when the data leaves that particular step of the pipeline

  step("Reversing") { |data|
    data.reverse
  }

  # now the final expectation on the result
  expect { |data|
    data == %w(BAZ BAR FOO)
  }
end

linepipe.output # => %W(BAZ BAR FOO)
```

Once you're comfortable with your algorithm, just change your call to
`Linepipe.develop` to `Linepipe.run` and no expectations will be run.

## Testing your linepipes

`Linepipe.run`, `Linepipe.benchmark` and `Linepipe.develop` return a `Linepipe::Process` object that
responds to two important methods: `output` and a hash-like
interface to access each step. In our case above we would access the second step
"Reversing" (from a test or wherever) like this:

```ruby
step = linepipe["Reversing"]
# => #<Step ...>
expect(step.apply([1,2,3])).to eq([3,2,1])
# => [3,2,1]
```

This way you can test every stage of your linepipe separately against as many
inputs as you want.

## Benchmarking your linepipes

To switch Linepipe into benchmark mode, just call `Linepipe.benchmark` instead
of `.develop` or `.run`. This will print a detailed benchmark for every step of
your algorithm so you can easily identify and fix bottlenecks.

```ruby
linepipe = Linepipe.benchmark(10_000) do
  data {
    %w(foo bar baz)
  }

  step("Upcasing") { |data|
    data.map(&:upcase)
  }

  step("Reversing") { |data|
    data.reverse
  }

  expect { |data|
    data == %w(BAZ BAR FOO)
  }
end
```

Will output to the screen:

    Rehearsal ---------------------------------------------
    Upcasing    0.020000   0.000000   0.020000 (  0.024458)
    Reversing   0.000000   0.000000   0.000000 (  0.004000)
    ------------------------------------ total: 0.020000sec

                    user     system      total        real
    Upcasing    0.020000   0.000000   0.020000 (  0.022565)
    Reversing   0.010000   0.000000   0.010000 (  0.007034)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2013 Wimdu GmbH (MIT License). See LICENSE.txt for details.
