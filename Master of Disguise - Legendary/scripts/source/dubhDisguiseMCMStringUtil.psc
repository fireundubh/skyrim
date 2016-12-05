ScriptName dubhDisguiseMCMStringUtil
{string manipulation utility}

import StringUtil
import Debug

String Function StringSubst (String sOriginal, String sFind, String sReplace) global
;replace all occurrances of sFind in sOriginal with sReplace
	int iFoundLocation
	int iFindLen = GetLength(sFind)
	int iReplaceLen = GetLength(sReplace)
	int iFindReplaceLenDiff = iReplaceLen - iFindLen
;Trace("JaxonzStringUtil::ReplaceSubstring, sOriginal: " + sOriginal + ", sFind: " + sFind + ", iFindLen: " + iFindLen + ", sReplace: " + sReplace + ", iReplaceLen: " + iReplaceLen + ", iFindReplaceLenDiff: " + iFindReplaceLenDiff)
	iFoundLocation = Find(sOriginal, sFind, iFoundLocation)
	While iFoundLocation > -1
;Trace("JaxonzStringUtil::ReplaceSubstring, iFoundLocation: " + iFoundLocation + ", sOriginal: " + sOriginal)
		if iFoundLocation == 0	;a little weirdness here because asking Substring to return 0 length actually returns entire to string end
			sOriginal = sReplace + Substring(sOriginal, iFoundLocation + iFindLen)
		Else
			sOriginal = Substring(sOriginal, 0, iFoundLocation) + sReplace + Substring(sOriginal, iFoundLocation + iFindLen)		
		EndIf
		iFoundLocation = Find(sOriginal, sFind, iFoundLocation + iFindReplaceLenDiff)
	EndWhile
	
;Trace("JaxonzStringUtil::Return value: " + sOriginal)
	return sOriginal
EndFunction

String Function IffString(bool bCondition, String sIfTrue, String sIfFalse) global
;return a string value based on conditional statement
;useful for inline concatination
	if bCondition
		return sIfTrue
	Else
		return sIfFalse
	EndIf
EndFunction

string[] Function ParseCSVtoArray (string sCSVlist) global
;parses a comma separated value string to an array of StringSubst
;requires SKSE 1.7.2!
	string sDelimiter = ","
	string[] sReturn
	
	int iElements = 1
	if sCSVlist == ""	;invalid input
		return sReturn
	EndIf
	
	;count number of elements in the string
	int iOffset = 0
	iOffset = Find(sCSVlist, sDelimiter)
	While iOffset != -1
		iElements += 1
		iOffset = Find(sCSVlist, sDelimiter, iOffset + 1)
;Trace("iElements:" + iElements + ", iOffset: " + iOffset)
	EndWhile
	;create the return string array
	sReturn = Utility.CreateStringArray(iElements)
	
	;fill the array with values
	iElements = 0	
	While GetLength(sCSVlist)
		iOffset = Find(sCSVlist, sDelimiter)
		if iOffset == 0	;a little weirdness here because asking Substring to return 0 length actually returns entire to string end
			sReturn[iElements] = ""
		Else
			sReturn[iElements] = Substring(sCSVlist, 0, iOffset)	
		EndIf
		If iOffset == -1
			sCSVlist = ""
		Else
			sCSVlist = Substring(sCSVlist, iOffset + 1)
		EndIf
;Trace("iElements:" + iElements + ", sReturn[iElements]:" + sReturn[iElements] + "    , sCSVlist:" + sCSVlist)
		iElements += 1
	EndWhile
	
	return sReturn
EndFunction

string[] Function ParseStringtoArray (string sStringList, string sDelimiter = ",") global
;parses a comma separated value string to an array of StringSubst
;requires SKSE 1.7.2!
;Trace("JaxonzStringUtil::ParseStringtoArray")
	string[] sReturn
	int iDelimiterLen = GetLength(sDelimiter)	
	int iElements = 1
	if sStringList == ""	;invalid input
		return sReturn
	EndIf
	
	;count number of elements in the string
	int iOffset = 0
	iOffset = Find(sStringList, sDelimiter)
	While iOffset != -1
		iElements += 1
		iOffset = Find(sStringList, sDelimiter, iOffset + iDelimiterLen)
;Trace("iElements:" + iElements + ", iOffset: " + iOffset)
	EndWhile
	;create the return string array
	sReturn = Utility.CreateStringArray(iElements)
	
	;fill the array with values
	iElements = 0	
	While GetLength(sStringList)
		iOffset = Find(sStringList, sDelimiter)
		if iOffset == 0	;a little weirdness here because asking Substring to return 0 length actually returns entire to string end
			sReturn[iElements] = ""
		Else
			sReturn[iElements] = Substring(sStringList, 0, iOffset + iDelimiterLen)	
		EndIf
		If iOffset == -1
			sStringList = ""
		Else
			sStringList = Substring(sStringList, iOffset + iDelimiterLen)
		EndIf
;Trace("iElements:" + iElements + ", sReturn[iElements]:" + sReturn[iElements] + "    , sCSVlist:" + sCSVlist)
		iElements += 1
	EndWhile
	
	return sReturn
EndFunction