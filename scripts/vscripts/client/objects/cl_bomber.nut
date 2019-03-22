global function ClBomber_Init


//

bool initialized = false

void function ClBomber_Init()
{
	if ( initialized )
		return
	initialized = true


	ModelFX_BeginData( "thrusters", $"mdl/vehicle/imc_bomber/bomber.rmdl", "all", true )
		//
		//
		//
		ModelFX_AddTagSpawnFX( "L_exhaust_side_1", $"P_veh_bomber_jet_LF" )
		ModelFX_AddTagSpawnFX( "L_exhaust_side_2", $"P_veh_bomber_jet_LR" )

		ModelFX_AddTagSpawnFX( "R_exhaust_side_1", $"P_veh_bomber_jet_RF" )
		ModelFX_AddTagSpawnFX( "R_exhaust_side_2", $"P_veh_bomber_jet_RR" )

		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"P_veh_bomber_jet_rear" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"P_veh_bomber_jet_rear" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_3", $"P_veh_bomber_jet_rear" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_4", $"P_veh_bomber_jet_rear" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"P_veh_bomber_jet_rear" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"P_veh_bomber_jet_rear" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_3", $"P_veh_bomber_jet_rear" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_4", $"P_veh_bomber_jet_rear" )
	ModelFX_EndData()

	ModelFX_BeginData( "dropshipDamage", $"mdl/vehicle/imc_bomber/bomber.rmdl", "all", true )
		//
		//
		//
		ModelFX_AddTagHealthFX( 0.80, "L_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.80, "L_exhaust_rear_2", $"xo_health_smoke_white", false )

		ModelFX_AddTagHealthFX( 0.75, "R_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.75, "R_exhaust_rear_2", $"xo_health_smoke_white", false )

		ModelFX_AddTagHealthFX( 0.50, "L_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.50, "L_exhaust_rear_2", $"veh_chunk_trail", false )

		ModelFX_AddTagHealthFX( 0.45, "R_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.45, "R_exhaust_rear_2", $"veh_chunk_trail", false )
	ModelFX_EndData()


	//
	//
	//
	//
	//
	//
}