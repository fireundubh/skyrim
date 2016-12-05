ScriptName dubhApplyingEffectScript Extends ActiveMagicEffect

; Globals
GlobalVariable Property iDubhScriptDebugMonitor Auto
GlobalVariable Property	iDubhDetectionEnabled Auto
GlobalVariable Property iDubhAlwaysSucceedDremora Auto
GlobalVariable Property iDubhAlwaysSucceedWerewolves Auto

; Actors
Actor Property Player Auto
Actor NPC

; Abilities
Spell Property dubhMonitorAbility Auto

; Races Formlist
Formlist Property dubhBaseFaction Auto
Formlist Property dubhExcludedActors Auto
Formlist Property dubhExcludedFactions Auto

; -----------------------------------------------------------------------------
; Sends a message to the Papyrus log
; -----------------------------------------------------------------------------
Function Log(String msgTrace)
	If iDubhScriptDebugMonitor.GetValueInt() == 1
		Debug.Trace("Master of Disguise: ApplyingEffectScript> " + msgTrace)
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Returns TRUE if the NPC has an excluded actor type keyword
; -----------------------------------------------------------------------------
Bool Function IsExcludedActorType()
	Int iIndex = 0
	While iIndex < dubhExcludedActors.GetSize()
		Keyword currentKeyword = dubhExcludedActors.GetAt(iIndex) as Keyword
		If NPC.HasKeyword(currentKeyword)
			Return True
		EndIf
		iIndex += 1
	EndWhile
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns TRUE if the actor is in the specified faction
; -----------------------------------------------------------------------------
Bool Function IsInValidFaction()
	Int iIndex = 0
	While iIndex < dubhBaseFaction.GetSize()
		Faction currentFaction = dubhBaseFaction.GetAt(iIndex) as Faction
		If NPC.IsInFaction(currentFaction)
			If NPC.GetFactionRank(currentFaction) > -1
				Return True
			EndIf
		EndIf
		iIndex += 1
	EndWhile
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns TRUE if the actor is in the specified faction
; -----------------------------------------------------------------------------
Bool Function IsInExcludedFaction()
	Int iIndex = 0
	While iIndex < dubhExcludedFactions.GetSize()
		Faction excludedFaction = dubhExcludedFactions.GetAt(iIndex) as Faction
		;Log("Excluded Faction: " + excludedFaction + " - Index: " + iIndex)
		If NPC.IsInFaction(excludedFaction)
			If NPC.GetFactionRank(excludedFaction) > -1
				Return True
			EndIf
		EndIf
		iIndex += 1
	EndWhile
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns TRUE if the actor has a relationship to the player greater than 0
; -----------------------------------------------------------------------------
Bool Function IsMoreThanAnAcquaintance()
	If NPC.GetRelationshipRank(Player) > 0
		Return True
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns TRUE if the actor is in the Dremora or Werewolves factions
; -----------------------------------------------------------------------------
Bool Function IgnoreActor()
	Faction WerewolvesFaction = dubhBaseFaction.GetAt(16) as Faction
	Faction DremoraFaction = dubhBaseFaction.GetAt(28) as Faction
	If NPC.IsInFaction(WerewolvesFaction) && iDubhAlwaysSucceedWerewolves.GetValue() == 1
		If NPC.GetFactionRank(WerewolvesFaction) > -1
			Return True
		EndIf
	ElseIf NPC.IsInFaction(DremoraFaction) && iDubhAlwaysSucceedDremora.GetValue() == 1
		If NPC.GetFactionRank(DremoraFaction) > -1
			Return True
		EndIf
	Else
		Return False
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Main
; -----------------------------------------------------------------------------
Event OnEffectStart(Actor akTarget, Actor akCaster)
	If iDubhDetectionEnabled.GetValueInt() == 1
		NPC = akTarget
		If !Player.IsDead() && !NPC.IsDead() && !NPC.HasSpell(dubhMonitorAbility) && NPC.GetDistance(Player) <= 2048
			If !IgnoreActor() && !IsInExcludedFaction() && IsInValidFaction() && !IsExcludedActorType() && !IsMoreThanAnAcquaintance()
				If NPC.AddSpell(dubhMonitorAbility)
					Log("Attached " + dubhMonitorAbility + " to " + NPC + " after satisfying all conditions")
				EndIf
			EndIf
		EndIf
	EndIf
EndEvent