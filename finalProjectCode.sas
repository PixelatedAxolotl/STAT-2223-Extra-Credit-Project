/***IMPORTANT***/
/*
*	ALL the csv files and SAS code files must be kept in the same folder!
*	
*	THE ONLY PATH YOU NEED TO CHANGE IS THE projectDirPath HERE
*	Change it to whatever the path is for the folder than holds this file and the Multilinear Project Dataset .csv file
*	
*   NOTE: if you change the name of Multilinear Project Dataset you must also change the name in the "%LET inFile" line
*/
%LET projectDirPath = C:\Users\allth\Documents\GitHub\STAT-2223-Extra-Credit-Project;

%LET inFile = %SYSFUNC(CATX(\, &projectDirPath, rawData.csv));
%LET cleanDataFile = %SYSFUNC(CATX(\, &projectDirPath, cleanData.csv));

/*Import dataset from downloaded csv file*/
/*PATH: replace full path if getting file can't be found error on Aporto*/
PROC IMPORT DATAfile="&inFile"
    out=work.dataset
    dbms=csv
	REPLACE;	/*overwrite dataset if it already exists (it shouldn't already exist but just to be safe*/
	getnames=yes;
RUN;



/*ADD DUMMY VARIABLES + CLEAN DATA
	-matching case insensitively with UPCASE
    -INDEX searches field for substring
*/
DATA dummyDataset;
SET work.dataset;

	/*Dummy variable for MAJOR*/
	Major=UPCASE(Major);
	IF INDEX(Major, 'COMPUTER SCIENCE') > 0 THEN Major_D=1;
		ELSE Major_D=0;

	

	/*Dummy variable for LISTEN_MUSIC*/
	IF UPCASE(listen_music)='YES' THEN listen_music_D=1;
		ELSE listen_music_D=0;

	/*Dummy variable for STUDY_MUSIC*/
	IF UPCASE(study_music)='YES' THEN study_music_D=1;
		ELSE study_music_D=0;

	/*Dummy variables for STUDY_MUSIC_LYRICS
		-REFERENCE GROUP: 'NO'*/
	study_lyrics = UPCASE(study_lyrics);
	IF study_lyrics='YES' THEN studyL_yes_D=1;
		ELSE studyL_yes_D=0;
	IF study_lyrics='SOMETIMES' THEN studyL_some_D=1;
		ELSE studyL_some_D=0;


	/*Translates levels into numbers (for sgcatter visualizations)*/
	IF study_lyrics='NO' THEN study_lyrics_num=0;
	IF study_lyrics='YES' THEN study_lyrics_num=1;
	IF study_lyrics='SOMETIMES' THEN study_lyrics_num=2;



	/*Dummy variables for GENRE + generation of genra count per observation
		-Oof
		-REFERENCE GROUP: NA
		-Current Count: 15 levels, 14 Dummy variables


		- creates new column g_cnt with a count of how many genres a given respondant selected
			if a person chose 3 genres g_cnt = 3 if they chose 10 g_cnt = 10.
			This can be used to weight the observations.
	*/
	Genre=UPCASE(Genre);
	IF INDEX(genre, 'POP') > 0 THEN do 
		genrePop=1; 
		g_cnt + 1; 
		END;
		ELSE genrePop=0;
	IF INDEX(Genre, 'HIP HOP') > 0 THEN do
		genreHipHop=1;
		g_cnt + 1; 
		END;
		ELSE genreHipHop=0;
	IF INDEX(UPCASE(genre), 'JAZZ') > 0 THEN do
		genreJazz=1;
		g_cnt + 1; 
		END;
		ELSE genreJazz=0;
	IF INDEX(Genre, 'CLASSICAL/INSTRUMENTAL') > 0 THEN do 
		genreClassic=1;
		g_cnt + 1; 
		END;
		ELSE genreClassic=0;
	IF INDEX(Genre, 'HOUSE') > 0 THEN do 
		genreHouse=1;
		g_cnt + 1; 
		END;
		ELSE genreHouse=0;
	IF INDEX(Genre, 'ALTERNATIVE') > 0 THEN do 
		genreAlt=1;
		g_cnt + 1; 
		END;
		ELSE genreAlt=0;
	IF INDEX(Genre, 'CONTEMPORARY') > 0 THEN do 
		genreContemp=1;
		g_cnt + 1; 
		END;
		ELSE genreContemp=0;
	IF INDEX(Genre, 'ROCK') > 0 THEN do 
		genreRock=1;
		g_cnt + 1; 
		END;
	ELSE genreRock=0;
	IF INDEX(Genre, 'COUNTRY') > 0 THEN do 
		genreCountry=1;
		g_cnt + 1; 
		END;
		ELSE genreCountry=0;
	IF INDEX(Genre, 'KPOP') > 0 THEN do 
		genreKpop=1;
		g_cnt + 1; 
		END;
		ELSE genreKpop=0;
	IF INDEX(Genre, 'FOLK') > 0 THEN do 
		genreFolk=1;
		g_cnt + 1; 
		END;
		ELSE genreFolk=0;
	IF INDEX(Genre, 'AFROBEAT') > 0 THEN do 
		genreAfro=1;
		g_cnt + 1; 
		END;
	ELSE genreAfro=0;
	IF INDEX(Genre, 'METAL') > 0 THEN do 
		genreMetal=1;
		g_cnt + 1; 
		END;
		ELSE genreMetal=0;
	IF INDEX(Genre, 'R&B') > 0 THEN do 
		genreRnB=1;
		g_cnt + 1; 
		END;
		ELSE genreRnB=0;



	/*Dummy variables for preferred_study_hours
		-INDEX searches field for substring to account for multiple choice answers
		-REFERENCE GROUP: 1AM - 4AM
	*/
	preferred_study_hours = UPCASE(preferred_study_hours); /*capitalize for easy matching*/
	IF INDEX(preferred_study_hours, '5AM - 11AM') > 0 THEN prefStudy5_11=1;
		ELSE prefStudy5_11=0;
	IF INDEX(preferred_study_hours, '12PM - 5PM') > 0 THEN prefStudy12_5=1;
		ELSE prefStudy12_5=0;
	IF INDEX(preferred_study_hours, '6PM - MIDNIGHT') > 0 THEN prefStudy6_12=1;
		ELSE prefStudy6_12=0;



	/*Dummy variables for study_effect
		-No observations with:
			- Nope
			- I think studying made me understand less actually
		-Because of that: only including the 4 levels that were used in at least 1 observation
		-REFERENCE GROUP: Maybe a litte
	*/
	study_effect = UPCASE(study_effect); /*capitalize for easy matching*/
	IF study_effect='SOMETIMES' THEN studyEfficacy3=1;
		ELSE studyEfficacy3=0;
	IF study_effect='YES' THEN studyEfficacy4=1;
		ELSE studyEfficacy4=0;
	IF study_effect='YES, DEFINITELY' THEN studyEfficacy5=1;
		ELSE studyEfficacy5=0;

		

	/*Translates study_effect levels into numbers (for sgscatter visulization)*/
	IF study_effect='I THINK STUDYING MADE ME UNDERSTAND LESS ACTUALLY' THEN study_effect=0;
	IF study_effect='NOPE' THEN study_effect=1;
	IF study_effect='MAYBE A LITTLE' THEN study_effect=2;
	IF study_effect='SOMETIMES' THEN study_effect=3;
	IF INDEX(study_effect, 'YES') > 0 THEN study_effect=4;
	IF study_effect='YES DEFINITELY' THEN study_effect=5;


