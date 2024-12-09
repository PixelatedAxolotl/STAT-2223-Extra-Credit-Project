/***IMPORTANT***/
/*
*	ALL the csv files and SAS code files should be kept in the same folder!
*	
*	THE ONLY PATH YOU NEED TO CHANGE IS THE projectDirPath HERE
*	Change it to whatever the path is for the folder than holds this file and the Multilinear Project Dataset .csv file
*	ALSO: if you change the name of Multilinear Project Dataset you must also change the name in the "%LET inFile" line
*/
%LET projectDirPath = C:\Users\allth\Documents\CLASSES\STAT-2223-004\FinalProject;

%LET inFile = %SYSFUNC(CATX(\, &projectDirPath, Multilinear Project Dataset - COMP-SCI + DATA SCIENCE.csv));
%LET cleanDataFile = %SYSFUNC(CATX(\, &projectDirPath, cleanData.csv));

/*DUMMY VARIABLE GENERATION - DO NOT KEEP COPYING EVERY TIME OR YOU WILL HAVE TO CHANGE THE PATHS EACH TIME*/
/*Import dataset from downloaded csv file*/
/*PATH: replace full path if getting file can't be found error on Aporto*/
PROC IMPORT DATAfile="&inFile"
    out=work.dataset
    dbms=csv
	REPLACE;	/*overwrite dataset if it already exists (it shouldn't already exist but just to be safe*/
	getnames=yes;
RUN;


/*DEBUG: print dataset to check that it imported correctly*/
/*PROC PRINT data=work.dataset;
RUN;
*/


/*ADD DUMMY VARIABLES + CLEAN DATA
	-matching case insensitively with UPCASE*/
