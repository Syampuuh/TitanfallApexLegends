global function ShPrecacheBreachAndClearAssets

void function ShPrecacheBreachAndClearAssets()
{
	PrecacheObjectiveAsset_Model( "BREACH_AND_CLEAR_MODEL_LOCK", $"mdl/IMC_base/door_lock_small_IMC_01.rmdl" )
	PrecacheObjectiveAsset_FX( "BREACH_AND_CLEAR_FX_LOCK_EXPLODE", $"P_door_lock_IMC_exp_LG" )
	PrecacheObjectiveAsset_FX( "FX_BREACH_DOOR_LOCK_GREEN", $"P_door_lock_IMC_open" )
	PrecacheObjectiveAsset_FX( "FX_BREACH_DOOR_LOCK_RED", $"P_door_lock_IMC_locked" )
}
