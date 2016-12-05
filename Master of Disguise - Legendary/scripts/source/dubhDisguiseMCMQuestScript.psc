ScriptName dubhDisguiseMCMQuestScript extends dubhDisguiseMCMHelper

String ModName

Actor Property Player Auto

Quest Property dubhDisguiseQuest Auto
Quest Property dubhDetectionQuest Auto

; Globals
GlobalVariable Property fDetectionViewCone Auto
GlobalVariable Property fDubhBountyPenaltyMult Auto
GlobalVariable Property fDubhBestSkillContribMax Auto
GlobalVariable Property fDubhEscapeDistance Auto
GlobalVariable Property fDubhLOSDistanceMax Auto
GlobalVariable Property fDubhLOSPenaltyClearMin Auto
GlobalVariable Property fDubhLOSPenaltyDistanceFar Auto
GlobalVariable Property fDubhLOSPenaltyDistanceMid Auto
GlobalVariable Property fDubhLOSPenaltyDistortedMin Auto
GlobalVariable Property fDubhLOSPenaltyPeripheralMin Auto
GlobalVariable Property fDubhMobilityBonus Auto
GlobalVariable Property fDubhMobilityPenalty Auto

; Globals - Script
GlobalVariable Property fDubhScriptDetectionSpeed Auto
GlobalVariable Property fDubhScriptDisguiseSpeed Auto
GlobalVariable Property fDubhScriptDistanceMax Auto
GlobalVariable Property fDubhScriptSuspendTime Auto
GlobalVariable Property fDubhScriptSuspendTimeBeforeAttack Auto

; Globals - Race Scores
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

; Globals - Equipment Scores
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

; Globals - Debug
GlobalVariable Property iDubhScriptDebugDisguise Auto
GlobalVariable Property iDubhScriptDebugEnemy Auto
GlobalVariable Property iDubhScriptDebugMonitor Auto
GlobalVariable Property	iDubhDetectionEnabled Auto
GlobalVariable Property iDubhAlwaysSucceedDremora Auto
GlobalVariable Property iDubhAlwaysSucceedWerewolves Auto

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

; Formlists
Formlist Property dubhBaseFactions Auto
Formlist Property dubhDisguiseFactions Auto
Formlist Property dubhGuardFactions Auto
Formlist Property dubhExcludedDisguises Auto
Formlist Property dubhTrackedBounties Auto

; Bools
;Bool bUninstalled = False
Bool bDisguiseSystem = True
Bool bDetectionSystem = True
Bool bBanditDisguise = True
Bool bGuardsVsDarkBrotherhood = False
Bool bGuardsVsThievesGuild = False

Event OnConfigInit()
	Pages = new String[6]
	Pages[0] = "$dubhPageInformation"
	Pages[1] = "$dubhPageDetection"
	Pages[2] = "$dubhPageScoring"
	Pages[3] = "$dubhPageRace"
	Pages[4] = "$dubhPageCrime"
	Pages[5] = "$dubhPageAdvanced"
EndEvent

