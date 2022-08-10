global function PassiveHeartbeatSensor_Init
global function OnWeaponPrimaryAttack_ability_heartbeat_sensor
global function OnWeaponAttemptOffhandSwitch_ability_heartbeat_sensor
global function OnWeaponActivate_ability_heartbeat_sensor
global function OnWeaponDeactivate_ability_heartbeat_sensor
global function ActivateHeartbeatSensor
global function DeactivateHeartbeatSensor
global function GetHeartbeatSensorRange
#if CLIENT
global function InitializeHeartbeatSensorUI
#endif         

#if SERVER
                                                    
                                                        
                                                       
                                                      
#endif         
global const float HEARTBEAT_SENSOR_NATURAL_RANGE = 75 / INCHES_TO_METERS            
global const float HEARTBEAT_SENSOR_PING_INTERVAL = 1.75
global const float HEARTBEAT_SENSOR_PING_INTERVAL_MIN = 0.4
const float TICK_RATE = 0.01
const float HEARTBEAT_SOUND_BAR_WAIT_TIME = 0.28                                                                  
const float HEARTBEAT_SENSOR_MIN_ZOOM_FOV = 55
const float HEARTBEAT_SENSOR_MAX_ZOOM_FOV = 8.01071                   
const float HEARTBEAT_SENSOR_MIN_WATCH_RANGE = 5500
const float HEARTBEAT_SENSOR_MAX_WATCH_RANGE = 20000
const float HEARTBEAT_SENSOR_RANGE_VISUAL_COMBAT_THRESHOLD = 2.0
const float HEARTBEAT_SENSOR_RANGE_VISUAL_DEBOUNCE_THRESHOLD = 3.5
                                   
const float HEARTBEAT_SENSOR_TEAMMATES_COMMS_DISPLAYTIME = 6.0
const float HEARTBEAT_SENSOR_REPORT_DELAY = 1.75
const float HEARTBEAT_SENSOR_COMMS_COOLDOWN_CLEAR_AFTER_ENEMIES = 15.0
const float HEARTBEAT_SENSOR_COMMS_COOLDOWN = 35.0
const float HEARTBEAT_SENSOR_STATE_COOLDOWN = 1.75
const float HEARTBEAT_SENSOR_GLOBAL_COOLDOWN = 3.5
const float HEARTBEAT_SENSOR_REPORT_LISTEN_DELAY = 2.0
                                        
const int HEARTBEAT_SENSOR_OFFHAND_INDEX = OFFHAND_EQUIPMENT
const int MAX_HEARTBEAT_SENSOR_TARGETS = 10                   

const asset HEARTBEAT_SENSOR_RADIUS_FX = $"P_decoy_grenade_radius_ping"

const string HEARTBEAT_SENSOR_HEARTBEAT_SOUND_3P = "Seer_Passive_Heartbeat_3p"
const string HEARTBEAT_SENSOR_ACTIVE_SOUND_3P = "Seer_Passive_HeartbeatSensor_3p"
const string HEARTBEAT_SENSOR_ACTIVE_SOUND_1P = "Seer_Passive_HeartbeatSensor_1p"

const asset FX_HEARTBEAT_SENSOR_EYEGLOW_FRIEND = $"p_heart_sensor_eye_foe"                                
const asset FX_HEARTBEAT_SENSOR_EYEGLOW_FOE = $"p_heart_sensor_eye_foe"
const asset FX_HEARTBEAT_SENSOR_SONAR_PULSE = $"P_heart_sensor_pulse_1p"
const asset FX_HEARTBEAT_SENSOR_SONAR_PULSE_NO_INTRO = $"P_heart_sensor_on_1p"

                            
                                                                                          
                                 

#if DEV
const bool HEARTBEAT_SENSOR_DEBUG = false
const bool HEARTBEAT_SENSOR_DEBUG_VERBOSE = false
const bool HEARTBEAT_SENSOR_WEAPON_MODS_DEBUG = false
const bool HEARTBEAT_SENSOR_STAT_TRACKING_DEBUG = false
                                   
const bool HEARTBEAT_SENSOR_COMMS_DEBUG = false
                                        
#endif      

struct BarData
{
	float angle
	float lastGameTimeBeat
	bool isLocked
	bool inTacRange
}

struct
{
	#if CLIENT
		table<entity, int> heartbeatSensorEyeVFX                                 
		array<entity> heartbeatSensorVictims
		table<entity, BarData> waveformRadialValueTable
		table<entity, PlayersInViewInfo> victimPlayerViewportInfo
		entity bestVictimForAudio
		bool hasTargetLocked
		int heartbeatsHeardWhileActive
		float lastHeartbeatSensorActivationTime
                                    
		float         lastCommsTimeEnemies
		float         lastCommsTimeClear
		float         lastCommsTimeClearInCombat
		float         lastCommsTimeEither
		vector        lastCommsLocation
		float         commsResetRange
		float	      commsEnemyRemovalRange
		array<entity> lastHeardEnemies
		float		  lastHeardHeartbeatTime
                                         
                             
                                              
                                  
	#endif         
	#if SERVER
		                                                      
