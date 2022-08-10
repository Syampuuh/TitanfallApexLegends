global function ShPlayerPet_Init
global function PlayerPetsEnabled

#if SERVER
	                                                 
	                                                               
	                                                      
#endif

struct
{
	int 			petType

	#if SERVER
		                                                                         
		                                                                              
		             	          
		   				             
		             	          
		    			             
		   				            
		      			                   
		    			                             

	#endif             
} file

#if SERVER || CLIENT
void function ShPlayerPet_Init()
{
	if ( !PlayerPetsEnabled() )
		return

	string petType = GetCurrentPlaylistVarString( "squad_pet_type", "shadow_prowler" )
	switch( petType )
	{
		case "shadow_prowler":
			file.petType = eNPC.DIRE_PROWLER
			#if CLIENT
				AddCreateCallback( "npc_prowler", OnPetCreatedClient )
			#endif
			break
		case "prowler":
			file.petType = eNPC.PROWLER
			#if CLIENT
				AddCreateCallback( "npc_prowler", OnPetCreatedClient )
			#endif
			break
		default:
			Assert( 0, "Unhandled playlist var 'squad_pet_type': " + petType )
	}

	#if SERVER
		                             
		                                                    

		                                            
		                                                 
		                                                          
		                                                        
		                                                             
		                                                                       
		                                                                     
		                                                                                  
		                                                                                
		                                                                                              
		                                                                                                
	#endif

}
#endif                   

#if SERVER || CLIENT
bool function PlayerPetsEnabled()
{
	return GetCurrentPlaylistVarBool( "squad_pets_enabled", false )
}
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

#if SERVER
                                          
 
	                                 
	                        
		      

	                     
	                             

	                    
		                                    

	                                             
		                            

	    
		                                    

 
#endif         


#if SERVER
                                                 
 
	                          
 
#endif         


#if SERVER
                                         
 
	                       
 
#endif         


#if SERVER
                                                                
 
	                      
		      

	                        
		      

	                                                                              
	                                                                                                        

	                                   
	                                                                                                         

	                                       
	                                                                                                 

	                           				                                             

	                                                                       
	 
		                
	 

	                                                                              
	 
		                         
	 

	                                                                                                         

	                                  
	                          
	                        
	                 
 
#endif         

#if CLIENT
void function OnPetCreatedClient( entity pet )
{
	thread function() : ( pet )
	{
		if ( !IsValid( pet ) )
			return

		pet.EndSignal( "OnDeath" )
		entity petOwner = pet.GetBossPlayer()
		float timeOutFrames
		while( !IsValid( petOwner ) || timeOutFrames > 1000 )
		{
			WaitFrame()
			if ( !IsAlive( pet ) )
				return
			petOwner = pet.GetBossPlayer()
		}

		vector infoColor
		if ( IsValid( petOwner ) )
			infoColor = GetPlayerInfoColor( petOwner )
		else
			infoColor = <255, 255, 255>

		SetCustomPlayerInfoColor( pet, infoColor )

	}()

}
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



#if SERVER && DEV
                                                        
 
	                      
		      

	                        
		      

	                          
	                            

	             
	 
		                                                                                        
		                                                              
		         
	 

 
#endif         


