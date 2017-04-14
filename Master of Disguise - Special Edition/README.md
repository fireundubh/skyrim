# Master of Disguise - Special Edition

## Overview

Master of Disguise transforms faction armor into real disguises with an immersive and fully customizable detection system. Suit up as anyone, from a Dark Brotherhood assassin to a rough-and-tumble bandit. Find safety among new allies, or deceive and betray them. Wage war against new enemies, or fire the first shot. You are the Master of Disguise. What will you do?

## Accolades

 - [GameSpot's Top Skyrim Mod of the Week](http://www.gamespot.com/videos/top-5-skyrim-mods-of-the-week-become-the-master-of/2300-6423174/) ([@8:11](https://www.youtube.com/watch?v=QZxRm1EcbQ4&t=8m11s))
 - [Featured by Kotaku](http://kotaku.com/skyrim-disguises-let-you-walk-around-doing-whatever-1681784966)
 - [Featured by MxR Mods](https://www.youtube.com/watch?v=69e7xcYw-G4)
 - [Featured by Brodual](https://www.youtube.com/watch?v=ATGNFDgNT-A)
 - #1 in Stealth in the Skyrim G.E.M.S. Hall of Fame (pre-GitHub)
 - #1 in Stealth on the Skyrim Nexus (pre-GitHub)

## Requirements

 - Skyrim Special Edition
 - Unofficial Skyrim Special Edition Patch

## Design

### Avoiding Detection

NPCs now have a horizontal front-facing field of view, or cone of vision, that extends outward up to a predetermined distance. The fDetectionViewCone game setting, changed or dynamically adjusted by some mods, determines the width of the cone, and the amount of light on the player adjusts the distances at which NPCs can recognize the player.

Periodically, while the player is within that cone of vision, NPCs may become suspicious. If an NPC becomes suspicious, the player will be notified that "you are being watched" in the top left corner of the screen. The identity of the suspicious NPC will not be revealed; however, the player will have seconds to lose their line of sight, which, in addition to cover, can also be achieved by moving into dark or dimly lit areas of the geography.

If the player fails to lose their line of sight, the player and NPC will make dice rolls to determine whether the NPC discovers the player. If the player wins the dice roll, life will go on and nobody will be any wiser. If the player loses the dice roll, combat will begin, but only if the NPC would have been hostile normally. 

#### Understanding the NPC Perception Model

![Example NPC Field of View](http://oi59.tinypic.com/2n1e5ig.jpg)

Field of View Segmentation:

 - CLEAR: -15&deg; to 15&deg;
 - DISTORTED: -30&deg; to -15&deg; and 15&deg; to 30&deg;
 - PERIPHERAL: -60&deg; to -30&deg; and 30&deg; to 60&deg;
 - HOSTILE: Region meant to indicate the natural state of the actor. (Ignore.)

Line of Sight Ranges:

 - The ranges 512, 1024, and 2048 are dynamically adjusted by light level.
 - The base LOS distance max is configurable by the player.
 - Adjustment formula: `fLOSDistanceMaxBase x (fLightLevel / 100.0)`
 - Default Value: `fLOSDistanceMaxBase = 2048.0`

Line of Sight Penalties:

 - When rolling for discovery, the player's skill contribution to the dice roll is multiplied by a skill penalty determined by where the player was suspected in the cone of vision.
 - For example, if the player's adjusted skill score was 50, that score would be multiplied by 0.75, 0.8, or 0.85, so the effective skill score would be respectively 37.5, 40, or 42.5.
 - Originally, there were more penalties, as indicated in the graphic, but the gain did not justify the complexity.
 - Skill formula: `((fBestSkillContribMax x fSneakOrIllusionSkill) / 100.0) x fSkillPenalty`
 - Default Value: `fBestSkillContribMax = 50.0`

### Rolling for Discovery

The player's skill in Sneak or Illusion, behaviors, race, and disguise coverage are combined into a "identity score" that is rolled against a random number between 0 and 99. If the identity score is greater than the random number, the player wins the discovery roll and the NPC will not become hostile.

#### Racial Synergies

Skyrim factions respond differently to the Man, Mer, and Beast races. Master of Disguise takes those biases into account:

Race | Faction | Modifier
--- | --- | ---
Imperial | Blades | Bonus
Dunmer | Cultists | Bonus
Nord | Cultists | Bonus
Vampire | Dark Brotherhood | Bonus
Vampire | Dawnguard | Penalty 
Breton | Forsworn | Bonus 
All Others | Forsworn | Penalty 
Imperial | Imperial Legion | Bonus 
Orc | Imperial Legion | Bonus 
Dunmer | Morag Tong | Bonus 
Imperial | Penitus Oculatus | Bonus 
Orc | Penitus Oculatus | Bonus
Nord | Stormcloaks | Bonus
Altmer | Stormcloaks | Penalty 
Imperial | Stormcloaks | Penalty 
Altmer | Thalmor | Bonus
Bosmer | Thalmor | Bonus
All Others | Thalmor | Penalty
Argonian | Thieves Guild | Bonus 
Khajiit | Thieves Guild | Bonus 
Vampire | Vigil of Stendarr | Penalty 
Vampire | Clan Volkihar | Bonus 
Vampire | Necromancers | Bonus 
Vampire | Vampires | Bonus
Nord | Markarth Guard | Bonus
Breton | Markarth Guard | Penalty 
Dunmer | Redoran Guard | Bonus 
Imperial | Solitude Guard | Bonus
Orc | Solitude Guard | Bonus 
Nord | Solitude Guard | Penalty 
Nord | Windhelm Guard | Bonus 
Altmer | Windhelm Guard | Penalty 
All | Daedra | Penalty
Redguard | Alik'r Mercenaries | Bonus 
All Others | Alik'r Mercenaries | Penalty 
Altmer | Bandits | Penalty 
All Others | Bandits | Bonus

### Leaving Witnesses

If a faction NPC is attacked by the player in disguise, the player will be immediately discovered and attacked. If the NPC is dispatched without any witnesses nearby, the player's disguise will be restored.

### Escaping

When the player is discovered, it is not necessary to engage in combat, although hostilities will begin. If the player is able to outpace the pursuers by some distance, they will give up the chase and return to their patrol points. Although requiring some suspension of disbelief, this allows the player to try again without reloading a save.

### Factions

Disguises not only deceive members of the factions to whom the disguise belongs but also enemies of those factions. Opposing factions, which may not normally be hostile to the player, may see the player as an enemy. 

In addition, faction NPCs engaged in combat with other NPCs, except companions, will not roll for discovery.

### SkyUI Mod Configuration Menu

*Only available in the non-SSE version of Skyrim.*

Using the new SkyUI Mod Configuration Menu, the player can adjust nearly every aspect of the discovery system from within the game. The disguise and discovery systems can be toggled independently as well.

#### Example: Scoring Menu

![Scoring Menu](http://i.imgur.com/jhZQVRv.jpg)

#### Example: Crime Menu

![Crime Menu](http://i.imgur.com/DiStqBN.jpg)

## How to Wear a Disguise

To wear most disguises, the player will need to equip faction armor in only the body slot. Some disguises have special base requirements. However, the disguise will be always more effective when complete.

### Special Base Requirements

 - The player must wear the Ring of the Silver Hand to infiltrate the Silver Hand.
 - The player must wear the Vigilant's Amulet of Stendarr to infiltrate the Vigil of Stendarr.
 - The player must equip the Eastmarch Guard's Shield to infiltrate the Windhelm Guard. The Windhelm Guard wear regular Stormcloak uniforms and have only this shield to separate them.
 - Dragonborn: The player must wear the Cultist Mask to infiltrate Miraak's Cultists.

*Items that satisfy these requirements can be found on members of the above factions.*

### Priority Rule

When the player wears a disguise that shares components with another, the first disguise activated will remain activated but additional disguises will not. For example, the player cannot be favored by Hircine (friendly with werewolves) and a member of the Silver Hand by equipping the Savior's Hide and Ring of the Silver Hand.

*Only disguises with special base requirements are affected by the priority rule.*

### Guard Disguises

When the player equips a guard disguise, the player's bounty is concealed in the respective hold. For example, wearing the Windhelm Guard disguise will conceal the player's bounty in Eastmarch but not The Reach.

In addition, the amount of the bounty will be used to determine the effectiveness of the disguise. By default, the player can achieve 50% effectiveness at 1,000 septims, which is the default bounty for murder.

While in a guard disguise, if the player commits a crime and leaves witnesses, the player will incur a bounty and the disguise will no longer have the desired effect. But smaller bounties can still be paid off.

When the player is discovered, or the disguise is no longer worn, the player's active bounty will be restored. Any bounties incurred while in the disguise will be added to the player's active bounty.

**Known Exploit:** The player can continually re-equip the guard disguise to continually conceal the active bounty, and effectively commit most crimes without penalties while in disguise. However, the tracked bounty will continue to increase, so at some point, the player will have to address the enlarged active bounty.

### Other Faction Equipment

#### Bandit Disguises

*Only available in the non-SSE version of Skyrim.*

The player can now wear a bandit disguise, comprised of Fur Armor, Fur Helmet, Fur Bracers, and Fur Shoes. Fur Boots and Fur Gauntlets, found on Stormcloaks, can also be substituted. All hold guards are hostile to bandits.

This feature can be toggled from the SkyUI Mod Configuration Menu.

#### Savior's Hide

*Only available in the non-SSE version of Skyrim.*

Wearing the Savior's Hide, a gift from Hircine, will signal to Werewolves that the player is favored and the player will not be attacked by Werewolves.

This feature can be toggled from the SkyUI Mod Configuration Menu.

#### Daedric Weapons and Armor

*Only available in the non-SSE version of Skyrim.*

According to the Vigil of Stendarr, "the Mercy of Stendarr does not extend to Daedra worshippers." When the player equips Daedric weapons or armor, Vigilants will attempt to drag the player into the light. In addition, Dremora will see the player as aligned with Mehrunes Dagon and will not attack.

This feature can be toggled from the SkyUI Mod Configuration Menu.

## Faction Relations Overhaul

![Faction Relations Overhaul](http://i.imgur.com/QAfAcIu.png)

## Compatibility

 - Compatible with all mods except those offering similar features
 - Compatible with armor replacers and retextures
 - Compatible with custom races but custom races will not have racial modifiers
 - Compatible with Requiem 1.7.3, 1.8, 1.9, and beyond with patches
 - Not compatible with Skyrim Redone (SkyRe) due to similar features
 - Not compatible with PerMa due to similar features
 - Mods adding new faction armor will require patches to add disguise support
 - Mods changing any faction may require patches to address compatibility issues

## Upgrading/Uninstalling

 1. While in the game, using the SkyUI menu, go to the Debug submenu.
 2. Toggle off the disguise and discovery systems.
 3. Save and quit the game.
 4. Uninstall Master of Disguise.

**Note:** Bethesda Softworks does not support uninstalling mods. Loading saves without previously active mods may break the save. Following the steps above offers the best chance at avoiding problems with existing saves.