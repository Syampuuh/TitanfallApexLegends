global function ShTreasureExtractionInit

const string TREASURE_BUTTON_MODEL_SCRIPTNAME = "genericTreasureExtractButton"
const string TREASURE_BOX_SCRIPTNAME = "treasureBoxForQuests"
const float TREASURE_EXTRACT_USE_TIME = 6.0
const float TREASURE_EXTRACT_USE_TIME_SOLO = 3.5
const float MINI_HARVESTER_DEPLOY_TIME = 1.6

#if SERVER
	                                   
	                                    
	                                             
	                                        
	                                                
	                                                          
	                                                       
	                                                        
	                                               
	                                 

                               
 
	                
	                        
	                          
	                              
	             
	             
 

                                    
 
	             
	             
	                   
	                    
	                           
	                        
	                                
	                     
	                       
	                                                                              
	                                                                                 
	                                                                               
	                                                                                      
	                                
 
#endif         

        
void function ShTreasureExtractionInit()
{
	RegisterSignal( "TreasureButtonReprogram_Success" )
	#if SERVER
		                                                 
		                                                                                            
	#endif         

	#if CLIENT
		AddCreateCallback( "prop_dynamic", OnTreasureUsableButtonSpawn )
		AddCreateCallback( "prop_dynamic", Client_OnTreasureBoxCreated )
	#endif         
}
            


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
void function Client_OnTreasureBoxCreated( entity treasureBox )
{
	if ( treasureBox.GetScriptName() != TREASURE_BOX_SCRIPTNAME )
		return

	AddCallback_OnUseEntity_ClientServer( treasureBox, OnUseTreasureBox )
}
#endif         

#if CLIENT
void function OnUseTreasureBox( entity vehicle, entity player, int pickupFlags )
{
	                                                                                                    
	                                      
	Minimap_DeathFieldDisableDraw()
}
#endif         


        
void function OnTreasureUsableButtonSpawn( entity panel )
{
	if ( panel.GetScriptName() != TREASURE_BUTTON_MODEL_SCRIPTNAME )
		return

#if SERVER
	                     
	                                           
	                 
	                                                                                                    
	                                                                                          
	                                               
	                                                                                                       
	                     
	                  
	                       
	                      
#elseif CLIENT
	AddEntityCallback_GetUseEntOverrideText( panel, ExtendedUseTextOverride )
	thread ShowGhostedModelWhenClose( panel )
#endif

	AddCallback_OnUseEntity_ClientServer( panel, OnTreasureButtonUse )
}
            

#if CLIENT
void function ShowGhostedModelWhenClose( entity panel )
{
	float distToShow = 300
	float distToShowSq = distToShow * distToShow

	                                                    
	                                                       
	                                                    
	vector origin = panel.GetOrigin()
	vector angles = panel.GetAngles()
	entity ghostedDrillModel = CreateClientSidePropDynamic( origin, angles, GetObjectiveAsset_Model( "TREASUREEXTRACT_MODEL_DRILL_BASE" ) )
	entity ghostedDrillBox = CreateClientSidePropDynamic( origin, angles, GetObjectiveAsset_Model( "TREASUREEXTRACT_MODEL_TREASURE_CASE" ) )
	ghostedDrillBox.SetParent( ghostedDrillModel, "BOX_POINT", false, 0.0 )
	array<entity> ghostedDrillParts
	ghostedDrillParts.append( ghostedDrillModel )
	ghostedDrillParts.append( ghostedDrillBox )
	foreach( model in ghostedDrillParts )
	{
		model.EnableRenderAlways()
		model.kv.rendermode = 3
		model.kv.renderamt = 0
		model.kv.fadedist = distToShow
		DeployableModelHighlight( model )
	}

	                                                      
	ghostedDrillModel.EndSignal( "OnDestroy" )
	panel.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( ghostedDrillParts )
		{
			foreach( model in ghostedDrillParts )
			{
				if ( IsValid( model ) )
				{
					model.ClearParent()
					model.Destroy()
				}
			}
		}
	)

	while ( IsValid( panel ) )
	{
		wait 0.25
		entity player = GetLocalClientPlayer()
		if ( !IsValid( player ) )
			continue

		if ( DistanceSqr( player.GetOrigin(), origin ) > distToShowSq )
		{
			foreach( model in ghostedDrillParts )
			{
				model.kv.renderamt = 0
			}
		}
		else
		{
			foreach( model in ghostedDrillParts )
			{
				model.kv.renderamt = 1
			}
		}

	}

}
#endif         

        
void function OnTreasureButtonUse( entity panel, entity player, int useInputFlags )
{
	if ( useInputFlags & USE_INPUT_LONG )
	{
		thread TreasureButtonUseThink( panel, player )
	}
}
            

        
void function TreasureButtonUseThink( entity ent, entity playerUser )
{

	ExtendedUseSettings settings
	#if CLIENT
		settings.loopSound = "SQ_Item_Use_Loop"
		settings.successSound = "SQ_Item_Use_Complete"
		settings.displayRui = $"ui/extended_use_hint.rpak"
		settings.displayRuiFunc = DefaultExtendedUseRui
		settings.icon = $""
		settings.hint = "#FREELANCE_DEPLOYING_DRILL"
	#elseif SERVER
		                            
		                             
		                               
	#endif

	settings.successFunc = OnTreasureButtonUseSuccess
	settings.duration = TREASURE_EXTRACT_USE_TIME
	if ( GetPlayerArray().len() == 1 )
		settings.duration = TREASURE_EXTRACT_USE_TIME_SOLO
	settings.requireMatchingUseEnt = false
	settings.useInputFlag = IN_USE_LONG
	ent.EndSignal( "OnDestroy" )

	waitthread ExtendedUse( ent, playerUser, settings )

}
            

        
void function OnTreasureButtonUseSuccess( entity panel, entity player, ExtendedUseSettings settings )
{
	#if SERVER
		                                                 
		               
	#endif         
}
            




#if SERVER
                                                                              
 
	                                   

	                       			               
	                      			              
	                      			             

	                                                                                                                                                
	                                                
	                                                                             
	                                                                                                     
	                                                    
	                                                                       
	                                                 

	                                                                    
	                                                                

	                                 
	                                 

	                                              

	                        
 
#endif         

#if SERVER
                                                                                  
 
	                                                                     
 
#endif         

#if SERVER
                                                                       
 
	                                        
	                                        

	                                                                                                                    

	                               

	                                                                                                                    

	                                         
	                                                           
		                                                            

	                                                              
	                                                        

	                       
	                                                                                                                                                               
	                                            
	                                     
	                                                         


	                                                    
	                                                                        

	                                              

	            
		                                  
		 
			                                                           
				                                                            

			                                               
			 
				                    
				 
					                
					                
				 
			 
			                                                                                  
			                                                              
			                                                                 
			                                                                                                                                                                            
		 
	 

	             
	 
		                                              
		         
	 
 
#endif         


#if SERVER
                                                                     
 
	                                    
	                                         
	 
		                                                                  
		                                                        
	 
	                                           
	 
		                    
			            
	 
	                                                 
		                                         
 
#endif         
