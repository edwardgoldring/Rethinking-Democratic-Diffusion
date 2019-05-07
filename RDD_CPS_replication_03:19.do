*******************************************
*** Rethinking Democratic Diffusion
*** Comparative Political Studies
*** Replication Materials
*******************************************


*cd ""
use "RDD_CPS_replication", clear


***************************************************************
*** Correlation of regime and geographic spatial lag variables
//footnote 14
corr geog_cont_aut_fail_lag regime_aut_fail_lag
***************************************************************


***************************************************************
*** Table 2: autocratic breakdowns of regime type v. geography
***************************************************************
* Model 1
logit gwf_fail geog_cont_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat
* Model 2
logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat
* Model 3
logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag interaction_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat


**************************************************
*** Figure 2: probability of autocratic breakdown
**************************************************
set seed 135798642
estsimp logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)

foreach v in x mn lo hi {
	gen `v' = .
}

local b = 1

setx mean
setx (intrastate_war_1000_robust inter_state_war former_anglo_colony regime_aut_fail_lag) 0
qui foreach x of numlist 0(1)6 {
	setx regime_aut_fail_lag `x'
	simqi, genpr(pr) prval(1)
	
	sum pr, meanonly
	local mn = r(mean)
	replace mn = `mn' in `b'
	
	_pctile pr, p(2.5 97.5)
	local lo = r(r1)
	local hi = r(r2)
	replace lo = `lo' in `b'
	replace hi = `hi' in `b'
	
	replace x = `x' in `b'
	
	drop pr
	local b = `b' + 1
}

set scheme s2color
grstyle init
grstyle set noextend
grstyle color background white
grstyle anglestyle vertical_tick horizontal
grstyle color major_grid gray
grstyle linewidth major_grid thin
grstyle yesno grid_draw_min yes
grstyle yesno grid_draw_max yes
grstyle linepattern major_grid dot

twoway rcap hi lo x, lstyle(ci) || ///
	scatter mn x, mstyle(p1) ///
	ytitle("Pr({it:y}=Autocratic breakdown)") ///
	xtitle("{it:Similar regime autocratic breakdown (lag)}") ///
	xlabel(0(1)6) ///
	legend(position(6) order(1 "95% confidence intervals" 2 "Probability of Autocratic Breakdown") cols(2)) ///
	name(twoway, replace)

hist regime_aut_fail_lag, percent xtitle("{it:Similar regime autocratic breakdown (lag)}") xlabel(0(1)6) fysize(30) barwidth(0.5) ytitle("% of observations") title("Number of similar regimes that broke down in the prior year") name(hist, replace)
graph combine twoway hist, cols(1) xcommon note("{it:Notes}: Predicted probability of {it:Autocratic breakdown} is calculated after estimating Model 2." "All other variables held at their mean (continuous) and mode (binary).", size(small))

foreach v in x mn lo hi {
	drop `v'
}


**********************************************
*** Table 3: changes in predicted probability
**********************************************
quietly logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)

* median to 95th percentile (similar regime autocratic breakdown lag)
qui prvalue, x(regime_aut_fail_lag=1 intrastate_war_1000_robust=0 inter_state_war=0 former_anglo_colony=0) rest(mean) save
prvalue, x(regime_aut_fail_lag=3 intrastate_war_1000_robust=0 inter_state_war=0 former_anglo_colony=0) rest(mean) diff
* percent change
di (.0162/.0376)*100

* median to largest value (similar regime autocratic breakdown lag)
qui prvalue, x(regime_aut_fail_lag=1 intrastate_war_1000_robust=0 inter_state_war=0 former_anglo_colony=0) rest(mean) save
prvalue, x(regime_aut_fail_lag=6 intrastate_war_1000_robust=0 inter_state_war=0 former_anglo_colony=0) rest(mean) diff
* percent change
di (.0531/.0376)*100

* median to 95th percentile (geographic neighbor autocratic breakdown lag)
qui prvalue, x(geog_cont_aut_fail_lag=0 intrastate_war_1000_robust=0 inter_state_war=0 former_anglo_colony=0) rest(mean) save
prvalue, x(geog_cont_aut_fail_lag=1 intrastate_war_1000_robust=0 inter_state_war=0 former_anglo_colony=0) rest(mean) diff
* percent change
di (.0021/.0375)*100

* median to largest value (geographic neighbor autocratic breakdown lag)
qui prvalue, x(geog_cont_aut_fail_lag=0 intrastate_war_1000_robust=0 inter_state_war=0 former_anglo_colony=0) rest(mean) save
prvalue, x(geog_cont_aut_fail_lag=2 intrastate_war_1000_robust=0 inter_state_war=0 former_anglo_colony=0) rest(mean) diff
* percent change
di (.0044/.0375)*100


