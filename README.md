# Macroeconomic Forecasting of E-Commerce Retail Sales

## Overview
This project develops a time-series forecasting model for U.S. e-commerce retail sales using ARIMA econometric techniques. The analysis uses quarterly e-commerce sales data from the Federal Reserve Economic Data (FRED) database from 1999–2025.

The project evaluates trend behavior, seasonality, covariance stationarity, autoregressive structures, and forecasting performance to generate one-year-ahead forecasts under multiple economic scenarios.

---

## Research Objectives
- Examine the time-series dynamics of U.S. e-commerce retail sales
- Test for stationarity and seasonal persistence
- Compare autoregressive and ARIMA forecasting models
- Evaluate forecasting performance using residual diagnostics
- Generate baseline, bull-case, and bear-case forecasts

---

## Econometric Techniques
- Augmented Dickey-Fuller (ADF) testing
- Log differencing
- Seasonal analysis
- ACF/PACF diagnostics
- ARIMA modeling
- Residual correlogram diagnostics
- Scenario forecasting

---

## Final Model
The final selected specification was an:

### ARIMA(4,1,1)

The model captured:
- short-run growth dynamics
- quarterly seasonal persistence
- moving average shock effects

Residual diagnostics confirmed that the model residuals behaved approximately like white noise.

---

## Key Findings
- E-commerce retail sales exhibit strong long-run upward growth
- Significant quarterly seasonality persists even after differencing
- ARIMA models outperformed simpler autoregressive specifications
- Forecast scenarios indicate continued long-run expansion in e-commerce activity
- Scenario analysis highlights uncertainty in future retail growth environments

---

## Tools Used
- Stata
- Excel
- FRED Database
- Time-Series Econometrics

---

## Repository Structure

| Folder | Contents |
|---|---|
| `code/` | Stata forecasting and econometric analysis scripts |
| `figures/` | Forecast plots, diagnostics, and transformations |
| `paper/` | Final project report |

---

## Forecast Visualizations

### Final Forecast
![Forecast](figures/forecast_baseline.png)

### Forecast Scenario Analysis
![Scenario Analysis](figures/forecast_scenarios.png)

### ACF and PACF Diagnostics
![ACF PACF](figures/acf_pacf.png)

---

## Author
Shivani Samlal  
M.S. Applied Economics — Johns Hopkins University
