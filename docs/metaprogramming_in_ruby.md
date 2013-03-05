
# Metaprogramming in Ruby

## 0.0 Preamble

These study notes should be used along with Satoshi Asakawa's excellent course on Ruby Metaprogramming. The programs in these study notes have been tested using the following Ruby version:

```
ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]
```

## 1.0 Ruby Metaprogramming

Metaprogramming in Ruby is writing code that manipulates language constructs (like classes, modules, and instance variables) at runtime. It is even possible to enter new Ruby code at runtime and execute the new code without restarting the program.

## 1.1 Instance variables, Methods and Classes

### 1.1.1 An object's Instance variables / Methods

Instance variables just spring into existence when you use them, so you can have objects of the same class that carry different sets of instance variables.

On the inside, an object simply contains its instance variables and a reference to its class. Thus, an object's instance variables live in the object itself, and an object's methods live in the object's class (where they're called the "instance methods" of the class). That's why objects of the same class share methods, but they don't share instance variables.

### 1.1.2 Classes

>    Classes themselves are nothing but objects.
>    Since a class is an object, everything that applies to objects also applies to classes. Classes, like any object, have their own class, being instances of a class called Class.
>    Like any object, classes also have methods. The methods of an object are also the instance methods of its class. This means that the methods of a class are the instance methods of Class.
>    All classes ultimately inherit from Object, which in turn inherits from BasicObject, the root of the Ruby class hierarchy.
>    Class names are nothing but constants.

### 1.1.3 Open Classes

In Ruby, classes are never closed. You can always re-open existing Ruby classes, even standard library classes such as String or Array, and modify them on the fly.

```ruby
class String
  def writesize
    self.size
  end
end
puts "Tell me my size!".writesize
```

Warning: Be careful with Open Classes, if you casually add bits and pieces of functionality to classes, you can end up with bugs like, for example, defining your own capitalize( ) method and inadvertently overwriting the original capitalize( ) method in the class String.

### 1.1.4 Multiple initialize methods?

Following is an example of class overloading. We write a Rectangle class that represents a rectangular shape on a grid. You can instantiate a Rectangle by one of two ways: by passing in the coordinates of its top-left and bottom-right corners, or by passing in its top-left corner along with its length and width. In Ruby there is only one initialize method, but in this example you can act as though there were two.

```ruby
# The Rectangle constructor accepts arguments in either
# of the following forms:
#   Rectangle.new([x_top, y_left], length, width)
#   Rectangle.new([x_top, y_left], [x_bottom, y_right])
class Rectangle
  def initialize(*args)
    if args.size < 2  || args.size > 3
      puts 'Sorry. This method takes either 2 or 3 arguments.'
    else
      puts 'Correct number of arguments.'
    end
  end
end
Rectangle.new([10, 23], 4, 10)
Rectangle.new([10, 23], [14, 13])
```

The above program is incomplete from the Rectangle class viewpoint, but is enough to demonstrate how method overloading can be achieved. Overloading allows that the initialize method takes in a variable number of arguments. This works for any method, it doesn't have to be the initialize method only.

### 1.1.5 Anonymous class

An anonymous class is also known as a singleton class, eigenclass, ghost class, metaclass or an uniclass.

Each object in Ruby has its own anonymous class, a class that can have methods, but is only attached to the object itself: When we add a method to a specific object, Ruby inserts a new, anonymous class into the inheritance hierarchy as a container to hold these types of methods. What's important to understand is that the anonymous class is a regular class which is hidden. It has no name and is not accessible through a constant like other classes. You can't instantiate a new object from it.

Here are some ways by which you can define an anonymous class:

```ruby
# 1
class Rubyist
  def self.who
    "Geek"
  end
end

# 2
class Rubyist
  class << self
    def who
      "Geek"
    end
  end
end

# 3
class Rubyist
end
def Rubyist.who
  "Geek"
end

# 4
class Rubyist
end
Rubyist.instance_eval do
  def who
    "Geek"
  end
end
puts Rubyist.who # => Geek

# 5
class << Rubyist
  def who
    "Geek"
  end
end
```

