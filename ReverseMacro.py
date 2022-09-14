OLD_PREFIX='J FIC'
if OLD_PREFIX in record['092']['a']:
        originalCallNumber=record['590']['a']
        record['092']['a']=originalCallNumber
