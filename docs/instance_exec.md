# Understanding Instance Exec in Ruby

Mar 12th, 2013

## procs have lexical scoping

Let’s start with a simple example

```ruby
square = lambda { x * x }
x = 20
puts square.call()
# => undefined local variable or method `x' for main:Object (NameError)
```

So even though variable x is present, the proc could not find it
because when the code was read then x was missing .

Let’s fix the code.

```ruby
x = 2
square = lambda { x * x }
x = 20
puts square.call()
# => 400
```

In the above case we got the answer. But the answer is 400 instead of
4 . That is because the proc binding refers to the variable x. The
binding does not hold the value of the variable, it just holds the
list of variables available. In this case the value of x happens to be
20 when the code was executed and the result is 400.

x does not have to a variable. It could be a method. Check this out.

```ruby
square = lambda { x * x }
def x
  20
end
puts square.call()
# => 400
```

In the above case x is a method definition. Notice that binding is
smart enough to figure out that since no x variable is present let’s
try and see if there is a method by name x .

Another example of lexical binding in procs

```ruby
def square(p)
   x = 2
   puts p.call
end
x = 20
square(lambda { x * x })
#=> 400
```

In the above case the value of x is set as 20 at the code compile
time. Don’t get fooled by x being 2 inside the method call. Inside the
method call a new scope starts and the x inside the method is not the
same x as outside .

##Issues because of lexical scoping

Here is a simple case.

```ruby
class Person
  code = proc { puts self }

  define_method :name do
    code.call()
  end
end

class Developer < Person
end

Person.new.name # => Person
Developer.new.name # => Person
```

In the above case when `Developer.new.name` is executed then output is
Person. And that can cause problem. For example in Ruby on Rails at a
number of places `self` is used to determine if the model that is being
acted upon is STI or not. If the model is STI then for Developer the
query will have an extra where clause like AND "people"."type" IN
('Developer') . So we need to find a solution so that self reports
correctly for both Person and ‘Developer` .

##`instance_eval` can change self

`instance_eval` can be used to change `self`. Here is refactored code
using instance_eval .

```ruby
class Person
  code = proc { puts self }

  define_method :name do
    self.class.instance_eval &code
  end
end

class Developer < Person
end

Person.new.name #=> Person
Developer.new.name #=> Developer
```

Above code produces right result. However `instance_eval` has one
limitation. It does not accept arguments. Let’s change the proc to
accept some arguments to test this theory out.

```ruby
class Person
  code = proc { |greetings| puts greetings; puts self }

  define_method :name do
    self.class.instance_eval 'Good morning', &code
  end
end

class Developer < Person
end

Person.new.name
Developer.new.name

#=> wrong number of arguments (1 for 0) (ArgumentError)
```

In the above case we get an error. That’s because `instance_eval` does
not accept arugments.

This is where `instance_exec` comes to rescue. It allows us to change
`self` and it can also accept arguments.

##instance_exec to rescue

Here is code refactored to use instance_exec .

```ruby
class Person
  code = proc { |greetings| puts greetings; puts self }

  define_method :name do
    self.class.instance_exec 'Good morning', &code
  end
end

class Developer < Person
end

Person.new.name #=> Good morning Person
Developer.new.name #=> Good morning Developer
```

As you can see in the above code `instance_exec` reports correct `self`
and the proc can also accept arguments .

##Conclusion

I hope this article helps you understand why `instance_exec` is useful.

I scanned RubyOnRails source code and found around 26 usages of
`instance_exec` . Look at the usage of instance_exec usage there to gain
more understanding on this topic.

> Posted by Neeraj Singh Mar 12th, 2013 Rails
> http://blog.bigbinary.com/2013/03/12/understanding-instance-exec-in-ruby.html