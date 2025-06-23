# churn_signals_and_sales_trends

👋 Hey everyone! This is Week 2 of my active content and engagement plan.
Each week, I’m sharing real lessons, tools, and insights. I’m learning as I grow in data analytics and this week’s focus is all about the behind-the-scenes of a project I just finished.

This project taught me way more than SQL or Power BI.
It taught me how analysts think and how to stop treating dashboards like decoration.
Here are some real-life lessons, tips, and reflections from a meal subscription analytics project I built using SQL, MySQL Workbench, and Power BI:

Real-Life Lessons:
1. SQL errors are part of the process and not the end of it.
From foreign key issues to incorrect data types, every error taught me something I’d never learn from a tutorial.
2. A good question is better than a perfect chart.
"Why are customers churning?" was more powerful than “What visual should I use?”
3. Fake data, real insight.
Even simulated orders and subscriptions gave me practice writing business-driven queries, building relationships, and visualizing patterns like LTV (lifetime value) and churn risk.

💡 Tips & Tricks I’ll Use Again:
•	Use NULLIF() when importing CSVs with blanks to avoid MySQL errors
•	Always load your tables in referential order: customers → subscriptions → orders
•	Replace "True"/"False" with 1 and 0 for Boolean columns
•	In Power BI, WEEKNUM() + YEAR() make great trend axes
•	Turning raw fields into business logic using DAX — like [AtRiskCustomer] or [ChurnStatus]

Workflow Hacks:
•	Group charts around questions, not tables.
Ex: “What’s our weekly revenue trend?” → Line chart
“Who are we losing the most?” → Bar chart by region + churn %
•	Build measures first, visuals second.
This saved me so much rework in Power BI.

Thoughtful Realizations:
•	Metrics without interpretation are just numbers
•	Clean data isn’t always clean logic
•	Data work is debugging meets storytelling
