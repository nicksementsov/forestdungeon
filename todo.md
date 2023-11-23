# To do:
	
	* Add a key item and implement locked doors that need a key
	* Implement a weapon swing animation

# Known Issues:

# Journal:

September 5th, 2023:

	Added basic pause functionality. 
	
February 18th, 2023:

	Fixed a crash bug that was a result of removing the level by way of using remove_child(current_level), now
	using current_level.queue_free()

	Implemented the ability for the player to lose and gain health

	Figured out a simpler way to check what door the player is standing in, and that they are actually standing in it, by including the area2d in the area entered signal

	Implemented a basic heart (health) pickup, and a check to make sure player.health doesn't go below zero
	or a predifined maximum

February 17th, 2023:

	Implemented a simple UI that shows how many hearts the player has