	#endif         
	var heartbeatSensorRui
	float heartbeatSensorRange
	float heartbeatSensorRangeSqr
	float sonicBlastRange
} file

                                                                                                                       
              
                                                                                                                       
void function PassiveHeartbeatSensor_Init()
{
	PrecacheWeapon( "mp_ability_heartbeat_sensor" )
	RegisterSignal( "DestroyHeartbeatSensor" )                                        
	RegisterSignal( "EndHeartbeatSensorUI" )               

	file.heartbeatSensorRange = GetHeartbeatSensorRange()
	file.heartbeatSensorRangeSqr = pow( file.heartbeatSensorRange, 2 )
	file.sonicBlastRange = GetSonicBlastRange()

	#if CLIENT
	RegisterSignal( "EndHeartbeatSensorVictimManager" )                                                                    

	RegisterSignal( "StopWatchingHeartbeatSensorVictim" )                                                                                          
	AddCallback_ClientOnPlayerConnectionStateChanged( OnClientConnectionChanged )
	AddCallback_OnViewPlayerChanged( HeartbeatSensor_OnLocalViewPlayerChanged )
	RegisterConCommandTriggeredCallback( "+scriptCommand5", HeartbeatSensorTogglePressed )

                                    
	file.lastCommsTimeEnemies = -100.0
	file.lastCommsTimeClear = -100.0
	file.lastCommsTimeClearInCombat = -100.0
	file.lastCommsTimeEither = -100.0

	file.lastCommsLocation = ZERO_VECTOR
	file.commsResetRange = file.sonicBlastRange * 0.75                                                                     
	file.commsEnemyRemovalRange = file.sonicBlastRange * 1.35                                                                                                                 
                                         
	#endif         

	PrecacheParticleSystem( FX_HEARTBEAT_SENSOR_EYEGLOW_FRIEND )
	PrecacheParticleSystem( FX_HEARTBEAT_SENSOR_EYEGLOW_FOE )
	PrecacheParticleSystem( FX_HEARTBEAT_SENSOR_SONAR_PULSE )
	PrecacheParticleSystem( FX_HEARTBEAT_SENSOR_SONAR_PULSE_NO_INTRO )

	Remote_RegisterServerFunction( "ClientCallback_ToggleHeartbeatSensor" )
	Remote_RegisterServerFunction( "ClientCallback_UpdateHeartbeatsHeardStat", "int", INT_MIN, INT_MAX )

	AddCallback_OnPassiveChanged( ePassives.PAS_PARIAH, HeartbeatSensor_OnPassiveChanged )
	AddCallback_OnPlayerZoomIn( PlayerZoomInCallback )
	AddCallback_OnPlayerZoomOut( PlayerZoomOutCallback )
}

                                                                                                                       
                  
                                                                                                                       
void function HeartbeatSensor_OnPassiveChanged( entity player, int passive, bool didHave, bool nowHas )
{
	#if CLIENT
		entity localViewPlayer = GetLocalViewPlayer()
	#endif         
	if ( didHave )
	{
		#if SERVER
		                        
		 
			          
			                                                                         
			                                                          
			                                         

			                                                       
			 
				                                                     
			 
		 
		#elseif CLIENT
			if ( player == localViewPlayer )
			{
				localViewPlayer.Signal( "DestroyHeartbeatSensor" )
			}
			if ( player in file.heartbeatSensorEyeVFX )
			{
				if ( EffectDoesExist( file.heartbeatSensorEyeVFX[player] ) )
				{
					EffectStop( file.heartbeatSensorEyeVFX[player], false, true )
					delete file.heartbeatSensorEyeVFX[player]
				}
			}
		#endif         
	}
	if ( nowHas )
	{
		#if SERVER
		                                                                                             

		                                                     
		#elseif CLIENT
			if ( player == localViewPlayer )
			{
				file.heartbeatSensorVictims.clear()
			}

			if ( player in file.heartbeatSensorEyeVFX )
			{
				if ( EffectDoesExist( file.heartbeatSensorEyeVFX[player] ) )
				{
					EffectStop( file.heartbeatSensorEyeVFX[player], false, true )
					delete file.heartbeatSensorEyeVFX[player]
				}

				delete file.heartbeatSensorEyeVFX[player]
			}
		#endif         
	}
}

void function PlayerZoomInCallback( entity player )
{
	#if CLIENT
	if ( !IsAlive( player ) )
		return

	if ( !PlayerHasPassive( player, ePassives.PAS_PARIAH ) )
		return

	if ( player == GetLocalViewPlayer() )
	{
		InitializeHeartbeatSensorUI( player )

		                                                                                                                                                     
		                                             
		entity turret = player.GetTurret()
		if ( IsValid( turret ) )
		{
			ActivateHeartbeatSensor( player, false )
			thread TurretHeartbeatSensor_Thread( player )
		}
	}
	#endif         
}

#if CLIENT
void function HeartbeatSensor_OnLocalViewPlayerChanged( entity player )
{
	if ( !PlayerHasPassive( player, ePassives.PAS_PARIAH ) )
	{
		if ( file.heartbeatSensorRui != null )
		{
			player.Signal( "DestroyHeartbeatSensor" )
		}
	}
	else
	{
		                                                                                                                                                                                                                    
		if ( PlayerIsInADS( player, false ) )
		{
			if ( file.heartbeatSensorRui == null )
			{
				entity heartbeatSensor = player.GetOffhandWeapon( HEARTBEAT_SENSOR_OFFHAND_INDEX )
				if ( IsValid( heartbeatSensor ) )
				{
					                                                                                                     
					if ( heartbeatSensor.IsWeaponActivated() )
					{
						ActivateHeartbeatSensor( player, false )
					}
				}
			}
		}
	}
}

void function TurretHeartbeatSensor_Thread( entity player )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "DestroyHeartbeatSensor" )
	player.EndSignal( "EndHeartbeatSensorVictimManager" )
	player.EndSignal( "EndHeartbeatSensorUI" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
			function() : ( player )
			{
				if ( IsValid( player ) )
				{
					DeactivateHeartbeatSensor( player, false )

					                                                                                                                
					player.Signal( "EndHeartbeatSensorUI" )
				}
			}
		)

	WaitSignal( player, "DeactivateMountedTurret" )
}
#endif

void function PlayerZoomOutCallback( entity player )
{
	#if CLIENT
	if ( player == GetLocalViewPlayer() )
	{
		player.Signal("EndHeartbeatSensorUI")
	}
	#endif         
}

void function OnWeaponActivate_ability_heartbeat_sensor( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsAlive( player ) )
		return

	if ( !PlayerHasPassive( player, ePassives.PAS_PARIAH ) )
		return

	ActivateHeartbeatSensor( player, false )
}

void function OnWeaponDeactivate_ability_heartbeat_sensor( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsAlive( player ) )
		return

	if ( !PlayerHasPassive( player, ePassives.PAS_PARIAH ) )
		return

	DeactivateHeartbeatSensor( player, false )
}

bool function OnWeaponAttemptOffhandSwitch_ability_heartbeat_sensor( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) )
		return false

	if ( !player.IsPlayer() )
		return false

	return PlayerHasPassive( player, ePassives.PAS_PARIAH )
}


var function OnWeaponPrimaryAttack_ability_heartbeat_sensor( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

                                                                                       
         
                                         
                                         
                                         
         
                                         
                                         
                                         
                                         
                                                                                                                                                                  
                                                                                                                     

#if CLIENT
void function HeartbeatSensorTogglePressed( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( activeWeapon ) )
		return

	if ( StatusEffect_GetSeverity( player, eStatusEffect.silenced ) > 0 )
		return

	if ( activeWeapon.IsWeaponAdsButtonPressed() || activeWeapon.IsWeaponInAds() )
	{
		Remote_ServerCallFunction( "ClientCallback_ToggleHeartbeatSensor" )
	}
}
#endif              

