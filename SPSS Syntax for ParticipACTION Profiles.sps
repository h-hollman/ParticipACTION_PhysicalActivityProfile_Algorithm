* Encoding: UTF-8.
* SPSS Syntax for ParticipACTION Profiles

* The algorithm requires the following four questions:

* Q1. Physical Activity Behaviour
* “In the past week, on how many days have you done a total of 30 minutes or more of PA, 
* which was enough to raise your breathing rate? 
* This may include sport, traditional games, exercise and brisk walking or cycling for recreation or 
*  to get to and from places, but should not include housework or PA that may be part of your job.” 
* Responses range from 0 to 7 where 0 = 0 days and 7 = 7 days
* This single item has demonstrated surveillance-relevant concurrent validity and reliability (Bauman & Richards, 2022; Milton et al., 2011). 

* Q2. Physical Activity Intentions
* “How many days per week do you intend to engage in PA for 30 minutes or more?” 
* Responses range from 0 to 7 where 0 = 0 days to 7 = 7 days
* This question was modified from Courneya (1994) to reflect the framing of the PA behaviours question. 

* Q3. Physical Activity Habit
* “Engaging in PA for 30 minutes or more, most days of the week, is something I do without thinking” 
* Responses scored on a 5-points Likert scale (1 = strongly disagree, 2 = disagree, 3 = neither agree nor disagree, 4 = agree, 5 = strongly agree). 
* PA habit was measured with the third question from the Self-Report Behavioral Automaticity Index (Gardner et al., 2012).
* This item was selected because it consistently resulted in the lowest overall internal consistency (Cronbach alpha) when dropped, using our algorithm development and testing datasets.

* Q4. Physical Activity Identity
* “Others see me as someone who does PA regularly” 
* Responses scored on a 5-points Likert scale (1 = strongly disagree, 2 = disagree, 3 = neither agree nor disagree, 4 = agree, 5 = strongly agree). 
* This item was selected from the Exercise Identity Scale because it had the highest standardized factor loading score for PA role identity (Wilson & Muon, 2008)

* References
* Bauman, A. E., & Richards, J. A. (2022). Understanding of the Single-Item Physical Activity Question for Population Surveillance. Journal of Physical Activity and Health, 19(10), 681–686. https://doi.org/10.1123/jpah.2022-0369
* Milton, K., Bull, F. C., & Bauman, A. (2011). Reliability and validity testing of a single-item physical activity measure. British Journal of Sports Medicine, 45(3), 203–208. https://doi.org/10.1136/bjsm.2009.068395
* Courneya, K. S. (1994). Predicting repeated behavior from intention: The issue of scale correspondence. Journal of Applied Social Psychology, 24(7), 580–594. https://doi.org/10.1111/j.1559-1816.1994.tb00601.x
* Gardner, B., Abraham, C., Lally, P., & Bruijn, G.-J. de. (2012). Towards parsimony in habit measurement: Testing the convergent and predictive validity of an automaticity subscale of the Self-Report Habit Index. International Journal of Behavioral Nutrition and Physical Activity, 9(1), 1–12. https://doi.org/10.1186/1479-5868-9-102
* Wilson, P. M., & Muon, S. (2008). Psychometric properties of the exercise identity scale in a university sample. International Journal of Sport and Exercise Psychology, 6(2), 115–131. https://doi.org/10.1080/1612197X.2008.9671857

* Upload the data (you will need it edit the file path)

GET DATA  /TYPE=TXT 
  /FILE="/Users/YourUserName/sample_data.csv" 
  /ENCODING='UTF8' 
  /DELIMITERS="," 
  /QUALIFIER='"' 
  /ARRANGEMENT=DELIMITED 
  /FIRSTCASE=2 
  /DATATYPEMIN PERCENTAGE=95.0 
  /VARIABLES= 
  PAIntentionsraw AUTO 
  PABehavioursraw AUTO 
  PAHabitraw AUTO 
  PAIdentityraw AUTO 
  /MAP. 
RESTORE. 
CACHE. 
EXECUTE. 

* Convert variables to numbers