RUN; /*run statements to create dummy variables*/

/*Remove any % or - from Information_retained column
	-Not sure why this only works like this - will not work if combined into 
        the dummy variable generation dataset for reasons known only to SAS
*/
DATA cleanNumbers;
    set dummyDataset;
	
	Information_retained = tranwrd(Information_retained, "%", "");
	Information_retained = tranwrd(Information_retained, "-", "");
run;


/*print dataset to .csv file*/
/*IF YOU ARE GETTING FILE NOT FOUND ERRORS: Replace with full path if getting file not found errors in Aporto*/
proc EXPORT data=cleanNumbers
	OUTFILE="&cleanDataFile"
	DBMS=csv
	REPLACE;	/*overwrites cleanData.csv if it already exists*/
RUN;





/*writing to file and reading back in is the only thing that seems to correctly switch
  some of the field's datatypes after data is cleaned???*/

/*Import dataset from newly created csv file*/
/*IF YOU ARE GETTING FILE NOT FOUND ERRORS: Replace with full path if getting file not found errors in Aporto*/
PROC IMPORT DATAfile="&cleanDataFile"
	out=work.dataset
	dbms=csv
	REPLACE;		/*overwrite dataset if it already exists (it shouldn't already exist but just to be safe*/
	GETNAMES=yes;	/*lets us use the column headers as variable names automatically*/
