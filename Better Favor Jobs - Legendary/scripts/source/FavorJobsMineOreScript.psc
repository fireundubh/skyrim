ScriptName FavorJobsMineOreScript Extends Quest

; -------------------------------------------------------------------------------
; Globals
; -------------------------------------------------------------------------------
GlobalVariable Property JobsOreCorundumValue Auto
GlobalVariable Property JobsOreEbonyValue Auto
GlobalVariable Property JobsOreGoldValue Auto
GlobalVariable Property JobsOreIronValue Auto
GlobalVariable Property JobsOreMalachiteValue Auto
GlobalVariable Property JobsOreMoonstoneValue Auto
GlobalVariable Property JobsOreOrichalcumValue Auto
GlobalVariable Property JobsOreQuicksilverValue Auto
GlobalVariable Property JobsOreSilverValue Auto

; -------------------------------------------------------------------------------
; Actors
; -------------------------------------------------------------------------------
Actor Property Player Auto

; -------------------------------------------------------------------------------
; Ore
; -------------------------------------------------------------------------------
MiscObject Property OreCorundum Auto
MiscObject Property OreEbony Auto
MiscObject Property OreGold Auto
MiscObject Property OreIron Auto
MiscObject Property OreMalachite Auto
MiscObject Property OreMoonstone Auto
MiscObject Property OreOrichalcum Auto
MiscObject Property OreQuicksilver Auto
MiscObject Property OreSilver Auto

; -------------------------------------------------------------------------------
; Keywords
; -------------------------------------------------------------------------------
Keyword Property MinerCorundum Auto
Keyword Property MinerEbony Auto
Keyword Property MinerGold Auto
Keyword Property MinerIron Auto
Keyword Property MinerMalachite Auto
Keyword Property MinerMoonstone Auto
Keyword Property MinerOrichalcum Auto
Keyword Property MinerQuicksilver Auto
Keyword Property MinerSilver Auto

; -------------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------------
Int Property PlayerOreCount Auto
Int Property PlayerGoldReward Auto
MiscObject Property pGold001 Auto

; fireundubh
Int OreValue
Int TransactionValue

; Take the Speech skill into account
String PlayerSkill = "Speechcraft"

; Set skill reward XP for each item traded
Float fSkillRewardXP = 15.0

; -------------------------------------------------------------------------------
; Barter
; -------------------------------------------------------------------------------
Float fSkill
Float fBarterMax
Float fBarterMin
Float fBarterSellMax

; -------------------------------------------------------------------------------
; Reward
; -------------------------------------------------------------------------------
Float fPlayerGoldReward
Float fTransactionValue
Float fRewardRatio
Float fSkillReward