RECODE PAIntentionsraw ('0 days'=0) ('1 day'=1) ('2 days'=2) ('3 days'=3) ('4 days'=4) ('5 '+
    'days'=5) ('6 days'=6) ('7 days'=7) INTO PAIntentionNumbers.
EXECUTE.
RECODE PABehavioursraw ('0 days'=0) ('1 day'=1) ('2 days'=2) ('3 days'=3) ('4 days'=4)
    ('5 days'=5) ('6 days'=6) ('7 days'=7) INTO PABehaviourNumbers.
EXECUTE.
RECODE PAHabitraw ('Strongly Disagree'=1) ('Disagree'=2) ('Neither Agree '+
    'nor Disagree'=3) ('Agree'=4) ('Strongly Agree'=5) INTO Habit.
EXECUTE.
RECODE PAIdentityraw ('Strongly Disagree'=1) ('Disagree'=2) ('Neither Agree nor '+
    'Disagree'=3) ('Agree'=4) ('Strongly Agree'=5) INTO Identity.
EXECUTE.

* Check for outliers

EXAMINE VARIABLES=PAIntentionNumbers PABehaviourNumbers Habit Identity
  /STATISTICS DESCRIPTIVES.

* Recode outliers if needed 

* Check for outliers again and examine descriptive statistics

EXAMINE VARIABLES=PAIntentionNumbers PABehaviourNumbers Habit Identity
  /STATISTICS DESCRIPTIVES.

* Recode PAIntentionNumbers into PAIntentions.
RECODE PAIntentionNumbers (Lowest thru 2=0) (3 thru Highest=1) INTO PAIntentions.
EXECUTE.

* Recode PABehaviourNumbers into PABehaviours.
RECODE PABehaviourNumbers (Lowest thru 2=0) (3 thru Highest=1) INTO PABehaviours.
EXECUTE.

* Recode Habit into PAHabit.
RECODE Habit (Lowest thru 3=0) (4 thru Highest=1) INTO PAHabit.
EXECUTE.

* Recode Identity into PAIdentity.
RECODE Identity (Lowest thru 3=0) (4 thru Highest=1) INTO PAIdentity.
EXECUTE.

* Create the following 8 profiles
i.	Non-Intenders – both low
ii.	Unsuccessful Adopters – both low
iii.	Successful Adopters – both low
iv.	Successful Maintainers – either high
v.	Non-Intenders – either high
vi.	Unsuccessful Non-Intenders – both low
vii.	Unsuccessful Non-Intenders – either high
viii.	Unsuccessful Adopters – either high

* Compute Nonintenders_BothLow only if conditions are met.
DO IF (NOT SYSMIS(PAIntentions) AND NOT SYSMIS(PABehaviours) AND 
        (NOT SYSMIS(PAIdentity) OR NOT SYSMIS(PAHabit))).
   COMPUTE Nonintenders_BothLow = (PAIntentions = 0 AND PABehaviours = 0 AND 
                                PAIdentity = 0 AND PAHabit = 0).
ELSE.
   COMPUTE Nonintenders_BothLow = $SYSMIS.
END IF.

* Compute UnsuccessfulAdopters_BothLow only if conditions are met.
DO IF (NOT SYSMIS(PAIntentions) AND NOT SYSMIS(PABehaviours) AND 
        (NOT SYSMIS(PAIdentity) OR NOT SYSMIS(PAHabit))).
   COMPUTE UnsuccessfulAdopters_BothLow = (PAIntentions = 1 AND PABehaviours = 0 AND 
                                        PAIdentity = 0 AND PAHabit = 0).
ELSE.
   COMPUTE UnsuccessfulAdopters_BothLow = $SYSMIS.
END IF.

* Compute SuccessfulAdopters_BothLow only if conditions are met.
DO IF (NOT SYSMIS(PAIntentions) AND NOT SYSMIS(PABehaviours) AND 
        (NOT SYSMIS(PAIdentity) OR NOT SYSMIS(PAHabit))).
   COMPUTE SuccessfulAdopters_BothLow = (PAIntentions = 1 AND PABehaviours = 1 AND 
                                       PAIdentity = 0 AND PAHabit = 0).
ELSE.
   COMPUTE SuccessfulAdopters_BothLow = $SYSMIS.
