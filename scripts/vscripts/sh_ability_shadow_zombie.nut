global function ShAbilityShadowZombie_Init
global function IsPlayerShadowZombie
global function Ability_Shadow_Zombie_RegisterNetworking
global function AreTeammatesShadowZombiesOrRespawning

#if SERVER
	                                         
	                                           
	                                   
	                                        
	                                         


	       
		                                             
		                                         
	            
#endif


#if CLIENT
	global function ServerCallback_ShadowAbilitiesClientEffectsEnable
#endif

const string STRING_SHADOW_SOUNDS = "ShadowSounds"
const string STRING_SHADOW_FX = "ShadowFX"

struct
{
	#if CLIENT
		table< int, array< int > > playerShadowZombieClientFxHandles
	#endif         

} file

void function ShAbilityShadowZombie_Init()
{
	#if SERVER
		                                                                           
		                                                                           
		                                                                             
		                                                                                
		                                                    
	#endif
	
	PrecacheWeapon( "melee_shadowsquad_hands" )
	PrecacheWeapon( "melee_shadowroyale_hands" )
	PrecacheWeapon( "mp_weapon_shadow_squad_hands_primary" )
}

        
bool function IsPlayerShadowZombie( entity player )
{
	if ( !IsShadowRoyaleMode() && !IsFallLTM() )
		return false

	if ( !IsValid( player ) )
		return false

	if ( !player.IsPlayer() )
		return false

	return player.GetPlayerNetBool( "isPlayerShadowZombie" )
}
            

        
void function Ability_Shadow_Zombie_RegisterNetworking()
{
	if ( !IsShadowRoyaleMode() )
		return

	RegisterNetworkedVariable( "isPlayerShadowZombie", SNDC_PLAYER_GLOBAL, SNVT_BOOL, false )
	Remote_RegisterClientFunction( "ServerCallback_ShadowAbilitiesClientEffectsEnable", "entity", "bool" )

	#if CLIENT
		RegisterNetworkedVariableChangeCallback_bool( "isPlayerShadowZombie", OnServerVarChanged_IsPlayerShadowZombie )
	#endif
}
            

#if CLIENT
void function ServerCallback_ShadowAbilitiesClientEffectsEnable( entity player, bool enableFx )
{
	thread ShadowAbilitiesClientEffectsEnable( player, enableFx )
}
#endif         

#if CLIENT
void function OnServerVarChanged_IsPlayerShadowZombie( entity player, bool new )
{
	                                                                                                    
	                                                                 
	entity localViewPlayer = GetLocalViewPlayer()

	if ( player == localViewPlayer )
	{
		SetCustomPlayerInfoShadowFormState( localViewPlayer, new )
		                                                                                                      

		#if AUTO_PLAYER
			AutoPlayer_IsPlayerShadowZombieChanged( player, new )
		#endif
	}
	else
	{
		SetUnitFrameShadowFormState( player, new )
		                                                                                            
	}

}
#endif         


