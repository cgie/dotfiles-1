

# Variable Bindings in Ruby

{ |one, step, back| }
(http://onestepback.org/index.cgi/Tech/Ruby/RubyBindings.rdoc)

In the Shoeboxes article I argued that a mapping of names to values is a better mental model for variables than the shoebox model. How can we take advantage of explicit bindings?

## Bindings

In Ruby, bindings are explicitly made available in a Binding object. Invoking the binding method will produce a Binding object for the current local variables.

Given that bindings are objects, one would think that there would be a number of methods available to get, set and query the names and their values. Unfortunately, in Ruby that is not the case. When you pass a binding to eval, Ruby will use the binding to resolve open variable references while evaluating a string. Other than that, bindings are pretty opaque.

But that still gives us some useful functionality. If you want to know the value of a variable in binding, just evaluate the variable name...

```ruby
  eval "a", vars         # Evaluate the value of "a" in the binding "vars"
```

To change a variable’s value in a binding, use

```ruby
  eval "a = 101", vars   # Bind "a" to the value 101.
```

## Bindings and Local Scope

Using the binding method, we can capture the variable bindings available at a particular point in the code, and pass that binding to a different part of the code to be used there.

Here we pass the binding of the current scope to a method that uses it. This is pretty straight-forward.

```ruby
  def value_of_a(vars)
    eval "a", vars
  end

  def my_scope
    a = 33
    value_of_a(binding)
  end

  my_scope               # => 33
```

Bindings can be returned from a function as well. This example shows that a binding continues to exist after the function that defines the binding has exited.

```ruby
  def f
    a = 22
    b = 33
    binding
  end

  f_vars = f()

  eval "a", f_vars         # => 22
  eval "b", f_vars         # => 33
  eval "a = 101", f_vars
  eval "a", f_vars         # => 101
```

The bizzare feature of this example shows that not only does binding persist beyond the scope of the function that created them, but that you can modify these bindings just by evaluating an assignment within their context.

## Blocks and Bindings

A block in Ruby is a chunk of code that can be called like a function. The block automatically carries with it the bindings from the code location where it was created. For example...

```ruby
  a = 33
  block = lambda { a }
  def redefine_a(b)
    a = 44
    b.call
  end
  redefine_a(block)      # => 33
```

The block returns the value of a in the binding where the block was defined (a == 33), not the binding where the block was called (a == 44).

This combination of code block and binding is called a closure, and is a very powerful tool in a Ruby programmers toolbox.

## Swapping Values

Recently on the ruby-talk mailing list, someone asked about writing a swap function where swap(a,b) would swap the values of the variables "a" and "b". Normally this cannot be done in Ruby because the swap function would have no reference to the binding of the calling function.

However, if we explictly pass in the binding, then it is possible to write a swap-like function. Here is a simple attempt:

```ruby
  def swap(var_a, var_b, vars)
    old_a = eval var_a, vars
    old_b = eval var_b, vars
    eval "#{var_a} = #{old_b}", vars
    eval "#{var_b} = #{old_a}", vars
  end

  a = 22
  b = 33
  swap ("a", "b", binding)
  p a                          # => 33
  p b                          # => 22
```

This actually works! But it has one big drawback. The old values of "a" and "b" are interpolated into a string. As long as the old values are simple literals (e.g. integers or strings), then the last two eval statements will look like: eval "a = 33", vars". 
But if the old values are complex objects, then the eval would look like eval "a = #<SomeObject:0x401fef20>", vars. Oops, this will fail for any value that can not survive a round trip to a string and back.

## Blocks as Getters and Setters

Let’s try a different approach to the "swap" problem. Instead of passing variable names and bindings to the swap function, let’s pass closures that do the work for us …

```ruby
  def swap(get_a, get_b, set_a, set_b)
    temp = get_a.call
    set_a.call(get_b.call)
    set_b.call(temp)
  end

  a = 22
  b = 33
  swap(lambda{a}, lambda{b}, lambda{|v| a=v}, lambda{|v| b=v})
  p a           # => 33
  p b           # => 22
```

Wow! This works great! The values are swapped and arbitrary values are supported. The only down side is that the call to swap is extremely verbose.

## Abstracting the Getter/Setter Code

We can shorten this by creating a getter/setter abstraction called a reference. To create a reference, we will need to supply the name of a variable along with a binding. But this is what we want the code to look like.

```ruby
  a = 22
  ref_a = Reference.new(:a, binding)
  p ref_a.value        # => 22
  ref_a.value = 33
  p ref_a.value        # => 33
  p a                  # => 33
```

So changing the value of a reference should change the binding of the variable the reference refers to.

Here is a first pass at writing the Reference class …

```ruby
  class Reference
    def initialize(var_name, vars)
      @getter = eval "lambda { #{var_name} }", vars
      @setter = eval "lambda { |v| #{var_name} = v }", vars
    end
    def value
      @getter.call
    end
    def value=(new_value)
      @setter.call(new_value)
    end
  end
```

Note that we create lambdas to handle the getting and the setting of values. This avoids the string interpolation problem mentioned above. Since we create the lambdas in the scope of the initialize fuction, we need to explicity pass in the calling scopes bindings so that the lambdas are created in the environment where are variables are defined. Leaving off the binding to eval will cause our getter and setter lambdas to modify the values of "a" and "b" in the scope of initialize instead of the calling scope.

## Writing Swap

We are almost ready to write our swap function. First, let’s create a utility function (named ref) for creating references.

```ruby
  def ref(&block)
    Reference.new(block.call, block.binding)
  end
```

ref takes a single block that returns the name of the value we are refering to. Since blocks automatically carry their binding with them, we get both the variable name and binding in a single argument. We use ref like this... 

```ruby
   aref = ref{:a}
```

Now swap can be written like this.

```ruby
  def swap(aref, bref)
    aref.value, bref.value = bref.value, aref.value
  end

  a = 22
  b = 33
  swap(ref{:a}, ref{:b})
  p a                       # => 33
  p b                       # => 22
```

## Summary

Using bindings, blocks and closures, we can have a great deal of control over the binding of names to objects within any scope. The basic ideas for the Reference class were developed in response to a Scheme/Python question on the C2 Wiki (see c2.com/cgi/wiki?SinisterSchemeSampleInRuby).

