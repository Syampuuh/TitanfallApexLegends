global function Caustic_TT_Init
global function Caustic_TT_RegisterNetworking
global function IsCausticTTEnabled
global function GetCausticTTCanisterFrameForLoot
global function AreCausticTTCanistersClosed
global function CausticTT_SetGasFunctionInvertedValue

#if SERVER
                                                    
#endif          

#if CLIENT
global function Caustic_TT_ServerCallback_SetCanistersOpen
global function Caustic_TT_ServerCallback_SetCanistersClosed
global function Caustic_TT_ServerCallback_ToxicWaterEmitterOn
global function Caustic_TT_ServerCallback_ToxicWaterEmitterOff

const string CAUSTIC_TT_TOXIC_WATER_AUDIO_EMIT = "caustic_tt_floor_ambient_generic"
const string CAUSTIC_TT_TURBINE_SCRIPTNAME = "caustic_tt_turbine"
#endif          

const string CAUSTIC_TT_SWITCH_SCRIPTNAME = "caustic_tt_switch"
const string CAUSTIC_TT_CANISTER_FRAME_SCRIPTNAME = "caustic_tt_canister_frame"

const float CANISTER_TIMER_START = 15.0
const float CANISTER_TIMER_END = 10.0

const int CANISTER_DISTANCE_FRAME_TO_LOOT_SQR = 4900

#if SERVER
                                                                               
                                                                                     
                                                                                   
                                                                  
                                                                      
                                                                        
                                                                  
                                                                                     
                                                                       
                                                                          

                                                                            
                                                                            
                                                                                   
                                                                                 
                                                                              
                                                                                 
                                                         

                                                                                 
                                                                          
                                                                            

                        
                                                                                                 
                                                                                                 
                              

                                                           
                                                            
                                                       
                                                     

                                                                
                                                                  

                                                                
                                                                      
                                                                  

                      
                                                        
                                                         

                         
                              
                            
#endif          

#if SERVER
                       
 
	       	             
	       	             
	       	       
	       	           
	       	       
	       	                    
	   		                 
	       	                        
 

                     
 
	                 
	                      
	                                 
	                            
 
#endif          

struct
{
	bool 				canistersClosed
	array < entity >	canisterFrames
	array < entity >	canisterSwitches
	array < entity >	windowHighlights
	array < string >	canisterLootRefs

	bool isGasFunctionInverted = false

	#if CLIENT
		array < entity >	toxicWaterEmitters
	#endif

	#if SERVER
		      							                
		       							                      
		      							            
		                 				               
		                				              
		                				                
		                                  	                   
		                				              

		                                       
	#endif          
}file

void function Caustic_TT_Init()
{
	if (!GetCurrentPlaylistVarBool( "caustic_tt_enabled", true ))
		return

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	#if CLIENT
		AddCreateCallback( "prop_dynamic", CausticCanisterSwitchSpawned )
	#endif
	#if SERVER
		                                                
		                                                   
		                                                             
	#endif          
}

void function Caustic_TT_RegisterNetworking()
{
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_SetCanistersOpen" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_SetCanistersClosed" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_ToxicWaterEmitterOn" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_ToxicWaterEmitterOff" )
}


void function CausticCanisterSwitchSpawned( entity panel )
{
	if( panel.GetScriptName() != CAUSTIC_TT_SWITCH_SCRIPTNAME )
		return

	                                                                                                          
	                                                        
	Caustic_TT_SetButtonUsable( panel )
}

void function Caustic_TT_SetButtonUsable( entity canisterSwitch )
{
	#if SERVER
		                            
		                                                  
		                          
		                                                                                                             
		                                                          
		                           
	#endif          

	#if CLIENT
		                                                                                  
		                                                                                                  
		                                                                             
		                                                               
		if( canisterSwitch.e.canUseEntityCallback != null )
			return
	#endif          

	SetCallback_CanUseEntityCallback( canisterSwitch, CanisterSwitch_CanUse )
	AddCallback_OnUseEntity_ClientServer( canisterSwitch, CanisterSwitch_OnUse )

	#if CLIENT
		AddEntityCallback_GetUseEntOverrideText( canisterSwitch, GetCanisterSwitchUseTextOverride )
	#endif          
}

