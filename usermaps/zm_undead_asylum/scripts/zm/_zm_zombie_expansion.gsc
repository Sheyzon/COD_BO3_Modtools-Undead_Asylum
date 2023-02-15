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
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\zm\_zm_zombie_expansion.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;

//Traps
#using scripts\zm\_zm_trap_electric;

// ==================================================================================================================
#using scripts\zm\_hb21_zm_behavior;

#using scripts\shared\demo_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_blockers;
// ==================================================================================================================

#using scripts\zm\zm_usermap;

// ==================================================================================================================
#precache( "model", "p7_light_led_worklight" );
#precache( "model", "p7_light_led_worklight_lit" );
#precache( "model", "p7_zm_moo_door_airlock_heavy_lt" );
#precache( "model", "p7_zm_moo_door_airlock_heavy_lt_locked" );
#precache( "model", "p7_zm_moo_door_airlock_heavy_rt" );
#precache( "model", "p7_zm_moo_door_airlock_heavy_rt_locked" );
#precache( "fx", "explosions/fx_exp_rocket_default_sm" );
#precache( "fx", "dlc1/castle/fx_dust_impact_ground" );
// ==================================================================================================================

REGISTER_SYSTEM_EX( "zm_zombie_expansion", &__init__, &__main__, undefined )

//*****************************************************************************
// MAIN
//*****************************************************************************

function __init__()
{}

function __main__()
{
	
	if ( IS_TRUE( USE_CLOSEABLE_DOORS ) )
		level flag::set("door_can_close");
	
	level._effect["def_explosion"] = "explosions/fx_exp_rocket_default_sm";
	level._effect["dlc1/castle/fx_dust_impact_ground"] = "dlc1/castle/fx_dust_impact_ground";
	
	// ==================================================================================================================
	airlock_buys = GetEntArray("zombie_airlock_buy", "targetname");
	for(i = 0; i < airlock_buys.size; i++)
	{
		airlock_buys[i] thread airlock_buy_init();
	}
	
	airlock_doors = GetEntArray("zombie_door_airlock", "script_noteworthy");
	for(i = 0; i < airlock_doors.size; i++)
	{
		airlock_doors[i] thread airlock_init();
	}
	
	level.e_active_kill_door = undefined;
	level flag::init( "kill_counter_door_active" );
	level.custom_door_buy_check = &door_test;
	reset_door_counters();
	zm_spawner::register_zombie_death_event_callback( &kill_counter_death_check );
	// ==================================================================================================================
}

function is_touching_active_kill_door()
{
	if ( !isDefined( level.e_active_kill_door ) )
		return 0;
	
	temp = [];
	
	foreach ( e_target in getEntArray( level.e_active_kill_door.target, "targetname" ) )
	{
		if ( !isDefined( e_target.script_noteworthy ) || e_target.script_noteworthy != "door_kill_counter_area" )
			continue;
		
		temp[ temp.size ] = e_target;
		// if ( self isTouching( e_target ) )
			// return 1;
		
	}
	if ( !isDefined( temp ) || !isArray( temp ) || temp.size < 1 )
		return 1;
	
	foreach ( e_target in temp )
	{
		if ( self isTouching( e_target ) )
			return 1;
		
	}
	return 0;
}

function kill_counter_death_check( e_attacker )
{
	if ( isDefined( level.e_active_kill_door ) )
	{
		if ( self is_touching_active_kill_door() )
		{
			level.e_active_kill_door.n_kills++;
		}
	}
}
// door_kill_counter_area script_noteworthy

function reset_door_counters()
{
	foreach( e_counter in getEntArray( "door_counters", "script_noteworthy" ) )
	{
		e_trigs = getEntArray( e_counter.targetname, "target" );
		count = e_trigs[ 0 ].script_int;
		e_counter zod_robot_set_number_joints( count );
	}
}

