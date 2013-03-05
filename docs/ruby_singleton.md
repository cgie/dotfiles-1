
Logoblue

A weblog of hand-picked development content served hot. If you're new to Devalot you might want to head over to the article listing or subscribe to the RSS feed. There's also an archive indexed by year and the obligatory tag cloud.
Understanding Ruby Singleton Classes

Posted by: Peter Jones on Sep 15, 2008

If you learned object oriented programming from one of the more static languages such as C++ or Java, the dynamic nature of Ruby may seem magical and elusive. After running into the syntax dedicated to meta-programming you may have been left scratching your head or at least wondering what's happening behind the scenes. Singleton classes, not to be confused with the singleton design pattern, can easily be placed into this head scratching category.

The name itself is confusing leading people to create alternative names such as: object-specific classes, anonymous classes, virtual classes, and eigenclasses. Anonymous class is my favorite, but since the source code to the Ruby interpreter uses the term singleton that's what I'm going to stick with.

Truth be told, singleton classes aren't really that difficult to understand. In this excerpt from my Accelerated Ruby workshop, I remove the mystical fog surrounding the singleton class, and even demonstrate how they can be useful in your day-to-day Ruby adventures.
Method Dispatching

Before we dive into the mysterious singleton underground, let's step back for a quick refresher on dynamic dispatch in Ruby. With each method call, the Ruby interpreter needs to examine the inheritance hierarchy of the receiver in order to find the method that will be executed.

foobar = Array.new
foobar.class # => Array
foobar.size  # => 0

In the last statement above, the size method was called on the foobar object. You can also say that the foobar object was the receiver of the size message. It's the class of the receiver where the interpreter will start its search for the size method, which in this case is the Array class.

If the Array class doesn't contain the size method, the search will continue up the hierarchy until it's found. If the method isn't found at the top of the hierarchy, the search is aborted, and the receiver is sent the method_missing message. Luckily for us the Array class does indeed have a size method and in the example above, it returned zero.

The diagram below illustrates how an object is connected to its class, and how a class is connected to its parent class, also known as its super class.

Dynamic Dispatch Without Singletons
Enter the Singleton Class

Instead of working our way through some wordy and complicated description of what a singleton class is, let's just dive right in and see what it does.

foobar = Array.new

def foobar.size
  "Hello World!"
end

foobar.size  # => "Hello World!"
foobar.class # => Array

bizbat = Array.new
bizbat.size  # => 0

As in the previous example, a new instance of the Array class is created and safely tucked away into a variable named foobar. Then, without warning, we have a funny looking method definition.

Ruby, being the flexible language that it is, allows you to explicitly specify a receiver when defining methods. That is, we can tell Ruby what object will acquire the new method. This syntax shouldn't look too unfamiliar, since it's similar to the syntax used when creating class methods. However, in the case above, we're adding a method to the foobar object.

That's right, that method definition above creates a method that only exists for a single object, not for a class of objects. As you can see from the example code above, other objects of the Array class do not have this new size method, they're still using the one defined in the Array class.

That cheeky little foobar object has now been transformed to something slightly different than what it was before. How is this possible? What is it that makes this foobar object so special that it gets to have methods that no other object has? If you said "singleton class" you'd be correct. When you add a method to a specific object Ruby inserts a new anonymous class into the inheritance hierarchy as a container to hold these types of methods.

Dynamic Dispatch With Singletons

This new singleton class in the foobar inheritance hierarchy has some special properties. As mentioned before, the singleton class is anonymous, it has no name and is not accessible through a constant like other classes. You are able, however, to access the singleton class using some trickery but you can't instantiate a new object from it.

Object instantiation is prevented by the interpreter for any class that has a special singleton flag set on it. This internal flag is also used is when you call the class method on an object. You would expect that the singleton class is returned from that method call, but in fact the interpreter skips over it and returns Array instead.

Another very interesting side effect of the singleton class is that you can use the super method from within your singleton method. Looking back to the code above, we could have called the super method from inside the singleton method. In that case, we would be calling the size method from the Array class.

Speaking of side effects, if you're curious whether or not an object has a singleton class, there is an introspective method called singleton_methods that you can use to get a list of names for all of the singleton methods on an object.

Finally, a word of caution. Once you've created a singleton class for an object you can no longer use Marshal.dump on that object. The marshal library doesn't support objects with singleton classes:

>> Marshal.dump(foobar)
TypeError: singleton can't be dumped
        from (irb):6:in `dump'
        from (irb):6

Since some of the distributed programming libraries use the marshal calls to move objects around machines you might run into the error message above. And now you know what it means.
More Ways to Skin a Singleton

It shouldn't be surprising that Ruby has several ways to create a singleton class for an object. Below you'll find no less than three additional techniques.
Methods From Modules

When you use the extend method on an object to add methods to it from a module, those methods are placed into a singleton class.

module Foo
  def foo
    "Hello World!"
  end
end

foobar = []
foobar.extend(Foo)
foobar.singleton_methods # => ["foo"]

Opening the Singleton Class Directly

Here comes the funny syntax that everyone has been waiting for. The code below tends to confuse people when they see it for the first time but it's pretty useful and fairly straightforward.

foobar = []

class << foobar
  def foo
    "Hello World!"
  end
end

foobar.singleton_methods # => ["foo"]

Anytime you see a strange looking class definition where the class keyword is followed by two less than symbols, you can be sure that a singleton class is being opened for the object to the right of those symbols.

In this example, the singleton class for the foobar object is being opened. As you probably already know, Ruby allows you to reopen a class at any point adding methods and doing anything you could have done in the original class definition. As with the rest of the examples in this section a foo method is being added to the foobar singleton class.
Evaluating Code in the Context of an Object

If you've made it this far it shouldn't be shocking to see a singleton class created when you define a method inside an instance_eval call.

foobar = []

foobar.instance_eval <<EOT
  def foo
    "Hello World!"
  end
EOT
  
foobar.singleton_methods # => ["foo"]

Practical Uses of Singleton Classes

Before you chalk this all up to useless black magic let's tie everything off with some practical examples. Believe it or not, you probably create singleton classes all the time.
Class Methods

While some object oriented languages have class structures that support both instance methods and class methods (sometimes called static methods), Ruby only supports instance methods. If Ruby only supports instances methods where do all those class methods you've been creating end up? Why, the singleton class of course.

This is possible because Ruby classes are actually objects instantiated from the Class class. Their names are constants that point to this object instantiated from the Class class. While this object holds the instance methods for objects instantiated from it, its so-called class methods are kept on a singleton class.

class Foo
  
  def self.one () 1 end
  
  class << self
    def two () 2 end
  end

  def three () 3 end
  
  self.singleton_methods # => ["two", "one"]
  self.class             # => Class
  self                   # => Foo
end

Two of the three methods defined in the code above are class methods, and therefore go into a singleton class. Left as an exercise for the reader is the inheritance hierarchy for the object that the Foo constant references.
Test Mocking

Mocking is a popular testing technique that allows you to stub out method calls for an object or class, forcing them to return a specific value or ensuring that they are called a specific number of times. While there are several good mocking libraries available for Ruby, wouldn't it be nice to know how they work?

In the example below there is a Foo class with two instance methods. The available? method is dependent on the results of the status method. What do you do if you need to verify that the available? method works correctly given the varying results which the status method could return? Mocking and singleton classes to the rescue.

require 'test/unit'

class Foo
  
  def available?
    status == 1
  end
  
  private
  
  def status
    rand(1)
  end
end

class FooTest < Test::Unit::TestCase
  def setup
    @foo = Foo.new
  end

  def test_available_with_status_1
    def @foo.status () 1 end
    assert(@foo.available?)
  end
  
  def test_available_with_status_0
    def @foo.status () 0 end
    assert(!@foo.available?)
  end
end

Conclusion

Understanding the advanced aspects of the Ruby programming language need not be difficult. Hopefully singleton classes make a lot more sense to you now and even seem somewhat useful. You may have missed it but hiding in the text above is also a rather shallow examination of the object system that Ruby employs.

I recommend that you continue your journey in that direction. Hint: see if your local library has a book on Smalltalk.

Tags: Class Method Eigenclass Object Model Ruby Singleton

There's a lot more to Devalot than what you see here. Make sure you subscribe to the RSS feed so you can find out as we launch new features.

Have something to say? Want to submit an article or suggest an open source project? Let us know.
Things to click
RSS Articles Feedback Follow

Copyright © 2012 pmade inc. All Rights Reserved.

[http://www.devalot.com/articles/2008/09/ruby-singleton]
