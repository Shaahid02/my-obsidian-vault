### 1. Does a Function Require _All_ Elements of the Domain to be Mapped?

- **The Misunderstanding:** Assuming that for a relation to be a function, every element in the source set must have an assigned value.
- **The Reality:**
    - The defining rule of a **function** is strictly about **unambiguous outputs**: each input that is mapped can have **at most one** output (no single input splits into multiple values).
    - Whether _all_ elements in the source set are mapped determines whether the function is **Partial** or **Total**:
        - **Partial Function (`+->`):** Only _some_ (or none, or all) elements of the source set are mapped. The domain is a subset: \(\text{dom}(f) \subseteq A\). In **Q3**, `animalSound` mapped only `Cat` and `Dog`, leaving `Fish` and `Bird` unmapped; it is still a valid function—specifically a **partial function**.
        - **Total Function (`-->`):** _Every single element_ of the source set must map to an output: \(\text{dom}(f) = A\). In **Q2**, `fuelType` mapped all five vehicles in `Vehicle`, making it a **total function**.

---

### 2. What Does It Mean When `ran(fuelType) /= Fuel`? (Codomain vs. Range)

- **The Misunderstanding:** Listing the entire target set (`Fuel = {Petrol, Diesel, Electric, None}`) as the range of `fuelType`.
- **The Reality:**
    - **Target Set / Codomain (`Fuel`):** The declared pool of possible values that outputs _can_ belong to.
    - **Range (`ran(fuelType)`):** The set of actual values that are _actively pointed to_ by the mapping.
        - In `fuelType`, the outputs were `Petrol`, `Diesel`, and `Electric`. The value `None` was never assigned to any vehicle.
        - Therefore, \(\text{ran}(\text{fuelType}) = {\text{Petrol}, \text{Diesel}, \text{Electric}} \neq \text{Fuel}\).
    - **Significance:** When \(\text{ran}(f) \neq B\), the function is **not surjective** (it is not "onto") because some potential target values are left unused.

---

### 3. "Relation" vs. "Function" in Questions

- **The Misunderstanding:** Answering that `animalSound` is a "relation" rather than a function.
- **The Reality:**
    - In discrete mathematics and B, all functions are relations (\(\text{Functions} \subset \text{Relations}\)).
    - However, when an exercise asks _"Is it a relation or a function?"_, it is asking: **Does it satisfy the functional property (single-valued), or is it a general relation that maps one element to multiple values?**
    - If no element maps to more than one output, always identify it as a **function**, then specify:
        1. **Partial or Total** (based on domain coverage: \(\text{dom}(f) = A\) or \(\text{dom}(f) \subset A\)).
        2. **Injective or Not** (based on whether distinct inputs yield distinct outputs: \(f(x) = f(y) \implies x = y\)).
        3. **Surjective or Not** (based on whether the whole target set is covered: \(\text{ran}(f) = B\)).

---

### 4. Output Types: Tuples/Pairs vs. Sets

- **The Misunderstanding:** Writing relational images or domains as tuples: e.g. `(Few, Many)` instead of sets `{Few, Many}`.
- **The Reality:**
    - `dom(...)`, `ran(...)`, and relational image `r[...]` **always return sets**, enclosed in curly braces `{ ... }`.
    - Parentheses `(a, b)` or maplets `a |-> b` are only used for individual ordered pairs within a relation.

---

### Quick Diagnostic Flowchart

$$\text{Does any single input map to multiple outputs?}$$

- **Yes** $\implies$ **General Relation (`<->`)**
- **No** $\implies$ **Function**
    - Is **every** element in the source set mapped?
        - **Yes** $\implies$ **Total (`-->`)**
        - **No** $\implies$ **Partial (`+->`)**
    - Is every output value unique to one input?
        - **Yes** $\implies$ **Injective (`>+>` / `>->`)**
        - **No** $\implies$ Non-injective (Many-to-one)
    - Does the range cover the entire target set ($\text{ran} = \text{Target}$)?
        - **Yes** $\implies$ **Surjective (`+->>` / `-->>`)**
        - **No** $\implies$ Non-surjective
