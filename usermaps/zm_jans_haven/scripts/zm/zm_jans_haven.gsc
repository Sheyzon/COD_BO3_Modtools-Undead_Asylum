#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\lilrobot\_inspectable_weapons;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\_zm_score;

#using scripts\shared\ai\zombie_utility;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_perk_vulture_aid;
#using scripts\zm\_zm_perk_whoswho;
#using scripts\zm\_zm_perk_tombstone;
#using scripts\zm\_zm_perk_phdflopper;
#using scripts\zm\_zm_perk_elemental_pop;
#using scripts\zm\_zm_perk_random;

// MECHZ ZOMBIE
#using scripts\zm\_zm_ai_mechz;

// BO3 WEAPONS
#using scripts\zm\craftables\_hb21_zm_craft_blundersplat;
#using scripts\zm\_hb21_zm_weap_blundersplat;
#using scripts\zm\_hb21_zm_weap_magmagat;

//BOWS
#using scripts\zm\_zm_weap_elemental_bow;
#using scripts\zm\_zm_weap_elemental_bow_storm;
#using scripts\zm\_zm_weap_elemental_bow_rune_prison;
#using scripts\zm\_zm_weap_elemental_bow_wolf_howl;
#using scripts\zm\_zm_weap_elemental_bow_demongate;

#using scripts\zm\_t9_wonderfizz;

#using scripts\zm\_zm_bgb_machine;

//Powerups
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_ancient_evil_challenges;
//#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_hb21_zm_magicbox;

#using scripts\zm\_zm_easteregg_song;

//Traps
#using scripts\zm\_zm_trap_electric;

// Sickle
#using scripts\zm\_zm_melee_weapon;

// WW2 Power Switch
#using scripts\fanatic\ww2\ww2_power_switch;

#using scripts\zm\zm_usermap;

#using scripts\_NSZ\nsz_kino_teleporter;
#using scripts\Sphynx\craftables\_zm_craft_vineshield;
#using scripts\zm\zm_wolf_soul_colletors;
#using scripts\zm\_hb21_zm_behavior;

// Giant ZombieMGR
#using scripts\zm\zm_giant_cleanup_mgr;
#using scripts\_redspace\rs_o_jump_pad;
#using scripts\zm\growing_soulbox;

// Sphynx's Buyable Perk Slot
#using scripts\Sphynx\_zm_perk_increment;

//SG4Y & MR.Lednor’s BW Vision,
#using scripts\zm\lednors_black_and_white;

#using scripts\zm\_zm_arenamode;

//-----FX Cache-----
#precache( "fx", "dlc2/island/fx_fire_spot_xxsm_island" );
#precache( "fx", "zombie/fx_perk_quick_revive_factory_zmb" );
#precache( "fx", "zombie/fx_perk_sleight_of_hand_factory_zmb" );
#precache( "fx", "zombie/fx_barrier_buy_zmb" );
#precache( "fx", "zombie/fx_elec_gen_idle_sm_zmb" );
#precache( "fx", "zombie/fx_elec_gen_tip_zmb" );
#precache( "fx", "lensflares/fx_lensflare_light_warm_sm" );
#precache( "fx", "lensflares/fx_lensflare_grime01" );
#precache( "fx", "dlc2/island/fx_fog_ground_thin_lg_island" );
#precache( "fx", "dlc2/island/fx_fog_ground_lg_island" );
#precache( "fx", "dirt/fx_dust_motes_200x200_pcloud" );
#precache( "fx", "dlc1/castle/fx_ritual_key_soul_exp_igc" );
#precache( "fx", "dlc1/zmb_weapon/fx_bow_wolf_arrow_trail_zmb" );
#precache( "fx", "dlc1/zmb_weapon/fx_bow_wolf_impact_ug_zmb" );
#precache( "fx", "dlc1/castle/fx_ritual_key_soul_tgt_igc" );

#define QUICK_REVIVE_MACHINE_LIGHT_FX                       "revive_light"
#define SLEIGHT_OF_HAND_MACHINE_LIGHT_FX                    "sleight_light"
#define ADDITIONAL_PRIMARY_WEAPON_MACHINE_LIGHT_FX          "additionalprimaryweapon_light"

