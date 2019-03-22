global function ShHoverBike_Init
#if(false)

#endif

const asset HOVERBIKE_MODEL = $"mdl/vehicle/hoverbike/proxy.rmdl"
//
const vector DEV_HOVERBIKE_MODEL_ROT = < 90, 0, 0 >

global enum eRodeoSpots_Hoverbike
{
	DRIVER,
	PASSENGER_MIDDLE,
	PASSENGER_REAR,
}

global enum eRodeoTransitions_Hoverbike
{
	ATTACH_DRIVER,
	SHIFT_FROM_PASSENGER_MIDDLE_TO_DRIVER,
	SHIFT_FROM_PASSENGER_REAR_TO_DRIVER, //
	DETACH_DRIVER,

	ATTACH_PASSENGER_MIDDLE,
	SHIFT_FROM_DRIVER_TO_PASSENGER_MIDDLE,
	SHIFT_FROM_PASSENGER_REAR_TO_PASSENGER_MIDDLE,
	DETACH_PASSENGER_MIDDLE,

	ATTACH_PASSENGER_REAR,
	SHIFT_FROM_DRIVER_TO_PASSENGER_REAR, //
	SHIFT_FROM_PASSENGER_MIDDLE_TO_PASSENGER_REAR,
	DETACH_PASSENGER_REAR
}

struct
{
	RodeoVehicleFlavor& hoverbikeVehicleFlavor
	#if(false)

#endif
} file

void function ShHoverBike_Init()
{
	PrecacheModel( $"mdl/titans/medium/titan_blackbox.rmdl" ) //
	PrecacheModel( $"mdl/vehicle/straton/straton_imc_gunship_01.rmdl" ) //

	PrecacheModel( HOVERBIKE_MODEL )

	#if(false)


//

//

#endif

	#if(CLIENT)
		AddCreateCallback( "script_mover", OnScriptMoverCreated )
		AddCreateCallback( "npc_gunship", OnNpcGunshipCreated )
	#endif

	RodeoVehicleFlavor vf
	vf.getAttachTransition = GetAttachTransition
	vf.onRodeoStartingFunc = OnRodeoStarting
	vf.onRodeoFinishingFunc = OnRodeoFinishing
	#if(false)


#endif
	vf.jumpOffKey = IN_USE
	file.hoverbikeVehicleFlavor = vf

	{
		RodeoSpotFlavor sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Hoverbike.DRIVER )
		sf.attachPoint = "DRIVER"
		sf.thirdPersonIdleAnim = "pt_mount_idle"
		sf.firstPersonIdleAnim = "idle"
		sf.disableWeapons = true
	}
	{
		RodeoSpotFlavor sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE )
		sf.attachPoint = "PASSENGER_MIDDLE"
		sf.thirdPersonIdleAnim = "pt_mount_idle"
		sf.firstPersonIdleAnim = "idle"
	}
	{
		RodeoSpotFlavor sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Hoverbike.PASSENGER_REAR )
		sf.attachPoint = "PASSENGER_REAR"
		sf.thirdPersonIdleAnim = "pt_mount_idle"
		sf.firstPersonIdleAnim = "idle"
	}

	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.ATTACH_DRIVER, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Hoverbike.DRIVER
		)
		tf.attachment = "DRIVER"
		tf.thirdPersonAnim = "pt_rodeo_entrance_F_front"
		tf.firstPersonAnim = "ptpov_rodeo_entrance_F_front"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Exterior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.ATTACH_PASSENGER_MIDDLE, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE
		)
		tf.attachment = "PASSENGER_MIDDLE"
		tf.thirdPersonAnim = "pt_rodeo_entrance_F_front"
		tf.firstPersonAnim = "ptpov_rodeo_entrance_F_front"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Exterior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.ATTACH_PASSENGER_REAR, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Hoverbike.PASSENGER_REAR
		)
		tf.attachment = "PASSENGER_REAR"
		tf.thirdPersonAnim = "pt_rodeo_entrance_F_front"
		tf.firstPersonAnim = "ptpov_rodeo_entrance_F_front"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Exterior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_DRIVER_TO_PASSENGER_MIDDLE, eRodeoSpots_Hoverbike.DRIVER, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE
		)
		tf.attachment = "PASSENGER_MIDDLE"
		tf.thirdPersonAnim = "pt_rodeo_trans_F2L"
		tf.firstPersonAnim = "ptpov_rodeo_trans_F2L"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_DRIVER_TO_PASSENGER_REAR, eRodeoSpots_Hoverbike.DRIVER, eRodeoSpots_Hoverbike.PASSENGER_REAR
		)
		tf.attachment = "PASSENGER_REAR"
		tf.thirdPersonAnim = "pt_rodeo_trans_F2R"
		tf.firstPersonAnim = "ptpov_rodeo_trans_F2R"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_MIDDLE_TO_DRIVER, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE, eRodeoSpots_Hoverbike.DRIVER
		)
		tf.attachment = "DRIVER"
		tf.thirdPersonAnim = "pt_rodeo_trans_L2F"
		tf.firstPersonAnim = "ptpov_rodeo_trans_L2F"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_MIDDLE_TO_PASSENGER_REAR, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE, eRodeoSpots_Hoverbike.PASSENGER_REAR
		)
		tf.attachment = "PASSENGER_REAR"
		tf.thirdPersonAnim = "pt_rodeo_trans_L2R"
		tf.firstPersonAnim = "ptpov_rodeo_trans_L2R"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_REAR_TO_DRIVER, eRodeoSpots_Hoverbike.PASSENGER_REAR, eRodeoSpots_Hoverbike.DRIVER
		)
		tf.attachment = "DRIVER"
		tf.thirdPersonAnim = "pt_rodeo_trans_R2F"
		tf.firstPersonAnim = "ptpov_rodeo_trans_R2F"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_REAR_TO_PASSENGER_MIDDLE, eRodeoSpots_Hoverbike.PASSENGER_REAR, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE
		)
		tf.attachment = "PASSENGER_MIDDLE"
		tf.thirdPersonAnim = "pt_rodeo_trans_R2L"
		tf.firstPersonAnim = "ptpov_rodeo_trans_R2L"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
}


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