RUN;

/*Print dataset and make sure everything looks good*/
proc print data=work.dataset;
title "DEBUG: CLEAN DATA + DUMMY VARIABLES";
RUN;

/*DEBUG: check data types - if data isn't cleaned properly sometimes numeric will end up as char types.
		 This will cause problems later for sgscatter and glm*/
PROC CONTENTS data=work.dataset;
	TITLE "DEBUG: DATA TYPE CHECK";
RUN;



/*matrix scatter plot*/
proc sgscatter data=work.dataset;
title "MATRIX";
matrix Age study_music_D Information_retained Total_study_time ;
run;




/***REGRESSION ANALYSIS CODE***/

/*** 1ST MODEL (Total study time): NO INTERACTIONS ***/

PROC REG data = work.dataset;
title "Full Model - No Interactions";

model Total_study_time =
      /*Continuous Variables*/
      Age             Information_retained

      /*Dummy variables + Categorical variables*/
      Major_D         listen_music_D 
      study_music_D   studyL_yes_D    studyL_some_D
      prefStudy5_11   prefStudy12_5   prefStudy6_12
      studyEfficacy3  studyEfficacy4  studyEfficacy5

      genrePop        genreHipHop     genreJazz
      genreClassic    genreHouse      genreAlt
      genreContemp    genreRock       genreCountry
      genreKpop       genreFolk       genreAfro
      genreMetal      genreRnB
	;/*end of model*/
                                      

/*test significance of continuous variables*/
Age_Test : test Age = 0;
informationRetainedTest : test Information_retained = 0;

/*test significance of 2 level + 3 level categorical variables*/
Major_Test : test Major_D = 0;
Listen_Music_Test : test listen_music_D = 0;

study_music_D_Test : test study_music_D = 0;
studyL_yes_D_Test : test studyL_yes_D = 0;
studyL_some_D_Test : test studyL_some_D = 0;

prefStudy5_11_Test : test prefStudy5_11 = 0;
prefStudy12_5_Test : test prefStudy12_5 = 0;
prefStudy6_12_Test : test prefStudy6_12 = 0;

studyEfficacy3_Test : test studyEfficacy3 = 0;
studyEfficacy4_Test : test studyEfficacy4 = 0;
studyEfficacy5_Test : test studyEfficacy5 = 0;

/*test significance of genre dummy variables*/
genrePop_Test : test genrePop = 0;
genreHipHop_Test : test genreHipHop = 0;
genreJazz_Test : test genreJazz = 0;
genreClassic_Test : test genreClassic = 0;
genreHouse_Test : test genreHouse = 0;
genreAlt_Test : test genreAlt = 0;
genreContemp_Test : test genreContemp = 0;
genreRock_Test : test genreRock = 0;
genreCountry_Test : test genreCountry = 0;
genreKpop_Test : test genreKpop = 0;
genreFolk_Test : test genreFolk = 0;
genreAfro_Test : test genreAfro = 0;
genreMetal_Test : test genreMetal = 0;
genreRnB_Test : test genreRnB = 0;

RUN;
QUIT;



/*** 1ST MODEL (Total study time): NO INTERACTIONS - dropped least significant predictors ***/

