create table Special_LOCATION as
SELECT
 LOCNUMBER,LOCCODE,LOCNAME,RENEWALSALLOWED,DOESNOTCIRCULATEFLAG,ALLOWRECALL,
  ALLOWHOLDS,FINEGRACEPERIOD,FINELIMIT,FINERATE,FINEASSESSMENTTYPE,OVERRIDENOFINE,
  REQUESTFINEGRACEPERIOD,REQUESTFINELIMIT,REQUESTFINERATE,REQUESTFINEASSESSMENTTYPE,
  CHARGELOANPERIOD,RENEWLOANPERIOD,RECALLLOANPERIOD,REQUESTCHARGELOANPERIOD,
  REQUESTRENEWLOANPERIOD,REQUESTRECALLLOANPERIOD,CHARGELIMIT,RENEWALLIMIT,PROCESSINGFEE,
  LOSTBOOKCHARGE,SPECIALFEE,MAGNETICMEDIA,NOTICEDAYS_0,SENDNOTICE,NOTICEFEES_0,
  NOTICEFEES_1,NOTICEFEES_2,NOTICEFEES_3,NOTICEFEES_4,NOTICEFEES_5,LOSTNOTICEDAYS_0,
  LOSTNOTICEDAYS_1,LOSTNOTICEDAYS_2,SENDLOSTNOTICE,LOSTNOTICEFEES_0,LOSTNOTICEFEES_1,
  LOSTNOTICEFEES_2,RECALLNOTICEDAYS_0,RECALLNOTICEDAYS_1,RECALLNOTICEDAYS_2,
  RECALLNOTICEDAYS_3,RECALLNOTICEDAYS_4,RECALLNOTICEDAYS_5,SENDRECALLNOTICE,
  RECALLNOTICEFEES_0,RECALLNOTICEFEES_1,RECALLNOTICEFEES_2,RECALLNOTICEFEES_3,
  RECALLNOTICEFEES_4,RECALLNOTICEFEES_5,FINESNOTICEDAYS_0,FINESNOTICEDAYS_1,
  FINESNOTICEDAYS_2,SENDFINENOTICE,FINESNOTICEFEES_0,HOLDNOTICEFEE,FINESNOTICEFEES_1,
  FINESNOTICEFEES_2,NOTICEDAYS_1,NOTICEDAYS_2,NOTICEDAYS_3,NOTICEDAYS_4,NOTICEDAYS_5,
  INTELLECTUAL_LEVEL,CIRCULATION_LEVEL,ALLOWFLOATINGCOLLECTION
 FROM
    CXDAT.LOCATION
/

comment on table LOCATION_V2 is 'Defines the physical branches of the library.'
/

comment on column LOCATION_V2.INSTBIT is 'Numeric institution code'
/

comment on column LOCATION_V2.LOCNUMBER is 'Unique number assigned to the location'
/

comment on column LOCATION_V2.LOCCODE is 'Up-to-6-character code assigned to a location within a branch(es)'
/

comment on column LOCATION_V2.LOCNAME is 'Name of the location'
/

comment on column LOCATION_V2.RENEWALSALLOWED is 'Determines whether items with this location code are eligible for renewal'
/

comment on column LOCATION_V2.DOESNOTCIRCULATEFLAG is 'Indicates whether items from this location may be checked out'
/

comment on column LOCATION_V2.ALLOWRECALL is 'Indicates whether items with this specific parameter value may be recalled'
/

comment on column LOCATION_V2.ALLOWHOLDS is 'Indicates whether items with this specific parameter value may fill holds'
/

comment on column LOCATION_V2.FINEGRACEPERIOD is 'Number of days an item can be returned overdue without generating a fine'
/

comment on column LOCATION_V2.FINELIMIT is 'Maximum fine that is calculated for the return of overdue or lost items with this specific parameter value'
/

comment on column LOCATION_V2.FINERATE is 'Daily rate of fine that is calculated for the return of overdue or lost items with this specific parameter value'
/

comment on column LOCATION_V2.FINEASSESSMENTTYPE is 'Assessment type for fines (D for Daily)'
/

comment on column LOCATION_V2.OVERRIDENOFINE is 'Standard override no fine'
/

comment on column LOCATION_V2.REQUESTFINEGRACEPERIOD is 'Number of days a recalled item can be returned overdue without generating a fine'
/

comment on column LOCATION_V2.REQUESTFINELIMIT is 'Maximum fine that is calculated for the return of overdue or lost and recalled items with this speciric parameter value'
/

comment on column LOCATION_V2.REQUESTFINERATE is 'Daily rate of fine that is calculated for the return of overdue or lost and recalled items with this specific parameter value'
/

