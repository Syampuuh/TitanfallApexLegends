global function NPCPrecache_Marvin

const asset MODEL_NPC_MARVIN = $"mdl/robots/marvin/marvin_base_v2.rmdl"

const asset MARVIN_GIB_LEG_L = $"mdl/robots/marvin_v2/marvin_v2_l_leg_gib.rmdl"
const asset MARVIN_GIB_LEG_R = $"mdl/robots/marvin_v2/marvin_v2_r_leg_gib.rmdl"
const asset MARVIN_GIB_ARM_L = $"mdl/robots/marvin_v2/marvin_v2_l_arm_gib.rmdl"
const asset MARVIN_GIB_ARM_R = $"mdl/robots/marvin_v2/marvin_v2_r_arm_gib.rmdl"
const asset MARVIN_GIB_HEAD = $"mdl/robots/marvin_v2/marvin_v2_head_gib.rmdl"

const asset MARVIN_FX_EYE = $"P_marvin_eye_SM"
const asset MARVIN_FX_DAMAGE = $"P_marvin_dmg_elec"
const asset MARVIN_FX_DEATH_EXPLO = $"P_exp_marvin_death"
const asset MARVIN_FX_HEADSHOT = $"P_marvin_headshot"

void function NPCPrecache_Marvin()
{
	                                                        
	                                                              

	                                                       

	PrecacheModel( MODEL_NPC_MARVIN )
	PrecacheModel( MARVIN_GIB_LEG_L )
	PrecacheModel( MARVIN_GIB_LEG_R )
	PrecacheModel( MARVIN_GIB_ARM_L )
	PrecacheModel( MARVIN_GIB_ARM_R )
	PrecacheModel( MARVIN_GIB_HEAD )

	PrecacheParticleSystem( MARVIN_FX_EYE )
	PrecacheParticleSystem( MARVIN_FX_DAMAGE )
	PrecacheParticleSystem( MARVIN_FX_DEATH_EXPLO )
	PrecacheParticleSystem( MARVIN_FX_HEADSHOT )

	SetNPCAsset( eNPC.MARVIN, eNPCAsset.BODY, MODEL_NPC_MARVIN )

	#if CLIENT
		ClMarvin_InitFX()
	#endif
}


#if CLIENT
void function ClMarvin_InitFX()
{
	const float MIN_VELO = 150
	const float MAX_VELO = 250

	           
	ModelFX_BeginData( "stalkerHealth", MODEL_NPC_MARVIN, "all", true )
	ModelFX_AddTagHealthFX( 0.25, "CHESTFOCUS", MARVIN_FX_DAMAGE, false )
	ModelFX_EndData()

	ModelFX_BeginData( "death_fx", MODEL_NPC_MARVIN, "all", true )
	ModelFX_AddTagBreakGib( 1, "HEADFOCUS", MARVIN_GIB_HEAD, GIBTYPE_NORMAL, MIN_VELO, MAX_VELO )
	ModelFX_AddTagBreakGib( 1, "left_arm", MARVIN_GIB_ARM_L, GIBTYPE_NORMAL, MIN_VELO, MAX_VELO )
	ModelFX_AddTagBreakGib( 1, "right_arm", MARVIN_GIB_ARM_R, GIBTYPE_NORMAL, MIN_VELO, MAX_VELO )
	ModelFX_AddTagBreakGib( 1, "left_leg", MARVIN_GIB_LEG_L, GIBTYPE_NORMAL, MIN_VELO, MAX_VELO )
	ModelFX_AddTagBreakGib( 1, "right_leg", MARVIN_GIB_LEG_R, GIBTYPE_NORMAL, MIN_VELO, MAX_VELO )
	ModelFX_EndData()


	          
	ModelFX_BeginData( "lights", MODEL_NPC_MARVIN, "all", true )
	ModelFX_HideFromLocalPlayer()
	ModelFX_AddTagSpawnFX( "EYEFX", MARVIN_FX_EYE )
	ModelFX_EndData()
}
#endif