#if SERVER
                                                                   
 
	                         
		      

	                                                                         

	                         
		      

	                                                                   
		      

	                                     

	                                  
		                                    
	    
		                         

	                      
 

                                                            
 
	                                                                       

	                                                                      
	 
		                                        

		                                                       
		 
			       
			                                         
			 
				                                                                          
			 
			      
			                                             
			                                 
		 
	 
 

                                                               
 
	                                                                       

	                                                                      
	 
		                                        

		                                                      
		 
			       
			                                         
			 
				                                                                            
			 
			      
			                                                        
			                                 
		 
	 
 

                                                                      
 
	                         
		      

	                                                                                                                                                                                   
	                                              
	                                        

	                                          
		                                            

	                                 
 

                                                                     
 
	                         
		      

	                                        

	                                           
		                                 

	                                 
 

                                                                                  
 
	                                                       
	 
		                                                                              

		                                                                               
		                                               

		       
		                                           
		 
			                                                                                                                                                                                                              
		 
		            

		                    
		 
			                                                       
		 
	 
 
#endif         

void function OnClientConnectionChanged( entity player )
{
	#if CLIENT
		if ( player != GetLocalClientPlayer() )
			return

		if ( !IsConnected() )
			return

		if ( !PlayerHasPassive( player, ePassives.PAS_PARIAH ) )
			return

		if ( player == GetLocalViewPlayer() )
		{
			                                                                                                                                                                                                                            
			if ( PlayerIsInADS( player, false ) )
			{
				if ( file.heartbeatSensorRui == null )
				{
					SetupHeartbeatSensorUI( player )
				}
			}
		}
	#endif
}

                                                                                                                       
                  
                                                                                                                       
#if CLIENT
void function SetupHeartbeatSensorUI( entity player )
{
	InitializeHeartbeatSensorUI( player )
	entity heartbeatSensor = player.GetOffhandWeapon( HEARTBEAT_SENSOR_OFFHAND_INDEX )

	                                                                                                     
	if ( heartbeatSensor.IsWeaponActivated() )
	{
		RuiSetBool( file.heartbeatSensorRui, "heartbeatSensorEnabled", true )
	}
	else
	{
		RuiSetBool( file.heartbeatSensorRui, "heartbeatSensorEnabled", false )
	}
}

void function InitializeHeartbeatSensorUI( entity player )
{
	if( file.heartbeatSensorRui == null )
	{
		file.heartbeatSensorRui = CreateCockpitRui( $"ui/heartbeat_sensor_waveform_radial.rpak" )
		RuiSetGameTime( file.heartbeatSensorRui, "startTime", Time() )
		entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		thread CL_HeartSeekerRUIThread( player, activeWeapon )
	}


}
#endif         

void function ActivateHeartbeatSensor( entity player, bool fromTac )
{
	#if SERVER
		                                                       
		 
			       
			                                           
			 
				                                                               
			 
			            

			                                                       
		 

		                                       
	#endif         
	#if CLIENT
		entity localViewPlayer = GetLocalViewPlayer()

		if ( player == localViewPlayer )
		{
			SetupHeartbeatSensorUI( player )

			RuiSetBool( file.heartbeatSensorRui, "heartbeatSensorEnabled", true )

			if ( fromTac )
			{
				                                                                                                                                        
				RuiSetBool( file.heartbeatSensorRui, "heartbeatSensorADSOverride", true )
			}

			thread ShowHeartbeatSensorRange_Thread( player )

			thread ManageVictims_Thread( player )
                                      
			thread ManageHeartbeatSensorComms_Thread( player )
                                           
			file.heartbeatsHeardWhileActive = 0
		}
		else
		{
			EmitSoundOnEntity( player, HEARTBEAT_SENSOR_ACTIVE_SOUND_3P )
			bool isFriendly = IsFriendlyTeam( localViewPlayer.GetTeam(), player.GetTeam() )
			int particleIndex = isFriendly ? GetParticleSystemIndex( FX_HEARTBEAT_SENSOR_EYEGLOW_FRIEND ) : GetParticleSystemIndex( FX_HEARTBEAT_SENSOR_EYEGLOW_FOE )

			if ( player in file.heartbeatSensorEyeVFX )
			{
				if ( EffectDoesExist( file.heartbeatSensorEyeVFX[player] ) )
				{
					EffectStop( file.heartbeatSensorEyeVFX[player], false, true )
					file.heartbeatSensorEyeVFX[player] = -1
				}
			}
			else
			{
				file.heartbeatSensorEyeVFX[player] <- -1
			}

			int leftEyeFX = StartParticleEffectOnEntity( player, particleIndex, FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( "EYE_L" ) )

			file.heartbeatSensorEyeVFX[player] = leftEyeFX

			                                
			                                                                                                                                      
			                                              
		}
	#endif         
}

#if CLIENT
                                   
