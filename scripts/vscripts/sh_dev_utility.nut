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

#if CLIENT || UI 
void function ShDevUtility_Init()
{
	RegisterSignal( "DevSignal1" )
	RegisterSignal( "DevSignal2" )

	#if(CLIENT)
		PrecacheModel( $"mdl/Humans/class/medium/pilot_medium_empty.rmdl" ) //
	#endif

	#if(false)


#endif

	#if(CLIENT)
		RegisterSignal( "DEV_PreviewScreenRUI" )
		RegisterSignal( "DEV_PreviewWorldRUI" )
	#endif
}
#endif


#if(CLIENT)
entity function GEBI( int entIndex )
{
	return GetEntByIndex( entIndex )
}
#endif


#if(CLIENT)
entity function GP( int playerIndex = 0 )
{
	array<entity> players = GetPlayerArray()
	if ( playerIndex >= players.len() )
		return null

	return players[playerIndex]
}
#endif


#if(CLIENT)
entity function GPAW( int playerIndex = 0 )
{
	entity player = GP( playerIndex )
	entity result = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	return result
}
#endif


#if(CLIENT)
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
#endif


#if(CLIENT)
void function PrintEntArray( array<entity> arr )
{
	printf( "%s() - len:%d  %s", FUNC_NAME(), arr.len(), string( arr ) )
	foreach( int index, entity ent in arr )
		printf( " [%d] - %s %s", index, string( arr[index] ), string( arr[index].GetOrigin() ) )
}
#endif


//
//
#if(CLIENT)
array<entity> function gp()
{
	return GetPlayerArray()
}
#endif


#if(CLIENT)
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


#if(CLIENT)
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


#if(CLIENT)
void function PrintLoc()
{
	vector origin    = GetPlayerArray()[0].GetOrigin()
	//
	vector eyeAngles = GetPlayerArray()[0].EyeAngles()
	eyeAngles.x = 0
	printt( "xxx: " + origin + ", " + eyeAngles + "" )
}
#endif

//
//
//
//
//
#if(CLIENT)
void function BatchClientsideExecutionTest( vector refPoint, vector ang, array<ItemFlavor> characterPool )
{
	int count = 0
	foreach( ItemFlavor attackerCharacter in characterPool )
	{
		ItemFlavor attackerSkin = GetValidItemFlavorsForLoadoutSlot( EHI_null, Loadout_CharacterSkin( attackerCharacter ) ).getrandom()
		foreach( ItemFlavor execution in GetValidItemFlavorsForLoadoutSlot( EHI_null, Loadout_CharacterExecution( attackerCharacter ) ) )
		{
			ItemFlavor victimCharacter = characterPool.getrandom()
			ItemFlavor victimSkin      = GetValidItemFlavorsForLoadoutSlot( EHI_null, Loadout_CharacterSkin( victimCharacter ) ).getrandom()
			//
			delaythread(1.1) ClientsideExecutionTest( refPoint + count * AnglesToForward( ang ) * 180, attackerCharacter, attackerSkin, victimCharacter, victimSkin, execution )
			count++
		}
	}
}
void function ClientsideExecutionTestInspiration( vector refPoint, entity attackerInspiration, entity victimInspiration, string whichCamera = "none" )
{
	ItemFlavor attackerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( attackerInspiration ), Loadout_CharacterClass() )
	ItemFlavor attackerSkin      = LoadoutSlot_GetItemFlavor( ToEHI( attackerInspiration ), Loadout_CharacterSkin( attackerCharacter ) )
	ItemFlavor victimCharacter, victimSkin
	if ( victimInspiration == null )
	{
		array<entity> players = GetPlayerArray()
		players.fastremovebyvalue( GetLocalClientPlayer() )
		if ( players.len() > 0 )
		{
			victimInspiration = players.getrandom()
		}
	}
	if ( victimInspiration == null )
	{
		victimCharacter = GetLaunchCharacters().getrandom()
		victimSkin = GetValidItemFlavorsForLoadoutSlot( EHI_null, Loadout_CharacterSkin( victimCharacter ) ).getrandom()
	}
	else
	{
		victimCharacter = LoadoutSlot_GetItemFlavor( ToEHI( victimInspiration ), Loadout_CharacterClass() )
		victimSkin = LoadoutSlot_GetItemFlavor( ToEHI( victimInspiration ), Loadout_CharacterSkin( victimCharacter ) )
	}
	ItemFlavor attackerExecution = LoadoutSlot_GetItemFlavor( ToEHI( attackerInspiration ), Loadout_CharacterExecution( attackerCharacter ) )
	ClientsideExecutionTest( refPoint, attackerCharacter, attackerSkin, victimCharacter, victimSkin, attackerExecution, whichCamera )
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
			//
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
	string victimAnimSeq   = string(CharacterExecution_GetVictimAnimSeq( attackerExecution, victimRigWeight ))

	float attackerAnimDuration = attacker.GetSequenceDuration( attackerAnimSeq )
	float victimAnimDuration   = victim.GetSequenceDuration( victimAnimSeq )

	victim.SetParent( attacker, "ref", false, 0.0 )

	if ( camera != null )
	{
		clGlobal.clientCamera = camera
		GetLocalClientPlayer().SetMenuCameraEntity( camera )
	}

	if ( whichCamera == "delay" ) //
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


#if(false)



//
//














//

//
//
//
//






//
//
//
//
//
//












#endif

//
//
//
//
//
#if(false)









//


//




//



//











//
//

//










































































































































//



















//
//
//



















//



#endif


//
//
//
//
//
#if(CLIENT)
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





//
//
//
//
//
//
//
//

#if(CLIENT)
void function DEV_HidePreviewRUIs()
{
	Signal( clGlobal.levelEnt, "DEV_PreviewScreenRUI" )
	Signal( clGlobal.levelEnt, "DEV_PreviewWorldRUI" )
}
#endif

#if(CLIENT)
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
		//
	}
	catch ( e2 )
	{
		//
	}
	//

	OnThreadEnd( function() : ( topo, rui, nestedRui ) {
		RuiDestroyNestedIfAlive( rui, "instance" )
		RuiDestroyIfAlive( rui )
		RuiTopology_Destroy( topo )
	} )

	WaitForever()
}
#endif

#if(CLIENT)
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

	DebugDrawLine( pos, pos + 50.0 * right, 255, 120, 120, true, 5 )
	DebugDrawLine( pos, pos + 50.0 * down, 120, 255, 120, true, 5 )

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

#if(CLIENT)
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
	//

	OnThreadEnd( function() : ( topo, rui, nestedRui ) {
		RuiDestroyNestedIfAlive( rui, "instance" )
		RuiDestroyIfAlive( rui )
		RuiTopology_Destroy( topo )
	} )

	WaitForever()
}
#endif





//
//
//
//
//
#if(CLIENT)
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
		foreach( entity player in GetPlayerArray() )
		{
			DebugDrawLine( player.GetOrigin(), player.EyePosition(), 10, 80, 65, true, 0.0 )
			DebugDrawLine( player.EyePosition(), player.EyePosition() + 40.0 * AnglesToForward( player.EyeAngles() ), 30, 255, 220, false, 0.0 )
			DebugDrawAxis( player.GetOrigin(), player.GetAngles(), 0.0, 10.0 )
		}

		WaitFrame()
	}
}
#endif


#if(CLIENT)
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
#endif

