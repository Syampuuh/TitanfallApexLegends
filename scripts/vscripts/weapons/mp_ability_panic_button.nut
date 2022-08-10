global function OnWeaponAttemptOffhandSwitch_ability_panic_button
global function OnWeaponPrimaryAttack_ability_panic_button

global function PanicButton_Init

#if CLIENT
global function SCB_BroadcastPanicButtonCast
global function SCB_DoPanicHealFeedback
global function SCB_DoPanicSkydiveFeedback
#endif          

enum ePanicButton
{
	NOTHING,

	HEALING,
	SKYDIVE,
	LOOTFOUNTAIN,
	DANCEPARTY,

	_count
}

const asset FX_HEAL_HEALED3P = $"P_heal_3p"
const asset FX_HEAL_RADIUS = $"P_ar_heal_radius_CP"

const string FUNCNAME_BroadcastPanicButtonCast = "SCB_BroadcastPanicButtonCast"
const string FUNCNAME_DoPanicHealFeedback = "SCB_DoPanicHealFeedback"
const string FUNCNAME_DoPanicSkydiveFeedback = "SCB_DoPanicSkydiveFeedback"
void function PanicButton_Init()
{
	Remote_RegisterClientFunction( FUNCNAME_BroadcastPanicButtonCast, "entity", "int", 0, ePanicButton._count, "int", 0, 128 )
	Remote_RegisterClientFunction( FUNCNAME_DoPanicHealFeedback )
	Remote_RegisterClientFunction( FUNCNAME_DoPanicSkydiveFeedback )

	PrecacheParticleSystem( FX_HEAL_HEALED3P )
	PrecacheParticleSystem( FX_HEAL_RADIUS )
}

bool function OnWeaponAttemptOffhandSwitch_ability_panic_button( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}

  

#if SERVER

                         
                                 
 
	                               
		      

	                                                                     
		                                             
	                                                                      
		                                             
	                                                                          
		                                                  
	                                                                        
		                                                
 

                               
 
	       
	 
		                               
		                  
		 
			        	                           
			        	                           
			        	                                
			        	                              
		 
	 
	             

	                   
	                                
		                           

	                                 
 
#endif          

#if SERVER

                                                                                                                 
 
	                                                                                                              
 

                              
 
	                                                               
 

                                                                                     
 
	                                                                                                          

	          
	 
		                  
		                                           
		 
			                                            
				                       
		 

		                              
		                                           
		 
			                                            
			                          
		 
	 

	              
 

                                                   
 
	                                                                                  
	                                                                                    

	                
	 
		                                                                                                                                                     
		                            
		                                                                                                                               
		                                     
		                                   
		                                                    
		                                                               
	 


	                     
	                                                                           
	                               
	 
		                         
			        
		                                       
			        
		                              
			        

		                        
	 

	                 
	                            
	 
		                                                     
		                                                                    

		           
		                                                                                    
		                                                                                      
		                                                                  

		             
		 
			                                                                                                                                                                        
			                                                                                              
		 
	 

	                            
		                                                                               
 

                                                   
 
	                     
	                                                                           
	                               
	 
		                         
			        
		                                       
			        
		                              
			        
		                                      
			        
		                                       
			        
		                                    
			        

		                        
	 

	                    
	                                             
	                            
	 
		                                  
		                                                 
		                          
		                                                 

		                                                                  
		                                                                     
		              
	 

	                            
		                                                                                  
 

                                                        
 
	                                   
	 
		                                                             
		                     
			        

		                                                                     

		                                                   
		                                                                                          
		                                                                                                      
	 

	                                                                                  
	                                                                                    

	                                                                        
	                             
		                                                                            
 

                                                     
 
	                                      

	                                                                                          
	                                                                                                  
	                                                          
	 
		                                                                                                  
		                                                          
		                                                                                                                          
		                                                                                                                          

		                                                                             
		                        
		                     
		                                                                                                          
		                            
		                            
		                              
		                                       
		                                            
		                                                                                                   
			                       
				                                                     
		   
	 
 

                                                                     
 
	                                

	                                                                                   
	                                                                                     

	                                                                        
	                             
		                                                                          
 
#endif          

var function OnWeaponPrimaryAttack_ability_panic_button( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( !IsValid( weaponOwner ) || !weaponOwner.IsPlayer() )
		return

	#if SERVER
		  
		                                  
		                   
		 
			                          
				                                   
				     
			                          
				                                   
				     
			                               
				                                        
				     
			                             
				                                              
				     
		 

	#endif          

	#if CLIENT
		ScreenFlash( 3.0, 3.0, 5.0, 0.2, 0.4 )
	#endif          

	PlayerUsedOffhand( weaponOwner, weapon )
	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}


#if CLIENT
string function GetAnnounceTextForPanicType( int panicType )
{
	switch ( panicType )
	{
		case ePanicButton.HEALING:
			return "EMERGENCY  AREA  HEAL"
		case ePanicButton.SKYDIVE:
			return "EMERGENCY  MASS  TELEPORT"
		case ePanicButton.LOOTFOUNTAIN:
			return "EMERGENCY  LOOT  Piñata"
		case ePanicButton.DANCEPARTY:
			return "EMERGENCY  DANCE  PARTY"
	}

	return format( "ERR - %s( %d )", FUNC_NAME(), panicType )
}

string function GetAnnounceSubTextForPanicType( entity player, int panicType, int targetCount, entity localPlayer )
{
	if ( !IsValid( player ) )
		return ""

	if ( player == localPlayer )
	{
		switch ( panicType )
		{
			case ePanicButton.HEALING:
				return format( "Targets Healed: %d", targetCount )
			case ePanicButton.SKYDIVE:
				return format( "Targets Teleported: %d", targetCount )
			case ePanicButton.LOOTFOUNTAIN:
				return ""
			case ePanicButton.DANCEPARTY:
				return ""
		}

		return ""
	}

	string playerName = GetPlayerNameFromEHI( ToEHI( player ) )
	return format( "%s hit their Panic Button.", playerName )
}

void function SCB_BroadcastPanicButtonCast( entity player, int panicType, int targetCount )
{
	entity localPlayer = GetLocalClientPlayer()
	string mainText = GetAnnounceTextForPanicType( panicType )
	string subText = GetAnnounceSubTextForPanicType( player, panicType, targetCount, localPlayer )
	vector titleColor = <1.8, 0.4, 0.2>
	float duration = 3.0
	AnnouncementMessageSweep( localPlayer, mainText, subText, titleColor, $"", SFX_HUD_ANNOUNCE_QUICK, duration )
}

void function SCB_DoPanicHealFeedback()
{
	entity localPlayer = GetLocalClientPlayer()
	if ( !IsAlive( localPlayer ) )
		return

	ScreenFlash( 3.0, 16.0, 5.0, 0.2, 0.5 )
	thread DoHealScreenFX( localPlayer )
}

void function SCB_DoPanicSkydiveFeedback()
{
	entity localPlayer = GetLocalClientPlayer()
	if ( !IsAlive( localPlayer ) )
		return

	ScreenFlash( 0.0, 0.0, 0.0, 0.2, 1.0 )
	EmitSoundOnEntity( GetLocalViewPlayer(), "dropship_mp_epilogue_warpout" )
}
#endif          
