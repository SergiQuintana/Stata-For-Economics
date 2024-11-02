		*===============================*
		* 	STATA BRUSH UP COURSE
		*===============================*
		
*-------------------------------------------------------------------------------		
		// How to comment do files
		
		// We can use this
		
		/* We can also
		use this */
		
		* and finally, this

*-------------------------------------------------------------------------------		
		// Very basics
		
		set
		
		set more off, permanently
		
		help help
		
		help maxvar

*-------------------------------------------------------------------------------

		// Managing memory size
		
		memory
		
		compress

*-------------------------------------------------------------------------------
		// Example Syntaxt
		
		use "https://www.stata-press.com/data/r18/census12", clear
		
		webuse census12, clear
		
		* SHOW IN SCREEN HOW IT LOOKS LIKE! HOW TO BROWSE ETC
		
		describe   // use it every time we open a new data set
		
		summarize
		summarize marriage_rate divorce_rate
		
		* summarize using by varlist:
		
		by region: summarize marriage_rate divorce_rate
	
		sort region // data needs to be sorted
		
		by region: summarize marriage_rate divorce_rate
		
		bysort // merges sort and by
		
		bysort () // uses brakets. 
		
		* summarize using the if expression:
		
		summarize marriage rate divorce rate if region=="West"
		
		* we can include more than one expression
		
		summarize marriage_rate divorce_rate if region == "West" & marriage_rate > .015  // both must be true. 
		summarize marriage rate divorce rate if region=="West" | marriage rate>.015  // one or the other are true 
		
		* We can combine the different possible arguments
		
		by region: summarize marriage_rate divorce_rate if marriage_rate>.015
		
		* using the in range
		
		summarize marriage_rate divorce_rate in 5/25
		
		* using options
		
		help summarize
		
		summarize marriage_rate, detail
		
*-------------------------------------------------------------------------------

		// Quietly and abbreviation rules
		
		help summarize
		
		qui: summarize
*-------------------------------------------------------------------------------
		
		// Variables 
		
		summarize state*
		
		summarize *_rate
		
		summarize *ia*
		
		encode state, gen(state_new)  // forget about this!
		
		list i.state_new	
		
*-------------------------------------------------------------------------------
		
		// Managing packages
		*********************
		net from "https://www.stata.com"
		ssc install mads
		
		*sometimes package names can be not intuitive
		search reghdfe
		
		*finally we might want to install packages manually 
		sysdir
*-------------------------------------------------------------------------------		
		// Saving the output
		*********************
		
		log using session1, replace
		
		summarize
		
		log off
		
		summarize state
		
		log on
		
		log close
		
		translate session1.smcl session1.pdf, replace
*------------------------------------------------------------------------------
		
		// Stata initial commands
		**************************
		
		pwd  // show the current working directory
		dir  // see files inside a directory
		cd "C:\Users\Sergi\Dropbox\PhD\Third Year\Stata Course\Class Content\Class 1" // change the working directory
		
		mkdir "folder1" // create a new directory
		
*-------------------------------------------------------------------------------		
		// Basic data reporting
		************************
		
		* list
		
		list in 1/5
		
		list state
		
		list state,table
		
		list state in 1/7, noobs  // supress the number of obvservations
		
		list state median_age in 1/10, divider separator(2)
		
		* describe
		
		describe state marriage_rate
		
		describe, simple
		
		describe, replace  // creates a new data set. 
		
		* codebook
		
		codebook state
		
		codebook state,header
		
		codebook state, detail
		
		* browse
		
		browse state
		
		* count
		
		count  // counts the number of observations
		
		* inspect
		
		inspect state
		
		inspect pop
		
		* table
		
		table state
		
		use "https://www.stata-press.com/data/r17/auto", clear

		table rep78, statistic(min mpg) statistic(max mpg)
		
		table rep78, statistic(mean mpg price)
		
				
		* tabulate
		
		tabulate rep78   // one-way tabulation
		
		tabulate rep78 make  // two-way tabulation
		
		bys headroom: tabulate rep78 make  // three-way tabulation
		
		* summarize
		
		summarize rep78
		
*-------------------------------------------------------------------------------

		// Exercices 1 solution
		
		use "https://www.stata-press.com/data/r17/auto", clear
		
		* 1
		
		compress
		
		describe
		
		* 2
		
		list price mpg in 1/5, divider
		
		* 3
		
		codebook rep78
		
		tab rep78
		
		* 4 
		
		table headroom, statistic(mean price) statistic(sd price)
		
		table headroom rep78, statistic(mean price) statistic(sd price)
*-------------------------------------------------------------------------------		

		// Basic data operations
		************************
		
		* sorting 
		
		sort rep78 make
		
		* ordering 
		
		order rep78 mpg price
		
		* renaming
		
		rename price monetary_price
		
		* labeling
		
		label variable monetary_price "Price of the vehicle"
		
		label list // list of existing data labels
		
		label define rep 1 "very few" 2 "few" 3 "normal" 4 "quite" 5 "a lot"
		
		label values rep78 rep
		
		* drop
		
		drop rep78 make
		
		* keep
		
		keep monetary_price mpg
		
		* correlate
		
		correlate monetary_price mpg
		
*-------------------------------------------------------------------------------

		// Exercice 2
		
		use data1, clear
		
		describe
		
		compress
		
		
		* 2
		
		list 1961.year_b in 1/20
		
		* compute the fraction of individuals born each year by gender
		
		table female, stat(mean i.year_b)
		
		* display the amount of individuals that are born each year, and do it by ethnicity
		
		bys ethnicity: tab year_b
		
*-------------------------------------------------------------------------------
		
		// Preserve and Restore
		************************
		
		preserve
			describe, replace
		restore
*-------------------------------------------------------------------------------		
		// Dealing with time
		*********************
		
		use "https://www.stata-press.com/data/r18/datexmpl2", clear
		
		list
		
		generate double dt = clock(timestamp, "# MD hms # Y")
		
		list id dt action
		
*-------------------------------------------------------------------------------	
		// Dealing With Errors
		
		help error
		
		do myfile, nostop
		
		help capture
		
		
		
		
		
		
		
		