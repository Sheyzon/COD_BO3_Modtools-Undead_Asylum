#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;

#insert scripts\shared\shared.gsh;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

#insert scripts\shared\abilities\_ability_util.gsh;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_powerups;

#insert scripts\zm\_zm_utility.gsh;

#namespace zm_ancient_evil_challenges;

#precache( "fx", "fire/fx_fire_barrel_30x30" );
#precache("xmodel", "zombie_z_money_icon");


#define CHALLENGE_ICON_BACKER	"white"
#define CHALLENGE_TIME			120


REGISTER_SYSTEM( "zm_ancient_evil_challenges", &__init__, undefined )

function __init__()
{
	level thread challeneges_init();
}

function challeneges_init()
{
	callback::on_connect( &on_player_connect );
	level waittill( "intro_hud_done" );

	add_challenege("Headshots",			&challenege_headshot,		"Kill Zombies With Headshots");
	add_challenege("Kills",				&challenege_kill,			"Kill Zombies With Anything");
	add_challenege("Melee Kills",		&challenege_melee,			"Kill Zombies With Melee Weapons");
	add_challenege("Dodgy Devil",		&challenege_dodge,			"Take No Damage From Zombies");
	add_challenege("Big Spender",		&challenege_spender,		"Spend Points");
	add_challenege("Lurker",			&challenege_lurker,			"Kill Zombies While Crouched");
	add_challenege("Anchored Down",		&challenege_anchored,		"Don't Move");


	//common
	add_challenge_reward(1,				level.zombie_powerups["nuke"].model_name,				&spawn_powerup,		"nuke");
	add_challenge_reward(1,				level.zombie_powerups["carpenter"].model_name,			&spawn_powerup,		"carpenter");
	add_challenge_reward(1,				"zombie_z_money_icon",									&bonus_points,		500);
	add_challenge_reward(1,				getweapon("ar_marksman").worldModel,					&free_gun,			getweapon("ar_marksman"));
	add_challenge_reward(1,				getweapon("pistol_burst").worldModel,					&free_gun,			getweapon("pistol_burst"));

	//uncommon
	add_challenge_reward(2,				level.zombie_powerups["fire_sale"].model_name,			&spawn_powerup,		"fire_sale");
	add_challenge_reward(2,				level.zombie_powerups["insta_kill"].model_name,			&spawn_powerup,		"insta_kill");
	add_challenge_reward(2,				level.zombie_powerups["double_points"].model_name,		&spawn_powerup,		"double_points");
	add_challenge_reward(2,				"zombie_z_money_icon",									&bonus_points,		1000);
	add_challenge_reward(2,				getweapon("shotgun_pump").worldModel,					&free_gun,			getweapon("shotgun_pump"));

	//rare
	add_challenge_reward(3,				level.zombie_powerups["full_ammo"].model_name,			&spawn_powerup,		"full_ammo");
	add_challenge_reward(3,				level.zombie_powerups["double_points"].model_name,		&spawn_powerup,		"double_points");
	add_challenge_reward(3,				"zombie_z_money_icon",									&bonus_points,		1500);
	add_challenge_reward(3,				getweapon("ar_cqb").worldModel,							&free_gun,			getweapon("ar_cqb"));
	add_challenge_reward(3,				getweapon("lmg_slowfire").worldModel,					&free_gun,			getweapon("lmg_slowfire"));

	//epic
	add_challenge_reward(4,				level.zombie_powerups["free_perk"].model_name,			&spawn_powerup,		"free_perk");
	add_challenge_reward(4,				level.zombie_powerups["full_ammo"].model_name,			&spawn_powerup,		"full_ammo");
	add_challenge_reward(4,				"zombie_z_money_icon",									&bonus_points,		3000);
	add_challenge_reward(4,				getweapon("ray_gun").worldModel,						&free_gun,			getweapon("ray_gun"));

	
	
	
	
	podium_challenge = struct::get_array("podium_challenge", "targetname");
	array::thread_all( podium_challenge, &podium_challenge_activate );
	
	podium_challenge_redeem_0 = struct::get_array("podium_challenge_redeem_0", "targetname");
	for(i=0;i<podium_challenge_redeem_0.size;i++)
		podium_challenge_redeem_0[i] thread podium_challenge_redeem(0);
	
	podium_challenge_redeem_1 = struct::get_array("podium_challenge_redeem_1", "targetname");
	for(i=0;i<podium_challenge_redeem_1.size;i++)
		podium_challenge_redeem_1[i] thread podium_challenge_redeem(1);
	
	podium_challenge_redeem_2 = struct::get_array("podium_challenge_redeem_2", "targetname");
	for(i=0;i<podium_challenge_redeem_2.size;i++)
		podium_challenge_redeem_2[i] thread podium_challenge_redeem(2);
	
	podium_challenge_redeem_3 = struct::get_array("podium_challenge_redeem_3", "targetname");
	for(i=0;i<podium_challenge_redeem_3.size;i++)
		podium_challenge_redeem_3[i] thread podium_challenge_redeem(3);
}

