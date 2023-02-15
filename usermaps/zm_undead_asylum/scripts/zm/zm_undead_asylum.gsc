#using scripts\zm\_zm_bgb_machine;
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
#using scripts\zm\_zm_perks;
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

//MANGLER
#using scripts\zm\_zm_ai_raz;

#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_perk_vulture_aid;
#using scripts\zm\_zm_perk_whoswho;
#using scripts\zm\_zm_perk_tombstone;
#using scripts\zm\_zm_perk_phdflopper;
#using scripts\zm\_zm_perk_elemental_pop;
#using scripts\zm\_zm_perk_random;

// Blundergat
#using scripts\zm\craftables\_hb21_zm_craft_blundersplat;
#using scripts\zm\_hb21_zm_weap_blundersplat;
#using scripts\zm\_hb21_zm_weap_magmagat;

#using scripts\zm\_t9_wonderfizz;

//BOWS
#using scripts\zm\_zm_weap_elemental_bow;
#using scripts\zm\_zm_weap_elemental_bow_storm;
#using scripts\zm\_zm_weap_elemental_bow_rune_prison;
#using scripts\zm\_zm_weap_elemental_bow_wolf_howl;
#using scripts\zm\_zm_weap_elemental_bow_demongate;

// MECHZ ZOMBIE
#using scripts\zm\_zm_ai_mechz;

#using scripts\shared\spawner_shared;
#using scripts\zm\_hb21_zm_behavior;

//Powerups
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
//#using scripts\zm\_zm_powerup_weapon_minigun;

#using scripts\zm\_hb21_zm_magicbox;

#using scripts\zm\_zm_easteregg_song;

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\_zm_zombie_expansion;

#using scripts\zm\zm_usermap;

#using scripts\zm\_zm_T8_ZA;

// NSZ Kino Teleporter
#using scripts\_NSZ\nsz_kino_teleporter;

// Giant ZombieMGR
#using scripts\zm\zm_giant_cleanup_mgr;

#using scripts\_redspace\rs_o_jump_pad;

//-----FX Cache-----
#precache( "fx", "zombie/fx_perk_quick_revive_factory_zmb" );
#precache( "fx", "zombie/fx_barrier_buy_zmb" );
#precache( "fx", "zombie/fx_elec_gen_idle_sm_zmb" );
#precache( "fx", "zombie/fx_elec_gen_tip_zmb" );
#precache( "fx", "lensflares/fx_lensflare_light_warm_sm" );
#precache( "fx", "lensflares/fx_lensflare_grime01" );
#precache( "fx", "dlc2/island/fx_fog_ground_thin_lg_island" );
#precache( "fx", "dlc2/island/fx_fog_ground_lg_island" );
#precache( "fx", "dirt/fx_dust_motes_200x200_pcloud" );

#define QUICK_REVIVE_MACHINE_LIGHT_FX                       "revive_light"

//*****************************************************************************
// MAIN
// zm_ai_raz::enable_raz_rounds();

// level.num_active_bgb_machines = 2;

// level zm_perks::spare_change();
//*****************************************************************************