DATA dummyDataset;
SET work.dataset;

	/*Dummy variable for MAJOR
		-INDEX searches field for substring to account for double majors 
		 who may have but computer science and another major
	*/
	IF INDEX(UPCASE(Major), 'COMPUTER SCIENCE') > 0 THEN Major_D=1;
		ELSE Major_D=0;

	/*Dummy variable for LISTEN_MUSIC*/
	IF UPCASE(listen_music)='YES' THEN listen_music_D=1;
		ELSE listen_music_D=0;

	/*Dummy variable for STUDY_MUSIC*/
	IF UPCASE(study_music)='YES' THEN study_music_D=1;
		ELSE study_music_D=0;

	/*Dummy variables for STUDY_MUSIC_LYRICS
		-Reference group: 'NO'*/
	IF UPCASE(study_lyrics)='YES' THEN studyL_yes_D=1;
		ELSE studyL_yes_D=0;
	IF UPCASE(study_lyrics)='SOMETIMES' THEN studyL_some_D=1;
		ELSE studyL_some_D=0;


	/*Translates levels into numbers (for sgcatter visualizations)*/
	IF UPCASE(study_lyrics)='NO' THEN study_lyrics_num=0;
	IF UPCASE(study_lyrics)='YES' THEN study_lyrics_num=1;
	IF UPCASE(study_lyrics)='SOMETIMES' THEN study_lyrics_num=2;



	/*Dummy variables for GENRE + generation of genra count per observation
		-Oof
		-Reference Group: NA
		-Current Count: 15 levels, 14 Dummy variables


		- creates new column g_cnt with a count of how many genres a given respondant selected
			if a person chose 3 genres g_cnt = 3 if they chose 10 g_cnt = 10.
			This can be used to weight the observations.

		-TO ADD NEW DUMMY VARIABLES:
		copy the following code snippet and change:
			-NEW GENRE to the genra you are adding
			-GENREDUMMY to whatever you want the name of the new genra's dummy variable to be

				IF INDEX(UPCASE(genre), 'NEW GENRE') > 0 THEN do 
					GENREDUMMY=1; 
					g_cnt + 1; 
					END;
				ELSE genrePop=0; 
	*/
	g_cnt = 0;
	IF INDEX(UPCASE(genre), 'POP') > 0 THEN do 
		genrePop=1; 
		g_cnt + 1; 
		END;
	ELSE genrePop=0;
	IF INDEX(UPCASE(genre), 'HIP HOP') > 0 THEN do
		genreHipHop=1;
		g_cnt + 1; 
		END;
	ELSE genreHipHop=0;
	IF INDEX(UPCASE(genre), 'JAZZ') > 0 THEN do
		genreJazz=1;
		g_cnt + 1; 
		END;
	ELSE genreJazz=0;
	IF INDEX(UPCASE(genre), 'CLASSICAL/INSTRUMENTAL') > 0 THEN do 
		genreClassic=1;
		g_cnt + 1; 
		END;
	ELSE genreClassic=0;
	IF INDEX(UPCASE(genre), 'HOUSE') > 0 THEN do 
		genreHouse=1;
		g_cnt + 1; 
		END;
	ELSE genreHouse=0;
	IF INDEX(UPCASE(genre), 'ALTERNATIVE') > 0 THEN do 
		genreAlt=1;
		g_cnt + 1; 
		END;
	ELSE genreAlt=0;
	IF INDEX(UPCASE(genre), 'CONTEMPORARY') > 0 THEN do 
		genreContemp=1;
		g_cnt + 1; 
		END;
	ELSE genreContemp=0;
	IF INDEX(UPCASE(genre), 'ROCK') > 0 THEN do 
		genreRock=1;
		g_cnt + 1; 
		END;
	ELSE genreRock=0;
	IF INDEX(UPCASE(genre), 'COUNTRY') > 0 THEN do 
		genreCountry=1;
		g_cnt + 1; 
		END;
	ELSE genreCountry=0;
	IF INDEX(UPCASE(genre), 'KPOP') > 0 THEN do 
		genreKpop=1;
		g_cnt + 1; 
		END;
	ELSE genreKpop=0;
	IF INDEX(UPCASE(genre), 'FOLK') > 0 THEN do 
		genreFolk=1;
		g_cnt + 1; 
		END;
	ELSE genreFolk=0;
	IF INDEX(UPCASE(genre), 'AFROBEAT') > 0 THEN do 
		genreAfro=1;
		g_cnt + 1; 
		END;
	ELSE genreAfro=0;
	IF INDEX(UPCASE(genre), 'METAL') > 0 THEN do 
		genreMetal=1;
		g_cnt + 1; 
		END;
	ELSE genreMetal=0;
	IF INDEX(UPCASE(genre), 'R&B') > 0 THEN do 
		genreRnB=1;
		g_cnt + 1; 
		END;
	ELSE genreRnB=0;

	/*Anything that doesn't match to one of our 14 genres just gets thrown in an OTHER category
		TO DO: clean the data a bit by hand to standardize some of the genres. Like 'christian rock' doesn't
			   need its own genre, it can just be replaced by 'rock'. Not a real good way to do this other than by
			   hand, at least for this project :( */
	array genres[12] $50 _temporary_ ('POP', 'HIP HOP', 'JAZZ', 'CLASSICAL/INSTRUMENTAL', 
                                       'HOUSE', 'ALTERNATIVE', 'CONTEMPORARY', 'ROCK', 
                                       'COUNTRY', 'KPOP', 'FOLK', 'AFROBEAT', 'METAL', 'R&B');
	    match_found = 0;  /* Flag to indicate if a match is found */

	    /* Loop through the array to check for a match */
	    do i = 1 to dim(genres);
			%PUT "DEBUGGING";
	        if index(UPCASE(genre), genres[i]) > 0 then do;
	            match_found = 1;
				%put "Debug: Match found for " genres[i] " at iteration " i;  /* Debug message */
	            leave;  /* Exit loop once a match is found */
	        end;
	    end;

	    /* If no match is found, set string to "OTHER" */
	    if match_found = 0 then genre = 'OTHER';



	/*Dummy variables for preferred_study_hours
		-Reference Group: 1AM - 4AM
		-INDEX searches field for substring to account for multiple choice answers
	*/
	IF INDEX(UPCASE(preferred_study_hours), '5AM - 11AM') > 0 THEN prefStudy5_11=1;
		ELSE prefStudy5_11=0;
	IF INDEX(UPCASE(preferred_study_hours), '12PM - 5PM') > 0 THEN prefStudy12_5=1;
		ELSE prefStudy12_5=0;
	IF INDEX(UPCASE(preferred_study_hours), '6PM - MIDNIGHT') > 0 THEN prefStudy6_12=1;
		ELSE prefStudy6_12=0;



	/*Dummy variables for study_effect
		-No observations with:
			- Nope
			- I think studying made me understand less actually
		-Because of that: only including the 4 levels that were used in at least 1 observation
		-Reference Group: Maybe a litte
	*/


	/*IF UPCASE(study_effect)='NOPE' THEN studyEfficacy1=1;
		ELSE studyEfficacy2=0;
	IF UPCASE(study_effect)='MAYBE A LITTLE' THEN studyEfficacy2=1;
		ELSE studyEfficacy3=0;*/
	IF UPCASE(study_effect)='SOMETIMES' THEN studyEfficacy3=1;
		ELSE studyEfficacy3=0;
	IF UPCASE(study_effect)='YES' THEN studyEfficacy4=1;
		ELSE studyEfficacy4=0;
	IF UPCASE(study_effect)='YES, DEFINITELY' THEN studyEfficacy5=1;
		ELSE studyEfficacy5=0;

		

	/*Translates study_effect levels into numbers (for sgscatter visulization)*/
	IF UPCASE(study_effect)='I THINK STUDYING MADE ME UNDERSTAND LESS ACTUALLY' THEN study_effect=0;
	IF UPCASE(study_effect)='NOPE' THEN study_effect=1;
	IF UPCASE(study_effect)='MAYBE A LITTLE' THEN study_effect=2;
	IF UPCASE(study_effect)='SOMETIMES' THEN study_effect=3;
	IF INDEX(UPCASE(study_effect), 'YES') > 0 THEN study_effect=4;
	IF UPCASE(study_effect)='YES DEFINITELY' THEN study_effect=5;