function add_challenge_reward(reward_level, reward_model, reward_func, reward_parm)
{
	if(!isdefined(level.ancient_evil_challenge_reward))
		level.ancient_evil_challenge_reward = [];
	reward = SpawnStruct();
	reward.reward_level = reward_level;
	reward.reward_model = reward_model;
	reward.reward_func = reward_func;
	reward.reward_parm = reward_parm;
		
	level.ancient_evil_challenge_reward[level.ancient_evil_challenge_reward.size] = reward;
}

function get_random_reward(num)
{
	vald = [];
	for ( i = 0; i < level.ancient_evil_challenge_reward.size; i++ )
	{
		can = true;
		if(level.ancient_evil_challenge_reward[i].reward_level != num)
			can = false;
		if(can)
			vald[vald.size] = i;
	}
	
	return vald[randomint(vald.size)];

}

function podium_challenge_activate()
{
	while(!isdefined(level.round_number)) wait .1;
	fxOrg = Spawn( "script_model", self.origin );
	fxOrg SetModel( "tag_origin" );
	fx = PlayFxOnTag( "fire/fx_fire_barrel_30x30", fxOrg, "tag_origin" );
	trig = Spawn( "trigger_radius", self.origin - (0, 0, 60), 0, 60, 80 );
	trig SetCursorHint( "HINT_NOICON" );
	for( ;; )
	{
		cost = get_challenge_cost();
		if(isdefined(level.podium_challenge_active))
			trig SetHintString( "A Tribute Has Already Been Paid" );
		else
			trig SetHintString( "Press & Hold ^3[{+activate}]^7 To Pay A Tribute [Cost: " + cost + "]" );
		trig waittill( "trigger", player );
		if(!player UseButtonPressed() || isdefined(level.podium_challenge_active))
		{
			wait .01;
			continue;
		}
		if( !player zm_score::can_player_purchase( cost ) )
		{
			player zm_audio::create_and_play_dialog( "general", "outofmoney" );
			wait .01;
			continue;
		}
		level thread challenge_timeout(CHALLENGE_TIME);
		level thread give_challenge();
		player zm_score::minus_to_player_score( cost ); 
		wait 1;
	}
}

function give_challenge()
{
	challenge = get_rand_challenge();
	level.previous_podium_challenge = challenge;
	if(isdefined(level.ancient_evil_challenges[challenge].challenege_thread))
		level thread [[level.ancient_evil_challenges[challenge].challenege_thread]]();
	bar_back = reap_create_hud_icon("left", "middle", "left", "middle", 0, -10, .5, CHALLENGE_ICON_BACKER, 150, 30, (0,0,0));
	name = reap_create_hud_text("center", "middle", "left", "middle", 75, -15, 1, (1,1,1), level.ancient_evil_challenges[challenge].challenege_name, 2);
	desc = reap_create_hud_text("center", "middle", "left", "middle", 75, 0, 1, (1,1,1), level.ancient_evil_challenges[challenge].challenege_description, 1);
	while(isdefined(level.podium_challenge_active)) wait .1;
	bar_back Destroy();
	name Destroy();
	desc Destroy();
}

function challenge_timeout(time)
{
	level.podium_challenge_active = true;
	bar_back = reap_create_hud_icon("center", "middle", "left", "middle", 75, -32, .5, CHALLENGE_ICON_BACKER, 50, 14, (0,0,0));
	timer = get_timer_challenge(time);
	name = reap_create_hud_text("center", "middle", "left", "middle", 75, -32, 1, (1,.8,0), timer, 1);
	while(time > 0)
	{
		time -=1;
		wait 1;
		timer = get_timer_challenge(time);
		name setText( timer );
	}
	level.podium_challenge_active = undefined;
	level notify("challenge_timeout");
	bar_back Destroy();
	name Destroy();
}

