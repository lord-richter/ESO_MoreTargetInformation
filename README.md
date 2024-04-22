# ESO_MoreTargetInformation
##More Target Information, an Elder Scrolls Online addon

### Install from:
https://www.esoui.com/downloads/info1189-MoreTargetInformation.html

### Description
This is just a simple addon that changes the target text under the target heath bar to show information about the player and character that are different from what the base game displays.

With nameplates, ZOS has decided on color schemes for NPCs and players. I am changing the color scheme of the target frame to better match the nameplates.

- Friendly NPCs will now display their name in green.
- Justice System NPCs and guards will remain yellow.
- Enemy and hostile targets will remain red.
- Players that are in the ignore list will show as pink, both character and account name, and will show little other information.
- Players will now be a cyan color to better match the nameplates. Friends will be a brighter cyan.
- Guild mates no longer have a green name. Instead, the second line will be green when a guild is shared.
- Players in the same group will be a light blue color that approximates the player group color in the nameplate.

ZOS displays the title before the name on the top line. I have moved the class and race information to the second and have included the title after the name on the top line.

The add-on will take into consideration the setting preference for character name and account name. If the character name is displayed, the target information will not have the account name in it, except for when the player is in the same guild. Guild chat uses account names, so this will be displayed on the second row, before the class and race. Previously, this was on the first row.

ZOS has added the tabard guild information to the nameplates on a second row. Previously, More Target Information did not display what guild the player shared with the target because there could be multiple guilds. With the Dark Brotherhood version of this add-on, the second line of the target will contain a shared guild name. This will be the guild name of the most populated guild shared by both players. The API does not have information about the tabard being worn and this information cannot be displayed in the target frame. If this is ever added to the API, I will switch over to using this.

CHANGE: This addon has been updated to prevent the UI from displaying both the character name and account name in places outside of the target frame. This responds to the preference setting and changes the way the Interact menu works (press F to interact). This will conflict with anything that overrides ZO_GetPrimaryPlayerNameWithSecondary and might not work in all situations.

This addon is probably incompatible with any other addon that touches the TargetUnitFramereticle stuff. This includes several Advanced UI mods, however, some of them can be configured properly if this add on is preferred.

This Add-on is not created by, affiliated with or sponsored by ZeniMax Media Inc. or its affiliates. The Elder Scrolls® and related logos are registered trademarks or trademarks of ZeniMax Media Inc. in the United States and/or other countries. All rights reserved.