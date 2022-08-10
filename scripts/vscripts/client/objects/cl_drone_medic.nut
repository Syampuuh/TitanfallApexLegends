global function ClDroneMedic_Init


void function ClDroneMedic_Init()
{
	ModelFX_BeginData( "thrusters", $"mdl/props/lifeline_drone/lifeline_drone.rmdl", "all", false )

		                        
		            
		                        
			ModelFX_AddTagSpawnFX( "vent_LF", $"P_LL_med_drone_jet_loop" )
			ModelFX_AddTagSpawnFX( "vent_LR", $"P_LL_med_drone_jet_loop" )
			ModelFX_AddTagSpawnFX( "vent_RR", $"P_LL_med_drone_jet_loop" )
			ModelFX_AddTagSpawnFX( "vent_RF", $"P_LL_med_drone_jet_loop" )
			ModelFX_AddTagSpawnFX( "vent_bot", $"P_LL_med_drone_jet_ctr_loop" )

	ModelFX_EndData()
	                        
	                                  
	ModelFX_BeginData( "thrustersleftside_burst", $"mdl/props/lifeline_drone/lifeline_drone.rmdl", "all", false )

		                 
			ModelFX_AddTagSpawnFX( "vent_LF", $"P_emote_lifeline_dj_drone_jet" )
			ModelFX_AddTagSpawnFX( "vent_LR", $"P_emote_lifeline_dj_drone_jet" )

	ModelFX_EndData()
	                        
	                                   
	ModelFX_BeginData( "thrustersrightside_burst", $"mdl/props/lifeline_drone/lifeline_drone.rmdl", "all", false )

		                  
			ModelFX_AddTagSpawnFX( "vent_RF", $"P_emote_lifeline_dj_drone_jet" )
			ModelFX_AddTagSpawnFX( "vent_RR", $"P_emote_lifeline_dj_drone_jet" )

	ModelFX_EndData()
	                        
	                            
	ModelFX_BeginData( "eyeglow_burst", $"mdl/props/lifeline_drone/lifeline_drone.rmdl", "all", false )

		                
			ModelFX_AddTagSpawnFX( "EYEGLOW", $"P_emote_lifeline_dj_drone_eye" )

	ModelFX_EndData()
	                        



	ModelFX_BeginData( "eyeglow", $"mdl/props/lifeline_drone/lifeline_drone.rmdl", "all", false )

		                        
		      
		                        
			ModelFX_AddTagSpawnFX( "EYEGLOW", $"P_LL_med_drone_eye"  )

	ModelFX_EndData()

	ModelFX_BeginData( "thrusters_attack", $"mdl/props/lifeline_drone/lifeline_drone.rmdl", "all", false )

		                        
		            
		                        
			ModelFX_AddTagSpawnFX( "vent_bot", $"P_LL_med_drone_jet_ctr_loop_attk" )

	ModelFX_EndData()

	ModelFX_BeginData( "eyeglow_attack", $"mdl/props/lifeline_drone/lifeline_drone.rmdl", "all", false )

		                        
		      
		                        
			ModelFX_AddTagSpawnFX( "EYEGLOW", $"P_LL_med_drone_eye_attk"  )

	ModelFX_EndData()
}



