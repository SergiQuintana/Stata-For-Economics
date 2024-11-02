		*===============================*
		* 	STATA BRUSH UP COURSE
		*===============================*
		
		// Session 2
		
*-------------------------------------------------------------------------------		
		// Import and Export Data
		
		cd "C:\Users\Sergi\Dropbox\PhD\Third Year\Stata Course\Class Content\Class 2"
		
		
		import delimited "auto.csv", clear
				
		/*		
		If the variable names were located on, for example, line 3, we would have specified varnames(3), and import delimited would have ignored the first two rows. If our file did not contain any variable names, we would have specified varnames(nonames).*/
		
		* import a subset of the data set
		
		import delimited "auto.csv", rowrange(2:4) colrange(1:4) clear
		
		* we can force variables to be of a specific type in case something is wrong
		
		 import delimited "auto.csv", numericcols(4) clear // numeric variables
		 
		 import delimited "auto.csv", stringcols(4) clear
		 
		 * export to a file
		 
		 export delimited "autonew.csv", replace
		 
		 * export just a subset
		 
		 export delimited in 1/5 using "autonew2.csv",replace
		
		* export to other formats
		
		export excel "auto.xls", replace
		
		help import excel
		// Excel
		
		* Some variables
		
		export excel make mpg weight using auto, replace
		
		export excel "auto.xls", replace
		
		* Exercice:
		
		export excel "auto.xls", firstrow(variables) replace
		
		import excel "auto.xls", firstrow clear
		
		import excel auto.xls, cellrange(:D70) firstrow clear // import a subrange
		
		
*-------------------------------------------------------------------------------

		// Missings and Duplicates
		
		webuse auto, clear
		
		ssc install mdesc
		
		mdesc
		
		search mvpatterns
		
		mvpatterns
		
		* duplicates
		
		 use "https://www.stata-press.com/data/r18/dupxmpl", clear
		 
		 duplicates report
		 
		 duplicates list
		 
		 duplicates tag, gen(tag)
		 
		 duplicates drop
		 
*-------------------------------------------------------------------------------

		// Logical operations
		
		webuse auto, clear
		
		tab price if rep78 == 5
		
		tab price if rep78 != 5
		
		tab price if headroom > weight
		
		tab price if headroom > 3
		
		replace rep78 = 0 if rep78 == . // substitute missings for 0
		
		tab price if !rep78  // logical negation rep78 == 0.
		
		* introduce multiple conditions
		
		tab price if rep78 == 5 & headroom > 3
		
		tab price if rep78 == 5 | headroom > 3
		
		tab price if rep78 != 5 & (headroom > 3 | headroom == 1)
		
		* Exercices:
		
		use data1, clear
		
		* 1
		
		table female if ethnicity == "white", stat(mean i.year_b)
		
		* 2
		
		keep if age < 43
		keep if female == 1
		
*-------------------------------------------------------------------------------

		// Variable Generation -- gen
		
		webuse auto, clear
		
		gen newvar = price+2
	
		gen newvar = 3
		
		gen newvar2 = price/mpg
		
		
		
		* We can use some math operations
		
		gen newvar5 = log(price+1)
		
		gen newvar6 = exp(price)
		
		
		* Generate variables and apply if conditions
		
		
		gen newprice = price + 2 if rep78 < 4  // the others will be missing. 
		
		
		* Show replace!!
		
		
		
		
*-------------------------------------------------------------------------------

		// Exercices Variable Generation
		
		
		
*-------------------------------------------------------------------------------
		
		
		* explicit subscripting:
		gen newvar3 = price[3]
		
		gen newvar4 = price[_n]
		
		* We can generate lags or leads
		
		
		gen price_lag = price[_n-1]
		gen price_lead = price[_n+1]
		
		* Generate indicator variables
		
		gen dummy1 = 0
		replace dummy1 = 1 if price > 3000
		
		gen dummy2 = (price>3000) 
		
		gen dummy2_2 = (price>3000 & price !=.)
		
		gen dummy3 = 3.rep78
		
		gen dummy3_2 = (rep78 == 3)  // be careful with missings!!!
		
		
		
*-------------------------------------------------------------------------------
		
		// Variable Generation -- egen
		
		egen total_rep = total(rep78)  // total of a variables
		
		egen max_price = max(price)    // returns maximum price
		
		egen max_rows = rowmax(mpg price)
		
		egen row_mean = rowmean()  // wathever
		
		egen row_total = rowtotal()
		
*-------------------------------------------------------------------------------

		// Combination with by!
		
