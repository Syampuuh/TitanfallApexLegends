untyped

global function CodeCallback_RegisterClass_C_BaseEntity


//
//
//
//

var function CodeCallback_RegisterClass_C_BaseEntity()
{
	//

	C_BaseEntity.ClassName <- "C_BaseEntity"

	//
	//
	C_BaseEntity.s <- null
	//
	//
	C_BaseEntity.hudElems <- null
	C_BaseEntity.hudVisible <- null

	C_BaseEntity._entityVars <- null
	C_BaseEntity.lastShieldHealth <- null


	function C_BaseEntity::constructor()
	{
		this.s = {}
		this.hudElems = {}
		this.hudVisible = false
		//
	}

	function C_BaseEntity::Get( val )
	{
		return this.GetValueForKey( val )
	}

	function C_BaseEntity::Set( key, val )
	{
		return this.SetValueForKey( key, val )
	}

	function C_BaseEntity::InitHudElem( name )
	{
		this.hudElems[name] <- HudElement( name )

		this.hudElems[name].SetVisGroupID( 0 )

		return this.hudElems[name]
	}

	function C_BaseEntity::ShowHUD()
	{
		if ( this.hudVisible )
			return

		this.hudVisible = true

		VisGroup_Show( clGlobal.menuVisGroup )

		foreach ( element in this.hudElems )
			element.UpdateVisibility()
	}

	function C_BaseEntity::HideHUD()
	{
		if ( !this.hudVisible )
			return

		this.hudVisible = false

		VisGroup_Hide( clGlobal.menuVisGroup )

		foreach ( element in this.hudElems )
			element.UpdateVisibility()
	}

	function C_BaseEntity::WaitSignal( signalID )
	{
		return WaitSignal( this, signalID )
	}

	function C_BaseEntity::EndSignal( signalID )
	{
		EndSignal( this, signalID )
	}

	function C_BaseEntity::Signal( signalID, results = null )
	{
		Signal( this, signalID, results )
	}

	function C_BaseEntity::Kill_Deprecated_UseDestroyInstead()
	{
		this.Destroy()
	}
	#document("C_BaseEntity::Kill_Deprecated_UseDestroyInstead","Kill this entity; deprecated: use ent.Destroy() instead")
}
