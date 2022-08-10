untyped

global function Grenade_FileInit
global function GetGrenadeThrowSound_1p
global function GetGrenadeDeploySound_1p
global function GetGrenadeThrowSound_3p
global function GetGrenadeDeploySound_3p
global function GetGrenadeProjectileSound
global function Grenade_OnWeaponToss

             
                                                                                                          
                      

const DEFAULT_FUSE_TIME = 2.25
global const float DEFAULT_MAX_COOK_TIME = 99999.9                                                                     

global function Grenade_OnWeaponTossReleaseAnimEvent
global function Grenade_OnWeaponTossCancelDrop
global function Grenade_OnWeaponDeactivate
global function Grenade_OnWeaponTossPrep
global function Grenade_OnProjectileIgnite
global function Grenade_UpdateStats
global function Grenade_OnWeaponActivate
global function Grenade_OnProjectileCollision

#if SERVER
                                                     
              
                                       
                                  
                                     
      
                                     
#endif
global function Grenade_Init
global function Grenade_Launch

                      
          
                                      
                                         
      
      

const EMP_MAGNETIC_FORCE = 1600
const MAG_FLIGHT_SFX_LOOP = "Explo_MGL_MagneticAttract"

                         
                                              
                                                          
                                              
      
const TRIGGERED_ALARM_SFX = "Weapon_ProximityMine_CloseWarning"
global const THERMITE_GRENADE_FX = $"P_grenade_thermite"
global const CLUSTER_BASE_FX = $"P_wpn_meteor_exp"
global const string FUNCNAME_GRENADE_TOGGLE_PLACEABLE = "Grenade_TogglePlaceable"
global const string PLACEABLE_MOD_NAME = "placeable"

global const ProximityTargetClassnames = {
	[ "npc_soldier_shield" ] = true,
	[ "npc_soldier_heavy" ] = true,
	[ "npc_soldier" ] = true,
	[ "npc_spectre" ] = true,
	[ "npc_drone" ] = true,
	[ "npc_titan" ] = true,
	[ "npc_marvin" ] = true,
	[ "player" ] = true,
	[ "npc_turret_mega" ] = true,
	[ "npc_turret_sentry" ] = true,
	[ "npc_dropship" ] = true,
}

const SOLDIER_ARC_STUN_ANIMS = [
	"pt_react_ARC_fall",
	"pt_react_ARC_kneefall",
	"pt_react_ARC_sidefall",
	"pt_react_ARC_slowfall",
	"pt_react_ARC_scream",
	"pt_react_ARC_stumble_F",
	"pt_react_ARC_stumble_R" ]

struct
{
               
                               
                                
       
} file

void function Grenade_FileInit()
{
	PrecacheParticleSystem( CLUSTER_BASE_FX )

	RegisterSignal( "ThrowGrenade" )
	RegisterSignal( "WeaponDeactivateEvent" )
	RegisterSignal( "OnEMPPilotHit" )
	RegisterSignal( "StopGrenadeClientEffects" )
	RegisterSignal( "DisableTrapWarningSound" )
               
                                        
       

	                             

	#if CLIENT
		AddDestroyCallback( "grenade_frag", ClientDestroyCallback_GrenadeDestroyed )
	#endif

	#if SERVER
		                               
		                                                              

		                                                                                                    
		                                                                                            

		                                                                        
		                                                                              

		                                             
	#endif

               
                                                                             
       
}


void function Grenade_OnWeaponTossPrep( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.w.startChargeTime = Time()

	entity weaponOwner = weapon.GetWeaponOwner()
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )

	#if SERVER
		                                              
		                                                     
	#elseif CLIENT
		if ( weaponOwner.IsPlayer() )
		{
			weaponOwner.p.grenadePulloutTime = Time()
		}
	#endif
}


void function Grenade_OnWeaponActivate( entity weapon )
{
               
                                                    
         

                                  
                                                                                                   
         

                                                                                
                                      
       
}

void function Grenade_OnWeaponDeactivate( entity weapon )
{
	weapon.Signal( "WeaponDeactivateEvent" )
}


void function Grenade_OnProjectileIgnite( entity weapon )
{
	printt( "Grenade_OnProjectileIgnite() callback." )
}

