/* Transform string variables to dummy variables for ethnicity and gender */

encode ethnicity, generate(ethcode)  

generate bosnjak = ethcode if ethcode==1 

generate croat = ethcode if ethcode==2  

generate serb = ethcode if ethcode==3 

replace bosnjak = 0 if bosnjak==.

replace croat = 1 if croat==2

replace croat = 0 if croat==.

replace serb = 1 if serb==3

replace serb = 0 if serb==. 

encode d4ethnicity1, generate(d4ethcode1)	

generate d4bosnjak1 = d4ethcode1 if d4ethcode1==1

generate d4croat1 = d4ethcode1 if d4ethcode1==2

generate d4serb1 = d4ethcode1 if d4ethcode1==3

replace d4bosnjak1 = 0 if d4bosnjak1==.

replace d4croat1 = 1 if d4croat1==2

replace d4croat1 = 0 if d4croat1==.

replace d4serb1 = 1 if d4serb1==3

replace d4serb1 = 0 if d4serb1==.

encode d4ethnicity2, generate(d4ethcode2)	

generate d4bosnjak2 = d4ethcode2 if d4ethcode2==1

generate d4croat2 = d4ethcode2 if d4ethcode2==2

generate d4serb2 = d4ethcode2 if d4ethcode2==3

replace d4bosnjak2 = 0 if d4bosnjak2==.

replace d4croat2 = 1 if d4croat2==2

replace d4croat2 = 0 if d4croat2==.

replace d4serb2 = 1 if d4serb2==3

replace d4serb2 = 0 if d4serb2==.

replace q1 = 0 if q1==1

replace q1 = 1 if q1==2

rename q1 female

encode d4gender1, generate (d4gencode1)

encode d4gender2, generate (d4gencode2)

replace d4gencode1 = 0 if d4gencode1==2

replace d4gencode2 = 0 if d4gencode2==2

label define MaleFemale 0 Male 1 Female

label values female MaleFemale

label values d4gencode1 MaleFemale

label values d4gencode2 MaleFemale

/* Variables needed for Table 2, Table 3 */

generate sameethnicity = 1 if ethcode==d4ethcode1 | ethcode==d4ethcode2

replace sameethnicity = 0 if sameethnicity==.

generate serbpartner = 1 if d4serb1==1 | d4serb2==1

replace serbpartner = 0 if serbpartner==.

generate croatpartner = 1 if d4croat1==1 | d4croat2==1

replace croatpartner = 0 if croatpartner==.

generate bosnjakpartner = 1 if d4bosnjak1==1 | d4bosnjak2==1

replace bosnjakpartner = 0 if bosnjakpartner==.


gen d4bosnjaksentbosnjak = d4amountsent1 if d4bosnjak1==1 & bosnjak==1

replace d4bosnjaksentbosnjak = d4amountsent2 if d4bosnjak2==1 & bosnjak==1

gen d4bosnjaksentcroat = d4amountsent1 if d4croat1==1 & bosnjak==1

replace d4bosnjaksentcroat = d4amountsent2 if d4croat2==1 & bosnjak==1

gen d4bosnjaksentserb = d4amountsent1 if d4serb1==1 & bosnjak==1

replace d4bosnjaksentserb = d4amountsent2 if d4serb2==1 & bosnjak==1

gen d4croatsentcroat = d4amountsent1 if d4croat1==1 & croat==1

replace d4croatsentcroat = d4amountsent2 if d4croat2==1 & croat==1

gen d4croatsentbosnjak = d4amountsent1 if d4bosnjak1==1 & croat==1

replace d4croatsentbosnjak = d4amountsent2 if d4bosnjak2==1 & croat==1

gen d4croatsentserb = d4amountsent1 if d4serb1==1 & croat==1

replace d4croatsentserb = d4amountsent2 if d4serb2==1 & croat==1

gen d4serbsentserb = d4amountsent1 if d4serb1==1 & serb==1

replace d4serbsentserb = d4amountsent2 if d4serb2==1 & serb==1

gen d4serbsentcroat = d4amountsent1 if d4croat1==1 & serb==1

replace d4serbsentcroat = d4amountsent2 if d4croat2==1 & serb==1

gen d4serbsentbosnjak = d4amountsent1 if d4bosnjak1==1 & serb==1

replace d4serbsentbosnjak = d4amountsent2 if d4bosnjak2==1 & serb==1

/* Variables needed Appendix table gender and ethnicity */

gen d4malesentingroupfemale = d4amountsent1 if female==0 & sameethnicity==1 & d4ethcode1==ethcode & d4gencode1==1

