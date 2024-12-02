/*Import dataset from downloaded csv file*/
PROC IMPORT datafile="C:\Users\allth\Documents\CLASSES\STAT-2223-004\FinalProject\Project Dataset - COMP-SCI + DATA SCIENCE.csv"
    out=work.dataset
    dbms=csv
	REPLACE;	/*overwrite dataset if it already exists (it shouldn't already exist but just to be safe*/
	GETNAMES=yes;
RUN;

/*print dataset to check that it imported correctly*/
PROC PRINT data=work.dataset;
RUN;

/*Add dummy variables
	-matching case insensitively with UPCASE*/
DATA dummyDataset;
SET work.dataset;

	/*Dummy variable for MAJOR
		-INDEX searches field for substring to account for double majors 
		 who may have but computer science and another major
	*/
	IF INDEX(UPCASE(Major), 'COMPUTER SCIENCE') > 0 THEN compSci=1;
		ELSE compSci=0;

	/*Dummy variable for LISTEN_MUSIC*/
	IF UPCASE(listen_music)='YES' THEN music=1;
		ELSE music=0;

	/*Dummy variable for STUDY_MUSIC*/
	IF UPCASE(study_music)='YES' THEN studyM=1;
		ELSE studyM=0;

	/*Dummy variables for STUDY_MUSIC_LYRICS
		-Reference group: 'NO'*/
	IF UPCASE(study_music_lyrics)='YES' THEN studyMLyricsYes=1;
		ELSE studyMLyricsYes=0;
	IF UPCASE(study_music_lyrics)='SOMETIMES' THEN studyMLyricsSome=1;
		ELSE studyMLyricsSome=0;

	/*Dummy variables for GENRE
		-Oof
		-Reference Group: R&B
		-Current Count: 14 levels, 13 Dummy variables
	*/
	IF INDEX(UPCASE(genre), 'POP') > 0 THEN genrePop=1;
			ELSE genrePop=0;
	IF INDEX(UPCASE(genre), 'HIP HOP') > 0 THEN genreHipHop=1;
		ELSE genreHipHop=0;
	IF INDEX(UPCASE(genre), 'Jazz') > 0 THEN genreJazz=1;
		ELSE genreJazz=0;
	IF INDEX(UPCASE(genre), 'CLASSICAL/INSTRUMENTAL') > 0 THEN genreClassic=1;
		ELSE genreClassic=0;
	IF INDEX(UPCASE(genre), 'HOUSE') > 0 THEN genreHouse=1;
		ELSE genreHouse=0;
	IF INDEX(UPCASE(genre), 'ALTERNATIVE') > 0 THEN genreAlt=1;
		ELSE genreAlt=0;
	IF INDEX(UPCASE(genre), 'CONTEMPORARY') > 0 THEN genreContemp=1;
		ELSE genreComtemp=0;
	IF INDEX(UPCASE(genre), 'ROCK') > 0 THEN genreRock=1;
		ELSE genreRock=0;
	IF INDEX(UPCASE(genre), 'COUNTRY') > 0 THEN genreCountry=1;
		ELSE genreCountry=0;
	IF INDEX(UPCASE(genre), 'KPOP') > 0 THEN genreKpop=1;
		ELSE genreKpop=0;
	IF INDEX(UPCASE(genre), 'FOLK') > 0 THEN genreFolk=1;
		ELSE genreFolk=0;
	IF INDEX(UPCASE(genre), 'AFROBEAT') > 0 THEN genreAfro=1;
		ELSE genreAfro=0;
	IF INDEX(UPCASE(genre), 'METAL') > 0 THEN genreMetal=1;
		ELSE genreMetal=0;

	/*Dummy variables for prefered_study_hours
		-Reference Group: 1AM - 4AM
		-INDEX searches field for substring to account for multiple choice answers
	*/
	IF INDEX(UPCASE(prefered_study_hours), '5AM - 11AM') > 0 THEN prefStudy5_11=1;
		ELSE prefStudy5_11=0;
	IF INDEX(UPCASE(prefered_study_hours), '12PM - 5PM') > 0 THEN prefStudy12_5=1;
		ELSE prefStudy12_5=0;
	IF INDEX(UPCASE(prefered_study_hours), '6PM - MIDNIGHT') > 0 THEN prefStudy6_12=1;
		ELSE prefStudy6_12=0;


	/*Dummy variables for study_effect
		-Reference Group: I think studying made me understand less actually
		-Dummy variables named 2-6 (1 is not included since that would correspond 
		 	to the reference group which doesn't get a dummy variable). 
			6 is most effective, 1 is not effective at all.
	*/
	IF UPCASE(study_effect)='NOPE' THEN studyEfficacy2=1;
		ELSE studyEfficacy2=0;
	IF UPCASE(study_effect)='MAYBE A LITTLE' THEN studyEfficacy3=1;
		ELSE studyEfficacy3=0;
	IF UPCASE(study_effect)='SOMETIMES' THEN studyEfficacy4=1;
		ELSE studyEfficacy4=0;
	IF UPCASE(study_effect)='YES' THEN studyEfficacy5=1;
		ELSE studyEfficacy5=0;
	IF UPCASE(study_effect)='YES, DEFINITELY' THEN studyEfficacy6=1;
		ELSE studyEfficacy6=0;
		

RUN; /*run statements to create dummy variables*/

proc print data=dummyDataset;
RUN;


/*print dataset to .csv file*/
proc EXPORT DATA=dummyDataset
	OUTFILE="C:\Users\allth\Documents\CLASSES\STAT-2223-004\FinalProject\cleanDataset.csv"
	DBMS=csv
	REPLACE;	/*THIS WILL OVERWRITE THE FILE IF IT ALREADY EXISTS*/
RUN;


