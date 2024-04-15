
# Map editor

Map editor is a tool that allows users to create skirmish maps. These maps can also be repackaged into campaigns.

Most basic editor controls are explained in the game settings, and can be overlayed as well.

Tile selector in the lower-right shows which tile will be placed. There is a number of categories, with many tiles in each. Most tiles require a ground tile to be placed first. Some tile categories will replace each other when placed, as things like Terrain, Building or Unit can not share the same tile.

Minimap in the lower-left allows users to see how the map is shaping up. There is a current cursor position indicator right above the minimap.

## Map Settings

Map Settings panel is available from the menu. It allows users access to more specific map configuration, as well as Trigger and Story editors for cutscenes, special behaviours and probably more.

It is divided in three tabs.

### Map Settings tab

This tab contains some map settings that are useful for both skirmish and campaign maps.

- `Skip initial camera pan to HQ` - this setting allows you to skip the inital camera pan to HQ (duh) regardless of the global flag in game Settings. This is useful when you want to open a scenario with a cutscene that leaves the camera in a specific spot.

- `Initial camera position` - camera position when the map is loaded. Can be picked manually with a picker button. This is useful when you want to open a scenario with a cutscene without revealing the area of the map where camera spawns as default (middle of the map)

- `Track` - musical track that is going to play during a match on this map. By default the track is randomised.

### Triggers tab

Triggers can be set up to react to what is happening on the game board in order to start Stories (configured in Stories tab). New Trigger can be created by providing a name.

List of Triggers can be paged.

#### Shared properties

All triggers share some basic properties:

- `Delete` - this button, placed next to a Trigger name, will remove the trigger entirely. WARNING: there will be no confirmation.

- `Change` - this button, placed next to a Trigger type, allows for the type to be changed. If a new type is chosen, that is different from the previous type, some specific Trigger settings might be lost

- `Select` - this button, placed next to a Story name (empty if not set), allows for the linked Story to be selected from a list.

- `One-off` - a setting that determines if a Trigger is going to be checked again once fired. Set to `Off` for a repeatable Trigger.

All other properties are Trigger type-specific, though many are going to repeat.

#### Trigger types

##### Assassination

Trigger that fires upon unit being killed.

- `VIP` - (optional) unit to be monitored for being killed. Can be picked by using picker button. If left empty, `Unit type` must be set.
- `Unit type` (optional) unit type to be monitored for being killed. Can be picked by using picker button from list of available types. If left empty, `VIP` must be set.

##### Attacked

Trigger that fires upon unit being attacked

- `VIP` - unit to be monitored for being attacked. Can be picked by using picker button.

##### Claim

Trigger that fires upon building being claimed

- `Player ID` - (optional) ID of a player who will have to claim a building in order to fire the Trigger. If left empty, `Player side` must be set.

- `Player side` - (optional) named player side who will have to claim a building in order to fire the Trigger. Can be picked from a list using picker button. If left empty, `Player ID` must be set.

- `Amount` - amount of buildings from `List` that need to be claimed in order to fire the Trigger.

- `List` - list of buildings to be monitored. Buildings can be picked using picker button. Once a building is added to the list, new position at the end is added for another one. Prev/Next buttons can be used to go through the list.

##### Decimate

Trigger that fires upon specific player forces being completely destroyed. Can be used in absence of an HQ building in Skirmish, that would normally trigger loss.

- `Player ID` - (optional) ID of a player who will have to be decimated in order to fire the Trigger. If left empty, `Player side` must be set.

- `Player side` - (optional) named player side who will have to be decimated in order to fire the Trigger. Can be picked from a list using picker button. If left empty, `Player ID` must be set.

##### Deploy

Trigger that fires upon player deploying specific amount of units.

- `Player ID` - (optional) ID of a player who will have to deploy units in order to fire the Trigger. If left empty, `Player side` must be set.

