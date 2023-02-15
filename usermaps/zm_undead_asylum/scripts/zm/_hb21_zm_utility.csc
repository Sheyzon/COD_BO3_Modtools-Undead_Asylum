#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\debug_menu_shared;
#using scripts\shared\water_surface;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#namespace hb21_zm_utility;

REGISTER_SYSTEM( "hb21_zm_utility", &__init__, undefined )

function __init__() {}

function is_stock_map()
{
	script = toLower( getDvarString( "mapname" ) );
	switch ( script )
	{
		case "zm_factory":
		case "zm_zod":
		case "zm_castle":
		case "zm_island":
		case "zm_stalingrad":
		case "zm_genesis":
		case "zm_prototype":
		case "zm_asylum":
		case "zm_sumpf":
		case "zm_theater":
		case "zm_cosmodrome":
		case "zm_temple":
		case "zm_moon":
		case "zm_tomb":
			return 1;
		default:
			return 0;
			
	}
}