All five snippets above, define a Rubyist.who that returns Geek.

Anytime one sees a strange looking class definition (\#5 above) where the class keyword is followed by "<<" symbols, you can be sure that an anonymous class is being opened for the object to the right of those symbols.

The following class hierarchy (courtesy: Nick Morgan) is informative:

Class Hierarchy

## 1.2 Calling a method

When you call a method, Ruby does two things:

    - It finds the method. This is a process called method lookup.
    - It executes the method. To do that, Ruby needs something called self.

### 1.2.1 Method Lookup

When you call a method, Ruby looks into the object's class and finds the method there. We need to know about two new concepts: the receiver and the ancestors chain. The receiver is simply the object that you call a method on.

For example, if you write `an_object.display()`, then an_object is the receiver. To understand the concept of an ancestors chain, just look at any Ruby class. Then imagine moving from the class into its superclass, then into the superclass's superclass, and so on until you reach Object (the default superclass) and then, finally, BasicObject (the root of the Ruby class hierarchy). The path of classes you just traversed is called the "ancestors chain" of the class (the ancestors chain also includes modules).

Therefore, to find a method, Ruby goes in the receiver's class, and from there it climbs the ancestors chain until it finds the method. This behavior is also called the "one step to the right, then up" rule: Go one step to the right into the receiver's class, and then up the ancestors chain, until you find the method. When you include a module in a class (or even in another module), Ruby creates an anonymous class that wraps the module, and inserts the anonymous class in the chain, just above the including class itself.

### 1.2.2 self

>    In Ruby, self is a special variable that always references the current object.
>    self (current object) is the default receiver of method calls. This means that if I call a method and don't give an explicit receiver (I don't put something before the dot) then Ruby will always look into the object referenced by self for that method.
>    self (current object) is where instance variables are found. This means that if I write @var then it's going to go and look into the object referenced by self for that particular instance variable. It's to be noted that instance variables are not defined by a class, they are unrelated to sub-classing and the inheritance mechanism.

Thus, whenever we do a method call with an explicit receiver, obj as shown below, then Ruby goes through the following three steps:

```ruby
obj.do_method(param)
```

    - switch self to receiver (obj)
    - look up method (do_method(param)) in self's class (objects do not - - store methods, only classes can)
    - invoke method (do_method(param))

## 1.3 Useful methods in Ruby Metaprogramming

### 1.3.1 Introspection or Reflection

In Ruby it's possible to read information about a class or object at runtime. We could use some of the methods like class(), instance_methods(), instance_variables() to do that. For example:

```ruby
# The code in the following class definition is executed immediately
class Rubyist
  # the code in the following method definition is executed later,
  # when you eventually call the method
  def what_does_he_do
    @person = 'A Rubyist'
    'Ruby programming'
  end
end
an_object = Rubyist.new
puts an_object.class # => Rubyist
puts an_object.class.instance_methods(false) # => what_does_he_do
an_object.what_does_he_do
puts an_object.instance_variables # => @person
```

The respond_to? method is another example of introspection or reflection. You can determine in advance (before you ask the object to do something) whether the object knows how to handle the message you want to send it, by using the respond_to? method. This method exists for all objects; you can ask any object whether it responds to any message.

```ruby
obj = Object.new
if obj.respond_to?(:program)
  obj.program
else
  puts "Sorry, the object doesn't understand the 'program' message."
end
```

### 1.3.2 send

send( ) is an instance method of the Object class. The first argument to send( ) is the message that you're sending to the object - that is, the name of a method. You can use a string or a symbol, but symbols are preferred. Any remaining arguments are simply passed on to the method.

```ruby
class Rubyist
  def welcome(*args)
    "Welcome " + args.join(' ')
  end
end
obj = Rubyist.new
puts(obj.send(:welcome, "famous", "Rubyists"))   # => Welcome famous Rubyists
```

With send( ), the name of the method that you want to call becomes just a regular argument. You can wait literally until the very last moment to decide which method to call, while the code is running.