replace d4malesentingroupfemale = d4amountsent2 if female==0 & sameethnicity==1 & d4ethcode2==ethcode & d4gencode2==1

gen d4malesentingroupmale = d4amountsent1 if female==0 & sameethnicity==1 & d4ethcode1==ethcode & d4gencode1==0

replace d4malesentingroupmale = d4amountsent2 if female==0 & sameethnicity==1 & d4ethcode2==ethcode & d4gencode2==0


gen d4femalesentingroupfemale = d4amountsent1 if female==1 & sameethnicity==1 & d4ethcode1==ethcode & d4gencode1==1

replace d4femalesentingroupfemale = d4amountsent2 if female==1 & sameethnicity==1 & d4ethcode2==ethcode & d4gencode2==1

gen d4femalesentingroupmale = d4amountsent1 if female==1 & sameethnicity==1 & d4ethcode1==ethcode & d4gencode1==0

replace d4femalesentingroupmale = d4amountsent2 if female==1 & sameethnicity==1 & d4ethcode2==ethcode & d4gencode2==0


gen d4malesentoutgroupfemale = d4amountsent1 if female==0 & sameethnicity==0 & d4gencode1==1 & d4gencode2==0

replace d4malesentoutgroupfemale = d4amountsent2 if female==0 & sameethnicity==0 & d4gencode2==1 & d4gencode1==0

gen d4malesentoutgroupmale = d4amountsent1 if female==0 & sameethnicity==0 & d4gencode1==0 & d4gencode2==1

replace d4malesentoutgroupmale = d4amountsent2 if female==0 & sameethnicity==0 & d4gencode2==0 & d4gencode1==1


gen d4femalesentoutgroupfemale = d4amountsent1 if female==1 & sameethnicity==0 & d4gencode1==1 & d4gencode2==0

replace d4femalesentoutgroupfemale = d4amountsent2 if female==1 & sameethnicity==0 & d4gencode2==1 & d4gencode1==0

gen d4femalesentoutgroupmale = d4amountsent1 if female==1 & sameethnicity==0 & d4gencode1==0 & d4gencode2==1

replace d4femalesentoutgroupmale = d4amountsent2 if female==1 & sameethnicity==0 & d4gencode2==0 & d4gencode1==1

/* Variables needed for Table 1 in-group recipients */

generate inoveroutbias = 1 if d4amountsent1>5 & (ethcode==d4ethcode1 & ethcode~=d4ethcode2)

replace inoveroutbias = 1 if d4amountsent2>5 & (ethcode==d4ethcode2 & ethcode~=d4ethcode1)

replace inoveroutbias = 0 if d4amountsent1<=5 & (ethcode==d4ethcode1 & ethcode~=d4ethcode2)

replace inoveroutbias = 0 if d4amountsent2<=5 & (ethcode==d4ethcode2 & ethcode~=d4ethcode1)

generate outoverinbias = 1 if d4amountsent1>5 & (ethcode~=d4ethcode1 & ethcode==d4ethcode2)

replace outoverinbias = 1 if d4amountsent2>5 & (ethcode~=d4ethcode2 & ethcode==d4ethcode1)

replace outoverinbias = 0 if d4amountsent1>=5 & (ethcode==d4ethcode1 & ethcode~=d4ethcode2)

replace outoverinbias = 0 if d4amountsent2>=5 & (ethcode==d4ethcode2 & ethcode~=d4ethcode1)


generate d4inoveroutbias = d4amountsent1 if d4amountsent1>5 & inoveroutbias==1

replace d4inoveroutbias = d4amountsent2 if d4amountsent2>5 & inoveroutbias==1

generate d4outoverinbias = d4amountsent1 if d4amountsent1<5 & outoverinbias==1

replace d4outoverinbias = d4amountsent2 if d4amountsent2<5 & outoverinbias==1

/* Variables needed for Table 1 out-group only recipients */

generate outoveroutbias = 1 if d4amountsent1~=5 & (ethcode~=d4ethcode1 & ethcode~=d4ethcode2)

replace outoveroutbias = 1 if d4amountsent2~=5 & (ethcode~=d4ethcode2 & ethcode~=d4ethcode1)

replace outoveroutbias = 0 if d4amountsent1==5 & (ethcode~=d4ethcode1 & ethcode~=d4ethcode2)

replace outoveroutbias = 0 if d4amountsent2==5 & (ethcode~=d4ethcode2 & ethcode~=d4ethcode1)