function get_timer_challenge(time)
{
	minutes = 0;
	while(time >= 60)
	{
		time -= 60;
		minutes++;
	}
	if(time < 10)
		time = "0"+time;
	return minutes+":"+time;
}

function get_rand_challenge()
{
	vald = [];
	for ( i = 0; i < level.ancient_evil_challenges.size; i++ )
	{
		can = true;
		if(isdefined(level.previous_podium_challenge) && i == level.previous_podium_challenge)
			can = false;
		if(can)
			vald[vald.size] = i;
	}
	
	return vald[randomint(vald.size)];
}

function get_challenge_cost()
{
	cost = 500;
	if(level.round_number > 10)
		cost = 1000;
	if(level.round_number > 15)
		cost = 1500;
	if(level.round_number > 20)
		cost = 2000;
	
	return cost;
}

function podium_challenge_redeem(num)
{
	players = GetPlayers();
	trig = Spawn( "trigger_radius", self.origin - (0, 0, 60), 0, 60, 80 );
	trig SetCursorHint( "HINT_NOICON" );
	fxOrg2 = Spawn( "script_model", self.origin );
	fxOrg2 SetModel( "tag_origin" );
	fx = PlayFxOnTag( "fire/fx_fire_barrel_30x30", fxOrg2, "tag_origin" );
	
	trig thread show_only_to_player(num);
	fxOrg2 thread show_only_to_player(num);
	for( ;; )
	{
		players = GetPlayers();
		reward_level = "^7Common";
		if(players[num].ancient_evil_challenge_power > 50)
			reward_level = "^2Uncommon";
		if(players[num].ancient_evil_challenge_power > 75)
			reward_level = "^4Rare";
		if(players[num].ancient_evil_challenge_power == 100)
			reward_level = "^1Epic";
		if(isdefined(trig.has_reward))
			trig SetHintString( "Press & Hold ^3[{+activate}]^7 To Take Reward" );
		else
		if(players[num].ancient_evil_challenge_power > 25)
			trig SetHintString( "Press & Hold ^3[{+activate}]^7 For " + reward_level + "^7 Reward" );
		else
			trig SetHintString( "Reward Level Too Low" );
		trig waittill( "trigger", player );
		if(!player UseButtonPressed() || player != GetPlayers()[num] || isdefined(trig.has_reward) )
		{
			wait .01;
			continue;
		}
		if(players[num].ancient_evil_challenge_power <= 25)
		{
			wait .01;
			continue;
		}
		if(players[num].ancient_evil_challenge_power == 100)
		{
			reward = get_random_reward(4);
			fxOrg = Spawn( "script_model", self.origin );
			fxOrg setmodel(level.ancient_evil_challenge_reward[reward].reward_model);
			fx = PlayFxOnTag( "zombie/fx_powerup_on_green_zmb", fxOrg, "tag_origin" );			
			trig thread offer_reward_timed(reward,num,fxOrg);
		}
		else
		if(players[num].ancient_evil_challenge_power > 75)
		{
			reward = get_random_reward(3);
			fxOrg = Spawn( "script_model", self.origin );
			fxOrg setmodel(level.ancient_evil_challenge_reward[reward].reward_model);
			fx = PlayFxOnTag( "zombie/fx_powerup_on_green_zmb", fxOrg, "tag_origin" );			
			trig thread offer_reward_timed(reward,num,fxOrg);
		}
		else
		if(players[num].ancient_evil_challenge_power > 50)
		{
			reward = get_random_reward(2);
			fxOrg = Spawn( "script_model", self.origin );
			fxOrg setmodel(level.ancient_evil_challenge_reward[reward].reward_model);
			fx = PlayFxOnTag( "zombie/fx_powerup_on_green_zmb", fxOrg, "tag_origin" );			
			trig thread offer_reward_timed(reward,num,fxOrg);
		}
		else
		{
			reward = get_random_reward(1);
			fxOrg = Spawn( "script_model", self.origin );
			fxOrg setmodel(level.ancient_evil_challenge_reward[reward].reward_model);
			fx = PlayFxOnTag( "zombie/fx_powerup_on_green_zmb", fxOrg, "tag_origin" );			
			trig thread offer_reward_timed(reward,num,fxOrg);
		}
		wait .01;
	}
}