- `Player side` - (optional) named player side who will have to deploy units in order to fire the Trigger. Can be picked from a list using picker button. If left empty, `Player ID` must be set.

- `Amount` - amount of units needed to fire the Trigger

- `Unit type` (optional) - type of unit to be monitored. If set, only this type of unit will count towards `Amount`

##### Move

Trigger that fires upon unit being moved.

- `Player ID` - (optional) ID of a player who will have to move unit in order to fire the Trigger. If left empty, `Player side` or `VIP` or `Unit tag` must be set.

- `Player side` - (optional) named player side who will have to move unit in order to fire the Trigger. Can be picked from a list using picker button. If left empty, `Player ID` or `VIP` or `Unit tag` must be set.

- `VIP` - (optional) unit to be monitored in order to fire the Trigger. If left empty, `Player ID` or `Player side` or `Unit tag` must be set.

- `Unit tag` - (optional, useless) tag to be monitored on units in order to fire the Trigger. Currently there is no way to tag units. If left empty, `Player ID` or `Player side` or `VIP` must be set.

- `Excluded VIPs` - (optional) list of units that will NOT fire the Trigger. Can be picked using the picker button.

- `Watched fields` - list of rectangular fields to be watched in order to fire the Trigger. Fields can overlap. Fields are defined by two points, an upper-left and lower-right. Corner points can be picked using picker buttons.

##### Resources

Trigger that fires upon player reaching a certain amount of resources.

- `Player ID` - (optional) ID of a player who will have to gather resources in order to fire the Trigger. If left empty, `Player side` must be set.

- `Player side` - (optional) named player side who will have to gather resources in order to fire the Trigger. Can be picked from a list using picker button. If left empty, `Player ID` must be set.

- `Amount` - amount of resources needed to fire the Trigger

##### Turn

Trigger that fires at the start of a specific turn.

- `Player ID` - (optional) ID of a player who will have to start a turn in order to fire the Trigger. If left empty, `Player side` must be set.

- `Player side` - (optional) named player side who will have to start a turn in order to fire the Trigger. Can be picked from a list using picker button. If left empty, `Player ID` must be set.

- `Turn` - number order of a turn when to fire the Trigger



### Stories tab

Stories to be executed when certain conditions are met. These stories can range from cutscenes that show story to quiet modifications that happen in the background and player might not notice.

List of Stories can be paged.

New story can be created by providing a name. Editing a story will open a list of steps in that specific story. The `Delete` button will remove entire story. WARNING: there will be no confirmation.

#### Editing Story steps

When editing story steps, a list of steps with order numbers is shown on the left, while specific step editor will appear on the right. List of steps can be paged.

New steps can be added by clicking `Add` button. New step will be added at the end of the story and can be moved later if needed.

#### Shared properties

All story steps share some basic properties:

- `Step NO.` - order number of the step. Can be moved by changing the number and clicking `Move` button.

- `Delete` - this button appears next to the `Move` button. It will remove the step entirely. WARNING: there will be no confirmation.

- `Change` - this button, placed next to a Step type, allows for the type to be changed. If a new type is chosen, that is different from the previous type, some specific step settings might be lost

- `Delay` - number of seconds that have to pass before step after this one will be executed. Can be a fraction.

#### Story Step types

##### Activate hero

This step adds a hero as active for it's side, so that it's passive ability will be applied. Must be used after a Hero unit has been spawned by a Story.

- `VIP` - position of a hero to be activated. Can be picked with a picker button.

##### AP

This step modifies player AP.

- `Player side` - named player side who will have their AP modified. Can be picked from a list using picker button.

- `Amount` - the amount of AP that will be used for modification

- `Set` - if turned on, the player AP will be set to `Amount`, otherwise the `Amount` will be added to the current balance.

- `Cap` - if turned on, the player AP will be capped at `Amount`. If current AP is below `Amount` nothing will happen.

##### Attack

This steps makes one unit attack another.

