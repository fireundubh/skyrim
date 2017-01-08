ScriptName dubhPlayerScript Extends ReferenceAlias

; Globals
GlobalVariable Property iDubhScriptDebugMonitor Auto
GlobalVariable Property dubhCloakEffectOn Auto

; Actor Data
Actor Property Player Auto

; Abilities
Spell Property dubhCloakAbility Auto

; -----------------------------------------------------------------------------
; Sends a message to the Papyrus log
; -----------------------------------------------------------------------------
Function Log(String msgTrace)
	If iDubhScriptDebugMonitor.GetValueInt() == 1
		Debug.Trace("Master of Disguise: PlayerScript> " + msgTrace)
	EndIf
EndFunction

Event OnInit()
	RegisterForSingleUpdate(1.0)
EndEvent

Event OnCellLoad()
	RegisterForSingleUpdate(1.0)
EndEvent

Event OnUpdate()
	If dubhCloakEffectOn.GetValue()
		;Log("Adding cloak ability to player...")
		If !Player.HasSpell(dubhCloakAbility)
			Player.AddSpell(dubhCloakAbility, false)
			Utility.Wait(1.0)
			Player.RemoveSpell(dubhCloakAbility)
		EndIf
	EndIf
	RegisterForSingleUpdate(4.0)
EndEvent
