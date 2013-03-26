
# Ruby optimization example and explanation

> This entry was written by Matt Aimonetti and posted on Monday, September 5th, 2011, 14:58, last updated on Monday, September 5th, 2011, 08:09, and is filed under Misc, ruby.
>
> http://merbist.com/2011/09/05/ruby-optimization-example-and-explaination/
> #performance, #ruby, #scalability

Recently I wrote a small DSL that allows the user to define some code that then gets executed later on and in different contexts. Imagine something like Sinatra where each route action is defined in a block and then executed in context of an incoming request.

The challenge is that blocks come with their context and you can’t execute a block in the context of another one.

Here is a reduction of the challenge I was trying to solve:

```ruby
class SolutionZero
  def initialize(origin, &block)
    @origin = origin
    @block = block
  end
 
  def dispatch
    @block.call
  end
end

SolutionZero.new(42){ @origin + 1 }.dispatch
# undefined method `+' for nil:NilClass (NoMethodError)
```

The problem is that the block refers to the @origin instance variable which is not available in its context.

My first workaround was to use `instance_eval`:

```ruby
class SolutionOne
  def initialize(origin, &block)
    @origin = origin
    @block = block
  end
 
  def dispatch
    self.instance_eval &@block
  end
end
 
SolutionOne.new(40){ @origin + 2}.dispatch
# 42
```

My workaround worked fine, since the block was evaluated in the context of the instance and therefore the `@origin` ivar is made available to block context. Technically, I was good to go, but I wasn’t really pleased with this solution. 

First using `instance_eval` often an indication that you are trying to take a shortcut. Then having to convert my block stored as a block back into a proc every single dispatch makes me sad. Finally, I think that this code is probably not performing as well as it could, mainly due to unnecessary object allocations and code evaluation.

I did some benchmarks replacing `instance_eval` by `instance_exec` since looking at the C code, instance_exec should be slightly faster. Turns out, it is not so I probably missed something when reading the implementation code.

I wrote some more benchmarks and profiled a loop of 2 million dispatches (only the #disptach method call on the same object). The GC profiler report showed that the GC was invoked 287 times and each invocation was blocking the execution for about 0.15ms.
Using Ruby’s ObjectSpace and disabling the GC during the benchmark, I could see that each loop allocates an object of type T_NODE which is more than likely our @block ivar converted back into a block. This is quite a waste. Furthermore, having to evaluate our block in a different context every single call surely isn’t good for performance.

So instead of doing the work at run time, why not doing it at load time? By that I mean that we can optimize the `#dispatch` method if we could “precompile” the method body instead of “proxying” the dispatch to an instance_eval call. Here is the code:

```ruby
class SolutionTwo
  def initialize(origin, &block)
    @origin = origin
    implementation(block)
  end
 
  private
 
  def implementation(block)
    mod = Module.new
    mod.send(:define_method, :dispatch, block)
    self.extend mod
  end
end
 
SolutionTwo.new(40){ @origin + 2}.dispatch
# 42
```

This optimization is based on the fact that the benchmark (and the real life usage) creates the instance once and then calls #dispatch many times. So by making the initialization of our instance a bit slower, we can drastically improve the performance of the method call. We also still need to execute our block in the right context. And finally, each instance might have a different way to dispatch since it is defined dynamically at initialization. To work around all these issues, we create a new module on which we define a new method called `dispatch` and the body of this method is the passed `block`. Then we simply our instance using our new module.

Now every time we call `#dispatch`, a real method is dispatched which is much faster than doing an eval and no objects are allocated. Running the profiler and the benchmarks script used earlier, we can confirm that the GC doesn’t run a single time and that the optimized code runs 2X faster!

Once again, it’s yet another example showing that you should care about object allocation when dealing with code in the critical path. It also shows how to work around the block bindings. Now, it doesn’t mean that you have to obsess about object allocation and performance, even if my last implementation is 2X faster than the previous, we are only talking about a few microseconds per dispatch. That said microseconds do add up and creating too many objects will slow down even your faster code since the GC will stop-the-world as its cleaning up your memory. 

In real life, you probably don’t have to worry too much about low level details like that, unless you are working on a framework or sharing your code with others. But at least you can learn and understand why one approach is faster than the other, it might not be useful to you right away, but if you take programming as a craft, it’s good to understand how things work under the hood so you can make educated decisions.
 
## Update:

@apeiros in the comments suggested a solution that works & performs the same as my solution, but is much cleaner:

```ruby
class SolutionTwo
  def initialize(origin, &block)
    @origin = origin
    define_singleton_method(:dispatch, block) if block_given?
  end
end
```

-----------------------

# Passing Blocks in Ruby Without &block

> By Paul Mucur
> Wednesday, 26 January 2011
> http://mudge.name/2011/01/26/passing-blocks-in-ruby-without-block.html

There are two main ways to receive blocks in a method in Ruby: the first is to use the yield keyword like so:

```ruby
def speak
  puts yield
end

speak { "Hello" }
# Hello
#  => nil
```

The other is to prefix the last argument in a method signature with an ampersand which will then create a `Proc` object from any block passed in. This object can then be executed with the `call` method like so:

