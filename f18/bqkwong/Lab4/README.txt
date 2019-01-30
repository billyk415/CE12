------------------------
Lab 4: ASCII Decimal to 2SC
CMPE 012 Fall 2018
Kwong, Billy
bqkwong
-------------------------
What was your approach to converting each decimal number to two’s complement
form?
My approach for converting decimal number to two's complement was to -48 to the value 
to get the ASCII value. I checked if the number is a triple, double, or single digit 
number by checking if the number is greater than 100, from 10-99, and from 0-9, and if 
it was negative, vice versa. I created a bitmask for a loop that will check each individual
bit to print out.

What did you learn in this lab?
How to look at program arguments and where they are stored in memory. How to convert
ASCII characters to values. How to use a bitmask and make a loop to shift each bit over to 
look at each individual bit.

Did you encounter any issues? Were there parts of this lab you found enjoyable?
One of the first issues was figuring out how to print the second program argument 
onto the console. But then I figure you just offset it by 4 to get the next arguement. 
Next was figuring out how to load each byte and convert it but then all you had to do was look 
at the ASCII table to figure out how to convert. Creating a bitmask and making a loop to look at each bit
sounds easier than actually doing it, but after learning about shifts, it helped out for the loop.

How would you redesign this lab to make it better?
This lab requires a lot of time to understand and complete. Lab sections are very important 
for this lab, and all help is needed to succeed in this lab. I feel like this lab should be made 
just a bit easier and less time dependent, as many people have other priorities to attend to.
Especially with break coming up, and no lab sections to attend for help, it was really bad timing
and very stressful for this lab.