generate d4outoveroutbias = d4amountsent1 if d4amountsent1>5 & outoveroutbias==1

replace d4outoveroutbias = d4amountsent2 if d4amountsent2>5 & outoveroutbias==1

/* Variables for Table 4 and 5 and appendix Table 5 recodes */

alpha q44a q44b if bosnjak==1, gen(bosnjakoutgroupthreat)

alpha q44a q44c if croat==1, gen(croatoutgroupthreat)

alpha q44b q44c if serb==1, gen(serboutgroupthreat)

generate outgroupthreat = bosnjakoutgroupthreat if bosnjak==1

replace outgroupthreat = croatoutgroupthreat if croat==1

replace outgroupthreat = serboutgroupthreat if serb==1

gen inoveroutbias2 = inoveroutbias

replace inoveroutbias2 = 1 if outoverinbias==1

logit inoveroutbias2 ethnicties outgroupthreat bosnjak croat female age education

logit inoveroutbias ethnicties outgroupthreat bosnjak croat female age education

logit outoveroutbias outgroupthreat bosnjak croat female age education


generate magnitudeinbias = 0 if inoveroutbias==0

replace magnitudeinbias = 0 if outoverinbias==1

replace magnitudeinbias = 2 if d4inoveroutbias==6

replace magnitudeinbias = 4 if d4inoveroutbias==7

replace magnitudeinbias = 6 if d4inoveroutbias==8

replace magnitudeinbias = 8 if d4inoveroutbias==9

replace magnitudeinbias = 10 if d4inoveroutbias==10


generate magnitudeoutbias = 0 if outoveroutbias==0

replace magnitudeoutbias = 2 if d4outoveroutbias==6

replace magnitudeoutbias = 4 if d4outoveroutbias==7

replace magnitudeoutbias = 6 if d4outoveroutbias==8

replace magnitudeoutbias = 8 if d4outoveroutbias==9

replace magnitudeoutbias = 10 if d4outoveroutbias==10

ologit magnitudeinbias ethnicties outgroupthreat bosnjak croat female age education

ologit magnitudeoutbias outgroupthreat bosnjak croat female age education


gen magnitudeinbias2 = magnitudeinbias

replace magnitudeinbias2 = -10 if d4outoverinbias==0

replace magnitudeinbias2 = -8 if d4outoverinbias==1

replace magnitudeinbias2 = -6 if d4outoverinbias==2

replace magnitudeinbias2 = -4 if d4outoverinbias==3

replace magnitudeinbias2 = -2 if d4outoverinbias==4

tab magnitudeinbias2

ologit magnitudeinbias2 ethnicties outgroupthreat bosnjak croat female age education

gen magnitudeinbias3 = magnitudeinbias

replace magnitudeinbias3 = 10 if d4outoverinbias==0

replace magnitudeinbias3 = 8 if d4outoverinbias==1

replace magnitudeinbias3 = 6 if d4outoverinbias==2

replace magnitudeinbias3 = 4 if d4outoverinbias==3

replace magnitudeinbias3 = 2 if d4outoverinbias==4

sum magnitudeinbias3

ologit magnitudeinbias3 ethnicties outgroupthreat bosnjak croat female age education

/*Table 6 variables */

generate egalitarian = 1 if d4amountsent1==5

replace egalitarian = 0 if egalitarian==.

generate outgroupfairness = 1 if q40==2

replace outgroupfairness = 0 if q40==1

gen serbfairness = 1 if q41i==4

replace serbfairness = 2 if q41i==3

replace serbfairness = 3 if q41i==2

replace serbfairness = 4 if q41i==1

gen croatfairness = 1 if q41j==4

replace croatfairness = 2 if q41j==3

replace croatfairness = 3 if q41j==2

replace croatfairness = 4 if q41j==1

gen bosnjakfairness = 1 if q41k==4

replace bosnjakfairness = 2 if q41k==3

replace bosnjakfairness = 3 if q41k==2

replace bosnjakfairness = 4 if q41k==1

logit outgroupfairness egalitarian bosnjak croat female age education

ologit serbfairness egalitarian bosnjak female age education if serb==0

ologit croatfairness egalitarian bosnjak female age education if croat==0

ologit bosnjakfairness egalitarian croat female age education if bosnjak==0

/* Variables for appendix attachment 4 table */

ologit commonties egalitarian bosnjak croat female age education if commonties~=4

ologit commonties inoveroutbias bosnjak croat female age education if commonties~=4

ologit commonties magnitudeinbias bosnjak croat female age education if commonties~=4

log close

