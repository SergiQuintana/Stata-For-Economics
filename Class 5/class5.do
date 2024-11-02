
		
		cd "C:\Users\Sergi\Dropbox\PhD\Third Year\Stata Course\Class Content\Class 4"



*-------------------------------------------------------------------------------
		
		// Regression
		
		* Basic Linear Regression
		
		webuse auto, clear
		
		regress mpg weight foreign // take a look at the regression output!
		
		REG EXAMPLE COLLINEARITY

		* We can supress the constant
		
		reg weight length, noconstant
		
		* We can have two constants
		
		reg weight length bn.foreign, hascons
		
		* We can include squares of variables: 
		
		regress mpg weight c.weight#c.weight
		
		* We can include dummies as well:
		
		regress mpg weight i.rep78
		
		* Interactions of dummies:
		
		regress mpg weight i.rep78#i.foreign
		
		* And we can combine it with the by option
		
		by foreign: regress mpg weight c.weight#c.weight
		
				
		* Replying prior results: 
		
		reg mpg weight displacement
		
		reg
		
		* Cataloging Estimation Results: We can store the elements of our model 
		
		regress mpg weight displacement
		
		estimates store r_base
		
		reg mpg weight displ foreign
		
		estimates store r_alt
		
		estimates dir   // dispay all estimtes
		
		estimates replay r_base
		
		estimates table _all 
		 
		estimates restore r_alt   // reload to memory another regression
		
		regress
		
		* Saving estimation results
		
		estimates save alt, replace
		
		estimates use alt // we can relload them in a new session
		
		* Specifying the estimation subsample
		
		regress mpg weight 5.rep78 if foreign  // equivalent to if foreign == 1
		
		* Now stata remembers the estimation subsampe and we can access it in another Stata command: 
		
		summarize mpg weight 5.rep78 if e(sample)
		
		* Specifying the width of the confidence intervals
		
		regress mpg weight displ, level(90)  // 90% confidence intervals
		
		* Obtaining the variance-covariance m atrix
		
		estat vce // displays covariances
		
		estat vce, corr // presents it as a coefficient table
		
		* Predicting values
		
		regress mpg weight c.weight#c.weight
		
		predict fitted // will predict fitted values
		
		predict blabla // notice the name is irrelevant. A new variable is created. 
		
		*For predict after linear regression, predict can calculate residuals, standardized residuals, Studentized residuals, influence statistics, etc
		
		predict residuals, resid // will predict the residuals
		
		* Accessing estimated coefficients
		
		regress mpg weight
		
		gen newvar = 3 + _b[weight]*weight 
		
		regress mpg weight c.weight#c.weight i.foreign#c.weight gear_ratio i.foreign#c.gear_ratio
		
		 gen asif=_b[weight]*weight + _b[c.weight#c.weight]*c.weight#c.weight + _b[gear_ratio]*gear_ratio + _b[_cons]
		 
*-----------------------------------------------------------------------------------

		// Performing Hyopthesis test on Coefficients (performs wald test!)
		
		gen weightsq = weight^2
		
		reg mpg weight weightsq foreign
		
		test weight weightsq // significance level (p-value) 0.000000 so we can reject
		
		

*-----------------------------------------------------------------------------------

		// Obtaining  Combinations of Coefficients
		
		
		* Linear combinations
		
		webuse regress, clear
		
		reg y x1 x2 x3
		
		lincom x2 - x1

		* Nonlinear 
		
		
		nlcom _b[x1]/_b[x2]
		
*-----------------------------------------------------------------------------------

		// Exercices -- Regressions 
		
		webuse nlswork, clear
		
		
		
		webuse auto, clear
		

		
*-----------------------------------------------------------------------------------

		// Obtaining Robust Variance Estimates
		
		gen gpmw = ((1/mpg)/weight)*100*1000   // efficiency of millaeg x weigth
		
		summarize gpmw
		
		reg gpmw foreign
		
		regress gpmw foreing, vce(robust)
		
		* The estimates are the same but the standard errors differ by 20%. 
		
		tab foreing, summarize(gpmw)  // there is noticable heteroskedasticity here. 
		
		* Alternative estimation
		
		regress gpmw foreign, vce(hc2)
		
*-----------------------------------------------------------------------------------
				
		// Clustered Data
		
		webuse regsmpl, clear
		
		regress ln_wage age c.age#c.age tenure
		
		/*Without a doubt, a woman with higher-than-average
wages in one year typically has higher-than-average wages in other years, and so the residuals are
not independent. One way to deal with this is to use cluster–robust standard errors. We do this
by specifying vce(cluster id), which treats only observations with different person ids as truly
independent:*/


		regress ln_wage age c.age#c.age tenure, vce(cluster id)
				

*-----------------------------------------------------------------------------------

		// Diagnostic Plots
		
		webuse auto,clear
		
		
		regress price weight foreign#c.mpg
		
		rvfplot, yline(0)  // allows to check for linearity assumption. There should be no pattern. Also the dispersion can show heteroskedasticity evidence. 
		
		regress price weight foreign##c.mpg
		
		avplot mpg  // Frisch-Waugh-Lovell Theorem 
		
		rvpplot mpg, yline(0)  // like the rvfplot but with predictors

*-----------------------------------------------------------------------------------		
		// Heteroskedastic Linear Regression
		
		help hetreg
		
		webuse foodexp, clear
		
		regress food_exp income
		
		rvpplot income, yline(0)
		
		estat hettest
		
		* Maximum Likelihood:
		generate double logincome = ln(income)
		hetregress food_exp income, het(logincome)
		
		* Two-step GLS Estimation:
		hetregess food_exp logincome, het(logincome) twostep

		
*-------------------------------------------------------------------------------

		// Exercices - Heteroskedasticity
		
		webuse salary, clear
		
		regress salary i.female##(c.priorexp c.yrrank c.yrbg c.salfac)

		
*-------------------------------------------------------------------------------

		// IV Regression
		
		webuse hsng, clear
		
		/* We have state data from the 1980 census on the median dollar value of owner-occupied housing
(hsngval) and the median monthly gross rent (rent). We want to model rent as a function of
hsngval and the percentage of the population living in urban areas (pcturban):
renti = β0 + β1hsngvali + β2pcturbani + ui
where i indexes states and ui
is an error term.
Because random shocks that affect rental rates in a state probably also affect housing values, we
treat hsngval as endogenous. We believe that the correlation between hsngval and u is not equal
to zero. On the other hand, we have no reason to believe that the correlation between pcturban and
u is nonzero, so we assume that pcturban is exogenous*/

		 ivregress 2sls rent pcturban (hsngval = faminc i.region)
		 
		 ivregress 2sls rent pcturban (hsngval = faminc i.region), first
		 
		 estat firststage

		// The first stage F statistic is high enough. We consider this a relevant instrument. 
		
		* Now using GMM
		
		ivregress gmm rent pcturban (hsngval = faminc i.region), wmatrix(robust)
		
*-------------------------------------------------------------------------------

		// Exercices -- Instrumental Variables
		

*-------------------------------------------------------------------------------

		// Time Series
		
		
		
		
*-------------------------------------------------------------------------------

		// Panel Data
		
		webuse nlswork, clear
		
		
		xtset idcode year  // the first thing we will do is set the panel dimensions. 
		
		* Notice that stata already tells us that we have an unbalanced panel. 
		
		
		xtdescribe   // Will provide information about how our dataset looks
		
		* Other methods are: 
		
		ssc install xtpatternvar
		
		xtpatternvar, gen(pattern)
		
		tab pattern  // we can see all the patterns in our data set. 
		
		// Estimation Methods
		
		* Fixed-Effects Model
		
		xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp tenure c.tenure#c.tenure 2.race not_smsa south, fe
		
		xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp tenure c.tenure#c.tenure 2.race not_smsa south, fe vce(robuts)  // include robust standard errors. 
		
		* Random-Effects Model
		
		 xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp tenure c.tenure#c.tenure 2.race not_smsa south, re
		
		xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp tenure c.tenure#c.tenure 2.race not_smsa south, mle   // we can also get it using maximum likelihoood estimation
		
		* Population-Averaged Model
		
		xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp tenure c.tenure#c.tenure 2.race not_smsa south, pa

			
		// Finally take a look at the documentation for stored results and estimation methods
		
		help xtreg
		
		// xtreg post-estimation commands: 
		
		*xttest --> test for the random effects hypothesis
		
		xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp tenure c.tenure#c.tenure 2.race not_smsa south, re theta
		
		xttest0

*-------------------------------------------------------------------------------

		// Other Commands for Panel Data
		
		* areg
		
		/* areg fits a linear regression absorbing one categorical factor. areg is designed for datasets with many groups, but not a number of groups that increases with the sample size*/
		
		webuse auto2
		
		reg mpg weight gear_ratio b5.rep78
		
		* The areg equivalent is: 
		
		areg mpg weight gear_ratio, absorb(rep78)  // the estimation is more efficient
		
		* reghdfe
		
		/* It improves areg since we can now absorb more than one variable and
		can grow with the dimension of the panel*/
		
		
		webuse nlswork, clear
        reghdfe ln_w grade age ttl_exp tenure not_smsa south , absorb(idcode year)
        reghdfe ln_w grade age ttl_exp tenure not_smsa south , absorb(idcode year occ)

		* Advanced options: 
		reghdfe ln_w grade age ttl_exp tenure not_smsa south , absorb(FE1=idcode FE2=year)  // save the fixed effects
		
		 reghdfe ln_w i.grade#i.age ttl_exp tenure not_smsa , absorb(idcode occ) // interactions in the independent variables 


         reghdfe ln_w grade age ttl_exp tenure not_smsa , absorb(idcode#occ) // interactions in the absorbed category
		 
		 help reghdfe // explore all the possible options!

*-------------------------------------------------------------------------------

		// IV Panel Data
	
		/* 'xtivreg' offers five different 2SLS estimators for fitting panel-data 
		   models in which some of the covariates are endogenous.  
		   These estimators are two-stage least-squares generalizations of simple 
		   panel-data estimators for exogenous variables. */
		
		/* For a moment, let's think of a production function with labor and capital
		   inputs, and let's instrument firm employment with average wages */

		webuse abdata, clear
		
		* Fixed-effects model
		xtivreg y k (n = w), fe


		* First-differenced model
		xtivreg y k (n = w), fd

		
		* Random effects model
		xtivreg y k (n = w), re

		 
*-------------------------------------------------------------------------------

		// Dynamic Panel Data Models
		
		DONT INCLUDE IT FOR NOW...
		
*-------------------------------------------------------------------------------

		// Exercices -- Panel Data
		
		use firm, clear
		
		* drop missings:
		drop if n==. | w==. | k==. | y==. 
		
		* drop duplicates: 
		sort firm year
		quietly by firm year: gen dup = cond(_N==1,0,_n)
	
		drop if dup > 1
		drop dup
		
		
		* generate the variables:
		
		xi, noomit prefix("di") gen i.firm
		*noomit tells STATA not to omit any firm of the data set.
				
		reg n k w y difirm_2-difirm_140
		
		reg n k w y i.firm
		
		* Now compare with 'xtreg, fe'. Results are equivalent
		xtreg n k w y, fe
*-------------------------------------------------------------------------------

		// Quantile Regressions
		
		webuse auto, clear
		
		help qreg

		* qreg
		qreg price weight length foreign
		qreg price weight length foreign, vce(r)


		* sqreg
		sqreg price weight length foreign, q(.25 .5 .75)

		* iqreg 
		iqreg price weight length foreign, q(.25  .75)

		*  bsqreg

		bsqreg price weight length foreign

		// Test for different effects across quantiles:
		sqreg price weight length foreign, q(.25 .5 .75)
		test[q25]weight = [q75]weight

		* Confidence interval for the difference in quantiles:
		lincom [q75]weight-[q25]weight

		* We can also directly estimate quantile differences:
		iqreg price weight length foreign, q(.25 .75)

		
*-------------------------------------------------------------------------------

		// Kernel Regressions


		webuse dui, clear


		* Estimate a kernel local-linear model
		npregress kernel citations fines

		describe *_*, fullnames

		* Estimate a kernel local-constant model
		npregress kernel citations fines, estimator(constant)


		// We can change the bandwidth for the mean or for the derivatives

		// bw -> 2 for each indepvar
		// meanbwidth -> 1 for each indepvar
		// derivbwidth -> 1 for each indepvar


		npregress kernel citations fines,derivbwidth(0.003,copy)

		npregress kernel citations fines i.college, meanbwidth (0.1 0.2,copy)

		// We can identify observations violating the identification assumption!


		// We can supress the derivative estimate

		npregress kernel citations fines, noderivatives
		
		
		
*-------------------------------------------------------------------------------

		// Logit and Probit
		
		webuse auto, clear
		
		// Logit
		
		logit foreign weight mpg
		
		* use margins
		
		* marginal effects can be at means, at values and we can also have the man of margina effects.
		
		margins, dydx(*) atmeans  // average marginal effects
		
		margins, atmeans // average values
		
		margins, dydx(*) at(weight=3)
		
		margins, dydx(*)  // average marginal effects.
		
		
		* use predict
		
		// Probit
		
		probit foreign weight mpg
		
		margins 

*-------------------------------------------------------------------------------
		
		// Margins
		
		webuse margex, clear
		
		reg y i.sex i.group
		
		margins sex // the numbers in margin are the av of y for each group. 
		
		* now after a logistic regression
		
		logistic outcome i.sex i.groups
		
		margins sex
		
		margins sex, atmeans  // predicted probabilities at the means of the covariates
		
		margins sex group // we can report many margins in the same command
		
		* margins with interaction terms
		
		logistic outcome i.sex i.groups sex#group
		
		margins sex group
		
		* margins with continuous variables
		
		logistic outcome i.sex i.group sex#group age
		
		margins sex gropu // if we dont include the continuous
		
		margins sex group age // if we include the continuous
		
		margins, at(age=40)  // at a specific values
		
		margins, at(age=(30 35 40 45 50))
		
*-------------------------------------------------------------------------------

		// There are other families of models like multinomial logit or probit, nested,...
		
		
*-------------------------------------------------------------------------------

		// Exercices -- Other Estimation Methods
		
		webuse nlswork, clear
		
		keep if year == 70
		
		qreg ln_wage tenure wks_ue
		
		sqreg ln_wage tenure wks_ue, q(.25 .5 .75) 
		
		// Test for different effects across quantiles:
		sqreg  ln_wage tenure wks_ue, q(.25 .5 .75)
		test[q25]tenure = [q75]tenure
		
		npregress kernel ln_wage tenure wks_ue
		
		logit nev_mar age ln_wage i.race
		
		margins i.race, atmeans
		marginsplot
		
*-------------------------------------------------------------------------------

		// Coefplots
		
		webuse auto,clear
		
		reg price mpg trunk length turn
		
		coefplot, drop(_cons) xline(0)
		
		coefplot, vertical drop(_cons) yline(0)
		
		* we can also keep just some variables
		
		mlogit rep78 mpp i.foreign if rep>=3
		
		coefplot, nolabel drop(_cons) keep(*:) omitted baselevels
		
		* we can also plot multiple models
		
		reg price mpg trunk length turn if foreign == 0
		
		est store model1
		
		reg price mpg trunk length turn if foreign == 1
		
		est store model2
		
		coefplot model1 model2, drop(_cons) xline(0)
		
*-------------------------------------------------------------------------------

		// Post-Estimation Tables
		
		ssc install estout
		
		help esttab
		
		webuse auto,clear
		
		reg price weight mpg
		
		est store model1
		
		reg price weight mpg foreign 
		
		est store model2
		
		esttab model1 model2  // creates the table
		
		
		esttab mode1 model2, se // include standard errors
		
		esttab model1 model2, p scalars(F df_m df_r) // include p vaue and degrees of freedom
		
		esttab model1 model2, wide // coeffs and stats by side
		
		esttab model1 model2, label title("Regressions Auto Data") mtitles("Model 1" "Model 2") nonumbers addnote("Source: auto.dta")
		
		* Exporting
		
		esttab model1 model2 using table1.xls, replace // excel
		
		esttab model1 model2 using table1.rtf, replace // word
		
		esttab model1 model2 using table1.rtf, append wide label modelwidth(8)
		
		esttab model1 model2 using table1.rtf, append nogaps
		
		esttab model1 model2 using table1.tex, label nostar 
		* more here: https://repec.sowi.unibe.ch/stata/coefplot/getting-started.html#h-3
		
*-------------------------------------------------------------------------
	 
	 /* Sources:
	 
	 https://www.stata.com/manuals13/u20.pdf#u20Estimationandpostestimationcommands