- `Who` - who will be attacking. Can be picked using a picker button.

- `Whom` - whom will be attacked and receive damage. Can be picked using a picker button.

- `Damage` - how much damage will be dealt. Can be `0` for story purposes.

##### Ban unit

Step that bans/unbans a unit from being produced in a specific building.

- `Building` - position of a building to apply the ban/unban. Can be picked using a picker button.

- `Unit NO.` - order number of the production skill to be banned/unbanned. Numbering starts at the top with `0` and goes clockwise. Most units are at positions `0`, `2` and `4`

- `Disable` - decides if unit is banned or unbanned. Set to `ON` for a ban and `OFF` for unban.

##### Camera

Step that pans the camera to a specific tile.

- `Position` - position to move camera to. Can be picked using a picker button.

- `Zoom` - camera zoom at destination, it will be smoothly animated to this value. Must be a fraction between `0.0` and `1.0`

##### Claim

Step that claims a building for a specific side.

- `Building` - position of a building to be claimed. Can be picked using a picker button.

- `Player side` - named player side who will claim the building. Can be picked from a list using picker button.

##### Despawn

Step that despawns units in specified area.

- `Who` - (optional) specific unit to be despawned. Can be picked using a picker button. If left empty, `Cleared fields` must be set.

- `Cleared fields` - (optional) list of fields to be cleared of all units. Fields can overlap. Fields are defined by two points, an upper-left and lower-right. Corner points can be picked using picker buttons. If left empty, `Who` must be set.

##### Die

Step that kills specific unit.

- `VIP` - position of a unit to be destroyed. Can be picked with a picker button.

##### Eliminate player

Step that eliminates specific player from the game

- `Player side` - named player side who will be eliminated. Can be picked from a list using picker button.

##### End game

Step that ends the game immidiately.

- `Winner` - named player side who will be announced a winner. Can be picked from a list using picker button.

##### Hero ability

Step that enables/disables active hero abilities for all heroes at specific side.

- `Player side` - named player side who will have hero abilities enabled/disabled. Can be picked from a list using picker button.

- `Disable` - wether the abilities are to be enabled or disabled. Set to 'Off' for enabled or `On` for disabled.

##### Level up

Step that promotes a unit by one level.

- `VIP` - position of a unit to be promoted. Can be picked with a picker button.

##### Lock

Step that locks the player UI for the duration of the cutscene. Unlock at the end with `Unlock`. This step has no specific properties.

##### Message

Step that shows a dialogue message to the player.

- `Name` - name of the actor that delivers the message. Can be a translation key.

- `Portrait` - tile template name that will be used as the actor portrait. Can be picked from a list of available actors with a button.

- `Side` - message side on which the actor will appear. Can be either `left` or `right`.

- `Colour` - (optional) named player side for the actor. Can be picked from a list using picker button. If left empty, default side for the selected `Portrait` will be used.

- `Font size` - (optional) font size to be applied instead of default.

- `Sound` - (optional) sound to be played when message is shown. Can be picked from a list of available sounds with a button.

- `Text` - message text to be shown. Can be a translation key.

##### Move

Step that moves a specific unit.

- `Who` - specific unit to be moved. Can be picked using a picker button.

- `Where` - position to move unit to. Can be picked using a picker button.

- `Path` - comma separated list of cardinal directions that will form a path from `Who` to `Where`. Valid directions are `n`, `w`, `e` and `s` (must be lowercase). Directions must be separated with commas without any spaces. The path must lead exactly from `Who` to `Where`, otherwise the unit will be visually misaligned. The path must have one additional element at the end, which will indicate which direction to face once the move is done.

##### Objective

Step that sets or clears mission objective information.

- `Slot` - which objective slot to modify. Valid values are from `0` to `3`.

- `Text` - (optional) text of the objective to be set. Can be a translation key.

- `Clear` - wether or not to clear the specific objective slot.

##### Pause AI

Step that pauses the AI for a specific unit.

