ScriptName dubhFactionEnemyScript Extends ActiveMagicEffect

; Debug
GlobalVariable Property iDubhScriptDebugEnemy Auto

; Globals
GlobalVariable Property fDubhScriptDistanceMax Auto
GlobalVariable Property fDubhEscapeDistance Auto

; Actor Data
Actor Property Player Auto
Actor NPC

; Spell Data
Spell Property dubhFactionEnemyAbility Auto

; Factions
Formlist Property dubhBaseFactions Auto
Formlist Property dubhDisguiseFactions Auto
Formlist Property dubhExcludedDamageSources Auto

; States
Bool[] Property DisguiseRemoved Auto

; -----------------------------------------------------------------------------
; Sends a message to the Papyrus log
; -----------------------------------------------------------------------------
Function Log(String msgTrace)
	If iDubhScriptDebugEnemy.GetValueInt() == 1
		Debug.Trace("Master of Disguise: FactionEnemyScript> " + msgTrace)
	EndIf
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
; Returns TRUE if the player is in the specified faction
; -----------------------------------------------------------------------------
Bool Function IsActorMember(Actor npcActor, Faction factFaction)
	If npcActor.IsInFaction(factFaction)
		If npcActor.GetFactionRank(factFaction) > -1
			Return True
		EndIf
	EndIf
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Restores previously removed disguises to player
; -----------------------------------------------------------------------------
Function AddDisguisesToPlayer()
	If !Player.IsDead()
		Int iIndex = 0
		While iIndex < DisguiseRemoved.Length
			Faction currentDisguiseFaction = dubhDisguiseFactions.GetAt(iIndex) as Faction
			If DisguiseRemoved[iIndex]
				Player.AddToFaction(currentDisguiseFaction)
				DisguiseRemoved[iIndex] = False
				Log("Added disguise to player: " + currentDisguiseFaction)
			EndIf
			iIndex += 1
		EndWhile
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Removes disguises from player
; -----------------------------------------------------------------------------
Function RemoveDisguisesFromPlayer()
	If !Player.IsDead()
		Int iIndex = 0
		While iIndex < dubhDisguiseFactions.GetSize()
			Faction currentDisguiseFaction = dubhDisguiseFactions.GetAt(iIndex) as Faction
			If !DisguiseRemoved[iIndex] && IsMember(currentDisguiseFaction)
				Player.RemoveFromFaction(currentDisguiseFaction)
				DisguiseRemoved[iIndex] = True
				Log("Removed disguise from player: " + currentDisguiseFaction)
			EndIf
			iIndex += 1
		EndWhile
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Restore disguised state
; -----------------------------------------------------------------------------
Function RestoreDisguisedState(String logText)
	If NPC.HasSpell(dubhFactionEnemyAbility)
		AddDisguisesToPlayer()
		If NPC.RemoveSpell(dubhFactionEnemyAbility)
			Log(logText)
		EndIf
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Suspends the script from processing for some number of seconds
; -----------------------------------------------------------------------------
Function Suspend(Float fSeconds)
	Float fTime = Utility.GetCurrentRealTime()
	Float fTimeGoal = (Utility.GetCurrentRealTime() + fSeconds)
	While fTime < fTimeGoal
		fTime = Utility.GetCurrentRealTime()
	EndWhile
EndFunction


Event OnEffectStart(Actor akTarget, Actor akCaster)
	NPC = akCaster

	If NPC.GetDistance(Player) <= fDubhScriptDistanceMax.GetValue()
		RemoveDisguisesFromPlayer()

		NPC.EvaluatePackage()

		If NPC.IsHostileToActor(Player)
			If !NPC.IsAlerted()
				NPC.SetAlert(true)
			EndIf
			If !NPC.IsWeaponDrawn()
				NPC.DrawWeapon()
			EndIf
			Game.ShakeCamera(afStrength = 0.4)
			NPC.EvaluatePackage()
		EndIf

		Suspend(5.0)
	EndIf

	If NPC.Is3DLoaded() && !NPC.IsDead()
		GoToState("Alive")
	ElseIf Player.IsDead()
		If NPC.RemoveSpell(dubhFactionEnemyAbility)
			Log("Detached enemy marker from " + NPC + " because the Player was prematurely dead. [1]")
		EndIf
	Else
		RestoreDisguisedState("Detached enemy marker from " + NPC + " because the NPC was either not loaded or dead. [2]")
	EndIf
EndEvent

Event OnCellDetach()
	RestoreDisguisedState("Detached enemy marker from " + NPC + " because the NPC's parent cell has been detached. [3]")
EndEvent

Event OnDetachedFromCell()
	RestoreDisguisedState("Detached enemy marker from " + NPC + " because the NPC was detached from the cell. [4]")
EndEvent

Event OnUnload()
	RestoreDisguisedState("Detached enemy marker from " + NPC + " because the NPC has been unloaded. [5]")
EndEvent

State Alive

	Event OnBeginState()
		RegisterForSingleUpdate(1.0)
	EndEvent

	Event OnUpdate()
		If Player.IsDead()
			If NPC.RemoveSpell(dubhFactionEnemyAbility)
				Log("Detached enemy marker from " + NPC + " because the Player died. [6]")
			EndIf
		ElseIf NPC.IsDead()
			RestoreDisguisedState("Detached enemy marker from " + NPC + " because the NPC was dead. [7]")
		ElseIf NPC.IsHostileToActor(Player) && NPC.GetDistance(Player) >= fDubhEscapeDistance.GetValue()
			RestoreDisguisedState("Detached enemy marker from " + NPC + " because the Player escaped. [8]")
		ElseIf !NPC.IsHostileToActor(Player)
			RestoreDisguisedState("Detached enemy marker from " + NPC + " because the NPC was no longer hostile. [9]")
		ElseIf !NPC.IsDead() && NPC.IsHostileToActor(Player)
			RegisterForSingleUpdate(1.0)
		EndIf
	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		If (akAggressor == Player) && !IsExcludedDamageSource(akSource) && !NPC.IsDead() && !NPC.IsHostileToActor(Player)
			Log("NPC was attacked. Trying to start combat.")
			NPC.StartCombat(Player)
		EndIf
	EndEvent

	Event OnDeath(Actor akKiller)
		RestoreDisguisedState("Detached enemy marker from " + NPC + " because the NPC was killed by " + akKiller + " [10]")
	EndEvent

	Event OnEffectFinish(Actor akTarget, Actor akCaster)
		RestoreDisguisedState("Detached enemy marker from " + NPC + " because the effect finished. [11]")
	EndEvent

EndState

State Dead
EndState