comment on column LOCATION_V2.REQUESTFINEASSESSMENTTYPE is 'Assessment type for fines on hold or recalled (D for Daily)'
/

comment on column LOCATION_V2.CHARGELOANPERIOD is 'Number of days used to calculate a due date for items with this specific parameter value'
/

comment on column LOCATION_V2.RENEWLOANPERIOD is 'Number of days used to calculate a renewal due date for items with this specific parameter value'
/

comment on column LOCATION_V2.RECALLLOANPERIOD is 'Number of days used to calculate the shortened due date for recalled items with this specific parameter value'
/

comment on column LOCATION_V2.REQUESTCHARGELOANPERIOD is 'Request charge loan period'
/

comment on column LOCATION_V2.REQUESTRENEWLOANPERIOD is 'Request renew loan period'
/

comment on column LOCATION_V2.REQUESTRECALLLOANPERIOD is 'Request recall loan period'
/

comment on column LOCATION_V2.CHARGELIMIT is 'Number of items with this specific parameter value that a patron may have checked out at any given time'
/

comment on column LOCATION_V2.RENEWALLIMIT is 'Number of times the patron may renew items with this specific parameter value'
/

comment on column LOCATION_V2.PROCESSINGFEE is 'Processing fee associated with lost items from this branch.'
/

comment on column LOCATION_V2.LOSTBOOKCHARGE is 'Lost book charge for items from this branch.  If data is not entered here, the default amount set at the institution level is used.'
/

comment on column LOCATION_V2.SPECIALFEE is 'Special fee assessed for an item checked out from this location'
/

comment on column LOCATION_V2.MAGNETICMEDIA is 'Indicates that items with this specific parameter value should not be de-sensitized by the self-check machine'
/

comment on column LOCATION_V2.NOTICEDAYS_0 is 'Produce 1st Overdue Notice at X days'
/

comment on column LOCATION_V2.SENDNOTICE is 'Determines whether an Overdue notice is sent and the notice format'
/

comment on column LOCATION_V2.NOTICEFEES_0 is '1st Overdue Notice Fee'
/

comment on column LOCATION_V2.NOTICEFEES_1 is '2nd Overdue Notice Fee'
/

comment on column LOCATION_V2.NOTICEFEES_2 is '3rd Overdue Notice Fee'
/

comment on column LOCATION_V2.NOTICEFEES_3 is '4th Overdue Notice Fee'
/

comment on column LOCATION_V2.NOTICEFEES_4 is '5th Overdue Notice Fee'
/

comment on column LOCATION_V2.NOTICEFEES_5 is '6th Overdue Notice Fee'
/

comment on column LOCATION_V2.LOSTNOTICEDAYS_0 is 'Go Lost and Produce 1st Lost Notice at X days'
/

comment on column LOCATION_V2.LOSTNOTICEDAYS_1 is 'Produce 2nd Lost Notice at X days'
/

comment on column LOCATION_V2.LOSTNOTICEDAYS_2 is 'Produce 3rd Lost Notice at X days'
/

comment on column LOCATION_V2.SENDLOSTNOTICE is 'Determines whether a Lost notice is sent and the notice format'
/

comment on column LOCATION_V2.LOSTNOTICEFEES_0 is '1st Lost Notice Fee'
/

comment on column LOCATION_V2.LOSTNOTICEFEES_1 is '2nd notice'
/

comment on column LOCATION_V2.LOSTNOTICEFEES_2 is '3rd notice'
/

comment on column LOCATION_V2.RECALLNOTICEDAYS_0 is 'Produce 1st Recall Notice at X days'
/

comment on column LOCATION_V2.RECALLNOTICEDAYS_1 is 'Produce 2nd Recall Notice at X days'
/

comment on column LOCATION_V2.RECALLNOTICEDAYS_2 is 'Produce 3rd Recall Notice at X days'
/

comment on column LOCATION_V2.RECALLNOTICEDAYS_3 is 'Produce 4th Recall Notice at X days'
/

comment on column LOCATION_V2.RECALLNOTICEDAYS_4 is 'Produce 5th Recall Notice at X days'
/

comment on column LOCATION_V2.RECALLNOTICEDAYS_5 is 'Produce 6th Recall Notice at X days'
/

comment on column LOCATION_V2.SENDRECALLNOTICE is 'Determines whether a Recall notice is sent and the notice format'
/

comment on column LOCATION_V2.RECALLNOTICEFEES_0 is '1st Recall Notice Fee'
/

