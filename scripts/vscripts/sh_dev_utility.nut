globalize_all_functions

global struct TestVars
{
	vector v
	float  f
	int    i
	var    vr
	var    rui
	entity ent
}
TestVars s_testVars

TestVars function TV()
{
	return s_testVars
}

struct
{
	float dev_finisherFOV = 0.0
} file

#if SERVER || CLIENT || UI
void function ShDevUtility_Init()
{
	RegisterSignal( "DevSignal1" )
	RegisterSignal( "DevSignal2" )

	#if SERVER || CLIENT
		PrecacheModel( $"mdl/Humans/class/medium/pilot_medium_empty.rmdl" )                         
	#endif

	#if SERVER
		                                                                   
		                                                                                           
	#endif

	#if CLIENT
		RegisterSignal( "DEV_PreviewScreenRUI" )
		RegisterSignal( "DEV_PreviewWorldRUI" )
	#endif
}
#endif


#if SERVER || CLIENT
entity function GEBI( int entIndex )
{
	return GetEntByIndex( entIndex )
}
#endif


#if SERVER || CLIENT
entity function GP( int playerIndex = 0 )
{
	array<entity> players = GetPlayerArray()
	if ( playerIndex >= players.len() )
		return null

	return players[playerIndex]
}
#endif


#if SERVER || CLIENT
entity function GPAW( int playerIndex = 0 )
{
	entity player = GP( playerIndex )
	entity result = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	return result
}
#endif


#if SERVER || CLIENT
entity function GBOT( int botIndex = 0 )
{
	array<entity> bots
	array<entity> players = GetPlayerArray()
	foreach ( entity player in players )
	{
		if ( player.IsBot() )
			bots.append( player )
	}

	if ( botIndex >= bots.len() )
		return null

	return bots[botIndex]
}

entity function GBOT_LAST()
{
	array<entity> bots
	array<entity> players = GetPlayerArray()
	foreach ( entity player in players )
	{
		if ( player.IsBot() )
			bots.append( player )
	}

	if ( bots.len() == 0 )
		return null

	return bots[bots.len()-1]
}
#endif


#if SERVER || CLIENT
void function PrintEntArray( array<entity> arr )
{
	printf( "%s() - len:%d  %s", FUNC_NAME(), arr.len(), string( arr ) )
	foreach ( int index, entity ent in arr )
		printf( " [%d] - %s %s", index, string( ent ), string( ent.GetOrigin() ) )
}
#endif                    

void function PrintStringArray( array<string> arr )
{
	printf( "%s() - len:%d  %s", FUNC_NAME(), arr.len(), string( arr ) )
	foreach ( int index, string str in arr )
		printf( " [%d] - \"%s\"", index, str )
}


void function PrintIntArray( array<int> arr )
{
	printf( "%s() - len:%d  %s", FUNC_NAME(), arr.len(), string( arr ) )
	foreach ( int index, int intVal in arr )
		printf( " [%d] - %d", index, intVal )
}


                            
                                
#if SERVER || CLIENT
array<entity> function gp()
{
	return GetPlayerArray()
}
#endif


#if SERVER || CLIENT
entity function ge( int ornull index = null )
{
	if ( index != null )
		return GetEntByIndex( expect int( index ) )

	entity player = gp()[0]

	vector traceStart = player.EyePosition()
	vector traceDir   = player.GetViewVector()
	vector traceEnd   = traceStart + (traceDir * 50000)

	TraceResults results = TraceLine( traceStart, traceEnd, player )

	return results.hitEnt
}
#endif


#if SERVER || CLIENT
vector function EyeTraceVec( entity player = null )
{
	if ( player == null )
		player = gp()[0]

	vector traceStart = player.EyePosition()
	vector traceDir   = player.GetViewVector()
	vector traceEnd   = traceStart + (traceDir * 50000)

	TraceResults results = TraceLine( traceStart, traceEnd, player )

	return results.endPos
}
#endif


