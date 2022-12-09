
# Damn... What am I looking for?

#[
    #[
        #[
            #
        ]#
    ]#
]#


# I want to believe that's a compile-time statement
when system.hostOS == "windows":
    echo "Running on Windows!"
elif system.hostOS == "linux":
    echo "Running on Linux!"
elif system.hostOS == "macosx":
    echo "Running on Mac OS X!"
else:
    echo "Unknown operating system :/"


block facExample:
    echo "-----------------facExample-----------------------"
    # computes fac(10) at compile time:
    const fac10 = (var x = 1; for i in 1..10: x *= i; x)
    echo fac10



#[
A procedure that returns a value has an implicit result variable declared 
that represents the return value.
A return statement with no expression is shorthand for return result. 
The result value is always returned automatically at the end of a procedure
if there is no return statement at the exit.
]#

block procResultExample:
    echo "-----------------procResultExample----------------"
    proc sumTillNegative(x: varargs[int]): int =
        for i in x:
            if i < 0:
                return
            result = result + i

    echo sumTillNegative() # echoes 0
    echo sumTillNegative(3, 4, 5) # echoes 12
    echo sumTillNegative(3, 4 , -1 , 6) # echoes 7

#[
The result variable is already implicitly declared at the start of the function, 
so declaring it again with 'var result', for example, would shadow it with a normal 
variable of the same name. 
The result variable is also already initialized with the type's default value. 
Note that referential data types will be nil at the start of the procedure, 
and thus may require manual initialization.
]#

#[
A procedure that does not have any return statement and does not use the special result variable
returns the value of its last expression. 
]#
block procWithLastExpressionReturn:
    echo "-----------------procWithLastExpressionReturn-----"
    proc helloWorld(): string =
        "Hello, World!"
    echo helloWorld()


#[
To call a procedure that returns a value just for its side effects and ignoring its 
return value, a discard statement must be used.
The return value can be ignored implicitly if the called proc/iterator has been declared 
with the discardable pragma.
]#
block discardExample:
    proc p_nd(x, y: int): int =
        return x + y
    
    proc p_d(x, y: int): int {.discardable.} =
        return x + y
    discard p_nd(3, 4)
    p_d(3, 4) # now valid


block operatorsExample:
    echo "-----------------operatorsExample------------------"
    # The "`" notation can also be used to call an operator just like any other procedure.
    if `==`( `+`(3, 4), 7): echo "true"
    type
        Person = object
            name: string
            age: int

    proc `+|+|`(p: Person): string = # `$` always returns a string
        result = p.name & " is " &
                $p.age & # we *need* the `$` in front of p.age which
                        # is natively an integer to convert it to
                        # a string
                " years old."

    var a: Person = Person(name: "Somebody", age: 10)
    var b: Person = Person(name: "Somebody", age: 12)
    echo +|+|a & "\n" & +|+|b


#[
Every variable, procedure, etc. needs to be declared before it can be used. 
(The reason for this is that it is non-trivial to avoid this need in a language 
that supports metaprogramming as extensively as Nim does). 
However, this cannot be done for mutually recursive procedures.
]#
block forwardDeclaration:
    # forward declaration:
    proc even(n: int): bool
    proc odd(n: int): bool

    proc odd(n: int): bool =
        assert(n >= 0) # makes sure we don't run into negative recursion
        if n == 0: false
        else:
            n == 1 or even(n-1)

    proc even(n: int): bool =
        assert(n >= 0) # makes sure we don't run into negative recursion
        if n == 1: false
        else:
            n == 0 or odd(n-1)

#[
Iterators look very similar to procedures, but there are several important differences:
 - Iterators can only be called from for loops.
 - Iterators cannot contain a return statement (and procs cannot contain a yield statement).
 - Iterators have no implicit result variable.
 - Iterators do not support recursion.
 - Iterators cannot be forward declared, because the compiler must be able to inline an iterator. 
(This restriction will be gone in a future version of the compiler.)
]#
block iteratorsExample:
    echo "-----------------iteratorsExample------------------"
    iterator countup(a, b: int): int =
        var res = a
        while res <= b:
            yield res
            inc(res)
    for x in countup(0, 2): echo x

block basicTypesSomething:
    #"(✌ﾟ∀ﾟ)☞"
    echo "-----------------basicTypesSomething---------------"

    var ✌: int = 50
    echo ✌

    var s: string = "卍ᛋᛋ卍" 
    var cs: cstring = cstring("(✌ﾟ∀ﾟ)☞")
    echo s
    echo cs

    var a = 0xFF'i8
    echo a shl 1 #shr, shl

    




    
    