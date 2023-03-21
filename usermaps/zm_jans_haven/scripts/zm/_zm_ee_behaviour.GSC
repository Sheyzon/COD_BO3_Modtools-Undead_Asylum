// Standard Util
#using scripts\shared\flag_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_audio;

//Custom Util
#using scripts\zm\zm_jans_haven;

function bosstrigger()
{
	level flag::wait_till("initial_blackscreen_passed");
    trig = GetEnt("tele_boss_trig","targetname");
	wait(5); //Dirty fix for now
	level flag::set("is_boss_time");
	level flag::clear("is_boss_time");
	level flag::wait_till("summoningkey_done");
	trig SetHintString("Press ^3&&1^7 for bossflag"); 
	while (1)
	{
		trig waittill("trigger", player);
		if (!level flag::get("is_boss_time"))
		{
			level flag::set("is_boss_time");
			trig SetHintString("Press ^3&&1^7: flag is set"); 
		}
		else
		{
			level flag::clear("is_boss_time");
			trig SetHintString("Press ^3&&1^7: flag is not set"); 
		}
	}
}

function buildable_bonfire()
{
	struct = GetEnt("bonfiresword","targetname");
    trig = GetEnt("bonfiresword_trig","targetname");
	model = GetEnt("bonfiresword_model","targetname");
	trig2 = GetEnt("bonfiresword_trig_2","targetname");

    trig SetCursorHint("HINT_NOICON"); 
	trig SetHintString("Press ^3&&1^7 for Part"); 
	trig UseTriggerRequireLookAt();

	trig2 SetCursorHint("HINT_NOICON"); 
	//trig2 UseTriggerRequireLookAt();

	trig waittill("trigger", player);
	player zm_audio::create_and_play_dialog( "general", "pickup" );
	model Delete();
	trig Delete();

	trig2 SetHintString("Press ^3&&1^7 to Place Part"); // Changes the string that shows when looking at the trigger.

	trig2 waittill("trigger", player);
	//struct MoveTo(bonfire_origin.origin, 1, 1, 1);
	struct MoveZ(76.75, 0.01, 0, 0);

	trig2 SetHintString("Press ^3&&1^7 to Light Bonfire"); 

	trig2 waittill("trigger", player);
	trig2 SetHintString(""); 
	player PlaySound("bonfire_lit");
	exploder::exploder("buildable_bonfire_fx");	
	level flag::set( "bbf" );
	//exploder::kill_exploder("alias");

	pos = GetEnt("summoning_key_pos_4","targetname");
	chest = GetEnt("grow_soul4","targetname");
	level flag::wait_till("has_summoning_key");

	bullshit = true;
	while(bullshit)
	{
		trig2 waittill("trigger", player);
		if (!level flag::exists("soulchest_occ") && level flag::exists("has_summoning_key"))
		{
			level flag::set( "soulchest_occ" );
			level flag::delete( "soulchest_done" );
			chest MoveZ(589, 0.01, 0, 0);
			exploder::exploder("collecting_souls_root_fx_4");
			wait(0.01);
			chest MoveZ(80, 1, 0.1, 0.1);
			wait(0.9);
			chest.origin = pos.origin;
			chest thread zm_jans_haven::rotateRandomFull(6,8);
			exploder::exploder("collecting_souls_summoning_fx_4");
			trig Delete();
			bullshit = false;
		}
	}
	level flag::wait_till( "soulchest_done" );
	level flag::set( "soul_trig4" );
	exploder::kill_exploder("collecting_souls_root_fx_4");
	exploder::kill_exploder("collecting_souls_summoning_fx_4");
	PlayFX(level.explodefx, pos.origin);
}