function offer_reward_timed(reward,num,fxOrg)
{
	self endon("reward_taken");
	self.has_reward = true;
	fxOrg thread point_share_drop_float();
	player = GetPlayers()[num];
	while(player UseButtonPressed()) wait .1;
	player.challenge_reward_back destroy();
	player.challenge_reward_text destroy();
	player.ancient_evil_challenge_power = 0;
	self thread timed_reward_stop(30);
	while(isdefined(self.has_reward))
	{
		player = GetPlayers()[num];
		if(player UseButtonPressed() && player istouching(self))
		{
			if(isdefined(self.has_reward))
				player thread [[ level.ancient_evil_challenge_reward[reward].reward_func ]](level.ancient_evil_challenge_reward[reward].reward_parm);
			if(isdefined(fxOrg))
				fxOrg delete();
			self.has_reward = undefined;
			self notify("reward_taken");
		}
		wait .01;
	}
	if(isdefined(fxOrg))
		fxOrg delete();
	self.has_reward = undefined;
}

function point_share_drop_float()
{
	self endon( "death" );
	while ( isdefined( self ) )
	{
		waittime = randomfloatrange( 2.5, 5 );
		yaw = RandomInt( 360 );
		if( yaw > 300 )
			yaw = 300;
		else if( yaw < 60 )
			yaw = 60;
		yaw = self.angles[1] + yaw;
		new_angles = (-60 + randomint( 120 ), yaw, -45 + randomint( 90 ));
		self rotateto( new_angles, waittime, waittime * 0.5, waittime * 0.5 );
		wait randomfloat( waittime - 0.1 );
	}
}

function timed_reward_stop(time)
{
	self endon("reward_taken");
	wait time;
	self.has_reward = undefined;
}

function show_only_to_player(num)
{
	while(1)
	{
		self SetInvisibleToAll(); 
		self SetVisibleToPlayer( GetPlayers()[num] );
		wait 1;
	}
}

function add_ancient_evil_challenge_power(num)
{
	bar_back = undefined;
	original_num = self.ancient_evil_challenge_power;
	self.ancient_evil_challenge_power += num;
	if(self.ancient_evil_challenge_power >= 100)
	{
		if(original_num < self.ancient_evil_challenge_power)
		{
		
		}
		self.ancient_evil_challenge_power = 100;
	}
	else
		bar_back = reap_create_hud_icon("left", "middle", "left", "middle", 0, -10, 0, CHALLENGE_ICON_BACKER, 150, 30, (0,1,0));
	if(self.ancient_evil_challenge_power > 25)
	{
		if(!isdefined(self.challenge_reward_back))
			self.challenge_reward_back = reap_create_hud_icon("left", "middle", "left", "middle", 15, 15, .5, CHALLENGE_ICON_BACKER, 120, 15, (0,0,0));
		if(!isdefined(self.challenge_reward_text))
			self.challenge_reward_text = reap_create_hud_text("left", "middle", "left", "middle", 15, 15, 1, (1,1,1), "", 1.2);
		reward = "^7Common";
		if(self.ancient_evil_challenge_power > 50)
			reward = "^2Uncommon";
		if(self.ancient_evil_challenge_power > 75)
			reward = "^4Rare";
		if(self.ancient_evil_challenge_power == 100)
			reward = "^1Epic";
			
		self.challenge_reward_text setText("^3Reward Avaliable: " + reward);
	}
	if(isdefined(bar_back))
	{
		bar_back FadeOverTime( .3 );
		bar_back.alpha = .4;
		wait( .3 );
		bar_back FadeOverTime( .3 );
		bar_back.alpha = 0;
		wait( .3 );
		bar_back destroy();
	}
}

function add_challenege(challenege_name, challenege_thread, challenege_description)
{		
	if(!isdefined(level.ancient_evil_challenges))
		level.ancient_evil_challenges = [];
	challenege = SpawnStruct();
	challenege.challenege_name = challenege_name;
	if(isdefined(challenege_thread))
		challenege.challenege_thread = challenege_thread;
	challenege.challenege_description = challenege_description;
		
	level.ancient_evil_challenges[level.ancient_evil_challenges.size] = challenege;
}