void function Grenade_UpdateStats( entity projectile )
{
	#if SERVER
		                                                                    
	#endif
}


void function Grenade_Init( entity grenade, entity weapon )
{
	entity weaponOwner = weapon.GetOwner()
	if ( IsValid( weaponOwner ) )
		SetTeam( grenade, weaponOwner.GetTeam() )

	                                                                
	                                                                                
	                                                                      
	entity owner = weapon.GetWeaponOwner()
	if ( IsValid( owner ) && owner.IsNPC() )
		SetTeam( grenade, owner.GetTeam() )

	var magnetic_force = weapon.GetWeaponInfoFileKeyField( "projectile_magnetic_force" )

	if ( magnetic_force != null )
	{
		grenade.InitMagnetic( magnetic_force, "Explo_MGL_MagneticAttract" )
	}

	#if SERVER
		                                                                                                    
		                         
		 
			                                      
			                                               
			                                              

			                                                                                                                                                                      
				                                                                           
		 
		    
		 
			                                      
		 
	#endif
	if ( IsValid( weaponOwner ) )
		grenade.s.originalOwner <- weaponOwner                                                                                                    
}


int function Grenade_OnWeaponToss( entity weapon, WeaponPrimaryAttackParams attackParams, float directionScale )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )
	bool projectilePredicted      = PROJECTILE_PREDICTED
	bool projectileLagCompensated = PROJECTILE_LAG_COMPENSATED
	#if SERVER
		                                        
		 
			                           
			                                
		 
	#endif
	entity grenade     = Grenade_Launch( weapon, attackParams.pos, (attackParams.dir * directionScale), projectilePredicted, projectileLagCompensated )
	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.Signal( "ThrowGrenade" )

	PlayerUsedOffhand( weaponOwner, weapon, true, grenade )                                                                                                  

	if ( IsValid( grenade ) )
		grenade.proj.savedDir = weaponOwner.GetViewForward()

	#if SERVER
		                                                     
	#endif

	#if SERVER
		                                               
		                                                                                                
	#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


var function Grenade_OnWeaponTossReleaseAnimEvent( entity weapon, WeaponPrimaryAttackParams attackParams )
{
               
                                 
                                                                                        
  
                                                   
   
                                             
                                          
       
                                           
   
  
       
	var result = Grenade_OnWeaponToss( weapon, attackParams, 1.0 )
	return result
}
#if SERVER
                                                                               
 
	                                                                                 
	   
	  	                                             
	  	 
			                                              
			      
		   
	   

	                                  
	                                       
	                                        
	                                                 
 
#endif          

#if SERVER
                                                                         
 
	                                        

	                                                   
	 
		                                               
		   
		  	                                           
		  	 
				                          

				                             
					                                                                                                                                        
			   
		   
	 
 
#endif          

#if SERVER
                                                                                  
 
	                                                         
	      
 
#endif          

             
                                                                                  
                                                                                                                         
 
                                                                              
              
 

                                                                                                                               
 
                                                                                                    
                                                     
                                                           
           
                                          
   
                              
                                   
   
       

                                             
                                         
  
                                                                                                              
                                                                                                                                                        
  
                                     


           
                                                       
       

                                                              
 
                      

