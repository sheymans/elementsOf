---
title:                             Elements of Perl
author: Stijn Heymans
date:                             12 October 2019
---
                            last updated: 3 March 2021

# Introduction

This article introduces the elements of `perl 5.x`. I'll start with introducing
what `perl` considers the smallest unit of things in the Scalars section. I'll
then show how to use those scalars in list-type data structures in the Array Variables section
as well as in map-like data structures in the Hash Variables
section. I'll tie the concepts of scalars, arrays, and hashes together to be
able construct arbitrary data structures in the References section.

After introducing the basic data structures, I'll show how to
control flow in the Conditions section, and how to use such conditions when
looping in the Looping section.
Once I tackled basic data structures and control flow, I'll show how to
encapsulate logic into functions in the Subroutines section.

We end the article with what `perl` got (in)famous for, regular expressions, in the
Matching and Substituting section, as well as 2 more practical sections: a
Constants section explaining how to define constants and a Printing Anything
section that will be useful when you're debugging.

As this is the _elements_ of `perl`, I made choices on what to leave out of this
article (for example, I did not introduce objects). You can read more in those
3 books:

- [Learning Perl: Making Easy Things Easy and Hard Things Possible](https://www.goodreads.com/book/show/30413201-learning-perl) by Randal L. Schwartz, Brian D. Foy, Tom Phoenix,
- [Intermediate Perl](https://www.goodreads.com/book/show/209276.Intermediate_Perl) by Randal L. Schwartz, Brian D. Foy, Tom Phoenix,
- [Perl Best Practices: Standards and Styles for Developing Maintainable Code](https://www.goodreads.com/book/show/86379.Perl_Best_Practices) by Damian Conway.

Reading the first 2 books in order and front-to-back works well to build
deep knowledge, where the last one, _Perl Best Practices_, can be sampled from.

# Scalars

## Strings

### Basics

_Scalars_ or _scalar values_ are the smallest unit of data in perl, for
example, numbers and strings.  We store scalars in _scalar variables_. This is
how you can store a string `'I am a string'` in a scalar variable `$var`:

~~~perl
my $var = 'I am a string';
~~~


::: warning
note
_statements_ in perl end with `;` as they do in Java or C++

:::
The `my` keyword _declares_ the variable `$var` (similar to a `let` in
Javascript) and `$var` consists of the symbol `$` and the name `var`. The
symbol `$` hints that the variable is used or accessed as a scalar. In this
case, it declares and initializes a string, which is indeed a scalar.

You'll later see a symbol `@` for array usage and `%` for hash usage (a `hash`
is Python's `dict` or generally a key-value structure such as a `Map` in Java).

A common operation is concatenating 2 strings which you do using the dot-operator `.` :

~~~perl
my $concat = $var . ' and me too.';
~~~

If you want to change `$var` by concatenating something to it, instead of

~~~perl
$var = $var . ' and me too.';
~~~

you can do:

~~~perl
$var .= ' and me too.';
~~~

So far I used single quotes for strings. What about double quotes? You can
use double quotes as well. Good practice is to use double quotes only when you
want to _interpolate_ variables appearing in such strings. For example:

~~~perl
my $name = 'stijn';
my $hello = "my name is $name";
~~~

Interpolation makes sure that `$name` in that `$hello` string is always
_expanded_ to its value. In this case, the string will be `my name is stijn`.
Interpolation will usually lead to cleaner code than concatenation. Compare the above to:

~~~perl
my $name = 'stijn';
my $hello_conc = 'my name is ' . $name;
~~~

### Built-in Functions

#### [`print`](https://perldoc.perl.org/functions/print.html)

Printing to standard output is useful for debugging the odd statement:

~~~perl
print "This is a printed string\n";
~~~


::: warning
There's an explicit `\n` in that statement; you might be used to a `println`
from other languages that puts that `\n` there for you.

:::
#### [`substr`](https://perldoc.perl.org/functions/substr.html)

Extract a substring out of a string. For example, to get `cat` out of the string `concatenate`:

~~~perl
my $cat = substr('concatenate', 3, 3);
~~~

The first `3` is the offset from where to start the substring, the second `3`
is the length of the substring you want (_cat_ has 3 letters). You'll see this
pattern occur frequently: an _offset_ followed by a _length_, in the arguments
of a function.

If you leave off the length, you can take the substring from the offset until the end of
the string. For example to get `catenate` out `concatenate`:

~~~perl
my $nonsense_substring = substr('concatenate', 3);
~~~

#### [`split`](https://perldoc.perl.org/functions/split.html)

`split` splits a string into parts based on a regular expression
`/REGEXP/`. You'll often spot this form in the
wild:

~~~perl
split //, 'yeah';
~~~

This will split the string `yeah` into a list of its individual characters because the
pattern `//` matches _everything_.
I will introduce lists/arrays as well as regular expressions later.



::: warning
Note that `split //, 'yeah'` has no parentheses. Based on
how I wrote `substr` you expected to see `split(//,'yeah')` and you'd been
right as well! `perl` is playing loose with parentheses, so for
built-in functions you'll often see parentheses dropped. For functions you
write yourself, I suggest to keep parentheses when invoking them. Life is
complicated enough as it is.


:::
## Numbers

### Basics

Let's dive into numbers:

~~~perl
my $numero = 42;
~~~

We can add numbers:

~~~perl
my $sum = $numero + 42;
~~~

which is of course the same as:

~~~perl
my $doubling = 2 * $numero;
~~~

Similar like in other languages, there is a shorthand for `$numero = $numero + 42`:

~~~perl
$numero += 42;
~~~

and for the other operations _la même chose_.

### Built-in Functions

This is where I am not going to write about _how to take the square
root_ using the built-in `sqrt` as you will never need it.

You can `print` numbers and a good conversion (the `%d` in the below template string) is...`%d`:

~~~perl
print "The meaning of life is %d", 42;
~~~

## `undef`

I talked about scalars like strings and numbers. But what about the `null` we
have come to hate from other languages? In `perl`, we have `undef`. And where
you'll see in other languages a lot of null-checks, in `perl` you'll see a lot
of:

~~~perl
if (defined $x) {
  # stuff
}
~~~

which checks whether `$x` is defined (so is `$x` `undef` or not).

What's with the

~~~perl
# stuff
~~~

A `#` marks comments. Anything following it is ignored by the `perl` compiler.

# Array Variables

## Basics

You can use array variables to store ordered lists of _things_.  This is how
you create an array with elements `here`, `I`, `am`:

~~~perl
my @array = ('here', 'I', 'am');
~~~

Note the `@` symbol prefixing the variable name. In contrast to other languages
like Python or Javascript, `perl` gives you a hint on what kind of variable
something is. We already saw _scalar_ variables in which you can store the
smallest unit of _things_ (for example, numbers or strings). The `@` signifies
this is an _array_ variable and stores a _list of such small-unit-things_. As a
consequence, if a list contains a variable, that variable will be a _scalar
variable_.

Try to get the first element of the array `@array`:

~~~perl
my $first_element = $array[0];
~~~

The `[0]` part should look familiar, but note that it is `$array` when you use
`@array` to _access_ the scalar value at the first position (index `0`). Or
differently put, while `@array` is an array, `$array[0]` is a scalar and hence
I use `$` rather than `@`.

The last element is usually easily retrieved using the `-1` index (similar to
how we access the last character in a string):

~~~perl
my $last_element = $array[-1];
~~~

Changing the first element of an `@array` can be done as follows:

~~~perl
$array[0] = 'You';
~~~

I can copy an existing array `@array` to a new array `@copy`:

~~~perl
my @copy = @array;
~~~

Note that here I use `@` for both sides of the assignment: I'm creating an
array `@copy` and copying the array `@array` (I am not referring to the
individual elements in `@array`: the array is used in a _list_ context).


::: warning
`@copy` is indeed a copy: changing elements in `@copy` will _not_ change
elements in `@array`.

:::
## Built-in Functions

### Adding and Removing from Back of an Array

You can remove elements from the back of an array, using
[`pop`](https://perldoc.perl.org/functions/pop.html):

~~~perl
my @array = (4, 5);
my $last = pop @array;
~~~

Note that I did not write `pop(@array)` as `pop` is a built-in. We leave
parentheses off of built-ins per convention. What will `$last` store? It will
store the last element of `@array`: `5`. What will `@array` store after the
`pop`ping? An array with the last element removed: `(4)`.

You can add it back by adding it to the end of array using [`push`](https://perldoc.perl.org/functions/pop.html):

~~~perl
push @array, 5;
~~~

Then, `@array` will be `(4, 5)` again. You can also use `push` to append a list:

~~~perl
push @array, (4, 5);
~~~

### Adding and Removing from Front of an Array

Sometimes you'd want to add something to the front of an array, and we use the
unmemorable [`unshift`](https://perldoc.perl.org/functions/unshift.html)
for that:

~~~perl
unshift @array, 4;
~~~

This adds `4` to the front of `@array`. You can also pre-pend lists like that:

~~~perl
unshift @array, (4, 5)
~~~

This turns an `@array` that is `(6, 7)` into `(4, 5, 6, 7)`. Note that the order is
preserved (so it does not loop through `(4, 5)` and adds the elements one by
one).

Similar to how `pop` removes from the back of the list, we have a function to remove something from the start of the list:

~~~perl
my $first = shift @array;
~~~

`@array` will be modified after this: the first element is removed and in this
case I stored it in `$first`. You can imagine
[`shift`](https://perldoc.perl.org/functions/shift.html) as shifting the array
to the _left_ and thus dropping the first element.

### Length of an Array with a detour to contexts

The notion of _context_ is important in `perl`. For example, assigning an array
to a scalar variable, will cause the _length_ of that array to be assigned to
the scalar. Indeed, you cannot store an array into a scalar, so what do you
store?  Well, a reasonable thing to store is the length of that array. So for
this:

~~~perl
my @array = ('hey', 'you');
my $scalar_something = @array;
~~~

we have that `$scalar_something` now contains `2`: the length of `@array`.

This also works the other way: what if you want to store a scalar into a list?
For example:

~~~perl
my $scalar = 'a';
my @array = $scalar;
~~~

You're now trying to store a scalar variable `$scalar` into an array variable,
or in other words, into a _list context_. `perl` will try to make a list out of
the scalar, and the natural way to do so is by treating your scalar as a list
with 1 element in it. So `@array` will effectively be the list `('a')`.

### [`reverse`](https://perldoc.perl.org/functions/reverse.html)

We can reverse arrays as follows:

~~~perl
my @array = (1, 2);
my @rev = reverse @array;
~~~

`@rev` will be `(2, 1)` and `@array` will have stayed the same.


::: warning
`reverse` is non-destructive on its argument. Contrast that with
`pop`/`push` and `shift/unshift`, all of which are destructive on the lists
they operate on.

:::
# Hash Variables

## Basics

Most programming languages have support for some key/value data structure (a
`Map in Java`, a `dict` in Python).  `perl` calls its key/value data structure
a _hash_. A hash _literal_ can be initialized as follows:

~~~perl
my %some_hash = ('name', 'john', 'age', 39);
~~~


::: warning
Tip
I used a new symbol `%` to indicate that `some_hash` is a variable used to store a hash.

:::
I did not make a syntactical distinction between keys and values when writing
`('name', 'john', 'age', 39)`. You expect `'name'` and `'age'` to be keys, and
`'john'` and `39` to be values, but there is no apparent syntactical distinction
with a literal _list_ in this example. So why is this defining a hash and not a list?

Let's get back to our _contexts_. We already saw a _list context_ and a _scalar
context_. The `%` on the left-hand side of the assignment, indicates a _hash
context_ and whereas the right-hand side is indeed a list, we are trying to
assign the list to a hash such that effectively we indeed store a hash (i.e,
something we can access based on keys `'name'` and `'age'` as we will see in a
bit).

The keys `'name'` and `'age'` are strings while the values are strings or
numbers (`39`). Indeed, the keys of a hash are always strings. The values are
less strict and can be any _scalar_. As such we cannot nest hashes by embedding
another hash as a value within a hash. At least not without a concept called
_references_ which I'll introduce later. For now, remember that values of a
hash are always scalars.

As the list syntax for hashes can be confusing, `perl` has a trick: it treats
the _fat comma_ `=>` exactly the same as a comma `,`, and thus we can replace
certain commas by so-called fat commas to introduce syntactical clarity around
what is a key and what is a value:

~~~perl
my %some_hash = ('name' => 'john', 'age' => 39);
~~~

When using the fat arrow notation, you can also leave off the quotes on the keys:

~~~perl
my %some_hash = (name => 'john', age => 39);
~~~

We can access values of a hash, using curly braces (`{` `}`):

~~~perl
my $name = $some_hash{name};
my $age = $some_hash{age};
~~~

Note that I did not write `'name'` nor `'age'` (with single quotes around them): indeed once `%some_hash` is
established as a hash, you can access values by using the keys without quotes
whether you initialized with quoted keys or not. However, you _could_ have written:

~~~perl
my $name = $some_hash{'name'};
my $age = $some_hash{'age'};
~~~

We also used the scalar `$` symbol instead of the hash symbol
`%` when _accessing_ the hash. In effect, we're accessing a scalar so we use
`$`. Or differently, `$some_hash{name}` _is_ a scalar (always, by the rule
that values in hashes have to be scalars) rather than a _hash_, so it makes
sense to refer to it with `$`.

Changing the value for a key can be done without surprises:

~~~perl
$some_hash{name} = 'bill';
$some_hash{age} = 40;
~~~

## Built-in Functions

### `values`/`keys`

As is usual with map-like structures in programming languages, you can get the
keys `age` and `name` from the hash:

~~~perl
my @keys = keys %some_hash;
~~~

Indeed, `@keys` will be the array `('age', 'name')`. Similarly, you can get the
values `39` and `john` from the hash:

~~~perl
my @values = values %some_hash;
~~~

Indeed, `@values` will be the array `(39, 'john')`. Note that even though I
defined `%some_hash` using the literal `('name', 'john', 'age', '39')` which
hints at some _ordering_, neither `values` nor `keys` need to satisfy that
original order.

# References

_References_ are the concept that makes nested structures possible. Recall that
arrays can store lists of scalars and hashes are key-value maps where the key
needs to be a string and the value needs to be a scalar.

At first sight this restricts us to flat data structures. For example, I
could not directly store a list of hashes. Or a hash that is an index of names
(the key) to addresses (the value, consisting of street, zip code)).

No-one wants to be restricted, the least of all to flat data structures. Enter:
the _reference_. The reference is like C/C++ style pointers. It
is a _scalar_ that _points_ to other _things_. Those other other things could
be other lists, other hashes, other scalars, or other references.

Say we have a reference `$a_ref` (note that references are
scalars, hence the `$`) that points to an array `(1, 2, 3)`:

***********************************
*                                 *
*   .--------.       .---------.  *
*   | $a_ref +----->| (1, 2, 3) | *
*   '--------'       '---------'  *
***********************************

Since `$a_ref` is a scalar, we can have a hash with values that are pointing to arrays:

~~~perl
my %array_value_hash = (john => $a_ref);
~~~

We skipped a crucial piece though. How did I create that `$a_ref`
reference to the array `(1, 2, 3)`? Recall that we can create an array
variable as follows:

~~~perl
my @array = (1, 2, 3);
~~~

I can now take a reference to `@array` using the backslash \:

~~~perl
my $a_ref = \@array;
~~~

There's a shorthand for taking a reference to an array _literal_:

~~~perl
my $a_ref = [1, 2, 3];
~~~

where I use square brackets `[ ]` instead of `( )`. Effectively, this:

~~~perl
my @array = (1, 2, 3);
my $a_ref = \@array;
~~~

is the same as:

~~~perl
my $a_ref = [1, 2, 3];
~~~

How could I get values out of that array using the reference `$a_ref`
rather than using `@array` directly? Recall that you could get the first
element (or change the first element) of `@array` with `$array[0]`. We can
get to the underlying array based on the `$a_ref` reference, by
_de-referencing_ it using curly braces `{$a_ref}`. Getting
the first element based on `$a_ref` can then be done by:

~~~perl
my $first = ${$a_ref}[0];
~~~

A similar dereferencing rule holds in situations where you'd normally deal with the array itself like when copying:

~~~perl
my @copy = @array;
~~~

To make a copy based on the `$a_ref`, you could do:

~~~perl
my @copy = @{$a_ref};
~~~

You can see that I just switched out the `array` part in `@array` by the
dereferenced reference: `{$a_ref}`.

I can copy array references:

~~~perl
my $copy_ref = $a_ref;
~~~

***********************************
*                                 *
*   .--------.       .---------.  *
*   | $a_ref +----->| (1, 2, 3) | *
*   '--------'       '---------'  *
*                         ^       *
*   .-----------.         |       *
*   | $copy_ref +--------'        *
*   '-----------'                 *
*                                 *
***********************************

If I then change `$copy_ref` I change the underlying array:

~~~perl
${$copy_ref}[0] = 500;
~~~

Indeed both `${$a_ref}[0]` and `${$copy_ref}[0]` are now equal to `500`:

************************************
*                                  *
*   .--------.       .-----------. *
*   | $a_ref +----->| (500, 2, 3) |*
*   '--------'       '-----------' *
*                           ^      *
*   .-----------.           |      *
*   | $copy_ref +----------'       *
*   '-----------'                  *
*                                  *
************************************

To always type `${$a_ref}` is not very succinct. These are all the same:

~~~perl
${$a_ref}[0]; # what we saw before
$$a_ref[0];   # 2 consecutive `$` so leave of braces (we'll not use this notation)
$a_ref->[0];  # use an arrow notation to indicate that `$a_ref` is actually a reference
~~~

That's that for array references. What about hash references? Similarly to
array references you can take a reference by using a backslash \:

~~~perl
my %hash = (age => 9);
my $hash_ref = \%hash;
~~~

Note again that `$hash_ref` is a scalar and thus prefixed with `$`. We can
thus use this hash reference as values in other hashes or as members of an
array.

As with arrays there is a shorthand for creating such hash references:

~~~perl
my $hash_ref = { age => 9 };
~~~

Namely, use `{ }` instead of `( )`. You will see that notation frequently and it will
comfort you as it is similar notation to JSON or Python `dict`s.

Accessing values from hash references is similar. Recall that if you'd want the
value `9` of the above `%hash`, you'd do:

~~~perl
$hash{age};
~~~

We have a similar _trick_ as with arrays when you want to get that value via the `$hash_ref` rather than the `%hash`.
We replace the name `hash` by `{$hash_ref}` -- the dereferenced reference:

~~~perl
${$hash_ref}{age};
~~~

Also this form has an easier to read form using an `->` notation:

~~~perl
$hash_ref->{age};
~~~

which is the preferable form.


# Conditions

The syntax for `if`-conditions has no surprises:

~~~perl
if ( $age == 18 ) {
  # stuff
}
~~~

Note the equality test `==` for numbers (strings are compared with `eq`).
Inequality is tested with `!=` for numbers (and `neq` for strings):

~~~perl
if ( $age != 18 ) {
  # stuff
}
~~~

or by using the negation operator `!` directly:

~~~perl
if ( !($age == 18) ) {
  # stuff
}
~~~

Note the extra parentheses in `!($age == 18)`. This is needed as in `!$age == 18`,
`!$age` is interpreted first. This is unwanted as `$age` is assumed to be a
number and the negation `!` of a number is false for all numbers except
`0`.

Other useful operators to use in conditions are `&&` for logical _and_, `||` for logical _or_.

We have the usual `else`:

~~~perl
if ( $age == 18 ) {
  # stuff
}
else {
  # other stuff
}
~~~

You can do cases using `elsif`:

~~~perl
if ( $age == 18 ) {
  # stuff
}
elsif ( $age > 18) {
  # other stuff
}
else {
  # more stuff
}
~~~

Note that it's _not_ `elseif` nor `else if`. It's `elsif`.

`perl` also has the `unless` keyword for the "`if` not" situation. Do not use
`unless` unless you feel like getting confused.

Conditions can also be used to filter arrays. Using `grep` you can reduce an
array to keep only the items that satisfy a certain condition.  Say I want to
create an array containing only negative numbers:

~~~perl
my @all_numbers = (9, -7, -6, 5, 4);
my @negatives = grep { $_ < 0 } @all_numbers;
~~~

I was able to avoid `$_` for a long time, but no more. `$_` is a scalar
variable (given away by the `$`). And the `_` can be memorized as something that points to _whatever makes
sense at this point in the code_. When used in a `grep`, `$_`, will contain, in
sequence, every number from `@all_numbers`. `grep` will apply the condition `$_
< 0` and will keep only those numbers that satisfy that condition (and store it
in `@negatives`).

Thus, `@negatives` will contain `(-7, -6)`.

How to check whether there is _any_ negative number (i.e., is there
at least 1 negative number?) in a list `@all_numbers`. You could do this:

~~~perl
my @all_numbers = (9, -7, -6, 5, 4);
my @negatives = grep { $_ < 0 } @all_numbers;
my $contains_negative = @negatives;
~~~

I first used `grep` to get all negatives, and then I forced the array
      `@negatives` into a scalar. When you force an array into
      a scalar it will store the length of that array, such that
      `$contains_negative` contains a `0` or strictly positive number (in the
      example, it will contain a positive number as `@negatives` has 2
      elements). You can use this in a condition:

~~~perl
if ($contains_negative) {
  # stuff
}
~~~

Indeed, since any non-zero positive number is considered true, this condition
will be true if there was _any_ negative number.

Besides being slightly involved, this is also not as efficient as it could be:
`grep` collects _all_ negative numbers and we are interested in whether there's
at least `1` negative number. In other words, we'd want to short-circuit this.
We have exactly that functionality in the core module `List::Util` with the
function [`any`](https://perldoc.perl.org/List/Util.html#any):

~~~perl
use List::Util qw(any);

if ( any { $_ < 0 } @all_numbers ) {
  # stuff
}
~~~

You see that `any { $_ < 0 } @all_numbers` returns true if the condition `$_ <
0` is true for _any_ of the numbers in `@all_numbers`.

I sprung something else on you:

~~~perl
use List::Util qw(any);
~~~

You're used to such inclusions of modules/packages/languages (modules in `perl`
parlance) in other languages (Java has import). In this example, `use`
announces _I'm making stuff available to use from the module `List::Util`_. But
what with `qw(any)`?

`any` is a function/subroutine (`subroutine` in `perl`) defined in that
`List::Util` module, so we're indicating that we'd like to import `any` from
`List::Util`. But what about `qw`? You
essentially want to indicate what functions you'd want to include, so you could
write a literal list of strings: `("any")`. And if you want also the subroutine
`first`:

~~~perl
use List::Util ("any", "first");
~~~

`perl` programmers find double quotes and commans burdensome, so you can write this as:

~~~perl
use List::Util qw(any first);
~~~

where `qw` signifies, _hey, these are quoted words_.

I already mentioned `first`: use `first` when you'd like to find
the first element that matches the condition:

~~~perl
my @all_numbers = (9, -7, -6, 5, 4);
my $first_negative = first { $_ < 0 } @all_numbers;
~~~

# Looping

For `for`-loops, I prefer this form:

~~~perl
for my $number (@all_numbers) {
  print "el: $number ";
}
~~~

With the above `@all_numbers`, this prints: `el: 9 el: -7 el: -6 el: 5 el: 4 `.

The first line of that loop: `for my $number (@all_numbers)`, indicates that we
are going to loop through the elements of the array `@all_numbers`. We
initialize `my $number` with each such element from `@all_numbers`.

Why are there parentheses `( )` around `@all_numbers` in that syntax? That seems
odd, but it seems that there are not many reasons apart from that [Larry wants
it](https://stackoverflow.com/questions/3650000/what-is-the-purpose-of-the-parentheses-in-perls-foreach-statement).

Let's modify the above loop to only print negative numbers:

~~~perl
for my $number (@all_numbers) {
  if ( $number < 0 ) {
    print $number;
  }
}
~~~

Let's rewrite that loop using the opposite condition: `$number > 0` (testing
for positive numbers) but let's still print negative numbers:

~~~perl
for my $number (@all_numbers) {
  if ( $number > 0 ) {
    # do nothing
  }
  else {
    print $number;
  }
}
~~~

Let's take that one step further and try to write that without an `else`.  If
there's a way to skip the rest of the loop I can just put the `print` as the last
statement. I just need to make sure I never reach that last statement when a
number is positive.  I could do that by skipping to the _next_ iteration of the
loop when a number is positive.

~~~perl
for my $number (@all_numbers) {
  if ( $number > 0 ) {
    next;
  }
  print $number;
}
~~~

Usually, when using `next` in such a simple case, you'd like it to be more
prominent, so you'd use the postfix notation:

~~~perl
for my $number (@all_numbers) {
  next if ( $number > 0 );
  print $number;
}
~~~

For additional clarity, you can label your for-loops when
having such control statements like `next`:

~~~perl
NUMBER:
for my $number (@all_numbers) {
  next NUMBER if ( $number > 0 );
  print $number;
}
~~~

That's often useful when nesting loops as it adds clarity as to where your
`next` is jumping to.

That `next` showed how to skip the current iteration. You can also break out of
the loop entirely by using
[last](https://perldoc.perl.org/functions/last.html).

Let's do another example of a loop. Construct a new array out of
`@all_numbers` that contains the elements of `@all_numbers` but doubled:

~~~perl
my @doubled_numbers = ();
for my $number (@all_numbers) {
  push @doubled_numbers, 2 * $number;
}
~~~

I initialized a new array `@doubled_numbers` with the empty array `(
)`. I looped through `@all_numbers` and using `push` I added all doubled numbers.
`push` adds numbers from the back as we saw before so order nicely stays
maintained. Is there a problem with this approach?

It works, but the caveat is that, as is usual in most programming languages,
the memory allocated for `@doubled_numbers` potentially has to be re-allocated
when we run out of initial memory for `@doubled_numbers`.  This is inefficient.
In cases where we're constructing a new _something_ out of an another
_something_ consider using a
[`map`](https://perldoc.perl.org/functions/map.html):

~~~perl
my @doubled_numbers = map { 2 * $_ } @all_numbers;
~~~

As with `grep`, the variable `$_` will be _each element from `@all_numbers`_.
We will take that element and execute the expression within `{ }`, and then we
will put the results of all those executions in 1 list. That list is the result
of the `map`. Note that we can generate multiple elements for each element of
the list that we apply the `map` to, so we can increase the size of the list.
Say we want to repeat each occurrence of each element:

~~~perl
my @double_sight = map { $_, $_ } @all_numbers;
~~~

will return a list of 2 elements for each number in `@all_numbers` which we'll
then concatenate. For example, say `@all_numbers` is `(1, 2, 3)`, then
`@double_sight` will be `(1, 1, 2, 2, 3, 3)`. Why will it not be `((1, 1), (2,
2), (3, 3))`: `perl` does not allow such nested lists, so the inner lists will
be implicitly flattened. We could make the list construction in that latter a
bit more explicit by writing:

~~~perl
my @double_sight = map { ($_, $_) } @all_numbers;
~~~

Since the result of a `map` is always an array, we can always store that result
into an array variable. But we also saw that we can initialize a hash using an
array. In other words, something like this:

~~~perl
my %hash = map { $_ => $_ } @something;
~~~

creates a `%hash` with as keys the elements from `@something` and as values
those same elements. So if `@something` is `("stijn", "stijn")`, we'll have
that `%hash` is `(stijn => 'stijn', stijn => 'stijn')`.


# Subroutines

We have talked about data, ways to store it, and ways to manipulate it using
`perl`'s built-ins and control structures such as conditions and loops. How do we write our own functions/methods to manipulate
data? In `perl`, functions/methods are called _subroutines_. We indicate that
we're defining a subroutine by the keyword `sub`.

For example, let's define a subroutine that doubles a number:

~~~perl
sub double_it {
  my ($x) = @_;

  return 2 * $x;
}
~~~

What `2 * $x` does is clear. What is new is the `return`: it tells `perl` to
exit from the subroutine and to return double the value of `$x` to the caller
of the subroutine.

Where are the arguments to this function? It _seems_ like `$x` is the argument
but it's first mentioned in an unexpected way:

~~~perl
my ($x) = @_;
~~~

Let's walk through a subroutine call to see how the argument to a subroutine
call gets stored in `$x` in this example. Say I want to double `5`:

~~~perl
my $y = double_it(5);
~~~

The argument list to `double_it` now gets implicitly bound to the special array
variable `@_`. Note that we already saw special variable `$_`, well, this is
another special one, for arrays.

In this case, we'd have that `@_` is be bound to the list `(5)`. So `my
($x) = @_`is at that point the same as `my ($x) = (5)`. The left hand side is
an array literal with a variable `$x` in it, the right hand side is just an
array literal. `perl` matches those 2 for you such that `$x` is now `5`.

Let's take a quick detour around this mechanism of matching. It allows you to
do:

~~~perl
my ($x, $y) = (5);
~~~

`$x` is now `5`, but what happened to `$y`? It's `undef` as you had nothing to match it with. What about:

~~~perl
my ($x) = (5, 6);
~~~

Again, `$x` is `5`, but what happened with `6`? Nothing. It fell on the floor.

I'll mention an alternative way to get to the arguments as you'll see that one
as well frequently used:

~~~perl
my $x = shift;
my $y = shift;
~~~

This is an alternative for

~~~perl
my ($x, $y) = @_;
~~~

You might ask why do I see `shift` and not `shift @_`? Well, `perl` is in the
habit of assuming defaults, in this case the `@_` is assumed and `shift` indeed
stands for `shift @_`.

This might be a cleaner way in case you want to validate `$x` for example,
before continuing with the rest of the arguments.

To test our knowledge, let's look at this:

~~~perl
my @a = (1, 2);

sub f {
  my @args = @_;
  $args[0] = 3;
}

f(@a);
print "@a\n";
~~~

What will this print? The array will print the original `@a`, namely `1 2`. The
reason is that `@args` is a copy of `@_`, and we only changed the copy.

How can we make it so the original `@a` is indeed changed. Well, we have references for that:

~~~perl
my @a = (1, 2);

sub f {
  my ($args_ref) = @_;
  $args_ref->[0] = 3;
}

f(\@a);
print "@a\n";
~~~

will print `3 2` as the original `@a` is now indeed changed since we passed it by reference.

# Matching and Substituting

We cannot talk about `perl` without mentioning regular expressions. Let's look
at some examples to explain common constructs.

Assume you have a string "there is a wolf somewhere" and you'd like to check
whether it contains the word _wolf_:

~~~perl
my $test = "there is a wolf somewhere";
if ($test =~ /wolf/) {
  print "there is a wolf somewhere but you already knew that!";
}
~~~

The meat of this code is in the `if` test: `$test =~ /wolf/`. With the binding
operator `=~` we are saying: I want to check the pattern on the right of `=~`
in the text on the left of `=~`. What is the pattern? The pattern is between
slashes `/`: `/wolf/`. Note that you'll sometimes see `m/wolf/`, i.e, the pattern prefixed
with `m`. That's because there's a version with `s` as well, which stands for
_substitute_.

That was the absolute basics. Let's advance to _capture groups_. They allow you
to use the matched pattern later:

~~~perl
my $test = "there is a Wolf somewhere";
if ($test =~ /([wW]olf)/) {
  my $matched_wolf = $1;
  print "there is a $matched_wolf somewhere but you already knew that!";
}
~~~

I used a _character class_ `[wW]` which stands for a match with either `w` or
`W`. And I surrounded `[wW]olf` with parentheses like so: `([wW]olf)`. The
parentheses created a capture group which I referenced later using `$1`. Note
that you could have several capture groups in a pattern, and you can refer to
these as `$1`, `$2`, etc. The ordering in those variable names is following the
order of the parentheses. For example, if you have pattern `((stuff)more)` and
a text `somestuffmore`, `stuffmore` is matched in `$1` and `stuff` in
`$2`.

I'll further say that the dot `.` stands for any character _except_ a newline.

That was for matching, what about substituting those matches? Let's try:

~~~perl
my $test = "there is a Wolf somewhere";
$test =~ s/([wW]olf)/bear/;
print $test;
~~~

will predictably announce to us that _there is a bear somewhere_. We already
mentioned the `s` for `substitute`. The first part `([wW]olf)` of that `s//`
construct is the pattern to replace, the second part `bear` is the pattern to
replace it with.

We can refer to the capturing groups of the first pattern in the 2nd pattern:

~~~perl
my $test = "there is a wolf somewhere";
$test =~ s/([wW]olf)/bear$1/;
print $test;
~~~

which prints `there is a bearwolf somewhere`. At which point, we should
all just leave the campground and find a hotel.

# Constants

Java programmers might wonder how to declare something as constant (`private
static final`), i.e., you can define it once, but you can afterward no longer
re-assign it.

You can use the `ReadOnly` module:

~~~perl
use Readonly;

Readonly my $MEANING_OF_LIFE => 42;
~~~

Things to note:

- we use `=>` instead of `=`
- we write `Readonly` before the variable declaration.

While this looks a lot like a variable declaration, you can see that, given
`perl`'s looseness with parentheses, this is probably just a subroutine call
`Readonly(my $MEANING_OF_LIFE, 42)` made to look like a variable declaration.

In any case, try this:

~~~perl
$MEANING_OF_LIFE = 41;
~~~

The compiler will complain with an _Invalid initialization by assignment_,
because we declared the variable to be read-only and `41` is not the [meaning
of life](https://en.wikipedia.org/wiki/The_Hitchhiker%27s_Guide_to_the_Galaxy).

# Printing Anything

If you print, for example, a hash reference:

```
print {a => 1, b => 2};
```

you'll see a useless `HASH(0x7f8d43004ee8)` printed. In order to print more
than strings or numbers, the `Data::Dumper` module is there to help:

~~~perl
use Data::Dumper;

my $hash_ref = {a => 1, b => 2};
print Dumper($hash_ref);
~~~

Often the thing you'd like to print is a deeply nested structure. If you want
to limit the levels of that nested structure you'd like to print you can do:

~~~perl
$Data::Dumper::Maxdepth=2;
~~~

# Acknowledgements

Thanks to [csbuja](https://github.com/csbuja) for corrections.

