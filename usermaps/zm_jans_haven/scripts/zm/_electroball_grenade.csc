#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace electroball_grenade;

#precache( "client_fx", "dlc1/castle/fx_wpn_115_blob" );
#precache( "client_fx", "dlc1/castle/fx_wpn_115_bul_trail" );
#precache( "client_fx", "dlc1/castle/fx_wpn_115_canister" );
#precache( "client_fx", "weapon/fx_prox_grenade_impact_player_spwner" );
#precache( "client_fx", "weapon/fx_prox_grenade_exp" );

REGISTER_SYSTEM_EX( "electroball_grenade", &__init__, undefined, undefined )

function __init__()
{
	clientfield::register( "toplayer", "tazered", 1, 1, "int", undefined, !CF_HOST_ONLY, 	!CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "allplayers", "electroball_shock", 1, 1, "int", &function_1619af16, !CF_HOST_ONLY, 	!CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "actor", "electroball_make_sparky", 1, 1, "int", &function_72eeb2e6, !CF_HOST_ONLY, 	!CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "missile", "electroball_stop_trail", 1, 1, "int", &function_bd1f6a88, !CF_HOST_ONLY, 	!CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "missile", "electroball_play_landed_fx", 1, 1, "int", &electroball_play_landed_fx, !CF_HOST_ONLY, 	!CF_CALLBACK_ZERO_ON_NEW_ENT );
	level._effect[ "fx_wpn_115_blob" ] = "dlc1/castle/fx_wpn_115_blob";
	level._effect[ "fx_wpn_115_bul_trail" ] = "dlc1/castle/fx_wpn_115_bul_trail";
	level._effect[ "fx_wpn_115_canister" ] = "dlc1/castle/fx_wpn_115_canister";
	level._effect[ "electroball_grenade_player_shock" ] = "weapon/fx_prox_grenade_impact_player_spwner";
	level._effect[ "electroball_grenade_sparky_conversion" ] = "weapon/fx_prox_grenade_exp";
	callback::add_weapon_type( "electroball_grenade", &proximity_spawned );
	level thread watchforproximityexplosion();
}

function proximity_spawned( localclientnum )
{
	self util::waittill_dobj( localclientnum );
	if ( self isgrenadedud() )
		return;
	
	self.var_886cac6a = playFxOnTag( localclientnum, level._effect[ "fx_wpn_115_bul_trail" ], self, "j_grenade_front" );
	self.var_5470a25d = playFxOnTag( localclientnum, level._effect[ "fx_wpn_115_canister" ], self, "j_grenade_back" );
}

function watchforproximityexplosion()
{
	if ( getactivelocalclients() > 1 )
		return;
	
	weapon_proximity = getWeapon( "electroball_grenade" );
	while ( 1 )
	{
		level waittill( "explode", localclientnum, position, mod, weapon, owner_cent );
		if ( weapon.rootweapon != weapon_proximity )
			continue;
		
		localplayer = getLocalPlayer( localclientnum );
		if ( !localplayer util::is_player_view_linked_to_entity( localclientnum ) )
		{
			explosionradius = weapon.explosionradius;
			if ( distanceSquared( localplayer.origin, position ) < ( explosionradius * explosionradius ) )
			{
				if ( isDefined( owner_cent ) )
				{
					if ( owner_cent == localplayer || !owner_cent util::friend_not_foe( localclientnum, 1 ) )
						localplayer thread postfx::playpostfxbundle( "pstfx_shock_charge" );
					
				}
			}
		}
	}
}

function function_72eeb2e6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	ai_zombie = self;
	if(isdefined(level.a_electroball_grenades))
	{
		electroball = arraygetclosest(ai_zombie.origin, level.a_electroball_grenades);
	}
	a_sparky_tags = array("j_spine4", "j_spineupper", "j_spine1");
	tag = array::random(a_sparky_tags);
	if(isdefined(electroball))
	{
		var_d72ccbc = beamlaunch(localclientnum, electroball, "tag_origin", ai_zombie, tag, "electric_arc_beam_electroball");
		wait(1);
		if(isdefined(var_d72ccbc))
		{
			beamkill(localclientnum, var_d72ccbc);
		}
	}
}

function function_1619af16(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	fx = playfxontag(localclientnum, level._effect["electroball_grenade_player_shock"], self, "J_SpineUpper");
}

function function_bd1f6a88(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.a_electroball_grenades))
	{
		level.a_electroball_grenades = [];
	}
	array::add(level.a_electroball_grenades, self);
	self thread function_1d823abf();
	if(isdefined(self.var_886cac6a))
	{
		stopfx(localclientnum, self.var_886cac6a);
	}
	if(isdefined(self.var_626a3201))
	{
		stopfx(localclientnum, self.var_626a3201);
	}
	if(isdefined(self.var_7a731cc6))
	{
		stopfx(localclientnum, self.var_7a731cc6);
	}
	if(isdefined(self.var_5470a25d))
	{
		stopfx(localclientnum, self.var_5470a25d);
	}
}

function function_1d823abf()
{
	self waittill("entityshutdown");
	level.a_electroball_grenades = array::remove_undefined(level.a_electroball_grenades);
}

function electroball_play_landed_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self.var_3b22ba3c = playfxontag(localclientnum, level._effect["fx_wpn_115_blob"], self, "tag_origin");
	dynent = createdynentandlaunch(localclientnum, "p7_zm_ctl_115_grenade_broken", self.origin, self.angles, self.origin, (0, 0, 0));
}