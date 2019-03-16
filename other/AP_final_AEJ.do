/***************************************************************************************************
* Title: Table production for Abel, Burger, Carranza & Piraino 2018, "Bridging the Intention-Behavior Gap? The Effect of
		 Plan-Making Prompts on Job Search and Employment"
		 
* Date: May 2018
* Replication file
***************************************************************************************************/

/*
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
INSTRUCTIONS FOR REPLICATION:
	1. In Section 1 set up the directory to point to the replication folder on your personal computer.
	2. Section 2 removes objects from the existing Stata instance
	3. Section 3 defines a series of global lists used to create the Tables and Figures
	4. Section 4 creates the Tables and Figures, in the same sequence as they appear in the paper. You may highlight any 
	   table and run it individually. The output will go to the "Output" folder in the replication folder on your personal computer.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

/* *************************************************************************************************
Program: THIS DO FILE GENERATES THE FIGURES AND TABLES OF THE PAPER "Bridging the Intention-Behavior Gap? The Effect of
		 Plan-Making Prompts on Job Search and Employment"
  
Input Files:   - final_data1.dta
		       - final_data2.dta
			   - final_data3.dta
						
Output Files:  - Table 1:  Sample Characteristics
			   - Figure 1: Intention-Behavior Gap: Difference at Baseline
			   - Table 2:  Action Plan Descriptives
			   - Table 3:  Effects on Job Search Intensity
			   - Table 4:  Effects on Employment Outcomes
			   - Table 5:  Effects on Frequency of Search Channel Use
			   
			   - Table A1: Test of Equal Means 
			   - Table A2: Effects of Reminders on Search and Employment Outcomes 
			   - Table A3: Effects of Peer Support on Search and Employment Outcomes
			   
			   - Table OnlineAppendix I: Attrition by Treatment
			   - Table OnlineAppendix II: Effects on Search Intensity and Quality, Objective Search Measures
			   - Table OnlineAppendix III: Effects on Frequency of Search Channel Use: Interval Regression
			   - Table OnlineAppendix IV: Second Follow Up: Goal Recall
			   - Table OnlineAppendix V: Action Plan Subgroup Analysis: Correlation with Search Intensity 

************************************************************************************************/

//////////////////////////
// 1. SETUP DIRECTORIES //
//////////////////////////

	global path_data "C:\Users\mabel\Dropbox\SA labour\ACTION PLAN\svetlana AP analysis\dta\using"
	global path_output "C:\Users\mabel\Dropbox\SA labour\ACTION PLAN\svetlana AP analysis\do\output"


version 13

	// DATA
	
	global path_data "D:\Dropbox\SA labour\ACTION PLAN\svetlana AP analysis\dta\using"
		
	// OUTPUT
	global path_output "D:\Dropbox\SA labour\ACTION PLAN\svetlana AP analysis\do\output"
		
///////////////////////////
// 2. PREVIOUS PROGRAMS //
///////////////////////////

	// SETUP
	clear all
	set more off
	matrix drop _all
	capture log close	
	


//////////////////////////////////
// 3. CREATE TABLES AND FIGURES //
//////////////////////////////////
	
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** TABLE 1: SAMPLE CHARACTERISTICS
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
{ 
	use "$path_data\final_data1.dta", clear
	local z: word count age_yr female educ_yr bs_b15a moved_yesno_d bs_b1_ever bs_b13_reserv_wage bs_b14 bs_transport_cost bs_b16 bs_c2 bs_c3
	keep age_yr female educ_yr bs_b15a moved_yesno_d bs_b1_ever bs_b13_reserv_wage bs_b14 bs_transport_cost bs_b16 bs_c2 bs_c3 treatment_group control_d ws*
	clear matrix
	matrix T = J(`z', 4, . ) 
	matrix rownames T = age_yr female educ_yr bs_b15a moved_yesno_d bs_b1_ever bs_b13_reserv_wage bs_b14 bs_transport_cost bs_b16 bs_c2 bs_c3
	matrix colnames T = N Mean Median SD 
	foreach var in age_yr female educ_yr bs_b15a moved_yesno_d bs_b1_ever bs_b13_reserv_wage bs_b14 bs_transport_cost bs_b16 bs_c2 bs_c3  { 
		global `var'l: var label `var' 
		qui sum `var', d
		mat T[rownumb(T, "`var'"), colnumb(T,"N")] = `r(N)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"Mean")] = round(`r(mean)', 0.01)
		mat T[rownumb(T, "`var'"), colnumb(T,"Median")] = round(`r(p50)', 0.01)
		mat T[rownumb(T, "`var'"), colnumb(T,"SD")] = round(`r(sd)', 0.01)		
	} 
	matrix list T 
	outtable using  "$path_output\Table_1", mat(T) replace label  ///	
	center nobox caption("Sample Characteristics"\label{tab:sample}) 
}


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** TABLE 2: ACTION PLAN CHARACTERISTICS
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

