#if SERVER
                                                       
                                                
#endif

global function MpMaggieCommon_Init
global function MaggieCommon_KnockbackTargetFromAttacker
global function MaggieCommon_KnockbackTargetFromEntity
global function MaggieCommon_CleanUpFX
global function MaggieCommon_GetTrapToDestroyNames

struct
{
	                                                                                                                     
	array<string> destroyTrapNames = [
		"caustic_trap",
		"tesla_trap_proxy",
		"crypto_camera",
		"crypto_camera_ultimate",
		"debris_trap",
		TROPHY_SYSTEM_NAME,
		"cover_wall",
		"mounted_turret_placeable",
	]
}
file

                                   
                                   
                                   

void function MpMaggieCommon_Init()
{
	RegisterSignal( "MaggieCommon_StopImpactTableFX" )
}

void function MaggieCommon_CleanUpFX( entity fx, float time )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	EndSignal( fx, "OnDestroy" )
	entity fxParent = fx.GetParent()
	if ( IsValid( fxParent ) )
		EndSignal( fxParent, "OnDeath", "OnDestroy" )

	OnThreadEnd(
		function() : ( fx )
		{
			if ( IsValid( fx ) )
				fx.Destroy()
		}
	)

	wait time
}

void function MaggieCommon_KnockbackTargetFromAttacker( entity attacker, entity target, float magnitude = 350 )
{
	if ( IsValid( target ) )
	{
		vector lookDirection		= attacker.GetViewForward()
		vector pushBackVelocity		= magnitude * lookDirection

		if ( target.IsPlayer() || target.IsNPC() || target.IsPlayerDecoy() )
		{
			vector targetDirection = target.GetWorldSpaceCenter() - attacker.GetWorldSpaceCenter()
			if ( DotProduct( lookDirection, targetDirection ) < 0 )
				pushBackVelocity = -pushBackVelocity

			if ( target.IsPlayer() )
			{
				if ( LengthSqr( pushBackVelocity ) > 0.0 )
					target.KnockBack( pushBackVelocity, 0.25 )
			}
#if SERVER
			    
			 
				                                                     
				                                                   
			 
#endif
		}
	}
}

void function MaggieCommon_KnockbackTargetFromEntity( entity ent, entity target, float magnitude = 300.0, vector sourceOffset = <0.0, 0.0, 0.0> )
{
	if ( !IsValid( target ) )
		return

	if ( target.IsPlayer() || target.IsNPC() || target.IsPlayerDecoy() )
	{
		vector dir					= Normalize ( ( target.GetOrigin() + <0.0, 0.0, 40.0> ) - ( ent.GetOrigin() + sourceOffset ) )
		vector pushBackVelocity		= magnitude * dir
		pushBackVelocity 			= < pushBackVelocity.x, pushBackVelocity.y, 300.0 >

		if ( target.IsPlayer() )
		{
			if ( LengthSqr( pushBackVelocity ) > 0.0 )
				target.KnockBack( pushBackVelocity, 0.25 )
		}
	#if SERVER
		    
		 
			                                                     
			                                                   
		 
	#endif
	}
}

array<string> function MaggieCommon_GetTrapToDestroyNames()
{
	return file.destroyTrapNames
}

                         
                         
                         

#if SERVER
                                                                                                   
 
	                                 

	                                            
		            

	                        
		            

	                                      
		            

	                                                           
	 
		                                        
			           
		                                                    
			            
		             
			           
	 

	                        
		           

	                                                            
		           

	            
 

                                                                                                                                                                                                                            
 
	                                                                     

	                                                  

	                             
	                                  

	                                 

	                                                
	 
		                                                     

		                                                                           
			                                                                                                         
		    
			                                        

		               
	 
 
#endif              