function lit_bonfire()
{
	trig = GetEnt("power_hintstring","targetname");
	trig SetHintString("Ignite the flames"); 
	
	model = GetEnt("power_gate","targetname");
	clip = GetEnt("power_door_gate_clip","targetname");

	level flag::wait_till("bbf");
	level flag::wait_till("bf1");
	level flag::wait_till("bf2");
	level flag::wait_till("bf3");

	//model MoveZ(-69, 1, 0.15, 0.05); //time needs to be at least 1
	model RotateYaw(90, 1);
	
	clip Delete();
	trig Delete();
}

function bonfire_1()
{
	trig = GetEnt("bonfire_trig_1","targetname");
	trig SetCursorHint("HINT_NOICON"); 
	trig SetHintString("Press ^3&&1^7 to Light Bonfire"); 
	trig UseTriggerRequireLookAt();

	trig waittill("trigger", player);

	player PlaySound("bonfire_lit");
	//zm_utility::play_sound_at_pos( "bonfire_lit", player.origin );

	exploder::exploder("bonfire_fire_1");	
	level flag::set( "bf1" );
	trig SetHintString(""); 

	pos = GetEnt("summoning_key_pos_1","targetname");
	chest = GetEnt("grow_soul","targetname");

	level flag::wait_till("has_summoning_key");

	bullshit = true;
	while(bullshit)
	{
		trig waittill("trigger", player);
		if (!level flag::exists("soulchest_occ") && level flag::exists("has_summoning_key"))
		{
			level flag::set( "soulchest_occ" );
			level flag::delete( "soulchest_done" );
			chest MoveZ(329, 0.01, 0, 0);
			exploder::exploder("collecting_souls_root_fx_1");
			wait(0.01);
			chest MoveZ(80, 1, 0.1, 0.1);
			wait(0.9);
			chest.origin = pos.origin;
			chest thread zm_jans_haven::rotateRandomFull(6,8);
			exploder::exploder("collecting_souls_summoning_fx_1");
			trig Delete();
			bullshit = false;
		}
	}
	level flag::wait_till( "soulchest_done" );
	level flag::set( "soul_trig" );
	exploder::kill_exploder("collecting_souls_root_fx_1");
	exploder::kill_exploder("collecting_souls_summoning_fx_1");
	PlayFX(level.explodefx, pos.origin);
}

function bonfire_2()
{
	trig = GetEnt("bonfire_trig_2","targetname");
	trig SetCursorHint("HINT_NOICON"); 
	trig SetHintString("Press ^3&&1^7 to Light Bonfire"); 
	trig UseTriggerRequireLookAt();

	trig waittill("trigger", player);

	player PlaySound("bonfire_lit");
	//zm_utility::play_sound_at_pos( "bonfire_lit", player.origin );

	exploder::exploder("bonfire_fire_2");	
	level flag::set( "bf2" );
	trig SetHintString(""); 

	pos = GetEnt("summoning_key_pos_2","targetname");
	chest = GetEnt("grow_soul2","targetname");
	
	level flag::wait_till("has_summoning_key");

	bullshit = true;
	while(bullshit)
	{
		trig waittill("trigger", player);
		if (!level flag::exists("soulchest_occ") && level flag::exists("has_summoning_key"))
		{
			level flag::set( "soulchest_occ" );
			level flag::delete( "soulchest_done" );
			chest MoveZ(274, 0.01, 0, 0);
			exploder::exploder("collecting_souls_root_fx_2");
			wait(0.01);
			chest MoveZ(80, 1, 0.1, 0.1);
			wait(0.9);
			chest.origin = pos.origin;
			chest thread zm_jans_haven::rotateRandomFull(6,8);
			exploder::exploder("collecting_souls_summoning_fx_2");
			trig Delete();
			bullshit = false;
		}
	}
	level flag::wait_till( "soulchest_done" );
	level flag::set( "soul_trig2" );
	exploder::kill_exploder("collecting_souls_root_fx_2");
	exploder::kill_exploder("collecting_souls_summoning_fx_2");
	PlayFX(level.explodefx, pos.origin);
}

