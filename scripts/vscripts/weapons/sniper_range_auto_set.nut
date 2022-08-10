global function SniperRangeAutoSet_Init

#if CLIENT
global function SniperRangeAutoSet_Start
global function SniperRangeAutoSet_Stop
#endif

const bool SNIPER_RANGE_DEBUG_DRAW = false


                                                           
   
  	                                                                         
  		      
  
  	                                                                             
  	                               
  		      
  
  	                                   
  	 
  		                                               
  		                                                                                                                                              
  
  		                                                                   
  
  		                                                                           
  
  	 
   

void function SniperRangeAutoSet_Init( )
{
	                                                                                             

	#if CLIENT
	                                                                                      

	RegisterSignal( "EndHawkAutoSetThread" )                           
	#endif         
}

#if CLIENT

void function SniperRangeAutoSet_Start( entity player )
{
	if ( IsValid(player) )
		thread SniperRangeAutoSet_Thread( player )
}

void function SniperRangeAutoSet_Stop( entity player )
{
	if ( IsValid(player) )
		player.Signal( "EndHawkAutoSetThread" )
}

void function SniperRangeAutoSet_Thread( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	player.EndSignal( "OnDeath" )
	player.EndSignal( "EndHawkAutoSetThread" )

	if ( IsValid( player ) )
		SetSniperRange( player, 1.0 )

	OnThreadEnd(
		function() : ( player)
		{
			if ( IsValid( player ) )
			{
				SetSniperRange( player, 0.0 )
			}
			#if DEV
				if ( SNIPER_RANGE_DEBUG_DRAW )
				{
					printt( "HawkAutoSetThread ENDED" )
				}
			#endif      
		}
	)


	float currentViewPlayerTime = 0.0
	entity currentViewPlayer    = null
	while( true )
	{
		entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if ( !IsValid( activeWeapon ) )
			break

		entity traceHit    = player.GetTargetUnderCrosshair()
		vector traceEndPos = player.GetCrosshairTraceEndPos()
		entity scopeTrackingTarget = SniperRecon_GetBestTarget( player )
		if ( SniperRecon_IsTracking( player ) )
		{
			scopeTrackingTarget = SniperRecon_GetBestTarget( player )
		}

		if ( IsValid( scopeTrackingTarget ) )
		{
			float distance = Distance( player.EyePosition(), scopeTrackingTarget.GetWorldSpaceCenter() )
			                                                                        
			SetSniperRange( player, distance )
		}
		else if ( IsValid( traceHit ) &&  traceHit.IsPlayer() )
		{
			float distance = Distance( player.EyePosition(), traceEndPos )
			SetSniperRange( player, distance )

		}
		else
		{
			#if DEV
				if ( SNIPER_RANGE_DEBUG_DRAW )
				{
					float distance = Distance( player.EyePosition(), traceEndPos )

					DebugDrawLine( player.EyePosition(), traceEndPos, COLOR_YELLOW, false, 0.3 )
					DebugDrawSphere( traceEndPos, 3, COLOR_YELLOW, false, 0.3 )

					entity aaTarget = GetAimAssistCurrentTarget()
					if ( IsValid(aaTarget) )
					{
						DebugDrawSphere( aaTarget.GetOrigin(), 3, COLOR_MAGENTA, false, 0.3 )
					}


				}
			#endif
		}
		wait 0.1
	}
}

void function SetSniperRange( entity player, float distance )
{
	if ( !IsValid( player ) )
		return

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( activeWeapon ) )
		return

	float distanceMeters = distance * INCHES_TO_METERS

	#if DEV
		if ( SNIPER_RANGE_DEBUG_DRAW )
		{
			printt( "Hawk Zero Distance Set " + distanceMeters )
		}
	#endif

	activeWeapon.SetSniperRangeDotDistance( distanceMeters )
}

#endif              

#if SERVER
                                                                              
   
  	                         
  		      
  
  	                                                                             
  	                               
  		      
  
  	                                                                     
  	                                                 
  	                                                                     
  	                                                  
  
  	       
  		                 
  		 
  			                                                    
  		 
  	      
  
  	                                                        
   
#endif