```ruby
def speak(&block)
  puts block.call
end

speak { "Hello" }
# Hello
#  => nil
```

The problem with the second approach is that instantiating a new `Proc` object incurs a surprisingly heavy performance penalty as detailed by Aaron Patterson in his excellent RubyConf X presentation, “ZOMG WHY IS THIS CODE SO SLOW?” (beginning around the 30 minute mark or from slide 181).

This can easily be verified with the following benchmark, `block_benchmark.rb`:

```ruby
require "benchmark"

def speak_with_block(&block)
  block.call
end

def speak_with_yield
  yield
end

n = 1_000_000
Benchmark.bmbm do |x|
  x.report("&block") do
    n.times { speak_with_block { "ook" } }
  end
  x.report("yield") do
    n.times { speak_with_yield { "ook" } }
  end
end
```

The results of this on my own machine are as follows (the numbers themselves aren’t as important as their difference):

```
$ ruby block_benchmark.rb 
Rehearsal ------------------------------------------
&block   1.410000   0.020000   1.430000 (  1.430050)
yield    0.290000   0.000000   0.290000 (  0.291750)
--------------------------------- total: 1.720000sec

             user     system      total        real
&block   1.420000   0.030000   1.450000 (  1.452686)
yield    0.290000   0.000000   0.290000 (  0.292179)
```

So it is clearly preferable to choose `yield` over `&block` but what if you need to pass a block to another method?

For example, here is a class that implements a method `tell_ape` which delegates to another, more generic method named tell. This sort of pattern is commonly done using `method_missing` but I’ll keep the methods explicit for simplicity:

```ruby
class Monkey

  # Monkey.tell_ape { "ook!" }
  # ape: ook!
  #  => nil
  def self.tell_ape(&block)
    tell("ape", &block)
  end

  def self.tell(name, &block)
    puts "#{name}: #{block.call}"
  end
end
```

Such a thing is not possible with the yield keyword:

```ruby
class Monkey

  # Monkey.tell_ape { "ook!" }
  # ArgumentError: wrong number of arguments (2 for 1)
  def self.tell_ape
    tell("ape", yield)
  end

  def self.tell(name)
    puts "#{name}: #{yield}"
  end
end
```

Neither does it work by using an ampersand:

```ruby
class Monkey

  # Monkey.tell_ape { "ook!" }
  # TypeError: wrong argument type String (expected Proc)
  def self.tell_ape
    tell("ape", &yield)
  end

  def self.tell(name)
    puts "#{name}: #{yield}"
  end
end
```

However, there is a way to only create a `Proc` object when needed and that is to use the little known behaviour of `Proc.new` as explained in Aaron Patterson’s aforementioned presentation.

If `Proc.new` is called from inside a method without any arguments of its own, it will return a new Proc containing the block given to its surrounding method.

```ruby
def speak
  puts Proc.new.call
end

speak { "Hello" }
# Hello
#  => nil
```

This means that it is now possible to pass a block between methods without using the `&block` parameter:

```ruby
class Monkey

  # Monkey.tell_ape { "ook!" }
  # ape: ook!
  #  => nil
  def self.tell_ape
    tell("ape", &Proc.new)
  end

  def self.tell(name)
    puts "#{name}: #{yield}"
  end
end
```

Of course, if you do use `Proc.new` then you lose the performance benefit of using only `yield` (as `Proc` objects are being created as with `&block`) but it does avoid unnecessary creation of `Proc` objects when you don’t need them. This can be demonstrated with the following benchmark, `proc_new_benchmark.rb`:

```ruby
require "benchmark"

def sometimes_block(flag, &block)
  if flag && block
    block.call
  end
end

def sometimes_proc_new(flag)
  if flag && block_given?
    Proc.new.call
  end
end

n = 1_000_000
Benchmark.bmbm do |x|
  x.report("&block") do
    n.times do
      sometimes_block(false) { "won't get used" }
    end
  end
  x.report("Proc.new") do
    n.times do
      sometimes_proc_new(false) { "won't get used" }
    end
  end
end
```

Which makes the following rather significant difference:

```
$ ruby code/proc_new_benchmark.rb 
Rehearsal --------------------------------------------
&block     1.080000   0.160000   1.240000 (  1.237644)
Proc.new   0.160000   0.000000   0.160000 (  0.156077)
----------------------------------- total: 1.400000sec

               user     system      total        real
&block     1.090000   0.080000   1.170000 (  1.178771)
Proc.new   0.160000   0.000000   0.160000 (  0.155053)
```

The key here is that using `&block` will always create a new `Proc` object, even if we don’t make use of it. By using `Proc.new` only when we actually need it, we can avoid the cost of this object instantiation entirely.

That said, there is a potential trade-off here between performance and readability: it is clear from the `sometimes_block` method signature that it takes a block and therefore will presumably do something with it; the same cannot be said for the more efficient `sometimes_proc_new`.

In the end, it comes down to your specific requirements but it is still a useful language feature to know.

> form the personal web site of Paul Mucur: a web application developer, RubyGem maintainer, jQuery plugin author, Ruby on Rails contributor, occasional tweeter, speaker and general lover of open-source.

------------------
