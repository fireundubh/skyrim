ScriptName dubhDisguiseQuestScript Extends Quest

; =============================================================================
; PURPOSE:	Allows the player add/remove factions by equipping/unequipping items
; 					while providing maximum compatibility with other mods
;
; AUTHOR: 	fireundubh <fireundubh@gmail.com>
; =============================================================================

; =============================================================================
; VARIABLES
; =============================================================================

; Debug
GlobalVariable Property iDubhScriptDebugDisguise Auto

; Globals
GlobalVariable Property dubhDisplayedTutorial Auto
GlobalVariable Property fDetectionViewCone Auto
GlobalVariable Property fDubhScriptDisguiseSpeed Auto

; Global Bounty Trackers
GlobalVariable Property iDubhCrimeImperial Auto
GlobalVariable Property iDubhCrimeStormcloaks Auto
GlobalVariable Property iDubhCrimeFalkreath Auto
GlobalVariable Property iDubhCrimeHjaalmarch Auto
GlobalVariable Property iDubhCrimeMarkarth Auto
GlobalVariable Property iDubhCrimePale Auto
GlobalVariable Property iDubhCrimeRavenRock Auto
GlobalVariable Property iDubhCrimeRiften Auto
GlobalVariable Property iDubhCrimeSolitude Auto
GlobalVariable Property iDubhCrimeWhiterun Auto
GlobalVariable Property iDubhCrimeWindhelm Auto
GlobalVariable Property iDubhCrimeWinterhold Auto

; Quests
Quest Property JailQuest Auto
Quest Property EscapeJailQuest Auto
Quest Property MS02 Auto

; Player
Actor Property Player Auto

; Tutorial
Message Property dubhFactionArmorTutorial01 Auto
Message Property dubhFactionArmorTutorial02 Auto

; Formlists
Formlist Property dubhBaseFactions Auto
Formlist Property dubhCrimeFactions Auto
Formlist Property dubhDisguiseFactions Auto
Formlist Property dubhDisguiseFormlists Auto
Formlist Property dubhExcludedDisguises Auto

; Messages
Message[] Property DisguiseMessageOn Auto
Message[] Property DisguiseMessageOff Auto

; States
Bool[] Property FactionJoined Auto
Bool[] Property DisguiseActivated Auto

; =============================================================================
; FUNCTIONS
; =============================================================================

; -----------------------------------------------------------------------------
; Sends a message to the Papyrus log
; -----------------------------------------------------------------------------
Function Log(String msgTrace)
	If iDubhScriptDebugDisguise.GetValueInt() == 1
		Debug.Trace("Master of Disguise: DisguiseQuestScript> " + msgTrace)
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Returns a global variable if the iIndex is associated with a bounty faction
; -----------------------------------------------------------------------------
GlobalVariable Function GetBountyTracker(Int iIndex)
	If iIndex == 5
		Return iDubhCrimeImperial
	ElseIf iIndex == 9
		Return iDubhCrimeStormcloaks
	ElseIf iIndex == 18
		Return iDubhCrimeFalkreath
	ElseIf iIndex == 19
		Return iDubhCrimeHjaalmarch
	ElseIf iIndex == 20
		Return iDubhCrimeMarkarth
	ElseIf iIndex == 21
		Return iDubhCrimePale
	ElseIf iIndex == 22
		Return iDubhCrimeRavenRock
	ElseIf iIndex == 23
		Return iDubhCrimeRiften
	ElseIf iIndex == 24
		Return iDubhCrimeSolitude
	ElseIf iIndex == 25
		Return iDubhCrimeWhiterun
	ElseIf iIndex == 26
		Return iDubhCrimeWindhelm
	ElseIf iIndex == 27
		Return iDubhCrimeWinterhold
	EndIf
	Return None
EndFunction

; -----------------------------------------------------------------------------
; Returns true or false if the iIndex is associated with a bounty faction
; -----------------------------------------------------------------------------
Bool Function HasBountyFaction(Int iIndex)
	If iIndex == 5
		Return True
	ElseIf iIndex == 9
		Return True
	ElseIf iIndex == 18
		Return True
	ElseIf iIndex == 19
		Return True
	ElseIf iIndex == 20
		Return True
	ElseIf iIndex == 21
		Return True
	ElseIf iIndex == 22
		Return True
	ElseIf iIndex == 23
		Return True
	ElseIf iIndex == 24
		Return True
	ElseIf iIndex == 25
		Return True
	ElseIf iIndex == 26
		Return True
	ElseIf iIndex == 27
		Return True
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Saves player's bounty to a global variable; decreases actual bounty to zero
; -----------------------------------------------------------------------------
Function SaveBounty(Int iIndex)
	If HasBountyFaction(iIndex)
		Faction currentFaction = dubhCrimeFactions.GetAt(iIndex) as Faction
		GlobalVariable gvBountyTracker = GetBountyTracker(iIndex)
		Int currentBounty = currentFaction.GetCrimeGold()
		If currentBounty > 0
			Log("Current bounty is " + currentBounty)
			gvBountyTracker.SetValueInt(currentBounty)
			Log("Saved bounty of " + gvBountyTracker.GetValueInt() + " to " + gvBountyTracker)
			currentFaction.ModCrimeGold(-currentBounty, false) ; Nonviolent Crime
			currentBounty = currentFaction.GetCrimeGold()
			If currentBounty > 0
				currentFaction.ModCrimeGold(-currentBounty, true) ; Violent Crime
			EndIf
			Log("Set current bounty to " + currentFaction.GetCrimeGold())
		EndIf
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Restores player's bounty from global variable; decreases variable to zero
; -----------------------------------------------------------------------------
Function RestoreBounty(Int iIndex)
	If HasBountyFaction(iIndex)
		Faction currentFaction = dubhCrimeFactions.GetAt(iIndex) as Faction
		GlobalVariable gvBountyTracker = GetBountyTracker(iIndex)
		Int newBounty = currentFaction.GetCrimeGold() + gvBountyTracker.GetValueInt()
		If newBounty > 0
			Log("New current bounty is " + newBounty)
			gvBountyTracker.SetValueInt(0)
			Log("Cleared bounty from " + gvBountyTracker)
			currentFaction.ModCrimeGold(newBounty, true)
			Log("Set current bounty to " + currentFaction.GetCrimeGold())
		EndIf
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Adds the player to the specified disguise faction, notifies the player,
; and sets the respective Bool flag in DisguiseActivated[] to TRUE
; -----------------------------------------------------------------------------
Function AddDisguise(Faction factDisguiseToAdd)
	Int iIndex = dubhDisguiseFactions.Find(factDisguiseToAdd)
	If iIndex > -1
		Faction currentDisguiseFaction = dubhDisguiseFactions.GetAt(iIndex) as Faction
		Log("Trying to add Player to disguise faction: " + currentDisguiseFaction)
		If !FactionJoined[iIndex] && !IsMember(currentDisguiseFaction) && CanDisguiseActivate(iIndex)
			Log("Player is not in disguise faction: " + currentDisguiseFaction)
			If ShowTutorialMessages()
				Log("Tutorial messages displayed to Player")
			EndIf
			DisguiseMessageOn[iIndex].Show()
			Log("Adding to disguise faction: " + currentDisguiseFaction)
			Player.AddToFaction(currentDisguiseFaction)
			If IsMember(currentDisguiseFaction)
				DisguiseActivated[iIndex] = True
				Log("Disguise activated: SUCCESS")
				Log("Disguises activated: " + DisguiseActivated)
			EndIf
		EndIf
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Removes the player from the specified disguise faction, notifies the player,
; and sets the respective Bool flag in DisguiseActivated[] to FALSE
; -----------------------------------------------------------------------------
Function RemoveDisguise(Faction factDisguiseToRemove)
	Int iIndex = dubhDisguiseFactions.Find(factDisguiseToRemove)
	If iIndex > -1
		Faction currentDisguiseFaction = dubhDisguiseFactions.GetAt(iIndex) as Faction
		Log("Trying to remove player from disguise faction: " + currentDisguiseFaction)
		If IsMember(currentDisguiseFaction)
			Log("Player is in disguise faction: " + currentDisguiseFaction)
			DisguiseMessageOff[iIndex].Show()
			Log("Removing from disguise faction: " + currentDisguiseFaction)
			Player.RemoveFromFaction(currentDisguiseFaction)
			If !IsMember(currentDisguiseFaction)
				DisguiseActivated[iIndex] = False
				Log("Disguise deactivated: SUCCESS")
				Log("Disguises activated: " + DisguiseActivated)
			EndIf
		EndIf
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Returns TRUE if the disguise can be activated without conflicts
; -----------------------------------------------------------------------------
Bool Function CanDisguiseActivate(Int iIndex)
	If iIndex == 1 && DisguiseActivated[12]      ; Cultists vs. Vigil of Stendarr
		Return False
	ElseIf iIndex == 4 && DisguiseActivated[26]  ; Forsworn vs. Windhelm Guard
		Return False
	ElseIf iIndex == 8 && DisguiseActivated[16]  ; Silver Hand vs. Werewolves
		Return False
	ElseIf iIndex == 8 && DisguiseActivated[17]  ; Silver Hand vs. The Companions
		Return False
	ElseIf iIndex == 12 && DisguiseActivated[1]  ; Vigil of Stendarr vs. Cultists
		Return False
	ElseIf iIndex == 12 && DisguiseActivated[13] ; Vigil of Stendarr vs. Clan Volkihar
		Return False
	ElseIf iIndex == 12 && DisguiseActivated[14] ; Vigil of Stendarr vs. Necromancers
		Return False
	ElseIf iIndex == 12 && DisguiseActivated[15] ; Vigil of Stendarr vs. Vampires
		Return False
	ElseIf iIndex == 12 && DisguiseActivated[16] ; Vigil of Stendarr vs. Werewolves
		Return False
	ElseIf iIndex == 12 && DisguiseActivated[17] ; Vigil of Stendarr vs. The Companions
		Return False
	ElseIf iIndex == 12 && DisguiseActivated[28] ; Vigil of Stendarr vs. Daedric Influence
		Return False
	ElseIf iIndex == 13 && DisguiseActivated[12] ; Clan Volkihar vs. Vigil of Stendarr
		Return False
	ElseIf iIndex == 14 && DisguiseActivated[12] ; Necromancers vs. Vigil of Stendarr
		Return False
	ElseIf iIndex == 15 && DisguiseActivated[12] ; Vampires vs. Vigil of Stendarr
		Return False
	ElseIf iIndex == 16 && DisguiseActivated[12] ; Werewolves vs. Vigil of Stendarr
		Return False
	ElseIf iIndex == 17 && DisguiseActivated[12] ; The Companions vs. Vigil of Stendarr
		Return False
	ElseIf iIndex == 18 && DisguiseActivated[26] ; Falkreath Guard vs. Windhelm Guard
		Return False
	ElseIf iIndex == 19 && DisguiseActivated[26] ; Hjaalmarch Guard vs. Windhelm Guard
		Return False
	ElseIf iIndex == 20 && DisguiseActivated[26] ; Markarth Guard vs. Windhelm Guard
		Return False
	ElseIf iIndex == 21 && DisguiseActivated[26] ; Pale Guard vs. Windhelm Guard
		Return False
	ElseIf iIndex == 22 && DisguiseActivated[26] ; Raven Rock Guard vs. Windhelm Guard
		Return False
	ElseIf iIndex == 23 && DisguiseActivated[26] ; Riften Guard vs. Windhelm Guard
		Return False
	ElseIf iIndex == 24 && DisguiseActivated[26] ; Solitude Guard vs. Windhelm Guard
		Return False
	ElseIf iIndex == 25 && DisguiseActivated[26] ; Whiterun Guard vs. Windhelm Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[4]  ; Windhelm Guard vs. Forsworn
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[18] ; Windhelm Guard vs. Falkreath Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[19] ; Windhelm Guard vs. Hjaalmarch Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[20] ; Windhelm Guard vs. Markarth Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[21] ; Windhelm Guard vs. Pale Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[22] ; Windhelm Guard vs. Raven Rock Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[23] ; Windhelm Guard vs. Riften Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[24] ; Windhelm Guard vs. Solitude Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[25] ; Windhelm Guard vs. Whiterun Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[27] ; Windhelm Guard vs. Winterhold Guard
		Return False
	ElseIf iIndex == 26 && DisguiseActivated[30] ; Windhelm Guard vs. Bandits
		Return False
	ElseIf iIndex == 27 && DisguiseActivated[26] ; Winterhold Guard vs. Windhelm Guard
		Return False
	ElseIf iIndex == 28 && DisguiseActivated[12] ; Daedric Influence vs. Vigil of Stendarr
		Return False
	ElseIf iIndex == 30 && DisguiseActivated[26] ; Bandits vs. Windhelm Guard
		Return False
	ElseIf iIndex == 30 && !IsDisguiseAllowed(30) ; Bandits can be toggled on/off through MCM
		Return False
	EndIf
	Return True
EndFunction

; -----------------------------------------------------------------------------
; Returns TRUE if the Formlist contains the Armor worn in the specified slot
; -----------------------------------------------------------------------------
Bool Function ObjHasDisguise(Formlist flstDisguise, Form SlotMask)
	If flstDisguise.HasForm(SlotMask)
		Return True
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns TRUE if the player is in the specified faction
; -----------------------------------------------------------------------------
Bool Function IsMember(Faction factFaction)
	If Player.IsInFaction(factFaction)
		If Player.GetFactionRank(factFaction) > -1
			Return True
		EndIf
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns the Form object for the slot associated with the specified disguise
; -----------------------------------------------------------------------------
Form Function GetSlotMask(Int iIndex)
	Formlist currentDisguiseFormlist = dubhDisguiseFormlists.GetAt(iIndex) as Formlist

	If iIndex == 1
		Form curSlotCirc = Player.GetWornForm(0x00001000) as Form ; Circlet
		If curSlotCirc != None && ObjHasDisguise(currentDisguiseFormlist, curSlotCirc)
			Return curSlotCirc
		EndIf

	ElseIf iIndex == 8
		Form curSlotRing = Player.GetWornForm(0x00000040) as Form ; Ring
		If curSlotRing != None && ObjHasDisguise(currentDisguiseFormlist, curSlotRing)
			Return curSlotRing
		EndIf

	ElseIf iIndex == 12
		Form curSlotAmlt = Player.GetWornForm(0x00000020) as Form ; Amulet
		If curSlotAmlt != None && ObjHasDisguise(currentDisguiseFormlist, curSlotAmlt)
			Return curSlotAmlt
		EndIf

	ElseIf iIndex == 26
		Form curSlotShld = Player.GetWornForm(0x00000200) as Form ; Shield
		If curSlotShld != None && ObjHasDisguise(currentDisguiseFormlist, curSlotShld)
			Return curSlotShld
		EndIf

	ElseIf iIndex == 28
		Form curSlotBody = Player.GetWornForm(0x00000004) as Form ; Body
		If curSlotBody != None && ObjHasDisguise(currentDisguiseFormlist, curSlotBody)
			Return curSlotBody
		EndIf

		Form curSlotHand = Player.GetWornForm(0x00000008) as Form ; Hands
		If curSlotHand != None && ObjHasDisguise(currentDisguiseFormlist, curSlotHand)
			Return curSlotHand
		EndIf

		Form curSlotFeet = Player.GetWornForm(0x00000080) as Form ; Feet
		If curSlotFeet != None && ObjHasDisguise(currentDisguiseFormlist, curSlotFeet)
			Return curSlotFeet
		EndIf

		Form curSlotCirc = Player.GetWornForm(0x00001000) as Form ; Circlet
		If curSlotCirc != None && ObjHasDisguise(currentDisguiseFormlist, curSlotCirc)
			Return curSlotCirc
		EndIf

		Form curSlotShld = Player.GetWornForm(0x00000200) as Form ; Shield
		If curSlotShld != None && ObjHasDisguise(currentDisguiseFormlist, curSlotShld)
			Return curSlotShld
		EndIf

		Form curSlotWeapL = Player.GetEquippedWeapon(True) as Form ; Weapon Left
		If curSlotWeapL != None && ObjHasDisguise(currentDisguiseFormlist, curSlotWeapL)
			Return curSlotWeapL
		EndIf

		Form curSlotWeapR = Player.GetEquippedWeapon() as Form ; Weapon Right
		If curSlotWeapR != None && ObjHasDisguise(currentDisguiseFormlist, curSlotWeapR)
			Return curSlotWeapR
		EndIf

	Else
		Form curSlotBody = Player.GetWornForm(0x00000004) as Form ; Body
		;Log("Evaluating " + DisguiseFormlist[iIndex] + " which is at index " + iIndex)
		If curSlotBody != None && ObjHasDisguise(currentDisguiseFormlist, curSlotBody)
			;Log("curSlotBody returning " + curSlotBody)
			Return curSlotBody
		Else
			;Log("curSlotBody returning None but actual value is " + curSlotBody)
			Return None
		EndIf
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Returns True if the Disguise Faction is NOT in the DisguisesDisallowed FLST
; -----------------------------------------------------------------------------
Bool Function IsDisguiseAllowed(Int iIndex)
	Faction currentDisguiseFaction = dubhDisguiseFactions.GetAt(iIndex) as Faction
	If dubhExcludedDisguises.HasForm(currentDisguiseFaction)
		;Log(currentDisguiseFaction + " is in " + DisguisesDisallowed + " and may not be activated")
		Return False
	EndIf
	Return True
EndFunction

; -----------------------------------------------------------------------------
; Adds and removes disguises by iterating through DisguiseFormlist[] array
; -----------------------------------------------------------------------------
Function UpdateDisguises()
	Int iIndex = 0
	While iIndex < dubhDisguiseFormlists.GetSize()
		; CONDITIONS:
		; 1. The appropriate slot mask must not be null or naked
		; 2. The disguise must not have already been activated
		; 3. Player must be wearing the essential disguise component in the determined slot mask
		Form SlotMask = GetSlotMask(iIndex)
		Bool currentFactionJoined = FactionJoined[iIndex] as Bool
		Bool currentDisguiseActivated = DisguiseActivated[iIndex] as Bool
		Faction currentDisguiseFaction = dubhDisguiseFactions.GetAt(iIndex) as Faction
		Formlist currentDisguiseFormlist = dubhDisguiseFormlists.GetAt(iIndex) as Formlist

		If !currentFactionJoined && !IsMember(currentDisguiseFaction) && !currentDisguiseActivated
			If ObjHasDisguise(currentDisguiseFormlist, SlotMask)
				SaveBounty(iIndex)
				AddDisguise(currentDisguiseFaction)
			EndIf
		ElseIf IsMember(currentDisguiseFaction) && currentDisguiseActivated
			If !ObjHasDisguise(currentDisguiseFormlist, SlotMask) || !IsDisguiseAllowed(iIndex)
				RestoreBounty(iIndex)
				RemoveDisguise(currentDisguiseFaction)
			EndIf
		EndIf

		iIndex += 1
	EndWhile
EndFunction

; -----------------------------------------------------------------------------
; Sets Bool flags in FactionJoined[] if the player is in a base faction
; -----------------------------------------------------------------------------
Function UpdateMemberships()
	Int iIndex = 0
	While iIndex < dubhBaseFactions.GetSize()
		Faction currentBaseFaction = dubhBaseFactions.GetAt(iIndex) as Faction
		FactionJoined[iIndex] = IsMember(currentBaseFaction)
		iIndex += 1
	EndWhile
EndFunction

; =============================================================================
; EVENTS
; =============================================================================

; -----------------------------------------------------------------------------
; Determines whether SKSE is installed when the script is initialized
; -----------------------------------------------------------------------------
Event OnInit()
	Log("--------------------------------------------------------------------------------")
	Log("Initializing...")
	Log("--------------------------------------------------------------------------------")
	CheckForSKSE()
EndEvent

; -----------------------------------------------------------------------------
; Determines whether SKSE is installed when a save is loaded
; -----------------------------------------------------------------------------
Event OnPlayerLoadGame()
	CheckForSKSE()
EndEvent

; -----------------------------------------------------------------------------
; Where the script stays alive
; -----------------------------------------------------------------------------
State Active
	Event OnBeginState()
		RegisterForSingleUpdate(fDubhScriptDisguiseSpeed.GetValue())
	EndEvent

	Event OnUpdate()
		If !Utility.IsInMenuMode()
			fDetectionViewCone.SetValue(Game.GetGameSettingFloat("fDetectionViewCone"))
			UpdateMemberships()
			UpdateDisguises()
		EndIf
		RegisterForSingleUpdate(fDubhScriptDisguiseSpeed.GetValue())
	EndEvent
EndState

; -----------------------------------------------------------------------------
; Where the script goes to die
; -----------------------------------------------------------------------------
State Dead
EndState

; =============================================================================
; DEBUG FUNCTIONS
; =============================================================================

; -----------------------------------------------------------------------------
; Determines whether SKSE is installed
; -----------------------------------------------------------------------------
Function CheckForSKSE()
	If SKSE.GetVersionRelease() > 0
		GoToState("Active")
	Else
		Debug.MessageBox("SKSE must be installed for Master of Disguise to work. You can download SKSE at skse.silverlock.org.")
		GoToState("Dead")
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Displays the tutorial messages once
; -----------------------------------------------------------------------------
Bool Function ShowTutorialMessages()
	Int i = dubhDisplayedTutorial.GetValue() as Int
	If i == 0
		If dubhFactionArmorTutorial01.Show() == 0
			If dubhFactionArmorTutorial02.Show() == 0
				dubhDisplayedTutorial.SetValueInt(1)
				Return True
			EndIf
		EndIf
	EndIf
	Return False
EndFunction