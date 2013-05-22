# Getting to Know the Ruby Standard Library – Delegator

Today we will examine ruby’s implementation of the Proxy pattern, with the `Delegator class`. We have already seen and example of it in use with WeakRef. A Delegator can be used when you want to intercept calls to some object without concerning the caller. For example we can use a Delegator to hide the latency from http calls or other slow code:

```ruby
  require 'delegate'

  class Future < SimpleDelegator
    def initialize(&block)
      @_thread = Thread.start(&block)
    end

    def __getobj__
      __setobj__(@_thread.value) if @_thread.alive?

      super
    end
  end
``` 

The `Future` will invoke whatever is passed to it without blocking the rest of your code until you try to access the result. You could use it to issue several http requests and then process them later:

```ruby
  require 'net/http'
  
  # These will each execute immediately
  google = Future.new{ Net::HTTP.get_response(URI('http://www.google.com')).body  }
  yahoo  = Future.new{ Net::HTTP.get_response(URI('http://www.yahoo.com')).body  }

  # These will block until their requests have loaded
  puts google
  puts yahoo
```

In this example, `google` and `yahoo` will both spawn threads, however when we try to print them, the `Future` instance will block until the thread is done, and then pass on method calls to the result of our http call. You can grab the code from github and give it try yourself. Lets take a look at how `Delegator` works. Open up the source, and follow along, if you have Qwandry installed qw delegate will do the trick.

The file `delegate.rb` defines two classes, `Delegator`, an abstract class, and `SimpleDelegator` which implements the missing methods in `Delegator`. Let’s look at the first few lines of `Delegator`:

```ruby
  class Delegator
    [:to_s,:inspect,:=~,:!~,:===].each do |m|
      undef_method m
    end
    ...
```

You will notice that a block of code is being executed as part of the ruby class definition. This is entirely valid, and will be executed in the scope of the `Delegator` class. `undef_method` is called to remove the default implementations of some common methods defined by `Object`. We will see why in a little bit. Next up is the initializer:

```ruby
  def initialize(obj)
    __setobj__(obj)
  end
```

The method `__setobj__` might look strange, but it is just a normal method with an obscure name. When a `Delegator` is instantiated, the object it is delegating to is stored away with `__setobj__`. 
Next look at how `Delegator` implements `method_missing`, and you’ll see what all the prep work was for:

```ruby
  def method_missing(m, *args, &block)
    ...
      target = self.__getobj__
      unless target.respond_to?(m)
        super(m, *args, &block)
      else
        target.__send__(m, *args, &block)
      end
    ...
```

`method_missing` is defined on `Object`, and will be called any time that you try to call method that is not defined. 
This is the key to how `Delegator` works, any methods not defined on `Delegator` are handled by this method. Before we dive into this, we should be aware of what the arguments to `method_missing` are. The `m` is the missing method’s name as a symbol. The `args` are zero or more arguments that would have been passed to that method. The `&block` is the block that the method was called with, or `nil` if no block was given.

The first thing `method_missing` does here is call `__getobj__`. 
We've already seen `__setobj__`, it sets the object that `Delegator` wraps, so we can reason that `__getobj__` gets it. 
Once the wrapped object has been obtained, it checks to see if that object implements the method we want to call. If not, then we call `Object#method_missing`, which is going to raise an exception. If the wrapped object does implement our method, then it passes it on. 

The methods that were undefined earlier are guaranteed to be passed on to the wrapped object, and the odd looking `__getobj__` and `__setobj__` are unlikely to collide with any other object’s methods. 

Ruby’s flexibility really shines in this example, in just a few lines of code, we get a very useful class that can be used to implement advanced behavior.

Now let's figure out why there are two classes defined here. If you look down at `Delegator#__setobj__` and `Delegator#__getobj__` we'll see something interesting:

```ruby
  def __getobj__
    raise NotImplementedError, "need to define `__getobj__'"
  end
  ...
  def __setobj__(obj)
    raise NotImplementedError, "need to define `__setobj__'"
  end
```

Neither of these methods are implemented, effectively making `Delegator` an <b>abstract class</b>. For connivence, `SimpleDelegator` implements them in a reasonable manner. There are a few other special methods defined on `Delegator` as well:

```ruby
  def ==(obj)
    return true if obj.equal?(self)
    self.__getobj__ == obj
  end
```

First `Delegator` checks for equality against itself, then it checks it against the wrapped object. This way `==` will return `true` if you pass in either the wrapped object, or the delegate itself. In this same manner you can intercept calls to specific methods, or override `Delegator#method_missing` to intercept all calls.

We have learned about a powerful design pattern that is easily implemented in ruby. We also saw a very good use for ruby’s `method_missing`. How have you used `Delegator` or found similar proxy patterns in ruby?

> Filed under ruby, stdlib

> January 18, 2011 · 8:53 pm

> http://endofline.wordpress.com/2011/01/18/ruby-standard-library-delegator/

> http://twitter.com/adamsanderson
