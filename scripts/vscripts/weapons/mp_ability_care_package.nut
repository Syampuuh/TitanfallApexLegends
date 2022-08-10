global function OnWeaponPrimaryAttack_care_package_medic

                   
	#if SERVER
	                                                
	#endif
      

struct AirdropContents
{
	array<string> left
	array<string> right
	array<string> center
}

struct LootPool
{
	                                                                          
	table< string, int > equipmentTable
	table< string, int > attachmentTable

	array<string> armorLootGroup
	array<string> equipmentLootGroup
	array<string> attachmentsLootGroup
}

enum eLootPoolType
{
	ARMOR
	OTHER_EQUIPMENT
	ATTACHMENTS
	SMALL_CONSUMABLE
	LARGE_CONSUMABLE
	DEAD

	_count
}

struct
{
	array<string> validSlots = [
		"armor",
		"helmet",
		"incapshield",
		"backpack",
	]

} file

var function OnWeaponPrimaryAttack_care_package_medic( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	CarePackagePlacementInfo placementInfo = GetCarePackagePlacementInfo( ownerPlayer )

	if ( placementInfo.failed )
		return 0

	#if SERVER
		                                    
		                                    

		                               

		                                   
		                                                       
		                              
		                                       
		                                                                
		                                                        
		                                                              
		                                    

                         
			                    
			 
				                                               
				                                
			 
        
                          
			                              
			 
				                                                             
				                                
			 
        

		                               
			                                                                

		                                                                       

		                                                                

		                                                                    
	#else
		PlayerUsedOffhand( ownerPlayer, weapon )
		SetCarePackageDeployed( true )
		ownerPlayer.Signal( "DeployableCarePackagePlacement" )
	#endif

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

#if SERVER
                                                                                                       
 
	             

	                                                                       
	                                                                                  

	                                                                           
	                                                                                                                     
	                                                                                                                  
	                                                                                                                

	                           
		                                                                                                                                                                            

	                                       
	 
		                           
		                                            
		 
			                                        
				        

			                                                                    
			                                                                                    
				                                            

		 

		                            
		                                                                   
		 
			                                                              

			                                                           
				        

			                          	                                 

			                                         
			 
				                                                       
				                      
				                                                                           
				                                      
				 
					                                                               
					                                    
				 

				                                                                                                                                
				                                   
				                           
				                                     

				                         
				 
					              
						                                             
						     
					           
						                                          
						     
					            
						                                           
						     
					        
						     
				 

				                                               
				 
					                                                                   
					                                                                  
					 
						                                       

						                          
							        

						                                       

						                                                                                                                             
							                                                                 
					 
				 

			 

		 

	 

	              

	                                                        
	                                                                            
	 
		                                           
			        

		                                                                                                                                                            

		                                                                                     
			                                           
	 

	                                                      
	                                                                         
	 
		              	    
		               	                                                                                                                                   

		                                                                              
		                              
		 
			                                                        
			                                       
				        

			                                        
				                    
			    
				                    

			                                                           

			                                                                                     
				                                     
		 
		    
		 
			                                    
			                                       
				        

			                                        
			 
				                       
				 
					                    
						                      
						     
					               
						                     
						     
					                 
						                        
						     
				 
			 

			                                                           

			                                                                                     
				                                         
		 
	 

	                        
	                                                             
	                                                                      
	                                                                    
	                                                                                     
 

                                                                                
 
	                                                                                                                                   
	                                      
	                                               
		                                                                                                 

	                          

	                       
	 
		                         
			                                           
			 
				                                                                         
					                                                           
				    
					                                                                                                  
			 
			    
			 
				                                                                     
			 
			     

		                                   
			                                               
			 
				                                                                                                      
				                                        
			 
			    
			 
				                                                                     
			 
			     

		                               
			                                                 
			 
				                                                                                                        
				                                       
			 
			    
			 
				                                                                     
			 
			     

		                                    
			                                        
			                                       
			     

		                                    
			                                  
			                                  
			                                  
			     

		                        
			                                                         
			     
	 

	                   
 

                                                              
 
	                                                                                                                   
	                      
	                     
	                                                                                               

	                             
	                             
	 
		                                                      
		                                            
		 
			                       
			                   
			     
		 
	 

	                        
		                    

	                                    
	                                                                                       
		                                                                                     
	                                                                                  

	                      
	                            
	 
		                                                      
		                                        
		 
			                
			                  
			     
		 
	 

	                 
		                  

	                        
	                         
	                        
	                          
	                                                         
 

                       
                                                                     
 
	                        
	                                       
	                                              
	                                               
	                                                         
 
      

                        
                                                                                    
 
	                        
	                              
	 
		                                                                                                                                
		                                                                                             
		                                                                                                                                
		                                                                                           
		                                                                               
		                                                                
		                                                                  
		                                                                    
	 
	    
	 
		                                                   
		                                                     
		                                                       
	 

	                                                         
 
      

#endif         