void function ManageHeartbeatSensorComms_Thread( entity player )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "DestroyHeartbeatSensor" )
	player.EndSignal( "EndHeartbeatSensorVictimManager" )
	player.EndSignal( "EndHeartbeatSensorUI" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	float lastTimeHadEnemies = 0.0
	float lastTimeHadClear = 0.0

	if ( IsSpectating() )
		return

	wait HEARTBEAT_SENSOR_REPORT_DELAY

	while ( true  )
	{
		if ( !PlayerIsInCombat( player ) )
		{
			#if DEV
			if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
				printt(FUNC_NAME() + " Out of Combat")
			#endif      

			                                                                                                                           
			vector lastReportLocation = file.lastCommsLocation != ZERO_VECTOR ? file.lastCommsLocation : player.EyePosition()

			float deltaTimeEither = Time() - file.lastCommsTimeEither
			bool onGlobalCooldown = ( deltaTimeEither <= HEARTBEAT_SENSOR_GLOBAL_COOLDOWN )

			float deltaHeardHeartbeat = Time() - file.lastHeardHeartbeatTime

			if ( file.heartbeatSensorVictims.len() > 0 && deltaHeardHeartbeat <= HEARTBEAT_SENSOR_REPORT_LISTEN_DELAY )
			{
				#if DEV
				if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
					printt(FUNC_NAME() + " Has enemeis")
				#endif      

				lastTimeHadEnemies = Time()

				foreach ( entity enemy in file.heartbeatSensorVictims )
				{
					if ( !file.lastHeardEnemies.contains( enemy ) )
					{
						file.lastHeardEnemies.append( enemy )
					}
				}

				if ( !onGlobalCooldown )
				{
					#if DEV
					if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
						printt(FUNC_NAME() + " Off Cooldown")
					#endif      

					float distanceFromLastReport = Length( player.EyePosition() - lastReportLocation )
					float deltaTimeEnemies = Time() - file.lastCommsTimeEnemies
					float deltaTimeSinceHadClear = Time() - lastTimeHadClear

					if ( ( deltaTimeEnemies > HEARTBEAT_SENSOR_COMMS_COOLDOWN || distanceFromLastReport > file.commsResetRange ) && ( deltaTimeSinceHadClear > HEARTBEAT_SENSOR_STATE_COOLDOWN ) )
					{
						#if DEV
						if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
							printt(FUNC_NAME() + " Adding enemy prompt" )
						#endif      

						AddOnscreenPromptFunction( "quickchat", TryHeartbeatSensorEnemiesNearCommsTeammates, HEARTBEAT_SENSOR_TEAMMATES_COMMS_DISPLAYTIME, "#SEER_HEARTBEAT_SENSOR_COMMS_ENEMIES", 100 )
						file.lastCommsTimeEnemies = Time()
						file.lastCommsTimeEither  = Time()
					}
				}
			}
			else
			{
				#if DEV
				if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
					printt(FUNC_NAME() + " No enemeis")
				#endif      

				lastTimeHadClear = Time()

				if ( !onGlobalCooldown )
				{
					#if DEV
					if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
						printt(FUNC_NAME() + " Off Cooldown")
					#endif      

					float distanceFromLastReport = Length( player.EyePosition() - lastReportLocation )
					float deltaTimeClear = Time() - file.lastCommsTimeClear
					float deltaTimeEnemies = Time() - file.lastCommsTimeEnemies
					float deltaTimeSinceHadEnemies = Time() - lastTimeHadEnemies

					#if DEV
					if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
						printt(FUNC_NAME() + "distanceFromLastReport: " + distanceFromLastReport + " deltaTimeClear: " + deltaTimeClear + " deltaTimeEnemies: " + deltaTimeEnemies + " deltaTimeSinceHadEnemies: " + deltaTimeSinceHadEnemies)
					#endif      

					                                                                                                                                                                                                                                                                                                                                                                          
					if ( ( ( deltaTimeClear > HEARTBEAT_SENSOR_COMMS_COOLDOWN && deltaTimeEnemies > HEARTBEAT_SENSOR_COMMS_COOLDOWN_CLEAR_AFTER_ENEMIES ) || distanceFromLastReport > file.commsResetRange ) && ( deltaTimeSinceHadEnemies > HEARTBEAT_SENSOR_STATE_COOLDOWN ) )
					{
						#if DEV
						if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
							printt( FUNC_NAME() + " Adding clear prompt" )
						#endif      

						AddOnscreenPromptFunction( "quickchat", TryHeartbeatSensorEnemiesClearCommsTeammates, HEARTBEAT_SENSOR_TEAMMATES_COMMS_DISPLAYTIME, "#SEER_HEARTBEAT_SENSOR_COMMS_CLEAR", 100 )
						file.lastCommsTimeClear  = Time()
						file.lastCommsTimeEither = Time()
					}
				}
			}
		}
		else                                                                                                                                                                                                                         
		{
			#if DEV
			if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
				printt( FUNC_NAME() + " In Combat")
			#endif      
			bool foundAliveEnemy = false

			for ( int i = 0; i < file.lastHeardEnemies.len(); i++ )
			{
				if ( !IsValid( file.lastHeardEnemies[i] ) || !IsAlive( file.lastHeardEnemies[i] ) )
				{
					#if DEV
					if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
						printt( FUNC_NAME() + " found dead or invalid enemy in list from last comms, removing" )
					#endif      
					file.lastHeardEnemies.fastremove( i )
					i--
					continue
				}
				else if ( Length( player.EyePosition() - file.lastHeardEnemies[i].EyePosition() ) > file.commsEnemyRemovalRange )
				{
					#if DEV
						if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
							printt( FUNC_NAME() + " enemy is far enoughaway from Seer that we no longer want to track them, removing." )
					#endif      
					file.lastHeardEnemies.fastremove( i )
					i--
					continue
				}
				else if ( IsAlive( file.lastHeardEnemies[i] ) )
				{
					#if DEV
					if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
						printt( FUNC_NAME() + " found alive enemy from last group seen" )
					#endif      

					foundAliveEnemy = true
					lastTimeHadEnemies = Time()
					break
				}
			}

			                                                                                  
			if ( !foundAliveEnemy && ( file.heartbeatSensorVictims.len() == 0 ) )
			{
				#if DEV
				if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
					printt( FUNC_NAME() + " !foundAliveEnemy && ( file.heartbeatSensorVictims.len() == 0 )")
				#endif      

				float deltaTimeClear = Time() - file.lastCommsTimeClearInCombat
				float deltaTimeEither = Time() - file.lastCommsTimeEither
				float deltaTimeHadEnemies = Time() - lastTimeHadEnemies

				#if DEV
				if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
					printt(FUNC_NAME() + "deltaTimeEither: " + deltaTimeEither + " deltaTimeClear: " + deltaTimeClear + " deltaTimeHadEnemies: " + deltaTimeHadEnemies)
				#endif      

				                                                 
				if ( ( ( deltaTimeClear > HEARTBEAT_SENSOR_COMMS_COOLDOWN ) ) && ( deltaTimeEither > HEARTBEAT_SENSOR_GLOBAL_COOLDOWN ) && ( deltaTimeHadEnemies > HEARTBEAT_SENSOR_GLOBAL_COOLDOWN ) )
				{
					AddOnscreenPromptFunction( "quickchat", TryHeartbeatSensorEnemiesClearCommsTeammates, HEARTBEAT_SENSOR_TEAMMATES_COMMS_DISPLAYTIME, "#SEER_HEARTBEAT_SENSOR_COMMS_CLEAR", 100 )
					file.lastCommsTimeClear  = Time()
					file.lastCommsTimeClearInCombat = Time()
					file.lastCommsTimeEither = Time()
				}
			}
			#if DEV
			else if ( HEARTBEAT_SENSOR_COMMS_DEBUG )
			{
				printt(FUNC_NAME() + " found alive enemy from last ping")
			}
			#endif      
		}

		wait 0.1
	}
}