comment on column LOCATION_V2.RECALLNOTICEFEES_1 is '2nd Recall Notice Fee'
/

comment on column LOCATION_V2.RECALLNOTICEFEES_2 is '3rd Recall Notice Fee'
/

comment on column LOCATION_V2.RECALLNOTICEFEES_3 is '4th Recall Notice Fee'
/

comment on column LOCATION_V2.RECALLNOTICEFEES_4 is '5th Recall Notice Fee'
/

comment on column LOCATION_V2.RECALLNOTICEFEES_5 is '6th Recall Notice Fee'
/

comment on column LOCATION_V2.FINESNOTICEDAYS_0 is 'Produce 1st Fine Notice at X days'
/

comment on column LOCATION_V2.FINESNOTICEDAYS_1 is 'Produce 2nd Fine Notice at X days'
/

comment on column LOCATION_V2.FINESNOTICEDAYS_2 is 'Produce 3rd Fine Notice at X days'
/

comment on column LOCATION_V2.SENDFINENOTICE is 'Determines whether a Fine notice is sent and the notice format'
/

comment on column LOCATION_V2.FINESNOTICEFEES_0 is '1st Fine Notice Fee'
/

comment on column LOCATION_V2.HOLDNOTICEFEE is 'Fee for the production of a Hold Available notice'
/

comment on column LOCATION_V2.FINESNOTICEFEES_1 is '2nd Fine Notice Fee'
/

comment on column LOCATION_V2.FINESNOTICEFEES_2 is '3rd Fine Notice Fee'
/

comment on column LOCATION_V2.NOTICEDAYS_1 is 'Produce 2nd Overdue Notice at X days'
/

comment on column LOCATION_V2.NOTICEDAYS_2 is 'Produce 3rd Overdue Notice at X days'
/

comment on column LOCATION_V2.NOTICEDAYS_3 is 'Produce 4th Overdue Notice at X days'
/

comment on column LOCATION_V2.NOTICEDAYS_4 is 'Produce 5th Overdue Notice at X days'
/

comment on column LOCATION_V2.NOTICEDAYS_5 is 'Produce 6th Overdue Notice at X days'
/

comment on column LOCATION_V2.INTELLECTUAL_LEVEL is 'Intellectual level identification number (references INTELLECTUAL_LEVEL table)'
/

comment on column LOCATION_V2.CIRCULATION_LEVEL is 'Circulation level identification number (references CIRCULATION_LEVEL table)'
/

comment on column LOCATION_V2.ALLOWFLOATINGCOLLECTION is 'Allow items of this location to participate in floating collection'
/

INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('ACQUIS', 'Acquisitions', 'Y', 'N', 'I');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('AREF', 'Adult Reference', 'O', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('BNDRY', 'Bindery', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('FRY', 'Fry Collection', 'Y', 'Y', 'I');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('GOVDOC', 'Government Document', 'O', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('GSA', 'Grant Seekers Audiobook', 'Y', 'Y', 'I');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('GSMAG', 'Grant Seekers Magazine', 'Y', 'Y', 'I');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('GSNF', 'Grant Seekers Nonfiction', 'Y', 'Y', 'I');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('GSREF', 'Grant Seekers Reference', 'O', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('HISCTR', 'History Center', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('ILL', 'Interlibrary Loan', 'Y', 'Y', 'I');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('LCOL', 'Library Collections', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRM', 'Maryland Room', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMAN', 'Maryland Room Annex', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMC1', 'Maryland Room Closed Stacks 1', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMC2', 'Maryland Room Closed Stacks 2', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMC3', 'Maryland Room Closed Stacks 3', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMC4', 'Maryland Room Closed Stacks 4', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMC5', 'Maryland Room Closed Stacks 5', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMM2', 'Maryland Room Mapcase 2', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMM3', 'Maryland Room Mapcase 3', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMM4', 'Maryland Room Mapcase 4', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMMC', 'Maryland Room Mapcase', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDRMMI', 'Maryland Room Missing', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('MDSPLY', 'Maryland Room Display', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('ONLINE', 'Online', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('REFDSK', 'Reference Desk', 'O', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('RVW', 'Review', 'N', 'N', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('STPROF', 'Staff Professional', 'Y', 'Y', 'I');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('TAMIL', 'Tamil Collection', 'Y', 'Y', 'N');
INSERT INTO CARLREPORTS.LOCATION_V2 (LOCCODE, LOCNAME, DOESNOTCIRCULATEFLAG, RENEWALSALLOWED, ALLOWHOLDS) VALUES ('YSPROF', 'Youth Services Professional', 'Y', 'Y', 'N');