function door_check( who )
{
	if( !who UseButtonPressed() )
	{
		return false;
	}

	if( who zm_utility::in_revive_trigger() )
	{
		return false;
	}

	if( IS_DRINKING(who.is_drinking) )
	{
		return false;
	}
	cost = 0;
	upgraded = 0;
	if( zm_utility::is_player_valid( who ) )
	{
		players = GetPlayers();

		// Get the cost of the door
		cost = self.zombie_cost;

		if( /*(isdefined(self.purchaser) && self.purchaser == who) &&*/ self._door_open == true)
		{
			self.purchaser = undefined;
		}	
		else if( who zm_score::can_player_purchase( cost ) )
		{
			who zm_score::minus_to_player_score( cost );
			scoreevents::processScoreEvent( "open_door", who );
			demo::bookmark( "zm_player_door", gettime(), who );
			who zm_stats::increment_client_stat( "doors_purchased" );
			who zm_stats::increment_player_stat( "doors_purchased" );
			who zm_stats::increment_challenge_stat( "SURVIVALIST_BUY_DOOR" );
			self.purchaser = who;
		}
		else // Not enough money
		{
			zm_utility::play_sound_at_pos( "no_purchase", self.doors[0].origin );
			
			if(isDefined(level.custom_door_deny_vo_func))
			{
				who thread [[level.custom_door_deny_vo_func]]();
			}
			else if(isDefined(level.custom_generic_deny_vo_func))
			{
				who thread [[level.custom_generic_deny_vo_func]](true);
			}
			else
			{
				who zm_audio::create_and_play_dialog( "general", "outofmoney" );
			}
			return false;
		}

	}

	if(isdefined(level._door_open_rumble_func))
	{
		who thread [[ level._door_open_rumble_func ]]();
	}
	return true;
}

function is_explosive_door()
{
	foreach ( e_target in getEntArray( self.target ) )
	{
		if ( e_target.script_string == "explosives" )
			return 1;
		
	}
	return 0;
}

function delay_delete()
{
	self waittill( "door_opened" );
	wait 1;
	self notify( "kill_door_think" );
}

function door_test( e_trig )
{
	if ( e_trig.script_noteworthy == "delay_door" )
	{
		e_trig thread delay_delete();
		return 1;
	}
	
	if ( e_trig.script_noteworthy == "kill_counter_door" && isDefined( e_trig._door_open ) && e_trig._door_open )
		return 1;
	
	if ( e_trig.script_noteworthy != "kill_counter_door" )
		return 1;
	
	if ( !e_trig door_check( self ) )
		return 0;
	
	if ( IS_TRUE( self.b_kill_counter_active ) )
		return 0;
	
	if ( level flag::get( "kill_counter_door_active" ) )
		return 0;
	
	e_trig setHintString( "" );
	e_trig thread kill_thread();
	
	return 0;
}

function kill_thread()
{
	self.b_kill_counter_active = 1;
	self timer();
	self.b_kill_counter_active = undefined;
}

// p7_light_led_worklight
// p7_light_led_worklight_lit
// counter_1s
// counter_10s
// counter_100s


function zod_robot_set_number_joints( n_num )
{
	a_bones = zod_robot_get_number_joints( n_num );
	for ( i = 0; i < 4; i++ )
	{
		for ( j = 0; j < 10; j++ )
			self hidePart( "j_" + i + "_" + j );
		
		self showPart( "j_" + i + "_" + a_bones[ i ] );
	}
}

function zod_robot_hide_number_joints()
{
	// a_bones = zod_robot_get_number_joints( n_num );
	for ( i = 0; i < 4; i++ )
	{
		for ( j = 0; j < 10; j++ )
			self hidePart( "j_" + i + "_" + j );
		
		// self showPart( "j_" + i + "_" + a_bones[ i ] );
	}
}

function zod_robot_get_number_joints( n_civil_protector_cost )
{
	a_bones = [];
	for ( i = 0; i < 4; i++ )
	{
		n_power = pow( 10, 3 - i );
		a_bones[ i ] = floor( n_civil_protector_cost / n_power );
		n_civil_protector_cost = n_civil_protector_cost - a_bones[ i ] * n_power;
	}
	return a_bones;
}

