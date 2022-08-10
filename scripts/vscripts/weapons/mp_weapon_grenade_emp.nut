global function OnProjectileCollision_weapon_grenade_emp

void function OnProjectileCollision_weapon_grenade_emp( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
{
               
                                                    
  
                                                                                                     
        
  
       

	if ( !IsValid( hitEnt ) )
		return

	if ( IsValid( projectile.GetOwner() ) && hitEnt == projectile.GetOwner() )
		return

	if ( hitEnt.IsPlayer() && IsFriendlyTeam( hitEnt.GetTeam(), projectile.GetTeam() ) )
		return

	if ( hitEnt.IsPlayerVehicle() && IsFriendlyTeam( hitEnt.GetTeam(), projectile.GetTeam() ) )
		return

#if SERVER
	                                                                                                          
		      
#endif

	DeployableCollisionParams collisionParams
	collisionParams.pos = pos
	collisionParams.normal = normal
	collisionParams.hitEnt = hitEnt
	collisionParams.hitBox = hitBox
	collisionParams.isCritical = isCritical

	if ( hitEnt.IsPlayer() && StatusEffect_GetTimeRemaining(hitEnt, eStatusEffect.death_totem_recall) )
	{
		projectile.SetVelocity( <0,0,0> )
		projectile.ClearParent()
		projectile.SetPhysics( MOVETYPE_FLYGRAVITY )
	}
	else
	{
		PlantStickyEntity( projectile, collisionParams, <0, 0, 0>,true )
	}

	if ( projectile.GrenadeHasIgnited() )
		return

	projectile.GrenadeIgnite()

	#if SERVER
		                                 
	#endif
}


void function ArcCookSound( entity projectile )
{
	if ( !IsValid( projectile ) )
		return

	projectile.EndSignal( "OnDestroy" )

	string cookSound   = expect string( projectile.ProjectileGetWeaponInfoFileKeyField( "sound_cook_warning" ) )

	float stickTime = 0.2
	wait stickTime                                                  

	EmitSoundOnEntity( projectile, cookSound )
}


