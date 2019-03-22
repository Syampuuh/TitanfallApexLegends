untyped

global function ClControlPanel_Init

global function ServerCallback_ControlPanelRefresh
global function CreateCallback_Panel
global function DestroyCallback_PanelTarget
global function RegisterWithPanel
global function VGUIUpdateGeneric
global function VGUISetupGeneric
global function Create_Display
global function AddPanelUpdateCallback


const HEAVY_TURRET_HEALTH_STR = "Health: %d%%"
const HEAVY_TURRET_REPAIR_STR = "Progress: %d%%"
const HEAVY_TURRET_REBOOT_STR = "Some indicator"

void function ClControlPanel_Init()
{
	PrecacheParticleSystem( $"panel_light_blue" )
	PrecacheParticleSystem( $"panel_light_red" )
	PrecacheParticleSystem( $"runway_light_orange" )

	AddCreateCallback( "prop_control_panel", CreateCallback_Panel )
	AddDestroyCallback( "prop_control_panel", DestroyCallback_Panel )
}

void function AddPanelUpdateCallback( panel, func )
{
	if ( !( "updateCallbacks" in panel.s ) )
		panel.s.updateCallbacks <- []
	panel.s.updateCallbacks.append( func )
}

void function ServerCallback_ControlPanelRefresh( int panelEHandle )
{
	entity panel = GetEntityFromEncodedEHandle( panelEHandle )
	if ( !IsValid( panel ) )
		return

	ControlPanelRefresh( panel )
}

void function CreateCallback_Panel( entity panel )
{
	if ( !ControlPanel_IsValidModel( panel ) )
		return

	ControlPanelInit( panel )
	Create_Display( panel )
	ControlPanelRefresh( panel )
}

void function DestroyCallback_Panel( entity panel )
{
	if ( !ControlPanel_IsValidModel( panel ) )
		return

	if ( "HudVGUI" in panel.s && panel.s.HudVGUI )
	{
		panel.s.HudVGUI.Destroy()
		panel.s.HudVGUI = null
	}

    if ( "particleEffect" in panel.s && panel.s.particleEffect != null && EffectDoesExist( panel.s.particleEffect ) )
    	EffectStop( panel.s.particleEffect, true, false )
}

void function ControlPanelInit( entity panel )
{
	panel.s.initiated <- true
	panel.s.HudVGUI <- null
	panel.s.VGUIFunc <- VGUIUpdateGeneric
	panel.s.VGUISetupFunc <- VGUISetupGeneric
	panel.s.targetArray <- []
	panel.s.resfile <- "control_panel_generic_screen"
	panel.s.particleEffect <- null
	panel.s.particleFlashingBlueToPlayer <- false

	if ( !( "updateCallbacks" in panel.s ) )
		panel.s.updateCallbacks <- []

	AddAnimEvent( panel, "create_dataknife", CreateFirstPersonDataKnife )
	AddAnimEvent( panel, "knife_popout", DataKnifePopsOpen )

	SetCallback_CanUseEntityCallback( panel, ControlPanel_CanUseFunction )

	if ( panel.GetNetworkedClassName() == "prop_script" )
	{
		int flags = panel.GetScriptPropFlags()
		if ( flags & SPF_CUSTOM_SCRIPT_1 )
		{
			panel.s.VGUIFunc = VGUIUpdateForRemoteTurret
			panel.s.VGUISetupFunc <- VGUISetupForRemoteTurret
		}
	}
}

void function RegisterWithPanel( entity ent )
{
	//
	ent.EndSignal( "OnDestroy" )
	entity panel = ent.GetControlPanel()

	Assert( IsValid( panel ) )
	Assert( "initiated" in panel.s )
	/*



*/

	if ( !panel.s.targetArray.contains( ent ) )
		panel.s.targetArray.append( ent )

	Create_Display( panel )

	ControlPanelRefresh( panel )
}

void function DestroyCallback_PanelTarget( entity ent )
{
	if ( ent.GetControlPanel() == null )
		return

	entity panel = ent.GetControlPanel()
	if ( !IsValid( panel ) )
		return

	foreach ( index, targetEnt in clone panel.s.targetArray )
	{
		if ( ent == targetEnt )
		{
			panel.s.targetArray.remove( index )
			break
		}
	}
}

