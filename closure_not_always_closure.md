# A Closure Is Not Always A Closure In Ruby

> March 27, 2013 By Alan Skorkin
> http://www.skorks.com/2013/03/a-closure-is-not-always-a-closure-in-ruby/
> http://www.twitter.com/skorks

## Surprise

Often you don’t really think about what particular language features mean, until those features come and bite you. For me one such feature was Ruby’s `instance_eval`. We all know how `instance_eval` works, it’s pretty straight forward. We pass it a block, and that block gets executed in the context of the object on which we call `instance_eval` e.g.:

```ruby
a = Object.new
a.instance_eval do
  def hello
    puts "hello"
  end
end
a.hello
```

The object a will get a hello method and the subsequent `a.hello` call will succeed. So what’s the gotcha?

The one overwhelming use of `instance_eval` is for creating configuration DSLs. I won’t go into that right now – it deserves a post of its own. Suffice to say that when used for this purpose, the closure semantics of the block that you pass to `instance_eval` don’t matter, i.e. you don’t tend to use the variables (or call methods) from the scope where the block was created. If you do need to use the variables or methods from the scope where the block was created, you might be in for a rude surprise.

## What It Means To Evaluate A Block In A Different Context

Let’s create a class with a method that takes a block and call that method from within another class:

```ruby
class A
  def method1(&block)
    block.call
  end
end

class B
  def initialize
    @instance_var1 = "instance_var1"
    @a = A.new
  end
  def method2
    local1 = "local1"
    @a.method1 do
      p local1
      p @instance_var1
      p helper1
    end
  end
  def helper1
    "helper1"
  end
end

b = B.new
b.method2
```

As expected we get:

```
"local1"
"instance_var1"
"helper1"
```

What happens is that when we create the block inside `method2`, there is a _binding_ that goes along with it. Inside the binding there is a `self object` which is our `instance b` of the `B class`. When we execute the block inside `method1`, it is executed within the context of this `self` and so our local variable, instance variable and helper method are all in scope (just as you would expect from a closure) and everything works fine. 
Let’s modify `method1` slightly to get the self from the binding:

```ruby
class A
  def method1(&block)
    puts block.binding.eval("self").object_id
    block.call
  end
end
b = B.new
p b.object_id
b.method2
```

We get:

```
70229187307420
70229187307420
"local1"
"instance_var1"
"helper1"
```

So both `b` and the `self` inside the binding are the same object as we expected.

But, what happens if instead of calling `method1` with a block on `@a` we `instance_eval` the same block within the context of `@a`.

```ruby
class A
end
class B
  def initialize
    @instance_var1 = "instance_var1"
    @a = A.new
  end
  def method2
    local1 = "local1"
    @a.instance_eval do
      p local1
      p @instance_var1
      p helper1
    end
  end
  def helper1
    "helper1"
  end
end
b = B.new
b.method2
```

We get:

```
"local1"
nil
code2.rb:19:in `block in method2': undefined local variable or method `helper1' for #<A:0x007f966292d308> (NameError)
```

This time `local1` is fine, the instance variable is `nil` and trying to call the method raises an error. This is unexpected, the block should be a closure, but only the local variables were closed over, everything else fell apart. This is not a new issue, but it is important to understand what is happening and why.

### Why

When we call `instance_eval` on an object, the `self` within the block is set to be the object on which we called `instance_eval` (Yahuda has more detail and there is even more detail here). So, even though we still manage to capture the locals from the previous scope, the methods (like `helper1`) are no longer in scope within our new `self` and the instance variables will be equal to `nil` since we haven’t initialized them in this new scope (unless you happen to have an instance variable with the same name in which case it will shadow the one from the scope in which the block was defined – which is probably not what you want).

So, even though we know that blocks in Ruby are closures, there is an exception to every rule.

## How To Overcome The Limitations

So what can we do if we want access to the instance variables and helper method from the scope where the block was defined. Well, for instance variables, one way around would be to pass them in as parameters to the `instance_eval` block, that way they could be treated as locals. Unfortunately `instance_eval` doesn’t take parameters. Luckily some time around Ruby 1.8.7 `instance_exec` was introduced. Since `instance_eval` is so much more popular we sometimes forget that `instance_exec` is even there, it essentially does the same thing as `instance_eval`, but you can pass some arguments to the block.

```ruby
class B
  def initialize
    @instance_var1 = "instance_var1"
    @a = A.new
  end
  def method2
    local1 = "local1"
    @a.instance_exec(@instance_var1) do |instance_var1|
      p local1
      p instance_var1
      p helper1
    end
  end
  def helper1
    "helper1"
  end
