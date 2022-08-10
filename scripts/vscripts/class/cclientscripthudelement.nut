untyped

global function CodeCallback_RegisterClass_CClientScriptHudElement

                                                                                                                                                     
var function CodeCallback_RegisterClass_CClientScriptHudElement()
{
	CClientHudElement.ClassName <- "CClientHudElement"

	CClientHudElement._name <- null                       
	CClientHudElement._displayName <- null
	CClientHudElement.s <- null
	CClientHudElement.childElements <- null
	CClientHudElement.classElements <- null
	CClientHudElement.loadoutID <- null
	CClientHudElement._parentMenu <- null                       
	CClientHudElement._panelAlpha <- null
	CClientHudElement._type <- null

	function CClientHudElement::constructor()
	{
		this.s = {}
		this.childElements = {}
		this.classElements = {}
		this._panelAlpha = 255
		this._type = "default"
	}

	function CClientHudElement::SetType( elemType )
	{
		this._type = elemType
	}

	function CClientHudElement::GetType()
	{
		return this._type
	}

	CClientHudElement.__CodeGetName <- CClientHudElement.GetHudName                       
	function CClientHudElement::GetHudName()                       
	{
		if ( this._name == null )
			return this.__CodeGetName()

		return this._name
	}

	function CClientHudElement::SetHudName( elemName )                       
	{
		this._name = elemName
	}

	function CClientHudElement::SetDisplayName( name )
	{
		this._displayName = name
	}

	function CClientHudElement::GetDisplayName()
	{
		return this._displayName
	}

	function CClientHudElement::EndSignal( signalID )
	{
		EndSignal( this, signalID )
	}

	function CClientHudElement::Signal( signalID, results = null )
	{
		Signal( this, signalID, results )
	}

	function CClientHudElement::FadePanelOverTime( alpha, duration )
	{
		this.FadePanelOverTimeDelayed( alpha, duration, 0.0 )
	}

	function CClientHudElement::FadePanelOverTimeDelayed( alpha, duration, delay )
	{
		this.RunAnimationCommand( "Alpha", alpha, delay, duration, INTERPOLATOR_LINEAR, 0.0 )
	}

	CClientHudElement.__CodeGetChild <- CClientHudElement.GetChild
	function CClientHudElement::GetChild( elemName )
	{
		if ( !(elemName in this.childElements) )
			this.childElements[elemName] <- this.__CodeGetChild( elemName )

		return this.childElements[elemName]
	}
}