{
	use "$path_data\final_data1.dta", clear
	keep APcomplete activity_days  goal_hours goal_opport goal_submit female_d
	local z: word count APcomplete activity_days  goal_hours goal_opport goal_submit
	clear matrix
	matrix T = J(`z', 3, . ) 
	matrix rownames T = APcomplete activity_days  goal_hours goal_opport goal_submit 
	matrix colnames T = N Mean SD

	*** Filling in Matrix with results
	foreach var in APcomplete activity_days  goal_hours goal_opport goal_submit  { 
		global `var'l: var label `var'  
		qui sum `var'  
			mat T[rownumb(T, "`var'"), colnumb(T,"N")] = `r(N)' 
			mat T[rownumb(T, "`var'"), colnumb(T,"Mean")] = round(`r(mean)', 0.01) 
			mat T[rownumb(T, "`var'"), colnumb(T,"SD")] = round(`r(sd)', 0.01) 
	}
	matrix list T
	outtable using  "$path_output\Table_2", mat(T) replace label  center nobox caption("Action Plan Descriptives"\label{tab:apstats})
/*
	\item[] Note: Table reports characteristics of transcribed action plans. Activity-days refer to number of days on which an activity was listed. Following the weekly breakdown of activities, respondents listed the goals for number of hours to search, number of opportunities to identify, and number of applications to submit.  
*/
}

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** FIGURE 1: INTENTION BEHAVIOR GAP DIFFERENCE AT BASELINE
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

{
	use "$path_data\final_data1.dta", clear
	twoway hist hours_diff, ///
		color(edkblue) lcolor(white) graphregion(color(white)) name(left, replace)
	twoway hist apps_diff , ///
		color(edkblue) lcolor(white) graphregion(color(white)) name(right, replace)
	graph combine left right, ycommon col(2) graphregion(color(white)) imargin(0 0 0 0)
	graph export "$path_output/Figure_1.eps", replace
}

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** TABLE 3: EFFECTS ON JOB SEARCH INTENSITY
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
{
	use "$path_data\final_data2.dta", clear
	est clear
	eststo clear
	eststo: reg b2_t ws_d ws_plus_d  nomiss_bs_c2 missd_bs_c2 i.location_f i.round, vce(cluster id)
			qui sum b2_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
	eststo: reg b2_t ws_d ws_plus_d nomiss_bs_c2 missd_bs_c2 educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d i.location_f i.round, vce(cluster id)
			qui sum b2_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
	eststo: reg b3_t ws_d ws_plus_d  nomiss_bs_c3 missd_bs_c3 i.location_f i.round, vce(cluster id)
			qui sum b3_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
	eststo: reg b3_t ws_d ws_plus_d  nomiss_bs_c3 missd_bs_c3 educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d i.location_f i.round, vce(cluster id)
			qui sum b3_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
			
	#delimit ;
	esttab using "$path_output\Table_3",  replace modelwidth(15) varwidth(20) depvar label
	nonote
	addnote(
		"Notes: * p\textless 0.10, ** p\textless 0.05, *** p\textless 0.01. Regressions use panel data over two follow-up periods."
		"Standard errors (reported in parentheses) are clustered at the individual level. P-value compares WS Plus to WS Basic."
		"All regressions control for location-fixed effects and baseline value of the outcome variable."
		"Outcome variables are winsorized at the 5\% level."
		)
	order (ws_d ws_plus_d) keep(ws_d ws_plus_d) indicate("Covariates = educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d")
	title ("Effects on Job Search Intensity"\label{tab:search})  
	alignment(D{.}{.}{-1}) // width(0.6\hsize) 
	b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 scalars("ControlMean Control Mean" "Pval P-value") sfmt(%9.3f %9.3f)
	;
	#delimit cr
	est clear
}

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** TABLE 4: EMPLOYMENT OUTCOMES
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

