# Tanks of Freedom 3D
## Changelog

### 1.0.0-rc
- Medkit and Repair Kit abilities now grant exp to the unit
- Repair Kit ability costs less on higher levels
- Hero level up bonuses rebalanced:
  - armor bonus at lvl 1
  - movement bonus at lvl 2
  - ability cooldown bonus at lvl 3
- Shortened cooldown on some hero abilities
- Lowered some ability SFX volume
- Fixed a possible team detection bug
- Fixed a dialogue issue in Prologue
- Fixed some dialogue issues in campaigns
- Fixed a no moves popup after loading saved game and ending turn

### 0.7.0-alpha
- New Skirmish mode maps
  - `2p_cityscape`
  - `2p_oasis`
  - `2p_forlorn`
  - `3p_arrowhead`
  - `3p_nexus`
  - `3p_isle`
  - `4p_oasis2`
  - `4p_cross`
  - `4p_ridge`
- Renamed existing Skirmish mode maps
  - `crossroad` is now `2p_crossroad`
  - `crossroad2` is now `4p_crossroad2`
  - `split2` is now `2p_split2`
- Removed new units and level ups from `2p_crossroad` to make it closer to ToF 1 classic
- Added unit healthbars and level stars
- Mobile Infantry Medkit ability rebalanced
  - Ability now available at level 0 for 5AP
  - Ability now free at level 1
- Added more blur for tilt-shift effect near max camera zoom
- Added new cover maps for campaigns
- Added story editor to map editor allowing to create scenarios
  - Additional map settings
  - Triggers editor
  - Stories editor
  - Documentation added to MANUAL.md
- Added new content suppression for maps created with older editor version
  - New abilities need to be marked with proper dlc version
- Added Credits screen
- Fixed a bug causing AI to stop working, freezing the turn
- Fixed a bug preventing online maps from being downloaded


### 0.6.1-alpha
- Fixed Infantry unit having wrong side when dropped from Attack Helicopter
- Attempted fix for units getting visually misaligned when moved (again)
- Fixed missing unit spawn sounds in campaign cutscenes
- Fixed SteamOS detection

### 0.6.0-alpha
- Updated Godot Engine to 4.2
- Added Online multiplayer via relay server
  - Added options to configure custom address for online servers
- LAN multiplayer can now have AI players
- Settings are now available during gameplay
  - Some settings that required map load to apply now apply instantly
- Added screen edge camera pan
- Added camera drag with righ mouse button
  - Camera mouse drag tweaks to match it better to cursor movement
- Added new hover menu for mouse controls
  - end turn button
  - show unit stats button
  - open unit skills button
  - open building button
- Added ending turn speed option in Settings
- Added end turn confirmation when player made no moves
- Added 90 FPS option for Deck OLED
- Radial menu now closes when clicked away
- Added new tiles to editor
- Fixed missing option descriptions in Settings
- Fixed a bug that would lock out custom maps in Skirmish mode after a map in multiplayer mode has been picked
- Fixed a bug preventing units from being unbanned in buildings
- Fixed a camera mouse drag bug when closing unit stats popup by clikcing the button
- Fixed an AI camera bug that would sometimes cause it to fail to show actions
- Attempted fix for units getting visually misaligned when moved

### 0.5.0-alpha
- Ported game project to Godot Engine 4
- New menus and UI look
- LAN multiplayer
- Most heroes will now use their active abilities when commanded by AI
- Added new tiles
  - city shops
  - railways
  - statues
  - tree alleys
  - city housing
  - farms
  - walls
- Various cosmetic updates to all campaigns using new tiles
- Campaign can now override mission selection map image
- Story messages can now define font size
- Story messages can now play audio samples
- Updated sound effects
- Added dust particle effect to units
- Fixed a team designation bug that made Tutorial 2 getting stuck
- Fixed a mouse camera drag bug
- Reduced instances AI failing to move and locking up
- Splash screen resolution matched to the game logo

### 0.4.0-alpha
- Added Amber Noon campaign
- Added Epilogue
- Added new tiles
- Added castle wall tiles
- Improvements to story triggers
- AP story step can now cap at value
- AI tether for units that need to stay in one area for story reasons
- Split editor terrain category into nature and construction
- Fixed a bug where message actor would be in desat state when assigned a custom colour
- Fixed a crash that would occure when player quits a last mission in a campaign without winning it
- Fixed an issue where hero passive effect would not be reassigned to new side when he changed sides using story step

### 0.3.1-alpha
- Cleaned-up Settings window
- Added on-screen controls help
- Fixed a bug with game going into auto-fullscreen and offseting mouse
- Fixed a bug with selection box jitter when using gamepad and having mouse cursor on-screen

### 0.3.0-alpha
- Added Jade Twilight campaign
- Added teams to gameplay
- Added mission objectives
- Added map frame
- Added simple game intro
- Added fake skybox
- Added Obsidian Night faction
- Added variety of new tiles
- Added translations funcionality
- Added Polish language
- Added Truck units for stories
- Added Lighthouse neutral Tower
- Added Saving and Loading, with autosaves
- Added online map sharing
- Added ToF 1 map import
- Story scripting improvements
- AI rebalance and improvements
- Restart mission function
- Various board UI improvements and notifications
- Various main menu UI controls improvements
- AI hero buying fix
- Multiple bug fixes

### 0.2.0-alpha
- Sapphire Dawn campaign
- Story scripting improvements
- More settings for the game
- Steam Deck optimised settings
- Editor quicksave
- Variety of new tiles
- Flags for Hero and NPC units for visibility
- Draw active abilities range
- Changed hero passives so all of them apply at the same time instead of just one
- Unit stats UI improvements
- Campaign selection UI improvements
- Memory leakage fixes

### 0.1.0-alpha
- Basic gameplay established
- Provisional main menu
- Functional map editor
- Functional AI
- Skirmish game mode
- Tutorial campaign
- Prologue campaign
- Ruby Dusk campaign
- Controls list
