**HOW TO RUN**

* Install ruby 2.7.6
* Access the poc_inkblot-therapy directory
* run ``bundle install``
* Choose your tag, ex: @signup
* Choose your env, ex: stg_t
* Choose your jira reference number, ex: jira-IQ-3
* run ``rake "parallel_tests[@desired_tag, browser, env, threads, jira]"``

Example:

``rake "parallel_tests[@poc, chrome, stg_t, 1, jira-IQ-2]"``

**REPORTS**

* Access the folder reports/final_reports and open the parallel_report.html