PROC REG data = work.dataset;
title "Reduced Model - No Interactions - most predictive";

model Total_study_time =
      /*Continuous Variables*/
      Age             

      /*Dummy variables + Categorical variables*/        
      study_music_D   studyL_yes_D    
      studyEfficacy4  studyEfficacy5

      genreHipHop     genreJazz
      genreHouse      genreAlt
      genreContemp    genreRock       
      genreFolk       genreAfro
      genreMetal      
	;/*end of model*/
                                      

/*test significance of continuous variables*/
Age_Test : test Age = 0;

/*test significance of categorical variables*/

study_music_D_Test : test study_music_D = 0;
studyL_yes_D_Test : test studyL_yes_D = 0;

studyEfficacy4_Test : test studyEfficacy4 = 0;
studyEfficacy5_Test : test studyEfficacy5 = 0;

/*test significance of genre dummy variables*/
genreHipHop_Test : test genreHipHop = 0;
genreJazz_Test : test genreJazz = 0;
genreHouse_Test : test genreHouse = 0;
genreAlt_Test : test genreAlt = 0;
genreContemp_Test : test genreContemp = 0;
genreRock_Test : test genreRock = 0;
genreFolk_Test : test genreFolk = 0;
genreAfro_Test : test genreAfro = 0;
genreMetal_Test : test genreMetal = 0;

RUN;
QUIT;







/*** 2ND MODEL (Infomation retained): NO INTERACTIONS ***/
PROC REG data = work.dataset;
title "Full Model 2 - No Interactions";

model Information_retianed =
      /*Continuous Variables*/
      Age Total_study_time

      /*Dummy variables + Categorical variables*/
      Major_D         listen_music_D 
      study_music_D   studyL_yes_D    studyL_some_D
      prefStudy5_11   prefStudy12_5   prefStudy6_12
      studyEfficacy3  studyEfficacy4  studyEfficacy5

      genrePop        genreHipHop     genreJazz
      genreClassic    genreHouse      genreAlt
      genreContemp    genreRock       genreCountry
      genreKpop       genreFolk       genreAfro
      genreMetal      genreRnB
	;
                                      

/*test significance of continuous variables*/
Age_Test : test Age = 0;
totatTimeRetained_Test : test Total_study_time = 0;

/*test significance of categorical variables*/
Major_Test : test Major_D = 0;
Listen_Music_Test : test listen_music_D = 0;

study_music_D_Test : test study_music_D = 0;
studyL_yes_D_Test : test studyL_yes_D = 0;
studyL_some_D_Test : test studyL_some_D = 0;

prefStudy5_11_Test : test prefStudy5_11 = 0;
prefStudy12_5_Test : test prefStudy12_5 = 0;
prefStudy6_12_Test : test prefStudy6_12 = 0;

studyEfficacy3_Test : test studyEfficacy3 = 0;
studyEfficacy4_Test : test studyEfficacy4 = 0;
studyEfficacy5_Test : test studyEfficacy5 = 0;

/*test significance of genre dummy variables*/
genrePop_Test : test genrePop = 0;
genreHipHop_Test : test genreHipHop = 0;
genreJazz_Test : test genreJazz = 0;
genreClassic_Test : test genreClassic = 0;
genreHouse_Test : test genreHouse = 0;
genreAlt_Test : test genreAlt = 0;
genreContemp_Test : test genreContemp = 0;
genreRock_Test : test genreRock = 0;
genreCountry_Test : test genreCountry = 0;
genreKpop_Test : test genreKpop = 0;
genreFolk_Test : test genreFolk = 0;
genreAfro_Test : test genreAfro = 0;
genreMetal_Test : test genreMetal = 0;
genreRnB_Test : test genreRnB = 0;

RUN;
QUIT;



/*** 2ND MODEL (Infomation retained): NO INTERACTIONS ***/
PROC REG data = work.dataset plots=none;
title "Reduced Model 2 - No Interactions";

model Information_retained = studyL_some_D genreJazz genreHouse genreAfro;