#if SERVER || CLIENT
void function PrintLoc()
{
	vector origin    = GetPlayerArray()[0].GetOrigin()
	                                                                    
	vector eyeAngles = GetPlayerArray()[0].EyeAngles()
	eyeAngles.x = 0
	printt( "xxx: " + origin + ", " + eyeAngles + "" )
}
#endif

                          
                          
                          
                          
                          
#if CLIENT
void function BatchClientsideExecutionTest( vector refPoint, vector ang, array<ItemFlavor> characterPool )
{
	int count = 0
	foreach ( ItemFlavor attackerCharacter in characterPool )
	{
		ItemFlavor attackerSkin = GetValidItemFlavorsForLoadoutSlot( EHI_null, Loadout_CharacterSkin( attackerCharacter ) ).getrandom()
		foreach ( ItemFlavor execution in GetValidItemFlavorsForLoadoutSlot( EHI_null, Loadout_CharacterExecution( attackerCharacter ) ) )
		{
			ItemFlavor victimCharacter = characterPool.getrandom()
			ItemFlavor victimSkin      = GetValidItemFlavorsForLoadoutSlot( EHI_null, Loadout_CharacterSkin( victimCharacter ) ).getrandom()
			                                 
			delaythread(1.1) ClientsideExecutionTest( refPoint + count * AnglesToForward( ang ) * 180, attackerCharacter, attackerSkin, victimCharacter, victimSkin, execution )
			count++
		}
	}
}

void function ClientsideExecutionTestInspiration( vector refPoint, entity attackerInspiration, entity victimInspiration, string whichCamera = "none", string weight = "none" )
{
	ItemFlavor attackerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( attackerInspiration ), Loadout_Character() )
	ItemFlavor attackerSkin      = LoadoutSlot_GetItemFlavor( ToEHI( attackerInspiration ), Loadout_CharacterSkin( attackerCharacter ) )
	ItemFlavor victimCharacter, victimSkin
	
	if ( victimInspiration == null )
	{
		if ( weight == "manual" )                                      
		{
			array<entity> players = GetPlayerArray()
			players.fastremovebyvalue( GetLocalClientPlayer() )
			if ( players.len() > 0 )
			{
				victimInspiration = players.getrandom()
				victimCharacter = LoadoutSlot_GetItemFlavor( ToEHI( victimInspiration ), Loadout_Character() )
				victimSkin = LoadoutSlot_GetItemFlavor( ToEHI( victimInspiration ), Loadout_CharacterSkin( victimCharacter ) )
			}
			else
			{
				Warning( "No other player / bot in game to clone!" )
				return
			}
		}
		else                             
		{
			array<ItemFlavor> characters = GetAllCharacters()
			array<ItemFlavor> sizedCharacters = []
			array<ItemFlavor> sizedSkins = []
			
			foreach ( character in characters )
			{
				asset setFile = CharacterClass_GetSetFile( character )
				string rigWeight = GetGlobalSettingsString( setFile, "bodyModelRigWeight" )
				
				if ( ( rigWeight == weight || weight == "random" ) )
				{
					ItemFlavor sizedSkin = GetValidItemFlavorsForLoadoutSlot( EHI_null, Loadout_CharacterSkin( character ) ).getrandom()
					asset bodyModel = CharacterSkin_GetBodyModel( sizedSkin )
					asset armsModel = CharacterSkin_GetArmsModel( sizedSkin )
				
					                                             
					if ( bodyModel != "" && armsModel != "" )
					{
						sizedCharacters.append( character )
						sizedSkins.append( sizedSkin )
					}
				}
			}
			
			if ( sizedCharacters.len() > 0 )
			{
				int randomIndex = RandomIntRange( 0, sizedCharacters.len() )
				victimCharacter = sizedCharacters[randomIndex]
				victimSkin = sizedSkins[randomIndex]
			}
			else
			{
				Warning( "Couldn't find any characters of this type!" )
				return
			}
		}
	}
	else
	{
		victimCharacter = LoadoutSlot_GetItemFlavor( ToEHI( victimInspiration ), Loadout_Character() )
		victimSkin = LoadoutSlot_GetItemFlavor( ToEHI( victimInspiration ), Loadout_CharacterSkin( victimCharacter ) )
	}
	
	ItemFlavor attackerExecution = LoadoutSlot_GetItemFlavor( ToEHI( attackerInspiration ), Loadout_CharacterExecution( attackerCharacter ) )
	ClientsideExecutionTest( refPoint, attackerCharacter, attackerSkin, victimCharacter, victimSkin, attackerExecution, whichCamera )
}

void function dev_finisherfov( float fov )
{
	if ( fov > 0.0 && fov < 180.0 )
		file.dev_finisherFOV = fov
	else
		Warning( "Dev_FinisherFOV - FOV must be in the range of 1 to 179" )
}