```ruby
class Rubyist
end

rubyist = Rubyist.new
if rubyist.respond_to?(:also_railist)
  puts rubyist.send(:also_railist)
else
  puts "No such information available"
end
```

In the code above, if the rubyist object knows what to do with :also_railist, you hand the rubyist the message and let it do its thing.

You can call any method with send( ), including private methods.

```ruby
class Rubyist
  private
  def say_hello(name)
    "#{name} rocks!!"
  end
end
obj = Rubyist.new
puts obj.send( :say_hello, 'Matz')
```

Note:

>    Unlike send(), public_send() calls public methods only.
>    Similar to send(), we also have an instance method __send()__ of the BasicObject class.

### 1.3.3 define_method

The `Module#define_method( )` is a private instance method of the class Module. The define_method is only defined on classes and modules. You can dynamically define an instance method in the receiver with define_method( ). You just need to provide a method name and a block, which becomes the method body:

```ruby
class Rubyist
  define_method :hello do |my_arg|
    my_arg
  end
end
obj = Rubyist.new
puts(obj.hello('Matz')) # => Matz
```

### 1.3.4 method_missing

When Ruby does a method look-up and can't find a particular method, it calls a method named `method_missing( )` on the original receiver. The method_missing( ) method is passed the symbol of the non-existent method, an array of the arguments that were passed in the original call and any block passed to the original method. Ruby knows that method_missing( ) is there, because it's a private instance method of BasicObject that every object inherits. The `BasicObject#method_missing( )` responds by raising a NoMethodError. Overriding method_missing( ) allows you to call methods that don't really exist.

```ruby
class Rubyist
  def method_missing(m, *args, &block)
    str = "Called #{m} with #{args.inspect}"
    if block_given?
      puts str + " and also a block: #{block}"
    else
      puts str
    end
  end
end

# => Called anything with []
Rubyist.new.anything
# => Called anything with [3, 4] and also a block: #<Proc:0xa63878@tmp.rb:12>
Rubyist.new.anything(3, 4) { something }
```

### 1.3.5 remove_method and undef_method

To remove existing methods, you can use the remove_method within the scope of a given class. If a method with the same name is defined for an ancestor of that class, the ancestor class method is not removed. The undef_method, by contrast, prevents the specified class from responding to a method call even if a method with the same name is defined in one of its ancestors.

```ruby
class Rubyist
  def method_missing(m, *args, &block)
    puts "Method Missing: Called #{m} with #{args.inspect} and #{block}"
  end

  def hello
    puts "Hello from class Rubyist"
  end
end

class IndianRubyist < Rubyist
  def hello
    puts "Hello from class IndianRubyist"
  end
end

obj = IndianRubyist.new
obj.hello # => Hello from class IndianRubyist

class IndianRubyist
  remove_method :hello  # removed from IndianRubyist, but still in Rubyist
end
obj.hello # => Hello from class Rubyist

class IndianRubyist
  undef_method :hello   # prevent any calls to 'hello'
end
obj.hello # => Method Missing: Called hello with [] and
```

### 1.3.6 eval

The module Kernel has the `eval()` method and is used to execute code in a string. The eval() method can evaluate strings spanning many lines, making it possible to execute an entire program embedded in a string. eval() is slow - calling eval() effectively compiles the code in the string before executing it. But, even worse, eval() can be dangerous. If there's any chance that external data - stuff that comes from outside your application - can wind up inside the parameter to eval(), then you have a security hole, because that external data may end up containing arbitrary code that your application will blindly execute. eval() is now considered a method of last resort.

```ruby
str = "Hello"
puts eval("str + ' Rubyist'") # => "Hello Rubyist"
```

### 1.3.7 instance_eval, module_eval, class_eval

instance_eval(), module_eval() and class_eval() are special types of eval().

#### 1.3.7.1 instance_eval

The class Object has an instance_eval() public method which can be called from a specific object. It provides access to the instance variables of that object. It can be called either with a block or with a string.

