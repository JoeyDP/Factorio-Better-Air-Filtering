# Better Air Filtering
#### A mod for Factorio that provides complex air filtering steps to remove pollution.
Based on the [air filtering mod](https://mods.factorio.com/mod/air-filtering) by [Schorty](https://mods.factorio.com/user/Schorty).

## Overview
![overview](https://github.com/JoeyDP/Factorio-Better-Air-Filtering/blob/master/res/setup.gif?raw=true)

This mod features three tiers of air filtering machines. These machines remove pollution from the air in their region by using air filters. Each consecutive tier has a larger radius and stronger filtering effect. Keep in mind that you will still need filters spread around your base at strategic locations to effectively counteract the spread of pollution.  

### Air filter machine 1
You start with a basic passive air filter machine that cleans the air in its own [chunk](https://wiki.factorio.com/Map_structure#Chunk). It should help keep biter attacks at bay through the early game.

### Air filter machine 2
The upgraded version has a stronger filtering effect. In addition, by using a moderate amount of electricity this machine is able to pull in pollution from neighboring chunks in the shape of a diamond. This version has a radius of two chunks (in [manhattan distance](https://en.wikipedia.org/wiki/Taxicab_geometry)). Note that a continuous amount of energy is consumed for this suction effect in addition to the cost of filtering the air.

![range_mark_2](https://github.com/JoeyDP/Factorio-Better-Air-Filtering/blob/master/res/radius_mk2.png?raw=true)

### Air filter machine 3
The third and final upgrade of the air filtering machine features a larger radius of three chunks along with more air filtering per second.

### Filter Types
There are currently two types of filters: __expendable filters__ and __recyclable filters__. The first ones are easier to craft, but filter out less pollution and are destroyed upon use. Recyclable filters are more expensive but can be refreshed with a bit of coal to be used again. However, beware that there is a slight chance the filter breaks in the recycling process.

> Known issue: used air filters cannot be extracted from the first tier of air filter machines by inserters. Factorio does not feature inserters that can extract from burnt_result_inventory.


## Technical Details
Some things to keep in mind when using this mod:

 - Pollution updates are very UPS efficient. The suction of pollution is implemented per chunk, rather than per machine and updates are spread evenly over an interval of 20 ticks (default). The interval can be changed in the settings.
 - The [evolution](https://wiki.factorio.com/Enemies#Evolution) factor of enemies is based on the total amount of produced pollution. Cleaning it back up does not reverse this effect. This means that biters will still get stronger, no matter how proficient you are at cleaning pollution. You can prevent attacks caused by pollution reaching the biter nests however.
 - Pollution from other chunks is sucked toward air filters at an exponentially decreasing rate depending on the distance. The formula is `suction = base_suction * (1/4)^distance`. This means that filters only pull in approximately as much pollution as they can filter.
 - When an air filter machine or any other entity containing pollution is destroyed or mined, the pollution inside is dispersed back into the atmosphere.


## Changes
Refer to the Factorio mod page for the complete [changelog](https://mods.factorio.com/mod/better-air-filtering/changelog).


## Future Features
 - A third and more efficient air filtering production chain based on first "dissolving" pollution in water and then treating it in chemical plants.
 - Support for signals, and a potential integration with https://mods.factorio.com/mod/pollution-detector.

## Bugs / Crashes / Suggestions
> Important! This mod is in it's early stages of development and has not yet been extensively tested and balanced.

If you experience issues, please notify me on the [forum](https://mods.factorio.com/mod/better-air-filtering/discussion). Suggestions for future releases are also welcome.

## Contribute
First and foremost, suggestions for balancing changes or new features are greatly appreciated. If you create a nice setup with this mod, feel free to share some screenshots or gifs as well. This can be done on the [forum](https://mods.factorio.com/mod/better-air-filtering/discussion) or via [PM](https://forums.factorio.com/ucp.php?i=pm&mode=compose&u=75847).
Changes in the code can be suggested through a pull request on [github](https://github.com/JoeyDP/Factorio-Better-Air-Filtering).