////////////////////////////////////////////////////////////////////////////////	
{ 
	use "$path_data\final_data2.dta", clear
	est clear
	eststo: reg b4_t ws_d ws_plus_d   nomiss_bs_c4 missd_bs_c4 i.location_f i.round, vce(cluster id)
			qui sum b4_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
	eststo: reg b4_t ws_d ws_plus_d nomiss_bs_c4 missd_bs_c4 educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d i.location_f i.round, vce(cluster id)
			qui sum b4_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
	eststo: reg b6_t ws_d ws_plus_d  nomiss_bs_c6 missd_bs_c6 i.location_f i.round, vce(cluster id)
			qui sum b6_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
	eststo: reg b6_t ws_d ws_plus_d   nomiss_bs_c6 missd_bs_c6 educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d  i.location_f i.round, vce(cluster id)
			qui sum b6_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
	eststo: reg a1_t ws_d ws_plus_d   i.location_f i.round, vce(cluster id)
			qui sum a1_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
	eststo: reg a1_t ws_d ws_plus_d educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d i.location_f i.round, vce(cluster id)
			qui sum a1_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)

	#delimit ;
	esttab * using "$path_output\Table_4",  replace modelwidth(15) varwidth(15) depvar label
	nonote
	addnote(
		"Notes: * p\textless 0.10, ** p\textless 0.05, *** p\textless 0.01. Regressions use panel data over two follow-up periods."
		"Standard errors (reported in parentheses) are clustered at the individual level. P-value compares WS Plus to WS Basic."	
		"All regressions control for location-fixed effects and baseline value of the outcome variable."	
		"Outcome variables are winsorized at the 5\% level."
	)
	order (ws_d ws_plus_d) keep(ws_d ws_plus_d) indicate("Covariates = educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d")
	title ("Effects on Employment Outcomes"\label{tab:employment}) 
	mtitles("Responses" "Responses"  "Offers" "Offers" "Employed" "Employed")
	alignment(D{.}{.}{-1}) // width(0.6\hsize) 
	b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 scalars("ControlMean Control Mean" "Pval P-value") sfmt(%9.3f %9.3f)
	;
	#delimit cr
	est clear
}

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** TABLE 5: FREQUENCY OF SEARCH CHANNEL USE
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	
{ 
	use "$path_data\final_data2.dta", clear
	est clear
	eststo clear
	forvalues x=1/6 {
		reg b1_`x'_t ws_d ws_plus_d educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c1_`x' missd_bs_c1_`x' i.location_f i.round, vce(cluster id) //took out $bscov
		est sto b1_`x'_t_`i' 
		estadd ysumm
		qui sum b1_`x'_t if treatment_group=="control"
		estadd scalar ControlMean = r(mean)
		qui test ws_d = ws_plus_d // check if coefficients are different
		estadd scalar Pval = r(p)
		local i = `i' + 1
	}		
	#delimit ;
	esttab * using "$path_output\Table_5",  replace modelwidth(15) varwidth(15) depvar label	
	nonote
	addnote(
		"Notes: * p\textless 0.10, ** p\textless 0.05, *** p\textless 0.01. Regressions use panel data over two follow-up periods."
		"Outcome variables are a categorial frequency scale from 0 (never) to 6 (daily). Standard errors (reported in parentheses) "
		"are clustered at the individual level. P-value compares WS Plus to WS Basic."
		"All regressions control for location-fixed effects and baseline value of the outcome variable."
		"Outcome variables are winsorized at the 5\% level."
	)
	order (ws_d ws_plus_d) keep(ws_d ws_plus_d)
	title ("Effects on Frequency of Search Channel Use"\label{tab:channels}) 
	alignment(D{.}{.}{-1}) // width(0.6\hsize) 
	b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 scalars("ControlMean Control Mean" "Pval P-value") sfmt(%9.3f %9.3f)
	;
	#delimit cr
}

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** APPENDIX 
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** TABLE A1: BALANCE TABLE
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

