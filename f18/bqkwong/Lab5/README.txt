------------------------
Lab 5: Subroutines
CMPE 012 Fall 2018
Kwong, Billy
bqkwong
-------------------------
What was your design approach?
My design approach was first to print out the prompt and the given string, and to 
start the timer using syscall 30. I then moved onto working on check_user_inout_string.
I then worked on printing out the user entered string, and figuring out how to get the total
elapsed time to see if the game is won or lost. I then moved on to checking each individual 
character bit to see if the user entered string matches the given string by creating a loop. 
If the next character is a null character, then the game will end and display the correct message.
I created a stack to save the stored values, so I can call back on it when needed.

What did you learn in this lab?
How to implement subroutines and use the stack to store values to call back on it later.
Learning to jump from registers and back.

Did you encounter any issues? Were there parts of this lab you found enjoyable?
FIguring out and keeping track of where my stack is and where in my program it is 
pointing at. 

How would you redesign this lab to make it better?
Overall the design of this lab is great. I felt like there was a good amount of time to 
work and solve this lab. Going to lab helped this lab out a lot.