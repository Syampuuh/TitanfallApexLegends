global function ShPrecacheTreasureExtractionAssets

void function ShPrecacheTreasureExtractionAssets()
{
	PrecacheObjectiveAsset_Model( "TREASUREEXTRACT_MODEL_USABLE_BUTTON", $"mdl/props/treasure_hunt_drill/treasure_hunt_drill.rmdl" )
	PrecacheObjectiveAsset_FX( "TREASUREEXTRACT_FX_EXTRACTION_COMPLETE", $"P_th_drill_plant" )	                                                                                       
	PrecacheObjectiveAsset_Model( "TREASUREEXTRACT_MODEL_DRILL_BASE", $"mdl/props/treasure_hunt_drill/treasure_hunt_drill.rmdl" )
	PrecacheObjectiveAsset_Model( "TREASUREEXTRACT_MODEL_TREASURE_CASE", $"mdl/props/treasure_hunt_drill_box/treasure_hunt_drill_box.rmdl" )
	PrecacheObjectiveAsset_FX( "HARVESTER_FX_EXTRACTION_BEAM", $"P_th_drill_beam" )
	PrecacheObjectiveAsset_FX( "HARVESTER_FX_PLANT", $"P_th_drill_plant" )	                                                 
}
