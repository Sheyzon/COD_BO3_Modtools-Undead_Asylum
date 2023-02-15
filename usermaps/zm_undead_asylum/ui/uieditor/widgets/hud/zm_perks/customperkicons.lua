CoD.Zombie.CommonHudRequire()
CoD.CustomPerkIcons = InheritFrom(LUI.UIElement)

function CoD.CustomPerkIcons.return_array()
    local array =
	{
		quick_revive 						= "i_t7_specialty_quickrevive",
		doubletap2 							= "i_t7_specialty_doubletap2",
		juggernaut 							= "i_t7_specialty_armorvest",
		sleight_of_hand 					= "i_t7_specialty_fastreload",
		dead_shot 							= "i_t7_specialty_deadshot",
		phdflopper 							= "i_t7_specialty_phdflopper",
		marathon 							= "i_t7_specialty_staminup",
		additional_primary_weapon 	= "i_t7_specialty_additionalprimaryweapon",
		tombstone 							= "i_t7_specialty_tombstone",
		whoswho 								= "i_t7_specialty_whoswho",
		electric_cherry 						= "i_t7_specialty_electriccherry",
        vultureaid 								= "i_t7_specialty_vultureaid",
		widows_wine 						= "i_t7_specialty_widowswine"
	}
	return array
end