ScriptName FavorJobsChopWoodScript extends Quest

MiscObject	Property pFirewood Auto
Int Property PlayerFirewoodCount Auto
Int Property PlayerGoldReward Auto
MiscObject Property pGold Auto
GlobalVariable Property JobsWoodValue Auto

; fireundubh
Bool Property bRequiemLoaded Auto Hidden

; Take the Speech skill into account
String PlayerSkill = "Speechcraft"

; Set skill reward XP for each item traded
Float fSkillRewardXP = 15.0

Function SellWood(Actor Foreman)

	Actor Player = Game.GetPlayer()
	
	Float fSkill     = Player.GetAV(PlayerSkill)
	Float fBarterMax = Game.GetGameSettingFloat("fBarterMax")
	Float fBarterMin = Game.GetGameSettingFloat("fBarterMin")
	Float fBarterSellMax = Game.GetGameSettingFloat("fBarterSellMax")

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Game.GetPlayer()) == 0
		Foreman.SetRelationshipRank(Game.GetPlayer(), 1)
	EndIf

	;fireundubh: Get value of wood and set global value
	JobsWoodValue.SetValueInt(pFirewood.GetGoldValue())

	;Count the amount of wood the player has
	PlayerFirewoodCount = Player.GetItemCount(pFirewood)

	;fireundubh: Set transaction value
	Int iTransactionValue = (PlayerFirewoodCount * JobsWoodValue.GetValueInt())
	
	;fireundubh: Calculate reward
	PlayerGoldReward = (iTransactionValue / ((fBarterMax * (100 - fSkill) + fBarterMin * fSkill) / 100)) as Int
	
	If fBarterSellMax
		Float fPlayerGoldReward = PlayerGoldReward as Float
		Float fTransactionValue = iTransactionValue as Float
		Float fRewardRatio = (fPlayerGoldReward / fTransactionValue)
		
		If fRewardRatio > fBarterSellMax
			PlayerGoldReward = (iTransactionValue * fBarterSellMax) as Int
		EndIf
	EndIf
	
	;fireundubh: Calculate the amount of skill to give the player
	Float fSkillReward = (PlayerFirewoodCount * fSkillRewardXP) as Int

	;Remove firewood from inventory and add gold
	Player.RemoveItem(pFirewood, PlayerFirewoodCount)
	Player.AddItem(pGold, PlayerGoldReward)

	;fireundubh: Add skill reward
	Game.AdvanceSkill(PlayerSkill, fSkillReward)

EndFunction