void function TryHeartbeatSensorEnemiesNearCommsTeammates( entity player )
{
	Quickchat( GetLocalViewPlayer(), eCommsAction.HEARTBEAT_SENSOR_DETECT_ENEMY )

	file.lastCommsLocation = player.EyePosition()
}

void function TryHeartbeatSensorEnemiesClearCommsTeammates( entity player )
{
	Quickchat( GetLocalViewPlayer(), eCommsAction.HEARTBEAT_SENSOR_NO_ENEMY )
	file.lastCommsLocation = player.EyePosition()
	                                                                                                                                                                                                                                                 
	file.lastCommsTimeEnemies = 0.0
}
                                        

void function ShowHeartbeatSensorRange_Thread( entity player )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "DestroyHeartbeatSensor" )
	player.EndSignal( "EndHeartbeatSensorVictimManager" )
	player.EndSignal( "EndHeartbeatSensorUI" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	entity weapon     = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( IsValid( weapon ) )
	{
		EmitSoundOnEntity( player, HEARTBEAT_SENSOR_ACTIVE_SOUND_1P )

		float activationTime = Time()

		float lastFireTimeWeapon = weapon.GetLastWeaponFireTime()
		bool inWeaponCombat 	 = lastFireTimeWeapon > ( activationTime - HEARTBEAT_SENSOR_RANGE_VISUAL_COMBAT_THRESHOLD )
		bool showRangeDebounce 	 = file.lastHeartbeatSensorActivationTime > ( activationTime - HEARTBEAT_SENSOR_RANGE_VISUAL_DEBOUNCE_THRESHOLD )
		                                                                                               
		int fxId          		 = ( inWeaponCombat || showRangeDebounce ) ? GetParticleSystemIndex( FX_HEARTBEAT_SENSOR_SONAR_PULSE_NO_INTRO ) : GetParticleSystemIndex( FX_HEARTBEAT_SENSOR_SONAR_PULSE )

		int pulseVFX      = StartParticleEffectOnEntity( player, fxId, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
		float adjustedRange = file.heartbeatSensorRange
		EffectSetControlPointVector( pulseVFX, 1, <adjustedRange, 0, 0> )

		file.lastHeartbeatSensorActivationTime = activationTime

		Minimap_SetVisiblityCone(true, file.heartbeatSensorRange, $"rui/hud/minimap/minimap_seer_tac_cone", GetKeyColor( COLORID_HUD_SEER_DEFAULT ))

		OnThreadEnd(
			function() : ( player, pulseVFX )
			{
				if ( EffectDoesExist( pulseVFX ) )
				{
					EffectStop( pulseVFX, false, true )
				}

				if ( IsValid( player ) )
				{
					StopSoundOnEntity( player, HEARTBEAT_SENSOR_ACTIVE_SOUND_1P )
				}

				Minimap_SetVisiblityCone( false, file.heartbeatSensorRange, $"rui/hud/minimap/minimap_seer_tac_cone", GetKeyColor( COLORID_HUD_SEER_DEFAULT ) )
			}
		)

		WaitForever()
	}
}
#endif         

void function DeactivateHeartbeatSensor( entity player, bool fromTac )
{
	#if SERVER
		                                          
	#endif         
	#if CLIENT
		if ( player == GetLocalViewPlayer() )
		{
			                                                                                                                                     
			                                                                                                       
			if ( file.heartbeatSensorRui != null )
			{
				RuiSetBool( file.heartbeatSensorRui, "heartbeatSensorEnabled", false )

				if ( fromTac )
				{
					RuiSetBool( file.heartbeatSensorRui, "heartbeatSensorADSOverride", false )
				}
			}

			                                                                                                    
			if ( IsSpectating() || player.Player_IsSkywardLaunching() )
			{
				player.Signal("EndHeartbeatSensorUI")
			}

			player.Signal( "EndHeartbeatSensorVictimManager" )

			if ( file.heartbeatsHeardWhileActive > 0 && !IsSpectating() )
			{
				Remote_ServerCallFunction( "ClientCallback_UpdateHeartbeatsHeardStat", file.heartbeatsHeardWhileActive )
			}
		}
		else
		{
			StopSoundOnEntity( player, HEARTBEAT_SENSOR_ACTIVE_SOUND_3P )
			if ( player in file.heartbeatSensorEyeVFX )
			{
				if ( EffectDoesExist( file.heartbeatSensorEyeVFX[player] ) )
				{
					EffectStop( file.heartbeatSensorEyeVFX[player], false, true )
					delete file.heartbeatSensorEyeVFX[player]
				}
			}
		}
	#endif         
}

#if CLIENT
void function ManageVictims_Thread( entity player )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "EndHeartbeatSensorVictimManager" )
	player.EndSignal( "DestroyHeartbeatSensor" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ( player )
		{
			file.heartbeatSensorVictims.clear()
		}
	)

	while ( true )
	{
		#if DEV
			if ( HEARTBEAT_SENSOR_DEBUG_VERBOSE )
			{
				DebugDrawSphere( player.EyePosition(), file.heartbeatSensorRange, COLOR_RED, true, 0.1 )
			}
		#endif      
		float viewportFOV = GetFOVForPlayer( player )


		                                                                                                                                                                                                                                                                                                   
		float watchRange = GraphCapped( viewportFOV, HEARTBEAT_SENSOR_MIN_ZOOM_FOV, HEARTBEAT_SENSOR_MAX_ZOOM_FOV, HEARTBEAT_SENSOR_MIN_WATCH_RANGE, HEARTBEAT_SENSOR_MAX_WATCH_RANGE )

		#if DEV
			if ( HEARTBEAT_SENSOR_DEBUG )
			{
				printt("viewportFOV: " + viewportFOV + " watchRange: " + watchRange)
				DebugDrawArrow( player.EyePosition(), player.EyePosition() + ( player.GetViewVector() * watchRange ), 10, COLOR_RED, true, 0.1)
			}
		#endif      

		array<PlayersInViewInfo> victimsInfo = player.GetPlayersInViewInfoArray( true, true, watchRange, viewportFOV, MAX_HEARTBEAT_SENSOR_TARGETS, false, file.heartbeatSensorRange )
		array<entity> victimsReturned

		float minDot = deg_cos( viewportFOV )

		                                                                                                                                               
		                                                              
		if ( IsFiringRangeGameMode() )
		{
			array<entity> dummies = GetEntArrayByScriptName( FIRING_RANGE_DUMMIE_SCRIPT_NAME )

			foreach ( entity dummy in dummies )
			{
				if ( !IsAlive( dummy ) )
					continue

				PlayersInViewInfo ornull data = GeneratePlayersInViewInfo( player, dummy, minDot, watchRange )

				if ( data != null )
					victimsInfo.append( expect PlayersInViewInfo( data ) )
			}
		}
		
		array<entity> decoys = GetEntArrayByScriptName( DECOY_SCRIPTNAME )
		decoys.extend( GetEntArrayByScriptName( CONTROLLED_DECOY_SCRIPTNAME ) )

		foreach ( entity decoy in decoys )
		{
			if ( !IsValid( decoy ) )
				continue

			if ( IsFriendlyTeam( decoy.GetTeam(), player.GetTeam() ) )
				continue

			PlayersInViewInfo ornull data = GeneratePlayersInViewInfo( player, decoy, minDot, watchRange )

			if ( data != null )
			{
				victimsInfo.append( expect PlayersInViewInfo( data ) )
			}
		}

                              
                                                                
                                               
   
                                                

                                                                
    
                                                          
    

                                                                            
                                                                                   
    
                                                                                                 

                                                                                 
     
                                
        
             
     
    
       
    
                                                            
    
   
                                   

		float bestDot = -1.0
		entity bestVictimForAudio = null

		foreach ( PlayersInViewInfo victimInfo in victimsInfo )
		{
			victimsReturned.append( victimInfo.player )

			if ( victimInfo.player in file.victimPlayerViewportInfo )
			{
				file.victimPlayerViewportInfo[victimInfo.player] = victimInfo
			}
			else
			{
				file.victimPlayerViewportInfo[victimInfo.player] <- victimInfo
			}

			if ( !file.heartbeatSensorVictims.contains( victimInfo.player ) )
			{
				HeartseekerAddWatchTarget( victimInfo, watchRange )
			}

			if ( victimInfo.dot > bestDot && victimInfo.distanceSqr <= file.heartbeatSensorRangeSqr )
			{
				bestDot = victimInfo.dot
				bestVictimForAudio = victimInfo.player
			}

			#if DEV
			if ( HEARTBEAT_SENSOR_DEBUG )
			{
				DebugDrawMark( victimInfo.player.GetWorldSpaceCenter(), 15, COLOR_RED, true, 0.1 )
			}
			#endif      
		}

		#if DEV
			if ( HEARTBEAT_SENSOR_DEBUG )
			{
				if ( IsValid( bestVictimForAudio ) )
				{
					DebugDrawMark( bestVictimForAudio.EyePosition(), 25, COLOR_GREEN, true, 0.1 )
				}
			}
		#endif      
		file.bestVictimForAudio = bestVictimForAudio

		foreach ( entity victim in file.heartbeatSensorVictims )
		{
			if ( !victimsReturned.contains( victim ) )
			{
				victim.Signal( "StopWatchingHeartbeatSensorVictim" )
				file.heartbeatSensorVictims.fastremovebyvalue( victim )
                                
                                                 
     
                                                
     
                                     
			}
		}

		wait 0.1
	}
}

