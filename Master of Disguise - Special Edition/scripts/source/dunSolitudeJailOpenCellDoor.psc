Scriptname dunSolitudeJailOpenCellDoor extends ObjectReference

ObjectReference property LightEnableMarker auto
ObjectReference property EscapeManagerMarker auto
ObjectReference property EscapeTriggerDoor auto

Event OnActivate(ObjectReference obj)
	PlayAnimation("OpenStart")
	CreateDetectionEvent(Game.GetPlayer(), 80)
	LightEnableMarker.Enable()
	EscapeManagerMarker.Enable()
	EscapeTriggerDoor.Activate(Game.GetPlayer())
EndEvent