var function Grenade_OnWeaponTossCancelDrop( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

                               
entity function Grenade_Launch( entity weapon, vector attackPos, vector throwVelocity, bool isPredicted, bool isLagCompensated, bool applyAngularVelocity = true )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() || !isPredicted )
			return null
	#endif

	var discThrow = weapon.GetWeaponInfoFileKeyField( "grenade_disc_throw" )

	                                               
	float currentTime = Time()
	if ( weapon.w.startChargeTime == 0.0 )
		weapon.w.startChargeTime = currentTime

	                                                                                                                                                                
	float fuseTime         = weapon.GetGrenadeFuseTime()
	bool startFuseOnLaunch = bool( weapon.GetWeaponInfoFileKeyField( "start_fuse_on_launch" ) )

	if ( fuseTime > 0 && !startFuseOnLaunch )
	{
		fuseTime = fuseTime - (currentTime - weapon.w.startChargeTime)
		if ( fuseTime <= 0 )
			fuseTime = 0.001
	}

	                                                                                  
	                                                                                                                                     
	vector angularVelocity = <0, 0, 0>
	if ( applyAngularVelocity )
	{
		angularVelocity = <10, -1600, 10>
		if ( discThrow == 1 )
			angularVelocity = <0, 30, -2200>
	}

	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = attackPos
	fireGrenadeParams.vel = throwVelocity
	fireGrenadeParams.angVel = angularVelocity
	fireGrenadeParams.fuseTime = fuseTime
	fireGrenadeParams.scriptTouchDamageType = (damageFlags & ~DF_EXPLOSION)                                                                                 
	fireGrenadeParams.scriptExplosionDamageType = damageFlags
	fireGrenadeParams.clientPredicted = isPredicted
	fireGrenadeParams.lagCompensated = isLagCompensated
	fireGrenadeParams.useScriptOnDamage = true
	entity frag = weapon.FireWeaponGrenade( fireGrenadeParams )
	if ( frag == null )
		return null

	#if SERVER
		                                      
		                       
		 
			                                
			 
				                                 
			 
			    
			 
				                          
				                                     
			 
		 
	#endif

	if ( discThrow == 1 )
	{
		Assert( !frag.IsMarkedForDeletion(), "Frag before .SetAngles() is marked for deletion." )

		frag.SetAngles( <8, 0, 0> )                                                    

		if ( frag.IsMarkedForDeletion() )
		{
			Warning( "Frag after .SetAngles() was marked for deletion." )
			return null
		}
	}

	frag.proj.savedOrigin = attackPos
	Grenade_OnPlayerNPCTossGrenade_Common( weapon, frag )

	return frag
}


void function Grenade_OnPlayerNPCTossGrenade_Common( entity weapon, entity frag )
{
	Grenade_Init( frag, weapon )
	#if SERVER
		                                                            
		                            
			                                          
	#endif

	if ( weapon.HasMod( "burn_mod_emp_grenade" ) )
		frag.InitMagnetic( EMP_MAGNETIC_FORCE, MAG_FLIGHT_SFX_LOOP )
}

struct CookGrenadeStruct
                                                                                               
{
	bool shouldOverrideFuseTime = false
}

void function HACK_CookGrenade( entity weapon, entity weaponOwner )
{
	float maxCookTime = GetMaxCookTime( weapon )
	if ( maxCookTime >= DEFAULT_MAX_COOK_TIME )
		return

	weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.EndSignal( "ThrowGrenade" )
	weapon.EndSignal( "WeaponDeactivateEvent" )
	weapon.EndSignal( "OnDestroy" )

	                                 

	            
	                                      
		 
			                                           
			 
				                                                                     
				                                       
				                          
				 
					                           
					                                                                                                
					                                        
				 
			 
		 
	   

	wait(maxCookTime)

	if ( !IsValid( weapon.GetWeaponOwner() ) )
		return

	weaponOwner.Signal( "ThrowGrenade" )                                                 
}


void function HACK_WaitForGrenadeDropEvent( entity weapon, entity weaponOwner )
{
	weapon.EndSignal( "WeaponDeactivateEvent" )

	weaponOwner.WaitSignal( "OnDeath" )
}


void function HACK_DropGrenadeOnDeath( entity weapon, entity weaponOwner )
{
	if ( weapon.HasMod( "burn_card_weapon_mod" ) )                                                                                                                                         
		return

	weaponOwner.EndSignal( "ThrowGrenade" )
	weaponOwner.EndSignal( "OnDestroy" )

	waitthread HACK_WaitForGrenadeDropEvent( weapon, weaponOwner )

	if ( !IsValid( weaponOwner ) || !IsValid( weapon ) || IsAlive( weaponOwner ) )
		return

	float elapsedTime  = Time() - weapon.w.startChargeTime
	float baseFuseTime = weapon.GetGrenadeFuseTime()
	float fuseDelta    = (baseFuseTime - elapsedTime)

	if ( (baseFuseTime == 0.0) || (fuseDelta > -0.1) )
	{
		float forwardScale = weapon.GetWeaponSettingFloat( eWeaponVar.grenade_death_drop_velocity_scale )
		vector velocity    = weaponOwner.GetForwardVector() * forwardScale
		velocity.z += weapon.GetWeaponSettingFloat( eWeaponVar.grenade_death_drop_velocity_extraUp )
		vector angularVelocity = <0, 0, 0>
		float fuseTime         = baseFuseTime ? baseFuseTime - elapsedTime : baseFuseTime

		if ( weapon.GetWeaponPrimaryClipCountMax() > 0 )
		{
			int primaryClipCount = weapon.GetWeaponPrimaryClipCount()
			int ammoPerShot      = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
			weapon.SetWeaponPrimaryClipCountAbsolute( maxint( 0, primaryClipCount - ammoPerShot ) )
		}

		PlayerUsedOffhand( weaponOwner, weapon )                                                                                            

		entity grenade = Grenade_Launch( weapon, weaponOwner.GetOrigin(), velocity, PROJECTILE_NOT_PREDICTED, PROJECTILE_NOT_LAG_COMPENSATED )
	}
}


