#if (CLIENT || SERVER)
global function PrecacheObjectiveAsset_Model
global function GetObjectiveAsset_Model

global function PrecacheObjectiveAsset_FX
global function GetObjectiveAsset_FX
#endif                      


#if (CLIENT || SERVER)

table<string, asset> s_models
void function PrecacheObjectiveAsset_Model( string name, asset model )
{
	Assert( !(name in s_models), format( "Objective model asset '%s' has already been registered with asset '%s'.", name, string( s_models[name] ) ) )
	s_models[name] <- model
	PrecacheModel( model )
}
asset function GetObjectiveAsset_Model( string name )
{
	Assert( (name in s_models), format( "Objective model asset '%s' has not been registered.", name ) )
	return s_models[name]
}

table<string, asset> s_fxs
void function PrecacheObjectiveAsset_FX( string name, asset fx )
{
	Assert( !(name in s_fxs), format( "Objective fx asset '%s' has already been registered with asset '%s'.", name, string( s_fxs[name] ) ) )
	s_fxs[name] <- fx
	PrecacheParticleSystem( fx )
}
asset function GetObjectiveAsset_FX( string name )
{
	Assert( (name in s_fxs), format( "Objective fx asset '%s' has not been registered.", name ) )
	return s_fxs[name]
}

#endif                      

