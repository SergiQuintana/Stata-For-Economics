		*===============================*
		* 	STATA BRUSH UP COURSE
		*===============================*
		
		// Session 3
		
		cd "C:\Users\Sergi\Dropbox\PhD\Teaching\Third Year\Stata Course\Class Content\Class 3"
		
		use allstates, clear
		
*-----------------------------------------------------------------------------	

		// Graphs
		
		// Scatter
		
		help graph twoway scatter
		
		graph twoway scatter ownhome propval100
		
		* marker options
		
		graph twoway scatter ownhome propval100, msymbol(Sh)
		
		graph twoway scatter ownhome propval100, mcolor(maroon)
		
		graph twoway scatter ownhome propval100, msize(vlarge)
		
		graph twoway scatter ownhome propval100 [aweight=rent700], msize(small)
		
		graph twoway scatter ownhome propval100, mlabel(stateab)
		
		graph twoway scatter ownhome propval100, mlabel(stateab) mlabsize(vlarge)
		
		graph twoway scatter ownhome propval100, mlabel(stateab) mlabposition(12) // controls the label position wrt the dot
		
		graph twoway scatter ownhome propval100, mlabel(stateab) mlabposition(0) msymbol(i)
		
		* legend options
		
		* title options
		
		graph twoway scatter ownhome propval100, xtitle("Percent homes over $100K") ytitle("Percent who own home")
		
		graph twoway scatter ownhome propval100, ytitle("Percent who own home", size(huge))
		
		graph twoway scatter ownhome propval100, title("First graph")
		
		graph twoway scatter ownhome propval100, xlabel(0(10)100) ylabel(40(5)80)
		
		graph twoway scatter ownhome propval100, xlabel(#10) ylabel(#5)
		
		
		graph twoway scatter ownhome propval100, xlabel(#10) ylabel(#5, nogrid)

		graph twoway scatter ownhome propval100, xlabel(#10) ylabel(#5) yline(55 75)
		
		* combine multiple graphs
		
		graph twoway scatter ownhome propval100, by(nsw)
		
		* add some text
		
		graph twoway scatter ownhome propval100, text(47 62 "Washington, DC")
		
		graph twoway scatter ownhome propval100, text(47 62 "Washington, DC", size(large) margin(medsmall) blwidth(vthick) box)
				

		// Fitted line
		
		twoway (scatter ownhome pcturban80) (lfit ownhome pcturban80)
		
		
		twoway (scatter ownhome pcturban80) (lfit ownhome pcturban80) (qfit ownhome pcturban80)  // quadratic fit
		
		twoway (scatter ownhome pcturban80) (lfitci ownhome pcturban80) // confidence interval fit!
		
		// Line plots
		
		use spjanfeb2001, clear
		
		twoway line close tradeday
		
		twoway line close tradeday, sort
		
		twoway line close tradeday, sort clwidth(vthick) clcolor(maroon)
		
		twoway connected close tradeday, sort
		
		twoway connected close tradeday, sort msymbol(Dh) mcolor(blue) msize(large)
		
		twoway connected close tradeday, sort clcolor(cranberry) clpattern(dash) clwidth(thick)
		
		// Area plots
		
		twoway area close tradeday
		
		twoway area close tradeday, sort
		
		twoway area close tradeday, sort horizontal 
		
		twoway area close tradeday, sort base(1320.20)  // base from which the area is to be shaded
		
		// Bar plots
		
		twoway bar close tradeday
		
		twoway bar close tradeday, horizontal  // horizontal bar graph
		
		twoway bar close tradeday, barwidth(.7) // change the widht of the bars
		
		twoway bar close tradeday, bfcolor(gs15) blcolor(gs5)  // sets the color of the inside bars and the bar outlines.
		
		
		
		// Range plots
		
		
		twoway rconnected high low tradeday, sort
		
		twoway rarea high low tradeday, sort
		
		twoway rcap high low tradeday // spike range
		
		// Histogram
		use nlsw, clear
		
		twoway histogram ttl_exp, bin(10)
		
		twoway histogram ttl_exp, width(10)
		
		* can't set previous two at the same time!
		
		twoway histogram ttl_exp, start(-2.5) width(5)  // lower imit of the first bin starts at -2.5
		
		twoway histogram ttl_exp, fraction // now bars sum up to 1. 
		
		twoway histogram ttl_exp, gap(20) // gap between bars
		
		
		// Kernel density
		
		twoway kdensity ttl_exp
		
		twoway (histogram ttl_exp) (kdensity ttl_exp)
		
		
		// Matrix Scatters
		
		use allstates,clear
		
		graph matrix propval100 ownhome borninstate, msize(vlarge)

		graph matrix propval100 ownhome borninstate, xlabel(0(20)100, axis(1)) xlabel(0(20)100, axis(2)) xlabel(0(20)100, axis(3))  // edit different axis

		
		graph matrix propval100 ownhome borninstate, half // just half
		
		
		// Bar graphs 
		
		* using nlsw data
		
		use nlsw, clear
		
		graph bar prev_exp tenure ttl_exp // mean of the values
		
		graph bar (median) prev_exp tenure ttl_exp  // median
		
		graph bar (median) prev_exp tenure (mean) ttl_exp // combine both
		
		graph bar (mean) meanwage = wage (median) medwage = wage // different statistics of the same variable
		
		graph bar prev_exp tenure, over(occ5)  // graph over some variabe
		
		graph bar prev_exp tenure, over(occ5) stack 
		
		graph bar prev_exp tenure, over(occ5) percentages stack // normalize to 1
		
		graph hbar wage, over(occ5) // mean horizontal graphs
		
		graph hbar wage, over(urban2) over(occ5) over(collgrad) // we ca do it over many variables
		
		
		// Dot plots -- using nlsw data
		
		graph dot tenure, over(occ7)
		
		graph dot tenure, over(occ7) over(collgrad)  // we can include many overs
		graph dot (median) prev_exp tenure, over(occ7) over(collgrad) // we can change the statistic
		
		
		
		// Pie graphs -- using allstates
		
		use allstates, clear
		
		graph pie poplt5 pop5_17 pop18_64 pop65p // we can supply many variables
		
		graph pie pop, over(division)  // or one vaiable over another
		
		use nlsw, clear
		
		graph pie, over(occ7)  // or just over one variable
		
		graph pie, over(occ7) pie(3, explode)  // we can move a slice
		
		graph pie, over(occ7) pie(3, explode(5)) pie(1, color(gold) explode(2.5))  // we can apply different functions with different magnitudes. 
		
		
		graph pie, over(occ7) plabel(_all percent)
		
		graph pie, over(occ7) plabel(_all name)

		
			
		// Options 
		
		
		* change the look of graph regions
		
		use allstates, clear
		
		scatter propval100 ownhome, plotregion(color(stone))

		scatter propval100 ownhome, plotregion(lcolor(navy))
		
		scatter propval100 ownhome, graphregion(color(stone))

		// Save the graph
		
		graph save fig1, replace
		
		graph export "fig1.png",replace
		
		graph twoway scatter age pov

		graph save fig2, replace
		
		graph use fig1
		
		graph twoway scatter age pov, name(scat1)  // saves graph in memory
		
		graph twoway bar age pov, name(bar1)
		
		graph combine scat1 bar1
		
		graph combine scat1 bar1, ycommon
		
		// Options
		
		help linestyle // better use google!
		
		help markerstye
		
		// EXERCICES
		

		
		
		
		

		
		