{ 
	preserve
	use "$path_data\final_data1.dta", clear
	local z: word count age_yr female educ_yr bs_b15a bs_b15b1 bs_b15b2 married_d moved_yesno_d bs_b12_UIF_d bs_b1_ever bs_b2_self unemployment_months bs_b13_reserv_wage bs_b14 bs_transport_cost bs_b16 bs_c2 bs_c3 bs_c4
	keep age_yr female educ_yr bs_b15a bs_b15b1 bs_b15b2 married_d moved_yesno_d bs_b12_UIF_d bs_b1_ever bs_b2_self unemployment_months bs_b13_reserv_wage bs_b14 bs_transport_cost bs_b16 bs_c2 bs_c3 bs_c4 treatment2 treatment_group  control_d ws*
	clear matrix 
	matrix T = J(`z', 10, . ) 
	matrix rownames T = age_yr female educ_yr bs_b15a bs_b15b1 bs_b15b2 married_d moved_yesno_d bs_b12_UIF_d bs_b1_ever bs_b2_self unemployment_months bs_b13_reserv_wage bs_b14 bs_transport_cost bs_b16 bs_c2 bs_c3 bs_c4
	matrix colnames T = N Control Workshop WS_Pv WS_Plus WSP_Pv ActPlan AP_Pv Peer Peer_Pv 
	foreach var in age_yr female educ_yr bs_b15a bs_b15b1 bs_b15b2 married_d moved_yesno_d bs_b12_UIF_d bs_b1_ever bs_b2_self unemployment_months bs_b13_reserv_wage bs_b14 bs_transport_cost bs_b16 bs_c2 bs_c3 bs_c4  { 
		global `var'l: var label `var' 
		sum `var'  if treatment_group=="control" | treatment_group=="workshop" | treatment_group=="workshop_AP" | treatment_group=="workshop_AP_peer"  
			mat T[rownumb(T, "`var'"), colnumb(T,"N")] = `r(N)' 
		sum `var' if treatment_group=="control" 
			mat T[rownumb(T, "`var'"), colnumb(T,"Control")] = round(`r(mean)', 0.01)
		sum `var' if treatment_group=="workshop"
			mat T[rownumb(T, "`var'"), colnumb(T,"Workshop")] = round(`r(mean)', 0.01)
		reg `var' ws_d if (treatment_group=="workshop" | treatment_group=="control"), r  
			local pr = 2*ttail(e(df_r),abs(_b[ws_d]/_se[ws_d])) 
			mat T[rownumb(T, "`var'"), colnumb(T,"WS_Pv")] = round(`pr', 0.01)	
		sum `var' if ws_plus==1
			mat T[rownumb(T, "`var'"), colnumb(T,"WS_Plus")] = round(`r(mean)', 0.01)
		reg `var' ws_plus if (treatment_group=="workshop" | ws_plus==1), r  
			local pr = 2*ttail(e(df_r),abs(_b[ws_plus]/_se[ws_plus])) 
			mat T[rownumb(T, "`var'"), colnumb(T,"WSP_Pv")] = round(`pr', 0.01)
				
	* Different workshop arms separately
		sum `var' if treatment_group=="workshop_AP"
			mat T[rownumb(T, "`var'"), colnumb(T,"ActPlan")] = round(`r(mean)', 0.01)			
		reg `var' ws_AP_d if (treatment_group=="workshop_AP" | treatment_group=="workshop"), r  //compared to workshop
			local pr = 2*ttail(e(df_r),abs(_b[ws_AP_d]/_se[ws_AP_d])) 
			mat T[rownumb(T, "`var'"), colnumb(T,"AP_Pv")] = round(`pr', 0.01)			
		sum `var' if treatment_group=="workshop_AP_peer"
			mat T[rownumb(T, "`var'"), colnumb(T,"Peer")] = round(`r(mean)', 0.01)
		reg `var' ws_Peer_d if (treatment_group=="workshop_AP_peer" | treatment_group=="workshop"), r  //compared to workshop
			local pr = 2*ttail(e(df_r),abs(_b[ws_Peer_d]/_se[ws_Peer_d])) 
			mat T[rownumb(T, "`var'"), colnumb(T,"Peer_Pv")] = round(`pr', 0.01)
		} 
	matrix list T
	outtable using  "$path_output\Table_A1", mat(T) replace label  center nobox caption("Test of Equal Means"\label{tab:balance}) 
	/* Notes to add to the tex file: (copy-paste)
	\item[] Note: Table reports balance of baseline characteristics across treatment assignment. Control column reports mean among control group; Workshop indicates mean in workshop only group; ActionPlan column reports mean in Workshop + Action Plan only group (no peer component); and  Peer column reports mean in Workshop + Action Plan + Peer group. WS Pval reports p-values of test of equal means with the control group; AP Pval and Peer Pval report test of equal means with Workshop group; Joint Pval reports test of equal means across all treatment assignments. Months of unemployment is measured for subsample who have ever been employed. Winsorized at 95\% where necessary for outliers. 
	*/
	restore 
}