PlayersInViewInfo ornull function GeneratePlayersInViewInfo( entity player, entity target, float minDot, float watchRange )
{
	if ( !IsValid( target ) )
		return null

	float dot = DotProduct( Normalize( target.GetWorldSpaceCenter() - player.EyePosition() ), player.GetViewVector() )
	float watchRangeSqr = pow( watchRange, 2 )
	float distanceSqr = DistanceSqr( player.EyePosition(), target.GetWorldSpaceCenter() )

	if ( dot < minDot )
		return null

	if ( distanceSqr > watchRangeSqr )
		return null

	PlayersInViewInfo data
	data.player = target
	data.dot = dot
	data.distanceSqr = DistanceSqr( player.EyePosition(), target.GetWorldSpaceCenter() )

	TraceResults trace = TraceLine( player.EyePosition(), target.GetWorldSpaceCenter(), null, TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
	data.hasLOS = ( trace.fraction >= 0.99 )

	return data
}

                            
                                                                
 
                        

                                                                      

                              
  
                                        
  
                                                         
  
                                                                                                                                                                                                                                                                                                
                    
  
     
  
                                                                         
                                                                                                                                           
                           
   
                                         
   
                                     
   
                                                            
                                                                                          
                           
                     
   
      
   
                                                                                                                                                                                                                                                                                        
                                                                                                                                                              
                                                                                                        

                                
      
                     
      
         
      
                                         
      
   
  

                   
 
                                 

void function HeartseekerAddWatchTarget( PlayersInViewInfo victimInfo, float watchRange )
{
	float watchRangeSqr = pow( watchRange, 2 )
	entity player = GetLocalViewPlayer()
	thread DoVictimHeartbeat_Thread( player, victimInfo.player, watchRangeSqr )
	thread UpdateVictimUIPosition_Thread( player, victimInfo.player, watchRangeSqr )
}

void function DoVictimHeartbeat_Thread( entity player, entity victim, float watchRangeSqr )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "DestroyHeartbeatSensor" )
	player.EndSignal( "EndHeartbeatSensorVictimManager" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	victim.EndSignal( "OnDestroy" )
	victim.EndSignal( "OnDeath" )
	victim.EndSignal( "StopWatchingHeartbeatSensorVictim" )

	file.heartbeatSensorVictims.append( victim )

	OnThreadEnd(
		function() : ( victim )
		{
			if ( file.heartbeatSensorVictims.contains( victim ) )
			{
				file.heartbeatSensorVictims.removebyvalue( victim )
			}
			if ( victim in file.waveformRadialValueTable )
			{
				delete file.waveformRadialValueTable[victim]
			}
		}
	)

	                                                                                                                       
	float randomWait = RandomFloatRange( HEARTBEAT_SENSOR_PING_INTERVAL_MIN, HEARTBEAT_SENSOR_PING_INTERVAL )
	wait randomWait

	while ( true )
	{
		int victimHealth = Bleedout_IsBleedingOut( victim ) ? 25 : victim.GetHealth()
		float healthPercent = float( victimHealth ) / float(victim.GetMaxHealth())

		if ( victim.IsPlayerDecoy() )
		{
			entity decoyOwner = victim.GetOwner()
			if ( IsValid( decoyOwner ) )
			{
				victimHealth = decoyOwner.GetHealth()
				healthPercent = float( victimHealth ) / float( decoyOwner.GetMaxHealth() )
			}
		}


		float scaledWait = Graph( healthPercent, 0.0, 1.0, HEARTBEAT_SENSOR_PING_INTERVAL_MIN, HEARTBEAT_SENSOR_PING_INTERVAL )
		float beatSoundTime = 0.0

		bool playAudio = IsValid( file.bestVictimForAudio ) ? victim == file.bestVictimForAudio : false

		if ( file.heartbeatSensorRui != null )
		{
			PlayersInViewInfo data = file.victimPlayerViewportInfo[victim]

			bool inTacRange = IsVicitmInTacRange( data )

			if ( inTacRange )
			{
				if ( playAudio )
				{
					file.heartbeatsHeardWhileActive++
					if ( GetConVarBool( "player_setting_enable_heartbeat_sounds" ) )
					{
						EmitSoundOnEntity( victim, HEARTBEAT_SENSOR_HEARTBEAT_SOUND_3P )
                                         
						file.lastHeardHeartbeatTime = Time()
                                              
					}
				}

				UpdateDataForHeartseekerRadarWaveformRadial( player, victim, true, false )

				wait HEARTBEAT_SOUND_BAR_WAIT_TIME

				UpdateDataForHeartseekerRadarWaveformRadial( player, victim, true, false)
				beatSoundTime = HEARTBEAT_SOUND_BAR_WAIT_TIME
			}
			else if ( data.hasLOS )
			{
				UpdateDataForHeartseekerRadarWaveformRadial( player, victim, false, false )

				wait HEARTBEAT_SOUND_BAR_WAIT_TIME

				UpdateDataForHeartseekerRadarWaveformRadial( player, victim, false, false )
				beatSoundTime = HEARTBEAT_SOUND_BAR_WAIT_TIME
			}else if ( victim in file.waveformRadialValueTable ){
				delete file.waveformRadialValueTable[victim]
			}
		}

		wait scaledWait - beatSoundTime
	}
}