void function ClientsideExecutionTest(
vector refPoint,
ItemFlavor attackerCharacter, ItemFlavor attackerSkin,
ItemFlavor victimCharacter, ItemFlavor victimSkin,
ItemFlavor attackerExecution, string whichCamera = "none" )
{
	entity attacker = CreateClientSidePropDynamic( refPoint, <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
	entity victim   = CreateClientSidePropDynamic( refPoint, <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
	entity camera   = null

	CharacterSkin_Apply( attacker, attackerSkin )
	CharacterSkin_Apply( victim, victimSkin )

	float fov = 70.0
	
	if ( whichCamera == "attacker" || whichCamera == "victim" )
	{
		fov = file.dev_finisherFOV
		if ( fov == 0.0 )
		{
			fov = 70.0
			Warning( "Using default fov = 70 - Type into console: script_client dev_finisherfov( x ) ... x = AE_SV_FOV in the animation event in bakery" )
		}
	}
	
	switch( whichCamera )
	{
		case "attacker":
		{
			camera = CreateClientSidePointCamera( attacker.GetOrigin(), attacker.GetAngles(), fov )
			camera.SetParent( attacker, "VDU", false, 0.0 )
			break
		}

		case "victim":
		{
			camera = CreateClientSidePointCamera( victim.GetOrigin(), victim.GetAngles(), fov )
			camera.SetParent( victim, "VDU", false, 0.0 )
			break
		}

		case "orbit":
		{
			camera = CreateClientSidePointCamera( attacker.GetOrigin(), attacker.GetAngles(), fov )
			                                                 
			break
		}
	}

	OnThreadEnd( function() : ( attacker, victim, camera ) {
		if ( IsValid( camera ) )
		{
			GetLocalClientPlayer().ClearMenuCameraEntity()
			camera.Destroy()
		}

		if ( IsValid( attacker ) )
			attacker.Destroy()

		if ( IsValid( victim ) )
			victim.Destroy()
	} )

	asset attackerPlayerSettings = CharacterClass_GetSetFile( attackerCharacter )
	asset victimPlayerSettings   = CharacterClass_GetSetFile( victimCharacter )
	string victimRigWeight       = GetGlobalSettingsString( victimPlayerSettings, "bodyModelRigWeight" )

	string attackerAnimSeq = string(CharacterExecution_GetAttackerAnimSeq( attackerExecution ))
	string victimAnimSeq   = string(CharacterExecution_GetVictimAnimSeq( attackerExecution, victimCharacter, victimRigWeight ))

	float attackerAnimDuration = attacker.GetSequenceDuration( attackerAnimSeq )
	float victimAnimDuration   = victim.GetSequenceDuration( victimAnimSeq )

	victim.SetParent( attacker, "ref", false, 0.0 )

	if ( camera != null )
	{
		clGlobal.clientCamera = camera
		GetLocalClientPlayer().SetMenuCameraEntity( camera )
	}

	if ( whichCamera == "delay" )       
		wait 2.2

	attacker.Anim_PlayWithRefPoint( attackerAnimSeq, refPoint, <0, 0, 0>, 0.0 )
	victim.Anim_Play( victimAnimSeq )
	victim.Anim_EnableUseAnimatedRefAttachmentInsteadOfRootMotion()

	int attackerVDUAttachIndex = attacker.LookupAttachment( "VDU" )
	int victimVDUAttachIndex   = victim.LookupAttachment( "VDU" )

	float finishTime   = Time() + max( attackerAnimDuration, victimAnimDuration )
	entity player      = GetLocalClientPlayer()
	vector orbitAngles = <45, VectorToAngles( Normalize( refPoint - player.EyePosition() ) ).y, 0>
	float prevTime     = Time()
	while ( Time() < finishTime )
	{
		float deltaTime = Time() - prevTime
		if ( whichCamera == "debuglines" )
		{
			vector attackerVDUOrigin = attacker.GetAttachmentOrigin( attackerVDUAttachIndex )
			vector attackerVDUAngles = attacker.GetAttachmentAngles( attackerVDUAttachIndex )
			DebugDrawAxis( attackerVDUOrigin, attackerVDUAngles, 0.0, 20, <255, 100, 100> )

			vector victimVDUOrigin = victim.GetAttachmentOrigin( victimVDUAttachIndex )
			vector victimVDUAngles = victim.GetAttachmentAngles( victimVDUAttachIndex )
			DebugDrawAxis( victimVDUOrigin, victimVDUAngles, 0.0, 20, <100, 255, 200> )
		}
		else if ( whichCamera == "orbit" )
		{
			float inputForward = player.GetInputAxisForward()
			float inputRight   = player.GetInputAxisRight()
			float exp          = 2.0
			orbitAngles += 175.0 * deltaTime * <signum( inputForward ) * pow( fabs( inputForward ), exp ), signum( inputRight ) * pow( fabs( inputRight ), exp ), 0>
			camera.SetOrigin( attacker.GetOrigin() - 150 * AnglesToForward( orbitAngles ) )
			camera.SetAngles( orbitAngles )
		}
		prevTime = Time()
		WaitFrame()
	}
	wait 0.25
}
#endif


#if SERVER
                                  
 
	                                           
	                                                                                
	                         
	                                                  
	                    
	                         
 
#endif

                              
                              
                              
                              
                              
#if SERVER
        
	                                
                 

                                                                            
 
	                                           
	 
		             
			                              

		            
			                         

		            
			                     
			 
				                              
			 
			     
	 
	                             
 

                                                                                                                                            
 
	                                       
	 
		                     
		        
	 
	                         
	 
		                                                                               
		                                                                            
		                                            
		                                                                   
		                             
		                               
		                  
		 
			                           
		 
		    
		 
			                                    
		 
	 

	                              
		                                   
 

                                                          
 
	                               
	              
	                                 
 

                                                                                                                                                             
 
	                            
	 
		                         
	 
	                            
		                                   

	                                       
	                                          
	 
		                   
		 
			          
				                                            
				     

			           
				                                             
				 
					                                     
				 
				     

			               
				                                             
				 
					                         
					 
						                                     
					 
				 
				     

			              
				                                   
				                                             
				 
					                                               
					 
						                                 
					 
				 
				                                 
				 
					                                                                                      
				 
				     

			                  
				                                   
				                                             
				 
					                                                                     
					 
						                                 
					 
				 
				                                 
				 
					                                                                                      
				 
				     

			            
				                                             
				 
					                     
					 
						                                     
					 
				 
				     

			                
				                                             
				 
					                                           
					 
						                                     
					 
				 
				     

			              
				                                                                            
				 
					                                     
				 
				     

			               
				                                                                               
				 
					                                     
				 
				     

			        
				                                                                                                                                                                      
		 
	 
	                                             
	                                           
	                                                 
	 
		                                           
		 
			                                       
			                                           
			                                                                                          
		 
	 
	                                   
 
                                                                                                     
 
	                                          
	                                                
	                                                                   
	         
	                      
	                                                                                                            
		                                    
		             
		 
			                                                           
			                                                        
		 
		    
		 
			                                      
		 
		                                                                      
		                                       
		                                                                      
	   
 

                                                                                  
 
	                                                               
 

                                                                                        
 
	                                                                                                   
	 
		                                                                                                                        
		      
	 
	                                         
	                                             
	 
		                                                                                                            
	 
 

                                                                          
 
	                                                   
	                                         
	 
		                           

		                                          

		                                                                                                  
		                                                                                                             
		                                                                                    
	 
 
#endif


                               
                               
                               
                               
                               
#if CLIENT
var DEV_screenAlignmentTopo = null
var DEV_screenAlignmentRui = null
var function DEV_ToggleScreenAlignmentTool()
{
	if ( DEV_screenAlignmentRui != null )
	{
		RuiTopology_Destroy( DEV_screenAlignmentTopo )
		DEV_screenAlignmentTopo = null

		RuiDestroyIfAlive( DEV_screenAlignmentRui )
		DEV_screenAlignmentRui = null

		return
	}

	UISize screenSize = GetScreenSize()
	DEV_screenAlignmentTopo = RuiTopology_CreatePlane( <0, 0, 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height ), 0>, false )
	DEV_screenAlignmentRui = RuiCreate( $"ui/dev_screen_alignment.rpak", DEV_screenAlignmentTopo, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 9001 )
	RuiSetResolution( DEV_screenAlignmentRui, float( screenSize.width ), float( screenSize.height ) )
	return DEV_screenAlignmentRui
}
#endif





                           
                           
                           
                           
                           
         
                                                                                                     
                                          

#if CLIENT
void function DEV_HidePreviewRUIs()
{
	Signal( clGlobal.levelEnt, "DEV_PreviewScreenRUI" )
	Signal( clGlobal.levelEnt, "DEV_PreviewWorldRUI" )
}
#endif

#if CLIENT
void function DEV_PreviewScreenRUI( asset ruiAsset, array<int> bgCol )
{
	Signal( clGlobal.levelEnt, "DEV_PreviewScreenRUI" )
	EndSignal( clGlobal.levelEnt, "DEV_PreviewScreenRUI" )

	UISize screenSize = GetScreenSize()
	var topo          = RuiTopology_CreatePlane( <0, 0, 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height ), 0>, false )
	var rui           = RuiCreate( $"ui/preview_screen_rui.rpak", topo, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 9002 )
	RuiSetColorAlpha( rui, "bgCol", <bgCol[0] / 255.0, bgCol[1] / 255.0, bgCol[2] / 255.0>, bgCol[3] / 255.0 )
	var nestedRui
	try
	{
		nestedRui = RuiCreateNested( rui, "instance", ruiAsset )
	}
	catch ( e )
	{
		AnnouncementData announcement = Announcement_Create( "Invalid RUI asset: " + string(ruiAsset) )
		Announcement_SetSubText( announcement, "Please check the argument and try again." )
		Announcement_SetHideOnDeath( announcement, false )
		Announcement_SetDuration( announcement, 10.0 )
		Announcement_SetPurge( announcement, true )
		AnnouncementFromClass( GetLocalClientPlayer(), announcement )
	}
	try
	{
		  	                                                                                       
	}
	catch ( e2 )
	{
		  
	}
	                                                                                

	OnThreadEnd( function() : ( topo, rui, nestedRui ) {
		RuiDestroyNestedIfAlive( rui, "instance" )
		RuiDestroyIfAlive( rui )
		RuiTopology_Destroy( topo )
	} )

	WaitForever()
}
#endif

