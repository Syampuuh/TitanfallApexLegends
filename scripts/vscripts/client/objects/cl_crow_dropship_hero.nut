global function ClCrowDropshipHero_Init


void function ClCrowDropshipHero_Init()
{
	ModelFX_BeginData( "friend_lights", $"mdl/vehicle/crow_dropship/crow_dropship_hero.rmdl", "friend", true )
		//
		//
		//
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_blue" )
	ModelFX_EndData()

	ModelFX_BeginData( "foe_lights", $"mdl/vehicle/crow_dropship/crow_dropship_hero.rmdl", "foe", true )
		//
		//
		//
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_red" )
	ModelFX_EndData()

	ModelFX_BeginData( "thrusters", $"mdl/vehicle/crow_dropship/crow_dropship_hero.rmdl", "all", true )
		//
		//
		//
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"veh_crow_jet1_full" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"veh_crow_jet2_full" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"veh_crow_jet1_full" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"veh_crow_jet2_full" )
	ModelFX_EndData()

	ModelFX_BeginData( "afterburners", $"mdl/vehicle/crow_dropship/crow_dropship_hero.rmdl", "all", false )
		//
		//
		//
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"P_afterburn_crow1" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"P_afterburn_crow1" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"P_afterburn_crow1" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"P_afterburn_crow1" )
	ModelFX_EndData()

	ModelFX_BeginData( "dropshipDamage", $"mdl/vehicle/crow_dropship/crow_dropship_hero.rmdl", "all", true )
		//
		//
		//
		ModelFX_AddTagHealthFX( 0.80, "L_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.80, "L_exhaust_rear_2", $"xo_health_smoke_white", false )

		ModelFX_AddTagHealthFX( 0.60, "R_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.60, "R_exhaust_rear_2", $"xo_health_smoke_white", false )

		ModelFX_AddTagHealthFX( 0.40, "L_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.40, "L_exhaust_rear_2", $"veh_chunk_trail", false )

		ModelFX_AddTagHealthFX( 0.20, "R_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.20, "R_exhaust_rear_2", $"veh_chunk_trail", false )
	ModelFX_EndData()
}