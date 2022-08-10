global function MpWeaponEmoteProjector_Init

global function OnWeaponTossReleaseAnimEvent_WeaponEmoteProjector
global function OnWeaponAttemptOffhandSwitch_WeaponEmoteProjector
global function OnWeaponTossPrep_WeaponEmoteProjector

#if CLIENT
global function ActivateEmoteProjector
global function CreateClientSideEmoteIcon
global function CreateClientSideEmoteIconModel
global function EnableEmoteProjector
#endif

global function EmoteIcon_Waypoint_GetLinkedPlayers
global function Holospray_DisableForTime

#if SERVER
                                             
                                         
                                              

       
       
                                 
                                     
                                      
      
      

#endif

global const float EMOTE_ICON_ROTATE_SPEED = 15.0
global const int HOLO_PROJECTOR_INDEX = 6
global const string HOLO_PROJECTOR_WEAPON_NAME = "mp_ability_emote_projector"

const vector EMOTE_ICON_TEXT_OFFSET = <0,0,60>
const int EMOTE_GUID_INDEX = 0
const float HOLO_EMOTE_ANGLE_LIMIT = 0.55
const float HOLO_EMOTE_LIFETIME = 999.0

global const asset HOLO_EMOTE_EMITTER_FX = $"P_emote_base"
const string SOUND_HOLOGRAM_LOOP = "Survival_Emit_RespawnChamber"

#if CLIENT || SERVER
global const asset HOLO_SPRAY_BASE = $"mdl/props/holo_spray/holo_spray_base.rmdl"
#endif

struct
{
	#if SERVER
		                                                                    
	#endif
	#if CLIENT
		ItemFlavor ornull lastUsedHolo
		var holoSpayTitleRui
		bool enabledView = true
	#endif

} file

void function MpWeaponEmoteProjector_Init()
{
	PrecacheWeapon( HOLO_PROJECTOR_WEAPON_NAME )
	PrecacheParticleSystem( HOLO_EMOTE_EMITTER_FX )

	PrecacheModel( $"mdl/levels_terrain/mp_lobby/holospray_backdrop_godray_01.rmdl" )

	Remote_RegisterServerFunction( "ClientCallback_TryUseHoloSpray" )

	#if CLIENT || SERVER
		PrecacheModel( HOLO_SPRAY_BASE )
		AddCallback_OnQuickchatEvent( eCommsAction.REPLY_HOLOSPRAY_LIKE, OnHolosprayLike )
	#endif

	#if CLIENT
		RegisterSignal( "CreateClientSideEmoteIcon" )
		if ( !IsLobby() )
		{
			AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, OnWaypointCreated )
			AddFirstPersonSpectateStartedCallback( OnFirstPersonSpectateStarted )

			AddCallback_OnPlayerLifeStateChanged( OnPlayerLifeStateChanged )
		}
	#endif
}

bool function OnWeaponAttemptOffhandSwitch_WeaponEmoteProjector( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	array <entity> activeWeapons = player.GetAllActiveWeapons()
	if ( activeWeapons.len() > 1 )
	{
		entity offhandWeapon = activeWeapons[1]

		if ( IsValid( offhandWeapon ) )
		{
			return false
		}
	}

	if ( weapon.w.startChargeTime > Time() )
		return false

	return GetCurrentPlaylistVarBool( "holosprays_enabled", true )
}

var function OnWeaponTossReleaseAnimEvent_WeaponEmoteProjector( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()

	entity deployable = ThrowDeployable( weapon, attackParams, DEPLOYABLE_THROW_POWER, OnEmoteProjectorPlanted, null, null )
	entity player = weapon.GetWeaponOwner()

	if ( deployable )
	{
		ItemFlavor ornull item

		#if SERVER
			                                                       
		#elseif CLIENT
			item = file.lastUsedHolo
		#endif

		if ( item != null )
		{
			expect ItemFlavor( item )
			int tier = ItemFlavor_GetQuality( item )

			string soundAlias = "dataknife_hologram_appear"
			switch ( tier )
			{
				case eRarityTier.LEGENDARY:
					soundAlias = "Holospray_Legendary_Throw"
					break
				case eRarityTier.EPIC:
				case eRarityTier.RARE:
					soundAlias = "Holospray_Epic_Throw"
					break
			}

			weapon.EmitWeaponSound_1p3p( soundAlias, soundAlias )

			#if SERVER
				                                            
				 
					                              
					                                                                       
				 
			#endif
		}

		#if SERVER


			                                                            
			                            
				                                                

			                                      
			 
				                                                         
			 

			                               

			                                                                                              
			 
				                                                                           

				                    
				                                      
				                      
				 
					                                        
					 
						                 
						                                 
					 
				 

				                               
					                       
			 

			                                                                   

			                                                
			                                                
		#endif
	}

	#if CLIENT
		if ( InPrediction() )
			file.lastUsedHolo = null
	#endif

	return ammoReq
}

