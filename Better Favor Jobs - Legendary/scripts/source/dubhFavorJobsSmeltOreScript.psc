ScriptName dubhFavorJobsSmeltOreScript Extends Quest

; -------------------------------------------------------------------------------
; Actors
; -------------------------------------------------------------------------------
Actor Property Player Auto

; -------------------------------------------------------------------------------
; Ingots
; -------------------------------------------------------------------------------
Formlist Property IngotTypes Auto
MiscObject Property IngotCorundum Auto
MiscObject Property IngotEbony Auto
MiscObject Property IngotGold Auto
MiscObject Property IngotIron Auto
MiscObject Property IngotMalachite Auto
MiscObject Property IngotMoonstone Auto
MiscObject Property IngotOrichalcum Auto
MiscObject Property IngotQuicksilver Auto
MiscObject Property IngotSilver Auto
MiscObject Property IngotSteel Auto
MiscObject Property IngotDwemer Auto

; -------------------------------------------------------------------------------
; Keywords
; -------------------------------------------------------------------------------
Formlist Property MinerKeywords Auto
Keyword Property MinerCorundum Auto
Keyword Property MinerEbony Auto
Keyword Property MinerGold Auto
Keyword Property MinerIron Auto
Keyword Property MinerMalachite Auto
Keyword Property MinerMoonstone Auto
Keyword Property MinerOrichalcum Auto
Keyword Property MinerQuicksilver Auto
Keyword Property MinerSilver Auto
Keyword Property MinerSteel Auto
Keyword Property MinerDwemer Auto

; -------------------------------------------------------------------------------
; Variables
; -------------------------------------------------------------------------------
Int Property PlayerIngotCount Auto
Int Property PlayerGoldReward Auto
MiscObject Property pGold001 Auto

; fireundubh
Int IngotValue
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
; Sell Ingots
; -------------------------------------------------------------------------------
Function SellIngots(Actor Foreman, Keyword IngotType)

	fSkill			= Player.GetAV(PlayerSkill)
	fBarterMax		= Game.GetGameSettingFloat("fBarterMax")
	fBarterMin		= Game.GetGameSettingFloat("fBarterMin")
	fBarterSellMax	= Game.GetGameSettingFloat("fBarterSellMax")

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Player) == 0
		Foreman.SetRelationshipRank(Player, 1)
	EndIf

	If IngotType == MinerCorundum
		IngotValue			= IngotCorundum.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotCorundum)

	ElseIf IngotType == MinerEbony
		IngotValue			= IngotEbony.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotEbony)

	ElseIf IngotType == MinerGold
		IngotValue			= IngotGold.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotGold)

	ElseIf IngotType == MinerIron
		IngotValue			= IngotIron.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotIron)

	ElseIf IngotType == MinerMalachite
		IngotValue			= IngotMalachite.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotMalachite)

	ElseIf IngotType == MinerMoonstone
		IngotValue			= IngotMoonstone.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotMoonstone)

	ElseIf IngotType == MinerOrichalcum
		IngotValue			= IngotOrichalcum.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotOrichalcum)

	ElseIf IngotType == MinerQuicksilver
		IngotValue			= IngotQuicksilver.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotQuicksilver)

	ElseIf IngotType == MinerSilver
		IngotValue			= IngotSilver.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotSilver)
		
	ElseIf IngotType == MinerSteel
		IngotValue			= IngotSteel.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotSteel)
		
	ElseIf IngotType == MinerDwemer
		IngotValue			= IngotDwemer.GetGoldValue()
		PlayerIngotCount	= Player.GetItemCount(IngotDwemer)

	EndIf

	;fireundubh: Calculate the transaction value
	TransactionValue = (PlayerIngotCount * IngotValue)

	;fireundubh: Calculate the amount of gold to give the player
	PlayerGoldReward = (TransactionValue / ((fBarterMax * (100 - fSkill) + fBarterMin * fSkill) / 100)) as Int

	If fBarterSellMax

		fPlayerGoldReward	= PlayerGoldReward as Float
		fTransactionValue	= TransactionValue as Float
		fRewardRatio		= (fPlayerGoldReward / fTransactionValue)

		If fRewardRatio > fBarterSellMax
			PlayerGoldReward = (TransactionValue * fBarterSellMax) as Int
		EndIf

	EndIf

	;fireundubh: Calculate the amount of skill to give the player
	fSkillReward = (PlayerIngotCount * fSkillRewardXP) as Int

	If IngotType == MinerCorundum
		Player.RemoveItem(IngotCorundum,    PlayerIngotCount)

	ElseIf IngotType == MinerEbony
		Player.RemoveItem(IngotEbony,       PlayerIngotCount)

	ElseIf IngotType == MinerGold
		Player.RemoveItem(IngotGold,        PlayerIngotCount)

	ElseIf IngotType == MinerIron
		Player.RemoveItem(IngotIron,        PlayerIngotCount)

	ElseIf IngotType == MinerMalachite
		Player.RemoveItem(IngotMalachite,   PlayerIngotCount)

	ElseIf IngotType == MinerMoonstone
		Player.RemoveItem(IngotMoonstone,   PlayerIngotCount)

	ElseIf IngotType == MinerOrichalcum
		Player.RemoveItem(IngotOrichalcum,  PlayerIngotCount)

	ElseIf IngotType == MinerQuicksilver
		Player.RemoveItem(IngotQuicksilver, PlayerIngotCount)

	ElseIf IngotType == MinerSilver
		Player.RemoveItem(IngotSilver,      PlayerIngotCount)
		
	ElseIf IngotType == MinerSteel
		Player.RemoveItem(IngotSteel,       PlayerIngotCount)
		
	ElseIf IngotType == MinerDwemer
		Player.RemoveItem(IngotDwemer,      PlayerIngotCount)

	EndIf

	Player.AddItem(pGold001, PlayerGoldReward)

	Game.AdvanceSkill(PlayerSkill, fSkillReward)

EndFunction