//*****************************************************************************
// MAIN
//*****************************************************************************

function main()
{	
	inspectable::add_inspectable_weapon( GetWeapon("iw8_scar_pdw"), 5.13 );
	inspectable::add_inspectable_weapon( GetWeapon("iw8_scar_pdw_up"), 5.13 );
	inspectable::add_inspectable_weapon( GetWeapon("iw8_uzi"), 4.66 );
	inspectable::add_inspectable_weapon( GetWeapon("iw8_uzi_up"), 4.66 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_nail_gun"), 5.63 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_nail_gun_up"), 5.63 );
	inspectable::add_inspectable_weapon( GetWeapon("iw8_aug_smg"), 5.13 );
	inspectable::add_inspectable_weapon( GetWeapon("iw8_aug_smg_up"), 5.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ray_gun"), 2.76 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ray_gun_up"), 2.76 );
	
	callback::on_ai_spawned(&_zm_arenamode::infinite_spawning);
	
	level thread nsz_kino_teleporter::init(); 
	level.randomize_perk_machine_location = false; // set before zm_usermap::main 
 	level.dog_rounds_allowed=1; // set before zm_usermap::main

	zm_usermap::main();
	ww2_power_switch::init();

	level.enemy_location_override_func = &enemy_location_override;
	level.no_target_override = &no_target_override;

	// Stielhandgranate
	zm_utility::register_lethal_grenade_for_level( "frag_grenade_potato_masher" );
	level.zombie_lethal_grenade_player_init = GetWeapon( "frag_grenade_potato_masher" );

	// Sickle
	zm_melee_weapon::init( "sickle_knife", "sickle_flourish", "knife_ballistic_sickle", "knife_ballistic_sickle_upgraded", 3000, "sickle_upgrade", "Hold ^3[{+activate}]^7 for Sickle [Cost: 3000]", "sickle", undefined );

	level._zombie_custom_add_weapons =&custom_add_weapons;

	//-----StartingWeapon-----
	level.start_weapon = (getWeapon("melee_katana"));
	level.explodefx = "dlc1/castle/fx_ritual_key_soul_exp_igc";
	level thread MonitorPower();
	//-----Perklimit-----
	level.perk_purchase_limit = 4;

	// Last Stand Weapon
	lastStandWeapon = "t9_nail_gun_up";
	level.default_laststandpistol = getWeapon(lastStandWeapon);
	level.default_solo_laststandpistol = getWeapon(lastStandWeapon);

	level._zombie_custom_add_weapons =&custom_add_weapons;
	level.pack_a_punch_camo_index = 121;
    level.pack_a_punch_camo_index_number_variants = 4;

	level._effect[QUICK_REVIVE_MACHINE_LIGHT_FX]                = "zombie/fx_perk_quick_revive_factory_zmb";
	level._effect["poltergeist"]								= "zombie/fx_barrier_buy_zmb";
	
	//Setup the levels Zombie Zone Volumes
	level.zones = [];
	level.zone_manager_init_func =&asylum_zone_init;
	init_zones[0] = "start_zone";
	init_zones[1] = "jump";
	init_zones[2] = "jump_4";
	init_zones[3] = "firelink_shrine";
	init_zones[4] = "secret_tp_room_1";
	init_zones[5] = "boss_room";
	level thread zm_zonemgr::manage_zones( init_zones );

	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_genesis_vox.csv");
	thread zm_easteregg_song::init();
	thread zombie_limit_increase(28, 10);

	level thread intro_screen_text("Lordran", "13th - 15th Century", "Northern Undead Asylum", 120, -50);
	level thread intro_screen_text("Music is on", "The music slider!", undefined, 20, -350);

	thread asylumEntrance();
	thread buildable_bonfire();
	thread MaxAmmo();
	thread lit_bonfire();
	thread door_drop();
	thread drop_summoning_key();
	thread bonfire_1();
	thread bonfire_2();
	thread bonfire_3();
	thread watch_pap_door();
	thread wolf_bow_();
	thread _zm_arenamode::lockdown_test();
	thread bosstrigger();

	level.player_starting_points = 50000;

	players = GetPlayers();
	players[0].has_arrow = "";
	players[1].has_arrow = "";
	players[2].has_arrow = "";
	players[3].has_arrow = "";

	SetDvar("ai_DisableSpawn",0);

	level.pathdist_type = PATHDIST_ORIGINAL;

	grow_soul::init(  );
}