#if CLIENT
void function ShadowAbilitiesClientEffectsEnable( entity player, bool enableFx, bool isVictorySequence = false )
{
	AssertIsNewThread()
	wait 0.25

	if ( !IsValid( player ) )
		return

	bool isLocalPlayer = ( player == GetLocalViewPlayer() )
	vector playerOrigin = player.GetOrigin()
	int playerTeam = player.GetTeam()

	                          
	                            
	                          
	if ( enableFx )
	{
		                     
		                    
		                     
		if ( isLocalPlayer )
		{
			HealthHUD_StopUpdate( player )

			                       
			                       
			                       
			EmitSoundOnEntity( player, "ShadowLegend_Shadow_Loop_1P" )

			entity cockpit = player.GetCockpit()
			if ( !IsValid( cockpit ) )
				return

			int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( SHADOW_SCREEN_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
			EffectSetIsWithCockpit( fxHandle, true )
			vector controlPoint = <1,1,1>
			EffectSetControlPointVector( fxHandle, 1, controlPoint )

			                                                                                
			if ( !( playerTeam in file.playerShadowZombieClientFxHandles) )
				file.playerShadowZombieClientFxHandles[ playerTeam ] <- []
			file.playerShadowZombieClientFxHandles[playerTeam].append( fxHandle )

		}

		                     
		                   
		                     
		else
		{
			                   
			entity clientAG = CreateClientSideAmbientGeneric( player.GetOrigin() + <0,0,16>, "ShadowLegend_Shadow_Loop_3P", 0 )
			SetTeam( clientAG, player.GetTeam() )
			clientAG.SetSegmentEndpoints( player.GetOrigin() + <0,0,16>, playerOrigin + <0, 0, 72> )
			clientAG.SetEnabled( true )
			clientAG.RemoveFromAllRealms()
			clientAG.AddToOtherEntitysRealms( player )
			clientAG.SetParent( player, "", true, 0.0 )
			clientAG.SetScriptName( STRING_SHADOW_SOUNDS )
		}


		               
		              
		               


		                                              
		  
		                                            
		                                                               
			                                                          

		             
		                                     
		                                                                                                                                                                          

		                                              
		                                                                           

		  

	}

	                          
	                            
	                          
	else
	{
		                     
		                    
		                     
		if ( isLocalPlayer )
		{
			StopSoundOnEntity( player, "ShadowLegend_Shadow_Loop_1P" )

			if ( !( playerTeam in file.playerShadowZombieClientFxHandles) )
			{
				Warning( "%s() - Unable to find client-side effect table for player: '%s'", FUNC_NAME(), string( player ) )
			}
			else
			{
				foreach( int fxHandle in file.playerShadowZombieClientFxHandles[ playerTeam ] )
				{
					if ( EffectDoesExist( fxHandle ) )
						EffectStop( fxHandle, false, true )
				}
				delete file.playerShadowZombieClientFxHandles[ playerTeam ]
			}
		}

		                
		              
		                


		                                              
		                                              
		                                              
		array<entity> children = player.GetChildren()
		foreach( childEnt in children )
		{
			if ( !IsValid( childEnt ) )
				continue

			if ( childEnt.GetScriptName() == STRING_SHADOW_SOUNDS )
			{
				childEnt.Destroy()
				continue
			}
		}


	}
}
#endif         


#if SERVER && DEV
                                                            
 
	                                    
	 
		                                                    
		                                
		 
			                                              
		 

		                                                                  
		                               
		 
			                                                 
		 
		                                         
		                           
		 
			                                             
		 
		                                   
	 

	                                   
	                                       
 
#endif                


#if SERVER
                                                          
 
	                                                      
 
#endif          


#if SERVER
                                                        
 
	                                                                                            
		      

	                                                         
	 
			                                                       

			               
				                                                      
			      
	 

	                                       
	 
		                                                                 
		                                                                                   
		                            
		                                  
	 

                  
		                  
		 
			                         
			                        
			                         
			                                      
			                                 

			                                 
			                                                  
				                                                   
		 
                       

	                                                                                                                  

	                                
	                               
	                                
	                                        
	 
		                      
			              
	 
	                                                
	 
		                      
			              
	 

	                             
	                           
	                           
	                               
	                             
	                          
	                               
	                         
	                                        

	                                    


	                                      
	                                     
	                                      
	                                                                                    
	                                                   
		                        

	                               

	                     
	                 
	                     
	                        
	                                            
	                                            
	                         
	                                                   
	                                      

	                                         
	                                                                                            
	                                                     
	                                 

                               
		                           
		 
			                                               
			                                                                      
		 
       

	                                                             
	                                               
	                        
	                                           
	                                                                
	 
		                                               
		 
			                                     
			     
		 
	 
	                                      
		                                                                                     
	                                                                       
	                                
	                                                   
	                           

	  
	                                                                            
                  
		                                                        
                       
	  
	                              
	                             
	                              
	                                        
	                                                                             
	                                           


	                                                               
	 
		              
		                          		                                                                          	                    
		                    			      
		                          		                                                                       		                    
		                				                      
		                       			                                                               				                    
		                        		       
		                                       
		                      			                                                 

		                                        
		                                                                                                                                                                                              
	 
	    
	 
		                                 
		                                        
	 
 
#endif


#if SERVER
                                                          
 
	                         
		      

	                                      
	 
		                                                                                                                          
		      
	 

	                                       
	 
		                                                                 
		                                                                                   
		                            
		                                  
	 

	                                                        
	                                                    
	                                                    
	                              
	                            
	                        
	                                       
	                                  
	                                                          
	                                         
	                                         
	                                
	                                     
	                                        
	                                 
	                                                        
		                                                        

	               
		                                                       
	      
 
#endif             

#if SERVER
                                                             
 
	                                                                 
		                                                                                                            

	                       

	             
	                                     
	                                                                                                                                                                                          
	                                 
	                                                   
	                                                                                          
	                                 

	            
	                         
	                                             
	 
		                                                                                                                                                                                      
		                                                                                                                                                                                      
		                            
		 
			                     
			                                                                                                                   
		 
		                             

		                                   
	 

	           

                               
	  
	                           
		                                                                              
	  
       

 
#endif             




#if SERVER
                                                  
 
	                         
		      

	                  
	           
	                  
	                                       
	                                            

	                                              

	                                                   
		                                                                                                                                                                     
	    
		                                            

	                                                                              

	                      
	                     
	                      
	                      
	                 

	                                  

 
#endif             

#if SERVER
                                                       
 
	                              

	                                       
	 
		                          
			                      
	 

	                                                                 
		                                                                                                             

 
#endif             


#if SERVER
                                                                
 
	                                                                                      

	                                                                                        
	                                                                                          
	 
		                                                          
		                                                       
		 
			                                                                        
			                                     
			                                                       
			                           
		 
	 

	                                              
	                                            
	                                             
	                                                                                                           
	                                   

	                                      
	                                               
	                                      

	                                
 
#endif         



#if SERVER
                                                               
 
	                                     
	 
		                                                    
	 

	                                                 
 
#endif         



#if SERVER
                                                        
 

	                                                                        
	 
		                    
			        


		                                   
			            
	 

	           

 
#endif         



#if CLIENT || SERVER
bool function AreTeammatesShadowZombiesOrRespawning( entity player )
{

	foreach ( entity guy in GetPlayerArrayOfTeam( player.GetTeam() ) )
	{
		if ( !IsValid( guy ) )
			continue

		if ( guy == player )
			continue

		if ( guy.GetPlayerNetInt( "respawnStatus" ) == eRespawnStatus.WAITING_FOR_RESPAWN )
			continue

		if ( !IsPlayerShadowZombie( guy ) )
			return false
	}

	return true

}
#endif                   