```ruby
class Rubyist
  def initialize
    @geek = "Matz"
  end
end
obj = Rubyist.new
# instance_eval can access obj's private methods
# and instance variables
obj.instance_eval do
  puts self # => #<Rubyist:0x2ef83d0>
  puts @geek # => Matz
end
```

The block that you pass to `instance_eval( )` helps you dip inside an object to do something in there. You can wreak havoc on encapsulation! No data is private data anymore.

instance_eval can also be used to add class methods as shown below:

```ruby
class Rubyist
end
Rubyist.instance_eval do
  def who
    "Geek"
  end
end
puts Rubyist.who # => Geek
```

Remember our example back on 1.1.5 Anonymous class #4? We had used instance_eval there.

#### 1.3.7.2 module_eval, class_eval

The `module_eval` and `class_eval` methods operate on modules and classes rather than on objects. The class_eval is defined as an alias of module_eval.

The module_eval and class_eval methods can be used to add and retrieve the values of class variables from outside a class.

```ruby
class Rubyist
  @@geek = "Ruby's Matz"
end
puts Rubyist.class_eval("@@geek") # => Ruby's Matz
```

The module_eval and class_eval methods can also be used to add instance methods to a module and a class. In spite of their names, module_eval and class_eval are functionally identical and each may be used with ether a module or a class.

```ruby
class Rubyist
end
Rubyist.class_eval do
  def who
    "Geek"
  end
end
obj = Rubyist.new
puts obj.who # => Geek
```

Note: class_eval defines instance methods, and instance_eval defines class methods.

### 1.3.8 class_variable_get, class_variable_set

To add or retrieve the values of class variables, the methods `class_variable_get` (this takes a symbol argument representing the variable name and it returns the variable’s value) and `class_variable_set` (this takes a symbol argument representing a variable name and a second argument which is the value to be assigned to the variable) can be used.

```ruby
class Rubyist
  @@geek = "Ruby's Matz"
end
Rubyist.class_variable_set(:@@geek, 'Matz rocks!')
puts Rubyist.class_variable_get(:@@geek) # => Matz rocks!
```

### 1.3.9 class_variables

To obtain a list of class variable names as an array of strings, we can use the class_variables method.

```ruby
class Rubyist
  @@geek = "Ruby's Matz"
  @@country = "USA"
end

class Child < Rubyist
  @@city = "Nashville"
end
print Rubyist.class_variables # => [:@@geek, :@@country]
puts
p Child.class_variables # => [:@@city]
```

You will observe from the program output that the method Child.class_variables gives us the class variables (@@city) defined in the class and not the inherited ones(@@geek, @@country).

### 1.3.10 instance_variable_get, instance_variable_set

One can retrieve the value of instance variables using the instance_variable_get method.

```ruby
class Rubyist
  def initialize(p1, p2)
    @geek, @country = p1, p2
  end
end
obj = Rubyist.new('Matz', 'USA')
puts obj.instance_variable_get(:@geek) # => Matz
puts obj.instance_variable_get(:@country) # => USA
```

You can also add instance variables to classes and objects after they have been created using instance_variable_set.

```ruby
class Rubyist
  def initialize(p1, p2)
    @geek, @country = p1, p2
  end
end
obj = Rubyist.new('Matz', 'USA')
puts obj.instance_variable_get(:@geek) # => Matz
puts obj.instance_variable_get(:@country) # => USA
obj.instance_variable_set(:@country, 'Japan')
puts obj.inspect # => #<Rubyist:0x2ef8038 @country="Japan", @geek="Matz">
```

### 1.3.11 const_get, const_set

One can similarly get and set constants using `const_get` and `const_set`.

const_get returns the value of the named constant, as shown below:

```ruby
puts Float.const_get(:MIN) # => 2.2250738585072e-308
```

const_set sets the named constant to the given object, returning that object. It creates a new constant if no constant with the given name previously existed, as shown below:

```ruby
class Rubyist
end
puts Rubyist.const_set("PI", 22.0/7.0) # => 3.14285714285714
```

