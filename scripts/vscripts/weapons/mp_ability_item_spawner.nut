global function OnWeaponPrimaryAttack_ItemSpawner

var function OnWeaponPrimaryAttack_ItemSpawner( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert( weaponOwner.IsPlayer() )

#if SERVER
	                                               

	                                         
	                                                                         
	                           
	  	                                       
	                                               
	                     
		        

	                                                                     

	                                                 
	                                   
	                                                                                                              
#endif          

#if CLIENT
	ScreenFlash( 4.0, 4.0, 4.0, 0.1, 0.2 )
#endif          

	weapon.EmitWeaponSound_1p3p( "Dummie_Tactical_Trigger_1p", "Dummie_Tactical_Trigger_3p" )
	PlayerUsedOffhand( weaponOwner, weapon )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}