function main()
{
	thread inspectable();

	// NSZ Kino Teleporter
	level thread nsz_kino_teleporter::init(); 

	//If dogs are allowed
	level.dog_rounds_allowed=1;

	zm_usermap::main();

	callback::on_ai_spawned(&infinite_spawning);

	thread lockdown_mainroom();

	thread rem_door_hintstring();

	thread MaxAmmo();

	//Monitor Power
	level thread MonitorPower();

	//PLayer voices
	level thread zm_castle_vox();

	//-----Perklimit-----
	level.perk_purchase_limit = 20;

	//-----Perk FX/Lights-----
	level._effect[QUICK_REVIVE_MACHINE_LIGHT_FX]                = "zombie/fx_perk_quick_revive_factory_zmb";
	level._effect["poltergeist"]								= "zombie/fx_barrier_buy_zmb";
	
	level._zombie_custom_add_weapons =&custom_add_weapons;

	//-----StartingWeapon-----
	level.start_weapon = (getWeapon("t9_1911"));

	// Last Stand Weapon
	lastStandWeapon = "t9_nail_gun_up";
	level.default_laststandpistol = getWeapon(lastStandWeapon);
	level.default_solo_laststandpistol = getWeapon(lastStandWeapon);

	level._zombie_custom_add_weapons =&custom_add_weapons;
	level.pack_a_punch_camo_index = 121;
    level.pack_a_punch_camo_index_number_variants = 4;

	T8ZA::set_name_for_undefined_zones("start_hallway_zone", "Cellhallways");
	T8ZA::set_name_for_undefined_zones("start_hallway_zone_2", "Cellhallways");
	T8ZA::set_name_for_undefined_zones("jumpad_lower", "Cellhallways");

	T8ZA::set_name_for_undefined_zones("jumpad_upper", "Southwing");
	
	//Setup the levels Zombie Zone Volumes
	level.zones = [];
	level.zone_manager_init_func =&asylum_zone_init;
	init_zones[0] = "start_zone";
	init_zones[1] = "anor_londo_pap";
	init_zones[2] = "black_box";
	init_zones[3] = "jump";
	init_zones[4] = "jump_4";
	level thread zm_zonemgr::manage_zones( init_zones );

	thread zm_easteregg_song::init();

	//spawner::add_archetype_spawn_function( "zombie", &test );

	level.pathdist_type = PATHDIST_ORIGINAL;

	// changing starting points
	level.player_starting_points = 50000;
}

function asylum_zone_init()
{
	zm_zonemgr::add_adjacent_zone( "start_zone", "start_hallway_zone", "ez1");

	zm_zonemgr::add_adjacent_zone( "start_hallway_zone", "start_hallway_zone_2", "ez1");

	zm_zonemgr::add_adjacent_zone( "start_hallway_zone_2", "jumpad_lower", "ez2");

	zm_zonemgr::add_adjacent_zone( "jumpad_lower", "jumpad_upper", "ez2");

	zm_zonemgr::add_adjacent_zone( "jumpad_upper", "southwing_lower", "ez2");

	zm_zonemgr::add_adjacent_zone( "southwing_lower", "main_room", "ez3");

	//zm_zonemgr::add_adjacent_zone( "southwing_lower", "southwing_stairs_lower");

	//zm_zonemgr::add_adjacent_zone( "southwing_lower", "southwing_stairs_upper");

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

	zm_zonemgr::add_adjacent_zone( "southwing_stairs_upper", "balcony_lt", "ez6");

	zm_zonemgr::add_adjacent_zone( "balcony_mdl", "balcony_lt", "ez6");

	zm_zonemgr::add_adjacent_zone( "balcony_mdl", "power_room", "ez6");

	zm_zonemgr::add_adjacent_zone( "balcony_mdl", "power_room_tunnel", "ez6");

	zm_zonemgr::add_adjacent_zone( "power_room", "power_room_tunnel", "ez6");

	zm_zonemgr::add_adjacent_zone( "balcony_mdl", "jump_2");

	//zm_zonemgr::add_adjacent_zone( "southwing_stairs_upper", "southwing_lower"); 326.36
}

function MonitorPower()
{
	level flag::wait_till("initial_blackscreen_passed");
	//level util::set_lighting_state(1);

	level flag::wait_till("power_on");
	level thread scene::play( "power_switch", "targetname" );
	// level thread scene::play( "fxanim_diff_engine_tele_rt", "targetname" );
	// level thread scene::play( "fxanim_diff_engine_tele_lt", "targetname" );
	//level util::set_lighting_state(0);
}

function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_levelcommon_weapons.csv", 1);
}

function zm_castle_vox()
{
	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_castle_vox.csv");
}

/*
function test()
{
    self hb21_zm_behavior::enable_side_step();
}
*/

