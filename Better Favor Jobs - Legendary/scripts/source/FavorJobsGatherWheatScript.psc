ScriptName FavorJobsGatherWheatScript extends Quest

Ingredient Property Wheat Auto
Ingredient Property Nirnroot Auto
Potion Property Gourd Auto
Potion Property FoodPotato Auto
Potion Property FoodCabbage Auto
Potion Property FoodLeek Auto
Int Property PlayerCropCount Auto
Int Property PlayerGoldReward Auto
MiscObject Property pGold Auto

; fireundubh
; Take the Speech skill into account
String PlayerSkill = "Speechcraft"

; Set skill reward XP for each item traded
Float fSkillRewardXP = 15.0

Function Reward(Form sItem)

	Actor Player = Game.GetPlayer()
	
	Float fSkill     = Player.GetAV(PlayerSkill)
	Float fBarterMax = Game.GetGameSettingFloat("fBarterMax")
	Float fBarterMin = Game.GetGameSettingFloat("fBarterMin")
	Float fBarterSellMax = Game.GetGameSettingFloat("fBarterSellMax")

	;Count the amount of crop the player has
	PlayerCropCount = Player.GetItemCount(sItem)
	
	;fireundubh: Set transaction value
	Int iTransactionValue = (PlayerCropCount * sItem.GetGoldValue())
	
	;fireundubh: Calculate the amount of gold to give the player
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
	Float fSkillReward = (PlayerCropCount * fSkillRewardXP) as Int

	Player.RemoveItem(sItem, PlayerCropCount)
	Player.AddItem(pGold, PlayerGoldReward)
	
	;fireundubh: Add skill reward
	Game.AdvanceSkill(PlayerSkill, fSkillReward)

EndFunction

Function SellWheat(Actor Foreman)

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Game.GetPlayer()) == 0
		Foreman.SetRelationshipRank(Game.GetPlayer(), 1)
	EndIf

	Reward(Wheat)

EndFunction

Function SellPotato(Actor Foreman)

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Game.GetPlayer()) == 0
		Foreman.SetRelationshipRank(Game.GetPlayer(), 1)
	EndIf

	Reward(FoodPotato)

EndFunction

Function SellLeek(Actor Foreman)

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Game.GetPlayer()) == 0
		Foreman.SetRelationshipRank(Game.GetPlayer(), 1)
	EndIf

	Reward(FoodLeek)

EndFunction

Function SellGourd(Actor Foreman)

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Game.GetPlayer()) == 0
		Foreman.SetRelationshipRank(Game.GetPlayer(), 1)
	EndIf

	Reward(Gourd)

EndFunction

Function SellCabbage(Actor Foreman)

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Game.GetPlayer()) == 0
		Foreman.SetRelationshipRank(Game.GetPlayer(), 1)
	EndIf

	Reward(FoodCabbage)

EndFunction

Function SellNirnroot(Actor Foreman)

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Game.GetPlayer()) == 0
		Foreman.SetRelationshipRank(Game.GetPlayer(), 1)
	EndIf

	Reward(Nirnroot)

EndFunction
