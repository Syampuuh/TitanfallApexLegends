#if SERVER
                                       
#endif


#if CLIENT
global function ClOlympusStoryEvents_Init
#endif

struct
{

} file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if SERVER
                                       
 
	                                              
 
#endif


#if CLIENT
void function ClOlympusStoryEvents_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}
#endif


#if SERVER || CLIENT
void function EntitiesDidLoad()
{

}
#endif                    