function lockdown_mainroom()
{
	clip = GetEnt("door_clip","targetname");
	door_rt_1 = GetEnt("door_rt_01","targetname");
	door_rt_2 = GetEnt("door_rt_02","targetname");

	door_lt_1 = GetEnt("door_lt_01","targetname");
	door_lt_2 = GetEnt("door_lt_02","targetname");

    trig = GetEnt("bf_trig","targetname");
    trig SetHintString("Press ^3&&1^7 to proof your worthiness"); // Changes the string that shows when looking at the trigger.
    trig SetCursorHint("HINT_NOICON"); // Changes the icon that shows when looking at the trigger.
	trig waittill("trigger", player);
	trig Delete();

	level.zombie_total = 10;

	//Start Spawning
	level.infinite_spawning_enabled = true;
	zombie_utility::set_run_speed();
	thread zm_easteregg_song::play_2D_sound("lockdown_music");

	wait(20);
	zm_ai_raz::special_raz_spawn(1, undefined, 1); // special_raz_spawn( n_to_spawn = 1, ptr_post_spawn = undefined, b_ignore_max_raz_count = 0, s_spawn_point = undefined )
	wait(20);
	zm_ai_raz::special_raz_spawn(3); 
	wait(55);

	//Stop Spawning
	level.infinite_spawning_enabled = false;
	zombies = GetAISpeciesArray("axis");
	level.zombie_total = 0;
	if(isDefined(zombies))
	{
		for(i = 0; i < zombies.size; i++)
		{
			zombies[i] doDamage(zombies[i].health .health + 666, zombies[i].origin );
			wait 0.05;
		}
	}
	
	level flag::set( "ez3" );
	
	door_rt_1 RotateYaw(-120, 1);
	door_rt_2 RotateYaw(-120, 1);
	door_lt_1 RotateYaw(120, 1);
	door_lt_2 RotateYaw(120, 1);

	clip Delete();
	IPrintLnBold("Your worth has been proven"); //Messsage on screen
}


function MaxAmmo()
{
	wip = GetEnt("trigger_wip","targetname");
    wip SetHintString("This area is under construction!"); // Changes the string that shows when looking at the trigger.
    wip SetCursorHint("HINT_NOICON"); // Changes the icon that shows when looking at the trigger.
   
    trigger = GetEnt("maxammo_trigger", "targetname");
    trigger SetHintString("You must turn on the Power first!"); // Changes the string that shows when looking at the trigger.
    trigger SetCursorHint("HINT_NOICON"); // Changes the icon that shows when looking at the trigger.
    trigger1cost = 25000;

	level flag::wait_till("power_on");

	trigger SetHintString("Press ^3&&1^7 for max ammo. Cost [25000]"); // Changes the string that shows when looking at the trigger.

	while(1)
	{
		// Purchase Code
		trigger waittill("trigger", player);
				
		if(player.score >= trigger1cost)
		{
			player zm_score::minus_to_player_score(trigger1cost);
			trigger PlayLocalSound( "zmb_cha_ching" );
			level thread zm_powerups::specific_powerup_drop("full_ammo", player.origin);
			wait(5);
		}
		else
		{
			trigger PlayLocalSound( "zmb_no_cha_ching" );
		}
	}
}

function infinite_spawning()
{
    if ( IsDefined(level.infinite_spawning_enabled) && IS_TRUE(level.infinite_spawning_enabled) )
    {
        if( zombie_utility::get_current_zombie_count() < level.zombie_ai_limit ) // only update if less than the ai limit
        {
            level.zombie_total = level.zombie_ai_limit; // keep ai total at the ai limit
        }

        self waittill("death");
        level.zombie_respawns++; // get ai back in the level faster
    }
}

function rem_door_hintstring()
{
	his = GetEnt("door_hintstring","targetname");
	his SetHintString("Door Can't Be Opened From This Side"); // Changes the string that shows when looking at the trigger.
    his SetCursorHint("HINT_NOICON"); // Changes the icon that shows when looking at the trigger.

	level flag::wait_till("hint_string_remove");
	his Delete();
}