RUN; /*run statements to create dummy variables*/

/*Remove any % or - from Information_retained column
	-Not sure why this only works like this - will not work if combined into the dummy variable generation dataset
		for reasons known only to SAS*/
DATA cleanNumbers;
    set dummyDataset;
	
	Information_retained = tranwrd(Information_retained, "%", "");
	Information_retained = tranwrd(Information_retained, "-", "");
run;


/*Print dataset and make sure everything looks good*/
proc print data=cleanNumbers;
title "DEBUG: CLEAN DATA + DUMMY VARIABLES";
RUN;


/*print dataset to .csv file*/
/*PATH: Replace with full path if getting file not found errors in Aporto*/
proc EXPORT data=cleanNumbers
	OUTFILE="&cleanDataFile"
	DBMS=csv
	REPLACE;	/*THIS WILL OVERWRITE THE cleanData.csv FILE IF IT ALREADY EXISTS*/
RUN;




/***REGRESSION CODE***/


/*Import dataset from downloaded csv file*/
/*PATH: Replace with full path if getting file not found errors in Aporto*/
PROC IMPORT DATAfile="&cleanDataFile"
	out=work.dataset
	dbms=csv
	REPLACE;		/*overwrite dataset if it already exists (it shouldn't already exist but just to be safe*/
	GETNAMES=yes;	/*lets us use the column headers as variable names automatically*/
RUN;

/*DEBUG: check data types - if data isn't cleaned properly sometimes numeric will end up as char types.
		 This will cause problems later for sgscatter and glm*/
PROC CONTENTS data=work.dataset;
	TITLE "DEBUG: DATA TYPE CHECK";
RUN;

