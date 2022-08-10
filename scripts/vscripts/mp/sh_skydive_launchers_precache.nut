global function ShPrecacheSkydiveLauncherAssets

void function ShPrecacheSkydiveLauncherAssets()
{
	FX_SKYDIVE_LAUNCHER_LOOP_DEFAULT = $"P_launchpad_winter"                                                                      
	FX_SKYDIVE_LAUNCHER_LOOP_NO_SNOW = $"P_launchpad_winter_AR"
	PrecacheParticleSystem( FX_SKYDIVE_LAUNCHER_LOOP_DEFAULT )
	PrecacheParticleSystem( FX_SKYDIVE_LAUNCHER_LOOP_NO_SNOW )

	FX_SKYDIVE_LAUNCHER_GRAVITY_MINI_IDLE = $"P_gravity_launcher_hld"
	PrecacheParticleSystem( FX_SKYDIVE_LAUNCHER_GRAVITY_MINI_IDLE )

	#if SERVER
		                                                         
		                                                                        
		                                               
		                                                    

		                                                                                  
		                                                    

		                                                                      
		                                                                 

                  
                                                                         
                                                                      
        
	#endif
}