void function EntitiesDidLoad()
{
	if ( !IsCausticTTEnabled() )
		return

	#if SERVER
		                        

		                                                                                                        
		 
			                            
			                                               
		 

		                                                                       
		                                                                                                                         
		                        
	#endif          

	#if CLIENT
		                                                                                                      
		foreach ( entity emitter in GetEntArrayByScriptName( CAUSTIC_TT_TOXIC_WATER_AUDIO_EMIT ) )
			file.toxicWaterEmitters.append( emitter )

		                           
		foreach ( entity turbine in GetEntArrayByScriptName( CAUSTIC_TT_TURBINE_SCRIPTNAME ) )
		{
			entity turbineRotator = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", turbine.GetOrigin(), turbine.GetAngles() )
			turbine.SetParent( turbineRotator )
			turbineRotator.NonPhysicsRotate( < 0, 0, 1 >, 60 )
		}
	#endif          

	file.canistersClosed = true

	foreach ( entity canisterSwitch in GetEntArrayByScriptName( CAUSTIC_TT_SWITCH_SCRIPTNAME ) )
	{
		Caustic_TT_SetButtonUsable( canisterSwitch )
		file.canisterSwitches.append( canisterSwitch )
	}

	                                                                                              
	foreach ( entity canisterFrame in GetEntArrayByScriptName( CAUSTIC_TT_CANISTER_FRAME_SCRIPTNAME ) )
		file.canisterFrames.append( canisterFrame )

	#if SERVER
		                                                                                                   
		 
			                     

			                                  
			                                    
			                                                       
			                                                             
			                                                              

			                                                         
			                                                                        
			                                    
			                                                                
			                                                           
			                                 

			                                                                       
			 
				                                                

				                                                  
				 
					                                 
					                                                  
				 
				                                                    
				 
					                                   

					                                                 
					                                               
					                                            
				 
				                                                       
				 
					                           
					                                  
					                                                          
					                                                                 
					                                                                 
				 
			 

			                                            
			                          

			                                      
			                                          

			                                                                                    
			                                                              
			                                               
			                                                                 
			                                                                                      
			                                                                                       
			                                                                                       
			                                                               
			                                                                       
			                                                     
			                                                        
			                                                          
			                                          

			                                                
		 

		                        
		                                                                                         
		                                                                            
		                                                                              
		 
			                                                  
			 
				                                   
				                                                           
			 
			                                                         
			 
				                                              
				                                                                      
			 
		 

		                               

		                                                                                      
		                                                               
		                                                                                          
		 
			                                                              
			                                                                 
			                                  
			                                                              
			                                                         
			                                                 

			                               

			                                             
			                             
		 

		                                                                                        
		 
			                                                             
			                                                                   
			                                 
			                                                             
			                                                       
			                                                       

			                              

			                                           
		 
		                                     
	#endif          

	if ( file.isGasFunctionInverted )
		thread CanisterSwitch_TrapActivate_Thread( null, true )                                                                  
}

bool function CanisterSwitch_CanUse ( entity player, entity canisterSwitch, int useFlags )
{
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, canisterSwitch ) )
		return false

	return true
}

#if CLIENT
string function GetCanisterSwitchUseTextOverride( entity canisterSwitch )
{
	if ( file.canistersClosed )
	{
		if ( !file.isGasFunctionInverted )
			return "#CAUSTIC_TT_SWITCH_ON"
		else
			return "#CAUSTIC_TT_SWITCH_ON_INVERTED"
	}

	return ""
}
#endif          

void function CanisterSwitch_OnUse( entity canisterSwitch, entity player, int useInputFlags )
{
	if ( file.canistersClosed )
	{
		if ( useInputFlags & USE_INPUT_LONG )
			thread CanisterSwitch_UseThink_Thread( canisterSwitch, player )
	}
	else
	{
		#if SERVER
			                                                                                        
		#endif          
	}
}

void function CanisterSwitch_UseThink_Thread( entity ent, entity playerUser )
{
	ent.EndSignal( "OnDestroy" )

	ExtendedUseSettings settings
	settings.loopSound = "survival_titan_linking_loop"
	settings.successSound = "ui_menu_store_purchase_success"
	settings.duration = 1.0
	settings.successFunc = CanisterSwitch_ExtendedUseSuccess

	#if CLIENT || UI
		settings.icon = $""
		settings.hint = !file.isGasFunctionInverted ? Localize ( "#CAUSTIC_TT_ACTIVATE" ) : Localize ( "#CAUSTIC_TT_ACTIVATE_INVERTED" )
		settings.displayRui = $"ui/extended_use_hint.rpak"
		settings.displayRuiFunc = CanisterSwitch_DisplayRui
	#endif                

	waitthread ExtendedUse( ent, playerUser, settings )
}

void function CanisterSwitch_DisplayRui( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	#if CLIENT || UI
		RuiSetString( rui, "holdButtonHint", settings.holdHint )
		RuiSetString( rui, "hintText", settings.hint )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetGameTime( rui, "endTime", Time() + settings.duration )
	#endif                
}