function inspectable()
{
	inspectable::add_inspectable_weapon( GetWeapon("t8_saug9mm"), 4.66 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_saug9mm_up"), 4.66 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_strife"), 3.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_strife_up"), 3.33 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_rk7"), 3.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_rk7_up"), 3.33 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_mozu"), 3.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_mozu_up"), 3.33 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_mx9"), 7.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_mx9_up"), 7.56 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_gks"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_gks_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_spitfire"), 4.9 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_spitfire_up"), 4.9 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_cordite"), 7.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_cordite_up"), 7.56 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_icr7"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_icr7_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_rampart17"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_rampart17_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_kn57"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_kn57_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_vapr_xkg"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_vapr_xkg_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_maddox_rfb"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_maddox_rfb_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_auger_dmr"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_auger_dmr_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_abr223"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_abr223_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_swordfish"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_swordfish_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_sdm"), 4.9 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_sdm_up"), 4.9 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_koshka"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_koshka_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_outlaw"), 7.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_outlaw_up"), 7.56 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_paladin_hb50"), 6.67 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_paladin_hb50_up"), 6.67 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_mog12"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_mog12_up"), 5.16 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_sg12"), 6.67 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_sg12_up"), 6.67 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_titan"), 5.7 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_titan_up"), 5.7 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_hades"), 6.67 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_hades_up"), 6.67 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_vkm750"), 6.67 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_vkm750_up"), 6.67 );

	inspectable::add_inspectable_weapon( GetWeapon("t8_hellion_salvo"), 5.7 );
	inspectable::add_inspectable_weapon( GetWeapon("t8_hellion_salvo_up"), 5.7 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_410ironhide"), 6.63 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_410ironhide_up"), 6.63 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_1911"), 3.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_1911_rdw_up"), 5 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_1911_ldw_up"), 5 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ak47"), 5.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ak47_up"), 5.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpk"), 5.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpk_up"), 5.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ak74u"), 5.93 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ak74u_up"), 5.93 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_amp63"), 3.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_amp63_rdw_up"), 3.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_amp63_ldw_up"), 3.16 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_aug"), 6.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_aug_up"), 6.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_aug_hbar"), 6.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_aug_hbar_up"), 6.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_bullfrog"), 4.36 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_bullfrog_up"), 4.36 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_c58"), 5.26 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_c58_up"), 5.26 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_hk21"), 5.26 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_hk21_up"), 5.26 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_carv2"), 8.1 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_carv2_up"), 8.1 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_diamatti"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_diamatti_up"), 6.23 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_dmr14"), 5.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_dmr14_up"), 5.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m14classic"), 5.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m14classic_up"), 5.86 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_em2"), 4.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_em2_up"), 4.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_fara83"), 6.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_fara83_up"), 6.86 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ffar1"), 4.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ffar1_up"), 4.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_gallo_sa12"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_gallo_sa12_up"), 4.33 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_grav"), 7.03 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_grav_up"), 7.03 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_galatz"), 7.03 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_galatz_up"), 7.03 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_groza"), 6.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_groza_up"), 6.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_hauer77"), 3.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_hauer77_up"), 3.56 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_krig6"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_krig6_up"), 4.33 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ksp45"), 4.9 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ksp45_up"), 4.9 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_lapa"), 4.9 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_lapa_up"), 4.9 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_lc10"), 5.26 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_lc10_up"), 5.26 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_lw3_tundra"), 7 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_lw3_tundra_up"), 7 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_m16"), 6.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m16_up"), 6.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_m60"), 10 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m60_up"), 10 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_m79"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m79_up"), 4.33 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_m82"), 8.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m82_up"), 8.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_mac10"), 6.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mac10_up"), 6.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_magnum"), 5.1 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_magnum_up"), 5.1 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_marshal"), 6.43 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_marshal_rdw_up"), 5.93 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_marshal_ldw_up"), 5.93 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_mg82"), 9.73 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mg82_up"), 9.73 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_milano821"), 6.03 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_milano821_up"), 6.03 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_mp5"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mp5_up"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mp5k"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mp5k_up"), 4.33 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_nail_gun"), 5.63 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_nail_gun_up"), 5.63 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ots9"), 3.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ots9_up"), 3.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_pelington703"), 6.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_pelington703_up"), 6.56 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ppsh41_base"), 7.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ppsh41_base_up"), 7.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ppsh41_drum"), 7.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ppsh41_drum_up"), 7.56 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_qbz83"), 6.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_qbz83_up"), 6.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpd"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpd_up"), 6.23 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpg7"), 6.63 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpg7_up"), 6.63 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_stoner63"), 5.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_stoner63_up"), 3.76 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_streetsweeper"), 5.6 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_streetsweeper_up"), 5.6 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_swiss_k31_scope"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_swiss_k31_scope_up"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_swiss_k31_irons"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_swiss_k31_irons_up"), 6.23 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_tec9"), 4.9 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_tec9_up"), 4.9 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_type63"), 5.7 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_type63_up"), 5.7 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_xm4"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_xm4_up"), 4.6 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_zrg20mm"), 6.67 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_zrg20mm_up"), 6.67 );
}
