ScriptName JailDoorScript Extends ObjectReference
{creates detection event when opened by player}

Event OnActivate(ObjectReference akActionRef)
	Actor npcActivator = akActionRef as Actor
	Key doorKey = self.GetKey()

	; 0 Lockpicking = 100 lock noise, 100 Lockpicking = 0 lock noise
	Int iSoundLevel = 100 - npcActivator.GetActorValue("Lockpicking") as Int

	; cap Lockpicking constant to 100
	If iSoundLevel < 0
		iSoundLevel = 0
	EndIf

	; reduce noise to 0 if the actor has the key
	If npcActivator.GetItemCount(doorKey) > 0
		iSoundLevel = 0
	EndIf

	; create the detection event only when there's noise to be made
	If iSoundLevel > 0
		CreateDetectionEvent(npcActivator, iSoundLevel)
	EndIf
EndEvent

Int Property SoundLevel = 25 Auto ; not used
