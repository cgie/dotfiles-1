# Evaluating alternative Decorator implementations in Ruby

> December 26, 2011

> by dancroak
>    design patterns
>    ruby
>    decorators
>    method_missing
>    inheritance
>    delegating


Recently, decorators have become a big part of my Ruby on Rails life.

We used them heavily in a recent client project, Harold Giménez wrote a great post about them, Avdi Grimm is writing about them in Objects on Rails, and Jeff Casimir has a great presentation about them.

Until recently, I still had some questions, however, such as:

- Should I roll my own decorators?
- If I roll my own, what are the tradeoffs of different implementations?
- Do I care about the “transparent interface” requirements of the Gang of Four’s decorator definition?
- Is it good or bad that the decorated object’s class is the decorator instead of the component?

I’d like to try to answer those questions here.

## Intent

A decorator is a design pattern. Its intent, as described in Design Patterns by the Gang of Four is:

> Attach additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing for extending functionality.

## Use it instead of inheritance

An example I’ve seen a couple of times for decorators is the “coffee with milk and sugar” example. One that I found particularly helpful was Luke Redpath’s article.

Here’s a Ruby implementation of that example using class inheritance (subclassing):

```ruby
class CoffeeWithSugar < Coffee
  def cost
    super + 0.2
  end
end

class CoffeeWithMilkAndSugar < Coffee
  def cost
    super + 0.4 + 0.2
  end
end
```

The problems with inheritance include:

- Choices are made statically.
- Clients can’t control how and when to decorate a component.
- Tight coupling.
- Changing the internals of the superclass means all subclasses must change.

In Ruby, including a module is also inheritance:

```ruby
module Milk
  def cost_of_milk
    0.4 if milk?
  end
end

class Coffee
  include Milk
  include Sugar

  def cost
    2 + cost_of_milk + cost_of_sugar
  end
end
```

## How a decorator works

Using Gang of Four terms, a decorator is an object that encloses a component object. It also:

- conforms to interface of component so its presence is transparent to clients.
- forwards (delegates) requests to the component.
- performs additional actions before or after forwarding.

This approach is more flexible than inheritance because you can mix and match responsibilities in more combinations and because the transparency lets you nest decorators recursively, it allows for an unlimited number of responsibilities.

## Alternative implementations in Ruby

I’ve researched and found four common implementations of decorators in Ruby:

- Module + Extend + Super decorator
- Plain Old Ruby Object decorator
- Class + Method Missing decorator
- SimpleDelegator + Super + Getobj decorator

There’s probably others but these seem to be the most common.

### Module + Extend + Super decorator

This implementation is described, and I think advocated for, in the Design Patterns in Ruby book. It consists of:

- module
- super
- extend

Staying with the “coffee with milk and sugar” example for consistency, it is implemented like this:

```ruby
class Coffee
  def cost
    2
  end
end

module Milk
  def cost
    super + 0.4
  end
end

module Sugar
  def cost
    super + 0.2
  end
end

coffee = Coffee.new
coffee.extend(Milk)
coffee.extend(Sugar)
coffee.cost   # 2.6
```

The benefits of this implementation are:

- it delegates through all decorators
- it has all of the original interface because it is the original object

The drawbacks of this implementation are:

- can not use the same decorator more than once on the same object
- difficult to tell which decorator added the functionality

### The “Plain Old Ruby Object” (PORO) decorator

My recommendation is to start with this style of decorator in your Ruby programs, including Rails apps, and then move to something else only when this style fails you.

```ruby
class Coffee
  def cost
    2
  end

  def origin
    "Colombia"
  end
end

class Milk
  def initialize(component)
    @component = component
  end

  def cost
    @component.cost + 0.4
  end
end

coffee = Coffee.new
Sugar.new(Milk.new(coffee)).cost  # 2.6
Sugar.new(Sugar.new(coffee)).cost # 2.4
Sugar.new(Milk.new(coffee)).class # Sugar
Milk.new(coffee).origin           # NoMethodError
```

The benefits of this implementation are:

- can be wrapped infinitely using Ruby instantiation
- delegates through all decorators
- can use same decorator more than once on component

The drawbacks of this implementation are:

- cannot transparently use component’s original interface

This drawback also means that this decorator isn’t really a decorator under the Gang of Four definition. I maintain that we should still call it a decorator, however, because it otherwise looks and acts overwhelmingly like a decorator.

This is a sticky opinion, however, so let’s consider the “transparent interface” requirement from Gang of Four in more detail.

Do we care about the “transparent interface” requirement?

Let’s say the interface we care about decorating is cost. If so, we don’t need to also support origin method. Then, the PORO decorator meets our practical needs.

