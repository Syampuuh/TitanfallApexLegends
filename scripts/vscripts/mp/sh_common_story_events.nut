#if SERVER
                                      
#endif

#if CLIENT
global function ClCommonStoryEvents_Init
#endif

struct
{

} file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if SERVER
                                      
 
	                                              
 
#endif


#if CLIENT
void function ClCommonStoryEvents_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}
#endif

#if SERVER || CLIENT
void function EntitiesDidLoad()
{

}
#endif                    