*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** TABLE A2: EFFECTS OF REMINDERS ON SEARCH AND EMPLOYMENT
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

{ 
	use "$path_data\final_data2.dta", clear
	est clear
	eststo clear
	eststo: reg b2_t ws_d ws_plus_d ws_d_reminder_any ws_plus_d_reminder_any educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c2 missd_bs_c2 i.location_f i.round, vce(cluster id)
			qui sum b2_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
	eststo: reg b3_t ws_d ws_plus_d ws_d_reminder_any ws_plus_d_reminder_any educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c3 missd_bs_c3 i.location_f i.round, vce(cluster id)
			qui sum b3_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
	eststo: reg b4_t ws_d ws_plus_d ws_d_reminder_any ws_plus_d_reminder_any educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c4 missd_bs_c4 i.location_f i.round, vce(cluster id)
			qui sum b4_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
	eststo: reg b6_t ws_d ws_plus_d ws_d_reminder_any ws_plus_d_reminder_any educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c6 missd_bs_c6 i.location_f i.round, vce(cluster id)
			qui sum b6_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
	eststo: reg a1_t ws_d ws_plus_d ws_d_reminder_any ws_plus_d_reminder_any educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d  i.location_f i.round, vce(cluster id)
			qui sum a1_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)

	#delimit ;
	esttab * using "$path_output\Table_A2",  replace modelwidth(15) varwidth(15) depvar label
	mgroups("Search" "Employment", pattern(1 0 1 0  0) prefix(\multicolumn{@span}{c}{) suffix(}) 
    span erepeat(\cmidrule(lr){@span})) 
	nonote
	addnote(
		"Notes: * p\textless 0.10, ** p\textless 0.05, *** p\textless 0.01. Regressions use panel data over two follow-up periods."
		"Standard errors (reported in parentheses) are clustered at the individual level. "
		"Coefficients on Reminder interaction terms express the additional value of the reminder. "
		"All regressions control for location-fixed effects and baseline value of the outcome variable."
		"Outcome variables are winsorized at the 5\% level."
	)
	order (ws_d ws_plus_d ws_d_reminder_any ws_plus_d_reminder_any) keep(ws_d ws_plus_d ws_d_reminder_any ws_plus_d_reminder_any)
	title ("Effects on Search and Employment Outcomes"\label{tab:reminder}) 
	alignment(D{.}{.}{-1}) // width(0.6\hsize) 
	b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 scalars("ControlMean Control Mean") sfmt(%9.3f)
	;
	#delimit cr
	est clear
}


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** TABLE A3: EFFECTS OF PEER SUPPORT ON SEARCH AND EMPLOYMENT
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

{ 
	use "$path_data\final_data2.dta", clear
	eststo clear
	eststo: reg b2_t ws_d ws_plus_d compPEER educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c2 missd_bs_c2 i.location_f i.round, vce(cluster id)
			qui sum b2_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
	eststo: reg b3_t ws_d ws_plus_d compPEER educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c3 missd_bs_c3 i.location_f i.round, vce(cluster id)
			qui sum b3_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
	eststo: reg b4_t ws_d ws_plus_d compPEER educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c4 missd_bs_c4 i.location_f i.round, vce(cluster id)
			qui sum b4_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
	eststo: reg b6_t ws_d ws_plus_d compPEER educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c6 missd_bs_c6 i.location_f i.round, vce(cluster id)
			qui sum b6_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
	eststo: reg a1_t ws_d ws_plus_d compPEER educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d  i.location_f i.round, vce(cluster id)
			qui sum a1_t if treatment_group=="control"
			estadd scalar ControlMean = r(mean)
			
	#delimit ;
	esttab * using "$path_output\Table_A3",  replace modelwidth(15) varwidth(15) depvar label
	mgroups("Search" "Employment", pattern(1 0 1 0  0) prefix(\multicolumn{@span}{c}{) suffix(}) 
    span erepeat(\cmidrule(lr){@span})) 
	nonote
	addnote(
		"Notes: * p\textless 0.10, ** p\textless 0.05, *** p\textless 0.01. Regressions use panel data over two follow-up periods."
		"Standard errors (reported in parentheses) are clustered at the individual level. "
		"Coefficient on Peer interaction term expresses the additional value of the peer support. "
		"All regressions control for location-fixed effects and baseline value of the outcome variable."
		"Outcome variables are winsorized at the 5\% level."
	)
	order (ws_d ws_plus_d compPEER) keep(ws_d ws_plus_d compPEER)
	title ("Effects on Search and Employment Outcomes"\label{tab:peer}) 
	alignment(D{.}{.}{-1}) // width(0.6\hsize) 
	b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 scalars("ControlMean Control Mean") sfmt(%9.3f)
	;
	#delimit cr
}

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** ONLINE APPENDIX
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** ONLINE APPENDIX TABLE I: ATTRITION TABLE
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

