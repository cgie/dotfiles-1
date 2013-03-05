# Evaluation Options in Ruby

Ruby provides a few different types of evaluation options; however, the evals used most often are: *eval*, *instance_eval*, and *class_eval*

## Module.class_eval - in the context of a class or module

The class_eval (and the aliased module_eval) method of Module allows you to evaluate a string or block in the context of a class or module.

Common usages for class_eval include adding methods to a class and including other modules in a class.

```ruby
  klass = Class.new
  klass.class_eval do
    include ERB::Util

    def encoded_hello
      html_escape "Hello World"
    end
  end
  
  klass.new.encoded_hello #=> <b>Hello World</b>

  ```

The above behavior can be achieved without using class_eval; however, a fair amount of readability must be traded.

```ruby
  klass = Class.new
  klass.send :include, ERB::Util
  klass.send :define_method, :encoded_hello do
    html_escape "Hello World"
  end
  klass.send :public, :encoded_hello

  klass.new.encoded_hello #=> <b>Hello World</b>

  ```

## Object.instance_eval - in the context of an instance of a class

The instance_eval method of Object allows you to evaluate a string or block in the context of an instance of a class. This powerful concept allows you to create a block of code in any context and evaulate it later in the context of an individual instance. 

In order to set the context, the variable self is set to the instance while the code is executing, giving the code access to the instance's variables.

```ruby
class Navigator
  def initialize
    @page_index = 0
  end
  def next
   @page_index += 1
  end
end

navigator = Navigator.new
navigator.next
navigator.next
navigator.instance_eval "@page_index" #=> 2
navigator.instance_eval { @page_index } #=> 2
 
```

Similar to the class_eval example, the value of an instance variable can be gotten in other ways; however, using instance_eval is a very straightforward way to accomplish the above task.

## Kernel.eval - in the current context

The eval method of Kernel allows you to evaluate a string in the current context. 

The eval method also allows you to optionally specify a *binding*. If a binding is given, the evaluation will be performed in the context of the binding.

```ruby
hello = "hello world"
 puts eval("hello") #=> "hello world"

 proc = lambda { hello = "goodbye world"; binding }
 eval("hello", proc.call) #=> "goodbye world"

```

-