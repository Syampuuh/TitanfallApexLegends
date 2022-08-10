global function DesertlandsStoryEvents_Init

#if SERVER
                            	                            
                                                                 
                                                               
#endif

#if CLIENT
const int S10E04_CHALLENGE_ID_MAX = 2
const int S10E04_VARIANCE_MAX = 4
const string S10E04_PRINTS_SCRIPTNAME_TEMPLATE = "s10e04_challengemark_%d_%d"
#endif

struct
{
	entity beamFX

} file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


void function DesertlandsStoryEvents_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	#if SERVER
		                                         
		                                             
	#endif
}

void function EntitiesDidLoad()
{
	#if SERVER
	                                                                                         
		                  
	#endif

	if ( GetMapName() == "mp_rr_desertlands_mu3" )
	{
		#if CLIENT
		HideStoryEventTrails()
		#endif
	}

}

#if SERVER
                                
 
	                               
	                                                                                                                                  
	                                                                                                                                                                      
	                                 
 
#endif

#if CLIENT
void function HideStoryEventTrails()
{
	for ( int i = 0 ; i <= S10E04_CHALLENGE_ID_MAX; i++ )
	{
		for ( int j = 0; j <= S10E04_VARIANCE_MAX; j++ )
		{
			string scriptName = format( S10E04_PRINTS_SCRIPTNAME_TEMPLATE, i, j )
			array< entity > printsArray = GetEntArrayByScriptName(scriptName)
			foreach ( print in printsArray )
			{
				print.Hide()
			}
		}
	}
}
#endif