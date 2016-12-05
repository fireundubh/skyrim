ScriptName FavorJobsHuntingScript extends Quest

Int Property PlayerCropCount Auto
Int Property PlayerGoldReward Auto

; Pelts
MiscObject Property BearPelt Auto
MiscObject Property BearCavePelt Auto
MiscObject Property BearSnowPelt Auto
MiscObject Property ChaurusChitin Auto
MiscObject Property CowHide Auto
MiscObject Property DeerHide Auto
MiscObject Property DeerHide02 Auto
MiscObject Property DragonScales Auto
MiscObject Property FoxPelt Auto
MiscObject Property FoxPeltSnow Auto
MiscObject Property GoatHide Auto
MiscObject Property HorkerTusk Auto
MiscObject Property HorseHide Auto
MiscObject Property MammothTusk Auto
MiscObject Property SabreCatPelt Auto
MiscObject Property SabreCatSnowPelt Auto
MiscObject Property WolfPelt Auto
MiscObject Property WolfIcePelt Auto

Ingredient Property HagravenFeathers Auto
Ingredient Property IceWraithTeeth Auto
Ingredient Property MudcrabChitin Auto
Ingredient Property SkeeverTail Auto
Ingredient Property SlaughterfishScales Auto

; Ingestibles
Potion Property FoodBeef Auto
Potion Property FoodGoatMeat Auto
Potion Property FoodHorseMeat Auto
Potion Property FoodHorkerMeat Auto
Potion Property FoodMammothMeat Auto
Potion Property FoodRabbit Auto
Potion Property FrostbiteVenom Auto

Ingredient Property ClamMeat Auto ; DLC?
Ingredient Property DaedraHeart Auto
Ingredient Property DogMeat Auto ; DLC?
Ingredient Property Ectoplasm Auto
Ingredient Property FalmerEar Auto
Ingredient Property GiantToes Auto
Ingredient Property glowDust Auto
Ingredient Property SkeeverTail Auto
Ingredient Property TrollFat Auto
Ingredient Property vampireDust Auto


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

	;Count the amount of crop the player has
	PlayerCropCount = Player.GetItemCount(Trophy)
	
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