function timer()
{
	level flag::set( "kill_counter_door_active" );
	level.e_active_kill_door = self;
	
	self.counter_1s zod_robot_set_number_joints( self.script_int );
	
	// n_start_counter = level.global_zombies_killed;
	// if ( !isDefined( n_start_counter ) )
	// 	n_start_counter = 0;
	
	complete = false;
	n_time = 0.0;
	iPrintLn( self.script_timer );
	
	n_kills_needed = self.script_int;
	
	self.n_state = 0;
	
	self.n_kills = 0;
	while ( n_time < self.script_timer )
	{
		if ( isDefined( self._door_open ) && self._door_open )
		{
			complete = 1;
			break;
		}
		
		// n_count = level.global_zombies_killed - n_start_counter;
		
		self.counter_1s zod_robot_set_number_joints( self.script_int - self.n_kills );
		
		iPrintLnBold( self.n_kills );
		iPrintLnBold( n_time );
		
		perc = int( ( self.n_kills / self.script_int ) * 3 );
		// self set_state( perc );
		if ( isDefined( self.n_kills ) && self.n_kills >= self.script_int )
		{
			complete = true;
			break;
		}
		
		n_time += .05;
		wait .05;
	}
	level flag::clear( "kill_counter_door_active" );
	if ( complete )
	{
		iPrintLnBold("^1OPEN FUCKER" );
		self.counter_1s zod_robot_set_number_joints( 0 );
		self zm_blockers::door_opened();
	}
	else
	{
		self setHintString( &"ZOMBIE_DOOR_ACTIVATE_COUNTER", self.zombie_cost );
		self.b_kill_counter_active = undefined;
		self.counter_1s zod_robot_set_number_joints( self.script_int );
		// self set_state( 0 );
	}
	self.n_kills = 0;
	level.e_active_kill_door = undefined;
}

function airlock_init()
{
	self.type = undefined;
	self._door_open = 0;
	targets = GetEntArray(self.target, "targetname");
	self.doors = [];
	for(i = 0; i < targets.size; i++)
	{
		targets[i] zm_blockers::door_classify(self);
		targets[i].startPos = targets[i].origin;
	}
	self thread airlock_think();
}

/*
	Name: airlock_think
	Namespace: zm_moon_utility
	Checksum: 0xAA2589CD
	Offset: 0x1910
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function airlock_think()
{
	while(1)
	{
		self waittill("trigger", who);
		
		if(isdefined(self.doors[0].startPos) && self.doors[0].startPos != self.doors[0].origin)
		{
			continue;
		}
		for(i = 0; i < self.doors.size; i++)
		{
			self.doors[i] thread airlock_activate(0.25, 1);
		}
		self._door_open = 1;
		while(self moon_airlock_occupied() || (isdefined(self.doors[0].door_moving) && self.doors[0].door_moving == 1))
		{
			wait(0.1);
		}
		self thread door_clean_up_corpses();
		for(i = 0; i < self.doors.size; i++)
		{
			self.doors[i] thread airlock_activate(0.25, 0);
		}
		self._door_open = 0;
	}
}

/*
	Name: airlock_activate
	Namespace: zm_moon_utility
	Checksum: 0x88133BB9
	Offset: 0x1AD0
	Size: 0x245
	Parameters: 2
	Flags: None
*/
function airlock_activate(time, open)
{
	if(!isdefined(time))
	{
		time = 1;
	}
	if(!isdefined(open))
	{
		open = 1;
	}
	if(isdefined(self.door_moving))
	{
		return;
	}
	self.door_moving = 1;
	self notsolid();
	if(self.classname == "script_brushmodel")
	{
		if(open)
		{
			self connectpaths();
		}
	}
	if(isdefined(self.script_sound))
	{
		if(open)
		{
			self playsound("zmb_airlock_open");
		}
		else
		{
			self playsound("zmb_airlock_close");
		}
	}
	scale = 1;
	if(!open)
	{
		scale = -1;
	}
	switch(self.script_string)
	{
		case "slide_apart":
		{
			if(isdefined(self.script_vector))
			{
				vector = VectorScale(self.script_vector, scale);
				if(open)
				{
					if(isdefined(self.startPos))
					{
						self moveto(self.startPos + vector, time);
					}
					else
					{
						self moveto(self.origin + vector, time);
					}
					self._door_open = 1;
				}
				else if(isdefined(self.startPos))
				{
					self moveto(self.startPos, time);
				}
				else
				{
					self moveto(self.origin - vector, time);
				}
				self._door_open = 0;
				self thread zm_blockers::door_solid_thread();
			}
			break;
		}
	}
}

