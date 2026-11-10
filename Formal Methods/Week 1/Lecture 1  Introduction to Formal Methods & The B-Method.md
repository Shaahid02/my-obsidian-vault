### 1. Why Formal Methods?

- **Cost of Software Errors:** Most software defects are introduced early during requirements and specification, but only discovered late during testing or maintenance. Fixing them late is significantly more expensive.
- **Limitations of Informal Approaches:**
    - **Natural Language:** Ambiguous and imprecise.
    - **UML & Structured Diagrams:** Non-formal representations that still rely on testing.
    - **Testing:** Testing demonstrates the _presence_ of defects, but cannot guarantee their _absence_ (e.g., formal post-mortem analysis of Windows XP revealed tens of thousands of undetected null pointer exceptions despite extensive testing).
- **Safety & Security Critical Systems:** Where software failure can lead to financial disaster, loss of property, or loss of life (e.g., Ariane 5 rocket, Therac-25 radiotherapy machine):
    - **EAL (Evaluation Assurance Level 1–7):** Security certification standard for information systems (e.g., banking).
    - **SIL (Safety Integrity Level 1–4):** Safety certification standard (e.g., railways, automotive; SIL4 specifies Mean Time To Failure ~100,000 years).
    - For highest levels of SIL and EAL certification, formal methods are legally required or essential.

---

### 2. Formal Specifications & The B-Method

- **Formal Specification:** A precise mathematical description focusing on **what** a system does, not **how** it is implemented.
- **Abstract Machine (AM):** The central building block in the B-Method (analogous to classes/modules in OOP). Encapsulates:
    - **Name:** Machine identifier.
    - **State:** Defined by variables.
    - **Interface:** Operations that query or modify state.
- **Core Machine Clauses:**
    - `SETS`: Defines custom enumerated types (e.g., `Family = {Amber, Ben, ...}`).
    - `CONSTANTS` & `PROPERTIES`: Declares constants and their mathematical constraints.
    - `VARIABLES`: State variables of the machine.
    - `INVARIANT`: Predicates that variables must **always** satisfy (types, safety bounds).
    - `INITIALISATION`: Assigns starting values to variables using parallel assignment (`||`).
    - `OPERATIONS`: Methods guarded by preconditions (`PRE condition THEN actions END`).

---

### 3. Mathematical Foundations: Set Theory & Arithmetic

#### Set Characteristics in B

- Sets are unordered collections with no duplicate elements.
- **Homogeneous restriction:** In B, sets cannot mix types (e.g., `{green, 8, {}}` is not permitted).

#### Number Sets

| Set               |      Math      | B ASCII Notation | Description                        |
| :---------------- | :------------: | :--------------: | :--------------------------------- |
| Integers          |  $\mathbb{Z}$  |  **`INTEGER`**   | All positive and negative integers |
| Natural Numbers   |  $\mathbb{N}$  |    **`NAT`**     | Integers starting from \(0\)       |
| Positive Naturals | $\mathbb{N}_1$ |    **`NAT1`**    | Integers starting from \(1\)       |

#### Set Operations & Relations

| Operation             |        Math         | B ASCII Notation | Meaning / Example                                                             |
| :-------------------- | :-----------------: | :--------------: | :---------------------------------------------------------------------------- |
| **Membership**        |      $x \in A$      |   **`x : A`**    | Element `x` is in set `A`                                                     |
| **Non-membership**    |    $x \notin A$     |   **`x /: A`**   | Element `x` is not in set `A`                                                 |
| **Subset**            |   $A \subseteq B$   |   **`A <: B`**   | All elements of \(A\) are in \(B\) (\(A\) can equal \(B\))                    |
| **Strict Subset**     |    $A \subset B$    |  **`A <<: B`**   | All elements of \(A\) are in \(B\), and \(A \neq B\)                          |
| **Not Subset**        | $A \not\subseteq B$ |  **`A /<: B`**   | At least one element of \(A\) is not in \(B\)                                 |
| **Not Strict Subset** |  $A \not\subset B$  |  **`A /<<: B`**  | \(A\) is not strictly contained in \(B\) (\(A = B\) or \(A \not\subseteq B\)) |
| **Union**             |     $A \cup B$      |   **`A \/ B`**   | Elements in \(A\), \(B\), or both                                             |
| **Intersection**      |     $A \cap B$      |   **`A /\ B`**   | Elements common to both \(A\) and \(B\)                                       |
| **Set Difference**    |   $A \setminus B$   |   **`A - B`**    | Elements in \(A\) that are not in \(B\)                                       |
| **Cardinality**       |       $\|A\|$       |    `card(A)`     | Total number of unique elements in $A$                                        |

