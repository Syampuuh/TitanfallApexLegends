global function Companion_Launch_Init
global function OnWeaponActivate_companion_launch
global function OnWeaponDeactivate_companion_launch
global function OnWeaponPrimaryAttack_companion_launch
global function OnWeaponPrimaryAttackAnimEvent_companion_launch
                                                               
global function OnWeaponAttemptOffhandSwitch_companion_launch

global function CanLaunchToCompanion


global function CodeCallback_OnJetDriveDoubleJump
global function CodeCallback_OnJetDriveWindowBegin
global function CodeCallback_OnJetDriveDuckCancel

                                                

        
const string JET_DRIVE_PRELAUNCH_BUILDUP_1P = "vantage_tac_buildup_1p"
const string JET_DRIVE_PRELAUNCH_BUILDUP_3P = "vantage_tac_buildup_3p"
const string JET_DRIVE_PRELAUNCH_BUILDUP_ABORT_1P = "Vantage_Tac_BuildupAbort_1p"
const string JET_DRIVE_PRELAUNCH_BUILTUP_WRIST_ABORT_1P = "Vantage_Tac_BuildupWristAbort_1p"
const string JET_DRIVE_PRELAUNCH_BUILDUP_ABORT_3P = "Vantage_Tac_BuildupAbort_3p"
const string JET_DRIVE_LAUNCH_1P = "vantage_tac_launch_1p"
const string JET_DRIVE_LAUNCH_3P = "vantage_tac_launch_3p"
const string JET_DRIVE_DOUBLE_JUMP_1P = "vantage_tac_launchdoublejump_1p"
const string JET_DRIVE_DOUBLE_JUMP_3P = "vantage_tac_launchdoublejump_3p"
const string JET_DRIVE_LAUNCH_ECHO_VOICE = "Vantage_Tac_Echo_Voice_JetPack"
const string JET_DRIVE_DEPLOY_ECHO_VOICE = "vantage_tac_draw"
const string JET_DRIVE_DEPLOY_ECHO_VOICE_3P = "vantage_tac_draw_3p"

const string JET_DRIVE_LAUNCH_CANCEL_1P = "vantage_tac_launchabort_1p"
const string JET_DRIVE_LAUNCH_CANCEL_3P = "vantage_tac_launchabort_3p"
const string ECHO_FIRST_DEPLOY_DIAG = "diag_mp_vantage_bc_tacticalfirst_1p"

const string JET_DRIVE_LAUNCH_END_1P = "vantage_tac_launchend_1p"
const string JET_DRIVE_LAUNCH_END_3P = "vantage_tac_launchend_3p"
const string JET_DRIVE_JUMP_WINDOW_SOUND_1P = "vantage_tac_doublejumpavailable_1p"

     
const JET_DRIVE_PRE_LAUNCH_FX = $"P_Vantage_thrusters_prelaunch"                      
const JET_DRIVE_LAUNCH_FX = $"P_Vantage_thrusters_launch"                      
const JET_DRIVE_DOUBLE_JUMP_FX = $"P_Vantage_thrusters_jump"                      
const JET_DRIVE_SCREEN_FX = $"P_van_tac_launch_screen"

const string TAKE_OFF_IMPACT_FX_TABLE = "pilot_bodyslam"

      
const string IS_LAUNCHING_MOD = "vantage_is_launching_mod"
const string FAILED_LOS_MOD = "vantage_failed_los_mod"
const string FROM_PERCHED_MOD = "vantage_from_perched_mod"

const string WHISTLE_FWD_MOD = "vantage_whistle_fwd"
const string WHISTLE_BACK_MOD = "vantage_whistle_back"
const string WHISTLE_LEFT_MOD = "vantage_whistle_left"
const string WHISTLE_RIGHT_MOD = "vantage_whistle_right"
const string CAN_INTERRUPT_MOD = "vantage_can_interrupt"

const string JET_DRIVE_DOUBLE_JUMP_HINT_STRING = "#JUMP_PAD_DOUBLE_JUMP_HINT"

        


const float LAUNCH_TARGET_UP_OFFSET = -1.75 * METERS_TO_INCHES
const float LAUNCH_TARGET_FWD_OFFSET = 0 * METERS_TO_INCHES