Event OnPageReset(String page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	Int iOID

	If page == ""
		LoadCustomContent("dubhDisguiseLogo.dds")
		Return
	Else
		UnloadCustomContent()
	EndIf

	If page == "$dubhPageInformation"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$dubhHeadingAccolades")
		DefineMCMParagraph("$dubhAccoladesText01")
		DefineMCMParagraph("$dubhAccoladesText02")
		DefineMCMParagraph("$dubhAccoladesText03")
		DefineMCMParagraph("$dubhAccoladesText04")
		DefineMCMParagraph("$dubhAccoladesText05")
		DefineMCMParagraph("$dubhAccoladesText06")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingCredits")
		DefineMCMParagraph("$dubhCredits01")
		DefineMCMParagraph("$dubhCredits02")
		DefineMCMParagraph("$dubhCredits03")

		SetCursorPosition(1)

		AddHeaderOption("$dubhHeadingSupport")

		DefineMCMParagraph("$dubhSupportText01")
		DefineMCMParagraph("$dubhSupportText02")
		DefineMCMParagraph("$dubhSupportText03")

		AddEmptyOption()

		DefineMCMParagraph("$dubhSupportText04")
		DefineMCMParagraph("$dubhSupportText05")
		DefineMCMParagraph("$dubhSupportText06")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingPermissions")
		DefineMCMParagraph("$dubhPermissions01")
		DefineMCMParagraph("$dubhPermissions02")

	ElseIf page == "$dubhPageDetection"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$dubhHeadingFov")
		DefineMCMSliderOptionGlobal("$dubhFovDiameter", fDetectionViewCone, fDetectionViewCone.GetValue(), 30.0, 360.0, 5.0, "$dubhHelpFovDiameter", "{2}")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingLosDistance")
		DefineMCMSliderOptionGlobal("$dubhLosMaxDistance", fDubhLOSDistanceMax, fDubhLOSDistanceMax.GetValue(), 1024.0, fDubhScriptDistanceMax.GetValue(), 256.0, "$dubhHelpLosMaxDistance", "{2}")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingLosPenalties")
		DefineMCMSliderOptionGlobal("$dubhLosDistanceClear", 			fDubhLOSPenaltyClearMin, 			fDubhLOSPenaltyClearMin.GetValue(), 			0.0, 1.0, 0.05, "$dubhHelpLosDistanceClear", "{2}")
		DefineMCMSliderOptionGlobal("$dubhLosDistanceDistorted", 	fDubhLOSPenaltyDistortedMin, 	fDubhLOSPenaltyDistortedMin.GetValue(), 	0.0, 1.0, 0.05, "$dubhHelpLosDistanceDistorted", "{2}")
		DefineMCMSliderOptionGlobal("$dubhLosDistancePeripheral", fDubhLOSPenaltyPeripheralMin, fDubhLOSPenaltyPeripheralMin.GetValue(), 	0.0, 1.0, 0.05, "$dubhHelpLosDistancePeripheral", "{2}")

		SetCursorPosition(1)

		AddHeaderOption("$dubhHeadingDetection")
		DefineMCMToggleOptionGlobal("$dubhDetectionDremoraToggle", iDubhAlwaysSucceedDremora, 0, "$dubhHelpDetectionDremoraToggle")
		DefineMCMToggleOptionGlobal("$dubhDetectionWerewolvesToggle", iDubhAlwaysSucceedWerewolves, 0, "$dubhHelpDetectionWerewolvesToggle")

	ElseIf page == "$dubhPageScoring"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$dubhHeadingBestSkill")
		DefineMCMSliderOptionGlobal("$dubhBestSkillMax", fDubhBestSkillContribMax, fDubhBestSkillContribMax.GetValue(), 0.0, 100.0, 10.0, "$dubhHelpBestSkillMax", "{2}")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingMobility")
		DefineMCMSliderOptionGlobal("$dubhMobilityBonus", 		fDubhMobilityBonus, 	fDubhMobilityBonus.GetValue(), 		1.0, 1.5, 0.05, "$dubhHelpMobilityBonus", "{2}")
		DefineMCMSliderOptionGlobal("$dubhMobilityPenalty", 	fDubhMobilityPenalty, fDubhMobilityPenalty.GetValue(), 	0.5, 1.0, 0.05,	"$dubhHelpMobilityPenalty", "{2}")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingWeapons")
		DefineMCMSliderOptionGlobal("$dubhWeaponsHandLeft", 	fDubhSlotWeaponLeft, 	fDubhSlotWeaponLeft.GetValue(), 	0.0, 100.0, 1.0,	"$dubhHelpWeaponsHandLeft", "{2}")
		DefineMCMSliderOptionGlobal("$dubhWeaponsHandRight", 	fDubhSlotWeaponRight, fDubhSlotWeaponRight.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpWeaponsHandRight", "{2}")

		SetCursorPosition(1)

		AddHeaderOption("$dubhHeadingEquipment")
		DefineMCMSliderOptionGlobal("$dubhEquipmentAmulet", 	fDubhSlotAmulet, 	fDubhSlotAmulet.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpEquipmentAmulet", "{2}")
		DefineMCMSliderOptionGlobal("$dubhEquipmentBody", 		fDubhSlotBody, 		fDubhSlotBody.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpEquipmentBody", "{2}")
		DefineMCMSliderOptionGlobal("$dubhEquipmentCirclet", 	fDubhSlotCirclet, fDubhSlotCirclet.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpEquipmentCirclet", "{2}")
		DefineMCMSliderOptionGlobal("$dubhEquipmentFeet", 		fDubhSlotFeet, 		fDubhSlotFeet.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpEquipmentFeet", "{2}")
		DefineMCMSliderOptionGlobal("$dubhEquipmentHair", 		fDubhSlotHair, 		fDubhSlotHair.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpEquipmentHair", "{2}")
		DefineMCMSliderOptionGlobal("$dubhEquipmentHands", 		fDubhSlotHands, 	fDubhSlotHands.GetValue(),		0.0, 100.0, 1.0, 	"$dubhHelpEquipmentHands", "{2}")
		DefineMCMSliderOptionGlobal("$dubhEquipmentRing", 		fDubhSlotRing, 		fDubhSlotRing.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpEquipmentRing", "{2}")
		DefineMCMSliderOptionGlobal("$dubhEquipmentShield",		fDubhSlotShield,	fDubhSlotShield.GetValue(),		0.0, 100.0, 1.0,	"$dubhHelpEquipmentShield", "{2}")

	ElseIf page == "$dubhPageRace"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$dubhHeadingRaceModifiers1")
		DefineMCMSliderOptionGlobal("$dubhRaceAltmer", 		fDubhRaceHighElf, 	fDubhRaceHighElf.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpRaceAltmer", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceArgonian", 	fDubhRaceArgonian, 	fDubhRaceArgonian.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpRaceArgonian", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceBosmer", 		fDubhRaceWoodElf, 	fDubhRaceWoodElf.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpRaceBosmer", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceBreton", 		fDubhRaceBreton, 		fDubhRaceBreton.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpRaceBreton", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceDunmer", 		fDubhRaceDarkElf, 	fDubhRaceDarkElf.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpRaceDunmer", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceImperial", 	fDubhRaceImperial, 	fDubhRaceImperial.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpRaceImperial", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceKhajiit", 	fDubhRaceKhajiit, 	fDubhRaceKhajiit.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpRaceKhajiit", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceNord", 			fDubhRaceNord, 			fDubhRaceNord.GetValue(), 			0.0, 100.0, 1.0, 	"$dubhHelpRaceNord", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceOrc", 			fDubhRaceOrc, 			fDubhRaceOrc.GetValue(), 				0.0, 100.0, 1.0, 	"$dubhHelpRaceOrc", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceRedguard", 	fDubhRaceRedguard, 	fDubhRaceRedguard.GetValue(),		0.0, 100.0, 1.0,	"$dubhHelpRaceRedguard", "{2}")

		SetCursorPosition(1)

		AddHeaderOption("$dubhHeadingRaceModifiers2")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireAltmer", 	fDubhRaceHighElfVampire, 	fDubhRaceHighElfVampire.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpRaceVampireAltmer", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireArgonian", fDubhRaceArgonianVampire, fDubhRaceArgonianVampire.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpRaceVampireArgonian", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireBosmer", 	fDubhRaceWoodElfVampire, 	fDubhRaceWoodElfVampire.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpRaceVampireBosmer", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireBreton", 	fDubhRaceBretonVampire, 	fDubhRaceBretonVampire.GetValue(), 		0.0, 100.0, 1.0, 	"$dubhHelpRaceVampireBreton", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireDunmer", 	fDubhRaceDarkElfVampire, 	fDubhRaceDarkElfVampire.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpRaceVampireDunmer", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireImperial", fDubhRaceImperialVampire, fDubhRaceImperialVampire.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpRaceVampireImperial", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireKhajiit", 	fDubhRaceKhajiitVampire, 	fDubhRaceKhajiitVampire.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpRaceVampireKhajiit", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireNord", 		fDubhRaceNordVampire, 		fDubhRaceNordVampire.GetValue(), 			0.0, 100.0, 1.0, 	"$dubhHelpRaceVampireNord", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireOrc", 			fDubhRaceOrcVampire, 			fDubhRaceOrcVampire.GetValue(), 			0.0, 100.0, 1.0,	"$dubhHelpRaceVampireOrc", "{2}")
		DefineMCMSliderOptionGlobal("$dubhRaceVampireRedguard", fDubhRaceRedguardVampire, fDubhRaceRedguardVampire.GetValue(), 	0.0, 100.0, 1.0, 	"$dubhHelpRaceVampireRedguard", "{2}")

	ElseIf page == "$dubhPageCrime"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$dubhHeadingBountyPenalty")
		DefineMCMSliderOptionGlobal("$dubhBountyPenaltyMult", fDubhBountyPenaltyMult, fDubhBountyPenaltyMult.GetValue(), 0.0, 1.0, 0.01, "$dubhHelpBountyPenaltyMult", "{2}")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingToggles")
		RegisterForModEvent("dubhToggleDisguiseBandit", "OnBooleanToggleClick")
		DefineMCMToggleOption("$dubhLabelToggleDisguiseBandit", bBanditDisguise, 0, "$dubhHelpToggleDisguiseBandit", "dubhToggleDisguiseBandit")

		RegisterForModEvent("dubhToggleGuardsVsDarkBrotherhood", "OnBooleanToggleClick")
		DefineMCMToggleOption("$dubhLabelToggleGuardsVsDarkBrotherhood", bGuardsVsDarkBrotherhood,	0, "$dubhHelpToggleGuardsVsDarkBrotherhood", "dubhToggleGuardsVsDarkBrotherhood")

		RegisterForModEvent("dubhToggleGuardsVsThievesGuild", "OnBooleanToggleClick")
		DefineMCMToggleOption("$dubhLabelToggleGuardsVsThievesGuild", bGuardsVsThievesGuild, 0, "$dubhHelpToggleGuardsVsThievesGuild", "dubhToggleGuardsVsThievesGuild")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingBountyBoardShort")
		DefineMCMSliderOptionGlobal("$dubhCrimeImperial", 		iDubhCrimeImperial, 		iDubhCrimeImperial.GetValue(), 		0.0, 99999.0, 1.0, "$dubhHelpCrimeImperial", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimeStormcloaks",	iDubhCrimeStormcloaks, 	iDubhCrimeStormcloaks.GetValue(), 0.0, 99999.0, 1.0, "$dubhHelpCrimeStormcloaks", "{2}", 1)

		SetCursorPosition(1)

		AddHeaderOption("$dubhHeadingBountyBoardLong")
		DefineMCMSliderOptionGlobal("$dubhCrimeFalkreath", 		iDubhCrimeFalkreath, 		iDubhCrimeFalkreath.GetValue(), 	0.0, 99999.0, 1.0, "$dubhHelpCrimeFalkreath", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimeHjaalmarch", 	iDubhCrimeHjaalmarch,		iDubhCrimeHjaalmarch.GetValue(), 	0.0, 99999.0, 1.0, "$dubhHelpCrimeHjaalmarch", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimeMarkarth", 		iDubhCrimeMarkarth,			iDubhCrimeMarkarth.GetValue(),		0.0, 99999.0, 1.0, "$dubhHelpCrimeMarkarth", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimePale", 				iDubhCrimePale, 				iDubhCrimePale.GetValue(), 				0.0, 99999.0, 1.0, "$dubhHelpCrimePale", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimeRavenRock", 		iDubhCrimeRavenRock, 		iDubhCrimeRavenRock.GetValue(), 	0.0, 99999.0, 1.0, "$dubhHelpCrimeRavenRock", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimeRiften", 			iDubhCrimeRiften, 			iDubhCrimeRiften.GetValue(), 			0.0, 99999.0, 1.0, "$dubhHelpCrimeRiften", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimeSolitude", 		iDubhCrimeSolitude, 		iDubhCrimeSolitude.GetValue(), 		0.0, 99999.0, 1.0, "$dubhHelpCrimeSolitude", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimeWhiterun", 		iDubhCrimeWhiterun, 		iDubhCrimeWhiterun.GetValue(), 		0.0, 99999.0, 1.0, "$dubhHelpCrimeWhiterun", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimeWindhelm", 		iDubhCrimeWindhelm, 		iDubhCrimeWindhelm.GetValue(), 		0.0, 99999.0, 1.0, "$dubhHelpCrimeWindhelm", "{2}", 1)
		DefineMCMSliderOptionGlobal("$dubhCrimeWinterhold", 	iDubhCrimeWinterhold, 	iDubhCrimeWinterhold.GetValue(), 	0.0, 99999.0, 1.0, "$dubhHelpCrimeWinterhold", "{2}", 1)

	ElseIf page == "$dubhPageAdvanced"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$dubhHeadingWatchRate")
		DefineMCMSliderOptionGlobal("$dubhWatchRateSeconds", fDubhScriptSuspendTime, fDubhScriptSuspendTime.GetValue(), 0.0, 60.0, 1.0, "$dubhHelpWatchRate", "{2}")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingPerfDisguise")
		DefineMCMSliderOptionGlobal("$dubhPerfUpdateRate",		fDubhScriptDisguiseSpeed, fDubhScriptDisguiseSpeed.GetValue(), 0.0, 10.0, 1.0, "$dubhHelpPerfDisguiseUpdateRate", "{2}")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingPerfDetection")
		DefineMCMSliderOptionGlobal("$dubhPerfDetectionDistanceMax",	fDubhScriptDistanceMax,			fDubhScriptDistanceMax.GetValue(), 		0.0, fDubhEscapeDistance.GetValue(), 	256.0, 	"$dubhHelpPerfDetectionDistanceMax", "{2}")
		DefineMCMSliderOptionGlobal("$dubhPerfUpdateRate",						fDubhScriptDetectionSpeed, 	fDubhScriptDetectionSpeed.GetValue(), 0.0, 10.0, 														1.0, 		"$dubhHelpPerfDetectionUpdateRate", "{2}")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingPerfEnemies")
		DefineMCMSliderOptionGlobal("$dubhPerfEnemiesEscapeDistance", fDubhEscapeDistance, fDubhEscapeDistance.GetValue(), fDubhScriptDistanceMax.GetValue(), 8192.0, 256.0, "$dubhHelpPerfEnemiesEscapeDistance", "{2}")

		SetCursorPosition(1)

		AddHeaderOption("$dubhHeadingCombatDelay")
		DefineMCMSliderOptionGlobal("$dubhCombatDelaySeconds", fDubhScriptSuspendTimeBeforeAttack, fDubhScriptSuspendTimeBeforeAttack.GetValue(), 0.0, 60.0, 1.0, "$dubhHelpCombatDelay", "{2}")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingDebug")
		DefineMCMToggleOptionGlobal("$dubhDebugDetection", iDubhScriptDebugMonitor, 0, "$dubhHelpDebugDetection")
		DefineMCMToggleOptionGlobal("$dubhDebugDisguises", iDubhScriptDebugDisguise, 0, "$dubhHelpDebugDisguises")
		DefineMCMToggleOptionGlobal("$dubhDebugEnemies", iDubhScriptDebugEnemy, 0, "$dubhHelpDebugEnemies")

		AddEmptyOption()

		AddHeaderOption("$dubhHeadingSetup")
		RegisterForModEvent("dubhToggleDisguiseSystem", "OnBooleanToggleClick")
		DefineMCMToggleOption("$dubhLabelToggleDisguiseSystem", bDisguiseSystem, 0, "$dubhHelpToggleDisguiseSystem", "dubhToggleDisguiseSystem")

		RegisterForModEvent("dubhToggleDetectionSystem", "OnBooleanToggleClick")
		DefineMCMToggleOption("$dubhLabelToggleDetectionSystem", bDetectionSystem, 0, "$dubhHelpToggleDetectionSystem", "dubhToggleDetectionSystem")

		;RegisterForModEvent("dubhUninstall", "OnBooleanToggleClick")
		;DefineMCMToggleOption("$dubhLabelUninstall", bUninstalled, 0, "$dubhHelpUninstall", "dubhUninstall")
	EndIf
EndEvent

; -----------------------------------------------------------------------------
; Sends a message to the Papyrus log
; -----------------------------------------------------------------------------
Function Log(String msgTrace)
	If iDubhScriptDebugDisguise.GetValueInt() == 1
		Debug.Trace("Master of Disguise: MCM> " + msgTrace)
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; Removes player from all disguise factions
; -----------------------------------------------------------------------------
Bool Function ClearDisguiseFactions()
	Int iIndex = 0
	While iIndex < dubhDisguiseFactions.GetSize()
		Faction currentDisguiseFaction = dubhDisguiseFactions.GetAt(iIndex) as Faction
		If Player.IsInFaction(currentDisguiseFaction)
			Player.RemoveFromFaction(currentDisguiseFaction)
		EndIf
		iIndex += 1
	EndWhile
	Log("Removed the player from all disguise factions.")
	Return True
EndFunction

; -----------------------------------------------------------------------------
; Clears all tracked bounty globals
; -----------------------------------------------------------------------------
Bool Function ClearTrackedBounties()
	Int iIndex = 0
	While iIndex < dubhTrackedBounties.GetSize()
		GlobalVariable currentTrackedBounty = dubhTrackedBounties.GetAt(iIndex) as GlobalVariable
		If currentTrackedBounty.GetValueInt() > 0
			currentTrackedBounty.SetValueInt(0)
		EndIf
		iIndex += 1
	EndWhile
	Log("Cleared all tracked bounty global variables.")
	Return True
EndFunction

; -----------------------------------------------------------------------------
; Sets relations between a faction and ALL factions in a formlist with string
; -----------------------------------------------------------------------------
Bool Function SetFactionRelationship(Formlist factions, Faction target, String rel)
	Int iIndex = 0
	While iIndex < factions.GetSize() - 1
		Faction currentGuardFaction = factions.GetAt(iIndex) as Faction
		Faction bfThievesGuild = dubhBaseFactions.GetAt(11) as Faction
		If rel == "Ally"
			If iIndex != 12 && target != bfThievesGuild
				currentGuardFaction.SetAlly(target)
			EndIf
		ElseIf rel == "Friend"
			If iIndex != 12 && target != bfThievesGuild
				currentGuardFaction.SetAlly(target, true, true)
			EndIf
		ElseIf rel == "Neutral"
			If iIndex != 12 && target != bfThievesGuild
				currentGuardFaction.SetEnemy(target, true, true)
			EndIf
		ElseIf rel == "Enemy"
			If iIndex != 12 && target != bfThievesGuild
				currentGuardFaction.SetEnemy(target)
			EndIf
		EndIf
		iIndex += 1
	EndWhile
	Return True
EndFunction

; -----------------------------------------------------------------------------
; Starts quest with debug output
; -----------------------------------------------------------------------------
Bool Function StartQuest(Quest targetQuest)
	If targetQuest.IsStopped()
		If targetQuest.Start()
			Log("Successfully started " + targetQuest)
			Return True
		EndIf
	EndIf
	Log("Could not start " + targetQuest + " because the quest was not stopped")
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Stops quest with debug output
; -----------------------------------------------------------------------------
Bool Function StopQuest(Quest targetQuest)
	Int iCycles = 0
	If targetQuest.IsRunning()
		targetQuest.Stop()
		While targetQuest.IsRunning()
			iCycles += 1
		EndWhile
		While targetQuest.IsStopping()
			iCycles += 1
		EndWhile
		If targetQuest.IsStopped()
			Log("Successfully stopped " + targetQuest)
			Return True
		EndIf
	EndIf
	Log("Could not stop " + targetQuest + " because the quest was not running")
	Return False
EndFunction

; -----------------------------------------------------------------------------
; Triggers when toggle button clicked
; -----------------------------------------------------------------------------
Event OnBooleanToggleClick(string eventName, string strArg, float numArg, Form sender)
	; -----------------------------------------------------------------------------
	; Toggle Disguise System
	; -----------------------------------------------------------------------------
	If eventName == "dubhToggleDisguiseSystem"
		bDisguiseSystem = numArg as Bool

		If bDisguiseSystem
			StartQuest(dubhDisguiseQuest)
		Else
			If StopQuest(dubhDisguiseQuest)
				ClearDisguiseFactions()
				ClearTrackedBounties()
			EndIf
		EndIf

	; -----------------------------------------------------------------------------
	; Toggle Detection System
	; -----------------------------------------------------------------------------
	ElseIf eventName == "dubhToggleDetectionSystem"
		bDetectionSystem = numArg as Bool

		If bDetectionSystem
			StartQuest(dubhDetectionQuest)
		Else
			StopQuest(dubhDetectionQuest)
		EndIf

	; -----------------------------------------------------------------------------
	; Uninstall
	; -----------------------------------------------------------------------------
	;ElseIf eventName == "dubhUninstall"
	;	bUninstalled = numArg as Bool
  ;
	;	If bUninstalled
	;		If StopQuest(dubhDisguiseQuest)
	;			If StopQuest(dubhDetectionQuest)
	;				parent.OnMenuClose(ModName)
	;				StopQuest(self)
	;			EndIf
	;		EndIf
	;	Else
	;		Log("bUninstalled set to: " + bUninstalled + ". This should be unreachable.")
	;	EndIf

	; -----------------------------------------------------------------------------
	; Toggle Bandit Disguise
	; -----------------------------------------------------------------------------
	ElseIf eventName == "dubhToggleDisguiseBandit"
		bBanditDisguise = numArg as Bool
		Faction BanditDisguise = dubhDisguiseFactions.GetAt(30) as Faction

		If bBanditDisguise
			If dubhExcludedDisguises.HasForm(BanditDisguise)
				dubhExcludedDisguises.RemoveAddedForm(BanditDisguise)
				Log("Removed " + BanditDisguise + " from " + dubhExcludedDisguises)
			EndIf
		Else
			If !dubhExcludedDisguises.HasForm(BanditDisguise)
				dubhExcludedDisguises.AddForm(BanditDisguise)
				Log("Added " + BanditDisguise + " to " + dubhExcludedDisguises)
			EndIf
		EndIf

	; -----------------------------------------------------------------------------
	; Toggle Guards vs. Dark Brotherhood
	; -----------------------------------------------------------------------------
	ElseIf eventName == "dubhToggleGuardsVsDarkBrotherhood"
		bGuardsVsDarkBrotherhood = numArg as Bool
		Faction bfDarkBrotherhood = dubhBaseFactions.GetAt(2) as Faction

		If bGuardsVsDarkBrotherhood
			If SetFactionRelationship(dubhGuardFactions, bfDarkBrotherhood, "Enemy")
				Log("Made " + bfDarkBrotherhood + " enemies of " + dubhGuardFactions)
			EndIf
		Else
			If SetFactionRelationship(dubhGuardFactions, bfDarkBrotherhood, "Neutral")
				Log("Made " + bfDarkBrotherhood + " neutral to " + dubhGuardFactions)
			EndIf
		EndIf

	; -----------------------------------------------------------------------------
	; Toggle Guards vs. Thieves Guild
	; -----------------------------------------------------------------------------
	ElseIf eventName == "dubhToggleGuardsVsThievesGuild"
		bGuardsVsThievesGuild = numArg as Bool
		Faction bfThievesGuild = dubhBaseFactions.GetAt(11) as Faction

		If bGuardsVsThievesGuild
			If SetFactionRelationship(dubhGuardFactions, bfThievesGuild, "Enemy")
				Log("Made " + bfThievesGuild + " enemies of " + dubhGuardFactions)
			EndIf
		Else
			If SetFactionRelationship(dubhGuardFactions, bfThievesGuild, "Neutral")
				Log("Made " + bfThievesGuild + " neutral to " + dubhGuardFactions)
			EndIf
		EndIf

	EndIf
EndEvent