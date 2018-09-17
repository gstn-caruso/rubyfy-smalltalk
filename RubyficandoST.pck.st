'From Cuis 5.0 of 7 November 2016 [latest update: #3430] on 16 September 2018 at 11:27:11 pm'!
'Description Please enter a description for this package'!
!provides: 'RubyficandoST' 1 5!
SystemOrganization addCategory: #RubyficandoST!


!classDefinition: #ParserTest category: #RubyficandoST!
TestCase subclass: #ParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RubyficandoST'!
!classDefinition: 'ParserTest class' category: #RubyficandoST!
ParserTest class
	instanceVariableNames: ''!


!ParserTest methodsFor: 'as yet unclassified' stamp: 'GC 9/12/2018 00:11:29'!
test01QuestionMarkIsConsideredAValidInIdentifiers

	self assert: ($?) isValidInIdentifiers! !

!ParserTest methodsFor: 'as yet unclassified' stamp: 'GC 9/12/2018 00:34:12'!
test02QuestionMarkIsNotInScannerxBinary

	|scanner questionMark|
	scanner := Scanner new.
	questionMark := $? numericValue.

	self assert: #xQuestionMark equals: (scanner typeTableAt: questionMark)! !

!ParserTest methodsFor: 'as yet unclassified' stamp: 'GC 9/12/2018 00:53:31'!
test03QuestionMarkIsIncludedInTheParsedSelectorName

	self assert: #'really?' equals: (Parser new parseSelector: 'really?')! !

!ParserTest methodsFor: 'as yet unclassified' stamp: 'GC 9/16/2018 23:27:03'!
test04QuestionMarkOnlyCanBeAtTheEndOfTheSelector

	self deny: (Parser new parseSelector: 'real?ly') = #'really?'! !

!Character methodsFor: '*RubyficandoST' stamp: 'GC 9/16/2018 02:30:32'!
isBlank
	| asString |
	asString _ self asString.	
		
	^ asString = '' or: [asString = ' ' ]! !

!Character methodsFor: '*RubyficandoST' stamp: 'GC 9/12/2018 00:14:47'!
isValidInIdentifiers
	"Can c be part of an identifier? (unary or keyword selector, or variable name)"

	^self isAlphaNumeric or: [ #( $_ ) statePointsTo: self ] or: [ self == $? ]! !

!Scanner methodsFor: '*RubyficandoST' stamp: 'GC 9/16/2018 23:11:25'!
isValidCharacterAtTheEnd: typeOfCharacter

	^ typeOfCharacter == #xQuestionMark 
		and: [aheadChar isDriveSeparator or: 
			[aheadChar isSeparator or: 
				[ aheadChar isBlank or: 
					[ source atEnd ] ]]]! !

!Scanner methodsFor: '*RubyficandoST' stamp: 'GC 9/16/2018 23:10:20'!
xLetter
	"Form a word or keyword."

	| type |
	buffer reset.
	[(type := self typeTableAt: hereChar) == #xLetter
		or: [type == #xDigit
		or: [type == #xUnderscore or: [self isValidCharacterAtTheEnd: type]]]] whileTrue:
			["open code step for speed"
			buffer nextPut: hereChar.
			hereChar := aheadChar.
			aheadChar := source atEnd
							ifTrue: [self doItCharacter "doit"]
							ifFalse: [source next]].
	tokenType := (type == #colon or: [type == #xColon and: [aheadChar ~~ $=]])
					ifTrue: 
						[buffer nextPut: self step.
						"Allow any number of embedded colons in literal symbols"
						[(self typeTableAt: hereChar) == #xColon] whileTrue:
							[buffer nextPut: self step].
						#keyword]
					ifFalse: 
						[#word].
	token := buffer contents! !

!Scanner methodsFor: '*RubyficandoST' stamp: 'GC 9/12/2018 00:51:51'!
xQuestionMark

	^ (self typeTableAt: hereChar) == $?! !
