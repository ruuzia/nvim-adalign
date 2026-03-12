# Nvim Adalign

![Adalign Demo](demo.gif)

Adalign adds a simple align by regexp command :Align for Neovim.

This started as a quick user command in my config but I've since improved upon it to be more complete. Thus the birth of a little plugin, Adalign.

Adalign uses the new Neovim 0.8 user command preview functionality to support previews (like :s and /). I recommend Neovim >=0.8.1 (or nightly).

### Installation
```lua
'ruuzia/nvim-adalign'
```

### Usage
```vim
:help adalign-neovim
```
```
Align                                                                 *:Align*

:[range]Align {pattern}

Inserts spaces in lines in [range] so that the start columns of {pattern}
match align. Lines that fail to match {pattern} are ignored.

SIMPLE EXAMPLE:
Visual selecting the following content:
>c
    Vector2 vec_Sum(Vector2 a, Vector2 b) { return VECOP(a, +, b); }
    Vector2 vec_Scale(Vector2 v, Vector2 f) { return VECOP(v, *, f); }
    Vector2 vec_Mult(Vector2 v, float f) { return VECOP(v, *, f); }
    Vector2 vec_Div(Vector2 v, float f) { return VECOP(v, /, f); }
    Vector2 vec_Add(Vector2 v, float f) { return VECOP(v, +, f); }
<
Then,
>vim
    :Align {
<
Yields:
>c
    Vector2 vec_Sum(Vector2 a, Vector2 b)   { return VECOP(a, +, b); }
    Vector2 vec_Scale(Vector2 v, Vector2 f) { return VECOP(v, *, f); }
    Vector2 vec_Mult(Vector2 v, float f)    { return VECOP(v, *, f); }
    Vector2 vec_Div(Vector2 v, float f)     { return VECOP(v, /, f); }
    Vector2 vec_Add(Vector2 v, float f)     { return VECOP(v, +, f); }
<

REMARK:
You may use the |/\zs| regex atom to easily control the start position of the match.

```
```
Unalign                                                             *:Unalign*

:[range]Unalign

Unalign does not necessarily undo an :Align command, and accepts no pattern.
It's a trivial command that simply replaces any sequence of consecutive spaces in
each line excluding indentation with a single space.

SIMPLE EXAMPLE:
Visual selecting the following content:
>python3
    x             = 1
    y             = 2
    long_variable = 3
<
Then,
>vim
    :Unalign
<
Yields:
>python3
    x = 1
    y = 2
    long_variable = 3
<
```
