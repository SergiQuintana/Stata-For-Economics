		
		
		cd "C:\Users\Sergi\Dropbox\PhD\Teaching\Third Year\Stata Course\Class Content\Class 6"
		
*-------------------------------------------------------------------------------

		// Macros
		
		webuse auto,clear
		
		* Local Macros
		
		local shortcut "make price rep78"
		
		* to access the content of the local we type ''
		
		list `shortcut'
		************************************
		
		local shortcut "make price rep78"
		local mynumber = 3
		di "`mynumber'"
		
		local sergi "list"
		
		`sergi' `shortcut'
		
		describe  `sergi'
		
		global varlist "make price rep78"
		
		list $varlist
		
		
		// IMPORTANT! Stata forgets about the locals every time the code stops running. Stata does remember the globals for all our session!
		
		local mynumber "3"
		
		di `mynumber'
			
		di 3   // those are equivalent
		
		
		* Globals are used to deal with many directories
		
		global path "C:\Users\Sergi\Dropbox\PhD\Third Year\Stata Course\Class Content\Class 6"
		
		global data "C:\Users\Sergi\Dropbox\PhD\Third Year\Stata Course\Class Content\Class 1"
		
		global figures "C:\Users\Sergi\Dropbox\PhD\Third Year\Stata Course\Class Content\Figures"
		
		
		use "$data\data1", clear
		
		reg earnings exp tenure age
		
		coefplot
		graph export "$figures\fig1.png",replace
		
		
*-------------------------------------------------------------------------------

		*********************
		
		local class "class1 class2 class3"
		
		display "`class'"

		local sentence "We are all tired of Sergi"

		display "`sentence'"
		
		display `sentence'
		
		display We are all tired of Sergi
		
		display "We are all tired of Sergi"
		
		
		local myvariables "make price"
		
		display `myvariables'
		
		display "`myvariables'"
		
		

		// Loops : forvalues
		
		forvalues i=1/5{   // will go one by one
			
			display `i'			
		}
		
		forvalues i=50(10)100{  // we can go 10 by 10
			
			display `i'
		}
		
		forvalues i=50(-2)0{   // we can go backwards
			
			display `i'
		}
		
		
		forvalues i = 5 10 : 25{  // change it to 26
			
			display `i'
		}
		
		
		forvalues number = 1/3{   // how to interact with the loop
			
			local newnumber = `number'*10
			
			display `newnumber'
		}
		
		forvalues i = 1(1)3 {    // how the loop works
			display "Top of loop i = `i'"
			local i = `i' * 10
			display "After change i = `i'"
		}
		
		
		
		


*-------------------------------------------------------------------------------

		// Loopos: foreach
		
		
		foreach name in "asf" "askdjas" "dsjfsd"{
			
			display length("`name'")  // important to include "".  show without
		}
		
		local grains "rice wheat flax"
		global grains "sdlfkjsd sdkfj skdfj"
		
		foreach ivan of local grains{
			
			display "`ivan'"
		}
		
		webuse auto,clear
		
		foreach var of varlist pri-rep t*{
			
			sum `var'			
		}
		
		foreach var of newlist z1-z4{   // will verify those are valid variable names but will not create them!
		
			gen `var' = 3
			
		}
		
		foreach var of numlist 1/4 6 231{
			
			di `num'
		}
		
		
*-------------------------------------------------------------------------------

		// While Loop
		
		local i = 10
		
		while `i' > 0 {
			
			di `i'
			local i = `i' - 1
		}
		
*-------------------------------------------------------------------------------

		// If and else statements
		
		local i = 10
		
		while `i' > 0 {
			
			di `i'
			
			if `i' > 5{
				
				di "greater than 5"
			}
			else if `i' == 5 {
				
				di "now we are 5!!"
			}
			else{
				di "smaller than 5"
			}
			
			local i = `i' - 1
		}
		
*-------------------------------------------------------------------------------

		// Break statement
		
		forvalues x = 1(1)4 {
			 if mod(`x',2) {
			 display "`x' is odd"
			 display "Hello"
			 }
			 else {
			 display "`x' is even"
			 }
		}
		
		forvalues x = 1(1)4 {  // continue will ignore statements afeter
			 if mod(`x',2) {
			 display "`x' is odd"
			 continue
			 display "Hello"
			 }
			 else {
			 display "`x' is even"
			 }
		}
		
		forvalues x = 1(1)4 {   // continue, break will stop the loop
			 if mod(`x',2) {
			 display "`x' is odd"
			 continue, break
			 display "Hello"
			 }
			 else {
			 display "`x' is even"
			 }
		}
		
