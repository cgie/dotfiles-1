
# 21 Ruby Tricks You Should Be Using In Your Own Code

> By Peter Cooper / May 26, 2008
> http://www.rubyinside.com/21-ruby-tricks-902.html

Writing for Ruby Inside, I get to see a lot of Ruby code. Most is good, but sometimes we forget some of Ruby's shortcuts and tricks and reinvent the wheel instead. In this post I present 21 different Ruby "tricks," from those that most experienced developers use every day to the more obscure. Whatever your level, a refresh may help you the next time you encounter certain coding scenarios.

> 2009 Update: This post was written in early 2008 and looking back on it, there are a couple of tricks that I wouldn't recommend anymore - or to which extra warnings need to be added. I've added paragraphs like this where necessary. Enjoy! :-)

## 1 - Extract regular expression matches quickly

A typical way to extract data from text using a regular expression is to use the `match` method. There is a shortcut, however, that can take the pain out of the process:

```ruby
email = "Fred Bloggs <fred@bloggs.com>"
email.match(/<(.*?)>/)[1]            # => "fred@bloggs.com"
email[/<(.*?)>/, 1]                  # => "fred@bloggs.com"
email.match(/(x)/)[1]                # => NoMethodError [:(]
email[/(x)/, 1]                      # => nil
email[/([bcd]).*?([fgh])/, 2]        # => "g"
```

Ultimately, using the `String#[]` approach is cleaner though it might seem more "magic" to you. It's also possible to use it without including an extra argument if you just want to match the entire regular expression. For example:

```ruby
x = 'this is a test'
x[/[aeiou].+?[aeiou]/]    # => 'is i'
```

In this example, we match the first example of "a vowel, some other characters, then another vowel."

## 2 - Shortcut for Array#join

It's common knowledge that `Array#*`, when supplied with a number, multiplies the size of the array by using duplicate elements:

```ruby
[1, 2, 3] * 3 == [1, 2, 3, 1, 2, 3, 1, 2, 3]
```

It's not well known, however, that when given a string as an argument `Array#*` does a join!

```ruby
%w{this is a test} * ", "                 # => "this, is, a, test"
h = { :name => "Fred", :age => 77 }
h.map { |i| i * "=" } * "n"              # => "age=77nname=Fred"
```

## 3 - Format decimal amounts quickly

Formatting floating point numbers into a form used for prices can be done with `sprintf` or, alternatively, with a formatting interpolation:

```ruby
money = 9.5
"%.2f" % money                       # => "9.50"
```

## 4 - Interpolate text quickly

The formatting interpolation technique from #3 comes out again, this time to insert a string inside another:

```ruby
"[%s]" % "same old drag"             # => "[same old drag]"
```

You can use an array of elements to substitute in too:

```ruby
x = %w{p hello p}
"<%s>%s</%s>" % x                    # => "<p>hello</p>"
```

## 5 - Delete trees of files

Don't resort to using the shell to delete directories. Ruby comes with a handy file utilities library called `FileUtils` that can do the hard work:

```ruby
require 'fileutils'
FileUtils.rm_r 'somedir'
```

Be careful how you use this one! There's a `FileUtils.rm_rf` too..

## 6 - Exploding enumerables

`*` can be used to "explode" enumerables (arrays and hashes). "Exploding" is sort of an implicit on-the-fly conversion from an array to regular method arguments. We'll let the examples do the talking:

```ruby
a = %w{a b}
b = %w{c d}
[a + b]                              # => [["a", "b", "c", "d"]]
[*a + b]                             # => ["a", "b", "c", "d"]

a = { :name => "Fred", :age => 93 }
[a]                                  # => [{:name => "Fred", :age =>93}]
[*a]                                 # => [[:name, "Fred"], [:age, 93]]

a = %w{a b c d e f g h}
b = [0, 5, 6]
a.values_at(*b).inspect              # => ["a", "f", "g"]
```

## 7 - Cut down on local variable definitions

Instead of defining a local variable with some initial content (often just an empty hash or array), you can instead define it "on the go" so you can perform operations on it at the same time:

```ruby
(z ||= []) << 'test'
```

> 2009 Update: This is pretty rancid, to be honest. I've changed my mind; you shouldn't be doing this :)

## 8 - Using non-strings or symbols as hash keys