const float JET_DRIVE_DEPLOY_WEAPONS_TIME = 0.5

const bool JET_DRIVE_PATH_TRAVEL_VERSION = true
const float JET_DRIVE_PATH_ACCEL = 40 * METERS_TO_INCHES
const float JET_DRIVE_PATH_SPEED = 20 * METERS_TO_INCHES
const float JET_DRIVE_PATH_SPEED_MIN = 2 * METERS_TO_INCHES
const float JET_DRIVE_PATH_DECEL_FRAC = 0.2

const float JET_DRIVE_PATH_DECEL_DIST = 5 * METERS_TO_INCHES
const float JET_DRIVE_PATH_POINT_PROX = 3 * METERS_TO_INCHES

global const vector ECHO_INITIAL_DEPLOY_OFFSET = <30, -15, 80>

       
const bool JET_DRIVE_DEBUG_DRAW = false
const bool JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS = false
const bool JET_DRIVE_DEBUG_DRAW_TRAVEL_PATH = false

const int JET_DRIVE_DISABLE_WEAPON_TYPES = WPT_ALL_EXCEPT_VIEWHANDS & ~WPT_TACTICAL

struct
{
	table<entity, bool> isButtonHeld
	table<entity, string> cachedLastWeaponName
	table<entity, vector> cachedOrderPos
} file

global enum eCanLaunchResult
{
	SUCCESS,
	INVALID,
	PLAYER_STATE
	NO_OFF_SCREEN,
	NO_LOS_FAIL
}

global const string  VANTAGE_COMPANION_LAUNCH_WEAPON_NAME = "mp_ability_companion_launch"

void function Companion_Launch_Init()
{
	PrecacheWeapon( VANTAGE_COMPANION_LAUNCH_WEAPON_NAME )

	PrecacheParticleSystem( JET_DRIVE_PRE_LAUNCH_FX )
	PrecacheParticleSystem( JET_DRIVE_LAUNCH_FX )
	PrecacheParticleSystem( JET_DRIVE_DOUBLE_JUMP_FX )
	PrecacheParticleSystem( JET_DRIVE_SCREEN_FX )
	PrecacheImpactEffectTable( TAKE_OFF_IMPACT_FX_TABLE )

	RegisterSignal( "VantageLaunched_Signal" )
	RegisterSignal( "JetDrive_EndPrelaunch" )
	RegisterSignal( "Vantage_RemoveAllTacMods" )

	AddCallback_OnPassiveChanged( ePassives.PAS_VANTAGE, OnPassiveChangedVantageCompanionLaunch )
}

void function OnPassiveChangedVantageCompanionLaunch( entity player, int passive, bool didHave, bool nowHas )
{
	#if CLIENT
		if ( !IsValid( GetLocalClientPlayer() ) || player != GetLocalClientPlayer() )
			return
	#endif

	if ( didHave && !nowHas )
	{
		#if SERVER
			                                                        

			                                                                                               
			 
				                                         
			 
		#endif
	}
	else if ( nowHas && !didHave )
	{
		#if SERVER
			                                                                                   
		#endif
	}
}

bool function OnWeaponAttemptOffhandSwitch_companion_launch( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return false

	                                             
	  	            

	if ( VantageCompanion_GetPlayerLaunchState( player ) != ePlayerLaunchState.NONE )
		return false

	return true
}

void function OnWeaponActivate_companion_launch( entity weapon )
{
	#if CLIENT
		                                                                                                 
		  	      
	#endif

	if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
		printt( "VANTAGE TAC: Activate -----------------------------------" )

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return
	VantageCompanion_SetPlayerLaunchState( player, ePlayerLaunchState.NONE )
	RemoveAllTacMods( weapon )

	int companionState = player.GetPlayerNetInt( VANTAGE_COMPANION_STATE_NETINT )
#if CLIENT
	if ( InPrediction() && IsFirstTimePredicted() )
	{
#endif          
		if ( companionState == eCompanionState.PERCHED )
		{
			weapon.AddMod( FROM_PERCHED_MOD )
			#if CLIENT
			if ( player == GetLocalViewPlayer() )
			{
				entity companionEnt = VantageCompanion_GetEnt( player )

				if ( IsValid( companionEnt ) )
				{
					EmitSoundOnEntity( companionEnt, JET_DRIVE_DEPLOY_ECHO_VOICE )
				}
			}
			#endif
		}
#if CLIENT
	}
#endif          

	thread CheckForHoldInput_Thread( player, weapon )
}