- `Who` - specific unit to be paused. Can be picked using a picker button.

- `Pause` - select if AI is to paused or unpaused.

##### Revive player

Step that revives specific player. Can be used to add an AI player mid-play in a campaign map (that specific player must exist from the start in a dead state).

- `Player side` - named player side who will be revived. Can be picked from a list using picker button.

##### Side

Step that changes side of a specific unit.

- `Who` - position of a unit to change side. Can be picked using a picker button.

- `Player side` - named player side who will be the new commander. Can be picked from a list using picker button.

##### Spawn

Step that spawns a new unit. If a specified tile is occupied, old unit will be removed.

- `Where` - position to spawn the new unit. Can be picked using a picker button.

- `Unit type` - template name of a new unit. Can be picked by using picker button from list of available types.

- `Player side` - named player side who will be the commander of a new unit. Can be picked from a list using picker button.

- `Rotation` - rotation in degrees the new unit will have. Values of `0`, `90`, `180` and `270` are recommended.

- `Sound` - wether or not to play the spawn sound.

- `Promote` - wether or not to promote the unit by one level upon spawn.

##### Target VIP

Step that re-targets a Trigger to a new VIP. Useful for setting up a Trigger on heroes that were added using a Story mid-game.

- `VIP` - position of a unit to be targeted. Can be picked with a picker button.

- `Trigger` - name of a Trigger to be modified. Can be picked by using picker button from list of available Triggers.

##### Terrain add

Step that adds a piece of terrain to the map.

- `Where` - position to spawn the new tile. Can be picked using a picker button.

- `Tile type` - type of tile to be added. Can be picked by using picker button from list of available types. Will narrow down the list of available templates.

- `Template` - tile template to be added. Can be picked by using picker button from list of available types. Will be narrowed down if the type is set.

- `Player side` - (optional) named player side to be applied if tile is a building. Can be picked from a list using picker button.

- `Rotation` - rotation in degrees the new tile will have. Values of `0`, `90`, `180` and `270` are recommended.

- `Smoke` - wether or not to apply a smoke particle effect as the tile appears.

##### Terrain remove

Step that removes a piece of terrain from the map.

- `Where` - position to remove the tile. Can be picked using a picker button.

- `Tile type` - type of tile to be removed. Can be picked by using picker button from list of available types.

- `Explosion` - wether or not to apply an explosion particle effect as the tile dissapears.

##### Tether

Step that applies an AI tether to a unit. A tethered unit will have it's movement restricted so that it does not leave the general area.

- `VIP` - position of a unit to be tethered. Can be picked with a picker button.

- `Length` - length of a tether.

##### Trigger

Step that modifies a trigger or group of triggers.

- `Trigger` (optional) name of a Trigger to be modified. Can be picked by using picker button from list of available Triggers. If left empty, `Group` must be set.

- `Suspended` - wether to set the Trigger or a group in a suspended state.

- `Group` - (optional) name of a group of Triggers to be modified. If left empty, `Trigger` must be set.

- `Turns` - (optional) if the target Trigger is of `Turn` type, set how many turns, counting from now, should it fire.

##### Trigger group

Step that adds or removes Triggers from groups.

- `Trigger` name of a Trigger to be modified. Can be picked by using picker button from list of available Triggers.

- `Group` - name of a group of Triggers.

- `Action` - action to be performed. Can be either `add` or `remove`.

##### Unlock

Step that unlocks the player UI after a cutscene, that was locked with `Lock`. This step has no specific properties.

##### Use ability

Step that makes a unit use it's ability. This can disregard normal ability range limitations.

- `Who` - position of a unit who will use the ability. Can be picked using a picker button.

- `Ability` - name of the ability node. Please refer to the specific unit type scene in source code. 

- `Where` - position where the ability will be used. Can be picked using a picker button.

- `Cooldown` - wether or not the cooldown of the ability should be triggered.