#if(CLIENT)
void function OnScriptMoverCreated( entity ent )
{
	if ( ent.GetScriptName() == "hoverbike" )
	{
		OnHoverbikeCreated( ent )
	}
}
void function OnNpcGunshipCreated( entity ent )
{
	if ( ent.GetScriptName() == "hoverbike_rodeo_proxy" )
	{
		Rodeo_RegisterVehicle( ent, file.hoverbikeVehicleFlavor )
	}
}
#endif


void function OnHoverbikeCreated( entity vehicle )
{
	#if(false)
//
#endif
}


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


int function GetAttachTransition( entity rider, entity vehicle )
{
	//
	//

	if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.DRIVER ) )
	{
		return eRodeoTransitions_Hoverbike.ATTACH_DRIVER
	}

	if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE ) )
	{
		return eRodeoTransitions_Hoverbike.ATTACH_PASSENGER_MIDDLE
	}

	if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.PASSENGER_REAR ) )
	{
		return eRodeoTransitions_Hoverbike.ATTACH_PASSENGER_REAR
	}

	return RODEO_SENTINEL_TRANSITION_NONE
}


void function OnRodeoStarting( entity rider, entity vehicle )
{
	#if(false)

//
#endif
	//
	#if(CLIENT)
		if ( rider == GetLocalClientPlayer() )
		{
			AddPlayerHint( 7.0, 1.0, $"", "%&use% to detach\nPress %duck% to switch between driver/passenger" ) //
		}
	#endif
}

#if(false)







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

//
//
//
//



//










//

//



#endif

void function OnRodeoFinishing( entity rider, entity vehicle )
{
	#if(false)

#endif
	#if(CLIENT)
		if ( rider == GetLocalClientPlayer() )
		{
			HidePlayerHint( "%&use% to detach\nPress %duck% to switch between driver/passenger" ) //
		}
	#endif
}


#if(false)



//


































































#endif

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
//
//
//
//

