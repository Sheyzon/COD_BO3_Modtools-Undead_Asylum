#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm_weapons;

//Perks
#using scripts\zm\_zm_pack_a_punch;
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

/*
//Traps
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_trap_fire;
#using scripts\zm\_hb21_zm_trap_centrifuge;
#using scripts\zm\_hb21_sym_zm_trap_fan;
#using scripts\zm\_hb21_sym_zm_trap_acid;
*/

// Custom AI
//#using scripts\zm\_hb21_zm_ai_margwa;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\zm_genesis_apothicon_fury;
#using scripts\zm\_zm_ai_napalm;

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

#using scripts\zm\_zm_bgb_machine;

//Powerups
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_hb21_zm_magicbox;

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\zm_usermap;

#using scripts\Sphynx\craftables\_zm_craft_vineshield;

//Snow
#define SNOW_FX "dlc0/factory/fx_snow_player_os_factory"
#precache( "client_fx", SNOW_FX );

function main()
{
    //LuiLoad( "ui.uieditor.menus.hud.t7hud_zm_factory" );
    //LuiLoad( "ui.uieditor.menus.Craftables.WonderfizzMenuBase");
    // P-06
	LuiLoad( "ui.uieditor.widgets.Reticles.ChargeShot.ChargeShot_reticle" );
	// R70 Ajax
	LuiLoad( "ui.uieditor.widgets.Reticles.Infinite.lmgInfiniteReticle" );
	// LV8 Basilisk
	LuiLoad( "ui.uieditor.widgets.Reticles.PulseRifle.PulseRifleReticle_NumbersScreen" );

	zm_usermap::main();

    //Snow
	callback::on_localplayer_spawned( &on_localplayer_spawned );

	include_weapons();
	
	util::waitforclient( 0 );
}

function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_levelcommon_weapons.csv", 1);
}

//*****************************************************************************
// SNOW
//*****************************************************************************
function on_localplayer_spawned( localClientNum )
{
    if( self == GetLocalPlayer( localClientNum ) ) 
        self thread falling_snow(localClientNum);
}

function falling_snow(localClientNum)
{
    self endon( "disconnect" );
    self endon( "entityshutdown" );
    self endon( "death" );
    while(1)
    {
        PlayFX( localClientNum, SNOW_FX, self.origin );
        wait 0.5; //Change this to increase or decrease the snow intensity (Higher = Slower )
    }
}