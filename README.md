# Netflix_DataAnalysis
Deploy using Shiny Dashboard and made using R Programming Language.


# Netflix Data Analysis & Prediction Report


Step 1: Data Cleaning
- Loaded dataset and inspected structure.
- Handled missing values in director, cast, and country.
- Checked duplicates (none found).
- Converted date_added to datetime and extracted year/month.

Step 2: Data Analysis
- Movies dominate over TV Shows.
- Top countries: USA leads.
- Most common rating: TV-MA.
- Peak growth observed after 2015.
- Movies analyzed by duration; TV Shows by seasons.

Step 3: Insights & Feature Engineering
- Identified most common genres.
- Found top actors and directors.
- Compared country vs content type.
- Observed growth trend before vs after 2015.

Step 4: Data Preparation
- Selected features: type, release_year, duration, rating, country.
- Converted categorical variables to factors.
- Extracted numeric duration.
- Removed missing values.

Step 5: Train-Test Split
- Dataset split into 70% training and 30% testing.

Step 6: Model Building
- Logistic Regression used to predict content type.

Step 7: Prediction
- Generated probabilities and converted to class labels.

Step 8: Evaluation
- Confusion matrix created.
- Accuracy calculated.

Step 9: Visualization
- Plotted actual vs predicted.
- Displayed class distribution.

Step 10: Deployment
- Model saved using RDS.
- Reloaded and used for new predictions.

Step 11: Conclusion
- Netflix content is movie-heavy with strong growth post-2015.
- Model performs reasonably well.
- Improvements: better encoding, more features, advanced models.
