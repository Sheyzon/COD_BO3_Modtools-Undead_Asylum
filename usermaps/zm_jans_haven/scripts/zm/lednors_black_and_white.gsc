/*
credits to ::
NateSmithZombies - Original idea of the bw vision.
Sharpgamers4you - re-creating the black and white scripts from scratch 7/1/21.
Killjoy - Helping out for things I needed to add in zone.
Scary Branden - Helping sg4y to figure out possible ways to achieve this.

mrlednor for the rewrite and the revive functions and the zpkg set up 09/09/22
holofya - advice 

*/



#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_equipment;
#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_weapons;
#using scripts\shared\array_shared;
#using scripts\shared\_burnplayer;
#using scripts\zm\_zm_laststand;
#using scripts\shared\lui_shared;


#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\zm\_zm_utility.gsh;

#namespace lednors_bw;

REGISTER_SYSTEM( "lednors_bw", &__init__, undefined )

function __init__()
{
  level waittill( "initial_blackscreen_passed" );
	thread bw_vision();
  thread ending_bw_vision();
  foreach(player in getplayers())
  {
    player thread last_stand_check();
  }
  
}
function bw_vision()
{
  VisionSetNaked( "zombie_last_stand", 8 ); 
  //iprintlnbold("vision set");
}
function last_stand_check()//mrlednor added
{
  //iprintlnbold("run check funtion");
  while(1)
  {
	   self waittill("player_revived");
    // iprintlnbold("player_revived");
	   if(level flag::exists("power_on")&& level flag::get("power_on"))
	   {
	    //iprintlnbold("power_on");
	    break;
	   }
	   else
	   {
       VisionSetNaked( "zm_factory", 0.5 );
       wait 0.5;
       VisionSetNaked( "zombie_last_stand", 1 );
      //iprintlnbold("power_off");
	   }
	    wait 1;
  }
}
function ending_bw_vision()
{
    level flag::wait_till( "power_on" );
    lui::screen_flash( 0.2, 0.5, 1.0, 0.8, "white" ); // flash
    wait(0.5);
    VisionSetNaked( "zm_factory", 0.5 );
}