**6SENG005W Formal Methods**

**Week 05 Tutorial: Functions in B**

#### Introduction

  

These tutorial exercises refer to the notes for the **Week 04 Lecture**.

In this tutorial we will use a B machine that represents a _family_ and illustrates how functions can be used in a specification.

The _Family_ specification is given in the Family.mch B machine.

It includes information about a family:

- the _family members_,
- for each family member their _age_ and _sex_.

The specification also has the following operations:

- For someone to have a birthday -- HadBirthday.
- For some female to have a baby -- HadABaby.
- For someone to die, that is no longer be a member of the family - PersonDies.
- An enquiry that tests if there is someone in the family with a particular sex, - DoesAFamilyMemberHaveThisSex.

## Exercise 5.1

1. Make sure you know the relevant lecture contents, including the **AMN versions of the Functions symbols**.
2. See **ProB's** "Help" menu and the pdf notation summary.

## Exercise 5.2

Create a new B "Project" using Atelier B, then create a new "Component" and then paste the _Family_ into it.

Complete the operations HadABaby, PersonDies and DoesAFamilyMemberHaveThisSex, then make sure that there are no errors.

## Exercise 5.3

Load the Family machine specification into **ProB.**

Animate it and execute the four operations:

 
      HadBirthday
 
      HadABaby
 
      PersonDies
 
      DoesAFamilyMemberHaveThisSex
 
 

Test both the _successful_ and _error_ cases of the operations.

After executing each operation **check** how the state has been modified.

Do this by use **ProB**'s "Eval" terminal to check the values of the three state variables that make up the state.

Also use the "Eval" terminal to test the truth value of each operation's:

- _precondition_
- IF statement _conditions_.

## Exercise 5.4

Add a mapping to the Family's state that maps an individual to their _unique_ Passport number.

Use the PASSPORT_NUMBER constant to represent the type of these numbers.

The mapping's _properties_ must be defined, and it should be initialised as appropriate.

## Exercise 5.5

Add an operation for a family member getting their _first_ passport - FirstPassport.

This operation inputs a person and a _unique_ passport number for the person's new passport.

If the person is not a family member or the passport number has already been assigned to a family member then it should report an error. Add appropriate reporting messages to the REPORT set.

Test all of the cases of the FirstPassport operation.

## Exercise 5.6

Add a similar operation but this one is when a family member is _renewing_ their passport - RenewPassport.

This operation inputs a person and a new _unique_ passport number, provided the person is a family member, already has a passport then their passport number is changed to the new number.

If the person is not a family member or the passport number is already in use by a family member or the person doesn't have a passport then it should report an error.

Test all of the cases of the RenewPassport operation.

## Exercise 5.7

Add a relation _parentOf_ to the _Family_ state that relates each family member to their children.

So for example, if _Grandad_ is _Paul_'s dad then the maplet

	Grandad |-> Paul
 

would be a member of the _parentOf_ relation, i.e.

	Grandad |-> Paul : parentOf

This relation should be initialised as appropriate.

This will be updated when the HadABaby operation is successful, then it needs to be updated with the new mother/baby relationship.

And when someone in the family dies they need to be removed from the relation, both as a parent (in domain) and as a child (in the range).

## Exercise 5.8

Add a function _myMum_ to the _Family_ state that maps a person to their mother, if still alive.

What kind of function should this be?

Consider each of the possible options and think about what the implications are of each one in relation to the family. (Make a note of your conclusions.)

So for example, if _Mary_ is _Joe_'s mum then the maplet

	Joe |-> Mary
 

would be a member of the _myMum_ function.

This function should be initialised as appropriate.

This will be updated when the HadABaby operation is successful, then it needs to be updated with the new mother/baby relationship.

And when someone in the family dies they need to be removed from the function, both as a child (in domain) and as a parent (in the range).

## Exercise 5.9

Add an enquiry HasChildren to test if a family member has any children.

This enquiry inputs a person's name and tests if they have any children, if they do it outputs _yes_, if not then it outputs _no_. Finally if they are not a family member then it replies _Do not know_.

Test all of the cases of the HasChildren operation.