var function OnWeaponPrimaryAttack_companion_launch( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	Assert( player.IsPlayer() )

	entity tacWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

	int ammoReq  = tacWeapon.GetAmmoPerShot()
	int currAmmo = tacWeapon.GetWeaponPrimaryClipCount()
	int ammoUsed = -1

	int companionState = player.GetPlayerNetInt( VANTAGE_COMPANION_STATE_NETINT )
	if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
		printt( "VANTAGE TAC: PRIMATK" )

	if ( file.isButtonHeld[player] == true )                                     
	{
		if ( currAmmo >= ammoReq )
		{
			RemoveAllTacMods( weapon )
			#if CLIENT
				if ( InPrediction() )
			#endif          
				weapon.AddMod( IS_LAUNCHING_MOD )

			if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
				printt( "--VANTAGE TAC: PRIMATK PRE LAUNCH" )

			entity companionEnt = VantageCompanion_GetEnt( player )
			if ( companionState == eCompanionState.PERCHED )
			{
				if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
					printt( "---VANTAGE TAC: PRIMATK PERCHED ORDER" )
				                                                                        
				VantageCompanion_OrderCompanion( player )
				#if SERVER
				                   
				#endif
			}

			entity mainHandWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			if ( IsValid( mainHandWeapon) )
			{
				if ( ( mainHandWeapon.GetWeaponTypeFlags() & WPT_ULTIMATE) == 0 )
					file.cachedLastWeaponName[player] <- mainHandWeapon.GetWeaponClassName()
				
				                                                                                                                                                       
				mainHandWeapon.FastHolster()
			}

			                     

			thread PreLaunch_Thread( player )
		}
		else
		{
			#if CLIENT
			AddPlayerHint( 2.0, 0.25, $"", "#TAC_NO_AMMO" )
			#endif
			weapon.DoDryfire()
			                                                            
			weapon.AddMod( FROM_PERCHED_MOD )
			ammoUsed = 0                              
		}
	}
	else                            
	{
		if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
			printt( "--VANTAGE TAC: PRIMATK REG CACHE ORDER" )


		#if CLIENT
		if ( InPrediction() && IsFirstTimePredicted() )
		{
		#endif          
			file.cachedOrderPos[player] <- VantageCompanion_FindAndDisplayOrderPos( player )
			if ( companionState != eCompanionState.PERCHED )
			{
				RemoveAllTacMods( weapon )

				entity companionEnt = VantageCompanion_GetEnt( player )
				vector toEcho = FlattenNormalizeVec(companionEnt.GetOrigin() - player.GetOrigin())
				vector toEchoLeft = CrossProduct(toEcho, UP_VECTOR )

				                                                                                                                
				                                                                                                                  
				vector echoToOrderPos = FlattenNormalizeVec(file.cachedOrderPos[player] - companionEnt.GetOrigin() )
				float dot = DotProduct( toEcho, echoToOrderPos )

				if ( dot >= DOT_45DEGREE )
				{
					                         
					weapon.AddMod( WHISTLE_FWD_MOD )
				}
				                                  
				   
				  	                        
				  	                                 
				   
				else
				{
					float leftDot = DotProduct( toEchoLeft, echoToOrderPos )
					if ( leftDot <= 0 )
					{
						                         
						weapon.AddMod( WHISTLE_RIGHT_MOD )
					}
					else
					{
						                        
						weapon.AddMod( WHISTLE_LEFT_MOD )
					}
				}
				   
			}
#if CLIENT
		}
#endif

	}

	return ammoUsed
}

vector function GetInitialDeployPos( entity player )
{
	vector initialDeploy = player.EyePosition() + (player.GetViewForward() * ECHO_INITIAL_DEPLOY_OFFSET.x)
												+ (player.GetViewRight() * ECHO_INITIAL_DEPLOY_OFFSET.y)
												+ (player.GetViewUp() * ECHO_INITIAL_DEPLOY_OFFSET.z)
	return initialDeploy
}

