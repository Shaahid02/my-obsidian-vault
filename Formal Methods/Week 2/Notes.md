In **Abstract Machine Notation (AMN)**, distinct separator symbols are used across the different clauses of a machine depending on what kind of information is being defined:

| Clause / Section                                           |         Separator          | Meaning / Purpose                                                                                 | Example                                           |
| :--------------------------------------------------------- | :------------------------: | :------------------------------------------------------------------------------------------------ | :------------------------------------------------ |
| **`SETS`**, **`OPERATIONS`**                               |   **`;`** _(semicolon)_    | Separates **complete declarations**.                                                              | `SETS A = {..} ; B = {..}``op1 = ... ; op2 = ...` |
| **`CONSTANTS`**, **`VARIABLES`**                           |      **,** _(comma)_       | Separates items in a **simple list of identifiers/names**.                                        | `VARIABLES x, y, z`                               |
| **`PROPERTIES`**, **`INVARIANT`**                          |   **`&`** _(ampersand)_    | Represents **logical AND** (conjunction) connecting predicate statements that must all hold true. | `x : NAT & y <: BOOKS`                            |
| **`INITIALISATION`**, **`Multiple lines in a operatrion`** | **`\|\|`** _(double pipe)_ |                                                                                                   |                                                   |

---

### Key Takeaway

- **Identifiers/Items** are separated by commas (`,`).
- **Logic/Predicates** are joined with logical AND (`&`).
- **Actions/Assignments** occurring at the same time are joined by parallel execution (`||`).
- **Independent structural units** (sets and operation specifications) are ended/separated by semicolons (`;`).