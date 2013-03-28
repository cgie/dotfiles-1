# Serializing (And Deserializing) Objects With Ruby

> by Alan Skorkin on April 14, 2010

Serialization is one of those things you can easily do without until all of a sudden you really need it one day. That's pretty much how it went with me. I was happily using and learning Ruby for months before I ever ran into a situation where serializing a few objects really would have made my life easier. Even then I avoided looking into it, you can very easily convert the important data from an object into a string and write that out to a file. Then when you need to, you just read the file, parse the string and recreate the object, what could be simpler? Of course, it could be much simpler indeed, especially when you're dealing with a deep hierarchy of objects. I think being weaned on languages like Java, you come to expect operations like serialization to be non-trivial. Don't get me wrong, it is not really difficult in Java, but neither is it simple and if you want your serialized object to be human-readable, then you're into 3rd party library land and things can get easier or harder depending on your needs. Suffice to say, bad experiences in the past don't fill you with a lot of enthusiasm for the future.

When I started looking into serialization in Ruby, I fully expected to have to look into 3rd party solutions – surely the serialization mechanisms built into the language couldn't possibly, easily fit my needs. As usual, I was pleasantly surprised. Now, like that proverbial hammer, serialization seems to be useful all the time :). Anyway, I'll let you judge for yourself, let's take a look at the best and most common options you have, when it comes to serialization with Ruby.
Human-Readable Objects

## Text

Ruby has two object serialization mechanisms built right into the language. One is used to serialize into a human readable format, the other into a binary format. I will look into the binary one shortly, but for now let’s focus on human readable. Any object you create in Ruby can be serialized into YAML format, with pretty much no effort needed on your part. Let’s make some objects:

```ruby
require "yaml"
 
class A
  def initialize(string, number)
    @string = string
    @number = number
  end
 
  def to_s
    "In A:\n   #{@string}, #{@number}\n"
  end
end
 
class B
  def initialize(number, a_object)
    @number = number
    @a_object = a_object
  end
 
  def to_s
    "In B: #{@number} \n  #{@a_object.to_s}\n"
  end
end
 
class C
  def initialize(b_object, a_object)
    @b_object = b_object
    @a_object = a_object
  end
 
  def to_s
    "In C:\n #{@a_object} #{@b_object}\n"
  end
end
 
a = A.new("hello world", 5)
b = B.new(7, a)
c = C.new(b, a)
 
puts c
```

Since we created a `to_s`, method, we can see the string representation of our object tree:

```
In C:
 In A:
   hello world, 5
 In B: 7
  In A:
   hello world, 5
```

To serialize our object tree we simply do the following:

```ruby
serialized_object = YAML::dump(c)
puts serialized_object
```

Our serialized object looks like this:

```
--- !ruby/object:C
a_object: &id001 !ruby/object:A
  number: 5
  string: hello world
b_object: !ruby/object:B
  a_object: *id001
  number: 7
```

If we now want to get it back:

```ruby
puts YAML::load(serialized_object)
```

This produces output which is exactly the same as what we had above, which means our object tree was reproduced correctly:

```
In C:
 In A:
   hello world, 5
 In B: 7
  In A:
   hello world, 5
```

Of course you almost never want to serialize just one object, it is usually an array or a hash. In this case you have two options, either you serialize the whole array/hash in one go, or you serialize each value separately. The rule here is simple, if you always need to work with the whole set of data and never parts of it, just write out the whole array/hash, otherwise, iterate over it and write out each object. The reason you do this is almost always to share the data with someone else.

If you just write out the whole array/hash in one fell swoop then it is as simple as what we did above. When you do it one object at a time, it is a little more complicated, since we don't want to write it out to a whole bunch of files, but rather all of them to one file. It is a little more complicated since you want to be able to easily read your objects back in again which can be tricky as YAML serialization creates multiple lines per object. Here is a trick you can use, when you write the objects out, separate them with two newlines e.g.:

```ruby
File.open("/home/alan/tmp/blah.yaml", "w") do |file|
  (1..10).each do |index|
    file.puts YAML::dump(A.new("hello world", index))
    file.puts ""
  end
end
```

The file will look like this:

```
--- !ruby/object:A
number: 1
string: hello world
--- !ruby/object:A
number: 2
string: hello world
...
```