function asylum_zone_init()
{
	zm_zonemgr::add_adjacent_zone( "start_zone", "start_hallway_zone", "ez1");
	zm_zonemgr::add_adjacent_zone( "start_hallway_zone", "start_hallway_zone_2", "ez1");
	zm_zonemgr::add_adjacent_zone( "start_hallway_zone_2", "jumpad_lower", "ez2");

	zm_zonemgr::add_adjacent_zone( "jumpad_lower", "jumpad_upper", "ez2");

	zm_zonemgr::add_adjacent_zone( "jumpad_upper", "southwing_lower", "ez2");
	zm_zonemgr::add_adjacent_zone( "southwing_lower", "main_room", "ez3");

	zm_zonemgr::add_adjacent_zone( "main_room", "pap", "pap_flag");
	zm_zonemgr::add_adjacent_zone( "main_room", "pap2", "pap_flag");
	zm_zonemgr::add_adjacent_zone( "pap", "pap2", "pap_flag");
	
	zm_zonemgr::add_adjacent_zone( "main_room", "westwing_middle", "ez4");
	zm_zonemgr::add_adjacent_zone( "main_room", "westwing_staircase_01", "ez4");
	zm_zonemgr::add_adjacent_zone( "westwing_staircase_01", "westwing_middle", "ez4");
	zm_zonemgr::add_adjacent_zone( "westwing_middle", "westwing_staircase_02", "ez4");
	
	zm_zonemgr::add_adjacent_zone( "westwing_staircase_02", "Southwing_upper_middle", "ez5");

	zm_zonemgr::add_adjacent_zone( "Southwing_upper_middle", "southwing_upper_filler_01", "ez5");
	zm_zonemgr::add_adjacent_zone( "Southwing_upper_middle", "southwing_upper_filler_02", "ez5");
	zm_zonemgr::add_adjacent_zone( "Southwing_upper_middle", "southwing_stairs_upper_oposite", "ez5");
	zm_zonemgr::add_adjacent_zone( "Southwing_upper_middle", "southwing_stairs_upper", "ez5");
	zm_zonemgr::add_adjacent_zone( "Southwing_upper_middle", "southwing_sideroom", "ez5");
	zm_zonemgr::add_adjacent_zone( "Southwing_upper_middle", "jump");
	zm_zonemgr::add_adjacent_zone( "southwing_stairs_upper", "southwing_stairs_lower", "ez5");
	zm_zonemgr::add_adjacent_zone( "southwing_stairs_upper", "southwing_sideroom", "ez5");

	zm_zonemgr::add_adjacent_zone( "southwing_stairs_upper", "balcony_lt", "ez6");
	zm_zonemgr::add_adjacent_zone( "balcony_mdl", "balcony_lt", "ez6");
	zm_zonemgr::add_adjacent_zone( "balcony_mdl", "power_room", "ez6");
	zm_zonemgr::add_adjacent_zone( "balcony_mdl", "power_room_tunnel", "ez6");
	zm_zonemgr::add_adjacent_zone( "power_room", "power_room_tunnel", "ez6");
	zm_zonemgr::add_adjacent_zone( "balcony_mdl", "jump_2");
}

