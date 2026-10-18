# IT Ticket & SLA Analysis

This is my data analyst project where I analysed IT support tickets using MySQL and Power BI.

## What is this project about?
An IT support team gets tickets from users. Each ticket has a time limit to be solved, called SLA. I wanted to find out how many tickets were solved on time and where the team is getting delayed.

## Questions I wanted to answer
1. How many tickets are there and how many met the SLA?
2. Which priority (High, Medium, Low) has the most delays?
3. Which topic has the most tickets?
4. Which agent is delaying the most and which is the best?

## Dataset
Source: Technical Support Dataset (Kaggle, by Suvradeep)
Size: 2,330 tickets, 22 columns
Key columns: Priority, Topic, Agent Name, Agent Group, Created time, Resolution time, SLA For Resolution, Support Level
The CSV is not included in this repo. Download it from Kaggle.

## Tools I used
- MySQL for cleaning the data and writing queries
- Power BI for making the dashboard

## What I did
1. Loaded the CSV file into MySQL.
2. Cleaned the data. The dates were stored as text, so I changed them into proper date format. I also made blank values NULL and removed extra spaces.
3. Checked that all 2330 rows were there.
4. Wrote simple queries using COUNT and GROUP BY to answer my questions.
5. Connected Power BI with the clean table and made the dashboard.

## What I found
- Total tickets: 2330
- SLA met: 1547 tickets and SLA missed: 783 tickets, so only **66.39%** tickets were solved on time.
- Priority wise delay: Medium 35.04%, Low 33.89%, High 30.29%. High priority tickets are handled a bit better.
- Product setup has the most tickets (630), then Pricing and licensing (525).
- Training request has the highest delay (42.42%), but it has only 66 tickets.
- Agent Connor Danielovitch has the highest delay (38.33%) and Heather Urry has the lowest (23.73%).

## My conclusion
About 1 out of every 3 tickets misses the SLA. The delay is almost the same in all priorities, so the problem is in the overall process and not in one priority. The team can learn from the agent with the lowest delay.

## Dashboard

The dashboard shows total tickets, SLA percentage, priority wise SLA status, tickets by topic, agent wise delay, monthly tickets and a priority filter.

## Things to note
- Some open tickets are already marked as "SLA Violated" in the data because their time limit is over, so they are counted in the missed tickets.
- I used the SLA status given in the dataset and did not calculate it again.

## Files in this repo
 Sql has all my queries
 Dashboard has the Power BI file
 Images has the dashboard screenshot

## About me
Pranjal, fresher looking for data analyst roles.
GitHub: pranjalpatil2004