void function OnWeaponTossPrep_WeaponEmoteProjector( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnEmoteProjectorPlanted( entity projectile, DeployableCollisionParams collisionParams )
{
#if SERVER
	                                                           
	 
		                    
		      
	 

	                               
	                                            
	                                                                                                                 
	                        
	 
		      
	 
	                                       

	                                   

	                                         
	                        
	                                          

	                
	                                                                                                                                        
	 
		                                  
	 
	                                
	 
		                     
	 

	                                                               
	                                                                         

	                                                           
	                                             
	                                                                
		                                           

                       
                    
                               
   
                                                                                                                            
                                                                                        
   
      
   
                                                                                                                            
   
      
		                                                                                                                                
       


	                      
	 
		                                                                   
		                                                                                                                      
		                        
		 
			                                                             
			                         
		 
	 

	                    
#endif
}
#if SERVER

       
       
                                                       
 
                                                                   
                                                                                                                      
 

                                     
 

                                            
                                        
                         

                                                           

                  
                        
                        
                                                  
                                    
  
                                                                                                                      
                                 
   
                                                                 
            

                                                             

                                          
            

                                 
                            
   
  

                               
  
                                                                                                                    
          
                                          
  
 

                                                               
 
                                            
                                            
                                 

                                                                       
                                                                                                              
  
                                                                          
                                                          
   
                                                                                          
           
   

                                                               
                                                                
   
                                                                                                                 
           
   

                                                                                                                    
          
                                          
  
 
      
      

                                                                                                                           
 
	                        
		           

	                                                                

	                   
		           

	                         


	                                                                 
	                      
	                                                                 

	                                           

	                                                           
	            
	                                                  
	                                                    
	                       
	 
		                                                   
		                                 
		                       
	 
	                       
	                                     

	                                                   

	                    
	 
		                                                
		                                          

		                                                        
		                                                  

		                                                               
		 
			                                 
		 

		                                                                  
		 
			                        
			 
				                                                 
				 
					                        
				 
			 
		 
	 

	                           
	 
		                           
	 

	                                        

	                                               
	               
	 
		                           
			                                       
			     
		                      
		                      
			                                  
			     
	 
	                                      

	                                
	               
	 
		                           
			                                     
			     
		                      
		                      
			                                
			     
	 

	                                     
	                                                 

	            
 

                                                                      
 
	                                            

	                              

	                                        

	                           
	                             

	            
		                                
		 
			                    
			 
				            
			 
			                      
			 
				                                                                                                   
				                                  
					                                           

				                    
				               
				 
					                      
					                      
						                                    
						     
					                           
						                                         
						     
				 

				                     
					                                            
				                                              
				              
			 
		 
	 

	                                  
		      

	                        
 
#endif

#if CLIENT
void function OnWaypointCreated( entity wp )
{
	int wpType = wp.GetWaypointType()

	if ( wpType == eWaypoint.EMOTE_ICON )
	{
		int guid = wp.GetWaypointInt( EMOTE_GUID_INDEX )

		entity myParent = wp.GetParent()

		if ( !IsValid( myParent ) )
			return

		thread ClientSideEmoteIconThink( myParent, guid, wp.WaypointGetCreationTime() )

		wp.WaypointFocusTracking_Register()
		wp.WaypointFocusTracking_SetDisabled( false )
		wp.WaypointFocusTracking_TrackPos( wp, RUI_TRACK_ABSORIGIN_FOLLOW, 0 );
	}
}

void function MoverCleanup( entity wp, entity mover )
{
	wp.EndSignal( "OnDestroy" )
	mover.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( mover) {
			if ( IsValid( mover ) )
				mover.Destroy()
		}
	)

	while ( IsValid( wp ) )
		wait 0.1
}