void function UpdateVictimUIPosition_Thread( entity player, entity victim, float watchRangeSqr )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "DestroyHeartbeatSensor" )
	player.EndSignal( "EndHeartbeatSensorVictimManager" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	victim.EndSignal( "OnDestroy" )
	victim.EndSignal( "OnDeath" )
	victim.EndSignal( "StopWatchingHeartbeatSensorVictim" )

	while ( true )
	{
		if ( file.heartbeatSensorRui != null )
		{
			PlayersInViewInfo data = file.victimPlayerViewportInfo[victim]
			bool inTacRange = IsVicitmInTacRange( data )

			if ( inTacRange || data.hasLOS )
			{
				UpdateDataForHeartseekerRadarWaveformRadial( player, victim, inTacRange, true )
			}
		}

		wait TICK_RATE
	}
}

bool function IsVicitmInTacRange( PlayersInViewInfo data )
{
	if ( data.distanceSqr <= file.heartbeatSensorRangeSqr )
		return true

	return false
}

float function GetFOVForPlayer( entity player )
{
	float viewportFOV = 60.0
	entity weapon     = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( IsValid( weapon ) )
	{
		if ( weapon.IsWeaponAdsButtonPressed() || weapon.IsWeaponInAds() )
		{
			viewportFOV = weapon.GetWeaponZoomFOV()
		}
	}

	                                                                                                                                                                                                                                    
	viewportFOV = min( 60.0, viewportFOV )

	return viewportFOV
}