function bonfire_3()
{
	trig = GetEnt("bonfire_trig_3","targetname");
	trig SetCursorHint("HINT_NOICON"); 
	trig SetHintString("Press ^3&&1^7 to Light Bonfire"); 
	trig UseTriggerRequireLookAt();

	trig waittill("trigger", player);
	
	player PlaySound("bonfire_lit");
	//zm_utility::play_sound_at_pos( "bonfire_lit", player.origin );

	exploder::exploder("bonfire_fire_3");	
	level flag::set( "bf3" );
	trig SetHintString(""); 

	pos = GetEnt("summoning_key_pos_3","targetname");
	chest = GetEnt("grow_soul3","targetname");

	level flag::wait_till("has_summoning_key");

	bullshit = true;
	while(bullshit)
	{
		trig waittill("trigger", player);
		if (!level flag::exists("soulchest_occ") && level flag::exists("has_summoning_key"))
		{
			level flag::set( "soulchest_occ" );
			level flag::delete( "soulchest_done" );
			chest MoveZ(913, 0.01, 0, 0);
			exploder::exploder("collecting_souls_root_fx_3");
			wait(0.01);
			chest MoveZ(80, 1, 0.1, 0.1);
			wait(0.9);
			chest.origin = pos.origin;
			chest thread zm_jans_haven::rotateRandomFull(6,8);
			exploder::exploder("collecting_souls_summoning_fx_3");
			trig Delete();
			bullshit = false;
		}
	}
	level flag::wait_till( "soulchest_done" );
	level flag::set( "soul_trig3" );
	exploder::kill_exploder("collecting_souls_root_fx_3");
	exploder::kill_exploder("collecting_souls_summoning_fx_3");
	PlayFX(level.explodefx, pos.origin);
}

function door_drop()
{
	trig = GetEnt("door_drop_trig","targetname");
	trig SetCursorHint("HINT_NOICON");
	trig UseTriggerRequireLookAt();

	trig2 = GetEnt("door_drop_trig_door","targetname");
	trig2 SetCursorHint("HINT_NOICON"); 
	trig2 SetHintString("A key is required");
	
	model = GetEnt("balcony_gate","targetname");
	clip = GetEnt("balcony_clip","targetname");

	trig SetHintString("Press ^3&&1^7 to Pillage crate"); 
	
	level flag::wait_till("initial_blackscreen_passed");
	
	exploder::exploder("ds_door_drop");
	trig waittill("trigger", player);
	player PlayLocalSound("ee_trigger");
	//IPrintLnBold("Door key found");

	thread zm_jans_haven::intro_screen_text("Door key found", undefined, undefined, 20, -280);

	trig Delete();
	exploder::kill_exploder("ds_door_drop");

	wait(1);
	player zm_audio::create_and_play_dialog( "general", "pickup" );
	
	trig2 SetHintString("Press ^3&&1^7 to open gate"); 
	trig2 waittill("trigger", player);
	model MoveZ(-69, 1, 0.15, 0.05);
	clip Delete();
	trig2 Delete();
	level flag::set( "ez6" );
}

function watch_pap_door()
{
	trig = GetEnt("pap_door_trig","targetname");
	trig SetCursorHint("HINT_NOICON"); 
	trig UseTriggerRequireLookAt();
	trig SetHintString("Press ^3&&1^7 to Open Door [Cost: 1000]");
	brushmodel = GetEnt("pap_door","targetname");

	bullshit = false;

	while (!bullshit)
	{
		trig waittill("trigger", player);
		if(player.score >= 1000)
		{
			player zm_score::minus_to_player_score(1500);
			player PlayLocalSound("zmb_cha_ching");
			level flag::set( "pap_flag" );
			trig Delete();
			brushmodel Delete();
			bullshit = true;
		}
		else
		{
			player zm_audio::create_and_play_dialog( "general", "outofmoney" );
		}
	}
}

