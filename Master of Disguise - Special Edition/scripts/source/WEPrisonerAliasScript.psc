ScriptName WEPrisonerAliasScript Extends ReferenceAlias
{This script pops a message box when activating the prisoner. If freed by player, adds factions to produce conflict. Captors must have aggression high enough to attack enemies.}

Topic Property WESharedDialoguePrisonerSetFree Auto

Idle Property OffsetBoundStandingStart Auto
Idle Property OffsetStop  Auto

Message Property WEPrisonerMessageBox Auto
Faction Property WEPrisonerFreedFaction Auto

Faction Property WEPrisonerFreedCombatCaptorFaction Auto
Faction Property WEPrisonerFreedCombatPrisonerFaction Auto

ReferenceAlias Property Captor1 Auto
ReferenceAlias Property Captor2 Auto
ReferenceAlias Property Captor3 Auto
ReferenceAlias Property Captor4 Auto
ReferenceAlias Property Captor5 Auto

; Master of Disguise
Faction Property CWSonsFaction Auto

Bool bound = True

Int iDoNothing = 0
Int iSetFree = 1
Int iSetFreeShareItems = 2

; -----------------------------------------------------------------------------
; Outputs message to Papyrus log with script name
; -----------------------------------------------------------------------------
Function Log(String traceMessage)
	Debug.Trace("WEPrisonerAliasScript> " + traceMessage)
EndFunction

; -----------------------------------------------------------------------------
; When the prisoner is loaded
; -----------------------------------------------------------------------------
Event OnLoad()
	If bound
		GetActorReference().PlayIdle(OffsetBoundStandingStart)
	EndIf
EndEvent

; -----------------------------------------------------------------------------
; When the prisoner is activated
; -----------------------------------------------------------------------------
Event OnActivate(ObjectReference akActionRef)
	If GetActorReference().IsDead() || GetActorReference().IsInCombat()
		; do nothing
	ElseIf bound == True
		Actor ActorRef = GetActorReference()
		Int result = WEPrisonerMessageBox.Show()

		If result == iDoNothing
			; Debug.Notification("DO NOTHING")
		ElseIf result == iSetFree
			; Debug.Notification("SET FREE")
			FreePrisoner(ActorRef, OpenInventory = False)
		ElseIf result == iSetFreeShareItems
			; Debug.Notification("SET FREE SHARE ITEMS")
			FreePrisoner(ActorRef, OpenInventory = True)
		EndIf
	EndIf
EndEvent

; -----------------------------------------------------------------------------
; When the prisoner is hit by the player
; -----------------------------------------------------------------------------
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
	If akAggressor == Game.GetPlayer()
		Game.GetPlayer().AddToFaction(WEPrisonerFreedCombatPrisonerFaction)
		; Validate properties added by USKP 1.2.6 because they were throwing Papyrus errors and aborting the function.
		If (Captor1)
			Captor1.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
		EndIf
		If (Captor2)
			Captor2.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
		EndIf
		If (Captor3)
			Captor3.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
		EndIf
		If (Captor4)
			Captor4.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
		endif
		If (Captor5)
			Captor5.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
		EndIf
	EndIf
EndEvent

; -----------------------------------------------------------------------------
; Sets the prisoner free
; -----------------------------------------------------------------------------
Function FreePrisoner(Actor ActorRef, Bool playerIsLiberator = True, Bool OpenInventory = False)
	; Log(self + "FreePrisoner(" + ActorRef + "," + playerIsLiberator + ", " + OpenInventory +")")

	; Master of Disguise
	; 	Adds prisoner to Stormcloaks faction if rank below zero
	If (ActorRef.GetFactionRank(CWSonsFaction) < 0)
		ActorRef.SetFactionRank(CWSonsFaction, 0)
	EndIf

	ActorRef.AddToFaction(WEPrisonerFreedFaction)
	ActorRef.AddToFaction(WEPrisonerFreedCombatPrisonerFaction)
	ActorRef.EvaluatePackage()
	ActorRef.PlayIdle(OffsetStop) ; USKP 2.0.1 - The property is defined for this purpose but was never used. Free his hands!

	If playerIsLiberator
		Game.GetPlayer().AddToFaction(WEPrisonerFreedCombatPrisonerFaction)
	EndIf

	If OpenInventory
		ActorRef.OpenInventory(True)
	EndIf

	ActorRef.Say(WESharedDialoguePrisonerSetFree)
	bound = False

	; Validate properties added by USKP 1.2.6 because they were throwing Papyrus errors and aborting the function.
	If (Captor1)
		Captor1.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf

	If (Captor2)
		Captor2.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf

	If (Captor3)
		Captor3.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf

	If (Captor4)
		Captor4.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf

	If (Captor5)
		Captor5.TryToAddToFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf

	ActorRef.EvaluatePackage()
EndFunction

; -----------------------------------------------------------------------------
; Clears factions when the quest shuts down
; -----------------------------------------------------------------------------
Function ClearFactions()
	; Log(self + "FreePrisoner")
	Game.GetPlayer().RemoveFromFaction(WEPrisonerFreedCombatPrisonerFaction)
	TryToRemoveFromFaction(WEPrisonerFreedCombatCaptorFaction)

	; Validate properties added by USKP 1.2.6 because they were throwing Papyrus errors and aborting the function.
	If (Captor1)
		Captor1.TryToRemoveFromFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf

	If (Captor2)
		Captor2.TryToRemoveFromFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf

	If (Captor3)
		Captor3.TryToRemoveFromFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf

	If (Captor4)
		Captor4.TryToRemoveFromFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf

	If (Captor5)
		Captor5.TryToRemoveFromFaction(WEPrisonerFreedCombatCaptorFaction)
	EndIf
EndFunction