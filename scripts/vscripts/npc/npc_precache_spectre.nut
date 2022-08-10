global function NPCPrecache_Spectre

                                                                                          
const asset MODEL_NPC_SPECTRE = $"mdl/Humans/class/medium/spectre_v20_orange_ai.rmdl"

const asset WEAPON_NPC_SPECTRE = $"npc_weapon_hemlok"
const asset OFFHAND_NPC_SPECTRE = $"npc_weapon_thermite_grenade"

const asset WEAPON_NPC_DEATH_SPECTRE = $"npc_weapon_lstar"

void function NPCPrecache_Spectre()
{
	PrecacheModel( MODEL_NPC_SPECTRE )
	SetNPCAsset( eNPC.SPECTRE, eNPCAsset.BODY, MODEL_NPC_SPECTRE )

	PrecacheWeapon( WEAPON_NPC_SPECTRE )
	SetNPCAsset( eNPC.SPECTRE, eNPCAsset.WEAPON_0, WEAPON_NPC_SPECTRE )

	                                      
	PrecacheWeapon( OFFHAND_NPC_SPECTRE )
	SetNPCAsset( eNPC.SPECTRE, eNPCAsset.WEAPON_OFFHAND, OFFHAND_NPC_SPECTRE )

	PrecacheWeapon( WEAPON_NPC_DEATH_SPECTRE )
	SetNPCAsset( eNPC.DEATH_SPECTRE, eNPCAsset.WEAPON_0, WEAPON_NPC_DEATH_SPECTRE )

	PrecacheModel( $"mdl/robots/spectre/spectre_assault_d_gib_arm_l.rmdl" )
	PrecacheModel( $"mdl/robots/spectre/spectre_assault_d_gib_arm_r.rmdl" )
	PrecacheModel( $"mdl/robots/spectre/spectre_assault_d_gib_leg_l.rmdl" )
	PrecacheModel( $"mdl/robots/spectre/spectre_assault_d_gib_leg_r.rmdl" )

	PrecacheParticleSystem( $"P_headshot_pilot_spectre" )
}