void function CanisterSwitch_ExtendedUseSuccess( entity canisterSwitch, entity player, ExtendedUseSettings settings )
{
		if ( !file.canistersClosed )
			return

		if ( !IsValid( player ) )
			return

		if ( !IsValid( canisterSwitch ) )
			return

		CanisterSwitches_Disabled()

	if ( !file.isGasFunctionInverted )
		thread CanisterSwitch_TrapActivate_Thread( player )
	else
		thread CanisterSwitch_TrapActivate_Inverted_Thread( player )
}

void function CanisterSwitch_TrapActivate_Thread( entity player, bool isInvertedSetup = false )
{
	#if SERVER
		                                                                                               
		                                                                                                                                                    
		                                                                

		                                                                                                

		                                                                                                                                                                                          

		                                                       
			                            

		                       
		 
			                                                    
				                            

			                                                   
			 
				                         
				 
					                                                           

					                                                                                                                                                          
					                                                                                                    
				 
			 
		 
	#endif          

	wait 2.0

	#if SERVER
		                                        

		                                                          
			                                                                                              

		                       
			                                                                                                   
	#endif          

	if ( isInvertedSetup )
		return

	wait 7.5

	#if SERVER
		                                
			                                                                      
	#endif          

	wait 7.5                       

	#if SERVER
		                                                                                               
	#endif          

	wait CANISTER_TIMER_END

	thread CanisterSwitch_TrapExpired_Thread()
}

void function CanisterSwitch_TrapExpired_Thread()
{
	#if SERVER
		                                                                                                                                                     
		                                                                 

		                                                    
			                            

		                                                         
			                            

		                                                                                                                

		                                                                                                                                                 

		                                                       
			                           

		                                                   
		 
			                         
			 
				                                                           

				                                  
				 
					                              
						                                           

					                                                    
					                                                                                                                      
					                                                                                                   
				 
			 
		 

		                                                          
			                                                                                             

		                                       
	#endif          

	wait 2.0

	#if SERVER
		                                                                                                 
	#endif          

	wait 5.0

	#if SERVER
		                                                         
			                             
	#endif          

	wait 3.0

	CanisterSwitches_Enabled()
}

const float CAUSTIC_TT_INVERTED_WAIT_TO_DRAIN = 20.0
const float CAUSTIC_TT_INVERTED_WAIT_TO_DRAIN_EXTENDED = 25.0
void function CanisterSwitch_TrapActivate_Inverted_Thread( entity player )
{
	bool useDefaultSFX = true

                         
		if ( Control_IsModeEnabled() )
			useDefaultSFX = false
                               

	#if SERVER

		                    
		 
			                                                                                               
			                                                                                                                                                    
			                                                                
		 
                          
		    
		 
			                                                                                                            
			                                                                                                                                                    
			                                                                             
		 
                                

		                                                    
			                            

		                                                         
			                            

		                                                                                                                

		                                                                                                                                                 

		                                                       
			                           

		                                                   
		 
			                         
			 
				                                                           

				                                                                                                                                                          
				                                                                                                    
			 
		 

		                                                          
			                                                                                             

		                                       
	#endif          

	wait 7.0

	#if SERVER
		                                                         
			                             
	#endif          

	                                 
	if ( useDefaultSFX )
	{
		wait CAUSTIC_TT_INVERTED_WAIT_TO_DRAIN
	}
	else
	{
		wait CAUSTIC_TT_INVERTED_WAIT_TO_DRAIN_EXTENDED
	}

	thread CanisterSwitch_TrapExpired_Inverted_Thread()
}

void function CanisterSwitch_TrapExpired_Inverted_Thread()
{
	#if SERVER
		                                                                                                                                                     
		                                                                 

		                                                    
			                            

		                                                                                                

		                                                                                                                                                                                          

		                                                       
			                            

		                                                   
		 
			                         
			 
				                                                           

				                                  
				 
					                              
						                                           

					                                                                                                                      
					                                                                                                   
				 
			 
		 
	#endif          

	wait 2.0

	#if SERVER
		                                        

		                                                          
			                                                                                              
	#endif          

	wait 5.0

	#if SERVER
		                                                         
			                             
	#endif          

	wait 3.0

	                                        
	wait 30.0

	CanisterSwitches_Enabled()
}

void function CanisterSwitches_Disabled()
{
	#if SERVER
		                                                   
		 
			                           

			                                                          
				                                                                                          
		 
		                                    
	#endif          

	file.canistersClosed = false
}

void function CanisterSwitches_Enabled()
{
	#if SERVER
		                                                    
		                                
		                                                   
		 
			                         
			 
				                          
			 
		 

		                                                                                                                          
		 
			                                                   
			 
				                           

				                                                          
					                                                                                            
			 
		 
		                                                                       
		 
			                                                   
			 
				                           
				                            
			 

		 
	#endif          

	file.canistersClosed = true
}