studyL_some_D_Test : test studyL_some_D = 0;
genreJazz_Test : test genreJazz = 0;
genreHouse_Test : test genreHouse = 0;
genreAfro_Test : test genreAfro = 0;

RUN;
QUIT;


/*create new dataset with all two way interactions*/
DATA temp.interactionData;
	set work.dataset;

	studyL_some_D_genreJazz = studyL_some_D * genreJazz;
    studyL_some_D_genreHouse = studyL_some_D * genreHouse;
    studyL_some_D_genreAfro = studyL_some_D * genreAfro;
    genreJazz_genreHouse = genreJazz * genreHouse;
    genreJazz_genreAfro = genreJazz * genreAfro;
    genreHouse_genreAfro = genreHouse * genreAfro;
RUN;
QUIT;


/*** 2ND MODEL (Infomation retained): INTERACTIONS ***/
PROC REG data=temp.interactionData;
	title "Full Model 2 With Interactions";
	model Information_retained = 
		studyL_some_D 
		genreJazz 
		genreHouse 
		genreAfro
		studyL_some_D_genreJazz 
	    studyL_some_D_genreHouse
	    studyL_some_D_genreAfro
	    genreJazz_genreHouse 
	    genreJazz_genreAfro
	    genreHouse_genreAfro
	;

	
	studyL_some_D_Test: test studyL_some_D = 0;
	genreJazz_Test: test genreJazz = 0;
	genreHouse_Test: test genreHouse = 0;
	genreAfro_Test: test genreAfro = 0;
	studyL_some_D_genreJazz_Test: test studyL_some_D_GenreJazz = 0;
	studyL_some_D_genreHouse_Test: test studyL_some_D_GenreHouse = 0;
	studyL_some_D_genreAfro_Test: test studyL_some_D_GenreAfro = 0;
	genreJazz_genreHouse_Test: test genreJazz_genreHouse = 0;
	genreJazz_genreAfro_Test: test genreJazz_genreAfro = 0;
	genreHouse_genreAfro_Test: test genreHouse_genreAfro = 0;



RUN;
QUIT;


/*** 2ND MODEL (Infomation retained): INTERACTIONS - dropped least significant predictors and interactions ***/
/*none of the interactions ended up being significant*/
PROC REG data=temp.interactionData;
	title "Full Model 2 With Interactions";
	model Information_retained = 
		studyL_some_D 
		genreJazz 
		genreHouse 
		genreAfro
	;

	
	studyL_some_D_Test: test studyL_some_D = 0;
	genreJazz_Test: test genreJazz = 0;
	genreHouse_Test: test genreHouse = 0;
	genreAfro_Test: test genreAfro = 0;

RUN;
QUIT;





/*For visualizations ONLY. DO NOT USE FOR REGRESSION*/
/*restructures the data to separate genre list so each respondent has [number of genres picked] rows
  each row for a specific respondent is identical except for the genre

  EXAMPLE: 
		This resondent: email@email.com ... yes, yes, yes, [pop, rock], 4 ...
        Now has 2 lines in the dataset:
            email@email.com ... yes, yes, yes, pop, 4 ...
			email@email.com ... yes, yes, yes, rock, 4 ...

*/
DATA temp.reshaped_data;
    SET work.dataset;

    /* Copy the original Genre column */
    GenreList = Genre;
    GenreIndex = 1;

    /* Loop until all genres have been processed */
    DO UNTIL (GenreList = "");
        /* Extract the genre (the first genre in the list) */
        Genre = scan(GenreList, GenreIndex, ',');  /* Extract the first genre */

		/* Output the row for the extracted genre */
        OUTPUT;

        /* Remove the genre we've just processed from the list */
        IF index(GenreList, ',') > 0 THEN
            GenreList = substr(GenreList, length(Genre) + 2); /* Remove processed genre and comma */
        ELSE
            GenreList = "";  /* If no comma, all genres are processed */


    END;

    DROP GenreList GenreIndex;  /* Drop intermediate variables */
	
RUN;
