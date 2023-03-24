#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_easteregg_song;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\zm_genesis_apothicon_fury;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;
#using scripts\shared\ai\zombie_utility;

function lockdown_test()
{
	while (1)
	{
		level flag::wait_till("tele_to_boss_done");
		wait(5);
		SetDvar("ai_DisableSpawn",0);
		thread zm_easteregg_song::play_2D_sound("hide_n_seek");
		ori_zom_count = level.zombie_total;
		level.infinite_spawning_enabled = true;
		level.hellhound_spawning_enabled = true;
		zombie_utility::set_run_speed();
		
		// Edit 0: 	need to exclude mech rounds. 
		// 			May crash internal server during mech rounds!
		// Edit1: 	Clear map of all ai when spawning into bossroom (Dumb idea)
		//			lowers zombie_total count end potentially ends round. Not wanted!
		// Edit2: 	Dog rounds behave... Strange but OK
		
		wait(7);
		zm_ai_dogs::special_dog_spawn(2);
		zm_genesis_apothicon_fury::apothicon_fury_special_spawn();
		s_loc = zm_ai_mechz::get_mechz_spawn_pos();
		wait (49);
		ai = zm_ai_mechz::spawn_mechz( s_loc, 1 );
		waitTillFrameEnd;
		wait (5);
		ai = zm_ai_mechz::spawn_mechz( s_loc, 1 );
		waitTillFrameEnd;
		zm_genesis_apothicon_fury::apothicon_fury_special_spawn();
		zm_genesis_apothicon_fury::apothicon_fury_special_spawn();
		wait (115);
		ai = zm_ai_mechz::spawn_mechz( s_loc, 1 );
		waitTillFrameEnd;
		zm_genesis_apothicon_fury::apothicon_fury_special_spawn();
		zm_genesis_apothicon_fury::apothicon_fury_special_spawn();
		zm_genesis_apothicon_fury::apothicon_fury_special_spawn();
		wait (44);
		
		level.infinite_spawning_enabled = false;
		level.hellhound_spawning_enabled = false;
		
		SetDvar("ai_DisableSpawn",1);
		zoms = GetAISpeciesArray( "axis" ); 
		for( i=0;i<zoms.size;i++ )
		{
			zoms[i] doDamage( zoms[i].health + 666, zoms[i].origin ); 
		}

		level.zombie_total = ori_zom_count;
		wait(20);
		level flag::set("lockdown_end");
		level flag::clear("tele_to_boss_done");
		wait(20);
		SetDvar("ai_DisableSpawn",0);
	}
}

function infinite_spawning() //gets called on every zombie!
{
    if ( IsDefined(level.infinite_spawning_enabled) && IS_TRUE(level.infinite_spawning_enabled) )
    {
        if( zombie_utility::get_current_zombie_count() < level.zombie_ai_limit - 9) // only update if less than the ai limit
        {
            level.zombie_total = level.zombie_ai_limit - 9;
        }

        self waittill("death");
        level.zombie_respawns++; // get ai back in the level faster
    }

	if ( IsDefined(level.hellhound_spawning_enabled) && IS_TRUE(level.hellhound_spawning_enabled) ) 
	{
		rand_int = RandomIntRange(0.5, 1.5);
		if (level.zombie_total < level.zombie_ai_limit - 3)
		{
			wait (rand_int);
			zm_ai_dogs::special_dog_spawn(1);
		}	
		else
		{
			wait (rand_int);
		}
	}
}