var function OnWeaponPrimaryAttackAnimEvent_companion_launch( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	Assert( player.IsPlayer() )

	if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
		printt( "VANTAGE TAC: ATK ANIM , Launch state: "+ VantageCompanion_GetPlayerLaunchState( player ) )

	int playerLaunchState = VantageCompanion_GetPlayerLaunchState( player )
	if ( playerLaunchState != ePlayerLaunchState.NONE )
	{
		entity companionEnt = VantageCompanion_GetEnt(player)

		if ( IsValid( companionEnt ) )
		{
			#if SERVER
				                                                                 
			#endif
			player.Signal( "JetDrive_EndPrelaunch" )

			entity tacWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
			int canLaunch = CanLaunchToCompanion ( player, companionEnt )
			int ammoReq  = tacWeapon.GetAmmoPerShot()
			int currAmmo = tacWeapon.GetWeaponPrimaryClipCount()
			bool hasAmmo  = currAmmo >= ammoReq
			if ( canLaunch == eCanLaunchResult.SUCCESS && hasAmmo )
			{
				                   
				#if CLIENT
					                                                                          
				#endif

				if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
					printt( "--VANTAGE TAC: ATK ANIM LAUNCH" )

				thread JetDrive_Thread( player, companionEnt )

				int newAmmo = currAmmo - ammoReq
				tacWeapon.SetWeaponPrimaryClipCount( newAmmo )

				player.Signal( "VantageLaunched_Signal" )
				PlayerUsedOffhand( player, tacWeapon )
			}
			else
			{
				#if CLIENT
				if ( InPrediction() )
			#endif          
				{
					RemoveAllTacMods( weapon )
					weapon.AddMod( FAILED_LOS_MOD )
				}
				#if CLIENT
					AddPlayerHint( 2.0, 0.25, $"", "#TAC_LOST_LOS" )
					if ( InPrediction() && IsFirstTimePredicted() )
					{
						EmitSoundOnEntity( player, JET_DRIVE_PRELAUNCH_BUILDUP_ABORT_1P   )
						EmitSoundOnEntity( player, JET_DRIVE_PRELAUNCH_BUILTUP_WRIST_ABORT_1P )
					}
				#endif
				weapon.Holster()
				#if SERVER
				                                                                                       

				                                          
				 
					                                                                                                
				 
				#endif

				if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
					printt( "--VANTAGE TAC: ATK ANIM NO LOS" )
			}
		}
	}
	else
	{

		if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
			printt( "--VANTAGE TAC: ATK ANIM REG SEND ORDER" )

		if ( player in file.cachedOrderPos )
		{
		#if CLIENT
			if ( InPrediction() && IsFirstTimePredicted() )
		#endif          
			{
				weapon.AddMod( CAN_INTERRUPT_MOD )
			}


			VantageCompanion_OrderCompanion( player, false, file.cachedOrderPos[player] )

			int companionState = player.GetPlayerNetInt( VANTAGE_COMPANION_STATE_NETINT )
			if ( companionState == eCompanionState.PERCHED )
			{
				#if SERVER
					                                                       
					                                                                       
					                                                                                       

					                                                
					                                      
					                                                        

					                                                      
					                                                             
					                                                                   
					                          
					   
					  	                                                                          
					  	                                                      
					  	                                     
					   

					                   
				#endif
			}
		}
		else
		{
			printt( "Vantage companion launch, player: " + player + " not in file.cachedOrderPos. " )
			#if SERVER
				                            
			#endif

			#if CLIENT
				printt( "--Vantage Client " + (InPrediction() ? "Predicted" : "NOT Predicted") + " " + (IsFirstTimePredicted() ? "FirstTime" : "NOT FirstTime" )  )
			#endif
		}

	}

	return -1
}


void function OnWeaponDeactivate_companion_launch( entity weapon )
{
	if ( JET_DRIVE_DEBUG_DRAW_FLOW_PRINTS )
		printt( "VANTAGE TAC: Deactivate -----------------------------------" )

	entity weaponOwner = weapon.GetWeaponOwner()

	if ( IsValid(weaponOwner ) )
		weaponOwner.Signal( "JetDrive_EndPrelaunch" )

	if ( weaponOwner in file.cachedOrderPos )
		delete file.cachedOrderPos[weaponOwner]

	bool dryFire = false

	#if CLIENT
	if ( weaponOwner == GetLocalViewPlayer() )
	{
	#endif
		int ammoReq  = weapon.GetAmmoPerShot()
		int currAmmo = weapon.GetWeaponPrimaryClipCount()
		dryFire = currAmmo < ammoReq
	#if CLIENT
	}
	#endif

	RemoveAllTacMods( weapon, dryFire )
}