void function ClientSideEmoteIconThink( entity wp, int guid, float creationTime )
{
	wp.SetDoDestroyCallback( true )
	wp.EndSignal( "OnDestroy" )

	entity localPlayer = GetLocalViewPlayer()

	localPlayer.EndSignal( "OnDestroy" )

	                                                                                                        
	if ( localPlayer != GetLocalClientPlayer() )
		wait 0.2

	bool active = false

	float distanceLimit = 3000.0
	float minDot = cos( DEG_TO_RAD * DEFAULT_FOV )

	while ( true )
	{
		float dot = DotProduct( AnglesToForward( localPlayer.CameraAngles() ), Normalize( wp.GetOrigin() - localPlayer.CameraPosition() ) )
		float scalar     = GetFovScalar( localPlayer )
		float distScalar = GraphCapped( scalar, 1.0, 2.0, 1.0, 3.0 )

		minDot = cos( DEG_TO_RAD * DEFAULT_FOV * 1.3 * scalar )
		bool isInView = dot > minDot

		                                                                   
		if ( !file.enabledView )
		{
			if ( active )
			{
				wp.Signal( "CreateClientSideEmoteIcon" )
				active = false
			}

			WaitFrame()
			continue
		}

		if ( !active )
		{
			if ( isInView )
			{
				float dist = Distance2D( wp.GetOrigin() , localPlayer.CameraPosition() )

				if ( dist < distanceLimit * distScalar )
				{
					thread CreateClientSideEmoteIcon( wp, guid, creationTime )
					active = true
				}
			}
		}
		else
		{
			float dist = Distance2D( wp.GetOrigin() , localPlayer.CameraPosition() )
			if ( !isInView || dist >= distanceLimit * distScalar )
			{
				wp.Signal( "CreateClientSideEmoteIcon" )
				active = false
			}
		}
		WaitFrame()
	}
}

