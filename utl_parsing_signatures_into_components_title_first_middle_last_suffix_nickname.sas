
SAS/Python: Parsing Signatures into components title, first, middle, last, suffix, and nickname;

https://goo.gl/b3J9ti
https://communities.sas.com/t5/General-SAS-Programming/extracting-first-and-last-name/m-p/415568

/* T1003370 SAS/Python: Parsing Signatures into components

SAS/Python: Parsing Signatures into components


HAVE  Signatures that I want to parse
====================================

Up to 40 obs WORK.SIGS total obs=21

Obs    SIGNATURE

  1    HATEM (LOVEM) A NOUR EL DEEN III MD
  2    MRS CRISTINA ISABEL DE LA PENA DDS
  3    JUAN (JOE) JOSE LEON DE LOS RIOS MD
  4    LILIANA M DE LA HOZ AYARZA MD
  5    MR RONDA L XARSON MD (DOC RON)
  6    MS ALBERT R BXOWN DDS
  7    MR BETTY B HXN DO
  8    MRS SIOBHAN AC AXWOTT DDS
  9    DR JASON R GERDON PHD
 10    DR TERI A DAVINE DO
 11    DR WALTER R WIEXZTORT DO
 12    MRS GREGORY S MCDENALD DDS
 13    MS JOHN C SACK DDS
 14    DR SUSAN NIEVES CZXNKA DDS
 15    DR NOEL I TBRMULO DDS
 16    DR MARK W JUEXGENS DDS
 17    PETER A MCGUIRE
 18    ZACHARY D ROTH
 19    PETER A MCGUIRE
 20    MARILYN G MASCHGAN
 21    DAVID J VILLANUEVA

WANT
====

You can add to the TITLE and SUFFIX dictionaries

Up to 40 obs WORK.TST total obs=21

Obs    TITLE    FIRST       MIDDLE       LAST                SUFFIX     NICKNAME

  1             HATEM       A NOUR EL    DEEN                III, MD    LOVEM
  2     MRS     CRISTINA    ISABEL       DE LA PENA          DDS
  3             JUAN        JOSE LEON    DE LOS RIOS         MD         JOE
  4             LILIANA     M            DE LA HOZ AYARZA    MD
  5     MR      RONDA       L            XARSON              MD         DOC RON
  6     MS      ALBERT      R            BXOWN               DDS
  7     MR      BETTY       B            HXN                 DO
  8     MRS     SIOBHAN     AC           AXWOTT              DDS
  9     DR      JASON       R            GERDON              PHD
 10     DR      TERI        A            DAVINE              DO
 11     DR      WALTER      R            WIEXZTORT           DO
 12     MRS     GREGORY     S            MCDENALD            DDS
 13     MS      JOHN        C            SACK                DDS
 14     DR      SUSAN       NIEVES       CZXNKA              DDS
 15     DR      NOEL        I            TBRMULO             DDS
 16     DR      MARK        W            JUEXGENS            DDS
 17             PETER       A            MCGUIRE
 18             ZACHARY     D            ROTH
 19             PETER       A            MCGUIRE
 20             MARILYN     G            MASCHGAN
 21             DAVID       J            VILLANUEVA


WORKING CODE
=============

   Python
      fo.write(str(HumanName(signature).as_dict()) + "\n");


*                _                  _       _
 _ __ ___   __ _| | _____        __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \_____ / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/_____| (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|      \__,_|\__,_|\__\__,_|

;

data sigs;
  length signature $55;
  input;
  signature=_infile_;
  file "d:/txt/nams.txt";
  put signature;
  putlog signature;
cards4;
HATEM (LOVEM) A NOUR EL DEEN III MD
MRS CRISTINA ISABEL DE LA PENA DDS
JUAN (JOE) JOSE LEON DE LOS RIOS MD
LILIANA M DE LA HOZ AYARZA MD
MR RONDA L XARSON MD (DOC RON)
MS ALBERT R BXOWN DDS
MR BETTY B HXN DO
MRS SIOBHAN AC AXWOTT DDS
DR JASON R GERDON PHD
DR TERI A DAVINE DO
DR WALTER R WIEXZTORT DO
MRS GREGORY S MCDENALD DDS
MS JOHN C SACK DDS
DR SUSAN NIEVES CZXNKA DDS
DR NOEL I TBRMULO DDS
DR MARK W JUEXGENS DDS
PETER A MCGUIRE
ZACHARY D ROTH
PETER A MCGUIRE
MARILYN G MASCHGAN
DAVID J VILLANUEVA
;;;;
run;quit;

*            _   _
 _ __  _   _| |_| |__   ___  _ __
| '_ \| | | | __| '_ \ / _ \| '_ \
| |_) | |_| | |_| | | | (_) | | | |
| .__/ \__, |\__|_| |_|\___/|_| |_|
|_|    |___/
;

%utlchkfyl(d:/txt/namfix.txt); * delete if exists;

%utl_submit_py64('
from nameparser import HumanName;
fo = open("d:/txt/namfix.txt", "w");
for line in open("d:/txt/nams.txt"):;
.   fo.write(str(HumanName(line).as_dict()) + "\n");
');


data WANT;
  length title first middle last suffix nickname $32;
  infile "d:/txt/namfix.txt";
  array keys[6] $18 ("u'last': u'","u'suffix': u'","u'title': u'","u'middle': u'","u'nickname': u'","u'first': u'");
  array nams[6] $32 last suffix title middle nickname first;
  input;
  do i=1 to 6;
    pos=find(_infile_,strip(keys[i]));
    nams[i] = scan(substr(_infile_,pos),4,"'");
    if nams[i]=:', u' then nams[i]='';
  end;
  output;
  keep last suffix title middle nickname first;
run;quit;


NOTE: The infile "d:/txt/namfix.txt" is:
      Filename=d:\txt\namfix.txt,
      RECFM=V,LRECL=384,File Size (bytes)=2420,
      Last Modified=30Mar2017:19:45:57,
      Create Time=30Mar2017:19:45:57

NOTE: 21 records were read from the infile "d:/txt/namfix.txt".
      The minimum record length was 106.
      The maximum record length was 124.
NOTE: The data set WORK.WANT has 21 observations and 6 variables.


Up to 40 obs from WANT total obs=21

Obs    TITLE    FIRST       MIDDLE       LAST                SUFFIX     NICKNAME

  1             HATEM       A NOUR EL    DEEN                III, MD    LOVEM
  2     MRS     CRISTINA    ISABEL       DE LA PENA          DDS
  3             JUAN        JOSE LEON    DE LOS RIOS         MD         JOE
  4             LILIANA     M            DE LA HOZ AYARZA    MD
  5     MR      RONDA       L            XARSON              MD         DOC RON
  6     MS      ALBERT      R            BXOWN               DDS
  7     MR      BETTY       B            HXN                 DO
  8     MRS     SIOBHAN     AC           AXWOTT              DDS
  9     DR      JASON       R            GERDON              PHD
 10     DR      TERI        A            DAVINE              DO
 11     DR      WALTER      R            WIEXZTORT           DO
 12     MRS     GREGORY     S            MCDENALD            DDS
 13     MS      JOHN        C            SACK                DDS
 14     DR      SUSAN       NIEVES       CZXNKA              DDS
 15     DR      NOEL        I            TBRMULO             DDS
 16     DR      MARK        W            JUEXGENS            DDS
 17             PETER       A            MCGUIRE
 18             ZACHARY     D            ROTH
 19             PETER       A            MCGUIRE
 20             MARILYN     G            MASCHGAN
 21             DAVID       J            VILLANUEVA