{
	preserve
	use "$path_data\final_data1.dta", clear
	sum f1_attrition_d f2_attrition_d 
	local z: word count f1_attrition_d f2_attrition_d 
	keep f1_attrition_d f2_attrition_d treatment_group control_d ws*
	clear matrix 
	matrix T = J(`z', 10, . ) 
	matrix rownames T = f1_attrition_d f2_attrition_d 
	matrix colnames T = Sample Control Workshop WS_Pv WSPlus WSPlus_Pv ActPlan AP_Pv Peer Peer_Pv
	foreach var in f1_attrition_d f2_attrition_d   { 
		global `var'l: var label `var' 
		sum `var'  if treatment_group == "control" | treatment_group == "workshop" | treatment_group == "workshop_AP" | treatment_group == "workshop_AP_peer"  
			mat T[rownumb(T, "`var'"), colnumb(T,"Sample")] = round(`r(mean)', 0.01)
		sum `var' if treatment_group == "control" 
			mat T[rownumb(T, "`var'"), colnumb(T,"Control")] = round(`r(mean)', 0.01)
			
		* Different workshop arms separately
		sum `var' if treatment_group == "workshop"
			mat T[rownumb(T, "`var'"), colnumb(T,"Workshop")] = round(`r(mean)', 0.01)
		reg `var' ws_d if (treatment_group == "workshop" | treatment_group == "control"), r  
			local pr = 2*ttail(e(df_r),abs(_b[ws_d]/_se[ws_d])) 
			mat T[rownumb(T, "`var'"), colnumb(T,"WS_Pv")] = round(`pr', 0.01)
		sum `var' if ws_plus==1
			mat T[rownumb(T, "`var'"), colnumb(T,"WSPlus")] = round(`r(mean)', 0.01)
		reg `var' ws_plus if (treatment_group == "workshop" | ws_plus == 1), r  
			local pr = 2*ttail(e(df_r),abs(_b[ws_plus]/_se[ws_plus])) 
			mat T[rownumb(T, "`var'"), colnumb(T,"WSPlus_Pv")] = round(`pr', 0.01)
			
		* AP
		sum `var' if inlist(treatment_group, "workshop_AP")
			mat T[rownumb(T, "`var'"), colnumb(T,"ActPlan")] = round(`r(mean)', 0.01)
		reg `var' ws_AP_d if inlist(treatment_group, "workshop", "workshop_AP"), r  
			local pr = 2*ttail(e(df_r),abs(_b[ws_AP_d]/_se[ws_AP_d])) 
			mat T[rownumb(T, "`var'"), colnumb(T,"AP_Pv")] = round(`pr', 0.01)
			
		* PEER
		sum `var' if inlist(treatment_group, "workshop_AP_peer")
			mat T[rownumb(T, "`var'"), colnumb(T,"Peer")] = round(`r(mean)', 0.01)	
		reg `var' ws_Peer_d if inlist(treatment_group, "workshop", "workshop_AP_peer"), r  
			local pr = 2*ttail(e(df_r),abs(_b[ws_Peer_d]/_se[ws_Peer_d])) 
			mat T[rownumb(T, "`var'"), colnumb(T,"Peer_Pv")] = round(`pr', 0.01)
		} 
	matrix list T 
	outtable using  "$path_output\Table_OnlineAppendix_I", mat(T) replace label center nobox caption("Attrition by Treatment"\label{tab:attrition}) 
	restore
}

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** ONLINE APPENDIX TABLE II: EFFECTS ON JOB SEARCH INTENSITY AND QUALITY 
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