/*making the matrix plot
* NEEDS SOME WORK TO MAKE IT MORE READABLE
* TO DO: Maybe some other types of visualizations???
*/
proc sgscatter data=work.dataset;
title "MATRIX";
matrix Age Major_D listen_music_D study_music_D Information_retained Total_study_time ;
run;



/*
*	study_lyrics_num = same as study_lyrics but with numbers instead of words for each level
*
*	IMPORTANT: look at Type III SS output NOT Type I SS
*		I stuck all these in random order and Type I is order dependent to it is useless for
*		this atm
*/
PROC GLM data=work.dataset;
	title "GLM METHOD - CURRENT";
    class Major_D 			listen_music_D 			study_music_D 	study_lyrics_num 	
		  study_effect  	
	;

	model Total_study_time = 
							 /*Continuous Variables*/
							 Major_D 				  	Age 		Information_retained				

							 /*Dummy variables + Categorical variables*/
							 listen_music_D 			study_music_D 		 		study_lyrics_num	
							 study_effect

							 genrePop 					genreHipHop 				genreJazz 	
							 genreClassic 				genreHouse 					genreAlt 
                             genreContemp 				genreRock 					genreCountry 
							 genreKpop 					genreFolk 					genreAfro 
							 genreMetal					genreRnB

							 prefStudy5_11				prefStudy12_5				prefStudy6_12
	;
	
RUN;
QUIT;	/*stop GLM from running indefinitely*/

PROC REG data=work.dataset;
	title "REG METHOD - CURRENT";

	model Total_study_time = 
							 /*Continuous Variables*/
							 Age 		Information_retained				

							 /*Dummy variables + Categorical variables*/
							 Major_D  			listen_music_D 		study_music_D 		 		
							 studyL_yes_D		studyL_some_D

							 genrePop 			genreHipHop 		genreJazz 	
							 genreClassic 		genreHouse 			genreAlt 
                             genreContemp 		genreRock 			genreCountry 
							 genreKpop 			genreFolk 			genreAfro 
							 genreMetal			genreRnB

							 prefStudy5_11		prefStudy12_5		prefStudy6_12

							 /*studyEfficacy1	studyEfficacy2*/	studyEfficacy3
							 studyEfficacy4		studyEfficacy5	
	;

	/*test significance of continuous variables*/
	Age_Test: test Age=0;
	InfoRetained_Test: test Information_retained=0;
	

	/*test significance of 2 level + 3 level categorical variables*/
	Major_Test: test Major_D=0;
	Listen_Music_Test: test listen_music_D=0;

	study_music_D_Test: test study_music_D = 0;
	studyL_yes_D_Test: test studyL_yes_D = 0;
	studyL_some_D_Test: test studyL_some_D = 0;

	prefStudy5_11_Test: test prefStudy5_11 = 0;
	prefStudy12_5_Test: test prefStudy12_5 = 0;
	prefStudy6_12_Test: test prefStudy6_12 = 0;

	studyEfficacy3_Test: test studyEfficacy3 = 0;
	studyEfficacy4_Test: test studyEfficacy4 = 0;
	studyEfficacy5_Test: test studyEfficacy5 = 0;


	/*test significance of genre dummy variables*/
	genrePop_Test: test genrePop = 0;
	genreHipHop_Test: test genreHipHop = 0;
	genreJazz_Test: test genreJazz = 0;
	genreClassic_Test: test genreClassic = 0;
	genreHouse_Test: test genreHouse = 0;
	genreAlt_Test: test genreAlt = 0;
	genreContemp_Test: test genreContemp = 0;
	genreRock_Test: test genreRock = 0;
	genreCountry_Test: test genreCountry = 0;
	genreKpop_Test: test genreKpop = 0;
	genreFolk_Test: test genreFolk = 0;
	genreAfro_Test: test genreAfro = 0;
	genreMetal_Test: test genreMetal = 0;
	genreRnB_Test: test genreRnB = 0;

	
RUN;
QUIT;

