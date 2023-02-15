#using scripts\codescripts\struct;

#using scripts\shared\system_shared;
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
#using scripts\shared\spawner_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;

#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#insert scripts\shared\ai\systems\behavior_tree.gsh;
#insert scripts\shared\ai\systems\animation_selector_table.gsh;
#insert scripts\shared\ai\systems\animation_state_machine.gsh;
#insert scripts\shared\ai\systems\blackboard.gsh;
#insert scripts\shared\ai\systems\behavior.gsh;

#using_animtree( "generic" );

#namespace hb21_zm_utility;

#define	ZOMBIE_SIDE_STEP_CHANCE		  						.7
#define	ZOMBIE_RIGHT_STEP_CHANCE		  					.5

#define	ZOMBIE_REACTION_INTERVAL							2000
#define	ZOMBIE_MIN_REACTION_DIST    						64
#define	ZOMBIE_MAX_REACTION_DIST		  					1000

REGISTER_SYSTEM( "hb21_zm_utility", &__init__, undefined )

//*****************************************************************************
// MAIN
//*****************************************************************************

function __init__()
{
	// # VARIABLES AND SETTINGS
	// level.zombie_ai_limit 													= 64;
	// level.zombie_actor_limit 												= 64;
	// # VARIABLES AND SETTINGS
	
	// # BEHAVIOR SET UP
	BT_REGISTER_API( 														"zombieCustomArchetypeService", 			&custom_zombie_archetype_service );
	// # BEHAVIOR SET UP
	
	// # SPAWN SET UP
	level.zm_custom_spawn_location_selection 						= &custom_spawn_location_selection;
	// # SPAWN SET UP
	
	util::registerClientSys( "hb21_zm_utility_client_notify" );
}

function delay_if_blackscreen_pending()
{
	while ( !flag::exists( "initial_blackscreen_passed" ) )
		WAIT_SERVER_FRAME;
	
	if ( !flag::get( "initial_blackscreen_passed" ) )
		level flag::wait_till( "initial_blackscreen_passed" );
	
}

function custom_zombie_archetype_service( behavior_tree_entity )
{
	if ( !isDefined( behavior_tree_entity.variant_type ) || IS_TRUE( behavior_tree_entity.needs_run_update ) )
	{
		if( isDefined( level.zm_variant_type_max ) )
		{
			if ( isDefined( behavior_tree_entity.zm_variant_type_max ) )
				behavior_tree_entity.variant_type = randomInt( behavior_tree_entity.zm_variant_type_max[ behavior_tree_entity.zombie_move_speed ][ behavior_tree_entity.zombie_arms_position ] );
			else
				behavior_tree_entity.variant_type = randomInt( level.zm_variant_type_max[ behavior_tree_entity.zombie_move_speed ][ behavior_tree_entity.zombie_arms_position ] );
			
		}
	}
		
	if ( IS_TRUE( behavior_tree_entity.needs_run_update ) )
		behavior_tree_entity._locomotion_speed = "locomotion_speed_" + behavior_tree_entity.zombie_move_speed;
	
	if ( !isDefined( behavior_tree_entity._has_legs ) )
		behavior_tree_entity._has_legs = HAS_LEGS_YES;
	
	if ( !IS_TRUE( behavior_tree_entity.missingLegs ) && behavior_tree_entity._has_legs != HAS_LEGS_YES )
		behavior_tree_entity._has_legs = HAS_LEGS_YES;
	else if ( IS_TRUE( behavior_tree_entity.missingLegs ) && behavior_tree_entity._has_legs != HAS_LEGS_NO )
		behavior_tree_entity._has_legs = HAS_LEGS_NO;
	
	if ( !isDefined( behavior_tree_entity._arms_position ) )
		behavior_tree_entity._arms_position = ARMS_UP;
	
	if ( behavior_tree_entity.zombie_arms_position == "up" && behavior_tree_entity._arms_position != ARMS_UP )
		behavior_tree_entity._arms_position = ARMS_UP;
	else if ( behavior_tree_entity.zombie_arms_position == "down" && behavior_tree_entity._arms_position != ARMS_DOWN )
		behavior_tree_entity._arms_position = ARMS_DOWN;
	
}

function enable_side_step()
{
	self.n_stepped_direction 							= 0;
	self.n_zombie_can_side_step 						= 1;
	self.n_zombie_can_forward_step 				= 1;
	self.n_zombie_side_step_step_chance 		= ZOMBIE_SIDE_STEP_CHANCE;
	self.n_zombie_right_step_step_chance 		= ZOMBIE_RIGHT_STEP_CHANCE;
	self.n_zombie_reaction_interval 					= ZOMBIE_REACTION_INTERVAL;
	self.n_zombie_min_reaction_dist 				= ZOMBIE_MIN_REACTION_DIST;
	self.n_zombie_max_reaction_dist 				= ZOMBIE_MAX_REACTION_DIST;
}

function set_level_variable( str_identifier, u_value )
{
	if ( !isDefined( level.a_level_variables ) )
		level.a_level_variables = [];
	
	level.a_level_variables[ str_identifier ] = u_value;
}

function get_level_variable( str_identifier )
{
	if ( !isDefined( level.a_level_variables ) || !isDefined( level.a_level_variables[ str_identifier ] ) )
		return undefined;
	
	return level.a_level_variables[ str_identifier ];
}

function custom_spawn_location_selection( a_spots )
{
	if ( level.zombie_respawns > 0 )
	{
		if( !isDefined( level.n_player_spawn_selection_index ) )
			level.n_player_spawn_selection_index = 0;

		a_players = getPlayers();
		level.n_player_spawn_selection_index++;
		if ( level.n_player_spawn_selection_index >= a_players.size )
			level.n_player_spawn_selection_index = 0;
		
		e_player = a_players[ level.n_player_spawn_selection_index ];

		arraySortClosest( a_spots, e_player.origin );

		a_candidates = [];

		v_player_dir = anglesToForward( e_player.angles );
		
		for ( i = 0; i < a_spots.size; i++ )
		{
			v_dir = a_spots[ i ].origin - e_player.origin;
			dp = vectorDot( v_player_dir, v_dir );
			if ( dp >= 0.0 )
			{
				a_candidates[ a_candidates.size ] = a_spots[ i ];
				if ( a_candidates.size > 10 )
					break;
				
			}
		}

		if ( a_candidates.size )
			s_spot = array::random( a_candidates );
		else
			s_spot = array::random(a_spots);
		
	}
	else
		s_spot = array::random( a_spots );
	
	return s_spot;
}

function register_black_hole_bomb_immunity()
{
	if ( !isDefined( self.ignore_poi_targetname ) )
		self.ignore_poi_targetname = [];
	
	self.ignore_poi_targetname[ self.ignore_poi_targetname.size ] 	= "gersh_device_poi";
	self.b_immune_gersh = 1;
}

function disable_ai_pain()
{
	self.a.disablepain = 1;
	self.allowpain = 0;
	self.a.disableReact = 1;
	self.allowReact = 0;
}

function enable_ai_pain()
{
	self.a.disablepain = 0;
	self.allowpain = 1;
	self.a.disableReact = 0;
	self.allowReact = 1;
}