### 1. General Relation vs. Function

- **Relation (`<->`)**: A general subset of the Cartesian product \(A \times B\).
    
    - An element in the source set can relate to **zero, one, or multiple** elements in the target set (many-to-many allowed).
    - _Example:_ `parentOf : PEOPLE <-> PEOPLE` (one parent can have several children).
- **Function**: A relation where each element in the domain maps to **at most one** element in the target set (no single input splits into multiple different outputs).
    

---

### 2. Domain Properties: Partial vs. Total

- **Partial Function (`+->`)**:
    
    - Not every element in the source set \(A\) needs to have an image.
    - $\text{dom}(f) \subseteq A$.
    - _Example:_ `myMum : PEOPLE +-> PEOPLE` (some people like `Grandad` do not have an alive mother in `family`).
- **Total Function (`-->`)**:
    
    - **Every** element in the source set \(A\) must map to an element in \(B\).
    - $\text{dom}(f) = A$.
    - _Logical definition:_ `!(xx).(xx:A => #(yy).(yy:B & (xx,yy):f))`.
    - _Example:_ `grades : Student --> Grade` if every enrolled student is assigned a grade.

---

### 3. Mapping Uniqueness & Coverage: Injective vs. Surjective vs. Bijective

- **Injective (`>+>` partial, `>->` total) — "One-to-One"**:
    
    - Different inputs map to different outputs. No two elements in the domain share the same target value.
    - If $f(x_1) = f(x_2)$, then $x_1 = x_2$.
    - _Logical definition:_ `!(xx,yy).(xx:A & yy:A => (xx /= yy => f(xx) /= f(yy)))`.
    - _Example:_ `passport : PEOPLE >+> PASSPORT_NUMBERS` (no two people can share the same passport number).
- **Surjective (`+->>` partial, `-->>` total) — "Onto"**:
    
    - Every element in the target set \(B\) is mapped to by at least one element from \(A\).
    - The range equals the entire codomain: $\text{ran}(f) = B$.
    - _Logical definition:_ `!(yy).(yy:B => #(xx).(xx:A & (xx,yy):f))`.
    - _Example:_ `fuelType` where every fuel in `Fuel` is used by at least one vehicle.
- **Bijective (`>->>`) — "One-to-One & Onto"**:
    
    - Both **injective** and **surjective** (and total).
    - Every input has a unique partner, and every output has a unique partner (an exact pairing).

---

### 4. AMN / B-Method Notation Quick Reference

|Symbol|Concept|Plain English Meaning|
|:--|:--|:--|
|`<->`|**Relation**|Any pairing; inputs can map to multiple outputs.|
|`+->`|**Partial Function**|Each input maps to **at most one** output; not all inputs need to map.|
|`-->`|**Total Function**|Every input in the source set maps to **exactly one** output.|
|`>+>`|**Partial Injection**|Unique outputs (one-to-one), but not all inputs are used.|
|`>->`|**Total Injection**|Unique outputs (one-to-one), and all inputs are used.|
|`+->>`|**Partial Surjection**|Covers the entire target set (onto), but not all inputs are used.|
|`-->>`|**Total Surjection**|Covers the entire target set, and all inputs are used.|
|`>->>`|**Bijection**|Perfect one-to-one correspondence across both sets.|

---

### 5. Common Clarification: Does "Partial" Mean "Many-to-One"?

- **No.** "Partial" refers strictly to **how much of the domain is covered** (some inputs don't map to anything).
- Whether a function is "many-to-one" depends on **injectivity**:
    - **Many-to-One**: A non-injective function (e.g. `sex : PEOPLE +-> SEX`, where both `Jim` and `Grandad` map to `Male`).
    - **One-to-One**: An injective function (`>+>` / `>->`), where two inputs cannot produce the same output.