function drop_summoning_key()
{
	level flag::wait_till("initial_blackscreen_passed");

	trig = GetEnt("drop_trig_1","targetname");
	trig UseTriggerRequireLookAt();

	level flag::wait_till("power_on");

	exploder::exploder("drop_1");
	trig SetHintString("Press ^3&&1^7 to Pillage altar"); 

	trig waittill("trigger", player);

	player PlayLocalSound("ee_trigger");
	thread zm_jans_haven::intro_screen_text("Summoning Key found", undefined, undefined, 20, -280);
	exploder::kill_exploder("drop_1");
	level flag::set("has_summoning_key"); //give summoning key
	trig SetHintString("");

	wait(1);
	
	player zm_audio::create_and_play_dialog( "general", "pickup" );
	level flag::wait_till("soul_trig");
	level flag::wait_till("soul_trig2");
	level flag::wait_till("soul_trig3");
	level flag::wait_till("soul_trig4");
	trig waittill("trigger", player);

	model = util::spawn_model( "script_model", trig.origin );
	fxOrg = util::spawn_model( "tag_origin", trig.origin );
	fx = PlayFxOnTag("dlc1/castle/fx_ritual_key_soul_tgt_igc", fxOrg, "tag_origin" );
	model SetModel("p7_fxanim_zm_zod_summoning_key_centered");
	model thread zm_jans_haven::rotateRandomFull(6,8);
	model MoveZ(50, 1, 0.1, 0.1);
	fxOrg MoveTo(fxOrg.origin + (0,0,50), 1, 0.1, 0.1);
	
	wait(1);
	
	fx = PlayFxOnTag("dlc1/castle/fx_ritual_key_soul_exp_igc", fxOrg, "tag_origin" );
	
	wait(1.5);
	
	fx Delete();
	fxOrg Delete();
	model MoveZ(-50, 1, 0.1, 0.1);
	
	wait(1);
	
	fxOrg = util::spawn_model( "tag_origin", trig.origin );
	fx = PlayFxOnTag("dlc1/castle/fx_ritual_key_soul_tgt_igc", fxOrg, "tag_origin" );
	trig SetHintString("Press ^3&&1^7 to pick up"); 
	
	trig waittill("trigger", player);
	
	level flag::set("summoningkey_done");
	trig Delete();
	model Delete();
	fx Delete();
	fxOrg Delete();
}

function asylumEntrance()
{
	clip = GetEnt("door_clip","targetname");
	door_rt_1 = GetEnt("door_rt_01","targetname");
	door_rt_2 = GetEnt("door_rt_02","targetname");

	door_lt_1 = GetEnt("door_lt_01","targetname");
	door_lt_2 = GetEnt("door_lt_02","targetname");

    trig = GetEnt("bf_trig","targetname");
    trig SetHintString("Press ^3&&1^7 to Open Door [Cost: 1500]"); 
    trig SetCursorHint("HINT_NOICON"); 
	
	bullshit = false;

	while (!bullshit)
	{
		trig waittill("trigger", player);
		if(player.score >= 1500)
		{
			player zm_score::minus_to_player_score(1500);
			player PlayLocalSound("zmb_cha_ching");
			level flag::set( "ez3" );

			door_rt_1 RotateYaw(-120, 1);
			door_rt_2 RotateYaw(-120, 1);
			door_lt_1 RotateYaw(120, 1);
			door_lt_2 RotateYaw(120, 1);

			clip Delete();
			trig Delete();
			bullshit = true;
		}
		else
		{
            player PlayLocalSound( "zmb_no_cha_ching" );
			player zm_audio::create_and_play_dialog( "general", "outofmoney" );
		}
	}
}