void function RemoveAllTacMods( entity weapon, bool instant = true )
{
	#if CLIENT
	if ( InPrediction() )
	#endif          
	{
		weapon.Signal( "Vantage_RemoveAllTacMods" )

		weapon.RemoveMod( IS_LAUNCHING_MOD )
		weapon.RemoveMod( FAILED_LOS_MOD )
		if ( instant )
			weapon.RemoveMod( FROM_PERCHED_MOD )
		else
		{
			if ( weapon.HasMod( FROM_PERCHED_MOD ) )
				thread RemoveModAfterDelay( weapon, FROM_PERCHED_MOD, 0.4 )
		}
		weapon.RemoveMod( WHISTLE_FWD_MOD )
		weapon.RemoveMod( WHISTLE_BACK_MOD )
		weapon.RemoveMod( WHISTLE_LEFT_MOD )
		weapon.RemoveMod( WHISTLE_RIGHT_MOD )
		weapon.RemoveMod( CAN_INTERRUPT_MOD )
	}
}

void function RemoveModAfterDelay( entity weapon, string mod, float delay )
{
	Assert ( IsNewThread(), "Must be threaded off" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "Vantage_RemoveAllTacMods" )

	OnThreadEnd(
		function() : ( weapon, mod )
		{
			#if CLIENT
			if ( InPrediction() )
			{
			#endif
				if ( IsValid( weapon ) )
					weapon.RemoveMod( mod )
			#if CLIENT
			}
			#endif
		}
	)

	wait delay
}


void function CheckForHoldInput_Thread( entity player, entity weapon )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "VantageLaunched_Signal" )

	            
	  	                     
	                  
	  	                                 


	file.isButtonHeld[player] <- true

	OnThreadEnd(
		function() : ( player, weapon  )
		{
			                                                                         
			                                                     
			   
			  	          
			  	                     
			  	                
			  		                                    
			   

			file.isButtonHeld[player] = false
		}
	)

	while ( player.IsInputCommandHeld( IN_OFFHAND1 ) )
	{
		WaitFrame()
	}
}



int function CanLaunchToCompanion( entity player, entity companion )
{
	if ( !IsValid( companion) )
		return eCanLaunchResult.INVALID

	if ( player.ContextAction_IsBusy() )
		return eCanLaunchResult.PLAYER_STATE
	if ( player.ContextAction_IsActive() )
		return eCanLaunchResult.PLAYER_STATE
	if ( player.IsPhaseShifted() )
		return eCanLaunchResult.PLAYER_STATE
	if ( player.Player_IsSkywardFollowing() )
		return eCanLaunchResult.PLAYER_STATE
	if ( HoverVehicle_PlayerIsDriving( player ) )
		return eCanLaunchResult.PLAYER_STATE

	vector companionPos = companion.GetOrigin()

	            
	vector playerToCompanionPos = companionPos - player.EyePosition()
	float dotToCompanionPos     = DotProduct( player.GetViewVector(), Normalize( playerToCompanionPos ) )
	if ( dotToCompanionPos < DOT_60DEGREE )
		return eCanLaunchResult.NO_OFF_SCREEN


	          
	vector startTrace = player.EyePosition()
	vector endTrace = companion.GetOrigin()
	TraceResults tr = TraceLine( startTrace, endTrace , [],TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER )
	if ( tr.fraction < 0.9 )
		return eCanLaunchResult.NO_LOS_FAIL

	return eCanLaunchResult.SUCCESS
}

#if SERVER


                                                                                     
 
	                               
	                             

	                                      
		                        
			                                  
			                                                           
			                                          
			 
				                                                     
				                                                                                                                    
				                                                                                                                                                                         
				                                                                                                                                                                               
				                                           
					                                 
				    
					                                                                                                
			 
	   

	          
 
#endif