{ 
	preserve
	use "$path_data\final_data3", clear 
	est clear
	foreach var in  response_text_any motivation_statement attached_CV attached_refletter ///
		attached_ID attached_schoolcertif qual_index {
		reg `var' ws_d ws_plus_d times_contacted educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d i.location_f i.year if response_d==1, r
			est sto `var'_`i' 
			qui sum `var' if treatment_group=="control" & response_d==1
			estadd scalar ControlMean = r(mean)
			qui test ws_d = ws_plus_d // check if coefficients are different
			estadd scalar Pval = r(p)
			local i = `i' + 1
	}	
		
	#delimit ;
	esttab * using "$path_output\Table_OnlineAppendix_II",  replace modelwidth(15) varwidth(25) depvar label 
	drop(educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d times_contacted lang_* *location*  *year _cons) 
	nonote
	addnote(
		"Notes: * p\textless 0.10, ** p\textless 0.05, *** p\textless 0.01. Robust standard errors (reported in parentheses). P-value compares WS Plus to WS Basic." 
		"Regressions use crossectional individual-level data controlling for demographics and location-fixed effects."
		"Reply likelihood is the probability respondents reply to a job vacancy provided by the researchers."
		"Measures of quality are binary indicators condtional on applying. Quality Index is calculated as the sum across six binary indicators of quality."
	)
	title ("Effects on Search Intensity and Quality, Objective Search Measures"\label{tab:vacancyqual})
	alignment(D{.}{.}{-1})
	b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 scalars("ControlMean Control Mean" "Pval P-value") sfmt(%9.3f %9.3f)
	;
	#delimit cr		
	est clear
	restore
}

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** ONLINE APPENDIX TABLE III: SEARCH CHANNEL INTERVAL REGRESSION
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
{
	use "$path_data\final_data2.dta", clear
	forvalues x=1/6 {
		gen l_b1_`x'_t = . if b1_`x'_t == 0
		gen u_b1_`x'_t = 0 if b1_`x'_t == 0
		replace l_b1_`x'_t = 0 if b1_`x'_t == 1
		replace u_b1_`x'_t = 1/52 if b1_`x'_t == 1
		replace l_b1_`x'_t = 1/52 if b1_`x'_t == 2
		replace u_b1_`x'_t = 1/4.2 if b1_`x'_t == 2
		replace l_b1_`x'_t = 1/4.2 if b1_`x'_t == 3
		replace u_b1_`x'_t = 1 if b1_`x'_t == 3
		replace l_b1_`x'_t = 1 if b1_`x'_t == 4
		replace u_b1_`x'_t = 3 if b1_`x'_t == 4
		replace l_b1_`x'_t = 3 if b1_`x'_t == 5
		replace u_b1_`x'_t = 7 if b1_`x'_t == 5
		replace l_b1_`x'_t = 7 if b1_`x'_t == 6
		replace u_b1_`x'_t = . if b1_`x'_t == 6
	}
	forvalues x=1/6 {
		eststo: intreg l_b1_`x'_t u_b1_`x'_t ws_d ws_plus_d educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c1_`x' missd_bs_c1_`x' i.location_f i.round, vce(cluster id) //took out $bscov
		if `x' == 1 outreg2 using "$path_output\Table_OnlineAppendix_III", excel replace
		if `x' > 1 outreg2 using "$path_output\Table_OnlineAppendix_III", excel append
		cap predict b1_`x'_hat1 if b1_`x'_t != .
		replace b1_`x'_hat1 = 0 if b1_`x'_t == 0
		replace b1_`x'_hat1 = 7 if b1_`x'_t == 6
		summ b1_`x'_hat1 if ws_d == 0 & ws_plus_d == 0
	}
}

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** ONLINE APPENDIX TABLE IV: GOAL RECALL
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
{	
	preserve
	use "$path_data\final_data1.dta", clear
	est clear
	foreach var in f2_recall  abs_diff_recall_goal { //diff_recall_goal
	reg `var' reminder_any educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d i.location_f , r 
		est sto `var'_`i' 
		qui sum `var' if reminder_any==0
		estadd scalar ControlMean = r(mean)
		local i = `i' + 1
	}	
	
	#delimit ;
	esttab * using "$path_output\Table_OnlineAppendix_IV",  replace modelwidth(15) varwidth(25) depvar label
		//mtitle("Nr.Apps Aim to Submit" "Nr.Apps Aim to Submit") addnote("Notes: Location fixed effects in all specifications")
	nonote
	addnote(
		"Notes: * p\textless 0.10, ** p\textless 0.05, *** p\textless 0.01. Regressions use data from the second follow-up."
		"Robust standard errors (reported in parentheses). Outcomes are likelihood of remembering the goal "
		"number of applications, and the absolute difference between stated goal and recalled goal. "
		"All regressions control for location-fixed effects. Outcome variables are winsorized at the 5\% level."
	)
	order (reminder_any) keep(reminder_any)
	title ("Second Follow Up: Goal Recall"\label{tab:recall})  
	alignment(D{.}{.}{-1})  //width(0.6\hsize) 
	b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 scalars("ControlMean Control Mean") sfmt(%9.3f)
	;
	#delimit cr
	est clear
	restore
}	


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
***************** ONLINE APPENDIX TABLE V: ACTION PLAN SUBGROUP ANALYSIS: CORRELATION WITH SEARCH INTENSITY
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

