
 SELECT '"'
    || REPLACE(INST.INSTNAME, '"', '""')
    || '",'
    || BM.BID
    || ',"'
    || REPLACE(I.ITEM, '"', '""')
    || '","'
    || REPLACE(BM.AUTHOR, '"', '""')
    || '","'
    || REPLACE(BM.TITLE, '"', '""')
    || '","'
    || REPLACE(BM.PUBLISHINGDATE, '"', '""')
    || '","'
    || CASE SUBSTR(I.CNLABEL, 4, 1)
         WHEN '9' THEN
            REPLACE(I.SUFFIX, '"', '""')
       END
    || '","'
    || TRIM(CASE SUBSTR(I.CNLABEL, 4, 1)
              WHEN '9' THEN
                I.SUFFIX || ' '
            END ||   -- prefix
            I.CN ||  -- call number
            CASE     -- volume
              WHEN SUBSTR(I.CNLABEL, 1, 1) != ' '
              THEN
                ' ' || (SELECT NAME FROM CAPTION WHERE SUBSTR(CNLABEL, 1, 1) = ABBR) || ' ' ||
                TRIM(I.VOLUME)
            END ||
            CASE     -- part
              WHEN SUBSTR(I.CNLABEL, 2, 1) != ' '
              THEN
                ' ' || (SELECT NAME FROM CAPTION WHERE SUBSTR(CNLABEL, 2, 1) = ABBR) || ' ' ||
                I.PART
            END ||
            CASE     -- number
              WHEN SUBSTR(I.CNLABEL, 3, 1) != ' '
              THEN
                ' ' || (SELECT NAME FROM CAPTION WHERE SUBSTR(CNLABEL, 3, 1) = ABBR) || ' ' ||
                I.NUMBER_
            END ||
            CASE     -- suffix
              WHEN SUBSTR(I.CNLABEL, 4, 1) != ' ' AND SUBSTR(I.CNLABEL, 4, 1) != '9'
              THEN
                ' ' || (SELECT NAME FROM CAPTION WHERE SUBSTR(CNLABEL, 4, 1) = ABBR) || ' ' ||
                I.SUFFIX
            END)
    || '","'
    || CASE WHEN I.STATUS IN ('C', 'CT') AND TI.TRANSCODE IN ('O', 'L') THEN REPLACE(S.CODEDESCRIPTION, '"', '""')
         ELSE REPLACE(SI.DESCRIPTION, '"', '""')
       END
    || '","'
    || REPLACE(I.PRICE, '"', '""')
    || '","'
    || REPLACE(BR.BRANCHNAME, '"', '""')
    || '","'
    || REPLACE(L.LOCNAME, '"', '""')
    || '","'
    || REPLACE(M.MEDNAME, '"', '""')
    || '","'
    || REPLACE(I.CIRCHISTORY, '"', '""')
    || '","'
    || REPLACE(I.CUMULATIVEHISTORY, '"', '""')
    || '",'
    || TO_CHAR(I.STATUSDATE, 'YYYY/MM/DD')
    || ',"'
    || REPLACE(BM.ISBN, '"', '""')
    || '",'
    || TO_CHAR(I.CREATIONDATE, 'YYYY/MM/DD')
    || ','
    || TO_CHAR(I.EDITDATE, 'YYYY/MM/DD')
    || ','
    || '${datetypetext}'
    || ','
    || TO_CHAR(TO_DATE(${gbegdate},'YYYYMMDD'),'YYYY/MM/DD')
    || ','
    || TO_CHAR(TO_DATE(${genddate},'YYYYMMDD'),'YYYY/MM/DD')
  FROM ITEM I
    JOIN INSTITUTION INST ON (I.INSTBIT = INST.INSTBIT)
    JOIN BBIBMAP BM ON (I.BID = BM.BID AND I.INSTBIT = BM.INSTBIT AND BM.FOLDER = 0)
    JOIN SYSTEMITEMCODES SI ON (SI.CODE=I.STATUS AND SI.INSTBIT=I.INSTBIT AND SI.TYPE = I.TYPE)
    JOIN LOCATION L ON (I.INSTBIT = L.INSTBIT AND I.LOCATION = L.LOCNUMBER)
    JOIN MEDIA M ON (I.INSTBIT = M.INSTBIT AND I.MEDIA = M.MEDNUMBER)
    LEFT OUTER JOIN TRANSITEM TI ON (TI.OCCUR = 0 and I.ITEM = TI.ITEM and I.INSTBIT = TI.INSTBIT)
    LEFT OUTER JOIN SYSTEMCODEVALUES S ON (S.CODETYPE = 4 AND S.CODEVALUE = TI.TRANSCODE)
    -- Now join on branch.  If it's on the hold shelf, we want to place it with the pick-up branch in transitem.
    JOIN BRANCH BR ON ( (I.STATUS in ('H', 'HT') AND I.INSTBIT = BR.INSTBIT and TI.BRANCH = BR.BRANCHNUMBER)
                        OR ( I.STATUS NOT IN ('H', 'HT') AND I.INSTBIT = BR.INSTBIT AND I.BRANCH = BR.BRANCHNUMBER) )
WHERE ${ldatetypecondition} ${lstatuscondition} ${lbranchcodecondition} ${lloccodecondition} ${lmedcodecondition} ;