function MonitorPower()
{
	level flag::wait_till("initial_blackscreen_passed");
	//level util::set_lighting_state(1);

	model = GetEnt("doe","targetname");
	clip = GetEnt("doe_clip","targetname");	
	trig = GetEnt("doe_hintstring","targetname");
    trig SetHintString("Locked by some contraption"); 
    trig SetCursorHint("HINT_NOICON"); 

	level flag::wait_till("power_on");
	//level thread scene::play( "power_switch", "targetname" );

	exploder::exploder("ammo_light");
	
	model MoveZ(-69, 1, 0.15, 0.05);
	clip Delete();
	trig Delete();
	
	// level thread scene::play( "fxanim_diff_engine_tele_rt", "targetname" );
	// level thread scene::play( "fxanim_diff_engine_tele_lt", "targetname" );
	//level util::set_lighting_state(0);
}

function wolf_bow_()
{
	level flag::wait_till("initial_blackscreen_passed");
	istriggered = true;
	trig = GetEnt("wolf_bow_trig", "targetname");
	pos = GetEnt("wolf_arrow_pos", "targetname");
	fxStart = GetEnt("fxOrg", "targetname");
	fxEnd = GetEnt("fxEnd", "targetname");
	arrow_model = GetEnt("wolf_arrow", "targetname");
	arrow_trig = GetEnt("wolf_arrow_trig", "targetname");
	arrow_trig SetCursorHint( "HINT_NOICON" );

	desiredweapon = getWeapon("elemental_bow"); // Weapon you want the player to have when shot

    while(istriggered)
    {        
        trig waittill( "trigger", player );
        current_weapon = player getCurrentWeapon();
		
        
        if( current_weapon == desiredweapon )
        {
			arrow_model MoveZ(41, 1, 0.1, 2);
			exploder::exploder("wolf_painting_fx");
			wait(1);
			exploder::exploder("wolf_arrow_fx");
			arrow_model.origin = pos.origin;
			arrow_trig SetHintString("Press ^3&&1^7 to pick up arrow"); 
			arrow_trig waittill( "trigger", player );
			arrow_model MoveZ(-41, 1, 0.1, 0.1);
			player.has_arrow = "has_wolf_arrow";
			level flag::set( "player_has_wolf_arrow" );
			player PlayLocalSound("ee_trigger");
			player zm_audio::create_and_play_dialog( "general", "pickup" );
			exploder::kill_exploder("wolf_arrow_fx");
			arrow_trig SetHintString(""); 
			istriggered = false;
        }
		wait(1);
    }
	level flag::wait_till("soul_catchers_charged");
	arrow_trig SetHintString("Press ^3&&1^7 to use this twigger"); 
	exploder::exploder("wolf_recive_arrow_fx");
	arrow_trig waittill( "trigger", player );
	arrow_trig SetHintString(""); 
	exploder::kill_exploder("wolf_recive_arrow_fx");
	fxOrg = util::spawn_model( "tag_origin", fxStart.origin );
	fx = PlayFxOnTag("dlc1/zmb_weapon/fx_bow_wolf_arrow_trail_zmb", fxOrg, "tag_origin" );
	time = Distance(fxStart.origin,fxEnd.origin)/100;
	fxOrg MoveTo(fxEnd.origin,time);
	wait(time - .05);
	fxOrg moveto(fxEnd.origin, .5);
	fxOrg waittill("movedone");
	fx = PlayFxOnTag("dlc1/zmb_weapon/fx_bow_wolf_impact_ug_zmb", fxOrg, "tag_origin" );
	
	wait(1);

	fxOrg MoveTo(fxStart.origin,time);
	fxOrg waittill("movedone");
	fx Delete();
	arrow_model MoveZ(41, 1, 0.1, 0.1);
	wait(1);
	arrow_trig SetHintString("Press ^3&&1^7 to pickup"); 
	exploder::exploder("wolf_arrow_fx");
	arrow_model.origin = pos.origin;
	arrow_trig waittill( "trigger", player );
	arrow_trig Delete();
	arrow_model Delete();
	exploder::kill_exploder("wolf_arrow_fx");
	exploder::kill_exploder("wolf_painting_fx");
	level flag::set("wolf_arrow_done");
}
