
# Even more eloquent Ruby
from _Rubies in the Rough_
_December 11th, 2011_

I recently read **Eloquent Ruby** so we can discuss it on an upcoming Ruby
Rogues episode with author Russ Olsen. In short, the book is fantastic.
You should definitely read it.

I, on the other hand, am cranky. When you have read Ruby books since the
first one was published (literally!), you can always find something to
complain about. There are a handful of examples in Eloquent Ruby that
could be better, in my opinion. I thought I would show you some of
those. If you've read the book, this should make a nice supplement.
Don't worry if you haven't though, you will still be able to follow
these ideas just fine. I also won't spoil the ending, but you all know
that the Rubyist saves the day.

Before I start, let me stress one more time that this is a terrific
book. It has so many clear discussions of real issues Rubyists must face
when writing code like class variables, the differences between
lambda(), proc(), and Proc.new(), how to use blocks and modules, why
people think Ruby leaks memory and how you can avoid those problems,
plus more. Don't let any fun I poke at the examples below change your
view of this book. If I didn't love it, I wouldn't have bothered to
write this article.

## My Personal Reasoning

In Eloquent Ruby, reasoning is given for when to use certain constructs.
For example, when should you define a block using do ... end and when
should you use braces { ... }? The book says to use words for multiline
blocks and braces for one-liners. That's a decent strategy, but I prefer
another.

I believe Jim Weirich invented this strategy, but here's what I use:

> Use braces for blocks when you care about the return value
> Use words for blocks when you are running the code for its side
effects

Let's look at a couple of examples for that. First, an example where the
return value matters:

```
(1..10).select { |n| n.even? }
```

Here the result of the block determines which values are kept and which
are discarded. So it matters. That means we use braces.

Now let's look at the other side of the equation:

```
10.times do |n|
  puts n
end
```

In this case, I'm just running a block multiple times. The results of it
are discarded. That means we are doing it for the side effects (printing
some content, in this case). That calls for words.

It's worth noting that I did switch to multiple lines here, using the
book's strategy as well. Ruby would allow it on one line, but I do
prefer to split a do ... end block across multiple lines.

I'll keep braces ({ ... }) on one line if it fits, but I'm not married to
this point. If I need multiple lines, I take them. I don't switch to do
... end though, if the return value matters.

## Magic Defined

The book also gives some advice on when you might want to use the `||=`
operator. All of the advice given is great, but it misses one of my
favorite reasons to use it.

I've recommended before that you should be using warnings and that's
still true. If you have warnings active, Ruby will complain when you use
an instance variable before it has been set:

```
$ ruby -we 'p @var'
-e:1: warning: instance variable @var not initialized
nil
```

That's good, because it can help you find bugs. Who hates free bug
finding?

The best way to address this issue is to provide a default value for the
variable when it is accessed:

```
$ ruby -we '@var ||= 42'
```

Ah, the warning is gone. Perfect.

It's interesting to look at exactly why the warning leaves though. It
might not be for the reason you think.

Often we teach that compound assignment operations, like a ||= b, are
just a shortcut form of a = a || b. Is that really true though?

```
$ ruby -we '@var = @var || 42'
-e:1: warning: instance variable @var not initialized
```

I guess not, because our warning came back. It kind of makes sense, if
you think about it. Even though the line above is an assignment, it has
to access @var first (the second reference) before it can complete the
assignment. That access triggers the warning, because it hasn't been
initialized at that point.

That leaves us wondering, what does ||= really expand to? The answer is
that it's something closer to this:

```
$ ruby -we '@var = (defined?(@var) && @var) || 42'
```

The warning is gone again. So what is this defined?() thing? Let's fire
up Pry (my favorite IRb replacement) and try it out:

```
>> defined? @var
=> nil
>> @var = 42
=> 42
>> defined? @var
=> "instance-variable"
```

defined? is one of the few magic keywords in Ruby. It's not a method,
because it has special powers. It will basically answer the question,
"Do you know what this is?"