#### Defining Sets & Constructors

- **Empty Set:** `{}` or \(\emptyset\).
- **Integer Range:** `m..n` (e.g., `2..7` is `{2, 3, 4, 5, 6, 7}`).
- **Power Set (`POW(A)`):** Set of all subsets of \(A\); contains \(2^{|A|}\) elements.
- **Cartesian Product (`A * B`):** Set of all ordered pairs `(a, b)` where `a : A` and `b : B`.
- **Set Comprehension:** `{ x | x : Set & condition }` (multiple conditions combined with `&`).

#### Arithmetic & Logic Operators

- **Arithmetic:** `+`, `-`, `*`, `/`, `mod`, `**` (power).
- **Successor / Predecessor:** `succ(x)` (\(x+1\)), `pred(x)` (\(x-1\)).
- **Comparison:** `=` (equal), `/=` (not equal), `<`, `<=`, `>`, `>=`.

---

### 4. Software Tools

- **Atelier B:** Primary B specification editor and syntax/type checker.
- **ProB:** Animator, simulator, and model checker for B specifications.
- **Graphviz:** Visualizer tool used to render state-transition graphs from `.dot` files produced by ProB.

---
### Subset (`<:`) vs. Strict Subset (`<<:`)

#### 1. Core Definitions

- **Subset (`A <: B` | $A \subseteq B$):**
    - Every element in set $A$ is also in set $B$.
    - **Equality is permitted:** $A$ and $B$ can be identical.
    - **Self-inclusion:** Every set is always a subset of itself (**`A <: A`** is always **True**).
- **Strict Subset (`A <<: B` | $A \subset B$):**
    - Every element in set $A$ is in set $B$, **and $A \neq B$**.
    - Set $B$ must contain at least one extra element not present in $A$.
    - **No self-inclusion:** A set can **never** be a strict subset of itself (**`A /<<: A`** is always **False**).

#### 2. The Null / Empty Set (`{}`)

- **General rule:** The empty set is a subset of every set (**`{} <: X`** is always **True**).
- **Strict subset rule:**
    - For any **non-empty** set: **`{} <<: X`** is **True** (e.g., `{} <<: {2, 4}` is True because `{2, 4}` contains extra elements).
    - For the **empty set itself**: **`{} <<: {}`** is **False** (a set cannot strictly contain itself).

#### 3. Logical Implications

- **`A <<: B` $\implies$ `A <: B`:** If \(A\) is a strict subset of \(B\), it is automatically a subset.
- **`A /<: B` $\implies$ `A /<<: B`:** If \(A\) is not a subset, it cannot possibly be a strict subset.

#### 4. Quick Reference Matrix

Using $C = {2, 4, 6}$ and $A = {1, 2, 3, 4, 5, 6, 7, 8}$:

| Expression                        | ASCII Notation |  Result   | Reason                                                                  |
| :-------------------------------- | :------------- | :-------: | :---------------------------------------------------------------------- |
| **$C \subseteq A$**               | `C <: A`       | **True**  | All elements of \(C\) are contained in \(A\).                           |
| **$C \subset A$**                 | `C <<: A`      | **True**  | All elements are in \(A\), and \(A\) has extra elements (\(C \neq A\)). |
| **$C \subseteq C$**               | `C <: C`       | **True**  | Any set is a subset of itself.                                          |
| **$C \subset C$**                 | `C <<: C`      | **False** | Strict containment forbids equal sets.                                  |
| **$\emptyset \subset C$**         | `{} <<: C`     | **True**  | Empty set is contained, and \(C\) is non-empty.                         |
| **$\emptyset \subset \emptyset$** | `{} <<: {}`    | **False** | Identical sets cannot be strict subsets.                                |

---
## Exercises
![[Pasted image 20261110103814.png]]
### Exercise 1

1. ``card(B) = 5``
2. ```B \/ C = {1, 2, 4, 6, 7, 9, 10}```
3. ```C/\ 1..5 = {2, 4}```
4.  ```A - B = {2, 3, 5, 6, 8}```
5. `POW(C) = {{}, {2}, {4}, {6}, {2, 4}, {2, 6}, {4,6}, {2, 4, 6}}`

### Exercise 2

`{EvenNumbers|EvenNumbers:NAT1 & EvenNumbers < 20 & EvenNumbers mod 2 = 0}
`
### Exercise 3

1. `5:D` is True
2. `4:B` is True
3. `A<:D` is True
4. `B<:A` is False
5. `C<<:B` is False
6. `{2,4}:POW(C)` is True