function on_player_connect()
{
	self.ancient_evil_challenge_power = 0;
	self thread watch_for_headshots();
}

function watch_for_headshots()
{
	self endon("disconnect");
	headshots = 0;
	while(1)
	{
		self waittill( "zom_kill" );
		if(self.headshots > headshots)
		{
			self notify( "zom_kill_headshot" );
			headshots = self.headshots;
		}
		if(self GetStance() == "crouch")
			self notify( "crouched_kill" );
	}
}

function reap_create_hud_icon(aligX, aligY, horzAlin, vertAlin, x, y, alp, icon, icon_x, icon_y, color)
{
	hud = undefined;
	if(self == level)
		hud = newHudElem();
	else
		hud = NewClientHudElem( self );
	hud.alignX = aligX; 
	hud.alignY = aligY;
	hud.horzAlign = horzAlin; 
	hud.vertAlign = vertAlin;
	hud.x = x;
	hud.y = y;
	hud.alpha = alp;
	hud.color = color;
	hud SetShader( icon, icon_x, icon_y );
	
	return hud;
}

function reap_create_hud_text(aligX, aligY, horzAlin, vertAlin, x, y, alp, color, text, size)
{
	hud = undefined;
	if(self == level)
		hud = newHudElem();
	else
		hud = NewClientHudElem( self );
	hud.alignX = aligX; 
	hud.alignY = aligY;
	hud.horzAlign = horzAlin; 
	hud.vertAlign = vertAlin;
	hud.x = x;
	hud.y = y;
	hud.alpha = alp;
	hud.color = color;
	hud.fontScale = size;
	hud setText( text );
	
	return hud;
}

function spawn_powerup(pow)
{
	zm_powerups::specific_powerup_drop( pow, self.origin);
}

function bonus_points(num)
{
	self zm_score::add_to_player_score( num );
}

function free_gun(gun)
{
	self thread zm_weapons::weapon_give(gun);
}

function generic_challenge_notify(power,noty)
{
	self endon("disconnect");
	level endon("challenge_timeout");
	while(1)
	{
		self waittill(noty);
		self thread add_ancient_evil_challenge_power(power);
	}
}

function challenege_headshot()
{
	foreach(player in GetPlayers())
		player thread generic_challenge_notify(2,"zom_kill_headshot");
}

function challenege_kill()
{
	foreach(player in GetPlayers())
		player thread generic_challenge_notify(1,"zom_kill");
}

function challenege_melee()
{
	foreach(player in GetPlayers())
		player thread generic_challenge_notify(3,"melee_kill");
}

function challenege_dodge()
{
	foreach(player in GetPlayers())
		player thread challenege_dodge_track();	
}

function challenege_dodge_track()
{
	level endon("challenge_timeout");
	self endon("disconnect");
	self.challenge_has_been_hit = undefined;
	self thread challenege_dodge_hit_track();
	while(1)
	{
		wait 2;
		if(!isdefined(self.challenge_has_been_hit))
			self thread add_ancient_evil_challenge_power(1);
	}
}
function challenege_dodge_hit_track()
{
	level endon("challenge_timeout");
	self endon("disconnect");
	while(1)
	{
		self waittill( "damage", mod, attacker );
		self.challenge_has_been_hit = true;
		wait 15;
		self.challenge_has_been_hit = undefined;
	}
}

function challenege_spender()
{
	level endon("challenge_timeout");
	while(1)
	{
		level waittill( "spent_points", player, points );
		power = int(points/1000);
		if(power > 0)
			player thread add_ancient_evil_challenge_power(power);
	}
}

function challenege_lurker()
{
	foreach(player in GetPlayers())
		player thread generic_challenge_notify(2,"crouched_kill");
}

function challenege_anchored()
{
	foreach(player in GetPlayers())
		player thread challenege_anchored_watch();
}

function challenege_anchored_watch()
{
	level endon("challenge_timeout");
	self endon("disconnect");
	or = self.origin;
	while(1)
	{
		wait 2;
		if(distance (or, self.origin) < 10)
			self thread add_ancient_evil_challenge_power(2);
		or = self.origin;
	}
}