You can see above that Ruby didn't know about the variable, before I set
it. Then it did.

defined? takes advantage of the fact that a String is a true value in
Ruby and returns what exactly the thing is. This means you can use it in
a conditional statement check or to gain more information.

We can also ask it about methods:

```
>> defined? puts
=> "method"
```

Note that I didn't say :puts. Again, it's magic. Whatever follows
defined? loses its normal meaning and becomes a simple question. That's
why it can dodge warnings. It doesn't have to access the thing (which
could trigger a warning). Instead it just tells you if it knows what it
is.

That can be pretty handy. Consider this:

```
>> defined? puts
=> "method"
>> puts = "Yikes!"
=> "Yikes!"
>> defined? puts
=> "local-variable"
>> defined? puts()
=> "method"
```

Notice how I hid the method from my current scope by creating a local
variable with the same name? defined? helped us see what was going on
there and that I would now need to use parentheses if I wanted the
method.

Aside from the uses mentioned above, and obvious uses like checking
constants, defined? has one more killer trick up its sleeve:

```
>> class Dog
 |   def bark
 |     "Woof!"
 |   end  
 | end  
=> nil
>> class Cat
 |   def meow
 |     "Meow!"
 |   end  
 | end  
=> nil
>> module BarkDetector
 |   def bark
 |     defined?(super) ? super : "I can't bark."
 |   end
 | end
=> nil
>> Dog.new.extend(BarkDetector).bark
=> "Woof!"
>> Cat.new.extend(BarkDetector).bark
=> "I can't bark."
```

As you can see, I used defined?(super) to tell me if I had a method
higher up in the call chain to delegate to. It returns "super" if I do
and the usual nil if I don't. This allows me to check if a handoff is
safe, before I make it.

Those are just a couple of reasons I wanted to add, to those provided in
the book, for how you might make use of certain Ruby constructs.

## Setting a Bad Example for Ruby

For chess nuts like me, going to the movies is a mixed bag. On one hand,
chess enjoys a blessed status in the movies. The go-to method for
telling you that character is brilliant or calculating, without coming
right out and saying it, is to place a chess board in their home.
Awesome!

Unfortunately, if you get a good look at that board, you'll be sad to
see that it's not setup properly about 50% of the time. Doh! I wish I
was exaggerating, but it's true. Look for two bishops of the same color
on identical color squares (not impossible, but incredibly unlikely), a
reversed king and queen in the initial setup, or the absence of a white
square in the lower right hand corner of the board. Now this can drive
you crazy too. You're welcome.

Ruby books use a similar trick that causes me the same amount of pain.
Most of them, including Eloquent Ruby, have an example very similar to
the following early on:

```
array.each { |item| puts item }
```

At this point some books ask, "Isn't that beautiful?" It's hard to say
just why they think that. Perhaps the question is meant to be something
like, "Isn't it nice that I didn't need a for loop, I didn't have to
track an index variable, and I didn't have to add a newline to the
output?" Well sure, but I always think, "What a dumb use of smart-ole
puts()." (Plus, you already know that I believe the block should be do ...
end.)

In case you don't know, this code is equivalent to the above:

```
puts array
```

Now I'm not showing you that just to show that I know more about puts()
than a lot of Ruby authors. Instead, I'm trying to make you aware of a
common Ruby pattern: we like our methods smart. puts() is designed just
that way, to be quite smart.

This method does a ton of things, when you think about it. Let's examine

First, puts() doesn't just blindly push data somewhere. Instead it
honors the $stdout variable. We can use that to spy on what it is really
doing. Let's wrap puts() to force it to return the String it would have
written:

```
>> require "stringio"
=> false
>> def capture_puts(*args)
 |   $stdout = StringIO.new
 |   puts(*args)
 |   $stdout.string
 | ensure
 |   $stdout = STDOUT
 | end
=> nil
>> capture_puts("test")
=> "test\n"
```

