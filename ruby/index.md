---
title:                             Elements of Ruby
author: Stijn Heymans
date:                             17 December 2021
---

# Introduction

I will introduce you to the elements of programming in
[Ruby](https://www.ruby-lang.org). I will assume you can program in some other
language such as Java,
[Perl](http://www.stijnheymans.net/elements_of_perl.html), Python, Go, ...

Background sources that were helpful to me:

- [Why's (Poignant) Guide to Ruby](https://poignant.guide/) by _why the lucky
  stiff_. More art project than programming book, but a beginner's resource
  that gives an elemental overview of the language _with_ intuition of the Ruby
  language.  If you have read that book, you can stop reading this article.
  There's nothing here for you.

- [Eloquent Ruby](https://www.goodreads.com/book/show/9364729-eloquent-ruby) by
  Russ Olsen. A bit more advanced than _Why's (Poignant) Guide to Ruby_. The
  book ventures into meta-programming with Ruby. To see what sets Ruby apart, I
  recommend this book.

In this article, I will follow a structure that is loosely inspired by the
structure of [Introducing
Go](https://www.goodreads.com/book/show/27015358-introducing-go) by Caleb
Doxsey. Not a Ruby book, but a Go book. It's a _short_ book on Go that manages
to bring the basics across.  Something I aspire to in this article for Ruby.

# Getting Started

On the command-line, check whether Ruby is installed:

~~~shell
$ ruby --version
~~~

For me, this shows `ruby 2.6.3p62 (2019-04-16 revision 67580)
[universal.x86_64-darwin20]`). If you don't have Ruby installed, get it at [the
ruby-lang website](https://www.ruby-lang.org/en/downloads/).

If you have Ruby installed, you also have an interactive interpreter called
[irb](https://github.com/ruby/irb). On the command-line, type `irb`.

~~~none
irb> puts 'Hello World!'
Hello World!
=> nil
~~~

Leave the interactive interpreter `irb` by typing `exit`. Now say `Hello
World!` again, but without `irb`. Open a file (make it end on `rb`, for example
`ruby_playground.rb`) and write the following line in it:

~~~ruby
puts 'Hello World!'
~~~

Close the file and at the command-line have Ruby interpret it:

~~~none
$ ruby ruby_playground.rb
Hello World!
~~~

Do you want to know more about `puts`? Get in the habit of using the [official
docs](https://docs.ruby-lang.org/en/).  Pick the right version of the docs
corresponding to what you saw in your initial `ruby --version`. I picked
`2.6.0` as my Ruby version is `2.6.3` and found this
[explanation](https://docs.ruby-lang.org/en/2.6.0/ARGF.html#method-i-puts).

# The Basic Classes

## Numbers

Unsurprisingly, integers are represented as `3`, `5`, `-100`, ...
Surprisingly, everything in Ruby is an object so you can ask the class of an
integer: `5.class`. This returns
[Integer](https://docs.ruby-lang.org/en/2.6.0/Integer.html). 

Since integers are objects there's more fun stuff one can ask them: 

~~~none
irb> 123.digits
=> [3, 2, 1]
~~~

Fans of coding interviews will appreciate this. 

Simple math still works despite rumors:

~~~none
irb> 1 + 2
=> 3
irb> 2 * 3
=> 6
irb> 8 / 4
=> 2
~~~

Real but inexact numbers are of type
[Float](https://docs.ruby-lang.org/en/2.6.0/Float.html). In its literal
representation, it's _things_ that contain a decimal point:`1.0`, `9.9999`, ...

~~~none
irb> 1.0.class
=> Float
~~~

First encounters are frequently unpleasant:

~~~none
irb> 7 / 2
=> 3
~~~

Dividing 2 integers results in integer division. Force one to be a `Float`
using `to_f`:

~~~none
irb> 7.to_f / 2
=> 3.5
~~~

## Strings

String are sequences of characters surrounded by single or double
quotes: `'Hello'` or `"Hello"`. The double-quoted variety is special. More
later. Be patient.

Use `+` to concatenate 2 Strings without changing the original Strings. Use
`<<` to concatenate and destroy the String you're appending to:

~~~none
irb> a = "hello"
=> "hello"
irb> b = "world"
=> "world"
irb> a + b
=> "helloworld"
irb> a
=> "hello"
irb> b
=> "world"
irb> a << b
=> "helloworld"
irb> a
=> "helloworld"
irb> b
=> "world"
~~~

Pull characters out of a String:

~~~none
irb> a = "hello"
=> "hello"
irb> a[0]
=> "h"
irb> a[-1]
=> "o"
~~~

Get substrings by using inclusive (`..`) or exclusive (`...`) ranges:

~~~none
irb> a = "hello"
=> "hello"
irb> a[0..2]
=> "hel"
irb> a[0...2]
=> "he"
~~~

## Symbols

Symbols consist of letters, digits, or underscores, and are preceded by a `:` .
For example, `:a`, `:a_2`, `:an_orange`. Why not just use Strings? [Great
question](https://stackoverflow.com/questions/255078/whats-the-difference-between-a-string-and-a-symbol-in-ruby).

Explore how Strings are different from symbols by asking for their
`object_id`:

~~~none
irb> "bar".object_id
=> 70236502854760
irb> "bar".object_id
=> 70236502887440
irb> :foo.object_id
=> 1516508
irb> :foo.object_id
=> 1516508
~~~

From that `irb` session, note that

- every object has a method `object_id` that returns _some_ id.
- Strings that appear the same do not necessarily have the same `object_id`, which _probably_ has memory consequences
- symbols that appear the same have the same `object_id`, which _probably_ has memory consequences

## Booleans

`true` and `false` $\square$

# Variables

Like symbols, variables consist of letters, digits, or underscores. Unlike symbols,
they do not start with colons. You initialize them:

~~~none
irb> x = 'hello'
=> "hello"
irb> x = 5
=> 5
irb> x = true
=> true
~~~

I assigned and re-assigned that `x` to my heart's content with different values
_and_ different types.

You feel resistance. "But this is insane," you say. You do not like it and you
want the world to know it. You take the matter to twitter, but twitter does not
care.

Single and double quotes are different: 

~~~none
irb> x = 2
=> 2
irb> "we were #{x}"
=> "we were 2"
irb> 'we were #{x}'
=> "we were \#{x}"
~~~

[String interpolation](https://en.wikipedia.org/wiki/String_interpolation) yes.

And sometimes, variables are not variable:

~~~none
irb> X = 5
=> 5
irb> X = 6
(irb):5: warning: already initialized constant X
~~~

Capitalize a variable and it becomes _constant_. 

A word on camels and snakes when naming in Ruby. Use snake case almost
everywhere: `lowercase_words_separated_by_underscores`. Except `ClassNames` and
`ModuleNames`, go for camel case there. Later more on classes and modules.

# Control Structures

## Conditions and `if`

The basic `if`:

~~~ruby
if condition
  do_something
end
~~~

No parentheses or curly brackets for the condition. No colon after the
condition. `end` to end.

`else if` and `else`:

~~~ruby
if condition
  do_something
elsif other_condition
  do_something_else
else
  final_thing_you_can_do
end
~~~

Conditions in `if` statements are expressions that evaluate to true or false.
What expressions evaluates to true?

- all numbers (including `0`) are true
- all Strings (including `''` -- the empty String) are true
- `nil` (yep, that's a null) is false
- the boolean literal `true` is true
- the boolean literal `false` is false
- the boolean expression `a && b` is true if `a` and `b` are true
- the boolean expression `a || b` is true if `a` or `b` are true
- the boolean expression `!a` is true if a is not true

Conditions often compare things: if variable `a` is equal to `"dog"`,
then do this. Ruby has `==`, `===`, `equal?`, and `eql?`. You
will mostly use:

- `==` for checking whether values are equal as far as the class designer of the objects you're comparing is concerned. 
- `equal?` for checking object equality.

In fact, `equal?` and `==` as defined in the
[`Object`](https://ruby-doc.org/core-3.0.2/Object.html#method-i-eql-3F) class
are equal. _But how are they equal? How?_ 

Class designers can override `==` to something that makes sense for the class.
`equal?` should stand for object equality. Take the `String` class:

~~~none
irb> "a" == "a"
=> true
irb> "a".equal?("a")
=> false
~~~

So `"a"` is equal to `"a"` as values, but, as we saw before, they're not the same
objects. However, for symbols:

~~~none
irb> :a == :a
=> true
irb> :a.equal?(:a)
=> true
~~~

Back to our `if`. Instead of:

~~~ruby
if !condition
  do_something
end
~~~

write:

~~~ruby
unless condition
  do_something
end
~~~

Furthermore, if `do_something` is just one line, Ruby devs often prefer a
one-liner:

~~~ruby
do_something if condition
~~~

or

~~~ruby
do_something unless condition
~~~

Especially when returning early from functions, this makes code readable:

~~~ruby
return if invalid_parameters
~~~

## Looping

Take a look at a relatively standard loop-pattern in programming. For example, this `go` loop:

~~~go
n := 5
for i := 0; i < n; i++ {
  fmt.Println(i)
}
~~~

This prints:

~~~none
0
1
2
3
4
~~~

There's a variety of ways to write this in Ruby, but the above `for`
construct is not one of them.  Closest in spirit to the original is to
use a `while`:

~~~ruby
n = 5
i = 0
while i < n
  puts i
  i += 1
end
~~~

This is more verbose than the corresponding `for` loop in `go`.
More idiomatic Ruby uses [`times`](https://docs.ruby-lang.org/en/2.6.0/Integer.html#method-i-times):

~~~ruby
n.times { |i| puts i }
~~~

More elegant than the clunky `while`.  Deconstruct this expression:

- `n`. An `Integer`, and thus an object that has methods.

- `times`. A
  [method](https://docs.ruby-lang.org/en/2.6.0/Integer.html#method-i-times)
  that is called on the object `n` and _iterates_ the following block `{ |i|
  puts i}` from `0` to `n - 1`, passing in those values to `i` with each
  iteration. More on blocks later, but for those familiar, the block is
  essentially an anonymous function or lambda with parameter `i` (or arrow
  function for the Javascript knowledgeables). 

- `{ |i| puts i }`. We spoiled it. This is a `block` that prints `i` with `i`
  ranging over values `0` to `n - 1`. This _ranging over values_ is
  accomplished by `times`. We'll see later how we can write functions such as
  `times` ourselves in the section on Blocks. For now, you can see `times` as
  an higher-order function that takes another function as an argument.

Most of the time your looping will be in the context of some collection so I'll
talk more about looping then.

# Collections

## Arrays

An array is an [ordered integer-indexed
collection](https://docs.ruby-lang.org/en/2.6.0/Array.html) of objects.
Initialize an array:

~~~none
irb> a = ["x", 1, :y]
=> ["x", 1, :y]
~~~

Arrays are not restricted to contain only 1 type of object. You can shove in
there what you fancy: 

~~~none
irb> a = ["x", [1, 2], :y]
=> ["x", [1, 2], :y]
~~~

The usual suspects with a special mention for `-1` (the last of the elements):

~~~none
irb> a = ["x", [1, 2], :y]
=> ["x", [1, 2], :y]
irb> a.length
=> 3
irb> a[1]
=> [1, 2]
irb> a[-1]
=> :y
~~~

Add elements to the back of an array using `<<` or `push`. Both are
destructive operations:

~~~none
irb> a << :b
=> ["x", [1, 2], :y, :b]
irb> a.push(:c)
=> ["x", [1, 2], :y, :b, :c]
irb> a
=> ["x", [1, 2], :y, :b, :c]
~~~

Remove that last element with `pop`:

~~~none
irb> l = a.pop
=> :c
irb> a
=> ["x", [1, 2], :y, :b]
~~~

What about adding and removing to the _front_ of an array? Use `unshift` and
`shift`. As far as unsavory mnemonics go, remove the `f` to remember which does
what.

~~~none
irb> a
=> ["x", [1, 2], :y, :b]
irb> f = a.shift
=> "x"
irb> a
=> [[1, 2], :y, :b]
irb> a.unshift("x_new")
=> ["x_new", [1, 2], :y, :b]
~~~

`pop/push` must be more efficient than `shift/unshift`? Seems it [hardly
matters](https://stackoverflow.com/questions/8353026/what-is-the-run-time-of-shift-unshift-in-a-ruby-array).

What if you have a second array `b = [:b1, :b2]` that you want to append (i.e.,
add each element) to array `a`? `push` does not do what you want:

~~~none
irb> a = ["x", [1, 2], :y]
=> ["x", [1, 2], :y]
irb> b = [:b1, :b2]
=> [:b1, :b2]
irb> a.push(b)
=> ["x", [1, 2], :y, [:b1, :b2]]
~~~

However, using the _splat_ operator `*` will:

~~~none
irb> b = [:b1, :b2]
=> [:b1, :b2]
irb> a.push(*b)
=> ["x", [1, 2], :y, :b1, :b2]
~~~

`*b` for an array `b` in the context of a function call (`push` here) sends
each element of the array `b` as an individual argument to the function. Thus,
`a.push(*b)` is the same as `a.push(:b1, :b2)`.

I initialized arrays using their literal form (such as `a = [1, 2]`).  I can
also initialize them using the `new` method from the
[Array](https://docs.ruby-lang.org/en/2.6.0/Array.html) class:

~~~none
irb> a = Array.new
=> []
irb> a << 1
=> [1]
~~~

## Hashes

[Hashes](https://docs.ruby-lang.org/en/2.6.0/Hash.html) store key-value pairs
with unique keys (also called dictionaries, associative arrays, or
maps in other languages). Any object can be a key.

Define a hash that stores a first and last name, get a
value for an existing/non-existing key, change a value for an existing
key, add a value for a non-existing key, and remove a key/value pair:

~~~none
irb> a = { "first" => "John", "last" => "Doe" }
=> {"first"=>"John", "last"=>"Doe"}
irb> a["first"]
=> "John"
irb> a["nothere"]
=> nil
irb> a["first"] = "Jane"
=> "Jane"
irb> a
=> {"first"=>"Jane", "last"=>"Doe"}
irb> a["first"]
=> "Jane"
irb> a["nothere"] = "now it is here"
=> "now it is here"
irb> a
=> {"first"=>"Jane", "last"=>"Doe", "nothere"=>"now it is here"}
irb> a.delete("nothere")
=> "now it is here"
irb> a
=> {"first"=>"Jane", "last"=>"Doe"}
~~~

Any object can be a value in a Hash. Any object can be a key in a Hash.  In the
above example, all keys were Strings. Consider this example with symbols as
keys:

~~~none
irb> a = { :first => "John", :last => "Doe" }
=> {:first=>"John", :last=>"Doe"}
irb> a[:first]
=> "John"
~~~

The example used symbols `:first` and `:last` as keys.  If you use symbols as
keys, you can party as wild as JSON on a Friday night: 

~~~none
irb> a = { first: "John", last: "Doe" }
=> {:first=>"John", :last=>"Doe"}
~~~

I said you can use any object as a hash key. This relies on properly overriding
`hash` and `eql?` (the latter is what
[Hash](https://docs.ruby-lang.org/en/2.6.0/Hash.html) uses for testing equality
of keys. [Two objects will then refer to the same key when their `hash` value
is identical and the 2 objects `eql?` each
other](https://docs.ruby-lang.org/en/2.6.0/Hash.html#class-Hash-label-Hash+Keys).

Elemental? Probably not. Moving on.

## Looping through Arrays and Hashes

You will spend half of your life looping through arrays and hashes. Given an array:

~~~none
a = [100, 200, 300]
~~~

Print each element:

~~~none
a.each { |el| puts el }
~~~

No `for` in sight. Use `each` when you can. `each` iterates through the
elements of the array and binds each of those elements to _el_ in the block `{
|el| puts el }`, and then executes the `puts el`. If you need more than a
one-liner, do use `do...end`:

~~~ruby
a.each do |el|
  puts el
  puts el
end
~~~

Sometimes you want the index as well as the element (mostly in interviews, in
real life not so much). So similar to the trickery we saw before you could do:

~~~ruby
a.length.times { |i| puts a[i] }
~~~

However, the thought police favors `each_with_index`:

~~~none
irb> a.each_with_index { |el, i| puts "#{i}: #{el}" }
0: 100
1: 200
2: 300
~~~

Get those [Anki flashcards](https://apps.ankiweb.net/) out to memorize
the order of `|el, i|`. You did not ask for it, but here's a tip: in Ruby, it often works to
ask "how would I say this out loud?". 


::: warning
In the array `a`, for _each_ `el` at index `i`, do something.

:::
If your intuition is _for each index `i` which has element `el`_, change your
intuition.

You can loop over a hash with `each`:

~~~none
irb> a = { first: "John", last: "Doe" }
=> {:first=>"John", :last=>"Doe"}
irb> a.each { |key, value|  puts "#{key} -> #{value}" }
first -> John
last -> Doe
~~~

Sometimes you only want to loop through the keys or values of a hash. You can
use `keys` and `values`:

~~~none
irb> a.keys
=> [:first, :last]
irb> a.values
=> ["John", "Doe"]
~~~

In contrast to hashes in other languages (e.g. `HashMap` in Java), you _can_
assume an order on key-value pairs. They will be in the order they were
inserted:

~~~none
irb> a = {}
=> {}
irb> a["first"] = 1
=> 1
irb> a["second"] = 2
=> 2
irb> a.each { |key, value|  puts "#{key} -> #{value}" }
first -> 1
second -> 2
~~~

Sometimes you can benefit from going one abstraction higher than pure looping,
and use a [`map`](https://docs.ruby-lang.org/en/2.6.0/Array.html#method-i-map):

~~~none
irb> a = [1, 2, 3]
=> [1, 2, 3]
irb> b = a.map { |x| x * 2 }
=> [2, 4, 6]
irb> a
=> [1, 2, 3]
~~~

If you do not want a new array, you can use the [destructive variant
`map!`](https://docs.ruby-lang.org/en/2.6.0/Array.html#method-i-map-21):

~~~none
irb> a.map! { |x| x * 2 }
=> [2, 4, 6]
irb> a
=> [2, 4, 6]
~~~

The convention in Ruby is to append `!` to function names if those functions
are destructive. The exclamation mark is a regular part of the function name.

We can also map hashes. For example, collect all keys of a map, but uppercased:

~~~none
irb> a = { first: "John", last: "Doe" }
=> {:first=>"John", :last=>"Doe"}
irb> a.map { |key, value| key.upcase }
=> [:FIRST, :LAST]
~~~

What if you want to map a `Hash` to a `Hash`, and you want to keep the keys but
uppercase the values?

~~~none
irb> a.map { |key, value| [key, value.upcase] }.to_h
=> {:first=>"JOHN", :last=>"DOE"}
~~~

The `map` returns an array of `[key, value.upcase]` arrays. So I use `to_h` to
convert that array to a hash.  Generally:

~~~none
irb> [[1, 2], [3, 4]].to_h
=> {1=>2, 3=>4}
~~~

This is no longer elemental.

# Functions

Functions (or _methods_, when appearing in classes) have this
shape:

~~~ruby
def function_name(arg1, arg2,...)
  # do stuff
end
~~~

Functions start with `def` and end with `end`. A function that doubles every
element in an array `a`:

~~~ruby
def double_all(a)
  a.map { |x| x * 2 }
end
~~~

"Oh no," you say. "They forgot to type the arguments." Yes. That `a` can be
anything as long as it understands `map`. 

Call `double_all`:

~~~none
irb> a = [1, 2, 3]
irb> puts double_all(a)
2
4
6
~~~

If you miss types, or you work in a large code base with many developers and
you prefer sanity over insanity, check out [sorbet](https://sorbet.org/).
Sorbet allows you to annotate functions with type information. For example, add
a signature to `double_all` with the sorbet `sig` annotation:

~~~ruby
sig { params(a: T::Array[Integer]).returns(T::Array[Integer]) }
def double_all(a)
  a.map { |x| x * 2 }
end
~~~

This indicates that `double_all` takes in an array of integers `a` and returns
an array of integers.

You can have defaults for your arguments:

~~~ruby
def double_all(a = [1, 2])
  a.map { |x| x * 2 }
end
~~~

After which, you can leave off the argument to `double_all`:

~~~none
irb> puts double_all
2
4
~~~

A function with a `Hash` as an argument:

~~~ruby
def hash_keys(h)
  puts "a: #{h[:a]}"
  puts "b: #{h[:b]}"
end
~~~

And then:

~~~none
irb> puts hash_keys({ a: 1, b: 2 })
a: 1
b: 2
~~~

If a `Hash` is the last argument of the function call, you can leave off the
curly braces:

~~~none
irb> puts hash_keys(a: 1, b: 2)
a: 1
b: 2
~~~

That reminds of _keyword arguments_. Indeed,  you can now change the
calling order:

~~~none
irb> puts hash_keys(b: 2, a: 1)
a: 1
b: 2
~~~

# Classes and Methods

## Defining classes

Define a minimal class with the `class` keyword, a name, and `end`:

~~~ruby
class A

end
~~~

This introduces `A` into the world.  Here's how to create a new `A` object `a`,
how to ask its `object_id`, how to get its String representation with `to_s`,
and how to get its class:

~~~none
irb> a = A.new
=> #<A:0x00007f913a9bb5e0>
irb> a.to_s
=> "#<A:0x00007f913a9bb5e0>"
irb> a.object_id
=> 70130865134320
irb> a.class
=> A
~~~

Not bad for a minute of work. You wonder why our minimal `A` object can do all
of this.  Poke at the class hierarchy:

~~~none
irb> a.class.ancestors
=> [A, Object, Kernel, BasicObject]
~~~

So `a` is an `A`, which is an `Object`, which is a `Kernel`, which is a
`BasicObject`.  We're tapping into _inherited_ methods:

~~~none
irb> o = Object.new
=> #<Object:0x00007f913a82f898>
irb> o.to_s
=> "#<Object:0x00007f913a82f898>"
irb> o.object_id
=> 70130864323660
irb> o.class
=> Object
irb> o.class.ancestors
=> [Object, Kernel, BasicObject]
~~~

You may have expected to see the definition of a _constructor_ when you saw
`A.new` used to create a new object.  For a minimal class like `A` we use the
`initialize` of `Object`. If you want to use your own _constructor_ you can
need to define your own `initialize`:

~~~ruby
class A

  def initialize
    puts "you called new!"
  end

end
~~~

Creating a new `A`:

~~~none
irb> a = A.new
you called new!
=> #<A:0x00007fc4eb1b8bd8>
~~~

The class `A` is useless. Usually classes carry some _state_ (cars have doors
and color, some cars have 4 doors, some 5, some cars are blue, some cars are
yellow). _Instance variables_ capture that state.

In Ruby, instance variables start with an `@`. Give `A` state:

~~~ruby
class A

  def initialize
    @a = 10
  end

  def print_your_state
    puts "my state is #{@a}"
  end

end
~~~

Note:

- I've set the value of `@a` in the `initialize`. When you create a new `A`
  object, the `@a = 10` line gets executed.

- I've introduced an _instance method_ `print_your_state`. If you have an `A`
  object `x` you can do `x.print_your_state`. This executes the `puts` line for
  your object `x`.

~~~none
irb> x = A.new
=> #<A:0x00007fc4ea1190c0 @a=10>
irb> x.print_your_state
my state is 10
~~~

Every object has `@a` equal to 10. Useless as far as state goes for objects.
You want to create objects with different states. Give `initialize` arguments
that indicate the initial state you want for the object:

~~~ruby
class A

  def initialize(a)
    @a = a
  end

  def print_your_state
    puts "my state is #{@a}"
  end

end
~~~

~~~none
irb> x = A.new(10)
=> #<A:0x00007fc4eb1c1f80 @a=10>
irb> y = A.new(11)
=> #<A:0x00007fc4e9832c40 @a=11>
irb> x.print_your_state
my state is 10
irb(main):014:0> y.print_your_state
my state is 11
~~~

You can also give instance methods arguments:

~~~ruby
class A

  def initialize(a)
    @a = a
  end

  def print_your_state_with_a_factor(x)
    result = @a * x
    puts "my state is #{result}"
  end
~~~

And then:

~~~none
irb> x = A.new(10)
=> #<A:0x00007fc4eb145778 @a=10>
irb> x.print_your_state_with_a_factor(3)
my state is 30
~~~

Note that `result` is a _local_ variable to the instance method
`print_your_state_with_a_factor`.

## Getters and Setters and Bouviers

Instance variables are _encapsulated_. You cannot get to their value from
outside the class:

~~~none
irb> x = A.new(3)
=> #<A:0x00007fc8cc180280 @a=3>
irb> x.a
Traceback (most recent call last):
        4: from /usr/bin/irb:23:in `<main>'
        3: from /usr/bin/irb:23:in `load'
        2: from /Library/Ruby/Gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):4
NoMethodError (undefined method `a' for #<A:0x00007fc8cc180280 @a=3>)
~~~

Ruby's instance variables are thus by default like private instance variables
in Java. If you want direct access to the instance variable, you need a getter:

~~~ruby
class A

  def initialize(a)
    @a = a
  end

  def a
    @a
  end
end
~~~

And then:

~~~none
irb> x = A.new(3)
=> #<A:0x00007f913a943c70 @a=3>
irb> x.a
=> 3
~~~

You can still not write to `@a` from outside the class as that requires a _setter_:

~~~none
irb> x.a = 5
Traceback (most recent call last):
        4: from /usr/bin/irb:23:in `<main>'
        3: from /usr/bin/irb:23:in `load'
        2: from /Library/Ruby/Gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        1: from (irb):20
NoMethodError (undefined method `a=' for #<A:0x00007f913a943c70 @a=3>)
Did you mean?  a
~~~

Write a setter:

~~~ruby
class A

  def initialize(a)
    @a = a
  end

  def a
    @a
  end

  def a=(a)
    @a = a
  end
end
~~~

and then:

~~~none
irb> x = A.new(3)
=> #<A:0x00007fb09b838558 @a=3>
irb> x.a
=> 3
irb> x.a = 5
=> 5
irb> x.a
=> 5
~~~

I'll pause, so you can enjoy the view.

~~~ruby
def a=(a)
  @a = a
end
~~~

That `a=` is an [assignment
method](https://docs.ruby-lang.org/en/2.6.0/doc/syntax/assignment_rdoc.html#label-Assignment+Methods).
This is an ordeal. As fortune has it, there is shorthand for getting and
setting a getter and setter:

~~~ruby
class A
  attr_accessor :a

  def initialize(a)
    @a = a
  end
end
~~~

Yes, you write `:a` there. 

~~~none
irb> x = A.new(3)
=> #<A:0x00007fc5ab109988 @a=3>
irb> x.a
=> 3
irb> x.a = 6
=> 6
~~~

If you only want the getter, you can use `attr_reader`. If you only want a
setter, you probably also put pineapple on your pizza. Anyhow, you can use
`attr_writer`.

## Equality

What is `x == y` in the below?

~~~none
irb> x = A.new(3)
=> #<A:0x00007fa3d6194778 @a=3>
irb> y = A.new(3)
=> #<A:0x00007fa3d58ed458 @a=3>
irb> x == y
~~~

False. `x` and `y` are different objects and `==` is `Object` equality.
Sometimes you want `x` and `y` to be equal as they represent the same data,
they are both `A` objects with the same state `3`. For example, it makes sense
to most that `"I am right" == "I am right"` is `true`.

You can override `==` in `A` to get equality based on state, rather than on
object identity:

~~~ruby
class A
  attr_accessor :a

  def initialize(a)
    @a = a
  end

  def ==(other)
    self.a == other.a
  end
end
~~~

And then:

~~~none
irb> x = A.new(3)
=> #<A:0x00007fb47c1805a0 @a=3>
irb> y = A.new(3)
=> #<A:0x00007fb47c189268 @a=3>
irb> x == y
=> true
~~~

Observe:

- `==` is an instance method defined as any other method:  `x == y` is really
  just `x.==(y)` as if `==` is any other method name.

- I used `self` which is similar to Java's `this` at least in _this_
  [context](https://airbrake.io/blog/ruby/self-ruby-overview). Here it's an
  instance of this object itself. So when doing `x == y`, we execute `==` for
  the object `x`, and `self` refers to `x`. Caveat emptor: `self` may mean
  other things. We will see how to use `self` to define _class methods_. 

- I did not actually have to use `self` here. There is no ambiguity if I would
  do `a == other.a`. The first `a` refers to the method `a` defined in `A` (by
  way of the `attr_accessor`) and allows me to check equality of the instance
  variable `@a` with `other.a` (aka the `@a` of the `other` object). You are
  right: I can do `@a == other.a`
  [directly](https://www.merriam-webster.com/dictionary/pedantic). 

## Class Methods and Variables

If you know `Java`, you must have met `static`. _static variables or methods_
in Java classes indicate that they belong to the class rather than the
instance.

In Ruby _class variables_ start with `@@` (recall that instance variables start
with `@`). _Class methods_ have their name preceded with `self`. The body is
not yet cold and here we are: `self` in this context refers to the class rather
than the object. An example: 

~~~ruby
class A
  @@counter = 0

  def initialize
    @@counter += 1
  end

  def self.counter
    @@counter
  end

end
~~~

And then:

~~~none
irb> x = A.new
=> #<A:0x00007fc82595ce60>
irb> A.counter
=> 1
irb> y = A.new
=> #<A:0x00007fc8259642a0>
irb> A.counter
=> 2
~~~

Note that I asked `A` for the `counter` (not `x`, nor `y`). In fact, doing
`x.counter` leads to an `undefined method` error.

## Inheritance

Make `B` a subclass of `A`:

~~~ruby
class A
  attr_accessor :a

  def initialize(a)
    @a = a
  end

  def double
    2 * @a
  end
end

class B < A
  def triple
    3 * @a
  end
end
~~~

Poke around:

~~~none
irb> x = A.new(3)
=> #<A:0x00007fa19e02dd10 @a=3>
irb> x.double
=> 6
irb> y = B.new
Traceback (most recent call last):
        6: from /usr/bin/irb:23:in `<main>'
        5: from /usr/bin/irb:23:in `load'
        4: from /Library/Ruby/Gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        3: from (irb):13
        2: from (irb):13:in `new'
        1: from /Users/sheymans/Workspaces/ruby_playground/src/ruby_playground.rb:7:in `initialize'
ArgumentError (wrong number of arguments (given 0, expected 1))
irb> y = B.new(5)
=> #<B:0x00007fa19f2184a8 @a=5>
irb> y.double
=> 10
irb> y.triple
=> 15
~~~

If you're familiar with inheritance, this looks encouraging. Observe:

- I did not define an `initialize` for `B` so we're forced to use the one of
  `A` which requires 1 argument `a`

- I accessed the instance variable `@a` in `B. This sometimes leads to
  surprises, but I hope you have a good [IDE](https://www.jetbrains.com/idea/)

# Modules

To define a module, start with keyword `module`, give it a name, do your thing,
and end with `end`:

~~~ruby
module HomeMade
  class A
    attr_accessor :a

    def initialize(a)
      @a = a
    end

    def double
      2 * @a
    end
  end

end
~~~

Prepend `HomeMade::` to your class name `A` if you want an instance of the `A`
in the `HomeMade` module:

~~~none
irb> a = HomeMade::A.new(3)
=> #<HomeMade::A:0x00007fdf07147448 @a=3>
irb> a.double
=> 6
~~~

## As Namespaces

Why modules? Because your neighbor also wants a class with name `A`.  Modules
are name islands of peace and quiet:

~~~ruby
module HomeMade
  class A
    attr_accessor :a

    def initialize(a)
      @a = a
    end

    def double
      2 * @a
    end
  end
end

module NeighborMade
  class A
    # Same name A, yet worse
  end
end
~~~

You can then pick your `A` without conflict:

~~~none
irb> a = HomeMade::A.new(3)
=> #<HomeMade::A:0x00007f95eb03f0b0 @a=3>
irb> b = NeighborMade::A.new
=> #<NeighborMade::A:0x00007f95ef0ef998>
~~~

Modules organize code within your application.

## As Mixins

Imagine (imagine!) you have 2 modules, 1 for logging and 1 for 
long-term analytics:

~~~ruby
module Logger
  def log_it(what)
    puts what
  end
end

module Analytics
  def send_event(event)
    puts event
  end
end
~~~

Imagine (imagine!) you have a class `A` that wants to use the methods from the
`Logger` and `Analytics` modules:

~~~ruby
class A

  def do_something
    log_it("we're logging this")
    send_event('for long term analytics we send this')
  end

end
~~~

If you try `a.do_something` for an object `a` of type `A`, you get a
`NoMethodError` for `log_it` and `send_event`. You are smart (your
grandmother told you so), and you say, "let `A` inherit from `Logger`."  Yes,
more of that smartness. What a joy.  And "also let `A` inherit from
`Analytics`." Wonderful.

Ruby does not allow for multiple inheritance. You can only inherit from 1 class
(ignoring for a minute that `Logger` and `Analytics` are not actually classes,
they are modules).

We (I say _We_ but I really mean _I_; you have turned out to be a bit of a
disappointment in these last 2 paragraphs; you also thought the semi-colon
is dead; it's not) can solve this by _mixing in_ the 2 modules in the class `A`
by using `include`:

~~~ruby
class A
  include Logger
  include Analytics

  def do_something
    log_it("we're logging this")
    send_event('for long term analytics we send this')
  end
end
~~~

`include` makes all methods of the modules available as _instance_ methods in
your class. Those familiar with the Java world, and maybe other worlds as well,
are reminded of the Utility class. You long for a better life.

# Testing

Define a class `A` in some file `ruby_playground.rb`:

~~~ruby
class A
  def initialize(a)
    @a = a
  end

  def double
    @a * 2
  end
end
~~~

How to unit test `double`? Create a file `test_ruby_playground.rb`:

~~~ruby
require 'test/unit'
require './ruby_playground'

class RubyPlayGroundTest < Test::Unit::TestCase
  def test_double
    a = A.new(3)
    assert_equal 6, a.double
  end

end
~~~

Note:

- `require` the `test/unit` Ruby [gem](https://en.wikipedia.org/wiki/RubyGems) which defines the class [`Test::Unit::TestCase`](https://www.rubydoc.info/github/test-unit/test-unit/Test/Unit/TestCase)
- `require` the file that contains the class `A` 
- create a new class `RubyPlayGroundTest` that inherits from `Test::Unit::TestCase`
- write a method that starts with `test_` and use `assert_equal` to test whether `6` is the result of `a.double`

Running that test file should result in success with statistics:

~~~none
$ ruby test_ruby_playground.rb
Loaded suite test_ruby_playground
Started
.
Finished in 0.000298 seconds.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1 tests, 1 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
100% passed
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
3355.70 tests/s, 3355.70 assertions/s
~~~

Change `double` to do `@a * 4`. Run the test again. It fails.

# Blocks

You already saw _blocks_:

~~~none
irb> a = [1, 2, 3]
=> [1, 2, 3]
irb> a.map { |el| el * 2 }
=> [2, 4, 6]
~~~

The part `{|el| el * 2 }` is a _block_. It has _parameters_ 
`|el|` and a _body_ `el * 2`. For multi-line blocks,
use the `do...end` form.

~~~ruby
a.map do |el|
 double = el * 2
 double + 1
end
~~~

In this example, `map` has as its argument another function (the block) and is
thus a _higher-order function_.  How do you define your own higher-order
functions? Define a function that prints "here we are now", calls _some_
function, and prints "entertain us".  For example, take a function `lost`:

~~~ruby
def lost
  puts 'a lost generation'
end
~~~

Print your two lines "here we are now" and "entertain us" around a call to
`lost`: 

~~~ruby
puts 'here we are now'
lost
puts 'entertain us'
~~~

If you want to do the same to another function than `lost` you have to
repeat that pattern. Instead, define a higher-function:

~~~ruby
def smells_like
  puts 'here we are now'
  yield
  puts 'entertain us'
end
~~~

Note the `yield` keyword. That keyword tells the function `smells_like` _and now
execute the block that was given to your call my friend_. So if we do
`smells_like { lost }`, you see:

~~~none
here we are now
a lost generation
entertain us
~~~

You could also just do `smells_like { puts 'a broken generation' }` and see:

~~~none
here we are now
a broken generation
entertain us
~~~

What about blocks with parameters? For example, what if I want to be able to do
`smells_like('broken') { |x| puts "a #{x} generation" }`? `yield` can take
arguments, and `yield`'s arguments get shuttled into the block's parameters:

~~~ruby
def smells_like(something)
  puts 'here we are now'
  yield(something)
  puts 'entertain us'
end
~~~

And then:

~~~none
irb> smells_like('lost') { |x| puts "a #{x} generation" }
here we are now
a lost generation
entertain us
irb> smells_like('broken') { |x| puts "a #{x} generation" }
here we are now
a broken generation
entertain us
~~~

Good times.