end
b = B.new
b.method2
```

We get:

```
"local1"
"instance_var1"
code2.rb:15:in `block in method2': undefined local variable or method `helper1' for #<A:0x007fea7912d3e0> (NameError)
```

This time our instance variable is fine since we’ve turned it into an argument, but we still can’t call the method. Still not nice, but `instance_exec` is obviously somewhat more useful than `instance_eval`. We will come back to handling method calls shortly, but first a bit of history.

## So What Did They Do Before `instance_exec` Existed

### Old

This issue has been around for ages, but `instance_exec` has only been around for a few years, so what did they do before that, when they wanted to pass parameters to `instnace_eval`?

When I decided to write Escort, I chose Trollop as the option parser. It is while reading the Trollop source that I accidentally stumbled upon the answer to the above question. The author of Trollop attributes it to "_why". It’s called `the cloaker` and we use it as a replacement for `instance_eval`. Here is how it works:

```ruby
class A
  def cloaker(&b)
    (class << self; self; end).class_eval do
      define_method :cloaker_, &b
      meth = instance_method :cloaker_
      remove_method :cloaker_
      meth
    end
  end
end
class B
  def initialize
    @instance_var1 = "instance_var1"
    @a = A.new
  end
  def method2
    local1 = "local1"
    @a.cloaker do |instance_var1|
      p local1
      p instance_var1
      p helper1
    end.bind(@a).call(@instance_var1)
  end
  def helper1
    "helper1"
  end
end
b = B.new
b.method2
```

We get:

```
"local1"
"instance_var1"
code2.rb:24:in `block in method2': undefined local variable or method `helper1' for #<A:0x007fb963064900> (NameError)
```

It is somewhat more awkward to use, but the output is identical to that of `instance_exec`. So why does this work?

We define a method on the metaclass of `A` using our block as the body, we then remove it and return the `UnboundMethod`. We then `bind` the unbound method to our target object and call the method.

In order for the `bind` to work, the relationship between the object to which we are binding and the object on which the `UnboundMethod` was originally defined must be a `kind_of? == true`. 
Curiously an instance of the `class A` is a `kind_of? metaclass of A` which is why everything works.

## The Many Faces Of Cloaker

Why did we have to define our `UnboundMethod` on the metaclass of `A`? Well there doesn’t seem to be any good reason really. A cloaker like this will work just fine.

```ruby
class A
  def cloaker(&b)
    self.class.instance_eval do
      define_method :cloaker_, &b
      meth = instance_method :cloaker_
      remove_method :cloaker_
      meth
    end
  end
end
```

So will this one:

```ruby
class A
  def cloaker(&b)
    self.class.class_eval do
      define_method :cloaker_, &b
      meth = instance_method :cloaker_
      remove_method :cloaker_
      meth
    end
  end
end
```

The `kind_of?` relationship will hold in both cases so everything will hang together.

Did we really need to go through all that history, we just want to call helper methods from within the scope where our block is defined?

## What To Do About Method Calls

Let’s have a look at how we can get our helper methods back. One obvious way is to assign `self` to a local and then use this local to call our helper methods from within the `instance_exec` block.

```ruby
class A
end
class B
  def initialize
    @instance_var1 = "instance_var1"
    @a = A.new
  end
  def method2
    local1 = "local1"
    local_self = self
    @a.instance_exec(@instance_var1) do |instance_var1|
      p local1
      p instance_var1
      p local_self.helper1
    end
  end
  def helper1
    "helper1"
  end
end
b = B.new
b.method2
```

We get:

```
"local1"
"instance_var1"
"helper1"
```

Everything works, but it is ugly and if you want to call a private helper method, you’re out of luck again since a private method can’t have an explicit receiver. This is where our cloaker comes into its own again. Using a cloaker and a bit of `method_missing` magic we can create our own version of `instance_exec` that has all the semantics we’ve come to expect from a closure, but will still execute the block within the context of the object on which it is called. We can also abstract away the ugly bind stuff while we’re at it.

```ruby
class A
  def cloaker(*args, &b)
    meth = self.class.class_eval do
      define_method :cloaker_, &b
      meth = instance_method :cloaker_
      remove_method :cloaker_
      meth
    end
    with_previous_context(b.binding) {meth.bind(self).call(*args)}
  end
  def with_previous_context(binding, &block)
    @previous_context = binding.eval('self')
    result = block.call
    @previous_context = nil
    result
  end
  def method_missing(method, *args, &block)
    if @previous_context
      @previous_context.send(method, *args, &block)
    end
  end
end
class B
  def initialize
    @instance_var1 = "instance_var1"
    @a = A.new
  end
  def method2
    local1 = "local1"
    @a.cloaker(@instance_var1) do |instance_var1|
      p local1
      p instance_var1
      p helper1
    end
  end
  private
  def helper1
    "helper1"
  end
end
b = B.new
b.method2
```

Despite the fact that helper1 was private, we get:

```
"local1"
"instance_var1"
"helper1"
```

Essentially when we execute the block within the context of on object; we retain (in an instance variable) the self from the context where the block was defined (we get this self from the biding of the block). When a method is called within the block and it is not defined within the current context – `method_missing` will be called as per usual Ruby semantics. We hook into `method_missing` and `send` the method call to the `self` that we have retained from when the block was defined. This will call our method or fail if it was a genuine error.

Despite the fact that Ruby can surprise you with non-closure blocks, you can have your cake and eat it too, if you’re willing to do just a bit of work and give some new legs to an old trick while you’re at it.

_