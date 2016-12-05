ScriptName FavorJobsHuntingScript extends Quest

Int Property PlayerCropCount Auto
Int Property PlayerGoldReward Auto

Race Property HorseRace Auto

Actor Property EncHorseBlack Auto
Actor Property EncHorseBlackAndWhite Auto
Actor Property EncHorseBrown Auto
Actor Property EncHorseGrey Auto
Actor Property EncHorsePalomino Auto
Actor Property EncHorseSaddledBlack Auto
Actor Property EncHorseSaddledBlackAndWhite Auto
Actor Property EncHorseSaddledBrown Auto
Actor Property EncHorseSaddledGrey Auto
Actor Property EncHorseSaddledPalomino Auto
Actor Property HorseForCarriageNew Auto
Actor Property HorseForCarrriageTemplate Auto
Actor Property TG05KarliahHorse Auto

MiscObject Property HorseHide Auto
Potion Property FoodHorseMeat Auto

MiscObject Property pGold Auto

; fireundubh
; Take the Speech skill into account
String PlayerSkill = "Speechcraft"

; Set skill reward XP for each item traded
Float fSkillRewardXP = 15.0

Function Reward(Form Trophy)

	Actor Player = Game.GetPlayer()
	
	Float fSkill     = Player.GetAV(PlayerSkill)
	Float fBarterMax = Game.GetGameSettingFloat("fBarterMax")
	Float fBarterMin = Game.GetGameSettingFloat("fBarterMin")
	Float fBarterSellMax = Game.GetGameSettingFloat("fBarterSellMax")

	; Get the player's last ridden horse
	Actor PlayerHorse = Game.GetPlayersLastRiddenHorse()

	; Count the amount of crop the player has
	PlayerCropCount = 1
	
	;fireundubh: Set transaction value
	Int iTransactionValue = (PlayerCropCount * Trophy.GetGoldValue())
	
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

	Player.RemoveItem(Trophy, PlayerCropCount)
	Player.AddItem(pGold, PlayerGoldReward)
	
	;fireundubh: Add skill reward
	Game.AdvanceSkill(PlayerSkill, fSkillReward)

EndFunction

Function SellTrophy(Actor Foreman, Form Trophy)

	;Make the Foreman the player's friend
	If Foreman.GetRelationshipRank(Game.GetPlayer()) == 0
		Foreman.SetRelationshipRank(Game.GetPlayer(), 1)
	EndIf

	Reward(Trophy)

EndFunction