/*
	Name: moon_airlock_occupied
	Namespace: zm_moon_utility
	Checksum: 0xF256E1B4
	Offset: 0x1D20
	Size: 0x1A9
	Parameters: 0
	Flags: None
*/
function moon_airlock_occupied()
{
	is_occupied = 0;
	zombies = GetAIArray();
	for(i = 0; i < zombies.size; i++)
	{
		if(zombies[i] istouching(self))
		{
			is_occupied++;
		}
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] istouching(self))
		{
			is_occupied++;
		}
	}
	if(is_occupied > 0)
	{
		if(isdefined(self.doors[0].startPos) && self.doors[0].startPos == self.doors[0].origin)
		{
			for(i = 0; i < self.doors.size; i++)
			{
				self.doors[i] thread airlock_activate(0.25, 1);
			}
			self._door_open = 1;
		}
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: door_clean_up_corpses
	Namespace: zm_moon_utility
	Checksum: 0xB50ED079
	Offset: 0x1ED8
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function door_clean_up_corpses()
{
	corpses = GetCorpseArray();
	if(isdefined(corpses))
	{
		for(i = 0; i < corpses.size; i++)
		{
			if(corpses[i] istouching(self))
			{
				corpses[i] thread door_remove_corpses();
			}
		}
	}
}

/*
	Name: door_remove_corpses
	Namespace: zm_moon_utility
	Checksum: 0x27F33632
	Offset: 0x1F78
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function door_remove_corpses()
{
	if(isdefined(level._effect["dog_gib"]))
	{
		playFX(level._effect["dog_gib"], self.origin);
	}
	self delete();
}

function airlock_buy_init()
{
	self.type = undefined;
	if(isdefined(self.script_flag) && !isdefined(level.flag[self.script_flag]))
	{
		if(isdefined(self.script_flag))
		{
			tokens = StrTok(self.script_flag, ",");
			for(i = 0; i < tokens.size; i++)
			{
				level flag::init(self.script_flag);
			}
		}
	}
	self.trigs = [];
	targets = GetEntArray(self.target, "targetname");
	for(i = 0; i < targets.size; i++)
	{
		if(!isdefined(self.trigs))
		{
			self.trigs = [];
		}
		else if(!IsArray(self.trigs))
		{
			self.trigs = Array(self.trigs);
		}
		self.trigs[self.trigs.size] = targets[i];
		if(isdefined(targets[i].classname) && targets[i].classname == "trigger_multiple")
		{
			targets[i] TriggerEnable(0);
		}
	}
	self setcursorhint("HINT_NOICON");
	if(isdefined(self.script_noteworthy) && (self.script_noteworthy == "electric_door" || self.script_noteworthy == "electric_buyable_door"))
	{
		self setHintString(&"ZOMBIE_NEED_POWER");
	}
	else
	{
		self.script_noteworthy = "default";
	}
	self thread airlock_buy_think();
}

function airlock_buy_think()
{
	self endon("kill_door_think");
	cost = 1000;
	if(isdefined(self.zombie_cost))
	{
		cost = self.zombie_cost;
	}
	while(1)
	{
		switch(self.script_noteworthy)
		{
			case "electric_door":
			{
				level flag::wait_till("power_on");
				break;
			}
			case "electric_buyable_door":
			{
				level flag::wait_till("power_on");
				self zm_utility::set_hint_string(self, "default_buy_door", cost);
				if(!self airlock_buy())
				{
					continue;
				}
				self moon_door_opened();
				break;
			}
			default:
			{
				self zm_utility::set_hint_string(self, "default_buy_door", cost);
				if(!self airlock_buy())
				{
					continue;
				}
				self moon_door_opened();
				break;
			}
		}
	}
}

function airlock_buy()
{
	self waittill("trigger", who, force);
	if(GetDvarInt("zombie_unlock_all") > 0 || (isdefined(force) && force))
	{
		return 1;
	}
	if(!who useButtonPressed())
	{
		return 0;
	}
	if(who zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(who.is_drinking > 0)
	{
		return 0;
	}
	cost = 0;
	upgraded = 0;
	if(zombie_utility::is_player_valid(who))
	{
		cost = self.zombie_cost;
		if(who zm_pers_upgrades_functions::is_pers_double_points_active())
		{
			cost = who zm_pers_upgrades_functions::pers_upgrade_double_points_cost(cost);
			upgraded = 1;
		}
		if(who zm_score::can_player_purchase(cost))
		{
			who zm_score::minus_to_player_score(cost);
			scoreevents::processScoreEvent("open_door", who);
			demo::bookmark("zm_player_door", GetTime(), who);
			who zm_stats::increment_client_stat("doors_purchased");
			who zm_stats::increment_player_stat("doors_purchased");
			who zm_stats::increment_challenge_stat("SURVIVALIST_BUY_DOOR");
			self.purchaser = who;
			who RecordMapEvent(5, GetTime(), who.origin, level.round_number, cost);
			// bb::function_91f32a58(who, self, cost, self.target, upgraded, "_door", "_purchase");
			who zm_stats::increment_challenge_stat("ZM_DAILY_PURCHASE_DOORS");
		}
		else
		{
			zm_utility::play_sound_at_pos("no_purchase", self.origin);
			who zm_audio::create_and_play_dialog("general", "outofmoney");
			return 0;
		}
	}
	return 1;
}

function moon_door_opened()
{
	self notify("door_opened");
	if(isdefined(self.script_flag))
	{
		tokens = StrTok(self.script_flag, ",");
		for(i = 0; i < tokens.size; i++)
		{
			level flag::set(tokens[i]);
		}
	}
	for(i = 0; i < self.trigs.size; i++)
	{
		self.trigs[i] TriggerEnable(1);
		self.trigs[i] thread change_door_models();
	}
	zm_utility::play_sound_at_pos("purchase", self.origin);
	all_trigs = GetEntArray(self.target, "target");
	for(i = 0; i < all_trigs.size; i++)
	{
		all_trigs[i] TriggerEnable(0);
	}
}

function change_door_models()
{
	doors = GetEntArray(self.target, "targetname");
	for(i = 0; i < doors.size; i++)
	{
		if(isdefined(doors[i].model) && doors[i].model == "p7_zm_moo_door_airlock_heavy_lt_locked")
		{
			doors[i] SetModel("p7_zm_moo_door_airlock_heavy_lt");
		}
		else if(isdefined(doors[i].model) && doors[i].model == "p7_zm_moo_door_airlock_heavy_rt_locked")
		{
			doors[i] SetModel("p7_zm_moo_door_airlock_heavy_rt");
		}
		else if(isdefined(doors[i].model) && doors[i].model == "p7_zm_moo_door_airlock_heavy_single_locked")
		{
			doors[i] SetModel("p7_zm_moo_door_airlock_heavy_single");
		}
		doors[i] thread airlock_connect_paths();
	}
}

function airlock_connect_paths()
{
	if(self.classname == "script_brushmodel")
	{
		self notsolid();
		self connectpaths();
		if(!isdefined(self._door_open) || self._door_open == 0)
		{
			self solid();
		}
	}
}

// ==================================================================================================================