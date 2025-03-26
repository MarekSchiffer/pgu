# Recursion
If somebody asks you what 720! is, you can always answer. It's obviously
720 * 719! The questioner might argue that doesn't help much and ask what 719! is.
To which you replay << It's 719 * 718! >>. If he's still not satisfied, I suggest
you put him in his place and tell him to do some of his work on his own.

The gist is the factorial function can be solved recursively. The solution can be
postponed up until the point the recursion anchor or base base is reached.

For factorial the base anchor is 0! = 1.
All other cases are resolved with $n! = n * (n-1)!$

If somebody asks you what 720! is, you can always answer. It's obviously 
$720 * 719!$ The questioner might argue that doesn't help much and ask what 719! is.
To which you reply: « It's $719 * 718!$ » If he's still not satisfied, I suggest 
you put him in his place and tell him to do some of his work on his own.

The gist is the factorial function can be solved recursively. The solution can be 
postponed up until the point the recursion anchor or base case is reached.

For factorial, the base anchor is 0! = 1.
All other cases are resolved with n! = n * (n-1)!

## Parentheses.
If we take the case 720!, actually let's take 4! for times sake and solve it recursively
purely mathematically
\begin{align*}
4! &= 4 \times 3! \\
   &= 4 \times (3 \times 2!) \\
   &= 4 \times (3 \times (2 \times 1!)) \\
   &= 4 \times (3 \times (2 \times (1 \times 0!))) \\
   &= 4 \times (3 \times (2 \times 1)) \\
   &= 4 \times (3 \times 2) \\
   &= 4 \times 6 \\
   &= 24
\end{align*}

$$
4! &= 4 * 3!
   &= 4 * ( 3 * 2!)
   &= 4 * ( 3 * ( 2 * 1!))
   &= 4 * ( 3 * ( 2 * ( 1 * 0! )))
   &= 4 * ( 3 * ( 2 * ( 1 * 1 )))
   &= 4 * ( 3 * ( 2 *  1 ))
   &= 4 * ( 3 *  2 )
   &= 4 * 6
   &= 24
$$
