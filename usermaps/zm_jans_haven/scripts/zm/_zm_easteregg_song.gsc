#namespace zm_easteregg_song;

function init()
{
	/*	Editable Variables - change the values in here */
	level.easterEggSong = "mydemons";							// sound alias name for the song
	level.easterEggTriggerSound = "ee_trigger";				// sound alias name for the sound played when activating a trigger
	level.easterEggTriggerLoopSound = "ee_loop_trigger";	// sound alias name for the loop sound when you are near a trigger
	level.som = "soundofmadness";
	level.eym = "ease_your_mind";
	level.bmth = "bring_me_the_horizon";
	level.dov = "dawn_of_victory";
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
	thread ease_your_mind();
	thread sound_of_madness();
	thread bring_me_the_horizon();
	thread dawn_of_victory();

	ent = self play_2D_loop_sound(level.easterEggTriggerLoopSound);

	self waittill("trigger");
	ent delete();
	self PlaySound(level.easterEggTriggerSound);
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

function ease_your_mind()
{
	trigger = GetEnt("ease_your_mind_gwn", "targetname");
	trigger UseTriggerRequireLookAt();

	while(1)
	{
		trigger waittill("trigger", player);
		play_2D_sound(level.eym);
	}
}


function bring_me_the_horizon()
{
	trigger = GetEnt("bring_me_the_horizon", "targetname");

	while(1)
	{
		trigger waittill("trigger", player);
		play_2D_sound(level.bmth);
	}
}


function sound_of_madness()
{ 
	trigger = GetEnt("sound_of_madness", "targetname");

	while(1)
	{
		trigger waittill("trigger", player);
		play_2D_sound(level.som);
	}
}

function dawn_of_victory()
{ 
	trigger = GetEnt("dawn_of_victory", "targetname");

	while(1)
	{
		trigger waittill("trigger", player);
		play_2D_sound(level.dov);
	}
}
