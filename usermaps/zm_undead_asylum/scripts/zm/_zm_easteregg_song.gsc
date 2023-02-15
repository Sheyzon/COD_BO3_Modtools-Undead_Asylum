#namespace zm_easteregg_song;

function init()
{
	/*	Editable Variables - change the values in here */
	level.easterEggSong = "song";							// sound alias name for the song
	//level.easterEggTriggerSound = "ee_trigger";				// sound alias name for the sound played when activating a trigger
	level.easterEggTriggerLoopSound = "ee_loop_trigger";	// sound alias name for the loop sound when you are near a trigger
	level.guitar = "guitar";
	level.piano = "piano";
	level.multipleActivations = true;						// whether or not the song can be activated multiple times (true means it can, false means just once)
	level.canBePlayed = true;
	/*	End of Editable Variables - don't touch anything below here */

	setupMusic();
}

function setupMusic()
{
	level.triggersActive = 0;
	triggers = GetEntArray("song_trigger", "targetname");

	foreach(trigger in triggers)
	{
		trigger SetCursorHint("HINT_NOICON");
		trigger UseTriggerRequireLookAt();
		trigger thread registerTriggers(triggers.size);
	}
}

function registerTriggers(numTriggers)
{
	thread guitar_play();
	thread shell_shock_play();

	ent = self play_2D_loop_sound(level.easterEggTriggerLoopSound);

	self waittill("trigger");
	ent delete();
	//self PlaySound(level.easterEggTriggerSound);
	level.triggersActive++;

	if(level.triggersActive >= numTriggers)
		playMusic();
}

function playMusic()
{
	play_2D_sound(level.easterEggSong);

	if(level.multipleActivations)
		setupMusic();
}

function play_2D_sound(sound)
{
	if(level.canBePlayed)
	{
		level.canBePlayed = false;
		temp_ent = spawn("script_origin", (0,0,0));
		temp_ent PlaySoundWithNotify(sound, sound + "wait");
		temp_ent waittill (sound + "wait");
		wait(0.05);
		temp_ent delete();	
		level.canBePlayed = true;
	}
}

function play_2D_loop_sound(sound)
{
	temp_ent = spawn("script_origin", self.origin);
	temp_ent PlayLoopSound(sound);
	return temp_ent;
}

function guitar_play()
{
	trigger = GetEnt("guitar_trigger", "targetname");
	trigger UseTriggerRequireLookAt();
    //trigger SetHintString("Press ^3&&1^7 for song"); // Changes the string that shows when looking at the trigger.
    trigger SetCursorHint("HINT_NOICON"); // Changes the icon that shows when looking at the trigger.

	while(1)
	{
		trigger waittill("trigger", player);
		play_2D_sound(level.guitar);
	}
}

function shell_shock_play()
{
	/*
	trigger = GetEnt("shell_shock", "targetname");
	trigger UseTriggerRequireLookAt();
    trigger SetHintString("Press ^3&&1^7 for song"); // Changes the string that shows when looking at the trigger.
    trigger SetCursorHint("HINT_NOICON"); // Changes the icon that shows when looking at the trigger.
	*/

	//door = GetEnt("lock_door", "targetname")
        
	trigger = GetEnt("shell_shock_trigger_mus", "targetname");

	while(1)
	{
		trigger waittill("trigger", player);
		play_2D_sound(level.piano);
	}
}