As const_get returns the value of a constant, you could use this method to get the value of a class name and then append the new method to create a new object from that class. This could even give you a way of creating objects at runtime by prompting the user to enter class names and method names. One can create a completely new class at runtime by using const_set.

```ruby
# Let us call our new class 'Rubyist'
# (we could have prompted the user for a class name)
class_name = "rubyist".capitalize
Object.const_set(class_name, Class.new)
# Let us create a method 'who'
# (we could have prompted the user for a method name)
class_name = Object.const_get(class_name)
puts class_name # => Rubyist
class_name.class_eval do
  define_method :who do |my_arg|
    my_arg
  end
end
obj = class_name.new
puts obj.who('Matz') # => Matz
```

## 1.4 Bindings

Entities like local variables, instance variables, self... are basically names bound to objects. We call them bindings.

## 1.5 Ruby Blocks and Bindings

A Ruby block contains both the code and a set of bindings. When you define a block, it simply grabs the bindings that are there at that moment, then it carries those bindings along when you pass the block into a method.

```ruby
def who
  person = "Matz"
  yield("rocks")
end
person = "Matsumoto"
who do |y|
  puts("#{person}, #{y} the world") # => Matsumoto, rocks the world
  city = "Tokyo"
end
# puts city # => undefined local variable or method 'city' for main:Object (NameError)
```

Observe that the code in the block sees the person variable that was around when the block was defined, not the method's person variable. Hence a block captures the local bindings and carries them along with it. You can also define additional bindings inside the block, but they disappear after the block ends.

## 1.6 Solved Problems

### 1.6.1 Problem 1

This example has been adapted from Dave Thomas' screencast "Episode 5: Nine Examples of Metaprogramming".

We all know that the Core Ruby course at RubyLearning.org runs for 8 weeks. Every week there is a quiz and marks are allocated out of 10. At the end of 8 weeks the student can find out his percentage score. For example, if a students scores 5,10,10,10,10,10,10,10 marks in 8 weeks i.e. his percentage score is 93.75%

Problem Statement: Every Core Ruby batch has hundreds of students. Let us assume that we have a Ruby method that does this percentage calculation and returns the same value given the same set of arguments. We don't need to go on calculating the value each time. We only need to calculate the value the first time and then somehow associate that value with that set of arguments. Then the next time it gets called, if we have the same arguments, we can use the previously stored value as the return value of this method thus bypassing the need to do the calculations again. We need to develop a solution to address this problem using Metaprogramming techniques.

#### 1.6.1.1 Existing class and method

To start with, let us look at the existing class and method and then keep modifying it to achieve the above result.

```ruby
class Result
  def total(*scores)
    percentage_calculation(*scores)
  end

  private

  def percentage_calculation(*scores)
    puts "Calculation for #{scores.inspect}"
    scores.inject {|sum, n| sum + n } * (100.0/80.0)
  end
end

r = Result.new
puts r.total(5,10,10,10,10,10,10,10)
puts r.total(5,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
```

In the code above, we have a Result class and a total method that takes a list of scores per student. The scores represent the marks obtained by a student in each of the 8 quizzes in the course. The private method percentage_calculation does the actual percentage calculation. To test this, we call the total method 4 times. The first two and the last two have the same set of scores. When we run our code we get the following output:

```
Calculation for [5, 10, 10, 10, 10, 10, 10, 10]
93.75
Calculation for [5, 10, 10, 10, 10, 10, 10, 10]
93.75
Calculation for [10, 10, 10, 10, 10, 10, 10, 10]
100.0
Calculation for [10, 10, 10, 10, 10, 10, 10, 10]
100.0
```

Looking at the above output, we realize that we have called the total method 4 times and that in turn also called the percentage_calculation method 4 times. We are now going to try and reduce the number of calls to the percentage_calculation method.

#### 1.6.1.2 Normal Solution

One way to reduce the number of calls to the percentage_calculation method is to somehow store the previous results in memory. For this, we shall define a subclass named MemoResult that has a hash named @mem and then use the @mem hash in the total method, as shown in the modified code below:

```ruby
class Result
  def total(*scores)
    percentage_calculation(*scores)
  end

  private

  def percentage_calculation(*scores)
    puts "Calculation for #{scores.inspect}"
    scores.inject {|sum, n| sum + n } * (100.0/80.0)
  end
end

class MemoResult < Result
  def initialize
    @mem = {}
  end
  def total(*scores)
    if @mem.has_key?(scores)
      @mem[scores]
    else
      @mem[scores] = super
    end
  end
end

r = MemoResult.new
puts r.total(5,10,10,10,10,10,10,10)
puts r.total(5,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
```

The Hash class has a has_key? method that returns true if the given key is present in @mem. In the above program, if has_key? is true then we return the value available in @mem for that key otherwise we do the calculation by calling percentage_calculation(*scores) and storing the value in @mem. Let us see the output:

```
Calculation for [5, 10, 10, 10, 10, 10, 10, 10]
93.75
93.75
Calculation for [10, 10, 10, 10, 10, 10, 10, 10]
100.0
100.0
```

Observe that we have saved calling the percentage_calculation(*scores) method for the second and fourth call to r.total.

#### 1.6.1.3 Solution using Class.new and define_method

The MemoResult class above, is intimately tied to its parent Result class. To avoid that, let us generate this subclass dynamically using whetever we have learnt so far in Ruby Metaprogramming.

To do that, let us write a method called mem_result that takes two parameters: the name of the parent class and the name of a method (the method will return the name of the class). Here's the code:

```ruby
class Result
  def total(*scores)
    percentage_calculation(*scores)
  end

  private

  def percentage_calculation(*scores)
    puts "Calculation for #{scores.inspect}"
    scores.inject {|sum, n| sum + n } * (100.0/80.0)
  end
end

def mem_result(klass, method)
  mem = {}
  Class.new(klass) do
    define_method(method) do |*args|
      if mem.has_key?(args)
        mem[args]
      else
        mem[args] = super
      end
    end
  end
end

r = mem_result(Result, :total).new
puts r.total(5,10,10,10,10,10,10,10)
puts r.total(5,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
```

The output is:

```
Calculation for [5, 10, 10, 10, 10, 10, 10, 10]
93.75
93.75
Calculation for [10, 10, 10, 10, 10, 10, 10, 10]
100.0
100.0
```

The code Class.new(klass) creates a new anonymous class with the given superclass klass. The block is used as the body of the class and contains the methods in that class. The define_method defines the method method (which is the second argument to mem_result). This takes the method arguments in args.

Note: We have done away with the initialize method and the instance variable @mem. Instead we use a local variable mem since the block is a closure and this local variable mem is available inside the block.

#### 1.6.1.4 Solution using anonymous class

```ruby
class Result
  def total(*scores)
    percentage_calculation(*scores)
  end

  private

  def percentage_calculation(*scores)
    puts "Calculation for #{scores.inspect}"
    scores.inject {|sum, n| sum + n } * (100.0/80.0)
  end
end

r = Result.new

# Anonymous class on object
def r.total(*scores)
  @mem ||= {}
  if @mem.has_key?(scores)
    @mem[scores]
  else
    @mem[scores] = super
  end
end

puts r.total(5,10,10,10,10,10,10,10)
puts r.total(5,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
```

#### 1.6.1.5 Solution using an anonymous class created on the fly

```ruby
class Result
  def total(*scores)
    percentage_calculation(*scores)
  end

  private

  def percentage_calculation(*scores)
    puts "Calculation for #{scores.inspect}"
    scores.inject {|sum, n| sum + n } * (100.0/80.0)
  end
end

def mem_result(obj, method)
  obj.class.class_eval do
    mem ||= {}
    define_method(method) do |*args|
      if mem.has_key?(args)
        mem[args]
      else
        mem[args] = super
      end
    end
  end
end

r = Result.new
mem_result(r, :total)

puts r.total(5,10,10,10,10,10,10,10)
puts r.total(5,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
```

