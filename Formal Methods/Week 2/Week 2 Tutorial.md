---

### 6SENG005W Formal Methods

Week 02 Tutorial: Exercises using the B Tools **Atelier B** & **ProB**

---

#### B-Method Tools: **Atelier B** & **ProB**

The first lab session is intended to introduce you to the B tools **Atelier B** & **ProB** and to B's _Abstract Machine Notation (AMN)_.

You will be required to type in the _PaperRound_ abstract machine into **Atelier B**.

Next you should **syntax & type check** it using **Atelier B** & finally **animate** it using **ProB**.

You should refer to the tool's manuals.

**Accessing B Tools**

**Atelier B** & **ProB** are installed on the University's Windows PCs, they are accessible from the **AppsAnywhere** application.

---

#### Exercise 1.1

Setting up & using the **Atelier B** tool & creating a _"workspace"_.

2. Start the **Atelier B** tool from the **AppsAnywhere** application.
    
3. Start by creating a _"workspace"_ for all your B specification projects.
    
    - Using Window's Explorer create a directory/folder in your **H:** _Home Drive_ directory to be used as your B specification _"workspace"_.
        
    - Next, create the "workspace" from the **Atelier B** _"Atelier B > New > Workspace"_ menu.
        
    - Use the _"Browse"_ option to select the directory/folder you just created on your **H:** drive.
    
4. Next set the _"Default Project Directory"_ (place where B specification projects are created) to be the _"workspace"_ you have just created.
    
    - Set the "Default Project Directory" from the **Atelier B** _"Atelier B > Preferences"_ menu.
        
    - Select the _"Project"_ tab, then use the _"Browse"_ option to select the same _"workspace"_ directory/folder you just created on your **H:** drive.
        
    - Finally, select _"Software Development"_

---

#### Exercise 1.2

Create a _"Project"_ for your new B specification, i.e. _PaperRound_.

2. Do this from the **Atelier B** _"Atelier B > New > Project"_ menu.
    
    Type in a _"Project Name"_
    
    Select "Project Type" as _"Software Development"_.
    
3. Then add components to your B specification, i.e. a _B MACHINE_ that makes up the system specification.
    
    Do this from the **Atelier B** _"Atelier B > New > Component"_ menu.
    
    Type in a new component name, in this case it should be just _PaperRound_, you do not need to type in the _".mch"_.
    
4. If everything has worked correctly you should see an _orange box with "PaperRound"_ in it.
    
5. To begin typing the _PaperRound_ specification in just _"double-click"_ the _"orange PaperRound"_ box.

---

#### Exercise 1.3

Using the **Atelier B** built in editor to type in the _PaperRound/I> specification.

You should create it in a file called

PaperRound.mch

You will need to convert the B symbols into their ASCII equivalent, see the first lecture & the B symbols listed in **Atelier B** in the right tab.

_

_

---

#### Exercise 1.4

**Syntax & Type Checking** the specification , using the **Atelier B** tool.

You can either syntax & type check the _PaperRound_ specification as you type it in or after you have finished typing it in.

The **Atelier B** tool will type check it automatically immediately after you have saved any changes.

Error messages will be displayed in the "Outline" sub-window & underlined in red in the specification.

Alternatively, you can "force" type checking by either:

- pressing the _blue circular "Tc" button_ at the top of the tool's main screen.
    
- pressing Control-T, i.e. hold down the "Ctrl" (Control) key & at the same time press the "T" key.

---

#### Exercise 1.5

Once the _PaperRound_ machine has been syntax & type checked & there are **no errors**, you can _animate_ it using the **ProB** animator.

In summary the steps are as follows:

2. To do this start the **ProB** animator tool from the **AppsAnywhere** application.
    
3. Then _open_ the PaperRound.mch file you created in **Atelier B**.
    
    You can open the PaperRound.mch file from the _"File > Open"_ menu, by using the _"Browse"_ option.
    
4. If there are **no errors** then you should see:
    
    - The specification in the top window.
        
    - In the bottom _"Enabled operations"_ window, you should see - **INITIALISATION({})** .
    
5. To begin the animation _"double-click"_ on **INITIALISATION({})** .
    
6. You can now animate the PaperRound machine by _"double-clicking"_ any of the operations that are listed there.
    
7. Note that **only operations that are enabled for the current state** are listed in this window.
    
8. Try all of the actions out & see what happens.

---

#### Exercise 1.6

Add an enquiry operation      ans <-- getsPapers( houseNumber )
that checks if the _housenumber_ has papers delivered to it.

If it does then it outputs the number 1.

**Hint:** this operation can be defined by combining:

- the "PRE-THEN-END" of the _addNewHouse( newHouse )_ operation,
    
- the condition to use in the "PRE" part is to check if newHouse is the correct type and that it is in the "houseNumbers".
    
- in the "THEN" part using the results variable "ans" like _numbHouses_ in the _howManyHouses_ operation.

---

#### Exercise 1.7

Add an operation      cancelPapers( houseNumber )
this cancels paper deliveries for thsi house by deleting house's number from the set of house numbers that are delivered to.

**Hint:** this operation can be defined by combining:

- Think about what must be true about the house number for it to be deleted. **(Pre-condition)**
    
- What effect should this operation have, i.e. what effect does it have. **(Post-condition)**
    
- This has the opposite effect to the _addNewHouse( newHouse )_ operation.

---

_Last updated: 2/10/2022_

---

_