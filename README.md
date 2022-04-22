# AutoHotKey Script for Latex Snippets
This is my personal script for $\LaTeX$ snippets for latex/markdown files. Optimised for use with [Obsidian](https://obsidian.md).
- Note that all snippets are triggered by tab.

## Environments
### Typing `\begin{environment}`
1. Type `beg{space}`. Text will autofill to `\begin.` (with the dot)
2. Then type the environment name, followed by a space to autofill `\begin{env_name}\end{env_name}`!

### Other Shorthands
| Shorthand | Environment                |
| --------- | -------------------------- |
| `mk `     | Inline Math Mode (`$$`)    |
| `dm `     | Display Math Mode (`$$$$`) |
| `ali `    | Align Environment          |
| `ali* `   | Align* Environment         |

## Expressions

### Fractions
- `/` is a shorthand for `\frac{}{}`:

| Shorthand    | Expression                                            |
| ------------ | ----------------------------------------------------- |
| `/ `         | Empty Fraction `\frac{<cursor0>}{<cursor1>}<cursor2>` |
| `a/ `        | Fraction `\frac{a}{<cursor0>}<cursor1>`               |
| `a/b `       | Fraction `\frac{a}{a}`                                |
| `(a + b)/ `  | Fraction`\frac{a + b}{<cursor0>}<cursor1>`            |
| `(a + b)/b ` | Fraction`\frac{a + b}{b}`                             |

### Expressions
#### Superscript & Subscript
- Curly braces `{}` are automatically placed between `_` or `^` and cursor  when space is pressed.

#### `\hat{}` and `\overline{}`
- Type `x.hat` (or `x.aht`) and `x.bar` for `\hat{x}` and `\overline{x}`.

#### Other Expressions of the forms `\[type]{}`
- Cursor is placed in between brackets.

| Shortcut       | String      |
| -------------- | ----------- |
| `sq `, `sqrt ` | `\sqrt{}`   |
| `te `          | `\text{}`   |
| `bf `          | `\mathbf{}` |
| `bb `          | `\mathbb{}` |

#### Symbols

| Shorthand | Symbol  |
| --------- | ------- |
| `pm `     | `\pm` ± |
| `mp `     | `\mp` ∓ |

##### Greek Symbols
- Note: `be` is not a valid shorthand since it clashes with the word 'be'.

| Shorthand       | Symbol       | Shorthand     | Symbol      | Shorthand     | Symbol     |
| --------------- | ------------ | ------------- | ----------- | ------------- | ---------- |
| `\al `, `al `   | `\alpha` α   | `\io `, `io ` | `\iota` ι   | `\Si `, `Si ` | `\Sigma` Σ |
| `\be `, `beta ` | `\beta` β    | `\ka `, `ka ` | `\kappa` κ  | `\si `, `si ` | `\sigma` σ |
| `\ga `, `ga `   | `\gamma` Γ   | `\La `, `La ` | `\Lambda` Λ | `\ta `, `ta ` | `\tau` τ   |
| `\De `, `De `   | `\Delta` Δ   | `\la `, `la ` | `\lambda` λ | `\Ph `, `Ph ` | `\Phi` Φ   |
| `\de `, `de `   | `\delta` δ   | `mu `         | `\mu` µ     | `\ph `, `ph ` | `\phi` φ   |
| `\ep `, `ep `   | `\epsilon` ε | `nu `         | `\nu` ν     | `\ch `, `ch ` | `\chi` χ   |
| `\ze `, `ze `   | `\zeta` ζ    | `Xi `         | `\Xi` Ξ     | `\Ps `, `Ps ` | `\Psi` Ψ   |
| `\et `, `et `   | `\eta` η     | `xi `         | `\xi` ξ     | `\ps `, `ps ` | `\psi` ψ   |
| `\Th `, `Th `   | `\Theta` Θ   | `Pi `         | `\Pi` Π     | `\Om `, `Om ` | `\Omega` Ω |
| `\th `, `th `   | `\theta` θ   | `pi `         | `\pi` π     | `\om `, `om ` | `\omega` ω |