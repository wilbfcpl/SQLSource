select history.PATRONID, patron.name, patron.EMAIL,patron.PH1, phonetype.DESCRIPTION,phonetype.address, typestatus.DESCRIPTION noticetype, history.item, delivery.DESCRIPTION "delivery method",
       history.CREATIONDATE, history.PROCESSEDDATE,
       codestatus.DESCRIPTION status from PATRON_V2 patron
           inner join PHONETYPE_V2 phonetype on patron.PHONETYPEID1=phonetype.PHONETYPEID
           inner join NOTICEHISTORY_V2 history on history.PATRONID = patron.PATRONID
           inner join SYSTEMNOTICECODES_V2 codestatus on history.status=codestatus.CODE
           inner join SYSTEMNOTICECODES_V2 typestatus on history.NOTICETYPE = typestatus.code
           inner join SYSTEMNOTICECODES_V2 delivery on history.DELIVERYMETHOD = delivery.CODE
                                     where PATRON.patronid='11982021684457';