#if CLIENT
void function DEV_PreviewWorldRUI( asset ruiAsset, float width = 100, float height = 100 )
{
	Signal( clGlobal.levelEnt, "DEV_PreviewWorldRUI" )
	EndSignal( clGlobal.levelEnt, "DEV_PreviewWorldRUI" )

	entity player   = GetLocalViewPlayer()
	TraceResults tr = TraceLine( player.EyePosition(), player.EyePosition() + 10000.0 * player.GetViewVector(), player, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

	vector pos, right, down = <0, 0, -1>
	if ( tr.fraction > 0.99 )
	{
		pos = tr.endPos
		vector ang = VectorToAngles( FlattenNormalizeVec( player.EyePosition() - tr.endPos ) )
		right = -1 * AnglesToRight( ang )
	}
	else
	{
		pos = tr.endPos + 1.2 * tr.surfaceNormal
		float verticalDot = DotProduct( tr.surfaceNormal, <0, 0, 1> )
		if ( verticalDot < -0.97 || verticalDot > 0.97 )
		{
			right = Normalize( CrossProduct( tr.surfaceNormal, player.GetViewVector() ) )
			down = CrossProduct( tr.surfaceNormal, right )
		}
		else
		{
			right = Normalize( CrossProduct( tr.surfaceNormal, <0, 0, 1> ) )
			down = CrossProduct( tr.surfaceNormal, right )
		}
	}

	DebugDrawLine( pos, pos + 50.0 * right, <255, 120, 120>, true, 5 )
	DebugDrawLine( pos, pos + 50.0 * down, <120, 255, 120>, true, 5 )

	pos -= 0.5 * width * right
	pos -= 0.5 * height * down

	if ( IsValid( tr.hitEnt ) )
		pos = WorldPosToLocalPos( pos, tr.hitEnt )
	var topo = RuiTopology_CreatePlane( pos, width * right, height * down, false )
	if ( IsValid( tr.hitEnt ) )
		RuiTopology_SetParent( topo, tr.hitEnt )

	var rui
	try
	{
		rui = RuiCreate( ruiAsset, topo, RUI_DRAW_WORLD, 32767 )
	}
	catch ( e )
	{
		AnnouncementData announcement = Announcement_Create( "Invalid RUI asset: " + string(ruiAsset) )
		Announcement_SetSubText( announcement, "Please check the argument and try again." )
		Announcement_SetHideOnDeath( announcement, false )
		Announcement_SetDuration( announcement, 10.0 )
		Announcement_SetPurge( announcement, true )
		AnnouncementFromClass( GetLocalClientPlayer(), announcement )
	}
	OnThreadEnd( function() : ( topo, rui ) {
		RuiDestroyIfAlive( rui )
		RuiTopology_Destroy( topo )
	} )

	WaitForever()
}
#endif

#if CLIENT
void function DEV_PreviewCurvedRUI( asset ruiAsset )
{
	Signal( clGlobal.levelEnt, "DEV_PreviewScreenRUI" )
	EndSignal( clGlobal.levelEnt, "DEV_PreviewScreenRUI" )

	UISize screenSize = GetScreenSize()
	var topo          = RuiTopology_CreateSphere(
		<-120, 0, -TITAN_COCKPIT_TOPO_RADIUS * deg_sin( TITAN_COCKPIT_ROTATION_ANGLE )>,
		<0, -1, 0>,
		<deg_sin( TITAN_COCKPIT_ROTATION_ANGLE ),
		0,
		-deg_cos( TITAN_COCKPIT_ROTATION_ANGLE )>,
		TITAN_COCKPIT_TOPO_RADIUS,
		TITAN_COCKPIT_RUI_SCREEN_WIDTH,
		TITAN_COCKPIT_RUI_SCREEN_WIDTH / 1.7665,
		TITAN_COCKPIT_RUI_SUBDIV
	)
	var rui           = RuiCreate( $"ui/preview_screen_rui.rpak", topo, RUI_DRAW_COCKPIT, RUI_SORT_SCREENFADE + 9002 )
	RuiSetColorAlpha( rui, "bgCol", <0.0, 0.0, 0.0>, 0.0 )
	var nestedRui
	try
	{
		nestedRui = RuiCreateNested( rui, "instance", ruiAsset )
	}
	catch ( e )
	{
		AnnouncementData announcement = Announcement_Create( "Invalid RUI asset: " + string(ruiAsset) )
		Announcement_SetSubText( announcement, "Please check the argument and try again." )
		Announcement_SetHideOnDeath( announcement, false )
		Announcement_SetDuration( announcement, 10.0 )
		Announcement_SetPurge( announcement, true )
		AnnouncementFromClass( GetLocalClientPlayer(), announcement )
	}
	                                                                                

	OnThreadEnd( function() : ( topo, rui, nestedRui ) {
		RuiDestroyNestedIfAlive( rui, "instance" )
		RuiDestroyIfAlive( rui )
		RuiTopology_Destroy( topo )
	} )

	WaitForever()
}
#endif





                                 
                                 
                                 
                                 
                                 
#if CLIENT
bool isPlayerDebugLinesToolRunning = false
void function DEV_TogglePlayerDebugLinesTool()
{
	RegisterSignal( "DEV_PlayerDebugLinesTool_Thread" )

	if ( isPlayerDebugLinesToolRunning )
		Signal( clGlobal.signalDummy, "DEV_PlayerDebugLinesTool_Thread" )
	else
		thread DEV_PlayerDebugLinesTool_Thread( GetLocalClientPlayer() )
}
void function DEV_PlayerDebugLinesTool_Thread( entity localClientPlayer )
{
	EndSignal( clGlobal.signalDummy, "DEV_PlayerDebugLinesTool_Thread" )

	isPlayerDebugLinesToolRunning = true
	OnThreadEnd( void function() {
		isPlayerDebugLinesToolRunning = false
	} )

	while( true )
	{
		foreach ( entity player in GetPlayerArray() )
		{
			DebugDrawLine( player.GetOrigin(), player.EyePosition(), <10, 80, 65>, true, 0.0 )
			DebugDrawLine( player.EyePosition(), player.EyePosition() + 40.0 * AnglesToForward( player.EyeAngles() ), <30, 255, 220>, false, 0.0 )
			DebugDrawAxis( player.GetOrigin(), player.GetAngles(), 0.0, 10.0 )
		}

		WaitFrame()
	}
}
#endif


#if CLIENT
void function DEV_DumpItems()
{
	string fmtStr = "%s,%s,%s,%s,\"%s\",\"%s\"\n"

	SpamLog( format( fmtStr,
		"GUID",
		"Dev name",
		"Type",
		"Tier",
		"Long name",
		"Short name"
	) )
	foreach ( ItemFlavor flav in GetAllItemFlavors() )
	{
		SpamLog( format( fmtStr,
			ItemFlavor_GetGUIDString( flav ),
			ItemFlavor_GetHumanReadableRef( flav ),
			DEV_GetEnumStringSafe( "eItemType", ItemFlavor_GetType( flav ) ),
			ItemFlavor_HasQuality( flav ) ? Localize( ItemFlavor_GetQualityName( flav ) ) : "None",
			Localize( ItemFlavor_GetLongName( flav ) ),
			Localize( ItemFlavor_GetShortName( flav ) )
		) )
	}
}

void function DEV_DrawBoundingBox()
{
	entity player = GetLocalClientPlayer()
	RegisterSignal( "DEV_DrawBoundingBox" )
	Signal( player, "DEV_DrawBoundingBox" )
	EndSignal( player, "DEV_DrawBoundingBox" )

	bool wasAttackHeld = player.IsInputCommandHeld( IN_ATTACK )
	vector[4] fourCorners
	int cornerIdx      = 0
	while ( cornerIdx < 4 )
	{
		WaitFrame()

		if ( cornerIdx == 0 )
		{
			fourCorners[0] = EyeTraceVec( GP() )
			DebugDrawMark( fourCorners[0], 20, COLOR_WHITE, false, 0.0 )
			DebugDrawMark( fourCorners[0], 20, <120, 120, 120>, true, 0.0 )
		}
		else if ( cornerIdx >= 1 )
		{
			if ( cornerIdx == 1 )
			{
				fourCorners[1] = EyeTraceVec( GP() )
			}
			DebugDrawLine( fourCorners[0], fourCorners[1], COLOR_GREEN, false, 0.0 )
			DebugDrawLine( fourCorners[0], fourCorners[1], <0, 120, 0>, true, 0.0 )
			vector fwdDir    = Normalize( fourCorners[1] - fourCorners[0] )
			vector fwdDirAng = VectorToAngles( fwdDir )

			if ( cornerIdx >= 2 )
			{
				if ( cornerIdx == 2 )
				{
					vector ornull intersection = GetIntersectionOfLineAndPlane(
						player.EyePosition(), player.EyePosition() + 10000.0 * player.GetViewVector(),
						fourCorners[0], fwdDir )
					if ( intersection == null )
						continue
					fourCorners[2] = expect vector(intersection)
				}
				DebugDrawLine( fourCorners[0], fourCorners[2], COLOR_RED, false, 0.0 )
				DebugDrawLine( fourCorners[0], fourCorners[2], <120, 0, 0>, true, 0.0 )
				vector rightDir    = Normalize( fourCorners[2] - fourCorners[0] )
				vector rightDirAng = VectorToAngles( rightDir )

				if ( cornerIdx == 3 )
				{
					vector rightAngInFwdDirSpace = AnglesCompose( AnglesInverse( fwdDirAng ), rightDirAng )
					float roll                   = rightAngInFwdDirSpace.z
					vector boxAng                = RotateAnglesAboutAxis( fwdDirAng, fwdDir, roll )

					LineSegment bridgeSegment = GetShortestLineSegmentConnectingLineSegments(
						player.EyePosition(), player.EyePosition() + 10000.0 * player.GetViewVector(),
						fourCorners[0], fourCorners[0] + 10000.0 * AnglesToUp( boxAng )
					)
					fourCorners[3] = bridgeSegment.end
					DebugDrawLine( fourCorners[0], fourCorners[3], COLOR_BLUE, false, 0.0 )
					DebugDrawLine( fourCorners[0], fourCorners[3], <0, 0, 120>, true, 0.0 )
				}
			}
		}

		bool isAttackHeld = player.IsInputCommandHeld( IN_ATTACK )
		if ( isAttackHeld && !wasAttackHeld )
			cornerIdx++
		wasAttackHeld = isAttackHeld
	}

	vector fwdDir                = Normalize( fourCorners[1] - fourCorners[0] )
	vector fwdDirAng             = VectorToAngles( fwdDir )
	vector rightDir              = Normalize( fourCorners[2] - fourCorners[0] )
	vector rightDirAng           = VectorToAngles( rightDir )
	vector rightAngInFwdDirSpace = AnglesCompose( AnglesInverse( fwdDirAng ), rightDirAng )
	float roll                   = rightAngInFwdDirSpace.z
	vector boxAng                = RotateAnglesAboutAxis( fwdDirAng, fwdDir, roll )

	vector boxCenter = fourCorners[0]
	boxCenter += 0.5 * (fourCorners[1] - fourCorners[0])
	boxCenter += 0.5 * (fourCorners[2] - fourCorners[0])
	boxCenter += 0.5 * (fourCorners[3] - fourCorners[0])

	vector boxSize = <
	Length( fourCorners[1] - fourCorners[0] ),
	Length( fourCorners[2] - fourCorners[0] ),
	Length( fourCorners[3] - fourCorners[0] )
	>
	vector boxMaxs = 0.5 * boxSize
	vector boxMins = -boxMaxs

	DebugDrawRotatedBox( boxCenter, boxMins, boxMaxs, boxAng, COLOR_WHITE, true, 20.0 )

	printf( "BOX!\n\tcenter = <%f, %f, %f>\n\t angle = <%f, %f, %f>\n\t  mins = <%f, %f, %f>\n\t  maxs = <%f, %f, %f>",
		boxCenter.x, boxCenter.y, boxCenter.z,
		boxAng.x, boxAng.y, boxAng.z,
		boxMins.x, boxMins.y, boxMins.z,
		boxMaxs.x, boxMaxs.y, boxMaxs.z
	)
}
#endif              


#if SERVER
                                                                     
 
	                    
	                                         
	                     
	                             
	                    
	                                      
	                             
	           
	                        
	                                                            
	          
 
#endif


#if SERVER || CLIENT
array<entity> function DEV_PrintChildren( entity ent )
{
	array<entity> children = []
	foreach ( entity child in ent.GetChildren() )
	{
		printt( child )
		children.append( child )
	}
	return children
}

int function DEV_PrintChildrenRecursive( entity parentEnt, string prefix = "" )
{
	if ( !IsValid( parentEnt ) )
		return 0

	printt( prefix + parentEnt )

	int rv = 1
	array<entity> children = parentEnt.GetChildren()
	foreach ( child in children )
	{
		rv += DEV_PrintChildrenRecursive( child, prefix + "|" )
	}

	return rv
}

void function DEV_DumpPlayers( bool includeSpectators = true, float drawDuration = 60 )
{
	array<entity> players
	if ( includeSpectators )
		players = GetPlayerArrayIncludingSpectators()
	else
		players = GetPlayerArray()

	string plural = players.len() > 1 ? "players" : "player"

	printt( "---", FUNC_NAME(), players.len(), plural, "total ---" )
	if ( players.len() == 0 )
		return

	players.sort(
		int function( entity lhs, entity rhs )
		{
			int rv = 0

			int lhsTeam = lhs.GetTeam()
			int rhsTeam = rhs.GetTeam()
			if ( lhsTeam == rhsTeam )
			{
				int entIndexDelta = lhs.GetEntIndex() - rhs.GetEntIndex()
				rv = entIndexDelta
			}
			else
			{
				int teamDelta = lhsTeam - rhsTeam
				rv = teamDelta
			}

			return ClampInt( rv, -1, 1 )
		}
	)

	int lastTeam = TEAM_INVALID
	foreach( idx, player in players )
	{
		int playerTeam = player.GetTeam()
		if ( playerTeam == TEAM_INVALID )
		{
			Warning( "%s is on TEAM_INVALID", string( player ) )
			return
		}

		if ( playerTeam != lastTeam )
		{
			int teamCount = GetTeamPlayerCount( playerTeam )
			string teamName = string( playerTeam )
			if ( playerTeam == TEAM_SPECTATOR )
				teamName = format( "SPECTATOR (%s)", teamName )

			plural = teamCount > 1 ? "players" : "player"

			printt( "" )
			printt( "Team", teamName, "has", teamCount, plural )
			lastTeam = playerTeam
		}

		string playerPrefix = "    "
		if ( player.IsBot() )
			playerPrefix = " BOT"

		#if CLIENT
			if ( player == GetLocalViewPlayer() && player == GetLocalClientPlayer() )
				playerPrefix = "LCVP"
			else if ( player == GetLocalViewPlayer() )
				playerPrefix = " LVP"
			else if ( player == GetLocalClientPlayer() )
				playerPrefix = " LCP"

			vector randomOffset = 10 * GetRandomUnitVector()
			DebugDrawText( player.GetOrigin() + randomOffset, string( player.GetEntIndex() ), false, drawDuration )
		#endif

		printf( "  %s[%2d] %-20s", playerPrefix, player.GetEntIndex(), player.GetPlayerName() )
	}
}
#endif


#if CLIENT
void function DEV_FreeCamBasedOnSun( vector toSunDir, entity target, float horzDist, float elevation, float fov )
{
	entity ply = GetLocalClientPlayer()

	if ( Distance( ply.EyePosition(), GetFinalClientMainViewOrigin() ) < 20.0 )
		ply.ClientCommand( "freecam" )

	vector freecamPos = target.GetWorldSpaceCenter() + FlattenVec( toSunDir ) * horzDist + <0, 0, elevation>
	vector freecamAng = VectorToAngles( Normalize( target.GetWorldSpaceCenter() - freecamPos ) )
	ply.ClientCommand( format( "freecam_setpos %f %f %f", freecamPos.x, freecamPos.y, freecamPos.z ) )
	ply.ClientCommand( format( "freecam_setang %f %f %f", freecamAng.x, freecamAng.y, freecamAng.z ) )

	ply.ClientCommand( format( "set fov %f", fov ) )
}
#endif

#if SERVER
                                                                
 
	                                                                                  
	                                      
	               
	                              
	                                                  
 

                                                                                      
 
	                                                                         
	                            
	 
		      
	 

	                           

	                                              
	 
		                             
		            
			                     
			 
				                      
					              
			 
		 

		                                                                                     
		             
		                                                         
	   
 


                                                                               
 
	                               

	                        
	                                    
	                    
	                

	                                             

	                           
	 
		                                                                                   
		                                
		           
	 
 

#endif