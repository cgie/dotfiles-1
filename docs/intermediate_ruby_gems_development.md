 Mitchell Hashimoto
posted 21 hours ago K
INTERMEDIATE
Intermediate RubyGem Development

This tutorial introduces intermediate level information on how to develop RubyGems. This builds on and expects the knowledge covered in the Basic RubyGem Development post. If you're new to RubyGem development, please start by reading that tutorial. Otherwise, please at least skim the article to make sure you know everything covered there, since the rest of this tutorial will assume you know it all.

Instead of focusing on what a RubyGem is, like we did in the tutorial on RubyGem basics we're going to cover more details on how to work in a RubyGem. We'll cover adding and using dependencies to a RubyGem, testing a RubyGem, more details on managing releases of RubyGems, and more.

At the end of reading this tutorial, you'll be equipped with the knowledge required to mimic the behavior of most RubyGems out there.
Testing RubyGems
A Simple Test

The Ruby programming language has a fantastic testing culture around it. It is difficult to find a library or application written in Ruby that isn't tested, and most publicly available code that isn't tested is quickly called out or simply ignored.

As such, it should come as no surprise that the idea of testing is well engrained into the idiomatic process of creating a RubyGem.

Let's augment our redundant_math library by adding some basic tests. We'll start by using the builtin Test::Unit library that comes standard with every Ruby installation.

First, create a "test" directory in the directory containing the gemspec of the RubyGem. Bundler doesn't create this directory for us, but it is easy enough to get going. Once the "test" directory is created, let's write our first test. Create a file "test/testredundantmath.rb" with the following contents:

require 'test/unit'
require 'redundant_math'

class RedundantMathTest < Test::Unit::TestCase
  def test_add
    assert_equal 7, RedundantMath.add(3, 4)
  end
end

This is a standard Test::Unit test. This tutorial won't cover how Test::Unit works, but the basic idea should be clear from the code above.

To run the test, just run the ruby file:

$ bundle exec ruby test/test_redundant_math.rb
Run options:

# Running tests:

.

Finished tests in 0.000507s, 1972.3866 tests/s, 1972.3866 assertions/s.

1 tests, 1 assertions, 0 failures, 0 errors, 0 skips

We need to prefix the command with "bundle exec" so that Bundler will setup our load paths so that the test can properly require the redundant_math library. If you run the test without the "bundle exec" prefix then it will give an error about not being able to load the library.

As you can see from the output, the test passed, which is some nice validation that our code probably works as expected.
Executing Tests with Rake

While manually executing the test file works for small projects or running individual tests, most gems are made up of many test files and the idiomatic way of running tests is via rake. Rake has built-in support for adding a task to run Test::Unit tests. Let's modify the Rakefile to support this now. The Rakefile should end up looking like this:

require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new

Now, run rake test and it'll run our tests:

$ rake test
Run options:

# Running tests:

.

Finished tests in 0.000638s, 1567.3981 tests/s, 1567.3981 assertions/s.

1 tests, 1 assertions, 0 failures, 0 errors, 0 skips

The Rake test task will automatically find any files matching test/test*.rb and run them. So if you add new tests to the "test" directory, they'll automatically be picked up and ran!
A Word About Test Files

For the "redundant_math" library, there is only a single file to test. More often, however, a library is made up of multiple files. In this case, it is common and often expected for the test files to map to this directory structure.

For example, let's say we had a "lib/redudantmath/abs.rb" that had a class RedundantMath::Abs that had methods for doing absolute value calculations on it. To test this, the test file should be "test/testredundantmathabs.rb" or something similar. Namely, there should be a 1:1 mapping between test files and library files.

This convention makes it easy for developers who may not be familiar with the project to easily find the test cases related to a certain class.
Development Dependencies

One of the best features of RubyGems is the ability to offload dependency management out of your library and onto the RubyGem system. RubyGems will load all the proper versions of libraries for you, and will print errors in the case that there are unresolvable dependencies. We covered basic dependencies in the tutorial on RubyGem basics.

In addition to basic dependencies, you can also define development dependencies. These are dependencies that are only relevant or used for development purposes.

Most commonly, these are used to bring in alternate test libraries. As an example, let's convert our tests to use RSpec instead of Test::Unit. RSpec is an extremely popular testing library for Ruby.

For the purpose of this tutorial, we'll just add RSpec alongside the Test::Unit test cases. In the real world, you probably only want one or the other.

First, we need to install RSpec. Let's add the development dependency by modifying the gemspec to include a line like the following:

gem.add_development_dependency "rspec", "~> 2.13.0"

Next, run bundle:

$ bundle
Using diff-lcs (1.2.2)
Using redundant_math (0.0.1) from source at .
Using rspec-core (2.13.1)
Using rspec-expectations (2.13.0)
Using rspec-mocks (2.13.0)
Using rspec (2.13.0)
Using bundler (1.2.3)
Your bundle is complete! Use `bundle show [gemname]` to see where a bundled gem is installed.

As you can see, various "rspec" related libraries are now included in our bundle. Bundler automatically installs development dependencies as well as runtime dependencies since bundle installations are typically only done in development for gems. However, when someone does a gem install for your gem after it is published, the development dependencies are not installed.

Let's write the RSpec test. Create a file "spec/redundantmathspec.rb" with the following contents:

require "redundant_math"

describe RedundantMath do
  it "can add numbers" do
    described_class.add(3, 4).should == 7
  end
end

Again, this tutorial won't cover RSpec, but the above is a very basic example of an RSpec test. Note also that the filename is now suffixed with "spec" rather than prefixed with "test". This is important because the RSpec test runner looks for the suffix by default, rather than the Test::Unit prefix.

The test can be run by calling spec:

$ bundle exec spec
.

Finished in 0.00036 seconds
1 example, 0 failures

Once again, our tests pass, but this time powered by RSpec tests.

Just like Test::Unit, there are ways to easily integrate RSpec with Rake, but we'll avoid covering that since we only wanted to highlight using development dependencies here, rather than how to use RSpec.
Code Layout

RubyGems are rarely a single file. They usually quickly become dozens of Ruby files. Beginners are often scared or unsure how to split up a complicated single-file project into multiple files. The Ruby community has a standard expected practice for doing this sort of thing. It is easy to understand and follow.

First, create as few Ruby files as possible directly in the "lib" folder. The "lib" folder of a RubyGem is added to the global Ruby $LOAD_PATH. For example, if you were to create a file "lib/thread.rb", then require "thread" might accidentally require your RubyGem library rather than the "thread" standard library. It depends on how the $LOAD_PATH is setup, but it is possible.

Therefore, it is standard RubyGem practice to only make a single file in "lib" based on the name of your gem. For example, for our library there is only "lib/redundant_math.rb". Based on the name of the library, a developer can reasonably expect that require "redundant_math" will pull in our library, without resorting to the documentation.

When adding additional files, they should go in a sub-directory within "lib" that is named the same as the main Ruby file. For example, a class to add absolute value support may be at "lib/redundant_math/abs.rb". Within this sub-directory, you may add as many files as possible, since the name for require is namespaces by the directory, so you're far less likely to collide with another library. Developers can then do require "redundant_math/abs" and so on. Again, this is expected behavior.

As an additional note, most RubyGems expose all functionality of the library by only requiring the top-level Ruby file. Splitting up the code into subdirectories is mostly done for code organization for development purposes. Therefore, following our previous example, if we split out absolute value functionality into "redundantmath/abs.rb", we should still be able to access it only by doing a require "redundant_math". This works because "lib/redundantmath.rb" should require the absolute value code, like the following:

require "redundant_math/abs"
require "redundant_math/version"

module RedundantMath
  def self.add(x, y)
    x + y
  end
end

Naming Conventions

Following code layout conventions, there are also standard module/class naming conventions within RubyGems. By following these conventions, you again make it easier for developers to quickly begin using your RubyGem, since most other RubyGems follow these patterns.

Modules in classes in Ruby are generally CamelCased. This probably comes as no surprise if you've been using it for some time already. What you may not know, however, is that the name of the RubyGem often maps to the name of module/class, and also the way the code is laid out into files typically maps to module/class namespacing.

For the purpose of this tutorial, assume "module" and "class" are interchangeable. The naming conventions are the same either way and it is beyond the scope of this tutorial to cover the functional differences of each and when to use each.

You've already seen a bit of this with "lib/redundant_math.rb", which includes a module RedundantMath.

The first important point is that the name of the top-level module should be the camel cased name of the gem itself. In our case, the RubyGem is named "redundant_math" and the top-level module is "RedundantMath". Easy to remember, and easy to expect when using a RubyGem.

Next, files within sub-directories map directly to additional modules or classes. "lib/redundant_math/abs.rb" should contain a module named RedundantMath::Abs.

Finally, additional sub-directories map to additional namespaces. If there was a file "lib/redundant_math/util/thing.rb", it would map to a module RedundantMath::Util::Thing.

I want to stress that these aren't required rules. You will certainly find RubyGems that do not follow this pattern. However, most library RubyGems do follow this pattern and by doing so makes it easier to use the library, find tests for the library, know what functionality a library may have, etc. There are many upsides and very few downsides to following this pattern.
An Intermediate-level RubyGem

While the tutorial on RubyGem development basics covered how to setup a basic RubyGem development environment and a bit about how to package and release them, this tutorial covered more of how to actually write Ruby code for a RubyGem.

Given the basics knowledge plus this knowledge, you're now capable of writing an idiomatic, high quality, well-tested RubyGem and releasing that RubyGem to the public. You know how to add dependencies to the RubyGem, executables, tests, and more. You should be comfortable splitting up your RubyGem implementation into multiple files and how those files map to implementation details of the gem itself.

There are a few more tricks to know about RubyGems, but they're rarely used and quite advanced: platform-specific RubyGems, C-extensions, etc. These might be covered in an advanced post in the future, but are unnecessary to write almost every RubyGem.

Have fun and good luck writing your RubyGems!

http://tech.pro/tutorial/1277/intermediate-rubygem-development