What did I do here? Simple, I just defined a new method, capture_puts(),
that forwards exactly the arguments you send it to puts(). Before it
does that though, is switches out $stdout to allow me to capture output
into a String. That's what the standard stringio library is for, to
create a String that pretends to be an IO object. After the call to
puts() I return the captured output. Finally, the ensure clause restores
$stdout to the original STDOUT before leaving this method, to undo my
fiddling. (Confused by the two different references to the standard
output device? Read this.) If I hadn't done that, I might have broken
Pry's ability to show me what's happening.

After I wrapped the method, you can see that I put it to work. The
result tells us about the first special behavior of puts(), which is
that it will add a newline ("\n") to a String before writing it out.

That naturally leads to the second question, "What if the String already
had a newline character at the end?" Let's ask:

```
>> capture_puts("test\n")
=> "test\n"
```

Sweet. puts() is smart enough to just skip adding it in this case.
That's handy.

I have more questions. What if we pass it multiple items?

```
>> capture_puts("one", "two", "three")
=> "one\ntwo\nthree\n"
```

Ah, so it's each item on its own line. Nice.

Of course, we know from how I started this discussion that it treats an
Array the same way:

```
>> capture_puts(%w[one two three])
=> "one\ntwo\nthree\n"
```

What if we mix the two?

```
>> capture_puts("one", %w[two three four], "five")
=> "one\ntwo\nthree\nfour\nfive\n"
```
Yep, it's definitely each item on its own line.

What if we pass it nothing?

```
>> capture_puts
=> "\n"
```

A blank line. Makes sense.

Can we break it? What if I don't give it a String?

```
>> capture_puts(Object.new)
=> "#<Object:0x00000101107a50>\n"
```

Woah, what did it do there? It did something to my Object, but I may not
know exactly what it did. We could find out though. Let's pass it a
snitch object that will tell us what happens:

```
>> class Snitch < BasicObject
 |   def method_missing(method, *args, &block)
 |     ::Kernel.warn "#{method} called."
 |   end
 | end
=> nil
>> capture_puts(Snitch.new)
to_ary called.
to_s called.
=> "#<Snitch:0x000001009c66d8>\n"
```

Now that's interesting! Before we get to what happened though, let's
talk about how I did that. I made a new kind of object called a Snitch,
but note that it inherits from BasicObject.

| `BasicObject` is the new superclass of Object in Ruby 1.9. It is    |
| purposely very barebones in the list of methods it supports. That's |
| for cases just like this, where you would like everything to hit    |
| `method_missing()` so you can handle it dynamically.                |

Once I had all the traffic going through method_missing(), I had to find
a way to tell myself what had happened. That's harder than you might
think with BasicObject. First, all of the handy output methods we are
use to from Kernel are mixed into Object, not BasicObject. So we can't
access those directly. Luckily, Kernel's method are defined using
module_function(), so you can also call them as module methods on Kernel
itself. But that leads to another problem: constant lookup happens from
Object, not BasicObject. That's why I had to use the funny looking
::Kernel to force the lookup into the top-level scope. Finally, I called
warn() to write some output to $stderr, since we are currently messing
with $stdout. OK, that was a pain in the butt, but it tells a cool
story.

Note that Ruby first tried to call to_ary(). That's the conversion
method for objects that are so close to an Array that it is OK for Ruby
to just treat them as if they were an Array. In other words, this is
puts() asking our argument, "Are you an Array?" I'm sure it won't
surprise you to hear that Array implements to_ary() to just return self.
It's OK to treat an Array like an Array, so that makes sense. This means
we now see how the special handling of Array arguments is handled. If
puts() can treat the argument as an Array, it will walk the items and
output each on a line.