{ 
	use "$path_data\final_data2.dta", clear
	est clear
	eststo: reg b2_t goal_submit  educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c2 missd_bs_c2 nomiss_bs_c3 missd_bs_c3 i.location_f round, vce(cluster id) 
			qui sum bs_c2 if ws_plus_d==1
			estadd scalar BaselineMean = r(mean)
	eststo: reg b2_t goal_hours    educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c2 missd_bs_c2 nomiss_bs_c3 missd_bs_c3 i.location_f round, vce(cluster id) 
			qui sum bs_c2 if ws_plus_d==1
			estadd scalar BaselineMean = r(mean)
	eststo: reg b2_t  goal_submit  goal_hours   educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c2 missd_bs_c2 nomiss_bs_c3 missd_bs_c3 i.location_f round, vce(cluster id) 
			qui sum bs_c2 if ws_plus_d==1
			estadd scalar BaselineMean = r(mean)

	eststo: reg b3_t goal_submit   educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c2 missd_bs_c2 nomiss_bs_c3 missd_bs_c3 i.location_f round, vce(cluster id) 
			qui sum bs_c3 if ws_plus_d==1
			estadd scalar BaselineMean = r(mean)
	eststo: reg b3_t  goal_hours    educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c2 missd_bs_c2 nomiss_bs_c3 missd_bs_c3 i.location_f round, vce(cluster id) 
			qui sum bs_c3 if ws_plus_d==1
			estadd scalar BaselineMean = r(mean)
	eststo: reg b3_t goal_submit  goal_hours   educ_yr age_yr female_d bs_b15a lang_xhosa_d lang_venda_d lang_zulu_d nomiss_bs_c2 missd_bs_c2 nomiss_bs_c3 missd_bs_c3 i.location_f round, vce(cluster id) 
			qui sum bs_c3 if ws_plus_d==1
			estadd scalar BaselineMean = r(mean)
	#delimit ;
	esttab $var_* using "$path_output\Table_OnlineAppendix_V",  replace modelwidth(15) varwidth(25) depvar label 
	nonote
	addnote(
		"Notes: * p\textless 0.10, ** p\textless 0.05, *** p\textless 0.01. Regressions use panel data over two follow-up periods."
		"Standard errors (reported in parentheses) are clustered at the individual level. "	
		"Subsample consists of those assigned to WSPlus. All regressions control for location-fixed effects "
		"and baseline values goal applications and goal search hours. Outcome variables are winsorized at the 5\% level."
	)
	mgroups("Search Hours" "Submitted Applications", pattern(1 0 0 1 0  0) prefix(\multicolumn{@span}{c}{) suffix(}) 
    span erepeat(\cmidrule(lr){@span})) 
	order (goal_submit  goal_hours) keep($var_ap)
	title ("Action Plan Subgroup Analysis: Correlation with Search Intensity"\label{tab:apsubgroup})
	alignment(D{.}{.}{-1})
	b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 scalars("BaselineMean Baseline Mean") sfmt(%9.3f)
	;
	#delimit cr	
}

exit

////////////////////////////////////////////////////////////////////////////////