It's rare you see anyone use non-strings or symbols as hash keys. It's totally possible though, and sometimes handy (and, no, this isn't necessarily a great example!):

```ruby
does = is = { true => 'Yes', false => 'No' }
does[10 == 50]                       # => "No"
is[10 > 5]                           # => "Yes"
```

## 9 - Use 'and' and 'or' to group operations for single liners

This is a trick that more confident Ruby developers use to tighten up their code and remove short multi-line if and unless statements:

```ruby
queue = []
%w{hello x world}.each do |word|
  queue << word and puts "Added to queue" unless word.length <  2
end
puts queue.inspect

# Output:
#   Added to queue
#   Added to queue
#   ["hello", "world"]
```

> 2009 Update: Be careful here - this one can sting you in the butt if your first expression returns nil even when it works. A key example of this is with the puts method which returns nil even after printing the supplied arguments.

## 10 - Do something only if the code is being implicitly run, not required

This is a very common pattern amongst experienced Ruby developers. If you're writing a Ruby script that could be used either as a library OR directly from the command line, you can use this trick to determine whether you're running the script directly or not:

```ruby
if __FILE__ == $0
  # Do something.. run tests, call a method, etc. We're direct.
end
```

## 11 - Quick mass assignments

Mass assignment is something most Ruby developers learn early on, but it's amazing how little it's used relative to its terseness:

```ruby
a, b, c, d = 1, 2, 3, 4
```

It can come in particularly useful for slurping method arguments that have been bundled into an array with `*`:

```ruby
def my_method(*args)
  a, b, c, d = args
end
```

If you want to get really smart (although this is more 'clever' than truly wise):

```
def initialize(args)
  args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
end
```

## 12 - Use ranges instead of complex comparisons for numbers

No more `if x > 1000 && x < 2000` nonsense. Instead:

```ruby
year = 1972
puts  case year
        when 1970..1979: "Seventies"
        when 1980..1989: "Eighties"
        when 1990..1999: "Nineties"
      end
```

## 13 - Use enumerations to cut down repetitive code

Rubyists are often keen to remove repetition - often espousing _DRY_ (Don't Repeat Yourself). You can take this to extremes using Ruby's enumerators to perform similar operations multiple times. Consider requiring multiple files, for instance:

```ruby
%w{rubygems daemons eventmachine}.each { |x| require x }
```

## 14 - The Ternary Operator

Another trick that's usually learned early on by Ruby developers but rarely in less experienced developers' code is the "ternary operator." The ternary operator is not a fix-all, but it can sometimes make things tighter, particularly in view templates.

```ruby
puts x == 10 ? "x is ten" : "x is not ten"

# Or.. an assignment based on the results of a ternary operation:
LOG.sev_threshold = ENVIRONMENT == :development ? Logger::DEBUG : Logger::INFO
```

## 15 - Nested Ternary Operators

It can be asking for trouble but ternary operators can be nested within each other (after all, they only return objects, like everything else):

```ruby
qty = 1
qty == 0 ? 'none' : qty == 1 ? 'one' : 'many'
# Just to illustrate, in case of confusion:
(qty == 0 ? 'none' : (qty == 1 ? 'one' : 'many'))
```

## 16 - Fight redundancy with Ruby's "logic" features

I commonly see methods using this sort of pattern:

```ruby
def is_odd(x)
  # Wayyyy too long..
  if x % 2 == 0
    return false
  else
    return true
  end
end
```

Perhaps we can use a ternary operator to improve things?

```ruby
def is_odd(x)
  x % 2 == 0 ? false : true
end
```

It's shorter, and I've seen that pattern a lot (sadly) but you should go one step further and rely on the true / false responses Ruby's comparison operators already give!

```ruby
def is_odd(x)
  # Use the logical results provided to you by Ruby already..
  x % 2 != 0
end
```

Sometimes, though, you want to explicitly convert implicit true/false scenarios into explicit true/false results:

```ruby
class String
  def contains_digits?
    self[/\d/] ? true : false
  end
end
```

If we hadn't done this, you'd get back either `nil` or the first matched digit rather than `true` or `false`.

## 17 - See the whole of an exception's backtrace

```ruby
def do_division_by_zero; 5 / 0; end
begin
  do_division_by_zero
rescue => exception
  puts exception.backtrace
end
```

## 18 - Allow both single items AND arrays to be enumerated against

```ruby
# [*items] converts a single object into an array with that single object
# of converts an array back into, well, an array again
[*items].each do |item|
  # ...
end
```

## 19 - Rescue blocks don't need to be tied to a 'begin'

```ruby
def x
  begin
    # ...
  rescue
    # ...
  end
end

def x
  # ...
rescue
  # ...
end
```

## 20 - Block comments

I tend to see this in more 'old-school' Ruby code. It's surprisingly under-used though, but looks a lot better than a giant row of pound signs in many cases:

```ruby
puts "x"
=begin
  this is a block comment
  You can put anything you like here!

  puts "y"
=end
puts "z"
```

> 2009 Update: Curiously, I've not seen any significant uptake of block comments in Ruby but.. I don't use them myself either anymore. I suspect with column editing and keyboard shortcuts in common text editors, the motivation here has lessened.

## 21 - Rescue to the rescue

You can use rescue in its single line form to return a value when other things on the line go awry:

```ruby
h = { :age => 10 }
h[:name].downcase                         # ERROR
h[:name].downcase rescue "No name"        # => "No name"
```

If you want to post your own list of Ruby tricks to your blog, send trackback here or leave a comment, and I'll link to all of them in a future post. Alternatively, feel free to post your own Ruby tricks as comments here, or critique or improve on those above.

As an aside, Ruby Inside is exactly two years old today. Thanks for your support! Intriguingly, the first post was another Ruby trick that I forgot to include above, so check that out too.
