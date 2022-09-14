OLD_CATEGORY='J CD BOOK MYS'
NEW_PREFIX = 'J FIC'
AUTHOR_START=13

if OLD_CATEGORY in record['092']['a']:
        savedCallNumber=record['092']['a']
	record.addField('590','$a')
	record['590']['a']=savedCallNumber
	callNumberAuthor=savedCallNumber[AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor


OLD_CATEGORY='J GRAPHIC MYS'
NEW_PREFIX = 'J FIC'
AUTHOR_START=13

if OLD_CATEGORY in record['092']['a']:
        savedCallNumber=record['092']['a']
	record.addField('590','$a')
	record['590']['a']=savedCallNumber
	callNumberAuthor=savedCallNumber[AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor



OLD_CATEGORY='J MYS FIC'
NEW_PREFIX = 'J FIC'
AUTHOR_START=9

if OLD_CATEGORY in record['092']['a']:
        savedCallNumber=record['092']['a']
	record.addField('590','$a')
	record['590']['a']=savedCallNumber
	callNumberAuthor=savedCallNumber[AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor



OLD_CATEGORY='J MYS'
NEW_PREFIX = 'J FIC'
AUTHOR_START=6

if OLD_CATEGORY in record['092']['a']:
	savedCallNumber=record['092']['a']
	record.addField('590','$a')
	record['590']['a']=savedCallNumber
	callNumberAuthor=savedCallNumber[AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor


OLD_CATEGORY='J PL BOOK MYS'
NEW_PREFIX = 'J FIC'
AUTHOR_START=13

if OLD_CATEGORY in record['092']['a']:
        savedCallNumber=record['092']['a']
	record.addField('590','$a')
	record['590']['a']=savedCallNumber
	callNumberAuthor=savedCallNumber[AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor



OLD_CATEGORY='J PL MYS'
NEW_PREFIX = 'J FIC'
AUTHOR_START=8

if OLD_CATEGORY in record['092']['a']:
        savedCallNumber=record['092']['a']
	record.addField('590','$a')
	record['590']['a']=savedCallNumber
	callNumberAuthor=savedCallNumber[AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor

