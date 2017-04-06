ScriptName dubhMonitorEffectScript Extends ActiveMagicEffect

; Debug
GlobalVariable Property iDubhScriptDebugMonitor Auto
GlobalVariable Property iDubhAlwaysSucceedDremora Auto
GlobalVariable Property iDubhAlwaysSucceedWerewolves Auto

; Globals
GlobalVariable Property fDubhBestSkillContribMax Auto
GlobalVariable Property fDubhBountyPenaltyMult Auto
GlobalVariable Property fDubhLOSDistanceMax Auto
GlobalVariable Property fDubhLOSPenaltyClearMin Auto
GlobalVariable Property fDubhLOSPenaltyDistanceFar Auto
GlobalVariable Property fDubhLOSPenaltyDistanceMid Auto
GlobalVariable Property fDubhLOSPenaltyDistortedMin Auto
GlobalVariable Property fDubhLOSPenaltyPeripheralMin Auto
GlobalVariable Property fDubhMobilityBonus Auto
GlobalVariable Property fDubhMobilityPenalty Auto

; Globals - Scripts
GlobalVariable Property fDubhScriptDetectionSpeed Auto
GlobalVariable Property fDubhScriptDistanceMax Auto
GlobalVariable Property fDubhScriptSuspendTime Auto
GlobalVariable Property fDubhScriptSuspendTimeBeforeAttack Auto

; Globals - Race Values
GlobalVariable Property fDubhRaceArgonian Auto
GlobalVariable Property fDubhRaceArgonianVampire Auto
GlobalVariable Property fDubhRaceBreton Auto
GlobalVariable Property fDubhRaceBretonVampire Auto
GlobalVariable Property fDubhRaceDarkElf Auto
GlobalVariable Property fDubhRaceDarkElfVampire Auto
GlobalVariable Property fDubhRaceHighElf Auto
GlobalVariable Property fDubhRaceHighElfVampire Auto
GlobalVariable Property fDubhRaceImperial Auto
GlobalVariable Property fDubhRaceImperialVampire Auto
GlobalVariable Property fDubhRaceKhajiit Auto
GlobalVariable Property fDubhRaceKhajiitVampire Auto
GlobalVariable Property fDubhRaceNord Auto
GlobalVariable Property fDubhRaceNordVampire Auto
GlobalVariable Property fDubhRaceOrc Auto
GlobalVariable Property fDubhRaceOrcVampire Auto
GlobalVariable Property fDubhRaceRedguard Auto
GlobalVariable Property fDubhRaceRedguardVampire Auto
GlobalVariable Property fDubhRaceWoodElf Auto
GlobalVariable Property fDubhRaceWoodElfVampire Auto

; Globals - Slot Values
GlobalVariable Property fDubhSlotAmulet Auto
GlobalVariable Property fDubhSlotBody Auto
GlobalVariable Property fDubhSlotCirclet Auto
GlobalVariable Property fDubhSlotFeet Auto
GlobalVariable Property fDubhSlotHair Auto
GlobalVariable Property fDubhSlotHands Auto
GlobalVariable Property fDubhSlotRing Auto
GlobalVariable Property fDubhSlotShield Auto
GlobalVariable Property fDubhSlotWeaponLeft Auto
GlobalVariable Property fDubhSlotWeaponRight Auto

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
;Quest Property MS02 Auto

; Races
Race Property ArgonianRace Auto
Race Property ArgonianRaceVampire Auto
Race Property BretonRace Auto
Race Property BretonRaceVampire Auto
Race Property DarkElfRace Auto
Race Property DarkElfRaceVampire Auto
Race Property HighElfRace Auto
Race Property HighElfRaceVampire Auto
Race Property ImperialRace Auto
Race Property ImperialRaceVampire Auto
Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto
Race Property NordRace Auto
Race Property NordRaceVampire Auto
Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Race Property RedguardRace Auto
Race Property RedguardRaceVampire Auto
Race Property WoodElfRace Auto
Race Property WoodElfRaceVampire Auto

; Actor Data
Actor Property Player Auto
Actor NPC

; Skill Data
Float fPlayerSneakSkill = 0.0
Float fPlayerIllusionSkill = 0.0
Float fPlayerBestSkillWeight = 0.0

; Detection Chance
Float fDetectionMax = 100.0
Float fDetectionWeight = 0.0
Float iDetectionRoll = 0.0
Float iRandomChance = 0.0

; Abilities/Magic Effects
Spell Property dubhMonitorAbility Auto
Spell Property dubhFactionEnemyAbility Auto
MagicEffect Property dubhFactionEnemyEffect Auto

; Player Faction
Faction Property PlayerFaction Auto

; Guard Faction
Faction Property GuardFaction Auto

; Formlists
Formlist Property dubhBaseFactions Auto
Formlist Property dubhCrimeFactions Auto
Formlist Property dubhDisguiseFactions Auto
Formlist Property dubhDisguiseFormlists Auto
Formlist Property dubhDisguiseSlots Auto
Formlist Property dubhExcludedDamageSources Auto
Formlist Property dubhGuardFactions Auto

; Messages
Message Property dubhDisguiseWarningSuspicious Auto		; "You are being watched..." (5 second delay)

; ===============================================================================
; FUNCTIONS
; ===============================================================================

; -----------------------------------------------------------------------------
; Sends a message to the Papyrus log
; -----------------------------------------------------------------------------
Bool Function Log(String msgTrace)
	If iDubhScriptDebugMonitor.GetValueInt() == 1
		Debug.Trace("Master of Disguise: MonitorEffectScript> " + msgTrace)
		Return True
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Suspends the script from processing for some number of seconds
; -----------------------------------------------------------------------------
Function Suspend(Float fSeconds)
	Float fTimeSuspending = Utility.GetCurrentRealTime()
	Float fTimeSuspendingGoal = (Utility.GetCurrentRealTime() + fSeconds)
	While fTimeSuspending < fTimeSuspendingGoal
		fTimeSuspending = Utility.GetCurrentRealTime()
	EndWhile
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
	If iIndex == 5 || iIndex == 9 || iIndex == 18 || iIndex == 19 || iIndex == 20 || iIndex == 21 || iIndex == 22 || iIndex == 23 || iIndex == 24 || iIndex == 25 || iIndex == 26 || iIndex == 27
		Return True
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns the integer value of the current disguise if wearing a guard uniform
; -----------------------------------------------------------------------------
Int Function WhichGuardDisguise()
	Int iIndex = 0
	While iIndex < dubhDisguiseFactions.GetSize()
		Faction currentDisguiseFaction = dubhDisguiseFactions.GetAt(iIndex) as Faction
		If IsMember(currentDisguiseFaction) && HasBountyFaction(iIndex)
			Return iIndex
		EndIf
		iIndex += 1
	EndWhile
	Return -1
EndFunction

; -----------------------------------------------------------------------------
; Returns True if the damage source is excluded
; -----------------------------------------------------------------------------
Bool Function IsExcludedDamageSource(Form sourceOfDamage)
	Int iIndex = 0
	While iIndex < dubhExcludedDamageSources.GetSize()
		Form currentDamageSource = dubhExcludedDamageSources.GetAt(iIndex) as Form
		If sourceOfDamage == currentDamageSource
			Return True
		EndIf
		iIndex += 1
	EndWhile
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Saves player's bounty to a global variable; decreases actual bounty to zero
; -----------------------------------------------------------------------------
Bool Function SaveBounty(Int iIndex)
	If iIndex > -1 && HasBountyFaction(iIndex)
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
			Return True
		EndIf
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Restores player's bounty from global variable; decreases variable to zero
; -----------------------------------------------------------------------------
Bool Function RestoreBounty(Int iIndex)
	If iIndex > -1 && HasBountyFaction(iIndex)
		Faction currentFaction = dubhCrimeFactions.GetAt(iIndex) as Faction
		GlobalVariable gvBountyTracker = GetBountyTracker(iIndex)
		Int newBounty = currentFaction.GetCrimeGold() + gvBountyTracker.GetValueInt()
		If newBounty > 0
			Log("New current bounty is " + newBounty)
			gvBountyTracker.SetValueInt(0)
			Log("Cleared bounty from " + gvBountyTracker)
			currentFaction.ModCrimeGold(newBounty, true)
			Log("Set current bounty to " + currentFaction.GetCrimeGold())
			Return True
		EndIf
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns the penalty for the tracked bounty as a float. This value is a mult.
; -----------------------------------------------------------------------------
Float Function GetBountyPenalty(Int iIndex)
	If iIndex >= 5
		GlobalVariable gvBountyTracker = GetBountyTracker(iIndex)
		Int iTrackedBounty = gvBountyTracker.GetValueInt()
		Float fBountyPenalty = (1.0 - ((iTrackedBounty * fDubhBountyPenaltyMult.GetValue()) / 100.0))
		If fBountyPenalty < 0.0
			Return 0.0
		Else
			Return fBountyPenalty
		EndIf
	EndIf
	Return 1.0
EndFunction

; -------------------------------------------------------------------------------
; Gets the actor's best skill, either Sneak or Illusion, and returns the weight
; 	of the best skill on the chance to remain undetected
; 	Ex: fDetectionWeight += GetBestSkillWeight(Player)
; -------------------------------------------------------------------------------
Float Function GetBestSkillWeight(Float fSkillPenalty)
	fPlayerSneakSkill    = Player.GetActorValue("Sneak")
	fPlayerIllusionSkill = Player.GetActorValue("Illusion")

	; Cap best skill to 100
	If fPlayerSneakSkill > 100
		fPlayerSneakSkill = 100
	EndIf

	If fPlayerIllusionSkill > 100
		fPlayerIllusionSkill = 100
	EndIf

	; Calculate best skill weight
	If fPlayerSneakSkill >= fPlayerIllusionSkill
		Log("Using Sneak as best skill: " + fPlayerSneakSkill)
		Return (((fDubhBestSkillContribMax.GetValue() * fPlayerSneakSkill) / 100) * fSkillPenalty)
	ElseIf fPlayerSneakSkill < fPlayerIllusionSkill
		Log("Using Illusion as best skill: " + fPlayerIllusionSkill)
		Return (((fDubhBestSkillContribMax.GetValue() * fPlayerIllusionSkill) / 100) * fSkillPenalty)
	EndIf
EndFunction

; -------------------------------------------------------------------------------
; Gets the actor's race, if the actor is in the associated faction, and returns
; 	the weight of the race on the chance to remain to undetected
;		Ex: fDetectionWeight += GetRaceWeight(Player, CustomFaction11, HighElfRace, 20)
; -------------------------------------------------------------------------------
Float Function GetRaceWeight(Race akRace)
	Float fRaceWeight = 0.0
	Race currentPlayerRace = Player.GetRace()

	If akRace == ArgonianRace && akRace == currentPlayerRace ; Argonian
		fRaceWeight = fDubhRaceArgonian.GetValue()
	ElseIf akRace == ArgonianRaceVampire && akRace == currentPlayerRace ; Argonian Vampire
		fRaceWeight = fDubhRaceArgonianVampire.GetValue()

	ElseIf akRace == BretonRace && akRace == currentPlayerRace ; Breton
		fRaceWeight = fDubhRaceBreton.GetValue()
	ElseIf akRace == BretonRaceVampire && akRace == currentPlayerRace ; Breton Vampire
		fRaceWeight = fDubhRaceBretonVampire.GetValue()

	ElseIf akRace == DarkElfRace && akRace == currentPlayerRace ; Dark Elf
		fRaceWeight = fDubhRaceDarkElf.GetValue()
	ElseIf akRace == DarkElfRaceVampire && akRace == currentPlayerRace ; Dark Elf Vampire
		fRaceWeight = fDubhRaceDarkElfVampire.GetValue()

	ElseIf akRace == HighElfRace && akRace == currentPlayerRace ; High Elf
		fRaceWeight = fDubhRaceHighElf.GetValue()
	ElseIf akRace == HighElfRaceVampire && akRace == currentPlayerRace ; High Elf Vampire
		fRaceWeight = fDubhRaceHighElfVampire.GetValue()

	ElseIf akRace == ImperialRace && akRace == currentPlayerRace ; Imperial
		fRaceWeight = fDubhRaceImperial.GetValue()
	ElseIf akRace == ImperialRaceVampire && akRace == currentPlayerRace ; Imperial Vampire
		fRaceWeight = fDubhRaceImperialVampire.GetValue()

	ElseIf akRace == KhajiitRace && akRace == currentPlayerRace ; Khajiit
		fRaceWeight = fDubhRaceKhajiit.GetValue()
	ElseIf akRace == KhajiitRaceVampire && akRace == currentPlayerRace ; Khajiit Vampire
		fRaceWeight = fDubhRaceKhajiitVampire.GetValue()

	ElseIf akRace == NordRace && akRace == currentPlayerRace ; Nord
		fRaceWeight = fDubhRaceNord.GetValue()
	ElseIf akRace == NordRaceVampire && akRace == currentPlayerRace ; Nord Vampire
		fRaceWeight = fDubhRaceNordVampire.GetValue()

	ElseIf akRace == OrcRace && akRace == currentPlayerRace ; Orc
		fRaceWeight = fDubhRaceOrc.GetValue()
	ElseIf akRace == OrcRaceVampire && akRace == currentPlayerRace ; Orc Vampire
		fRaceWeight = fDubhRaceOrcVampire.GetValue()

	ElseIf akRace == RedguardRace && akRace == currentPlayerRace ; Redguard
		fRaceWeight = fDubhRaceRedguard.GetValue()
	ElseIf akRace == RedguardRaceVampire && akRace == currentPlayerRace ; Redguard Vampire
		fRaceWeight = fDubhRaceRedguardVampire.GetValue()

	ElseIf akRace == WoodElfRace && akRace == currentPlayerRace ; Wood Elf
		fRaceWeight = fDubhRaceWoodElf.GetValue()
	ElseIf akRace == WoodElfRaceVampire && akRace == currentPlayerRace ; Wood Elf Vampire
		fRaceWeight = fDubhRaceWoodElfVampire.GetValue()

	Else
		fRaceWeight = 0.0
	EndIf

	Return fRaceWeight
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

; Disguise Formlist
; Disguise Slots Formlist 
; -- Disguise Slot Formlist
; ----- Disguise Armor Forms for that slot 

Form Function GetWornForm_NoSKSE(Formlist akSlot)
	Int i = 0
	While i < akSlot.GetSize()
		Form kItem = akSlot.GetAt(i)
		If Player.IsEquipped(kItem)
			Return kItem
		EndIf
		i += 1
	EndWhile
	
	Return None
EndFunction

; -----------------------------------------------------------------------------
; Returns the Bool[] array identifying which slots are used
; -----------------------------------------------------------------------------
Bool[] Function WhichSlotMasks(Int iIndex)
	Bool[] bWhichSlotMasks = new Bool[10]
	Formlist currentDisguise = dubhDisguiseFormlists.GetAt(iIndex) as Formlist
	Formlist currentDisguiseSlots = dubhDisguiseSlots.GetAt(iIndex) as Formlist

	Form WornForm_0 = GetWornForm_NoSKSE(currentDisguiseSlots.GetAt(0) as Formlist) as Form ; 0 Hair
	Form WornForm_1 = GetWornForm_NoSKSE(currentDisguiseSlots.GetAt(1) as Formlist) as Form ; 1 Body
	Form WornForm_2 = GetWornForm_NoSKSE(currentDisguiseSlots.GetAt(2) as Formlist) as Form ; 2 Hands
	Form WornForm_3 = GetWornForm_NoSKSE(currentDisguiseSlots.GetAt(3) as Formlist) as Form ; 3 Amulet
	Form WornForm_4 = GetWornForm_NoSKSE(currentDisguiseSlots.GetAt(4) as Formlist) as Form ; 4 Ring
	Form WornForm_5 = GetWornForm_NoSKSE(currentDisguiseSlots.GetAt(5) as Formlist) as Form ; 5 Feet
	Form WornForm_6 = GetWornForm_NoSKSE(currentDisguiseSlots.GetAt(6) as Formlist) as Form ; 6 Shield
	Form WornForm_7 = GetWornForm_NoSKSE(currentDisguiseSlots.GetAt(7) as Formlist) as Form ; 7 Circlet
	
	bWhichSlotMasks[0] = currentDisguise.HasForm(WornForm_0) ; 0 Hair
	bWhichSlotMasks[1] = currentDisguise.HasForm(WornForm_1) ; 1 Body
	bWhichSlotMasks[2] = currentDisguise.HasForm(WornForm_2) ; 2 Hands
	bWhichSlotMasks[3] = currentDisguise.HasForm(WornForm_3) ; 3 Amulet
	bWhichSlotMasks[4] = currentDisguise.HasForm(WornForm_4) ; 4 Ring
	bWhichSlotMasks[5] = currentDisguise.HasForm(WornForm_5) ; 5 Feet
	bWhichSlotMasks[6] = currentDisguise.HasForm(WornForm_6) ; 6 Shield
	bWhichSlotMasks[7] = currentDisguise.HasForm(WornForm_7) ; 7 Circlet
	bWhichSlotMasks[8] = currentDisguise.HasForm(Player.GetEquippedWeapon(true) as Form) ; 8 Weapon - Left
	bWhichSlotMasks[9] = currentDisguise.HasForm(Player.GetEquippedWeapon() as Form)     ; 9 Weapon - Right
	
	Return bWhichSlotMasks
EndFunction

; -----------------------------------------------------------------------------
; Returns the equipment score from worn items
; -----------------------------------------------------------------------------
; 1. Get worn items
; 2. Check if worn items are in formlist
; 3. If worn items are in formlist, return those slots as Bool array
Float Function GetEquipWeight(Bool[] bSlotMasks)
	Float fEquipWeight = 0.0

	If bSlotMasks[0] || !bSlotMasks[7] ; Hair and Circlet
		If bSlotMasks[0] && !bSlotMasks[7] ; Hair, but not Circlet
			fEquipWeight += fDubhSlotHair.GetValue()
		EndIf

		If !bSlotMasks[0] && bSlotMasks[7] ; Circlet, but not Hair
			fEquipWeight += fDubhSlotCirclet.GetValue()
		EndIf

		If bSlotMasks[0] && bSlotMasks[7] ; Both
			fEquipWeight += fDubhSlotCirclet.GetValue()
		EndIf
	EndIf

	If bSlotMasks[1] ; Body
		fEquipWeight += fDubhSlotBody.GetValue()
	EndIf

	If bSlotMasks[2] ; Hands
		fEquipWeight += fDubhSlotHands.GetValue()
	EndIf

	If bSlotMasks[3] ; Amulet
		fEquipWeight += fDubhSlotAmulet.GetValue()
	EndIf

	If bSlotMasks[4] ; Ring
		fEquipWeight += fDubhSlotRing.GetValue()
	EndIf

	If bSlotMasks[5] ; Feet
		fEquipWeight += fDubhSlotFeet.GetValue()
	EndIf

	If bSlotMasks[6] ; Shield
		fEquipWeight += fDubhSlotShield.GetValue()
	EndIf

	If bSlotMasks[8] || bSlotMasks[9]
		If bSlotMasks[8] && !bSlotMasks[9] ; Weapon Left, but not Weapon Right
			fEquipWeight += fDubhSlotWeaponLeft.GetValue()
		EndIf

		If !bSlotMasks[8] && bSlotMasks[9] ; Weapon Right, but not Weapon Left
			fEquipWeight += fDubhSlotWeaponRight.GetValue()
		EndIf

		If bSlotMasks[8] && bSlotMasks[9] ; Both
			fEquipWeight += fDubhSlotWeaponLeft.GetValue()
		EndIf
	EndIf

	If fEquipWeight > fDetectionMax
		fEquipWeight = fDetectionMax
	EndIf

	Return fEquipWeight
EndFunction

; -------------------------------------------------------------------------------
; Returns the player's dice roll
; -------------------------------------------------------------------------------
Int Function GetDetectionRoll(Float fPenalty)
	fDetectionWeight = 0.0
	fDetectionWeight += GetBestSkillWeight(fPenalty)

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(0) as Faction) ; Blades
		fDetectionWeight += GetRaceWeight(ImperialRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(0))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(1) as Faction) ; Cultists
		fDetectionWeight += GetRaceWeight(DarkElfRace)
		fDetectionWeight += GetRaceWeight(NordRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(1))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(2) as Faction) ; Dark Brotherhood
		fDetectionWeight += GetRaceWeight(ArgonianRaceVampire)
		fDetectionWeight += GetRaceWeight(BretonRaceVampire)
		fDetectionWeight += GetRaceWeight(DarkElfRaceVampire)
		fDetectionWeight += GetRaceWeight(HighElfRaceVampire)
		fDetectionWeight += GetRaceWeight(ImperialRaceVampire)
		fDetectionWeight += GetRaceWeight(KhajiitRaceVampire)
		fDetectionWeight += GetRaceWeight(NordRaceVampire)
		fDetectionWeight += GetRaceWeight(OrcRaceVampire)
		fDetectionWeight += GetRaceWeight(RedguardRaceVampire)
		fDetectionWeight += GetRaceWeight(WoodElfRaceVampire)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(2))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(3) as Faction) ; Dawnguard
		fDetectionWeight -= GetRaceWeight(ArgonianRaceVampire)
		fDetectionWeight -= GetRaceWeight(BretonRaceVampire)
		fDetectionWeight -= GetRaceWeight(DarkElfRaceVampire)
		fDetectionWeight -= GetRaceWeight(HighElfRaceVampire)
		fDetectionWeight -= GetRaceWeight(ImperialRaceVampire)
		fDetectionWeight -= GetRaceWeight(KhajiitRaceVampire)
		fDetectionWeight -= GetRaceWeight(NordRaceVampire)
		fDetectionWeight -= GetRaceWeight(OrcRaceVampire)
		fDetectionWeight -= GetRaceWeight(RedguardRaceVampire)
		fDetectionWeight -= GetRaceWeight(WoodElfRaceVampire)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(3))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(4) as Faction) ; Forsworn
		fDetectionWeight += GetRaceWeight(BretonRace)
		fDetectionWeight -= GetRaceWeight(ArgonianRace)
		fDetectionWeight -= GetRaceWeight(DarkElfRace)
		fDetectionWeight -= GetRaceWeight(HighElfRace)
		fDetectionWeight -= GetRaceWeight(ImperialRace)
		fDetectionWeight -= GetRaceWeight(KhajiitRace)
		fDetectionWeight -= GetRaceWeight(NordRace)
		fDetectionWeight -= GetRaceWeight(OrcRace)
		fDetectionWeight -= GetRaceWeight(RedguardRace)
		fDetectionWeight -= GetRaceWeight(WoodElfRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(4))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(5) as Faction) ; Imperial Legion
		fDetectionWeight += GetRaceWeight(ImperialRace)
		fDetectionWeight += GetRaceWeight(OrcRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(5)) * GetBountyPenalty(5)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(6) as Faction) ; Morag Tong
		fDetectionWeight += GetRaceWeight(DarkElfRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(6))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(7) as Faction) ; Penitus Oculatus
		fDetectionWeight += GetRaceWeight(ImperialRace)
		fDetectionWeight += GetRaceWeight(OrcRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(7))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(8) as Faction) ; Silver Hand
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(8))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(9) as Faction) ; Stormcloaks
		fDetectionWeight += GetRaceWeight(NordRace)
		fDetectionWeight -= GetRaceWeight(HighElfRace)
		fDetectionWeight -= GetRaceWeight(ImperialRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(9)) * GetBountyPenalty(9)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(10) as Faction) ; Thalmor
		fDetectionWeight += GetRaceWeight(HighElfRace)
		fDetectionWeight += GetRaceWeight(WoodElfRace)
		fDetectionWeight -= GetRaceWeight(ArgonianRace)
		fDetectionWeight -= GetRaceWeight(BretonRace)
		fDetectionWeight -= GetRaceWeight(DarkElfRace)
		fDetectionWeight -= GetRaceWeight(KhajiitRace)
		fDetectionWeight -= GetRaceWeight(NordRace)
		fDetectionWeight -= GetRaceWeight(OrcRace)
		fDetectionWeight -= GetRaceWeight(RedguardRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(10))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(11) as Faction) ; Thieves Guild
		fDetectionWeight += GetRaceWeight(ArgonianRace)
		fDetectionWeight += GetRaceWeight(KhajiitRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(11))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(12) as Faction) ; Vigil of Stendarr
		fDetectionWeight -= GetRaceWeight(ArgonianRaceVampire)
		fDetectionWeight -= GetRaceWeight(BretonRaceVampire)
		fDetectionWeight -= GetRaceWeight(DarkElfRaceVampire)
		fDetectionWeight -= GetRaceWeight(HighElfRaceVampire)
		fDetectionWeight -= GetRaceWeight(ImperialRaceVampire)
		fDetectionWeight -= GetRaceWeight(KhajiitRaceVampire)
		fDetectionWeight -= GetRaceWeight(NordRaceVampire)
		fDetectionWeight -= GetRaceWeight(OrcRaceVampire)
		fDetectionWeight -= GetRaceWeight(RedguardRaceVampire)
		fDetectionWeight -= GetRaceWeight(WoodElfRaceVampire)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(12))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(13) as Faction) ; Clan Volkihar
		fDetectionWeight += GetRaceWeight(ArgonianRaceVampire)
		fDetectionWeight += GetRaceWeight(BretonRaceVampire)
		fDetectionWeight += GetRaceWeight(DarkElfRaceVampire)
		fDetectionWeight += GetRaceWeight(HighElfRaceVampire)
		fDetectionWeight += GetRaceWeight(ImperialRaceVampire)
		fDetectionWeight += GetRaceWeight(KhajiitRaceVampire)
		fDetectionWeight += GetRaceWeight(NordRaceVampire)
		fDetectionWeight += GetRaceWeight(OrcRaceVampire)
		fDetectionWeight += GetRaceWeight(RedguardRaceVampire)
		fDetectionWeight += GetRaceWeight(WoodElfRaceVampire)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(13))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(14) as Faction) ; Necromancers
		fDetectionWeight += GetRaceWeight(ArgonianRaceVampire)
		fDetectionWeight += GetRaceWeight(BretonRaceVampire)
		fDetectionWeight += GetRaceWeight(DarkElfRaceVampire)
		fDetectionWeight += GetRaceWeight(HighElfRaceVampire)
		fDetectionWeight += GetRaceWeight(ImperialRaceVampire)
		fDetectionWeight += GetRaceWeight(KhajiitRaceVampire)
		fDetectionWeight += GetRaceWeight(NordRaceVampire)
		fDetectionWeight += GetRaceWeight(OrcRaceVampire)
		fDetectionWeight += GetRaceWeight(RedguardRaceVampire)
		fDetectionWeight += GetRaceWeight(WoodElfRaceVampire)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(14))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(15) as Faction) ; Vampires
		fDetectionWeight += GetRaceWeight(ArgonianRaceVampire)
		fDetectionWeight += GetRaceWeight(BretonRaceVampire)
		fDetectionWeight += GetRaceWeight(DarkElfRaceVampire)
		fDetectionWeight += GetRaceWeight(HighElfRaceVampire)
		fDetectionWeight += GetRaceWeight(ImperialRaceVampire)
		fDetectionWeight += GetRaceWeight(KhajiitRaceVampire)
		fDetectionWeight += GetRaceWeight(NordRaceVampire)
		fDetectionWeight += GetRaceWeight(OrcRaceVampire)
		fDetectionWeight += GetRaceWeight(RedguardRaceVampire)
		fDetectionWeight += GetRaceWeight(WoodElfRaceVampire)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(15))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(16) as Faction) ; Werewolves
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(16))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(17) as Faction) ; The Companions
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(17))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(18) as Faction) ; Falkreath Guard
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(18)) * GetBountyPenalty(18)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(19) as Faction) ; Hjaalmarch Guard
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(19)) * GetBountyPenalty(19)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(20) as Faction) ; Markarth Guard
		fDetectionWeight += GetRaceWeight(NordRace)
		fDetectionWeight -= GetRaceWeight(BretonRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(20)) * GetBountyPenalty(20)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(21) as Faction) ; Pale Guard
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(21)) * GetBountyPenalty(21)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(22) as Faction) ; Redoran Guard
		fDetectionWeight += GetRaceWeight(DarkElfRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(22)) * GetBountyPenalty(22)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(23) as Faction) ; Riften Guard
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(23)) * GetBountyPenalty(23)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(24) as Faction) ; Solitude Guard
		fDetectionWeight += GetRaceWeight(ImperialRace)
		fDetectionWeight += GetRaceWeight(OrcRace)
		fDetectionWeight -= GetRaceWeight(NordRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(24)) * GetBountyPenalty(24)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(25) as Faction) ; Whiterun Guard
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(25)) * GetBountyPenalty(25)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(26) as Faction) ; Windhelm Guard
		fDetectionWeight += GetRaceWeight(NordRace)
		fDetectionWeight -= GetRaceWeight(HighElfRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(26)) * GetBountyPenalty(26)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(27) as Faction) ; Winterhold Guard
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(27)) * GetBountyPenalty(27)
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(28) as Faction) ; Daedric Influence
		fDetectionWeight -= GetRaceWeight(ArgonianRace)
		fDetectionWeight -= GetRaceWeight(BretonRace)
		fDetectionWeight -= GetRaceWeight(DarkElfRace)
		fDetectionWeight -= GetRaceWeight(HighElfRace)
		fDetectionWeight -= GetRaceWeight(ImperialRace)
		fDetectionWeight -= GetRaceWeight(KhajiitRace)
		fDetectionWeight -= GetRaceWeight(NordRace)
		fDetectionWeight -= GetRaceWeight(OrcRace)
		fDetectionWeight -= GetRaceWeight(RedguardRace)
		fDetectionWeight -= GetRaceWeight(WoodElfRace)
		fDetectionWeight -= GetRaceWeight(ArgonianRaceVampire)
		fDetectionWeight -= GetRaceWeight(BretonRaceVampire)
		fDetectionWeight -= GetRaceWeight(DarkElfRaceVampire)
		fDetectionWeight -= GetRaceWeight(HighElfRaceVampire)
		fDetectionWeight -= GetRaceWeight(ImperialRaceVampire)
		fDetectionWeight -= GetRaceWeight(KhajiitRaceVampire)
		fDetectionWeight -= GetRaceWeight(NordRaceVampire)
		fDetectionWeight -= GetRaceWeight(OrcRaceVampire)
		fDetectionWeight -= GetRaceWeight(RedguardRaceVampire)
		fDetectionWeight -= GetRaceWeight(WoodElfRaceVampire)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(28))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(29) as Faction) ; Alik'r Mercenaries
		fDetectionWeight += GetRaceWeight(RedguardRace)
		fDetectionWeight -= GetRaceWeight(ArgonianRace)
		fDetectionWeight -= GetRaceWeight(BretonRace)
		fDetectionWeight -= GetRaceWeight(DarkElfRace)
		fDetectionWeight -= GetRaceWeight(HighElfRace)
		fDetectionWeight -= GetRaceWeight(ImperialRace)
		fDetectionWeight -= GetRaceWeight(KhajiitRace)
		fDetectionWeight -= GetRaceWeight(NordRace)
		fDetectionWeight -= GetRaceWeight(OrcRace)
		fDetectionWeight -= GetRaceWeight(WoodElfRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(29))
	EndIf

	If Player.IsInFaction(dubhDisguiseFactions.GetAt(30) as Faction) ; Bandits
		fDetectionWeight += GetRaceWeight(ArgonianRace)
		fDetectionWeight += GetRaceWeight(BretonRace)
		fDetectionWeight += GetRaceWeight(DarkElfRace)
		fDetectionWeight += GetRaceWeight(ImperialRace)
		fDetectionWeight += GetRaceWeight(KhajiitRace)
		fDetectionWeight += GetRaceWeight(NordRace)
		fDetectionWeight += GetRaceWeight(OrcRace)
		fDetectionWeight += GetRaceWeight(RedguardRace)
		fDetectionWeight += GetRaceWeight(WoodElfRace)
		fDetectionWeight -= GetRaceWeight(HighElfRace)
		fDetectionWeight += GetEquipWeight(WhichSlotMasks(30))
	EndIf

	;If DisguiseFaction[31] != None
	;	If Player.IsInFaction(DisguiseFaction[31])
	;		fDetectionWeight += GetEquipWeight(WhichSlotMasks(31))
	;	EndIf
	;EndIf


	If fDetectionWeight > fDetectionMax
		Int fDetectionRoll = fDetectionMax as Int
		Return fDetectionRoll
	Else
		Int fDetectionRoll = ((fDetectionMax * fDetectionWeight) / 100) as Int
		Return fDetectionRoll
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Returns whether the player and NPC are in the requisite factions for
;     disguises to work correctly
; -----------------------------------------------------------------------------
Bool Function IsInDisguise(Faction factDisguise, Faction factBase)
	If Player.IsInFaction(factDisguise) && NPC.IsInFaction(factBase)
		If NPC.GetFactionRank(factBase) > -1
			Log("Player was in " + factDisguise + " and " + NPC + " was in " + factBase)
			Return True
		EndIf
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns whether the disguise has been activated
; -----------------------------------------------------------------------------
Bool Function IsDisguiseActive()
	Int iIndex = 0
	While iIndex < dubhDisguiseFactions.GetSize()
		Faction currentDisguise = dubhDisguiseFactions.GetAt(iIndex) as Faction
		If currentDisguise != None
			Faction currentBaseFaction = dubhBaseFactions.GetAt(iIndex) as Faction
			If IsInDisguise(currentDisguise, currentBaseFaction)
				;Log("IsDisguiseActive() returned True")
				Return True
			EndIf
		EndIf
		iIndex += 1
	EndWhile
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Returns the distant LOS penalty based on the min and max LOS distances
; -----------------------------------------------------------------------------
; akPenalty = GetDistantLOSPenalty(0.0, 512.0)
; Reminder: Penalty only affects skill contribution to identity score
; Note: The penalties "increase" from close to far because we multiply Value * Penalty (100 * 0.9 = 90)
Float Function GetDistantLOSPenalty(Float fLOSDistanceMin, Float fLOSDistanceMax)
	If (NPC.GetDistance(Player) >= fLOSDistanceMin) && (NPC.GetDistance(Player) < (fLOSDistanceMax / 4.0)) ; 0 - 512
		Return fDubhLOSPenaltyClearMin.GetValue()
	ElseIf (NPC.GetDistance(Player) >= (fLOSDistanceMax / 4.0)) && (NPC.GetDistance(Player) <= (fLOSDistanceMax / 2.0)) ; 512 - 1024
		Return fDubhLOSPenaltyDistanceMid.GetValue()
	ElseIf (NPC.GetDistance(Player) > (fLOSDistanceMax / 2.0)) && (NPC.GetDistance(Player) <= fLOSDistanceMax) ; 1024 - 2048
		Return fDubhLOSPenaltyDistanceFar.GetValue()
	EndIf
EndFunction

; -------------------------------------------------------------------------------
; Returns true or false after trying to make a detection roll
; -------------------------------------------------------------------------------
Bool Function TryToDiscoverPlayer()
	If NPC.HasLOS(Player)
		Float fPenalty = 1.0

		Float lightLevel = Player.GetLightLevel()
		Log("Player's light level set to: " + lightLevel + "%")

		Float minDistance = 0.0
		Float maxDistance = (fDubhLOSDistanceMax.GetValue() * (lightLevel / 100))
		Log("Max detection distance set to " + maxDistance + " units")

		Float maxHeadingAngle = (Game.GetGameSettingFloat("fDetectionViewCone") / 2.0) ; 60
		Float minHeadingAngle = -(maxHeadingAngle) ; -60
		Log("Cone of vision extends from " + minHeadingAngle + " to " + maxHeadingAngle + " degrees")

		Float maxHeadingAngleClr = (maxHeadingAngle / 4.0)	;  15
		Float minHeadingAngleClr = -(maxHeadingAngleClr)		; -15
		Float maxHeadingAngleDst = (maxHeadingAngleClr * 2)	;  30
		Float minHeadingAngleDst = -(maxHeadingAngleDst)		; -30

		If fDubhScriptSuspendTime.GetValue() > 0.0
			If (NPC.GetDistance(Player) >= minDistance) && (NPC.GetDistance(Player) <= maxDistance)
				If !Player.IsRunning() && !Player.IsSprinting() && !Player.IsSneaking() && !Player.IsWeaponDrawn()
					Log(NPC + " is watching the Player...")
					dubhDisguiseWarningSuspicious.Show()
					Suspend(fDubhScriptSuspendTime.GetValue())
					If !NPC.HasLOS(Player)
						Log("NPC lost line of sight to player after warning displayed. Skipping math.")
						Log("-------------------------------------------------------------------------------")
						Return False
					EndIf
				EndIf
			EndIf
		EndIf

		Float fHeadingAngle = NPC.GetHeadingAngle(Player)
		If fHeadingAngle >= minHeadingAngle && fHeadingAngle <= maxHeadingAngle
			Float fDistanceToPlayer = NPC.GetDistance(Player)
			If fDistanceToPlayer >= minDistance && fDistanceToPlayer <= maxDistance
				If fHeadingAngle >= minHeadingAngleClr && fHeadingAngle <= maxHeadingAngleClr
					Log(NPC + " has CLEAR line of sight to the Player: " + minHeadingAngleClr + " to " + maxHeadingAngleClr)
					fPenalty = GetDistantLOSPenalty(0.0, maxDistance)
					Log("LOS Penalty was " + fPenalty)
				ElseIf (fHeadingAngle >= minHeadingAngleDst) && (fHeadingAngle < minHeadingAngleClr) || (fHeadingAngle > maxHeadingAngleClr) && (fHeadingAngle <= maxHeadingAngleDst)
					Log(NPC + " has DISTORTED line of sight to the Player: " + minHeadingAngleDst + " to " + minHeadingAngleClr + " or " + maxHeadingAngleClr + " to " + maxHeadingAngleDst)
					fPenalty = GetDistantLOSPenalty(0.0, maxDistance)
					Log("LOS Penalty was " + fPenalty)
				ElseIf (fHeadingAngle >= minHeadingAngle) && (fHeadingAngle < minHeadingAngleDst) || (fHeadingAngle > maxHeadingAngleDst) && (fHeadingAngle <= maxHeadingAngle)
					Log(NPC + " has PERIPHERAL line of sight to the Player: " + minHeadingAngle + " to " + minHeadingAngleDst + " or " + maxHeadingAngleDst + " to " + maxHeadingAngle)
					fPenalty = GetDistantLOSPenalty(0.0, maxDistance)
					Log("LOS Penalty was " + fPenalty)
				Else
					fPenalty = 1.0
				EndIf

				If !NPC.HasLOS(Player)
					Log("NPC lost line of sight to player before detection roll. Skipping math.")
					Log("-------------------------------------------------------------------------------")
					Return False
				EndIf

				Log("Rolling for discovery against " + NPC)

				iRandomChance = Utility.RandomInt(0, 99) as Int
				iDetectionRoll = GetDetectionRoll(fPenalty) as Int

				Log("Player's base detection roll was " + iDetectionRoll)

				If Player.IsSprinting() || Player.IsSneaking() || Player.IsWeaponDrawn()
					iDetectionRoll = (iDetectionRoll * fDubhMobilityPenalty.GetValue()) as Int
				Else
					iDetectionRoll = (iDetectionRoll * fDubhMobilityBonus.GetValue()) as Int
				EndIf

				Log("Player's modified detection roll was " + iDetectionRoll)

				If iRandomChance > iDetectionRoll
					Log("Player lost detection roll: " + iDetectionRoll + " vs. " + iRandomChance)
					Log("-------------------------------------------------------------------------------")
					Return True
				Else
					Log("Player won detection roll: " + iDetectionRoll + " vs. " + iRandomChance)
					Log("-------------------------------------------------------------------------------")
					Return False
				EndIf
			Else
				Log(NPC + " lost line of sight because the Player is outside the NPC's range of sight.")
				Log("-------------------------------------------------------------------------------")
				Return False
			EndIf
		Else
			Log(NPC + " lost line of sight because the Player is outside the NPC's field of view.")
			Log("-------------------------------------------------------------------------------")
			Return False
		EndIf
	Else
		Return False
	EndIf
EndFunction

; ===============================================================================
; EVENTS
; ===============================================================================

Event OnEffectStart(Actor akTarget, Actor akCaster)
	NPC = akTarget
	If NPC.Is3DLoaded() && !NPC.IsDead()
		RegisterForSingleUpdate(fDubhScriptDetectionSpeed.GetValue())
		GoToState("Active")
	Else
		If NPC.RemoveSpell(dubhMonitorAbility)
			Log("Detached monitor from " + NPC + " because the NPC was not loaded and dead.")
		EndIf
	EndIf
EndEvent

Event OnCellDetach()
	If NPC.RemoveSpell(dubhMonitorAbility)
		Log("Detached monitor from " + NPC + " because the NPC's parent cell has been detached.")
	EndIf
EndEvent

Event OnDetachedFromCell()
	If NPC.RemoveSpell(dubhMonitorAbility)
		Log("Detached monitor from " + NPC + " because the NPC was detached from the cell.")
	EndIf
EndEvent

Event OnUnload()
	If NPC.RemoveSpell(dubhMonitorAbility)
		Log("Detached monitor from " + NPC + " because the NPC has been unloaded.")
	EndIf
EndEvent

State Active

	Event OnBeginState()
		If NPC.Is3DLoaded() && !NPC.IsDead()
			RegisterForSingleUpdate(fDubhScriptDetectionSpeed.GetValue())
		Else
			If NPC.RemoveSpell(dubhMonitorAbility)
				Log("Detached monitor from " + NPC + " because the NPC was not loaded and dead.")
			EndIf
		EndIf
	EndEvent

	Event OnUpdate()
		If NPC.IsDead()
			If NPC.RemoveSpell(dubhMonitorAbility)
				Log("Detached monitor from " + NPC + " because the NPC is dead.")
			EndIf
		EndIf

		; don't execute anything if the player has a menu open
		If !Utility.IsInMenuMode()
			; -----------------------------------------------------------------------
			; ERRANT HOSTILITY
			; -----------------------------------------------------------------------
			; no reason to call TryToDiscoverPlayer() if the actor is already hostile
			; -----------------------------------------------------------------------
			If !Player.IsDead() && !NPC.IsDead() && NPC.GetCombatTarget() == Player && !NPC.HasMagicEffect(dubhFactionEnemyEffect)
				; player and npc must be in an appropriate disguise/base faction pair
				If IsDisguiseActive()
					; restory bounty, if any
					;RestoreBounty(WhichGuardDisguise())
					; try to make the npc hostile
					If NPC.AddSpell(dubhFactionEnemyAbility)
						Log("Attached " + dubhFactionEnemyAbility + " to " + NPC + " due to unknown hostility")
					EndIf
				EndIf
			EndIf

			; -----------------------------------------------------------------------
			; CORE LOOP
			; -----------------------------------------------------------------------
			If !Player.IsDead() && !NPC.IsDead()
				; NPC must satisfy various conditions before running expensive loops and math calculations
				If !NPC.IsHostileToActor(Player) && !NPC.HasMagicEffect(dubhFactionEnemyEffect) && !NPC.IsInCombat() && NPC.HasLOS(Player) && Player.IsDetectedBy(NPC) && !NPC.IsAlerted() && !NPC.IsArrested() && !NPC.IsArrestingTarget() && !NPC.IsBleedingOut() && !NPC.IsCommandedActor() && !NPC.IsGhost() && !NPC.IsInKillMove() && !NPC.IsPlayerTeammate() && !NPC.IsTrespassing() && !NPC.IsUnconscious() && (NPC.GetSleepState() != 3) && (NPC.GetSleepState() != 4)
					; player and NPC must be in an appropriate disguise/base faction pair
					If IsDisguiseActive()
						; try to roll for detection
						If TryToDiscoverPlayer()
							; suspend for some amount of seconds, if global set
							If fDubhScriptSuspendTimeBeforeAttack.GetValue() > 0.0
								Suspend(fDubhScriptSuspendTimeBeforeAttack.GetValue())
							EndIf

							; ensure that the actor still has line of sight to the Player
							If NPC.HasLOS(Player)
								; restore bounty, if any
								;RestoreBounty(WhichGuardDisguise())
								; try to make the npc hostile
								If NPC.AddSpell(dubhFactionEnemyAbility)
									Log("Attached " + dubhFactionEnemyAbility + " to " + NPC + " who won detection roll")
								EndIf
							Else
								Log(NPC + " lost line of sight to Player. Detection roll discarded.")
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			; extra performance management
			Suspend(fDubhScriptDetectionSpeed.GetValue())
		EndIf

		If NPC.Is3DLoaded() && !NPC.IsDead()
			RegisterForSingleUpdate(fDubhScriptDetectionSpeed.GetValue())
		Else
			If NPC.RemoveSpell(dubhMonitorAbility)
				Log("Detached monitor from " + NPC + " because the NPC is not loaded and dead.")
			EndIf
		EndIf

		If !Player.IsDead() && !NPC.IsDead() && NPC.GetDistance(Player) > fDubhScriptDistanceMax.GetValue()
			If NPC.RemoveSpell(dubhMonitorAbility)
				Log("Detached monitor from " + NPC + " because the Player is too far away.")
			EndIf
		EndIf
	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		If (akAggressor == Player) && !IsExcludedDamageSource(akSource) && !Player.IsDead() && !NPC.IsDead() && !NPC.IsHostileToActor(Player) && !NPC.HasMagicEffect(dubhFactionEnemyEffect)
			Log(NPC + " was attacked by " + Player + " with " + akSource)
			;RestoreBounty(WhichGuardDisguise())
			NPC.StartCombat(Player)
			If NPC.AddSpell(dubhFactionEnemyAbility)
				Log("Attached " + dubhFactionEnemyAbility + " to " + NPC + " who was hit by " + akAggressor)
			EndIf
		EndIf
	EndEvent

	Event OnDeath(Actor akKiller)
		If NPC.RemoveSpell(dubhMonitorAbility)
			Log("Detached monitor from " + NPC + " because the NPC was killed by " + akKiller)
		EndIf
	EndEvent

EndState