void function ControlPanelRefresh( entity panel )
{
	if ( !IsValid( panel ) )
		return

	foreach ( func in panel.s.updateCallbacks )
	{
		func( panel )
	}

	if ( CanUpdateVGUI( panel ) )
	{
		panel.s.VGUIFunc( panel )	//
		UpdateParticleSystem( panel )
	}
}

bool function CanUpdateVGUI( entity panel )
{
	if ( panel.s.VGUIFunc == null )
		return false

	if ( panel.s.HudVGUI == null )
		return false

	//
	//

	return true
}

void function Create_Display( entity panel )
{
	if ( panel.s.HudVGUI )
	{
		panel.s.HudVGUI.Destroy()
		panel.s.HudVGUI = null
	}

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
}

void function VGUIUpdateSpectre( panel )
{
	local stateElement = panel.s.HudVGUI.s.state
	local controlledItem = panel.s.HudVGUI.s.controlledItem
	controlledItem.SetText( "Spectre Drop" )
	stateElement.SetText( "[READY]" )

	//
	int show = int( Time() * 4 ) % 2
	if ( show )
		stateElement.Show()
	else
		stateElement.Hide()
}

function VGUISetupGeneric( panel )
{
	expect entity( panel )
	panel.s.HudVGUI.s.state <- HudElement( "State", panel.s.HudVGUI.s.panel )
	panel.s.HudVGUI.s.controlledItem <- HudElement( "ControlledItem", panel.s.HudVGUI.s.panel )
}

function VGUIUpdateGeneric( panel )
{
	expect entity( panel )
	local state = panel.s.HudVGUI.s.state

	//
	int show = int( Time() ) % 2
	if ( show )
		state.Show()
	else
		state.Hide()

	local stateElement = panel.s.HudVGUI.s.state
	stateElement.SetText( "#CONTROL_PANEL_ENABLED" )
}

function VGUISetupForRemoteTurret( panel )
{
	expect entity( panel )

	VGUISetupGeneric( panel )
	VGUIUpdateForRemoteTurret( panel )
}

function VGUIUpdateForRemoteTurret( panel )
{
	expect entity( panel )

	var topLine = panel.s.HudVGUI.s.controlledItem
	var bottomLine = panel.s.HudVGUI.s.state

	int flags = panel.GetScriptPropFlags()
	if ( flags & SPF_CUSTOM_SCRIPT_2 )
	{
		topLine.SetText( "Rebooting..." )
		bottomLine.SetText( "[ TURRET DAMAGED ]" )
		bottomLine.SetColor( 255, 100, 100, 255 )
	}
	else
	{
		topLine.SetText( "Link ready..." )
		topLine.SetColor( 130, 130, 155, 255 )
		bottomLine.SetText( "[ REMOTE TURRET ]" )
		bottomLine.SetColor( 255, 255, 128, 255 )
	}
}

void function UpdateParticleSystem( entity panel )
{
	bool playerSameTeamAsPanel = ( GetLocalViewPlayer().GetTeam() == panel.GetTeam() )

	if ( panel.s.particleEffect != null )
	{
		//
		if ( playerSameTeamAsPanel && panel.s.particleFlashingBlueToPlayer )
			return

		if ( !playerSameTeamAsPanel && !panel.s.particleFlashingBlueToPlayer )
			return

		//
		if ( EffectDoesExist( panel.s.particleEffect ) )
			EffectStop( panel.s.particleEffect, true, false )
	}

	int tagID = panel.LookupAttachment( "glow1" )

	int fxID
	if ( playerSameTeamAsPanel )
		fxID = GetParticleSystemIndex( $"panel_light_blue" )
	else
		fxID = GetParticleSystemIndex( $"panel_light_red" )

	panel.s.particleEffect = PlayFXOnTag( panel, fxID, tagID )

	panel.s.particleFlashingBlueToPlayer = playerSameTeamAsPanel
}