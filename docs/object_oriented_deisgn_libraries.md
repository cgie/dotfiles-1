# Object-Oriented Design Libraries

One of the interesting things about Ruby is the way it blurs the
distinction between design and implementation. Ideas that have to be
expressed at the design level in other languages can be implemented
directly in Ruby.

To help in this process, Ruby has support for some design-level
strategies.

-    The Visitor pattern (Design Patterns, ) is a way of traversing a
collection without having to know the internal organization of that
collection.
-    Delegation is a way of composing classes more flexibly and
dynamically than can be done using standard inheritance.
-    The Singleton pattern is a way of ensuring that only one
instantiation of a particular class exists at a time.
-    The Observer pattern implements a protocol allowing one object to
notify a set of interested objects when certain changes have occurred.

Normally, all four of these strategies require explicit code each time
they're implemented. With Ruby, they can be abstracted into a library
and reused freely and transparently.

Before we get into the proper library descriptions, let's get the
simplest strategy out of the way.

## Library: delegate

The Visitor Pattern

It's the method each.

Object delegation is a way of composing objects---extending an object
with the capabilities of another---at runtime. This promotes writing
flexible, decoupled code, as there are no compile-time dependencies
between the users of the overall class and the delegates.

The Ruby Delegator class implements a simple but powerful delegation
scheme, where requests are automatically forwarded from a master class
to delegates or their ancestors, and where the delegate can be changed
at runtime with a single method call.

The delegate.rb library provides two mechanisms for allowing an object
to forward messages to a delegate.

-    For simple cases where the class of the delegate is fixed, arrange
for the master class to be a subclass of DelegateClass, passing the name
of the class to be delegated as a parameter (Example 1). Then, in your
class's initialize method, you'd call the superclass, passing in the
object to be delegated. For example, to declare a class Fred that also
supports all the methods in Flintstone, you'd write

```ruby
    class Fred < DelegateClass(Flintstone)
      def initialize
        # ...
        super(Flintstone.new(...))
      end
      # ...
     end
```

-    This is subtly different from using subclassing. With subclassing,
there is only one object, which has the methods and the defined class,
its parent, and their ancestors. With delegation there are two objects,
linked so that calls to one may be delegated to the other.

-    For cases where the delegate needs to be dynamic, make the master
class a subclass of SimpleDelegator (Example 2). You can also add
delegation capabilities to an existing object using SimpleDelegator
(Example 3). In these cases, you can call the __setobj__ method in
SimpleDelegator to change the object being delegated at runtime.

Example 1. Use the DelegateClass method and subclass the result when you
need a class with its own behavior that also delegates to an object of
another class. In this example, we assume that the @sizeInInches array
is large, so we want only one copy of it. We then define a class that
accesses it, converting the values to feet.

```ruby
require 'delegate'


sizeInInches = [ 10, 15, 22, 120 ]


class Feet < DelegateClass(Array)
  def initialize(arr)
    super(arr)
  end
  def [](*n)
    val = super(*n)
    case val.type
    when Numeric; val/12.0
    else;         val.collect {|i| i/12.0}
    end
  end
end

sizeInFeet = Feet.new(sizeInInches)
sizeInInches[0..3] 	» 	[10, 15, 22, 120]
sizeInFeet[0..3] 	» 	[0.8333333333, 1.25, 1.833333333, 10.0]
```

Example 2. Use subclass SimpleDelegator when you want an object that
both has its own behavior and delegates to different objects during its
lifetime. This is an example of the State pattern. Objects of class
TicketOffice sell tickets if a seller is available, or tell you to come
back tomorrow if there is no seller.

```ruby
require 'delegate'


class TicketSeller
  def sellTicket()
    return 'Here is a ticket'
  end
end


class NoTicketSeller
  def sellTicket()
    "Sorry-come back tomorrow"
   end
end


class TicketOffice < SimpleDelegator
  def initialize
    @seller = TicketSeller.new
    @noseller = NoTicketSeller.new
    super(@seller)
  end
  def allowSales(allow = true)
    __setobj__(allow ? @seller : @noseller)
    allow
  end
end

to = TicketOffice.new
to.sellTicket 	» 	"Here is a ticket"
to.allowSales(false) 	» 	false
to.sellTicket 	» 	"Sorry-come back tomorrow"
to.allowSales(true) 	» 	true
to.sellTicket 	» 	"Here is a ticket"
```