*-------------------------------------------------------------------------------
		
		// Programs
		
		* syntax is: 
		/* program programname {
			
			whatever the program does
			
			end
			
		}
		*/
		
		capture program drop *
		
		program whatsmyname
		
			display "My name is Sergi"
		
		end
		
		whatsmyname
		
		capture program drop whatsmyname
		
		program whatsmyname
		
			args name
			
			display "My name is `name'"
		end
		
		whatsmyname "sergi"
		
		* program to generate a variables
		
		program genvars
		
			args oldvar newvar
			
			gen `newvar' = `oldvar' + 2
			
		end
		
		webuse auto, clear
		
		genvars price
		
		genvars price price_plus_two

*-------------------------------------------------------------------------------

		// Introduction to mata
		
		* open mata
		
		mata
		
		end // end mata here
		
		* sum
		
		mata
		
		2+2
		
		x = 2+3  // create a variable
		
		x
		
		end
		
		// Matrix Operators
		
		* Column and row join
		
		1,2 // matrix of one row and two columns
		
		1\2 // matrix with two rows and one column
		
		1,2\3,4 
		
		* we can put parenthesis to make our code more readable
		
		(1,2\3,4)
		(1,2)\(3,4)
		
		// Range Operators
		
		1..3 // a serie starting from the number on the left to the one on the right
		
		1.2..3.5 // we can do it with decimal numbers as well
		
		// Variables
		
		x = 3,4
		y = 5,6
		z = (1,2)\x\y
		
		// Operations
		
		x = (1,2)\(3,4)
		y = (1,2)\(4,4)
		
		x+y
		x.y
		
		x*y
		x:*y
		
		// Logical Operators
		
		x==y
		x>y
		x<y
		z=(1,2)\(3,5)
		x==z
		
		// Subscripting
		
		
		z = x[1,1]
		
		x[1,1] = 5
		
		x[.,1] // everything
		
		x[1,] // or just leave it blank
		
		
		// Move data from Stata to Mata
		
		end
		
		webuse auto, clear
		
		l in 1  // list the first observation
		
		mata
		_st_data(1,2)  // get the price of the first car
		
		_st_sdata(1,1)  // use it for strings
		
		_st_data(1,st_varindex("mpg"))  // look for variable names
		
		x = st_data(1,(2,4)) // store as matrix
		
		* we can do it more efficienty! st view
		
		st_view(x,.,.)
		st_view(n=0,1,(2,4))
		
		// Add new variables
		
		st_view(mpg=0,.,"mpg")  // the matrix mpg is now a view of all rows of the mpg variable
		
		* Generate a new variables
		
		st_view(weight=0,.,"weight")
		
		pmg = weight:*mpg
		
		st_addvar("long","pmg")
		
		st_store(.,"pmg","pmg")
		
		// Saving and Loading Mata Data
		
		*mata matasave filename matrixlist
		
		*mata matause filename
		
		// Matrix Functions
		
		I(2) // identity matrix
		I(4,3) // only diag 1s
		
		J(3,3,0)  // matrix of constants--> n rows, n columns, constant
		
		J(2,3,"a")
		
		e(1,3)  // unit vectors. row vectors with a one in one column and zeros everywhere. locations one, size vector
		
		* Example: 
		
		e(1,3)\e(2,3)\e(3,3)  // create the identity matrix
		
		uniform(5,5)  // draws from the 0 1 uniform distribution
		
		
		x = (2,1)\(1,3)\(1,2)
		
		sort(x,1)  // matrix to sort, columns to sort by
		
		// Sizes of matrices
		
		rows(x)
		
		cols(x)
		
		length(x)
		
		// Descriptive Statistics
		
		sum(x)
		rowsum(x)
		colsum(x)
		
		max(x)
		min(x)
		
		rowmax(x)
		
		mean(X)
		
		variance(x)
		correlation(x)
		


				
*-------------------------------------------------------------------------------		
		
		
		
		
		
		
		
		