Then when you want to read all the objects back, simply set the input record separator to be two newlines e.g.:

```ruby
array = []
$/="\n\n"
File.open("/home/alan/tmp/blah.yaml", "r").each do |object|
  array << YAML::load(object)
end
 
puts array
```

The output is:

```
In A:
   hello world, 1
In A:
   hello world, 2
In A:
   hello world, 3
...
```

Which is exactly what we expect – handy. By the way, I will be covering things like the input record separator in an upcoming series of posts I am planning to do about Ruby one-liners, so don't forget to subscribe if you don't want to miss it.

## A 3rd Party Alternative

Of course, if we don't want to resort to tricks like that, but still keep our serialized objects human-readable, we have another alternative which is basically as common as the Ruby built in serialization methods – JSON. The JSON support in Ruby is provided by a 3rd party library, all you need to do is:

```
gem install json
```

or

```
gem install json-pure
```

The second one is if you want a pure Ruby implementation (no native extensions).

The good thing about JSON, is the fact that it is even more human readable than YAML. It is also a "low-fat" alternative to XML and can be used to transport data over the wire by AJAX calls that require data from the server (that's the simple one sentence explanation :)). The other good news when it comes to serializing objects to JSON using Ruby is that if you save the object to a file, it saves it on one line, so we don't have to resort to tricks when saving multiple objects and reading them back again. 

There is bad news of course, in that your objects won't automagically be converted to JSON, unless all you're using is hashes, arrays and primitives. You need to do a little bit of work to make sure your custom object is serializable. Let’s make one of the classes we introduced previously serializable using JSON.

```ruby
require "json"
 
class A
  def initialize(string, number)
    @string = string
    @number = number
  end
 
  def to_s
    "In A:\n   #{@string}, #{@number}\n"
  end
 
  def to_json(*a)
    {
      "json_class"   => self.class.name,
      "data"         => {"string" => @string, "number" => @number }
    }.to_json(*a)
  end
 
  def self.json_create(o)
    new(o["data"]["string"], o["data"]["number"])
  end
end
```

Make sure to not forget to `'require' json`, otherwise you'll get funny behaviour. Now you can simply do the following:

```ruby
a = A.new("hello world", 5)
json_string = a.to_json
puts json_string
puts JSON.parse(json_string)
```

Which produces output like this:

```
{"json_class":"A","data":{"string":"hello world","number":5}}
In A:
   hello world, 5
```

The first string is our serialized JSON string, and the second is the result of outputting our deserialized object, which gives the output that we expect.

As you can see, we implement two methods:

-  `to_json` – called on the object instance and allows us to convert an object into a JSON string.
-  `json_create` – allows us to call JSON.parse passing in a JSON string which will convert the string into an instance of our object

You can also see that, when converting our object into a JSON string we need to make sure, that we end up with a hash and that contains the 'json_class' key. We also need to make sure that we only use hashes, arrays, primitives (i.e. integers, floats etc., not really primitives in Ruby but you get the picture) and strings.

So, JSON has some advantages and some disadvantages. I like it because it is widely supported so you can send data around and have it be recognised by other apps. I don't like it because you need to do work to make sure your objects are easily serializable, so if you don't need to send your data anywhere but simply want to share it locally, it is a bit of a pain.

##Binary Serialization

Binary

The other serialization mechanism built into Ruby is binary serialization using Marshal. It is very similar to YAML and just as easy to use, the only difference is it's not human readable as it stores your objects in a binary format. You use Marshal exactly the same way you use YAML, but replace the word YAML with Marshal :)

```ruby
a = A.new("hello world", 5)
puts a
serialized_object = Marshal::dump(a)
puts Marshal::load(serialized_object)
```

```
In A:
   hello world, 5
In A:
   hello world, 5
```

As you can see, according to the output the objects before and after serialization are the same. You don't even need to require anything :). The thing to watch out for when outputting multiple Marshalled objects to the same file, is the record separator. Since you're writing binary data, it is not inconceivable that you may end up with a newline somewhere in a record accidentally, which will stuff everything up when you try to read the objects back in. So two rules of thumb to remember are:


-  don't use puts when outputting Marshalled objects to a file (use print instead), this way you avoid the extraneous newline from the puts
-  use a record separator other than newline, you can make anything unlikely up (if you scroll down a bit you will see that I used '—_—' as a separator)

The disadvantage of Marshal is the fact the its output it not human-readable. The advantage is its speed.

##Which One To Choose?

It's simple, if you need to be able to read your serializable data then you have to go with one of the human-readable formats (YAML or JSON). I'd go with YAML purely because you don't need to do any work to get your custom objects to serialize properly, and the fact that it serializes each object as a multiline string is not such a big deal (as I showed above). The only times I would go with JSON (aside the whole wide support and sending it over the wire deal), is if you need to be able to easily edit your data by hand, or when you need human-readable data and you have a lot of data to deal with (see benchmarks below).

If you don't really need to be able to read your data, then always go with Marshal, especially if you have a lot of data.

Here is a situation I commonly have to deal with. I have a CSV file, or some other kind of data file, I want to read it, parse it and create an object per row or at least a hash per row, to make the data easier to deal with. What I like to do is read this CSV file, create my object and serialize them to a file at the same time using Marshal. This way I can operate on the whole data set or parts of the data set, by simply reading the serialized objects in, and it is orders of magnitude faster than reading the CSV file again. Let's do some benchmarks. I will create 500000 objects (a relatively small set of data) and serialize them all to a file using all three methods.

```ruby
require "benchmark"
 
def benchmark_serialize(output_file)
  Benchmark.realtime do
    File.open(output_file, "w") do |file|
      (1..500000).each do |index|
        yield(file, A.new("hello world", index))
      end
    end
  end
end
 
puts "YAML:"
time = benchmark_serialize("/home/alan/tmp/yaml.dat") do |file, object|
  file.puts YAML::dump(object)
  file.puts ""
end
puts "Time: #{time} sec"
 
puts "JSON:"
time = benchmark_serialize("/home/alan/tmp/json.dat") do |file, object|
  file.puts object.to_json
end
puts "Time: #{time} sec"
 
puts "Marshal:"
time = benchmark_serialize("/home/alan/tmp/marshal.dat") do |file, object|
  file.print Marshal::dump(object)
  file.print "---_---"
end
puts "Time: #{time} sec"
```

```
YAML:
Time: 45.9780583381653 sec
JSON:
Time: 5.44697618484497 sec
Marshal:
Time: 2.77714705467224 sec
```

What about deserializing all the objects:

```ruby
def benchmark_deserialize(input_file, array, input_separator)
  $/=input_separator
  Benchmark.realtime do
    File.open(input_file, "r").each do |object|
      array << yield(object)
    end
  end
end
 
array1 = []
puts "YAML:"
time = benchmark_deserialize("/home/alan/tmp/yaml.dat", array1, "\n\n") do |object|
  YAML::load(object)
end
puts "Array size: #{array1.length}"
puts "Time: #{time} sec"
 
array2 = []
puts "JSON:"
time = benchmark_deserialize("/home/alan/tmp/json.dat", array2, "\n") do |object|
  JSON.parse(object)
end
puts "Array size: #{array2.length}"
puts "Time: #{time} sec"
 
array3 = []
puts "Marshal:"
time = benchmark_deserialize("/home/alan/tmp/marshal.dat", array3, "---_---") do |object|
  Marshal::load(object.chomp)
end
puts "Array size: #{array3.length}"
puts "Time: #{time} sec"
```
```
YAML:
Array size: 500000
Time: 19.4334170818329 sec
JSON:
Array size: 500000
Time: 18.5326402187347 sec
Marshal:
Array size: 500000
Time: 14.6655268669128 sec
```

As you can see, it is significantly faster to serialize objects when you're using Marshal, although JSON is only about 2 times slower. YAML gets left in the dust. When deserializing, the differences are not as apparent, although Marshal is still the clear winner. The more data you have to deal with the more telling these results will be. So, for pure speed – choose Marshal. For speed and human readability – choose JSON (at the expense of having to add methods to custom objects). For human readability with relatively small sets of data – go with YAML.

That's pretty much all you need to know, but it is not all I have to say on serialization. One of the more interesting (and cool) features of Ruby is how useful blocks can be in many situations, so you will inevitably, eventually run into a situation where you may want to serialize a block and this is where you will find trouble! We will deal with block serialization issues and what (if anything) you can do about it in a subsequent post. More Ruby soon :).

> http://www.skorks.com/2010/04/serializing-and-deserializing-objects-with-ruby/
    
---------------------------------


# Customize Your IRB

> Mar 19th, 2013

You probably spend a lot of time in IRB (or the Rails console) but have you taken the time to customize it? Today we’ll take a look at the things I’ve added to mine, and I’ll show you how to hack in a .irbrc_rails that’s only loaded in the Rails console.

## The entire file

```ruby
# .irbrc github/sdball/dotfiles/.irbrc

# ruby 1.8.7 compatible
require 'rubygems'
require 'irb/completion'

# interactive editor: use vim from within irb
begin
  require 'interactive_editor'
rescue LoadError => err
  warn "Couldn't load interactive_editor: #{err}"
end

# awesome print
begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError => err
  warn "Couldn't load awesome_print: #{err}"
end

# configure irb
IRB.conf[:PROMPT_MODE] = :SIMPLE

# irb history
IRB.conf[:EVAL_HISTORY] = 1000
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = File::expand_path("~/.irbhistory")

# load .irbrc_rails in rails environments
railsrc_path = File.expand_path('~/.irbrc_rails')
if ( ENV['RAILS_ENV'] || defined? Rails ) && File.exist?( railsrc_path )
  begin
    load railsrc_path
  rescue Exception
    warn "Could not load: #{ railsrc_path } because of #{$!.message}"
  end
end

class Object
  def interesting_methods
    case self.class
    when Class
      self.public_methods.sort - Object.public_methods
    when Module
      self.public_methods.sort - Module.public_methods
    else
      self.public_methods.sort - Object.new.public_methods
    end
  end
end
```

Ok! There’s not too much there, but let’s break it down from top to bottom.
Require commonly used gems

```ruby
# ruby 1.8.7 compatible
require 'rubygems'
require 'irb/completion'

# interactive editor: use vim from within irb
begin
  require 'interactive_editor'
rescue LoadError => err
  warn "Couldn't load interactive_editor: #{err}"
end

# awesome print
begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError => err
  warn "Couldn't load awesome_print: #{err}"
end
```

Nothing too fancy here. Just some require commands and initialization to load up some of my favorite and frequently used gems.

-  interactive_editor: Allows you to use vim (or your favorite editor) to edit files and have them run within the context of the irb session and to edit objects’ YAML representation.
-  Awesome Print: Pretty prints Ruby objects in color and with nice formatting to show their structure. Seriously useful if you inspect a lot of data. The .irb! call hooks it into irb as the default formatter so you don’t even need to call it directly. It just happens.

## Configure the prompt and add history

```ruby
# configure irb
IRB.conf[:PROMPT_MODE] = :SIMPLE

# irb history
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]
IRB.conf[:EVAL_HISTORY] = 1000
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = File::expand_path("~/.irbhistory")
```

Prompt mode simple just makes prompts look like >> instead of 1.9.3p327 :001 >

Command history is obviously supremely useful if you frequently use the console to hack out solutions.
Optionally load customizations for the Rails console

```ruby
# load .irbrc_rails in rails environments
railsrc_path = File.expand_path('~/.irbrc_rails')
if ( ENV['RAILS_ENV'] || defined? Rails ) && File.exist?( railsrc_path )
  begin
    load railsrc_path
  rescue Exception
    warn "Could not load: #{ railsrc_path } because of #{$!.message}"
  end
end
```

Ahh, now things get interesting. If we detect RAILS_ENV or the Rails object is defined then we can assume that we’re actually inside a Rails console and add some extra configuration. We’ll get to that extra configuration for Rails in a moment.

## Add .interesting_methods

```ruby
class Object
  def interesting_methods
    case self.class
    when Class
      self.public_methods.sort - Object.public_methods
    when Module
      self.public_methods.sort - Module.public_methods
    else
      self.public_methods.sort - Object.new.public_methods
    end
  end
end
```

This one is pretty fun. It adds on a method to Object called interesting_methods. Ruby’s object model is great, but it means that the public api to any object is full of methods defined up its ancestor chain.

```
>> Object.new.methods.count
71
>> Module.new.methods.count
111
>> Class.new.methods.count
115
```

interesting_methods gives us an easy way to filter all that out.
	
```ruby
class Magic
  def cast
    'poof'
  end
end
```

```
>> Magic.new.methods.count
72
>> Magic.new.interesting_methods.count
1
>> Magic.new.interesting_methods
[
  [0] :cast
]
```

Handy! And with some introspection that code accounts for module and class methods as well.

## Rails customizations

Loading an rc file just for the Rails console adds all kinds of opportunities for enhancement.

`.irbrc_rails github/sdball/dotfiles/.irbrc_rails`

```ruby
# hirb: some nice stuff for Rails
begin
  require 'hirb'
  HIRB_LOADED = true
rescue LoadError
  HIRB_LOADED = false
end

require 'logger'

def loud_logger
  enable_hirb
  set_logger_to Logger.new(STDOUT)
end

def quiet_logger
  disable_hirb
  set_logger_to nil
end

def set_logger_to(logger)
  ActiveRecord::Base.logger = logger
  ActiveRecord::Base.clear_reloadable_connections!
end

def enable_hirb
  if HIRB_LOADED
    Hirb::Formatter.dynamic_config['ActiveRecord::Base']
    Hirb.enable
  else
    puts "hirb is not loaded"
  end
end

def disable_hirb
  if HIRB_LOADED
    Hirb.disable
  else
    puts "hirb is not loaded"
  end
end

def efind(email)
  User.find_by_email email
end

# set a nice prompt
rails_root = File.basename(Dir.pwd)
IRB.conf[:PROMPT] ||= {}
IRB.conf[:PROMPT][:RAILS] = {
  :PROMPT_I => "#{rails_root}> ", # normal prompt
  :PROMPT_S => "#{rails_root}* ", # prompt when continuing a string
  :PROMPT_C => "#{rails_root}? ", # prompt when continuing a statement
  :RETURN   => "=> %s\n"          # prefixes output
}
IRB.conf[:PROMPT_MODE] = :RAILS

# turn on the loud logging by default
IRB.conf[:IRB_RC] = Proc.new { loud_logger }
```

Hirb is an awesome thing to add to your Rails console. It adds stuff like table formatting for models and general data, a console menu, and a pager.

The logger customizations will output things like SQL statements made to the database unless quiet_logger is called. Very handy if you are debugging a complex ActiveRecord query.

The prompt mode configuration is just a nice prompt with the application name. We define a :RAILS prompt mode and then use it.

That efind method is just a handy shortcut for something I do semi-often. It combines well with a dash expander shortcut that autofills in my email address.
Want to know more?

There’s a great post on tagholic with tons of info on how to completely customize your irb session: Exploring how to configure irb. If you’re interested in any of the options I use in this post, odds are good that they are explained in much more detail there.

> Written by Stephen Ball Mar 19th, 2013 ruby 
> http://rakeroutes.com/blog/customize-your-irb/

---------------------------------------------

# Understanding method lookup in Ruby 2.0

The introduction of prepend in Ruby 2.0 is a great opportunity to review how exactly Ruby deals with method calls.

To understand method lookup it is imperative to master the class hierarchy in Ruby. I've peppered this article with many code examples; you'll need Ruby 1.9.2 or newer to run most of them yourself. There's one that uses prepend; it will only work in Ruby 2.0.0.
Class hierarchy

Let's start with a classical example of class-based inheritance:

```ruby
class Animal
  def initialize(name)
    @name = name
  end

  def info
    puts "I'm a #{self.class}."
    puts "My name is '#{@name}'."
  end
end

class Dog < Animal
  def info
    puts "I #{make_noise}."
    super
  end

  def make_noise
    'bark "Woof woof"'
  end
end

lassie = Dog.new "Lassie"
lassie.info
# => I bark "Woof woof".
#    I'm a dog.
#    My name is 'Lassie'.
```

## Fiddle with it!

In this example, Dog inherits from Animal. We say that Animal is the superclass of Dog:

```
Dog.superclass # => Animal
```

Note that the method Dog#info calls super. This special keyword executes the next definition of info in the hierarchy, in this case Animal#info.

The hierarchy of a class is available with ancestors:

Dog.ancestors # => [Dog, Animal, Object, Kernel, BasicObject]

It's interesting to note that the ancestry doesn't end with Animal:

Animal.superclass # => Object

The declaration class Animal was equivalent to writing class Animal < Object.

This is why an animal has more methods than just info and make_noise, in particular introspection methods like respond_to?, methods, etc:

lassie.respond_to? :upcase # => false
lassie.methods
 # => [:nil?, :===, :=~, :!~, :eql?, :hash, :<=>, :class, :singleton_class, ...]

So what about Kernel and BasicObject? I'll come back to Kernel later, and there's not much to say about BasicObject besides the fact that is only has a very limited number of methods and is the end of the hierarchy for all classes:

# BasicObject is the end of the line:
Object.superclass # => BasicObject
BasicObject.superclass # => nil
# It has very few methods:
Object.instance_methods.size # => 54
BasicObject.instance_methods.size # => 8

    Classes form a rooted tree with BasicObject as the root.

## Mixins

Although Ruby supports only single inheritance (i.e. a class has only one superclass), it also support mixins. A mixin is a collection of methods that can be included in classes. In Ruby, these are instances of the Module class:

```ruby
module Mamal
  def info
    puts "I'm a mamal"
    super
  end
end
Mamal.class # => Module
```

To pull this functionality in our Dog class, we can use either include or the new prepend. These will insert the module either after or before the class itself:

```ruby
class Dog
  prepend Mamal
end
lassie = Dog.new "Lassie"
lassie.info
# => I'm a mamal.
#    I bark "Woof woof".
#    I'm a dog.
#    My name is 'Lassie'.
Dog.ancestors # => [Mamal, Dog, Animal, Object, ...]
```

If the module was included instead of prepended, the effect would be similar, but the order would be different. Can you guess the output and the ancestors? Try it here.

You can include and prepend as many modules as you want and modules can even be included and prepended to other modules1. Don't hesitate to call ancestors to double check the hierarchy of modules & classes.
Singleton classes

In Ruby, there's just one extra layer to the hierarchy of modules and classes. Any object can have a special class just for itself that takes precedence over everything: the singleton class.

Here's a simple example building on previous ones:

```ruby
scooby = Dog.new "Scooby-Doo"

class << scooby
  def make_noise
    'howl "Scooby-Dooby-Doo!"'
  end
end
scooby.info
# => I'm a mamal.
#    I howl "Scooby-Dooby-Doo!".
#    I'm a dog.
#    My name is 'Scooby-Doo'.
```

Note how the barking was replaced with Scooby Doo's special howl. This won't affect any other instances of the Dog class.

The class << scooby is the special notation to reopen the singleton class of an object. There are alternative ways to define singleton methods:

```ruby
# equivalent to previous example:
def scooby.make_noise
  'howl "Scooby-Dooby-Doo!"'
end
```

The singleton class is a real Class and it can be accessed by calling singleton_class:

```
# Singleton classes have strange names:
scooby.singleton_class # => #<Class:#<Dog:0x00000100a0a8d8>>
# Singleton classes are real classes:
scooby.singleton_class.is_a?(Class) # => true
# We can get a list of its instance methods:
scooby.singleton_class.instance_methods(false) # => [:make_noise]
```

All Ruby objects can have singleton classes2, including classes themselves and yes, even singleton classes.

This sounds a bit crazy... wouldn't that require an infinite number of singleton classes? In a way, yes, but Ruby will create singleton classes as they are needed.

Although the previous example used the singleton class of an instance of Dog, it is more often used for classes. Indeed, "class methods" are actually methods of the singleton class. For example, attr_accessor is an instance method of the singleton class of Module. Ruby on Rails' ActiveRecord::Base has many such methods like has_many, validates_presence_of, etc. These are methods of the singleton class of ActiveRecord::Base:

```ruby
Module.singleton_class
      .private_instance_methods
      .include?(:attr_accessor) # => true

require 'active_record'
ActiveRecord::Base.singleton_method
                  .instance_methods(false)
                  .size  # => 170
```

Singleton classes get their names from the fact that they can only have a single instance:

```ruby
scooby2 = scooby.singleton_class.new
  # => TypeError: can't create instance of singleton class
```

For basically the same reason, you can't directly inherit from a singleton class:

```ruby
class Scoobies < scooby.singleton_class
  # ...
end
# => TypeError: can't make subclass of singleton class
```

On the other hand, singleton classes have a complete class hierachy.

For objects, we have:

```
scooby.singleton_class.superclass == scooby.class == Dog
 # => true, as for most objects
```

For classes, Ruby will automatically set the superclass so that different paths through the superclasses or the singleton classes are equivalent:

```
Dog.singleton_class.superclass == Dog.superclass.singleton_class
 # => true, as for any Class
```

This means that Dog inherits Animal's instance methods as well as its singleton methods.

Just to be certain to confuse everybody, I'll finish with a note on extend. It can be seen as a shortcut to include a module in the singleton class of the receiver3:

```
obj.extend MyModule
# is a shortcut for
class << obj
  include MyModule
end
```

    Ruby's singleton class follow the eigenclass model.

## Method lookup and method missing

Almost done!

The rich ancestor chain that Ruby supports is the basis of all method lookups.

When reaching the last superclass (BasicObject), Ruby provides an extra possibility to handle the call with method_missing.

```
lassie.woof # => NoMethodError: undefined method
  # `woof' for #<Dog:0x00000100a197e8 @name="Lassie">
```

```ruby
class Animal
  def method_missing(method, *args)
    if make_noise.include? method.to_s
      puts make_noise
    else
      super
    end
  end
end

lassie.woof # => bark "Woof woof!"
scooby.woof # => NoMethodError ...
scooby.howl # => howl "Scooby-Dooby-Doo!"
```

Fiddle with it!

In this example, we call super unless the method name is part of the noise an animal makes. super will go down the ancestors chain until it reaches BasicObject#method_missing which will raise the NoMethodError.
Summary

In summary, here's what happens when calling receiver.message in Ruby:

    send message down receiver.singleton_class' ancestors chain
    then send method_missing(message) down that chain

The first methods encountered in this lookup gets executed and its result gets returned. Any call to super resumes the lookup to find the next method.

The ancestors chain for a Module mod is:

    the ancestors chain of each prepended module (last module prepended first)
    mod itself
    the ancestors chain of each included module (last module included first)
    if mod is a class, then the ancestors chain of its superclass.

We can write the ancestors method in pseudo Ruby code4:

class Module
  def ancestors
    prepended_modules.flat_map(&:ancestors) +
    [self] +
    included_modules.flat_map(&:ancestors) +
    is_a?(Class) ? superclass.ancestors : []
  end
end

Writing the actual lookup is more tricky, but it would look like:

class Object
  def send(method, *args)
    singleton_class.ancestors.each do |mod|
      if mod.defines? method
        execute(method, for: self, arguments: args,
          if_super_called: resume_lookup_at(mod))
      end
    end
    send :method_missing, method, *args
  end

  def method_missing(method, *args)
    # This is the end of the line.
    # If we're here, either no method was defined anywhere in ancestors,
    # and no method called 'method_missing' was defined either except this one,
    # or some methods were found but called `super` when there was
    # no more methods to be found but this one.
    raise NoMethodError, "undefined method `#{method}' for #{self}"
  end
end

Technical Footonotes

1 There are some restrictions to mixins:

    Ruby does not support very well hierarchies where the same module appears more than once in the hierarchy. ancestors will (usually) only list a module once, even if it's included at different levels in the ancestry. I still hope this can change in the future, in particular to avoid embarrassing bugs.

    Including a submodule in a module M won't have any effect for any class that already included M, but it will for classes that include M afterwards. See it in action in this fiddle.

    Also, Ruby does not allow cycles in the ancestors chain.

 

2 Ruby actually prohibits access to singleton classes for very few classes: Fixnum, Symbol and (since Ruby 2.0) Bignum and Float:

42.singleton_class # => TypeError: can't define singleton

The rule of thumb is that immediates can't have singleton classes. Since (1 << 42).class will be Fixnum if the platform is 64 bits or Bignum otherwise, it was felt best to treat Bignum the same way. The same reasoning applies to Float in Ruby 2.0, since some floats may be immediates.

The only exceptions are nil, true and false who are singletons of their class: nil.singleton_class is NilClass.

 

3 To be perfectly accurate, extend and singleton_class.send :include have the same effect by default, but they will trigger different callbacks: extended vs included, append_features vs extend_object. If these callbacks are defined differently, then the effect could be different.

 

4 Note that, prepended_modules does not exist yet. Also, singleton_class.ancestors does not include the singleton class itself, but this will change in Ruby 2.1.
Post a Comment
http://tech.pro/tutorial/1149/understanding-method-lookup-in-ruby-20

-----------------------------------------------------