Example 3. Create SimpleDelegator objects when you want a single object
to delegate all its methods to two or more other objects.

```ruby
# Example 3 - delegate from existing object
seller   = TicketSeller.new
noseller = NoTicketSeller.new
to = SimpleDelegator.new(seller)
to.sellTicket 	» 	"Here's a ticket"
to.sellTicket 	» 	"Here's a ticket"
to.__setobj__(noseller)
to.sellTicket 	» 	"Sorry-come back tomorrow"
to.__setobj__(seller)
to.sellTicket 	» 	"Here's a ticket"
```

## Library: observer

The Observer pattern, also known as Publish/Subscribe, provides a simple
mechanism for one object to inform a set of interested third-party
objects when its state changes.

In the Ruby implementation, the notifying class mixes in the Observable
module, which provides the methods for managing the associated observer
objects.


- ```add_observer(obj)``` 	Add obj as an observer on this object. obj will now
receive notifications.
- ```delete_observer(obj)``` 	Delete obj as an observer on this object. It will
no longer receive notifications.
- ```delete_observers``` 	Delete all observers associated with this object.
- ```count_observers``` 	Return the count of observers associated with this
object.
- ```changed(newState=true)``` 	Set the changed state of this object.
Notifications will be sent only if the changed state is true.
- ```changed?``` 	Query the changed state of this object.
- ```notify_observers(*args)``` 	If this object's changed state is true, invoke
the update method in each currently associated observer in turn, passing
it the given arguments. The changed state is then set to false.
``

The observers must implement the update method to receive notifications.

```ruby
require "observer"


  class Ticker # Periodically fetch a stock price
    include Observable


    def initialize(symbol)
      @symbol = symbol
    end


    def run
      lastPrice = nil
      loop do
        price = Price.fetch(@symbol)
        print "Current price: #{price}\n"
        if price != lastPrice
          changed                 # notify observers
          lastPrice = price
          notify_observers(Time.now, price)
        end
      end
    end
  end


  class Warner
    def initialize(ticker, limit)
      @limit = limit
      ticker.add_observer(self)   # all warners are observers
    end
  end


  class WarnLow < Warner
    def update(time, price)       # callback for observer
      if price < @limit
        print "--- #{time.to_s}: Price below #@limit: #{price}\n"
      end
    end
  end


  class WarnHigh < Warner
    def update(time, price)       # callback for observer
      if price > @limit
        print "+++ #{time.to_s}: Price above #@limit: #{price}\n"
      end
    end
  end


ticker = Ticker.new("MSFT")
WarnLow.new(ticker, 80)
WarnHigh.new(ticker, 120)
ticker.run
```

produces:

```
Current price: 83
Current price: 75
--- Sun Jun 09 00:10:25 CDT 2002: Price below 80: 75
Current price: 90
Current price: 134
+++ Sun Jun 09 00:10:25 CDT 2002: Price above 120: 134
Current price: 134
Current price: 112
Current price: 79
--- Sun Jun 09 00:10:25 CDT 2002: Price below 80: 79
```

## Library: singleton

The Singleton design pattern ensures that only one instance of a
particular class may be created.

The singleton library makes this simple to implement. Mix the Singleton
module into each class that is to be a singleton, and that class's new
method will be made private. In its place, users of the class call the
method instance, which returns a singleton instance of that class.

In this example, the two instances of MyClass are the same object.

```ruby
require 'singleton'
class MyClass
  include Singleton
end
a = MyClass.instance 	» 	#<MyClass:0x401b4ca8>
b = MyClass.instance 	» 	#<MyClass:0x401b4ca8>
```

Extracted from the book "Programming Ruby - The Pragmatic Programmer's
Guide"
> Copyright © 2001 by Addison Wesley Longman, Inc. This material may be
> distributed only subject to the terms and conditions set forth in the
> Open Publication License, v1.0 or later (the latest version is presently
> available at http://www.opencontent.org/openpub/)).
>
> Distribution of substantively modified versions of this document is
> prohibited without the explicit permission of the copyright holder.
>
> Distribution of the work or derivative of the work in any standard
> (paper) book form is prohibited unless prior permission is obtained from
> the copyright holder. 
