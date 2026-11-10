/* LibraryManagment
 * Author: Shahid.f
 * Creation date: 11/10/2026
 */
MACHINE
    LibraryManagment
    SETS
        BOOKS = {Chemistry, Biology, Physics, CombinedMaths, LesMiserables, Zoology, Botany, JaneEyre}
    VARIABLES
        availableBooks, borrowedBooks
    INVARIANT
        //availableBooks<:BOOKS & borrowedBooks<:BOOKS & availableBooks/<:borrowedBooks
        availableBooks <: BOOKS & borrowedBooks <: BOOKS & availableBooks /\ borrowedBooks = {}
    INITIALISATION
        availableBooks:=BOOKS || borrowedBooks:={}
    OPERATIONS
        borrowBook(book) = 
            PRE
                book:availableBooks & book: BOOKS
            THEN
                borrowedBooks:=borrowedBooks\/{book} ||
                availableBooks:=availableBooks - {book}
            END;
            
       returnBook(book) =
           PRE
               book:borrowedBooks & book: BOOKS
           THEN
               availableBooks:=availableBooks\/{book} ||
               borrowedBooks:=borrowedBooks - {book}
               
           END;
           
       value<--noOfBooksBorrowed = 
            BEGIN
                value:=card(borrowedBooks)
            END    
            
            
END
