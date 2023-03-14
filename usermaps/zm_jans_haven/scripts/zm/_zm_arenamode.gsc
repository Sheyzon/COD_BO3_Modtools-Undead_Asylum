#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_dogs;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;
#using scripts\shared\ai\zombie_utility;

function lockdown_test()
{
	level flag::wait_till("initial_blackscreen_passed");
	trig = GetEnt("lockdown", "targetname");
	trig SetCursorHint("HINT_NOICON");
	trig SetHintString("Press ^3&&1^7 to start"); 
	SetDvar("ai_DisableSpawn",1);
	trig waittill("trigger", player);

	SetDvar("ai_DisableSpawn",0);
	ori_zom_count = zombie_utility::get_current_zombie_count();

	level.infinite_spawning_enabled = true;
	thread dog_non_stop();
	zombie_utility::set_run_speed();

	trig SetHintString("Press ^3&&1^7 to end lockdown"); 
	trig waittill("trigger", player);
	
	trig SetHintString("Lockdown has ended");
	level.infinite_spawning_enabled = false;

	SetDvar("ai_DisableSpawn",1);
	level flag::set("lockdown_end");
	zoms = GetAISpeciesArray( "axis" ); 
	for( i=0;i<zoms.size;i++ )
	{
		zoms[i] doDamage( zoms[i].health + 666, zoms[i].origin ); 
	}

	trig SetHintString("Press ^3&&1^7 to return spawning"); 
	trig waittill("trigger", player);
	SetDvar("ai_DisableSpawn",0);

	level.zombie_total = ori_zom_count;
}

function dog_non_stop()
{
	level endon( "intermission" );
	
	while (!level flag::get("lockdown_end"))
	{
		rand_int = RandomIntRange(1, 3);
		wait (rand_int);
		zm_ai_dogs::special_dog_spawn(1);
	}
}