void function CreateClientSideEmoteIcon( entity wp, int guid, float startTime, bool lastsForever = false )
{
	wp.Signal( "CreateClientSideEmoteIcon" )
	wp.EndSignal( "CreateClientSideEmoteIcon" )
	wp.EndSignal( "OnDestroy" )

	ItemFlavor item

	if ( IsValidItemFlavorGUID( guid ) )
	{
		item = GetItemFlavorByGUID( guid )
	}
	else
	{
		return
	}

	float width      = 100
	float height     = 100
	vector ang       = wp.GetAngles()
	vector forward       = AnglesToForward( ang )
	vector rgt       = AnglesToRight( ang )
	vector up        = AnglesToUp( ang )
	vector right     = <0, 1, 0> * height * 0.5
	vector fwd       = <1, 0, 0> * width * 0.5
	vector org 		 = <8 + height*0.5,0,0>

	float createTime = startTime
	float elapsedTime = Time() - createTime
	float rotateSpeed = EMOTE_ICON_ROTATE_SPEED

	if ( GetCurrentPlaylistVarBool( "holospray_billboard", true ) )
		rotateSpeed = 0

	vector angles = AnglesCompose( < -90, wp.GetAngles().y, 0>, <0,0,elapsedTime*rotateSpeed> )

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", wp.GetOrigin() + up*4, angles )

	if ( IsLobby() )
		mover.MakeSafeForUIScriptHack()

	bool useColor2 = CharacterQuip_GetUseEffectColor2( item )
	vector color1 = CharacterQuip_GetEffectColor1( item )
	vector color2 = useColor2 ? CharacterQuip_GetEffectColor2( item ) : color1

	array<int> fx
	int efx = StartParticleEffectOnEntity( mover, GetParticleSystemIndex( HOLO_EMOTE_EMITTER_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )

	EffectSetControlPointVector( efx, 3, color1 )
	EffectSetControlPointVector( efx, 4, color2 )
	fx.append( efx )

	mover.SetParent( wp )
	if ( !GetCurrentPlaylistVarBool( "holospray_billboard", true ) )
		mover.NonPhysicsRotate( <0,0,1>, rotateSpeed )

	asset ruiAsset = $"ui/emote_icon_basic.rpak"

	array<var> ruis
	array<var> topos

	entity model = CreateClientSideEmoteIconModel( item, wp.GetOrigin() + <0,0,32>, <0,wp.GetAngles().y,0> )

	model.SetParent( mover )

	float fadeTime = 0.4

	OnThreadEnd(
		function() : ( ruis, topos, mover, fx, model )
		{
			if ( IsValid( model ) )
				model.Destroy()

			foreach ( f in fx )
			{
				if ( EffectDoesExist( f ) )
					EffectStop( f, true, true )
			}

			foreach ( rui in ruis )
				RuiDestroy( rui )

			foreach ( topo in topos )
				RuiTopology_Destroy( topo )

			if ( IsValid( mover ) )
				mover.Destroy()
		}
	)

	float delay = ( HOLO_EMOTE_LIFETIME - (Time() - createTime) - fadeTime )


	if ( lastsForever )
	{
		waitthread OrientToLocalPlayer( wp, mover, 9999, model)
	}
	else
	{
		if ( delay > 0 )
			waitthread OrientToLocalPlayer( wp, mover, delay, model )

		foreach ( rui in ruis )
			RuiSetGameTime( rui, "fadeOutTime", Time() )

		foreach ( f in fx )
		{
			if ( EffectDoesExist( f ) )
				EffectStop( f, false, true )
		}
		fx.clear()

		if ( delay < 0 )
			fadeTime += delay

		if ( fadeTime > 0 )
			wait fadeTime
	}
}


void function OrientToLocalPlayer( entity wp, entity mover, float duration, entity model )
{
	wp.EndSignal( "OnDestroy" )
	mover.EndSignal( "OnDestroy" )

	if ( !GetCurrentPlaylistVarBool( "holospray_billboard", true ) )
	{
		WaitForever()
	}
	else
	{
		float endTime = Time() + duration
		mover.NonPhysicsStop()

		while ( Time() < endTime )
		{
			entity player = GetLocalViewPlayer()
			vector camPos = player.CameraPosition()
			vector camAng = player.CameraAngles()

			if ( IsLobby() && IsValid( Menu_GetCameraTarget() ) )
			{
				camPos = Menu_GetCameraTarget().GetOrigin()
				camAng = Menu_GetCameraTarget().GetAngles()
			}

			vector closestPoint    = GetClosestPointOnLine( camPos, camPos + (AnglesToRight( camAng ) * 100.0), mover.GetOrigin() )

			vector angles = VectorToAngles( mover.GetOrigin() - closestPoint )
			mover.SetAngles( < -90 * ( 1 - player.GetAdsFraction() ), angles.y, 0> )

			                                
			if (  player.GetAdsFraction() > 0.99 )
			{
				model.Hide()
			}
			else
			{
				model.Show()
			}

			WaitFrame()
		}
	}
}

entity function CreateClientSideEmoteIconModel( ItemFlavor item, vector origin, vector angles )
{
	asset modelName = CharacterQuip_GetModelAsset( item )

	entity model

	{
		model = CreateClientSidePropDynamic( origin, angles, modelName )
		if ( IsLobby() )
			model.MakeSafeForUIScriptHack()
		}

	return model
}

void function ActivateEmoteProjector( entity player, ItemFlavor quip )
{
	entity weapon = player.GetOffhandWeapon( HOLO_PROJECTOR_INDEX )

	if ( !IsValid( weapon ) )
		return

	if ( weapon.GetWeaponClassName() != HOLO_PROJECTOR_WEAPON_NAME )
		return

	file.lastUsedHolo = quip

	thread __ActivateEmoteProjector( player )
}

void function __ActivateEmoteProjector( entity player )
{
	player.EndSignal( "OnDestroy" )

	player.TrySelectOffhand( HOLO_PROJECTOR_INDEX )
	Remote_ServerCallFunction( "ClientCallback_TryUseHoloSpray" )
}

void function OnFirstPersonSpectateStarted( entity player, entity currentTarget )
{
	printt( "OnFirstPersonSpectateStarted" )
}
#endif

#if SERVER
                                                                  
 
	                                                               

	                         
		      

	                                                                
		      

	                          
 
#endif

#if CLIENT
void function EnableEmoteProjector( bool enable )
{
	if ( IsFiringRangeGameMode() )
		file.enabledView = enable
	else
		Warning( "Called EnableEmoteProjector() from a map other firing range. Currently not supported to turn off emotes outside."  )
}

void function OnPlayerLifeStateChanged( entity player, int oldState, int newState )
{
	if ( player == GetLocalViewPlayer() )
	{
		if ( newState != LIFE_ALIVE )
		{

		}
		else
		{
			thread TrackFocusedHolospray( player )
		}
	}
}

void function TrackFocusedHolospray( entity player )
{
	if ( file.holoSpayTitleRui == null )
	{
		var rui = CreateCockpitRui( $"ui/waypoint_ping_entpos.rpak", 200 )
		RuiSetString( rui, "promptText", "" )
		RuiSetImage( rui, "iconImage", $"" )
		RuiSetFloat3( rui, "iconColor", <1,1,1> )
		RuiSetFloat( rui, "iconSize", 0.0 )
		RuiSetFloat( rui, "iconSizePinned", 0.0 )
		RuiSetBool( rui, "doCenterOffset", true )
		RuiSetBool( rui, "hideIcon", true )
		RuiSetBool( rui, "completeADSFade", false )
		RuiSetBool( rui, "displayDistance", false )
		vector centerOffset = StringToVector( GetCurrentPlaylistVarString( "ping_center_offset", PING_CENTER_OFFSET ) )
		RuiSetFloat2( rui, "staticScreenPos", centerOffset )
		file.holoSpayTitleRui = rui
	}

	OnThreadEnd(
		function () : ()
		{
			RuiSetBool( file.holoSpayTitleRui, "isHidden", true )
		}
	)

	float minDot = deg_cos( 10.0 )
	float maxDist = GetCurrentPlaylistVarFloat( "holospray_ping_max_dist", 1500.0 )
	float minDist = GetCurrentPlaylistVarFloat( "holospray_ping_min_dist", 24.0 )

	while ( IsAlive( player ) )
	{
		RuiSetBool( file.holoSpayTitleRui, "hasFocus", false )
		RuiSetBool( file.holoSpayTitleRui, "isHidden", true )

		if ( GetFocusedWaypointEnt() != null && player.GetUsePromptEntity() == null )
		{
			entity wp = GetFocusedWaypointEnt()
			if ( wp.GetWaypointType() == eWaypoint.EMOTE_ICON )
			{
				float dist = Distance( player.CameraPosition(), wp.GetOrigin() )

				if ( dist < maxDist && dist > minDist )
				{
					float frac = TraceLineSimple( player.CameraPosition(), wp.GetOrigin(), player )

					if ( frac > 0.99 )
					{
						int guid = wp.GetWaypointInt( EMOTE_GUID_INDEX )
						if ( IsValidItemFlavorGUID( guid ) )
						{
							ItemFlavor flav = GetItemFlavorByGUID( guid )
							RuiTrackFloat3( file.holoSpayTitleRui, "targetPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
							RuiSetFloat3( file.holoSpayTitleRui, "iconColor", CharacterQuip_GetEffectColor1( flav ) )
							RuiSetString( file.holoSpayTitleRui, "shortPromptText", "\"" + Localize( ItemFlavor_GetLongName( flav ) ) + "\"" )

							array<entity> likes = EmoteIcon_Waypoint_GetLinkedPlayers( wp )
							RuiSetString( file.holoSpayTitleRui, "pingPrompt", "" )

							if ( wp.GetOwner() == GetLocalViewPlayer() )
							{
								if ( likes.len() > 0 )
								{
									if ( likes.len() == 1 )
										RuiSetString( file.holoSpayTitleRui, "pingPrompt", Localize( "#LIKE_COUNT_SINGLE", likes[0].GetPlayerName() ) )
									else
										RuiSetString( file.holoSpayTitleRui, "pingPrompt", Localize( "#LIKE_COUNT", likes.len() ) )
								}
							}
							else
							{
								if ( likes.contains( GetLocalViewPlayer() ) )
									RuiSetString( file.holoSpayTitleRui, "pingPrompt", Localize( "#PROMPT_PING_LIKE_DONE" ) )
								else
									RuiSetString( file.holoSpayTitleRui, "pingPrompt", Localize( "#PROMPT_PING_LIKE_HINT" ) )
							}

							RuiSetString( file.holoSpayTitleRui, "ownerPlayerName", wp.GetWaypointString( 0 ) )
							RuiSetBool( file.holoSpayTitleRui, "hasFocus", true )
							RuiSetBool( file.holoSpayTitleRui, "isHidden", false )
						}
					}
				}
			}
		}

		WaitFrame()
	}
}
#endif

void function OnHolosprayLike( entity player, int commsAction, entity subjectEnt )
{
	#if SERVER
		                             
			      

		                                                    
		 
			                     
			 
				                                                                                                                             
				                                                    
				                          
			 
		 
	#endif
}

array<entity> function EmoteIcon_Waypoint_GetLinkedPlayers( entity wp )
{
	if ( IsValid( wp.GetParent() ) )
		return wp.GetParent().GetLinkEntArray()

	return []
}

#if SERVER
                                                                       
 
	                                
	 
		                                  

		                                                
		                               
		 
			                                                                     
		 
	 
 

                                                              
 
	                                               
 
#endif

void function Holospray_DisableForTime( entity player, float duration )
{
	entity weapon = player.GetOffhandWeapon( HOLO_PROJECTOR_INDEX )

	if ( !IsValid( weapon ) )
		return

	float nextAllowTime = weapon.w.startChargeTime

	if ( nextAllowTime < Time() + duration )
		weapon.w.startChargeTime = Time() + duration
}

int function GetEmoteProjectorLimit()
{
	int playerCount = GetPlayerArray().len()

	if ( IsFiringRangeGameMode() )
		return 1

	if ( playerCount > 30 )
		return 1
	else if ( playerCount > 10 )
		return 2

	return 3
}