function bosstrigger()
{
    trig = GetEnt("tele_boss_trig","targetname");
	trig SetHintString("Press ^3&&1^7 for bossflag"); 
	trig waittill("trigger", player);
	trig SetHintString("Press ^3&&1^7: flag is set"); 
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
			chest thread rotateRandomFull(6,8);
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
			chest thread rotateRandomFull(6,8);
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
			chest thread rotateRandomFull(6,8);
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
			chest thread rotateRandomFull(6,8);
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

	thread intro_screen_text("Door key found", undefined, undefined, 20, -280);

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
	trig SetHintString("Mach Summoning Key du Opfer"); 
	
	brushmodel = GetEnt("pap_door","targetname");

	level flag::wait_till("summoningkey_done");

	trig SetHintString("Drück ^3&&1^7 Um des scheiß Brushmodel verschwinden zu lassen wie es dein Vater einst tat");
	trig waittill("trigger", player);

	trig Delete();
	brushmodel Delete();

	level flag::set( "pap_flag" );
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
	thread intro_screen_text("Summoning Key found", undefined, undefined, 20, -280);
	exploder::kill_exploder("drop_1");
	level flag::set("has_summoning_key"); //give summoning key
	trig SetHintString("");

	wait(1);
	
	player zm_audio::create_and_play_dialog( "general", "pickup" );
	//level flag::wait_till("soul_trig");
	//level flag::wait_till("soul_trig2");
	//level flag::wait_till("soul_trig3");
	//level flag::wait_till("soul_trig4");
	trig waittill("trigger", player);

	model = util::spawn_model( "script_model", trig.origin );
	fxOrg = util::spawn_model( "tag_origin", trig.origin );
	fx = PlayFxOnTag("dlc1/castle/fx_ritual_key_soul_tgt_igc", fxOrg, "tag_origin" );
	model SetModel("p7_fxanim_zm_zod_summoning_key_centered");
	model thread rotateRandomFull(6,8);
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
			player zm_audio::create_and_play_dialog( "general", "outofmoney" );
		}
	}
}

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
		// Purchase Code
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

function usermap_test_zone_init()
{
	level flag::init( "always_on" );
	level flag::set( "always_on" );
}	

function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_levelcommon_weapons.csv", 1);
}

/*
With trigger "buyable_powerup_trig", "targetname"
and struct "powerup_spawn", "targetname"
function buyable_powerup()
{
	level.buyable_powerup_cost = 100; // Cost for powerup
	level.buyable_powerup_cooldown = 20; // Cooldown in seconds for buyable trigger
	while(1)
	{
		while(1)
		{
			buyable_powerup_trig = GetEnt("buyable_powerup_trig", "targetname");	
			buyable_powerup_trig SetHintString("Press and hold &&1 to spawn Powerup [Cost: " + level.buyable_powerup_cost + "]");
			buyable_powerup_trig SetCursorHint("HINT_NOICON");
			buyable_powerup_spawn = struct::get( "powerup_spawn", "targetname" );
			buyable_powerup_trig waittill("trigger", player);

			if(player.score >= level.buyable_powerup_cost)
			{
				player zm_score::minus_to_player_score(level.buyable_powerup_cost);

				break;
			}
		}

		
		//	If you want a specific powerup, then uncomment the buyable_powerup_spawn below and delete or comment out the one above it.
		//	Available Powerups: double_points, free_perk, full_ammo, nuke, fire_sale, carpenter, insta_kill, shield_charge, bonfire_sale,
		

		buyable_powerup_spawn thread zm_powerups::special_powerup_drop(buyable_powerup_spawn.origin);
		//buyable_powerup_spawn thread zm_powerups::specific_powerup_drop("full_ammo", buyable_powerup_spawn.origin);

		buyable_powerup_trig SetHintString("Recharing...");

		wait(level.buyable_powerup_cooldown);
	}
}
*/

function enemy_location_override( zombie, enemy )
{
	AIProfile_BeginEntry( "factory-enemy_location_override" );

	if ( IS_TRUE( zombie.is_trapped ) )
	{
		AIProfile_EndEntry();
		return zombie.origin;
	}

	AIProfile_EndEntry();
	return undefined;
}

// model thread zm_sphynx_util::rotateRandomFull(6, 8);
function rotateRandomFull(rotateSpeedMin = 6, rotateSpeedMax = 7){
    while(isdefined(self)){
        rotationSpeed = RandomIntRange(rotateSpeedMin, rotateSpeedMax);
        self RotateYaw(360, rotationSpeed);
        wait rotationSpeed;
    }
}