#if SERVER
                                                                            
 
	                          
		      

	                                    

	                         
	 
		                                                           

		                                                       
			                         
	 

 

                                                                            
 
	                          
		      

	                                                              
	                       
		      

	                                    

	                         
	 
		                                                           

		                                                       
		 
			                                                                                                      

			                         
		 
	 
 

                                                 
 
                         
		                              
		 
			                                                                                             
			                                                                                               
		 
		    
                               
		 
			                                                                        
			                                                                                  
			                                                                          
		 

	                            
 

                                                         
 
	                                       
	 
		              
		                                             
		                                             

		                                                  

		                                                                 
		                                                                    

		                                 
			                                       
		                                           
			                                      
		                                        
			                                      

		                                                             

		                                              

		              
	 

	           
 

                                                           
 
	                                    

	                                                
	 
		                                       
		                                       

		                                                                                                                   
			             
		                                               
			                             
		                                                                          
			                                      
		                                                        
		 
			                                 
			                           
			 
				                                         

				                             
				 
					                                   
						                                                        

					                                                    
					                                                 
				 
			 
		 
	 
 

                                                                                                 
 
	                            
		      

	                                                  
		      

	                                                          

	                                
	                                                                                                                    

	                                                                                           
	                                      
	                                                   
	 
		                                 
			      

		                                        

		                                                        
		                                                                
		                                                                   
	 

	                        
		                                            

	           

	                        
	 
		                                         

		                                                     
		                                    
		                                         
		                                      
		                                      
		                                               
		                                                                          
		                                      
		                                                        
		                                                                
		                                                                   
		                                                                                                                                                                                                                    
	 

	                                                 

	            
		                            
		 
			                          

			                                                    
				                            

			                                                                               
		 
	 

	        
	                        
	                                   
	 
		                                                                                                

		                           

		                                                    
			                            

		        
	 
 

                                                           
 
	                                                
	 
		                                                    
	 
 

                                                                              
 
	                                                                   
		      

	                                           
	                                                        

	              
	 
		                
		                                            
		  
		       
			                                                                                                                                                                                                                         
		      
		  
		                                          
			                                   
	 
	    
	 
		                  
		                                            
		  
		       
			                                                                                                                                                                                                                       
		      
		  
		                                          
			                                  
	 
 
#endif          

#if CLIENT
void function Caustic_TT_ServerCallback_SetCanistersOpen()
{
	file.canistersClosed = false
}

void function Caustic_TT_ServerCallback_SetCanistersClosed()
{
	file.canistersClosed = true
}

void function Caustic_TT_ServerCallback_ToxicWaterEmitterOff()
{
	foreach ( entity emitter in file.toxicWaterEmitters )
	{
		emitter.SetEnabled( false )
	}
}

void function Caustic_TT_ServerCallback_ToxicWaterEmitterOn()
{
	foreach ( entity emitter in file.toxicWaterEmitters )
	{
		emitter.SetEnabled( true )
	}
}
#endif

entity function GetCausticTTCanisterFrameForLoot( entity lootEnt )
{
	foreach ( canisterFrame in file.canisterFrames )
	{
		if ( IsValid( canisterFrame ) )                                                                                                                            
			if ( DistanceSqr( canisterFrame.GetOrigin(), lootEnt.GetOrigin() ) < CANISTER_DISTANCE_FRAME_TO_LOOT_SQR )
				return canisterFrame
	}

	return null
}

bool function AreCausticTTCanistersClosed( entity canisterPanel )
{
	return file.canistersClosed
}

#if SERVER
                                              
 
	                               
		            

	                                                                                        
	                                                                            

	                                          
		            

	           
 
#endif

bool function IsCausticTTEnabled()
{
	bool causticTTSwitchExists = true
	array<entity> causticTTSwitches = GetEntArrayByScriptName( CAUSTIC_TT_SWITCH_SCRIPTNAME )
	if ( causticTTSwitches.len() == 0 )
		causticTTSwitchExists = false

	return causticTTSwitchExists
}


bool function CausticTT_IsGasFunctionInverted()
{
	return file.isGasFunctionInverted
}

void function CausticTT_SetGasFunctionInvertedValue( bool val )
{
	Assert( !Flag( "EntitiesDidLoad" ), "Caustic TT: Trying to set inverted gas function after initialization has been completed" )

	file.isGasFunctionInverted = val
}

#if SERVER
                                                                                                                                               
                                                                                                                                                                          
                                                                                                                                    
                                                           
 
	                         
		      

	                                           
		      

	                                       
	 
		                                                                                        
	 
	    
	 
		                                                                                         
	 
 
#endif