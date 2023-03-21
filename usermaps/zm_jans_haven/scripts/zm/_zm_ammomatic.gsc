#using scripts\shared\flag_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_audio;

function MaxAmmo()
{
	wip = GetEnt("trigger_wip","targetname");
    wip SetHintString("This area is under construction!"); 
    wip SetCursorHint("HINT_NOICON"); 
   
    trigger = GetEnt("maxammo_trigger", "targetname");
    trigger SetHintString("You must turn on the Power first!");
    trigger SetCursorHint("HINT_NOICON"); 
    trigger1cost = 25000;

	level flag::wait_till("power_on");

	trigger SetHintString("Press ^3&&1^7 for max ammo. Cost [25000]"); 

	while(1)
	{
		trigger waittill("trigger", player);
		if(player.score >= trigger1cost)
		{
			player zm_score::minus_to_player_score(trigger1cost);
			player PlayLocalSound("zmb_cha_ching");
			level thread zm_powerups::specific_powerup_drop("full_ammo", player.origin);
			wait(5);
		}
		else
		{
			player PlayLocalSound( "zmb_no_cha_ching" );
			//zm_utility::play_sound_at_pos( "no_purchase", player.origin );
			player zm_audio::create_and_play_dialog( "general", "outofmoney" );
		}
	}
}