function zombie_limit_increase( base_limit, increase_by )
{
    level endon( "end_game" );
    while ( isdefined( self ) )
    {
        level waittill( "start_of_round" );
        
        level.zombie_actor_limit = base_limit + (increase_by * GetPlayers().size);
        level.zombie_ai_limit = base_limit + (increase_by * GetPlayers().size);
    }
}

function intro_screen_text(text_1 = "", text_2 = "", text_3 = "", _x, _y)
{
	if (_x == 120 || text_1 == "Music is on")
	{
		wait(1); // wait for flags to init
		level flag::wait_till("initial_blackscreen_passed");
		wait(2);

		if (text_1 == "Music is on")
			wait(4);
	}

    intro_hud = [];
    str_text = Array( text_1, text_2, text_3 ); // Edit these lines to say what you want

    for ( i = 0; i < str_text.size; i++ )
    {
        intro_hud[i] = NewHudElem();
        intro_hud[i].x = _x;		//20
        intro_hud[i].y = _y + ( 20 * i ); // -250
        intro_hud[i].fontscale = ( IsSplitScreen() ? 2.75 : 1.75 );
        intro_hud[i].alignx = "LEFT";
        intro_hud[i].aligny = "BOTTOM";
        intro_hud[i].horzalign = "LEFT";
        intro_hud[i].vertalign = "BOTTOM";
        intro_hud[i].color = (1.0, 1.0, 1.0);
        intro_hud[i].alpha = 1;
        intro_hud[i].sort = 0;
        intro_hud[i].foreground = true;
        intro_hud[i].hidewheninmenu = true;
        intro_hud[i].archived = false;
        intro_hud[i].showplayerteamhudelemtospectator = true;
        intro_hud[i] SetText(str_text[i]);
        intro_hud[i] SetTypewriterFX( 90, 10000 - ( 3000 * i ), 3000 );
        wait(2);
    }

    wait(10);
    foreach ( hudelem in intro_hud ) hudelem Destroy();
}

// --------------------------------
//	NO TARGET OVERRIDE
// --------------------------------
function validate_and_set_no_target_position( position )
{
	if( IsDefined( position ) )
	{
		goal_point = GetClosestPointOnNavMesh( position.origin, 100 );
		if( IsDefined( goal_point ) )
		{
			self SetGoal( goal_point );
			self.has_exit_point = 1;
			return true;
		}
	}
	
	return false;
}

function no_target_override( zombie )
{
	if( isdefined( zombie.has_exit_point ) )
	{
		return;
	}
	
	players = level.players;
	
	dist_zombie = 0;
	dist_player = 0;
	dest = 0;

	if ( isdefined( level.zm_loc_types[ "dog_location" ] ) )
	{
		locs = array::randomize( level.zm_loc_types[ "dog_location" ] );
		
		for ( i = 0; i < locs.size; i++ )
		{
			found_point = false;
			foreach( player in players )
			{
				if( player laststand::player_is_in_laststand() )
				{
					continue;
				}
				
				away = VectorNormalize( self.origin - player.origin );
				endPos = self.origin + VectorScale( away, 600 );
				dist_zombie = DistanceSquared( locs[i].origin, endPos );
				dist_player = DistanceSquared( locs[i].origin, player.origin );
		
				if ( dist_zombie < dist_player )
				{
					dest = i;
					found_point= true;
				}
				else
				{
					found_point = false;
				}
			}
			if( found_point )
			{
				if( zombie validate_and_set_no_target_position( locs[i] ) )
				{
					return;
				}
			}
		}
	}
	
	
	escape_position = zombie giant_cleanup::get_escape_position_in_current_zone();
			
	if( zombie validate_and_set_no_target_position( escape_position ) )
	{
		return;
	}
	
	escape_position = zombie giant_cleanup::get_escape_position();
	
	if( zombie validate_and_set_no_target_position( escape_position ) )
	{
		return;
	}
	
	zombie.has_exit_point = 1;
	
	zombie SetGoal( zombie.origin );
}