END IF.

* Compute SuccessfulMaintainers_EitherHigh only if conditions are met.
DO IF (NOT SYSMIS(PAIntentions) AND NOT SYSMIS(PABehaviours) AND 
        (NOT SYSMIS(PAIdentity) OR NOT SYSMIS(PAHabit))).
   COMPUTE SuccessfulMaintainers_EitherHigh = (PAIntentions = 1 AND PABehaviours = 1 AND (PAIdentity = 1 OR PAHabit = 1)).
ELSE.
   COMPUTE SuccessfulMaintainers_EitherHigh = $SYSMIS.
END IF.

* Compute Nonintenders_EitherHigh only if conditions are met.
DO IF (NOT SYSMIS(PAIntentions) AND NOT SYSMIS(PABehaviours) AND 
        (NOT SYSMIS(PAIdentity) OR NOT SYSMIS(PAHabit))).
   COMPUTE Nonintenders_EitherHigh = (PAIntentions = 0 AND PABehaviours = 0 AND 
                                   (PAIdentity = 1 OR PAHabit = 1)).
ELSE.
   COMPUTE Nonintenders_EitherHigh = $SYSMIS.
END IF.

* Compute UnsuccessfulNonintenders_BothLow only if conditions are met.
DO IF (NOT SYSMIS(PAIntentions) AND NOT SYSMIS(PABehaviours) AND 
        (NOT SYSMIS(PAIdentity) OR NOT SYSMIS(PAHabit))).
   COMPUTE UnsuccessfulNonintenders_BothLow = (PAIntentions = 0 AND PABehaviours = 1 AND 
                                            PAIdentity = 0 AND PAHabit = 0).
ELSE.
   COMPUTE UnsuccessfulNonintenders_BothLow = $SYSMIS.
END IF.

* Compute UnsuccessfulNonintenders_EitherHigh only if conditions are met.
DO IF (NOT SYSMIS(PAIntentions) AND NOT SYSMIS(PABehaviours) AND 
        (NOT SYSMIS(PAIdentity) OR NOT SYSMIS(PAHabit))).
   COMPUTE UnsuccessfulNonintenders_EitherHigh = (PAIntentions = 0 AND PABehaviours = 1 AND 
                                              (PAIdentity = 1 OR PAHabit = 1)).
ELSE.
   COMPUTE UnsuccessfulNonintenders_EitherHigh= $SYSMIS.
END IF.

* Compute UnsuccessfulAdopters_EitherHigh only if conditions are met.
DO IF (NOT SYSMIS(PAIntentions) AND NOT SYSMIS(PABehaviours) AND 
        (NOT SYSMIS(PAIdentity) OR NOT SYSMIS(PAHabit))).
   COMPUTE UnsuccessfulAdopters_EitherHigh = (PAIntentions = 1 AND PABehaviours = 0 AND 
                                          (PAIdentity = 1 OR PAHabit = 1)).
ELSE.
   COMPUTE UnsuccessfulAdopters_EitherHigh = $SYSMIS.
END IF.
EXECUTE.

* Integrate the profiles into one variable 

COMPUTE Overall_Profile=(Nonintenders_BothLow*1) + (UnsuccessfulAdopters_BothLow*2) + (SuccessfulAdopters_BothLow*3) + (SuccessfulMaintainers_EitherHigh*4) +
   (Nonintenders_EitherHigh*5) + (UnsuccessfulNonintenders_BothLow*6) +
    (UnsuccessfulNonintenders_EitherHigh*7) + (UnsuccessfulAdopters_EitherHigh*8).
EXECUTE.
  
* Add labels to the profile variable

VALUE LABELS Overall_Profile
1 'NonIntenders_BothLow'
2 'UnsuccessfulAdopters_BothLow'
3 'SuccessfulAdopters_BothLow'
4 'SuccessfulMaintainers_EitherHigh'
5 'NonIntenders_ EitherHigh '
6 'UnsuccessfulNonIntenders_BothLow'
7 'UnsuccessfulNonIntenders_ EitherHigh '
8 'UnsuccessfulAdopters_EitherHigh '

* Calculate frequencies of the profile variable

FREQUENCIES Overall_Profile.