By redefining the scope of “interface” to be the subset of the object’s entire interface that we care about, we meet the Gang of Four definition. Is that cheating?

I say no. Consider how many methods are on Object in Ruby 1.9.3:

```ruby
> Object.new.methods.size
=> 56
```

An Object in Rails has more than double the number of methods:

```ruby
> Object.new.methods.size
=> 118
```

An ActiveRecord Object has even more:

```ruby
> User.new.methods.size
=> 366
```

We’re not using hundreds of methods on each object, especially in typical use from a Rails view.

However, if we used the PORO decorator in a Rails app to decorate an ActiveRecord object, we’re probably reducing the interface by about 300 methods.

Depending on how we use the object in the app, that may or may not be a problem.

In practice, when TDD’ing a new feature, I have not found this to be an actual problem. That’s why I say start with this decorator.

If it’s not a problem, great. Your test suite should tell you. You might decide to add one or two more methods that do very clear delegation:

```ruby
def comments
  @component.comments
end

def any?
  @component.any?
end
```

However, you might feel like this is tedious or repetitive. So, let’s say we do care about the “transparent interface” requirement later on.

That’s usually accomplished with method_missing or something from Ruby’s delegate library like Delegator, SimpleDelegator, DelegateClass, or Forwardable.

### “Method Missing” decorator

Here’s a `method_missing` implementation of a Ruby decorator:

```ruby
module Decorator
  def initialize(component)
    @component = component
  end

  def method_missing(meth, *args)
    if @component.respond_to?(meth)
      @component.send(meth, *args)
    else
      super
    end
  end

  def respond_to?(meth)
    @component.respond_to?(meth)
  end
end

class Coffee
  def cost
    2
  end

  def origin
    "Colombia"
  end
end

class Milk
  include Decorator

  def cost
    @component.cost + 0.4
  end
end

coffee = Coffee.new
Sugar.new(Milk.new(coffee)).cost   # 2.6
Sugar.new(Sugar.new(coffee)).cost  # 2.4
Sugar.new(Milk.new(coffee)).origin # Colombia
Sugar.new(Milk.new(coffee)).class  # Sugar
```

The benefits of this implementation are:

- can be wrapped infinitely using Ruby instantiation
- delegates through all decorators
- can use the same decorator more than once on the same component
- transparently uses component’s original interface

The drawbacks of this implementation are:

- uses method_missing
- the class of the decorated object is the decorator

Do we care that the class is the decorator?

We should not. This is Ruby, land of duck typing.

However, Rails inflects (object.class.name) for polymorphic relationships, form_for, and other places. When I tried to convert a few older Rails view helpers to decorators, this was an actual problem in the form of ActiveRecord errors during test runs.

In some cases, this revealed a deeper problems. By re-working the model code, I was able to use PORO decorators and the overall codebase was cleaner. Other times, I just thought it was less time-consuming to make the class appear to be the component’s class and move on.

### “SimpleDelegator + Super + Getobj” decorator

So, a Rails compromise is this decorator implementation. I’m trying to use it only as a last resort.

```ruby
class Coffee
  def cost
    2
  end

  def origin
    "Colombia"
  end
end

require 'delegate'

class Decorator < SimpleDelegator
  def class
    __getobj__.class
  end
end

class Milk < Decorator
  def cost
    super + 0.4
  end
end

coffee = Coffee.new
Sugar.new(Milk.new(coffee)).cost   # 2.6
Sugar.new(Sugar.new(coffee)).cost  # 2.4
Milk.new(coffee).origin            # Colombia
Sugar.new(Milk.new(coffee)).class  # Coffee

The benefits of this implementation are:

- can be wrapped infinitely using Ruby instantiation
- delegates through all decorators
- can use same decorator more than once on component
- transparently uses component’s original interface
- class is the component

The drawbacks of this implementation are:

- it redefines class

I honestly don’t know exactly what sort of problems can result from using method_missing or redefining class but I imagine they’ll be manifested in the form of a time-consuming debugging session.

## Plan of action

I think I now understand the tradeoffs of different Ruby implementations and have a plan for using them:

- PORO to start
- SimpleDelegator if I need the “transparent interface” requirement or the decorated object’s class is causing problems for Rails

I still have other questions like:

- What’s the difference between a decorator and a presenter?
- What’s the difference between a decorator and a strategy? And a composite?
- Should I use a gem like Draper?
- Is there any reason to use classic Rails view helpers anymore?
- Should I be using a different templating system like Mustache?

I think I have answers to some, but that’s another post...

> Written by Dan Croak.

> Don't just sit there. Learn something.

> giant robots smashing into other giant robots
> Written by thoughtbot
> source : http://robots.thoughtbot.com/post/14825364877/evaluating-alternative-decorator-implementations-in