In the above code, we have written a new mem_result method that takes as an argument an object (obj) for which an anonymous class needs to be generated and the second argument being the method (method) to be created within this anonymous class.

We had previously used define_method to create a method on the fly. The problem is that define_method is only defined on classes and modules and what we have here is an object. Hence we get the class of the object by obj.class and then use the class_eval and define_method methods on that class to add an instance method (method) to the class. Let us run the code and check the output.

```
result.rb:21:in `total': super: no superclass method `total' (NoMethodError)
  from result.rb:30
```

The code does not run.

The line mem[args] = super is trying to call the total method of the class Result, from the anonymous class. The problem is that we have defined our total method directly in class Result. We have said obj.class which is class Result and that's not going to work. What we need to do is create an anonymous class and put our total method in this anonymous class. Also, our anonymous class needs to be a subclass of our class Result.

Let us create our anonymous class as follows:

```ruby
  anon = class << obj
    self
  end
```

self above gives us our anonymous class object. This object is then being referenced by our variable anon. Most rubyists would put this code in one line to indicate that they are extracting the ghost class, as follows:

```ruby
anon = class << obj; self; end
```

Having got our anonymous class object, we shall use it in our class_eval method, as shown in the code below:

```ruby
class Result
  def total(*scores)
    percentage_calculation(*scores)
  end

  private

  def percentage_calculation(*scores)
    puts "Calculation for #{scores.inspect}"
    scores.inject {|sum, n| sum + n } * (100.0/80.0)
  end
end

def mem_result(obj, method)
  anon = class << obj; self; end
  anon.class_eval do
    mem ||= {}
    define_method(method) do |*args|
      if mem.has_key?(args)
        mem[args]
      else
        mem[args] = super
      end
    end
  end
end

r = Result.new
mem_result(r, :total)

