## Ruby Mixin Tutorial

In Java you just have classes (both abstract and concrete) and
interfaces. The Ruby language provides classes, modules, and a mix of
both. In this post I want to dive into mixins in Ruby.

In the Ruby language a mixin is a class that is mixed with a module.
In other words the implementation of the class and module are joined,
intertwined, combined, etc. A mixin is a different mechanism to the
extend construct used to add concrete implementation to a class. With
a mixin you can extend from a module instead of a class. Before we get
started with the mixin examples let me first explain what a module is.

I think of a module as a degenerate abstract class. A module can’t be
instantiated and no class can directly extend it but a module can
fully implement methods. A class can leverage the implementation of a
module by including the module’s methods. A module can define methods
that can be shared in different and separate classes either at the
class or instance level.

Let me define a module, albeit a trivial one, that would convert a
numeric integer value to English.

```
# Convert a integer value to English.
module Stringify
  # Requires an instance variable @value
  def stringify
    if @value == 1
      "One"
    elsif @value == 2
      "Two"
    elsif @value == 3
      "Three"
    end
  end
end
```

Note that the Stringify module makes use of a @value instance
variable. The class that will be mixed with this module needs to
define and set a @value instance variable since the Stringify module
uses it but does not define it. In addition to instance variables a
module could invoke methods defined not in the module itself but in
the class that it will be mixed with.

Now let me construct a self contained module that is not dependent on
the implementation of any class that it can be mixed with.

```
# A Math module akin to Java Math class.
module Math
  # Could be called as a class, static, method
  def add(val_one, val_two)
    BigInteger.new(val_one + val_two)
  end
end
```

The methods in the Math module are intended to be invoked like class
methods, also known as static methods. The add method in the Math
module accepts two integer values and returns an instance of
BigInteger. Let me now define the mixin BigInteger class.

```
# Base Number class
class Number
  def intValue
    @value
  end
end

# BigInteger extends Number
class BigInteger < Number

  # Add instance methods from Stringify
  include Stringify

  # Add class methods from Math
  extend Math

  # Add a constructor with one parameter
  def initialize(value)
    @value = value
  end
end
```

I loosely modeled the BigInteger and Number classes after the Java
versions. The BigInteger class defines one constructor and directly
inherits one method from the Number base class. To mix in the methods
implemented in the Stringify and Math modules with the BigInteger
class you will note the usage of the include and extend methods,
respectively.

```
# From the BASE class

# Create a new object
bigint1 = BigInteger.new(10)
# Call a method inherited from the base class (Number)
puts bigint1.intValue   # --> 10
```

The **extend method** will mix a module’s methods at the **class level**.
The method defined in the Math module can be used as a class/static
method.

```
# From the EXTENDED module

# Call class method extended from Math
bigint2 = BigInteger.add(-2, 4)
puts bigint2.intValue   # --> 2
```

The **include method** will mix a module’s methods at the **instance level**,
meaning that the methods will become **instance methods**. The method
defined in the Stringify module can be used as an instance method.

```
# From the INCLUDED module

# Call a method included from Stringify
puts bigint2.stringify   # --> 'Two'
```

There is another use of the extend method. You can enhance an object
instance by mixing it with a module at run time! This is a powerful
feature. Let me create a module that will be used to extend an object,
changing its responsibilities at runtime.

```
# Format a numeric value as a currency
module CurrencyFormatter
  def format
    "$#{@value}"
  end
end
```

To mix an object instance with a module you can do the following:

```
# Add the module methods to
# this object instance, only!
bigint2.extend CurrencyFormatter
puts bigint2.format   # --> '$2'
```

Calling the extend method on an an instance will only extend that one
object, objects of the same class will not be extended with the new
functionality.

```
puts bigint1.format   # will generate an error
```

Modules that will be mixed with a class via the include or extend
method could define something like a contructor or initializer method
to the module. The module initializer method will be invoked at the
time the module is mixed with a class. When a class extends a module
the module’s self.extended method will be invoked:

```
module Math
  def self.extended(base)
    # Initialize module.
  end
end
```

The self prefix indicates that the method is a static module level
method. The base parameter in the static extended method will be
either an instance object or class object of the class that extended
the module depending whether you extend a object or class,
respectively.

When a class includes a module the module’s self.included method will
be invoked.

```
module Stringify
  def self.included(base)
    # Initialize module.
  end
end
```

The base parameter will be a class object for the class that includes
the module.

It is important to note that inside the included and extended
initializer methods you can include and extend other modules, here is
an example of that:

```
module Stringify
  def self.included(base)
    base.extend SomeOtherModule
  end
end
```


> author: ...
> source: (http://juixe.com/techknow/index.php/2006/06/15/mixins-in-ruby/)
