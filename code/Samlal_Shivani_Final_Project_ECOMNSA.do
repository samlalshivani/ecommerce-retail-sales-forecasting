* Import data
import excel "ECOMNSA.xlsx", firstrow clear

* Convert daily date to quarterly date
gen qdate = qofd(observation_date)
format qdate %tq
tsset qdate

* Transformations
gen y = ECOMNSA
gen dy = D.y
gen lny = ln(y)
gen dlny = D.lny

* Plot original
tsline y, title("1. Original Series (Level)") ytitle("E-Commerce Sales") xtitle("Date")

* Plot first difference
tsline dy, title("2. First Difference") ytitle("Change") xtitle("Date")

* Plot log first difference
tsline dlny, title("3. Log First Difference") ytitle("Growth Rate") xtitle("Date")

*Combine all in one clean tiered graph
tsline y, title("1. Original Series (Level)") ytitle("E-Commerce Sales") name(g1, replace)

tsline dy, title("2. First Difference") ytitle("Change") name(g2, replace)

tsline dlny, title("3. Log First Difference") ytitle("Growth Rate") name(g3, replace)

graph combine g1 g2 g3, col(1) title("Figure 1: ECOMNSA and Data Transformations")

* Check seasonal pattern in the original series
gen quarter = quarter(dofq(qdate))

graph box ECOMNSA, over(quarter) title("Seasonality Check: E-Commerce Sales by Quarter") ytitle("E-Commerce Sales")

* ACF/PACF of original series
corrgram ECOMNSA, lags(24)
corrgram dlny, lags(24)

* Predict model specifications 
reg dlny L.dlny
estat ic

reg dlny L.dlny L4.dlny
estat ic

reg dlny L(1/3).dlny
estat ic

reg dlny L(1/2).dlny L4.dlny
estat ic

reg dlny L(1/3).dlny L4.dlny
estat ic

predict resid, residuals
corrgram resid, lags(24)

arima dlny, ar(1/3) ma(1)
estat ic
predict resid_arima, residuals
corrgram resid_arima, lags(24)

arima dlny, ar(1/4) ma(1)
estat ic
predict resid_arima2, residuals
corrgram resid_arima2, lags(24)

arima dlny, ar(1/3 4) ma(1)
estat ic
predict resid_arima3, residuals
corrgram resid_arima3, lags(24)

arima dlny, ar(1/4) ma(1)
* In-sample fitted values (growth rates)
predict dlny_hat, y
* Create baseline forecast in levels
gen yhat_base = .

* Initialize first observation
replace yhat_base = ECOMNSA[1] in 1

* Recursively build the series
forvalues i = 2/`=_N' {
    replace yhat_base = yhat_base[_n-1] * exp(dlny_hat) in `i'
}
gen yhat_bull = yhat_base * (1 + 0.02*_n/_N)
gen yhat_bear = yhat_base * (1 - 0.02*_n/_N)

replace yhat_base = . if train==1
replace yhat_bull = . if train==1
replace yhat_bear = . if train==1

summ qdate if test==1, meanonly
local starttest = r(min)

tsline ECOMNSA yhat_base yhat_bull yhat_bear, title("E-Commerce Sales: Actual vs Forecast Scenarios") xline(`starttest', lpattern(dash)) legend(order(1 "Actual" 2 "Baseline" 3 "Bull Case" 4 "Bear Case")) ytitle("E-Commerce Sales") xtitle("Quarter")


*actual forecast for a year
arima dlny, ar(1/4) ma(1)
tsappend, add(4)
predict dlny_forecast, y
gen yhat = .

* last observed level
summ qdate if !missing(ECOMNSA), meanonly
local lastobs = r(max)

replace yhat = ECOMNSA if qdate <= `lastobs'

forvalues i = 1/4 {
    replace yhat = yhat[_n-1] * exp(dlny_forecast) if missing(ECOMNSA)
}

gen yhat_baseline = yhat
gen yhat_bull = .
gen yhat_bear = .

replace yhat_bull = yhat * 1.05 if missing(ECOMNSA)
replace yhat_bear = yhat * 0.95 if missing(ECOMNSA)

replace yhat_baseline = . if !missing(ECOMNSA)

replace yhat_baseline = ECOMNSA if _n == _N-4

gen yhat_plot = yhat_baseline

* Anchor forecast to last actual point
replace yhat_plot = ECOMNSA if _n == _N-4

tsline ECOMNSA yhat_plot yhat_bull yhat_bear, title("E-Commerce Sales: 1-Year Ahead Forecast") legend(order(1 "Actual" 2 "Baseline Forecast" 3 "Bull Case" 4 "Bear Case")) ytitle("E-Commerce Sales") xtitle("Quarter")
