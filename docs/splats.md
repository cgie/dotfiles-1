# The Strange Ruby Splat

As of ruby 1.9, you can do some pretty odd things with array destructuring and splatting. Putting the star before an object invokes the splat operator, which has a variety of effects. First we’ll start with some very useful examples, then we will poke around the dark corners of ruby’s arrays and the splat operator.

##Method Definitions

You can use a splat in a method definition to gather up any remaining arguments:

```ruby
  def say(what, *people)
    people.each{|person| puts "#{person}: #{what}"}
  end
  
  say "Hello!", "Alice", "Bob", "Carl"
  # Alice: Hello!
  # Bob: Hello!
  # Carl: Hello!
```

In the example above, what will get the first argument, then `*people` will capture however many other arguments you pass into say. A real world example of this can be found in the definition of `Delegator#method_missing`. A common ruby idiom is to pass a hash in as the last argument to a method. Rails defines an array helper `Array#extract_options!` to make this idiom easier to handle with variable argument methods, but you can actually get a similar behavior using a splat at the beginning of the argument list:

```ruby
  def arguments_and_opts(*args, opts)
    puts "arguments: #{args} options: #{opts}"
  end
  
  arguments_and_opts 1,2,3, :a=>5
  # arguments: [1, 2, 3] options: {:a=>5}
```

Now this example only works if you are guaranteed to pass in a hash at the end, but it illustrates that the `splat` does not need to always come at the end of a method’s parameters. There are also some other odd uses for the splat in method defitions, for instance this is valid:

```ruby
  def print_pair(a,b,*)
    puts "#{a} and #{b}"
  end
  
  print_pair 1,2,3,:cake,7
  # 1 and 2
```

Outside of letting you mimic javascript calling conventions, I’m not sure what the practical use is:

```javascript
  function print_pair(a,b){ 
    console.log(a + " and " + b);
  }
  
  print_pair(1,2,3, "cake", 7);
  //=> 1 and 2
```

## Calling Methods

The `splat` can also be used when calling a method, not just when defining one. If you wanted to use the `say` method from above, but you have your list of people in an array, the `splat` can help you out:

```ruby
  people = ["Rudy", "Sarah", "Thomas"]
  say "Howdy!", *people
  # Rudy: Howdy!
  # Sarah: Howdy!
  # Thomas: Howdy!
```

In this case, the `splat` converted the array into method arguments. It doesn’t have to be used with methods that take a variable number of arguments though, you can use it in all kinds of other creative ways:

```ruby
  def add(a,b)
    a + b
  end
  
  pair = [3,7]
  add *pair
  # 7
```

## Array Destructuring

First of all, lets quickly cover a few things you can do without splatting:

```ruby
  a,b = 1,2               # Assign 2 values at once
  a,b = b,a               # Assign values in parallel
  puts "#{a} and #{b}"
  # 2 and 1
```

With the above samples in mind, let’s try some fancier stuff. You can use `splat`s with multiple assignment to extract various elements from a list:

```ruby
  first, *list = [1,2,3,4]          # first= 1, list= [2,3,4]
  *list, last  = [1,2,3,4]          # list= [1,2,3], last= 4
  first, *center, last = [1,2,3,4]  # first= 1, center= [2,3], last=4
  
  # Unquote a String (don't do this)
  _, *unquoted, _ = '"quoted"'.split(//)
  puts unquoted.join
  # quoted
```

## Array Coercion

If for some reason the previous examples seemed like great ideas to you, you’ll be thrilled to know that the `splat` can also be used to coerce values into arrays:

```ruby
  a = *"Hello"  #=> ["Hello"]
  "Hello".to_a  #=> NoMethodError: undefined method `to_a' for "Hello":String
  a = *(1..3)   #=> [1, 2, 3]
  a = *[1,2,3]  #=> [1, 2, 3]
```

This can be a nice way to make sure that a value is always an array, especially since it will handle objects that do not implement `to_a`.

The splat is a wily beast popping up in odd corners of ruby. I rarely actually use it outside of in method definitions and method calls, but it’s interesting to know that it is available. Have you found any useful idioms that make use of the splat? I would love to hear about them.

> January 21, 2011 · 7:46 am
> http://endofline.wordpress.com/2011/01/21/the-strange-ruby-splat/
> http://twitter.com/adamsanderson
> https://github.com/rubyspec/rubyspec/blob/master/language/splat_spec.rb)
>
> Filed under development, ruby
