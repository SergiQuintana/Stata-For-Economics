		
		cd "C:\Users\Sergi\Dropbox\PhD\Third Year\Stata Course\Class Content\Class 4"
		
		
		// Append
		
		webuse even, clear
		
		save even, replace
		
		webuse odd, clear
		
		save odd, replace
		
		use even, clear
		
		append using odd
		
		clear
		
		append using even odd
		
		use autosize, clear
		
		merge 1:1 make using autoexpense
		keep if _merge== 3
		drop _merge
		
		use autosize, clear
		
		merge 1:1 make using autoexpense, assert(match)
		
		drop _merge
		merge 1:1 make using autoexpense, keep(match)
		
		use overlap1,clear
		
		list, sepby(id)
		
		merge m:1 id using overlap2, update
		
		
		***********
		
		webuse auto, clear
		
		preserve
		sample 20
		save sample1, replace
		restore
		
		preserve
		sample 20
		save sample2, replace
		restore
		
		preserve
		sample 20
		save sample3, replace
		restore
		append using sample3 sample1 sample2 
		
		*************************************
		
		webuse reshape1,clear
		
		reshape long inc, i(id) j(number)
		***************************
		webuse reshape6, clear
		
		list
		
		reshape wide inc ue,i(id) j(year)
		
		***************
		webuse reshape1, clear
		drop ue81
		
		reshape long inc ue,i(id) j(year)
		
		**************
		webuse reshape3,clear
		
		reshape long ue inc@r, i(id) j(year)
		
		list
		
		**********
		webuse reshape4, clear
		
		list
		
		reshape long inc,i(id) j(gender) string
		
		***********
		
		webuse abdata,clear
		
		preserve
		keep id wage year ind
		save abdata1,replace
		restore
		
		preserve
		keep id emp year
		save abdata2,replace
		restore
		
		use abdata1, clear
		
		merge 1:1 year id using abdata2, nogen
		
		save abdata_joint,replace
		
		use ccpi_a, clear
		
		keep if Code == "GBR"
		keep i* Code
		
		reshape long i,i(Code) j(year)
		
		drop Code 
		
		rename i inflation
		
		save ukinflation,replace
		
		use ukinflation, clear
		br
		
		merge 1:m year using abdata_joint, nogen
		* another way:
		use abdata_joint, clear
		
		merge m:1 year using ukinflation, nogen keep(match)
		
		reshape wide wage emp inflation, i(id) j(year)

		reshape wide w* emp* inflation*, i(id) j(ind)
		
		******************
		
		
		// Collapse
		
		webuse college, clear
		
		collapse gpa, by(year)
		
		webuse college, clear
		
		collapse (median) gpa, by(year)
		
		***************************
		
		webuse college,clear
		
		collapse gpa [fw=number],by(year)
		
		********
		webuse census5, clear
		
		describe
		
		collapse (mean) marmean = marriage_rate divmean = divorce (median) medianmarr = marriage_rate mediandiv = divorce ,by(region)
		
		*******
		
		webuse auto, clear
		
		collapse (mean) mpg price (max) length, by(rep78 foreign)
		
		drop if rep78 == . 
		
		
		reshape wide mpg price length, i(rep78) j(foreign)
		
		rename *0 *_domestic
		rename *1 *_foreign
		
		************************
		
		use acs_small,clear
		
		drop if educ == 999999
		drop if incwage == 999999
		graph twoway (lfit educ incwage) (scatter educ incwage), xtitle("in class graph")
		
		graph bar incwage, over(sex) over(race,label(angle(45))) asyvars nofill legend(position(1) row(1))
		
		keep if educ >= 7
		
		collapse inctot incwage, by(race sex degfield)

		reshape wide inctot incwage, i(sex degfield) j(race)
		
		reshape wide inctot* incwage*, j(sex) i(degfield)
		
		preserve
		keep degfield incwage*
		save middata,replace
		restore

		reshape long
		
		reshape long inctot incwage,i(sex degfield) j(race)
		
		merge m:1 degfield using middata, nogen
		
		
		
		
		
		
		
		