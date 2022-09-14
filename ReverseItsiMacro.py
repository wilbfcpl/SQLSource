OLD_CATEGORY='J FIC'
NEW_PREFIX = 'J CD BOOK MYS'
AUTHOR_START=6

if OLD_CATEGORY in record['092']['a']:
	callNumberAuthor=record['092']['a'][AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor

OLD_CATEGORY='J FIC'
NEW_PREFIX = 'J GRAPHIC MYS'
AUTHOR_START=6

if OLD_CATEGORY in record['092']['a']:
	callNumberAuthor=record['092']['a'][AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor

OLD_CATEGORY='J FIC'
NEW_PREFIX = 'J MYS'
AUTHOR_START=6

if OLD_CATEGORY in record['092']['a']:
	callNumberAuthor=record['092']['a'][AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor


OLD_CATEGORY='J FIC'
NEW_PREFIX = 'J MYS FIC'
AUTHOR_START=6

if OLD_CATEGORY in record['092']['a']:
	callNumberAuthor=record['092']['a'][AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor



OLD_CATEGORY='J FIC'
NEW_PREFIX = 'J PL BOOK MYS'
AUTHOR_START=6

if OLD_CATEGORY in record['092']['a']:
	callNumberAuthor=record['092']['a'][AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor

OLD_CATEGORY='J FIC'
NEW_PREFIX = 'J PL MYS'
AUTHOR_START=6

if OLD_CATEGORY in record['092']['a']:
	callNumberAuthor=record['092']['a'][AUTHOR_START:]
	record['092']['a'] = NEW_PREFIX + ' ' + callNumberAuthor
