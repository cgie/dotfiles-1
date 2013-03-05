﻿> confessions of a ruby programmer
> by Luke Redpath [source](http://www.lukeredpath.co.uk/blog/developing-a-rails-model-using-bdd-and-rspec-part-1.html)
> 29 August 2006 updated 15 February 2009

# Developing a Rails model using BDD and RSpec, Part 1

Writing Rails testing articles seems to be quite popular at the
moment; seeing as I’m often quite vocal about testing on the #caboose
and #rubyonrails IRC rooms I felt it was about time I posted one of my
own. I have a large series of articles on testing with Rails in the
pipeline, but until that is done, here is a nice and simple tutorial
for newcomers to BDD and RSpec – the first in a two-part article
exploring the development of a typical Rails model, using BDD
techniques and the RSpec framework. If you are interested in BDD and
RSpec, or new to testing in general and want to learn how to
iteratively develop a model test/spec-first, this is the article for
you.

## Anatomy of a typical Rails-style test

Will Rails developers please raise their hands: how many times have
you written a test that looks like this:

```ruby
class UserTest < Test::Unit::TestCase
  def test_create
    user = User.create(:some => 'params')
    assert user.save
  end
end
```

Now ask yourself how many times have you sat back and asked yourself
why you are writing the above test?

If the concept of unit testing is new to you, then writing tests at
all is a great first step. But its also important to have useful
tests. Are your tests valuable? Are your tests acceptable?

## Avoid meaningless tests

The above test is a good example of a meaningless test. Why is it
meaningless? Because you aren’t testing your own code; you are testing
the ActiveRecord library, which is pretty well tested already. Let’s
take a look at a default Rails model:

```ruby
class User < ActiveRecord::Base
end
```

Just those two lines of code give us a whole load of functionality,
all of which is provided by the ActiveRecord library. Its fair to
assume that the functionality given by those two lines of code will
work. If it doesn’t then there is either something wrong with your
local setup or something fundamentally wrong with ActiveRecord; in
either case, your own tests are the last of your problems.

## Test your own code

So if we can safely assume that the built-in ActiveRecord
functionality works as advertised, what should you be testing? The
simple answer: test any code that you write. Anything that gets added
to your model needs test coverage. The aim of this tutorial is to
place an emphasis on testing the behaviour of your code in different
situations (or contexts). This is the basis of Behaviour Driven
Development, the methodology that I will use in this tutorial to
iteratively develop a Rails model, test-first spec-first.

For this tutorial, I will be using the excellent RSpec framework, but
you could easily apply these principles to TDD using Test::Unit.
Before we get started, you’ll need to install RSpec and the RSpec On
Rails plugin for your current app:

```
~/mygreatapp/ $ sudo gem install rspec
~/mygreatapp/ $ ./script/plugin install
svn://rubyforge.org/var/svn/rspec/tags/REL_X_Y_Z/vendor/rspec_on_rails/vendor/plugins/rspec
~/mygreatapp/ $ ./script/generate rspec
```

Replace X, Y and Z in the above with the version of RSpec that you are
using. If you have any problems, refer to the full instructions.

Going into RSpec in full detail is outside of the scope of this
article, but it should be pretty clear what is going on – this is one
of RSpec’s strengths. If you would like to read a more generic RSpec
tutorial, the RSpec website has a great tutorial to get you started.

## The problem

We’re in the process of writing our fantastic new Web 2.0 application,
and we’ve decided that we need people to be able to create accounts
and log in to the application. We don’t want to use any of the
available Rails authentication plugins; we want to develop our own
User model. After a quick whiteboard/CRC session, we come up with a
few basic specs for our User model:

* A user should have a username that they can log in with
* A user should have a password between 6 and 12 characters in length
* A user’s password should always be encrypted in the database
* A user should have an email address
* A user can optionally have a first name, surname and profile/description

With this in mind, we fire up our favourite text editor and start work
on a new Specification. We use the generator that comes with RSpec on
Rails to generate a new model, with an accompanying spec file.

```
$ ./script/generate rspec_model User
```

This will create a new `user.rb` file for our model, just like the
normal Rails script/generate model command, but it will also create an
accompanying spec file in the spec/ directory. If you open up the
created `user_spec.rb` file, you will see a stub context ready and
waiting.

Behaviour Driven Development favours the breaking up of specifications
into individual “contexts”. A context is an object (or collection of
objects, but generally object being specced) in a certain state. As we
are going to start our specs from scratch, you can safely remove the
stub context in the user_spec.rb file (don’t remove the require line
at the top though!).

So what is a good starting point? I tend to favour a more generic
starting context: “A user”. We can use this to specify the behaviour
of a user in general.

## Specifying your model in code

Let start with our first specification: a user should have a username
that they can log in with. Its fair to assume that the username is
required (otherwise they won’t be able to log in). So what could we
specify? How about this:

```ruby
context "A user (in general)" do
  setup do
    @user = User.new
  end

  specify "must have a username" do

  end
end
```

That’s not bad, but it could be better. We’ve expressed a requirement
in our code but we haven’t said anything about the behaviour of a User
object. What about this instead:

```ruby
context "A user (in general)" do
  setup do
    @user = User.new
  end

  specify "should be invalid without a username" do

  end
end
```

That’s better. Not only have we expressed that our user must have a
username, but we’ve also expressed what behaviour should be expected
from the User model if it doesn’t have one; it should be invalid.
Let’s fill this spec in, so we have a failing spec:

```ruby
context "A user (in general)" do
  setup do
    @user = User.new
  end

  specify "should be invalid without a username" do
    @user.should_not_be_valid
    @user.username = 'someusername'
    @user.should_be_valid
  end
end
```

Now we need to make this pass. The first things we need is our actual
User model, and a table in our database. BDD (and TDD) emphasise
taking small steps, following the red, green, refactor mantra.
However, due to our coupling to the database as a result of using the
ActiveRecord pattern, we are going to have to make a slightly larger
leap: our users table schema.

We need to write a migration for our users table, but at this stage we
aren’t certain exactly what columns we need. We could write a
migration every time we want to add a column but that would quickly
become tedious. Instead, we’ll make a reasonable guess at our schema
based on our written specs – if we get it wrong at this stage it
doesn’t matter. Migrations make it easy to modify our schema in the
future. Something like this should do the trick:

```ruby
class AddUsersTable < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email, :string
      t.column :description, :string
      t.column :username, :string
      t.column :encrypted_password, :string
      t.column :salt, :string
    end
  end

  def self.down
    drop_table :users
  end
end
```

You’ll note that we’ve made a few assumptions regarding our password
columns. We already have an idea in mind about how we want to store
the password – as a salted hash – so we’ve created columns for the
encrypted password and salt. Now we’ve written and run our migration,
and created our User model, its time to get the spec to pass:

```ruby
class User < ActiveRecord::Base
  validates_presence_of :username
end
```

You’ll notice that we’ve not added a should statement for the error
message itself. That is because we know Rails will happily provide us
with the default “can’t be blank” message. Remember: only test the
code that you write. In this case, we decide we do want a custom
message, so lets add a spec and make it pass:

```ruby
context "A user (in general)" do
  setup do
    @user = User.new
  end

  specify "should be invalid without a username" do
    @user.should_not_be_valid
    @user.errors.on(:username).should_equal "is required"
    @user.username = 'someusername'
    @user.should_be_valid
  end
end
```

```ruby
class User < ActiveRecord::Base
  validates_presence_of :username, :message => 'is required'
end
```

We’ve also specified that our user must have an email address, so lets
add a spec for that:

```ruby
context "A user (in general)" do
  setup do
    @user = User.new
  end

  specify "should be invalid without a username" do
    @user.should_not_be_valid
    @user.errors.on(:username).should_equal "is required"
    @user.username = 'someusername'
    @user.should_be_valid
  end

  specify "should be invalid without an email" do
    @user.should_not_be_valid
    @user.errors.on(:email).should_equal "is required"
    @user.email = 'joe@bloggs.com'
    @user.should_be_valid
  end
end
```

That’s simple enough to implement:

```ruby
class User < ActiveRecord::Base
  validates_presence_of :username, :message => 'is required'
  validates_presence_of :email, :message => 'is required'
end
```

Great, we’re on a roll. But wait a minute, both of our specs are now
failing. What gives? Of course, because we’ve now added two validation
requirements, we need to add an email address in the first spec to
make it pass and a username in the second spec to make that one pass.
Hmm, it doesn’t sound very DRY, but lets go with it for now – we want
our specs to pass after all!

```ruby
context "A user (in general)" do
  setup do
    @user = User.new
  end

  specify "should be invalid without a username" do
    @user.email = 'joe@bloggs.com'
    @user.should_not_be_valid
    @user.errors.on(:username).should_equal "is required"
    @user.username = 'someusername'
    @user.should_be_valid
  end

  specify "should be invalid without an email" do
    @user.username = 'joebloggs'
    @user.should_not_be_valid
    @user.errors.on(:email).should_equal "is required"
    @user.email = 'joe@bloggs.com'
    @user.should_be_valid
  end
end
```

Phew, that was a close one. Finally, lets add the specs for the
password. We know a password is required and that it has to be between
6 and 12 characters in length. Because that is actually two
specifications, we’ll write two separate specs in our code. Lets start
with the required field specification, as that will look similar to
our above specs:

```ruby
context "A user (in general)" do
  setup do
    @user = User.new
  end

  specify "should be invalid without a username" do
    @user.email = 'joe@bloggs.com'
    @user.password = 'abcdefg'
    @user.should_not_be_valid
    @user.errors.on(:username).should_equal "is required"
    @user.username = 'someusername'
    @user.should_be_valid
  end

  specify "should be invalid without an email" do
    @user.username = 'joebloggs'
    @user.password = 'abcdefg'
    @user.should_not_be_valid
    @user.errors.on(:email).should_equal "is required"
    @user.email = 'joe@bloggs.com'
    @user.should_be_valid
  end

  specify "should be invalid without a password" do
    @user.email = 'joe@bloggs.com'
    @user.username = 'joebloggs'
    @user.should_not_be_valid
    @user.password = 'abcdefg'
    @user.should_be_valid
  end
end
```

Now, we don’t actually have a password column in our users table, but
we need somewhere to store the cleartext password before it gets
encrypted. A standard Ruby instance variable will do. Here’s the code
to make it pass:

```ruby
class User < ActiveRecord::Base
  attr_accessor :password

  validates_presence_of :username, :message => 'is required'
  validates_presence_of :email, :message => 'is required'
  validates_presence_of :password
end
```

## Refactoring towards cleaner, clearer specifications

Before moving on to the password length specification, lets address
our duplication issue here. Its already getting tedious adding all the
other required fields in each spec in order to make them pass. It is
making our specs bloated, ugly and it will be a nightmare to maintain
in the future if our specification changes. Let’s solve this by
introducing a small helper module and a neat Hash extension:

```ruby
module UserSpecHelper
  def valid_user_attributes
    { :email => 'joe@bloggs.com',
      :username => 'joebloggs',
      :password => 'abcdefg' }
  end
end
```

```ruby
context "A user (in general)" do
  include UserSpecHelper

  setup do
    @user = User.new
  end

  specify "should be invalid without a username" do
    @user.attributes = valid_user_attributes.except(:username)
    @user.should_not_be_valid
    @user.errors.on(:username).should_equal "is required"
    @user.username = 'someusername'
    @user.should_be_valid
  end

  specify "should be invalid without an email" do
    @user.attributes = valid_user_attributes.except(:email)
    @user.should_not_be_valid
    @user.errors.on(:email).should_equal "is required"
    @user.email = 'joe@bloggs.com'
    @user.should_be_valid
  end

  specify "should be invalid without a password" do
    @user.attributes = valid_user_attributes.except(:password)
    @user.should_not_be_valid
    @user.password = 'abcdefg'
    @user.should_be_valid
  end
end
```

There, thats much DRYer, more expressive and easier to maintain. If
our valid attributes ever change, we only need to change them in one
place. However, we haven’t sacrificed readability in the name of DRY,
which is very important with any tests/specs.

Finally, lets add a spec for our password length:

```ruby
specify "should be invalid if password is not between 6 and 12
characters in length" do
  @user.attributes = valid_user_attributes.except(:password)
  @user.password = 'abcdefghijklm'
  @user.should_not_be_valid
  @user.password = 'abcde'
  @user.should_not_be_valid
  @user.password = 'abcdefg'
  @user.should_be_valid
end
```

And to make it pass:

```ruby
class User < ActiveRecord::Base
  attr_accessor :password

  validates_presence_of :username, :message => 'is required'
  validates_presence_of :email, :message => 'is required'
  validates_presence_of :password
  validates_length_of :password, :in => 6..12, :allow_nil => :true
end
```

You’ll notice we’ve added the :allow_nil option to the length
validation. This is to avoid a double validation error if we haven’t
set a password – the validates_presence_of validation will already
handle this and we don’t want an extra error message complaining about
the length of the password as well.

There is one last refactoring that we can do at this stage. In each of
our validation specs, we’ve checked that the model is invalid, then
set the required value and checked that it is now valid, to ensure
that the validation is working end to end. We can extract all of these
checks into a single specification:

```ruby
specify "should be valid with a full set of valid attributes" do
    @user.attributes = valid_user_attributes
    @user.should_be_valid
end
```

## Whats next?

So far we’ve written a basic User model, with an initial schema and a
validation of required attributes. We’ve covered the basics of RSpec
syntax and we’ve learnt how to DRY up our specs by extracting common
code into a helper module.

In the second part of this tutorial, we’ll look at password encryption
and authentication.