That didn't work here, because we didn't return an Array, so puts()
switched strategies. It said, "OK, convert yourself to a String." This
isn't the polite kind of a conversion we saw earlier that would ask,
"Can I treat you as a String?" That would be to_str(). This is the more
demanding version that says, "Turn yourself into a String." Almost every
thing in Ruby can do that, because they inherit a to_s() method from
Object. Not BasicObject though, which is why it was able to show us this
secret.

It's probably worth saying that I'm not sure where the actual output
came from in this case. We didn't provide an Array or a String. I assume
it's a special case inside puts() that kicks in when everything else
fails. I'm just guessing though. I haven't checked the source to see if
that's correct.

Given all of the above, we now understand what happened to our Object
and can prove it:

```
>> obj = Object.new
=> #<Object:0x00000100a2c898>
>> obj.to_s
=> "#<Object:0x00000100a2c898>"
>> capture_puts(obj)
=> "#<Object:0x00000100a2c898>\n"
```

We can actually make use of that knowledge now that we have it:

```
>> module Markdown
 |   class Bold
 |     def initialize(content)
 |       @content = content
 |     end
 |     
 |     def to_s
 |       "**#{@content}**"
 |     end
 |   end
 | end
=> nil
>> capture_puts(Markdown::Bold.new("I am bold!"))
=> "**I am bold!**\n"
```

By defining to_s() we can control what puts() converts our objects to
before writing them out. That's good to know.

puts() has a lot of behavior. This is to make it serve you better. It's
designed to intelligently handle the content you pass to it. That's how
we prefer our Ruby methods to work. Keep this in mind as you learn to
use core methods, but also as you write methods of your own.

## Show Me the Match

Here's a surprisingly simple thing I'm surprised the books never seem to
use.

Most books, including Eloquent Ruby, explain a little bit about regular
expressions and then say, "You can tell if a regex matches using the
match operator (=~):"

```
>> "one two" =~ /missing/
=> nil
>> "one two" =~ /\w+\z/
=> 4
```

OK, so if it doesn't match it's nil. We're pretty use to that. And if it
does match it's 4. To quote Liz Lemon, "What the what?" We know that 4
is true so that's an affirmative response, but 4 really? Why not 42?

The reason is that Ruby is returning the index of where the match
occurred. I think most people figure that out a lot faster than I did,
but even after knowing it I still don't find it all that helpful. I just
never seem to need the index and if I did, well, I would call
String#index().

The problem is actually the question. We are instructed to ask, "Does
this match?" However, when you are dealing with expressions like /\w+\z/
the far more interesting question is, "What does this match?" It turns
out that Ruby has an operator for that too:

```
>> "one two"[/missing/]
=> nil
>> "one two"[/\w+\z/]
=> "two"
```

Isn't that way more helpful? That just makes me think, "Oh, it matches
the last word." It's far easier to understand and teach, if you ask me.

It gets better though. When we index into a String with a regular
expression as I just did, we can even request a part of the match:

```
>> "Gray, James"[/\A(\w+),\s*(\w+)\z/, 2]
=> "James"
```

Or we can use Oniguruma's (the regex engine in Ruby 1.9) named captures
this way:

```
>> "Gray, James"[/\A(?<last>\w+),\s*(?<first>\w+)\z/, :first]
=> "James"
```

Why is this so great? Well think about what happens if it doesn't match.
Using this strategy, we still just get nil:

```
>> "not a name"[/\A(?<last>\w+),\s*(?<first>\w+)\z/, :first]
=> nil
```

But how would we do that with the match operator? The answer is that it
isn't pretty. One possible way is:

```
>> "not a name" =~ /\A(?<last>\w+),\s*(?<first>\w+)\z/ && $~[:first]
=> nil
```

Again, the index just doesn't end up being very helpful, so I had to
resort to another means of accessing the data I wanted. In this case, I
pulled the MatchData object for the last match, hidden in $~. Yuck.

Or you can just index the String with an expression. I'll let you
decide.

## Have Some Class

Eloquent Ruby doesn't really get into why, but it sometimes shows class
methods like this:

```
class MyClass
  def MyClass.whatever
    # ...
  end
end
```

Other times, it shows them like this:

```
class MyClass
  def self.whatever
    # ...
  end
end
```
And I think it pretty much always shows class methods accessed through
the instance like this:

```
class Renderer
  def Renderer.render(content)
    # ...
  end

  def render
    Renderer.render(self)
  end
end
```

But we could also write that as:

```
class Renderer
  def self.render(content)
    # ...
  end

  def render
    self.class.render(self)
  end
end
```

My advice is to prefer the latter. It's a small thing, but this makes it
much easier to change the name of your class (the same would apply to
modules). You just need to change that one name at the top and all the
self references will do the right thing. You won't need to hunt down all
of the extra references.

This is just a good general practice to follow. Let Ruby find the things
it knows how to find for you.

For example, I had to guide Ruby to the warn() method with a ::Kernel
prefix earlier, but that was a special case. Usually, we should just
call warn() and let Ruby do its thing. This is more flexible in the long
run, since methods can be inserted where they are needed in the call
chain.

Handle classes the same way using self as a prefix for class methods and
self.class when you need to get at them from within an instance. Ruby
will find them for you.

## Too Much Love

I love `inject()`. It's probably my favorite iterator. I guess it's that I
really had to work to gain a deep understanding of it, so it's special
to me now that I have that.

Given that, I'm loath to point out a bad use of it. But, a spade is a
spade as they say and Eloquent Ruby includes this gem of a line:

```ruby
@paragraphs.inject('') { |text, para| "#{text}\n#{para}" }
```

In Ruby, we spell that J-O-I-N:

```ruby
@paragraphs.join("\n")
```

To be fair, those aren't totally identical. The version in the book
starts with a blank line, which I assume is a just a bug.

Silly mistake aside, I want to look at the real difference between these
two lines. It actually represents a flaw in thinking about the operation
we are doing. We can start with the question, "Does it even matter which
one I use?" It might. Let's check the speed difference by benchmarking
some code:

```
require "benchmark"

LOREM = <<END_LOREM
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
occaecat cupidatat non proident, sunt in culpa qui officia deserunt
mollit anim id est laborum.
END_LOREM
PARAGRAPHS = Array.new(100, LOREM)
TESTS      = 10_000

Benchmark.bmbm do |results|
  results.report("inject:") do
    TESTS.times do
      PARAGRAPHS.inject("") { |text, para| "#{text}\n#{para}" }
    end
  end

  results.report("join:") do
    TESTS.times do
      PARAGRAPHS.join("\n")
    end
  end
end
```

I get these results:

```
Rehearsal -------------------------------------------
inject:   3.880000   0.010000   3.890000 (  3.890657)
join:     0.140000   0.040000   0.180000 (  0.186126)
---------------------------------- total: 4.070000sec

              user     system      total        real
inject:   3.440000   0.010000   3.450000 (  3.437444)
join:     0.130000   0.040000   0.170000 (  0.182338)
```

OK, so the join() call is about 19 times faster. But why is it faster?
What is inject() doing so much work on?

Let's walk it through for a few steps. First the join() model goes
something like this:

-   Prepare an empty result String
-   Add paragraph one onto the result String
-   Add the separator onto the result String
-   Add paragraph two onto the result String
-   Add the separator onto the result String
-   Add paragraph three onto the result String
-   Add the separator onto the result String
-   Add paragraph four onto the result String
-   Add the separator onto the result String
-   Add paragraph five onto the result String
-   Return the result String

That's just for five paragraphs, but you get the idea.

Now, you may be surprised to hear that the inject() version can be less
steps, depending on how we describe it:

-   Begin with an empty String
-   Replace that with the previous content plus a newline and the first paragraph
-   Replace that with the previous content plus a newline and the second paragraph
-   Replace that with the previous content plus a newline and the third paragraph
-   Replace that with the previous content plus a newline and the fourth paragraph
-   Replace that with the previous content plus a newline and the fifth paragraph
-   Return the final version