void function PreLaunch_Thread( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "JetDrive_EndPrelaunch" )

	VantageCompanion_SetPlayerLaunchState( player, ePlayerLaunchState.PRELAUNCHING )

	#if CLIENT
		if ( InPrediction() && IsFirstTimePredicted() )
		{
			if ( player == GetLocalViewPlayer() )
				EmitSoundOnEntity( player, JET_DRIVE_PRELAUNCH_BUILDUP_1P )
		}
	#endif
	array<entity> jumpJetFXs
	int disableWallClimbHandle
	#if SERVER
		                                                                                 

		                                                           
		                         
		                       
		                      

		                                                                                                                 

		                                                                       
	#endif

	OnThreadEnd(
		function() : ( player, jumpJetFXs , disableWallClimbHandle)
		{
			if ( IsValid( player ) )
				VantageCompanion_SetPlayerLaunchState( player, ePlayerLaunchState.NONE )

			#if SERVER
				                                       

				                        
				 
					                                                   
					                      
					                      
					                                                          
					                                                           
				 
			#endif

			#if CLIENT
			if ( IsValid( player ) )
				StopSoundOnEntity( player,JET_DRIVE_PRELAUNCH_BUILDUP_1P )
			#endif

		}
	)
	while ( true )
	{
		WaitFrame()
	}
}

void function JetDrive_Thread( entity player, entity companion )
{
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	player.Signal( "JumpPad_GiveDoubleJump" )                                                                                   

	VantageCompanion_SetPlayerLaunchState( player, ePlayerLaunchState.LAUNCHING )

	vector startingPosition = player.GetOrigin()
	vector playerToCompanionPos = companion.GetOrigin() - player.GetOrigin()

	vector offset = (FlattenNormalizeVec( playerToCompanionPos ) * LAUNCH_TARGET_FWD_OFFSET) +  <0.0, 0.0, LAUNCH_TARGET_UP_OFFSET>

	float approxTravelDistance      = Length( playerToCompanionPos )

	float travelSpeed = GetCurrentPlaylistVarFloat( "vantage_tactical_speed", JET_DRIVE_PATH_SPEED )
	float timeOut = 2* approxTravelDistance / travelSpeed
	timeOut = Round( timeOut, 1)

	player.BeginJetDrive( travelSpeed, JET_DRIVE_PATH_ACCEL, companion.GetOrigin(), companion, offset, timeOut )

	vector launchVel = < 13 * METERS_TO_INCHES, 0, 10 * METERS_TO_INCHES >
	player.EnableJetDriveDoubleJump( launchVel, JET_DRIVE_DOUBLE_JUMP_1P, JET_DRIVE_DOUBLE_JUMP_3P )

	array<entity> jumpJetFXs
	int screenFXHandle
#if CLIENT
	int screenFXID = GetParticleSystemIndex( JET_DRIVE_SCREEN_FX )
	screenFXHandle = StartParticleEffectOnEntityWithPos( player, screenFXID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID, player.EyePosition(), <0, 0, 0> )
	EffectSetIsWithCockpit( screenFXHandle, true )
	if ( InPrediction() && IsFirstTimePredicted() )
	{
		EmitSoundOnEntity( player, JET_DRIVE_LAUNCH_1P )
	}
#endif

	#if SERVER
	                                                              
	                                                                   
	                                                                         
	                                    
	                                                           
	                     
	                      

	                                                           
	                                                                      
	                                           
	                                                                  
	                       

	                                                                                                                                                        

	                                                                           


	                                                                                                           

#endif

	OnThreadEnd(
		function() : ( player , jumpJetFXs, screenFXHandle, startingPosition )
		{
			if ( IsValid ( player ) )
			{
				VantageCompanion_SetPlayerLaunchState( player, ePlayerLaunchState.NONE )

				#if SERVER
				                                                                                                                                                      

				                                                                   
				                                                  

				                                       
				                                                                  
				                    

				                                       
				                                                                                         
				                                                           
				                                                              


				                        
				 
					                                                        
				 

				                                                                                                                         
				                                                                        
				                                                
				#endif


				#if CLIENT
					if ( !EffectDoesExist( screenFXHandle ) )
						return

					EffectStop( screenFXHandle, false, true )

					HidePlayerHint( JET_DRIVE_DOUBLE_JUMP_HINT_STRING )
					StopSoundOnEntity( player, JET_DRIVE_JUMP_WINDOW_SOUND_1P )
					StopSoundOnEntity( player, JET_DRIVE_LAUNCH_1P )
				#endif
				#if SERVER
				                                     
				#elseif CLIENT
				if ( player == GetLocalViewPlayer() )
					thread WaitForGround_Thread( player )
				#endif

			}
		}
	)


		vector previousPos = player.GetOrigin()

		while ( player.IsJetDriveActive() )
		{
			if ( JET_DRIVE_DEBUG_DRAW_TRAVEL_PATH )
			{
				DebugDrawSphere( player.GetOrigin(), 20, <0, 200, 255>, false, 30 )
				DebugDrawLine( previousPos, player.GetOrigin(), <0, 100, 255>, false, 30 )
			}
			previousPos = player.GetOrigin()

			WaitFrame()
		}


}