*-------------------------------------------------------------------------------
		
		// Other Commands -- encode
		
		encode make, gen(producer)
		
		list i.make
		
		list i.producer
		
		

	*-------------------------------------------------------------------------------
		
		// Exercices -- Variable Generation
		
		
		
		
		
		
		* Exercices
		
		egen nhimpg = total(mpg > 30), by(rep78)
		
		
		
		* Exercices -- Second Part
		
		webuse census, clear
		
		
	*-------------------------------------------------------------------------------

		// Working with strings
		
		webuse auto, clear
		
		tostring price, replace
		
		destring price, gen(price_number)
		
		* substr
		
		gen new = substr(make,2,5)
		
		* subsint
		
		gen new2 = subinstr(make,"AMC","mercedes",1)
		
		* Exercices:
		
		use data1,clear
		
		encode ethnicity, gen(new)
		
		list i.new
		
		gen new2 = ethnicity*2
		
		* 
		
		replace new2 = subinstr(new2,"white","hello",1)
		
		* 
		
		gen new3 = substr(ethnicity,-2,2)

	*-------------------------------------------------------------------------------

		// Final Exercice
		
		use data1,clear
		
		
	*-------------------------------------------------------------------------------
		// Data Cleaning Case Study
		*(from https://ssc.wisc.edu/sscc/pubs/dws/data_wrangling_stata3.htm)
		
		
		use 2000_acs_sample, clear
		
		
		* First of all, describe the data!
		
		describe
		
		* It seems there is an excess of identifiers.... serial, serialno, pernum _pnum...
		* year might be unnecessary
		
		* why we want us200c in our variable names?
		
		
		* we have both hh weights and person weights, but this is unweighted..!?


		* why whould you label years?
		
		* what is the label of gq ?? 
		
		label list gq_lbl
		
		
		* analyze the variables
		
		browse
		
		* What can we see!?: 
		
		* 1. year and datanum always have same value
		* 2. weights are always 1000 since sample is unweighted
		* 3. pernum and us200c_pnum are identical
		* 4. pernum just counts observations
		* 5. all string variables contain mostly numbers
		* 6. some strings contain only numbers (sex, hispan, raece1, marstat)
		* 7. inctot sometimes has BBBBBBBB which means missings.
		
		* Find the Identifiers. Identifiers are variables that uniquely identify the data
		
		* we can find identifiers with duplicates
		
		duplicates report pernum  // it is not!
		
		tab pernum  // seems that it is kind of the identifier
		
		duplicates report serial
		
		duplicates report serial pernum   // we have found our identifiers!
		
		
		* Step 3 ! Get Rid of the Data We will not be using
		
		drop year datanum
		
		drop if qg== 3| gq == 4 
		
		* Change Variable Names
		
		rename pernum person
		
		* Get rid of the us200c_ prefix
		
		rename us2000c_* *
		
		* Step 4. Set the right data types!
		
		
		destring sex age hispanic race maritalStatus edu income, replace
		
		
		destring income, gen(income2) force  // bcs stata thinks is not a good idea
		
		* observations that could not be converted have a missing value
		
		tab income if income2 == . 
		
		
		* Use assert command to verify that a conditon is true for all observations
		
		assert real(pnum) == person   // we believe they are the same thing, but pnum is a string
		
		drop pnum
		
		codebook
		
		drop hhw perwt gq
		
		* Step 5. Recode indicator variables
		
		gen female = (sex==2) if sex<.
		tab sex female, miss
		
		
		* Step 6. Set the labels
		
		label define maritalStatusLabel ///
1 "Now married" ///
2 "Widowed" ///
3 "Divorced" ///
4 "Separated" ///
5 "Never married"

label values maritalStatus maritalStatusLabel
		
		tab maritalStatus
		
		
		* Step 7. Undestand the distribution of the data to see if it is ok
		
		* Income
		sum income
		
		* who is missing? what does negative means?
		
		sum age if income==.
		sum income if age<15
		
		
		count if income<0   // see who is below the income threshold!
		
		
		replace income = . if income < 0 
		
		
		
		* Educ
		
		tab edu, miss
		
		tab age if edu == 0 
		tab edu if age<3
		
		replace edu = . if edu == = 
		
		* Step 8. Analyze the missings
		
		
		missatble sum
		
		* maybe drop the missings? 
		
		
*------------------------------------------------------------------------------*

		// Exercice! Repeat the process for XXX
		
		*(https://ssc.wisc.edu/sscc/stata//dws/)
		