************************************************************************************
*** Number of observations with 6 similar autocratic reimg eneighbors breaking down
************************************************************************************
logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
tab regime_aut_fail_lag if e(sample), m
* 36 observations


**************************************************************
*** Table 4: democratic diffusion of regime type v. geography
**************************************************************
* Model 4
logit democratization geog_cont_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat
* Model 5
logit democratization regime_trans_lag geog_cont_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat
* Model 6
logit democratization regime_trans_lag geog_cont_trans_lag interaction_dem_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat


*********************
*********************
*** Appendix B
*********************
*********************


********************************
*** Table 6: Summary Statistics
********************************
quietly logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity if e(sample), det
tab gwf_fail if e(sample), m
tab intrastate_war_1000_robust if e(sample), m
tab inter_state_war if e(sample), m
tab former_anglo_colony if e(sample), m

quietly logit democratization regime_trans_lag geog_cont_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum democratization regime_trans_lag geog_cont_trans_lag if e(sample), det
tab democratization if e(sample), m

quietly logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_150_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum geog_cont_aut_fail_150_lag if e(sample), det

quietly logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_400_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum geog_cont_aut_fail_400_lag if e(sample), det

quietly logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag gwf_duration log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum gwf_duration if e(sample), det

quietly logit democratization regime_trans_lag geog_150_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum geog_150_trans_lag if e(sample), det

quietly logit democratization regime_trans_lag geog_400_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum geog_400_trans_lag if e(sample), det

quietly logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag interaction_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum interaction_aut_fail_lag if e(sample), det

quietly logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_150_lag interaction_aut_fail_150_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum interaction_aut_fail_150_lag if e(sample), det

quietly logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_400_lag interaction_aut_fail_400_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum interaction_aut_fail_400_lag if e(sample), det

quietly logit democratization regime_trans_lag geog_cont_trans_lag interaction_dem_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum interaction_dem_lag if e(sample), det

quietly logit democratization regime_trans_lag geog_150_trans_lag interaction_dem_150_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum interaction_dem_150_lag if e(sample), det

quietly logit democratization regime_trans_lag geog_400_trans_lag interaction_dem_400_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
sum interaction_dem_400_lag if e(sample), det


***********************************
*** Testing for serial correlation
***********************************
* Autocratic breakdown
xtset cowcode year
xtserial gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity

* Democratization
xtserial democratization regime_trans_lag geog_cont_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity


******************************************************************
*** Table 7: robustness tests with different levels of contiguity
******************************************************************
* Autocratic breakdown
* Model 7
logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_150_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat
* Model 8
logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_400_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat

* Democratization
* Model 9
logit democratization regime_trans_lag geog_150_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat
* Model 10
logit democratization regime_trans_lag geog_400_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat


********************************************************************
*** Table 8: robustness test with geographical spatial lag excluded
********************************************************************
* Autocratic breakdown
* Model 11
logit gwf_fail regime_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat

* Democratization
* Model 12
logit democratization regime_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat


**************************************
*** Table 9: duration robustness test
**************************************
* Autocratic breakdown
* Model 13
logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag gwf_duration log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat

* Democratization
* Model 14
logit democratization regime_trans_lag geog_cont_trans_lag gwf_duration log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat


*********************************************
*** Table 10: annual dummies robustness test
*********************************************
* Autocratic breakdown
* Model 15
logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity i.year, cluster(cowcode)
fitstat
testparm i(1962/2010).year

* Democratization
* Model 16
logit democratization regime_trans_lag geog_cont_trans_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity i.year, cluster(cowcode)
fitstat
testparm i(1962/2010).year


********************************************************
*** Table 11: robustness test with spatial durbin model
********************************************************
clear
clear mata
clear matrix

spatwmat using "W", name(W) eigenval(E) 

use "RDD_SAR_replication", clear

* Model 17
spatreg polity2 regime_aut_fail_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, weights(W) eigenval(E) model(lag)


*******************************************************************
*** Table 12: robustness tests with different levels of contiguity
*******************************************************************
use "RDD_CPS_replication", clear
* Autocratic breakdown
* Model 18
logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_150_lag interaction_aut_fail_150_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat
* Model 19
logit gwf_fail regime_aut_fail_lag geog_cont_aut_fail_400_lag interaction_aut_fail_400_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat

* Democratization
* Model 20
logit democratization regime_trans_lag geog_150_trans_lag interaction_dem_150_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat
* Model 21
logit democratization regime_trans_lag geog_400_trans_lag interaction_dem_400_lag log_development growth intrastate_war_1000_robust inter_state_war former_anglo_colony mean_polity, cluster(cowcode)
fitstat