void function WaitForGround_Thread( entity player )
{
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid(player) && player.IsOnGround() )
			{
				#if SERVER
					                                                    
				#elseif CLIENT
					StopSoundOnEntity( player, JET_DRIVE_LAUNCH_END_1P )
				#endif
			}
		}
	)

	while ( !player.IsOnGround() )
	{
		WaitFrame()
	}
}

#if SERVER
                                                               
 
	                             
	                               


	                        
	                                                                        

	            
		                                  
		 
			                                       
		 
	 

	            
 


                                                                                                  
 
	                                                         
	                                     
	 
		                                                     
		                                                                                                                                               
		                        
		                                  
		                                                            
		                          
	 
 

                                                                   
 
	                            
	 
		                    
			            
	 
	                  
 

#endif

void function DEV_DebugDrawPathPoints( array<vector> pathPoints, float time = 5 )
{
	vector prevPathPoint = ZERO_VECTOR
	foreach( point in pathPoints )
	{
		DebugDrawSphere( point, 10, COLOR_YELLOW, false, time )
		if ( prevPathPoint != ZERO_VECTOR )
		{
			DebugDrawLine( point, prevPathPoint, <100,255,0>,false, time )
		}
		prevPathPoint = point
	}
}

void function CodeCallback_OnJetDriveDuckCancel( entity player )
{
	if ( !IsValid( player ) )
		return

	#if CLIENT
	if ( InPrediction() && IsFirstTimePredicted() )
	{
		if ( player == GetLocalViewPlayer() )
		{
			EmitSoundOnEntity( player, JET_DRIVE_LAUNCH_CANCEL_1P )
			StopSoundOnEntity( player, JET_DRIVE_LAUNCH_1P )
		}
	}
	#elseif SERVER
		                                                                             
		                                                
	#endif
}

void function CodeCallback_OnJetDriveDoubleJump( entity player )
{
	#if CLIENT
		HidePlayerHint( JET_DRIVE_DOUBLE_JUMP_HINT_STRING )
		StopSoundOnEntity( player, JET_DRIVE_JUMP_WINDOW_SOUND_1P )
	#endif
	StopSoundOnEntity( player, JET_DRIVE_LAUNCH_END_1P )

	#if SERVER
	                                       
	#endif
}

void function CodeCallback_OnJetDriveWindowBegin( entity player, float windowTimeOut )
{
	#if SERVER

	                                                                          
	#endif

	#if CLIENT
		if ( InPrediction() && IsFirstTimePredicted() )
		{
			if ( player == GetLocalViewPlayer() )
				EmitSoundOnEntity( player, JET_DRIVE_LAUNCH_END_1P )

			float time = windowTimeOut - Time()
			thread PlayJetDriveDoubleJumpWindowSound( player, windowTimeOut )
			AddPlayerHint( time, 0, $"", JET_DRIVE_DOUBLE_JUMP_HINT_STRING )
		}
	#endif
}

#if CLIENT
void function PlayJetDriveDoubleJumpWindowSound(  entity player, float timeout )
{
	if ( InPrediction() && IsFirstTimePredicted() )
	{
		EmitSoundOnEntity(player, JET_DRIVE_JUMP_WINDOW_SOUND_1P )

		OnThreadEnd(
			function() : ( player)
			{
				StopSoundOnEntity( player, JET_DRIVE_JUMP_WINDOW_SOUND_1P )
			}
		)
		while ( Time() < timeout )
			WaitFrame()
	}
}
#endif