; -------------------------------------------------------------------------------
; Sell Ore
; -------------------------------------------------------------------------------
Function SellOre(Actor Foreman, Keyword OreType)

	fSkill 			= Player.GetAV(PlayerSkill)
	fBarterMax 		= Game.GetGameSettingFloat("fBarterMax")
	fBarterMin 		= Game.GetGameSettingFloat("fBarterMin")
	fBarterSellMax 	= Game.GetGameSettingFloat("fBarterSellMax")

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Player) == 0
		Foreman.SetRelationshipRank(Player, 1)
	EndIf

	If OreType == MinerCorundum
		JobsOreCorundumValue.SetValueInt(OreCorundum.GetGoldValue())
		OreValue		= JobsOreCorundumValue.GetValueInt()
		PlayerOreCount	= Player.GetItemCount(OreCorundum)

	ElseIf OreType == MinerEbony
		JobsOreEbonyValue.SetValueInt(OreEbony.GetGoldValue())
		OreValue		= JobsOreEbonyValue.GetValueInt()
		PlayerOreCount	= Player.GetItemCount(OreEbony)

	ElseIf OreType == MinerGold
		JobsOreGoldValue.SetValueInt(OreGold.GetGoldValue())
		OreValue		= JobsOreGoldValue.GetValueInt()
		PlayerOreCount	= Player.GetItemCount(OreGold)

	ElseIf OreType == MinerIron
		JobsOreIronValue.SetValueInt(OreIron.GetGoldValue())
		OreValue		= JobsOreIronValue.GetValueInt()
		PlayerOreCount	= Player.GetItemCount(OreIron)

	ElseIf OreType == MinerMalachite
		JobsOreMalachiteValue.SetValueInt(OreMalachite.GetGoldValue())
		OreValue		= JobsOreMalachiteValue.GetValueInt()
		PlayerOreCount	= Player.GetItemCount(OreMalachite)

	ElseIf OreType == MinerMoonstone
		JobsOreMoonstoneValue.SetValueInt(OreMoonstone.GetGoldValue())
		OreValue		= JobsOreMoonstoneValue.GetValueInt()
		PlayerOreCount	= Player.GetItemCount(OreMoonstone)

	ElseIf OreType == MinerOrichalcum
		JobsOreOrichalcumValue.SetValueInt(OreOrichalcum.GetGoldValue())
		OreValue		= JobsOreOrichalcumValue.GetValueInt()
		PlayerOreCount	= Player.GetItemCount(OreOrichalcum)

	ElseIf OreType == MinerQuicksilver
		JobsOreQuicksilverValue.SetValueInt(OreQuicksilver.GetGoldValue())
		OreValue		= JobsOreQuicksilverValue.GetValueInt()
		PlayerOreCount	= Player.GetItemCount(OreQuicksilver)

	ElseIf OreType == MinerSilver
		JobsOreSilverValue.SetValueInt(OreSilver.GetGoldValue())
		OreValue		= JobsOreSilverValue.GetValueInt()
		PlayerOreCount	= Player.GetItemCount(OreSilver)

	EndIf

	;fireundubh: Calculate the transaction value
	TransactionValue = (PlayerOreCount * OreValue)

	;fireundubh: Calculate the amount of gold to give the player
	PlayerGoldReward = (TransactionValue / ((fBarterMax * (100 - fSkill) + fBarterMin * fSkill) / 100)) as Int

	If fBarterSellMax

		fPlayerGoldReward 	= PlayerGoldReward as Float
		fTransactionValue 	= TransactionValue as Float
		fRewardRatio 		= (fPlayerGoldReward / fTransactionValue)

		If fRewardRatio > fBarterSellMax
			PlayerGoldReward = (TransactionValue * fBarterSellMax) as Int
		EndIf

	EndIf

	;fireundubh: Calculate the amount of skill to give the player
	fSkillReward = (PlayerOreCount * fSkillRewardXP) as Int

	If OreType == MinerCorundum
		Player.RemoveItem(OreCorundum,    PlayerOreCount)

	ElseIf OreType == MinerEbony
		Player.RemoveItem(OreEbony,       PlayerOreCount)

	ElseIf OreType == MinerGold
		Player.RemoveItem(OreGold,        PlayerOreCount)

	ElseIf OreType == MinerIron
		Player.RemoveItem(OreIron,        PlayerOreCount)

	ElseIf OreType == MinerMalachite
		Player.RemoveItem(OreMalachite,   PlayerOreCount)

	ElseIf OreType == MinerMoonstone
		Player.RemoveItem(OreMoonstone,   PlayerOreCount)

	ElseIf OreType == MinerOrichalcum
		Player.RemoveItem(OreOrichalcum,  PlayerOreCount)

	ElseIf OreType == MinerQuicksilver
		Player.RemoveItem(OreQuicksilver, PlayerOreCount)

	ElseIf OreType == MinerSilver
		Player.RemoveItem(OreSilver,      PlayerOreCount)

	EndIf

	Player.AddItem(pGold001, PlayerGoldReward)

	Game.AdvanceSkill(PlayerSkill, fSkillReward)

EndFunction