puts r.total(5,10,10,10,10,10,10,10)
puts r.total(5,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
puts r.total(10,10,10,10,10,10,10,10)
```

Our code runs successfully, giving us the desired result.

### 1.6.2 Problem 2

This example has been adapted from Hal Fulton's article "An Exercise in Metaprogramming with Ruby".

Suppose we have two CSV (comma-separated values) files with a descriptive header at the top, as follows:

```
File: location.txt

name,country
"Matz", "USA"
"Fabio Akita", "Brazil"
"Peter Cooper", "UK"

File: twitter.txt

twitterid,url
"AkitaOnRails","http://www.akitaonrails.com/"
"peterc","http://www.petercooper.co.uk/"
```

Let us start by writing a class and storing it in a file datawrapper.rb. We'll call our class DataWrapper and also define a class method called wrap which will take a filename as a parameter and build a class from it. The first line of the above two text files have a comma-separated list of attribute names. Furthermore, we want to treat the file as an array of data items, reading it into an array of objects.

```ruby
# file: datawrapper.rb
class DataWrapper
   def self.wrap(file_name)
     data = File.new(file_name)
     header = data.gets.chomp
     data.close
     puts header # => name,country
     # in the end we return the class name
  end
end
```

Now let's start writing a small program testdatawrapper.rb that uses the above. Let's read our location.txt file.

```ruby
#testdatawrapper.rb
require 'datawrapper'
DataWrapper.wrap("location.txt")
```

Coming back to our datawrapper.rb program, let's create a new class and give it a suitable name:

```ruby
# file: datawrapper.rb
class DataWrapper
  def self.wrap(file_name)
    data = File.new(file_name)
    header = data.gets.chomp
    data.close
    class_name = File.basename(file_name, ".txt").capitalize
    klass = Object.const_set(class_name, Class.new)
    klass # we return the class name
  end
end
```

The variable klass refers to our new class. If the file was called location.txt, the class will be named Location.

Let us run our modified program testdatawrapper.rb.

```ruby
#testdatawrapper.rb
require 'datawrapper'
data = DataWrapper.wrap("location.txt") # Capture return value and
puts data # => Location
```

Now, let's start to add attributes to it. The first line of data is a list of names. Let's turn it into a simple array of strings by splitting on the comma character. The modified datawrapper.rb program is:

```ruby
# file: datawrapper.rb
class DataWrapper
  def self.wrap(file_name)
    data = File.new(file_name)
    header = data.gets.chomp
    data.close
    class_name = File.basename(file_name, ".txt").capitalize
    klass = Object.const_set(class_name, Class.new)
    # get attribute names
    names = header.split(",")
    p names # => ["name", "country"]
    klass # we return the class name
  end
end
```

Now we can use class_eval in the context of our new class klass. At the same time, we'll define an initialize method. Also, we shall write a to_s method so that we can use puts; and let's also alias that to inspect for convenience. The modified datawrapper.rb program is:

```ruby
# file: datawrapper.rb
class DataWrapper
  def self.wrap(file_name)
    data = File.new(file_name)
    header = data.gets.chomp
    data.close
    class_name = File.basename(file_name, ".txt").capitalize
    klass = Object.const_set(class_name, Class.new)
    # get attribute names
    names = header.split(",")
    klass.class_eval do
      attr_accessor *names
      define_method(:initialize) do |*values|
        names.each_with_index do |name, i|
          instance_variable_set("@"+name, values[i])
        end
      end
      define_method(:to_s) do
        str = "<#{self.class}:"
        names.each {|name| str << " #{name}=#{self.send(name)}" }
        str + ">"
      end
      alias_method :inspect, :to_s
    end
    klass # we return the class name
  end
end
```

Next, we write a class-level method that does a read of an entire file and returns an array of objects representing its contents. Because it's a class method, we're just adding a singleton onto an object klass which happens to be a class. The modified datawrapper.rb program is:

```ruby
# file: datawrapper.rb
class DataWrapper
  def self.wrap(file_name)
    data = File.new(file_name)
    header = data.gets.chomp
    data.close
    class_name = File.basename(file_name, ".txt").capitalize
    klass = Object.const_set(class_name, Class.new)
    # get attribute names
    names = header.split(",")
    klass.class_eval do
      attr_accessor *names
      define_method(:initialize) do |*values|
        names.each_with_index do |name, i|
          instance_variable_set("@"+name, values[i])
        end
      end
      define_method(:to_s) do
        str = "<#{self.class}:"
        names.each {|name| str << " #{name}=#{self.send(name)}" }
        str + ">"
      end
      alias_method :inspect, :to_s
    end
    def klass.read
      array = []
      data = File.new(self.to_s.downcase+".txt")
      data.gets  # throw away header
      data.each do |line|
        line.chomp!
        values = eval("[#{line}]")
        array << self.new(*values)
      end
      data.close
      array
    end
    klass # we return the class name
  end
end
```

Let us now modify our program testdatawrapper.rb and test out the program datawrapper.rb.

```ruby
#testdatawrapper.rb
require 'datawrapper'
klass = DataWrapper.wrap("location.txt")
list = klass.read
list.each do |location|
  puts("#{location.name} is from the #{location.country}")
end
```

Now let's look at a totally different data file i.e. twitter.txt. Our testdatawrapper.rb is as follows:

```ruby
#testdatawrapper.rb
require 'datawrapper'
klass = DataWrapper.wrap("twitter.txt")
list = klass.read
list.each do |twitter|
  puts("#{twitter.twitterid}'s site is #{twitter.url}")
end
```
Even if we add another field to the data file, none of our code in the program datawrapper.rb would have to change. This is a an exercise and an example of the kind of metaprogramming that Ruby allows.

## 1.7 Scope

References

-    An Exercise in Metaprogramming with Ruby.
-    Metaprogramming Ruby - Author: Paolo Perrotta.
-    Metaprogramming in Ruby: It's All About the Self.
-    Programming Ruby 1.9 - Author: Dave Thomas.
-    Seeing Metaclasses Clearly.
-    The Book Of Ruby - Author: Huw Collingbourne.
-    The Ruby Object Model and Metaprogramming screencasts with Dave Thomas.
-    Understanding Ruby Singleton Classes.

_