#if SERVER

                                                                       
 
	                      
		      

	                                       
 

                                                                   
 
	                                                         
		      

	                         
		                                         
 
#endif          


#if CLIENT
void function ClientDestroyCallback_GrenadeDestroyed( entity grenade )
{
}
#endif          

              
          
                                                                     
 
                                               
        

                           
        

                                                         
        

                                                   
        

                                           
                                        
     
                                     
 
      
      

void function Grenade_OnProjectileCollision( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
{
               
           
                                                       
         

                           
         

                                      

                                             
         

                                                                                      
         

                                                                                             
         

                                                                                                            
         

                                                       
         

                                           
                           
                                 
                                 
                                 
                                         

                                                                                                     
   
                                    
                           
                                               
   
      
   
                                                                   
   

                                       
         

                                                               
                                                                                                       
                                  
   
                                     
                                     
   

                           
                    
                  
                           
                                             
       
       
}

#if SERVER
                                                 
 
	                                                                
 

                                                                                                        
                                                                                   
 
                                        

             
                                
   
                                  
                           
   
  
                                                      
                                                                      

                                                                

                                 

                                                               
                       
               
  
                                            
                                             
                              
                                                      
   
                                                          
                                                                                                                                                           
    
                          
                     
     
                                                  
                     
     
         
    
   

                                 
        

          
  

                                                                    
                                                          
                                             

                                                    
                                                            
                                                           
                              
                                
                                

                                                                                                                                                                                   
                                                               
                           
                                                                                

                                                                     

             
                        
   
                          
                       
   
  

                                       
                                                          
  
                                                    
   
                                                                                                                  
                                
    
                                                          
     
                                                                      
                                               
           
     
    
                               
   

                                                                                                                
                                  
   
                                                         
    
                                                                     
                                              

                           
                        

          
    
   

                            
  
 

                                                                                      
 
                                                        

                                                                                                                                     
                                                                       

                                                                                                                                                                                                             
                                
                                                   
                                     

              

                                
  
                             
                          

                                                       
                                                          

                                               
   
                                     
                                          
                                                      
   
      
   
                                                                   
   
  
 

                                                                           
 
                                                                
              

                            
              

                                                                                                                                                                   
                                                      
             

             
 
      
#endif          


float function GetMaxCookTime( entity weapon )
{
	var cookTime = weapon.GetWeaponSettingFloat( eWeaponVar.max_cook_time )
	if ( cookTime == null )
		return DEFAULT_MAX_COOK_TIME

	expect float( cookTime )
	return cookTime
}


string function GetGrenadeThrowSound_1p( entity weapon )
{
	return weapon.GetWeaponSettingString( eWeaponVar.sound_throw_1p )
}


string function GetGrenadeDeploySound_1p( entity weapon )
{
	return weapon.GetWeaponSettingString( eWeaponVar.sound_deploy_1p )

}


string function GetGrenadeThrowSound_3p( entity weapon )
{
	return weapon.GetWeaponSettingString( eWeaponVar.sound_throw_3p )
}


string function GetGrenadeDeploySound_3p( entity weapon )
{
	return weapon.GetWeaponSettingString( eWeaponVar.sound_deploy_3p )
}


string function GetGrenadeProjectileSound( entity weapon )
{
	return weapon.GetWeaponSettingString( eWeaponVar.sound_grenade_projectile )
}