#if SERVER
                                           
#endif

#if CLIENT
global function ClCanyonlandsStoryEvents_Init
#endif


struct
{

} file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if SERVER
                                           
 
	                                              
 
#endif


#if CLIENT
void function ClCanyonlandsStoryEvents_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}
#endif


#if SERVER || CLIENT
void function EntitiesDidLoad()
{

}
#endif                    