The main difference is the number of String objects that get
constructed. In the join() version we make one: the result. It gets
modified several times as we push content onto it, but we already had
all of that content (the paragraphs are in the Array and the separator
was passed as an argument). We're just building up one new String which
ends up being the result.

The inject() version is not like that. It begins with an empty String.
Then it constructs a new String that is the empty String, plus a
separator, plus paragraph one. Then it constructs yet another String
that is the second String (empty, plus a separator, plus first
paragraph), plus a separator, plus paragraph two. At each step, the
previous String becomes junk that must be garbage collected and that's
just more work for Ruby.

Knowing that, could we speed up the inject() version? Probably. Here's
the test I added to the previous benchmarks:

```
results.report("inject with <<:") do
  TESTS.times do
    separator = "\n"
    PARAGRAPHS.inject("") { |text, para| text << separator << para }
  end
end
```

The changes are:

```
    separator is defined just once and reused
    I've switched to the << operator which adds to the String on the
left
```

This means that the empty String passed as an argument to inject()
actually ends up being the end result of the expression. It's just
modified each time the block is called. This is very similar to what
join() is doing.

As you would expect, that gets a lot closer to join():

```
Rehearsal ---------------------------------------------------
inject:           3.880000   0.000000   3.880000 (  3.890008)
join:             0.140000   0.050000   0.190000 (  0.188791)
inject with <<:   0.320000   0.000000   0.320000 (  0.317442)
------------------------------------------ total: 4.390000sec

                      user     system      total        real
inject:           3.610000   0.010000   3.620000 (  3.618957)
join:             0.140000   0.030000   0.170000 (  0.172145)
inject with <<:   0.300000   0.000000   0.300000 (  0.304058)
```

inject() still adds a little overhead, but at least we're in the
neighborhood now.

Am I saying this is a good change? No way! We've missed the point of
inject(). See inject() is for incrementally building up a result, piece
by piece. We aren't doing that. We're just mutating one String over and
over.

You see this all the time in Ruby. For example, say we had some text and
wanted to count word usage in it. I often see this:

```
>> text = "one two two three three three"
=> "one two two three three three"
>> text.scan(/\w+/).inject(Hash.new(0)) { |ws, w| ws[w] += 1; ws }
=> {"one"=>1, "two"=>2, "three"=>3}
```

The use of a Hash to track the counts is fine, but notice how inject()
isn't being allowed to do its thing anymore? You can tell because we had
to tack an ugly ; ws onto the end of the block to carry the Hash forward
with each pass. Otherwise, the block would return some number and we
would error out the next time we tried to index into that.

We could fix that by building a new Hash each time:

```
>> text.scan(/\w+/).inject(Hash.new(0)) { |ws, w| ws.merge(w => ws[w] +
>> 1) }
=> {"one"=>1, "two"=>2, "three"=>3}
```

This brings us full circle though. We are back to burning through
unwanted objects.

It's worth noting that Ruby 1.9 adds an iterator for this purpose. If
you want to iterate but use some secondary object, say for tracking
statistics, try each_with_object():

```
>> text.scan(/\w+/).each_with_object(Hash.new(0)) { |w, ws| ws[w] += 1 }
=> {"one"=>1, "two"=>2, "three"=>3}
```

This ignores the result of the block each time and always carries the
object forward, including making it the final result.

In the end, this just boils down to a case of using the wrong tool for
the job. As much as I love inject() and do recommend you spend the
effort to learn it, it doesn't properly model the process we are using
here. Because that, it just ends up getting in our way.

I hope you have enjoyed this look into some example from the book.
Remember, as is always the case, it's not the specific code we saw that
matters. It's just what we managed to learn from it.

> author: @JEG2
> [source](http://subinterest.com/rubies-in-the-rough/5-even-more-eloquent-ruby)
> <http://subinterest.com/rubies-in-the-rough>