void function UpdateDataForHeartseekerRadarWaveformRadial( entity player, entity victim, bool inTacRange, bool distPercentOverride=false )
{
	bool isLocked = false

	                                                 
	if ( inTacRange )
	{
		vector startPos 		  = player.GetAttachmentOrigin( player.LookupAttachment( "CHESTFOCUS" ) ) + ( player.GetViewVector() * SONIC_BLAST_IN_FRONT_START_DISTANCE )
		vector blastVector        = startPos + (player.GetViewVector() * file.sonicBlastRange )
		vector blastVecNormalized = Normalize( blastVector - player.GetWorldSpaceCenter() )
		isLocked = ShouldBlastHitVictim( startPos, blastVector, blastVecNormalized, victim, player.GetTeam() )
	}
	else
	{
		                                                                                                                                                            
		                                                                                                                                                 
		UISize screenSize = GetScreenSize()
		entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		float offset = GetHeartbeatSensorUIOffsetForWeapon( player, activeWeapon, screenSize )
		ScreenSpaceData data = GetScreenSpaceData( player, victim.GetWorldSpaceCenter() )

		                         
		float distOnScreen = sqrt( pow( data.deltaCenterX, 2 ) + pow( data.deltaCenterY, 2 ) )

		                                   
		int screenWidth          = screenSize.width
		                                                                                                                                                                                                                                             
		float scale = offset/1920.0 * 0.75
		float scaledOffsetVal = screenWidth * scale

		if ( distOnScreen <= scaledOffsetVal )
		{
			isLocked = true
		}
	}

	BarData data
	bool isInTable = victim in file.waveformRadialValueTable

	if ( isInTable )
	{
		data =  file.waveformRadialValueTable[victim]
	}

	if(!distPercentOverride || !isInTable)
	{
		data.lastGameTimeBeat = Time()
	}
	data.inTacRange = inTacRange
	data.isLocked = isLocked
	file.waveformRadialValueTable[victim] <- data

	return
}
#endif         

                                                                                                                       
            
                                                                                                                       
#if CLIENT
void function CL_HeartSeekerRUIThread( entity player, entity weapon )
{
	Assert( IsNewThread(), "Must be threaded off." )

	if ( !IsValid( player ) || !IsValid( weapon ) )
		return

	player.EndSignal( "OnDestroy" )
	player.EndSignal( "DestroyHeartbeatSensor" )
	player.EndSignal( "EndHeartbeatSensorUI" )
	weapon.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( player )
		{
			if(	file.heartbeatSensorRui != null )
			{
				RuiSetGameTime( file.heartbeatSensorRui, "endTime", Time() )
				file.heartbeatSensorRui = null
			}
		}
	)

	UISize screenSize = GetScreenSize()
	float offset = GetHeartbeatSensorUIOffsetForWeapon( player, weapon, screenSize )

	#if DEV
	if ( HEARTBEAT_SENSOR_DEBUG )
	{
		printt( "Weapon name: " + weapon.GetWeaponClassName() + "optic: " + weapon.w.activeOptic + " FOV - " + weapon.GetWeaponZoomFOV() + " Offset: " + offset )
	}
	#endif      

	float fireRate = weapon.GetWeaponSettingFloat( eWeaponVar.fire_rate )
	float weaponFireDelay = 1.0

	if ( fireRate > 0 )
	{
		weaponFireDelay = 1.0 / fireRate
	}

	                                                                                                             
	weaponFireDelay += 0.3

	                                                      
	RuiSetFloat( file.heartbeatSensorRui, "weaponFireDelay", weaponFireDelay )
	RuiSetFloat( file.heartbeatSensorRui, "offset", offset )
	RuiSetFloat( file.heartbeatSensorRui, "heartbeatSensorNaturalRange", file.heartbeatSensorRange )
	RuiSetFloat2( file.heartbeatSensorRui, "screenSize", <screenSize.width, screenSize.height, 0> )

	RuiTrackGameTime( file.heartbeatSensorRui, "lastFireTime", weapon, RUI_TRACK_WEAPON_LAST_PRIMARY_ATTACK_TIME )
	RuiTrackFloat( file.heartbeatSensorRui, "bleedoutEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
	RuiTrackFloat( file.heartbeatSensorRui, "reviveEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

	bool lastTargetsInRange = false

	while ( true )
	{
		bool isSilenced = ( StatusEffect_GetSeverity( player, eStatusEffect.silenced ) > 0 )
		RuiSetBool( file.heartbeatSensorRui, "isSilenced", isSilenced )

		bool targetsInRange = false
		int i = 0

		foreach ( entity victim, BarData data in file.waveformRadialValueTable )
		{
			if(file.heartbeatSensorRui != null)
			{
				RuiSetFloat3( file.heartbeatSensorRui, "target" + (i + 1), victim.GetWorldSpaceCenter() )
				RuiSetFloat( file.heartbeatSensorRui, "target" + (i + 1) + "GameTimeBeat",  data.lastGameTimeBeat )
				RuiSetBool( file.heartbeatSensorRui, "target" + (i + 1) + "Locked",  data.isLocked )
			}

			targetsInRange = targetsInRange || data.inTacRange

			i++
			if( i == MAX_HEARTBEAT_SENSOR_TARGETS)
				break
		}

		                                                       
		for(int j = i; j < MAX_HEARTBEAT_SENSOR_TARGETS; j++)
		{
			if(file.heartbeatSensorRui != null)
			{
				RuiSetFloat( file.heartbeatSensorRui, "target" + (j + 1) + "GameTimeBeat", -1 )
				RuiSetBool( file.heartbeatSensorRui, "target" + (j + 1) + "Locked", false )
			}
		}
		if(lastTargetsInRange != targetsInRange){
			lastTargetsInRange = targetsInRange
			Minimap_SetVisiblityConeColor((targetsInRange)?GetKeyColor( COLORID_HUD_SEER_IN_RANGE ): GetKeyColor( COLORID_HUD_SEER_DEFAULT ))
		}


		WaitFrame()
	}
}

float function GetHeartbeatSensorUIOffsetForWeapon( entity player, entity weapon, UISize screenSize )
{
	float offset = 84

	if ( !IsValid( weapon ) )
		return offset

	int slot = GetSlotForWeapon( player, weapon )

	if ( slot >= 0 )
		weapon.w.activeOptic = SURVIVAL_GetWeaponAttachmentForPoint( player, slot, "sight" )
	else
		weapon.w.activeOptic = ""

	#if DEV
		if ( HEARTBEAT_SENSOR_DEBUG )
		{
			printt(FUNC_NAME() + ": looking up offset value for optic: " + weapon.w.activeOptic )
		}
	#endif      

	int screenWidth          = screenSize.width
	int screenHeight         = screenSize.height

	float defaultAR = 16.0/9.0
	float currentAR = float(screenWidth)/float(screenHeight)

	                                                                                                                      
	float scaledAR = defaultAR/currentAR

	#if DEV
		if ( HEARTBEAT_SENSOR_DEBUG )
		{
			printt( FUNC_NAME() + " - ScaledAR: " + scaledAR )
		}
	#endif

	                                      
	switch ( weapon.w.activeOptic )
	{
		case "":	            
		switch( weapon.GetWeaponClassName() )
		{
			case "mp_weapon_volt_smg":
			case "mp_weapon_esaw":
				offset = 110
				break
			case "mp_weapon_g2":
			case "mp_weapon_defender":
			case "mp_weapon_sentinel":
			case "mp_weapon_bow":
				offset = 65
				break
			case "mp_weapon_hemlok":
				offset = 67
				break
			case "mp_weapon_energy_ar":
			case "mp_weapon_vinson":
				offset = 70
				break
			case "mp_weapon_mastiff":
			case "mp_weapon_lstar":
			case "mp_weapon_lmg":
			case "mp_weapon_shotgun":
			case "mp_weapon_3030":
				offset = 75
				break
			default:
				offset = 84
				break
		}
		break
		case "optic_cq_threat":
		case "optic_cq_hcog_classic":
		case "optic_cq_holosight":
		case "optic_cq_hcog_bruiser":
		case "optic_cq_holosight_variable":
		case "optic_ranged_hcog":
		case "optic_ranged_aog_variable":
		case "optic_sniper":
		case "optic_sniper_threat":
			offset = 84
			break
		case "optic_sniper_variable":
			offset = 110
			break
		default:
			Warning( "Heartbeat Sensor HUD rui: unhandled optic " + weapon.w.activeOptic + ". Falling back on default offset." )
			offset = 84
	}

	offset *= scaledAR

	switch ( weapon.GetWeaponClassName() )
	{
		case "mp_weapon_semipistol":
		case "mp_weapon_wingman":
		case "mp_weapon_shotgun_pistol":
			if ( weapon.w.activeOptic == "" )
			{
				offset *= 0.9
			}
			else
			{
				offset *= 0.75
			}
			break
		default:
			break
	}

	return offset
}
#endif         

float function GetHeartbeatSensorRange()
{
	return GetCurrentPlaylistVarFloat( "seer_passive_range", HEARTBEAT_SENSOR_NATURAL_RANGE )
}