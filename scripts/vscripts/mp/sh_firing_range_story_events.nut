#if SERVER || CLIENT
global function ShFiringRangeStoryEvents_Init
#endif

struct RealmStoryData
{
}

struct
{
	table< int,  RealmStoryData > realmStoryDataByRealmTable
} file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    

#if SERVER || CLIENT
void function ShFiringRangeStoryEvents_Init()
{
	if ( GetMapName() != "mp_rr_canyonlands_staging" )                                                  
		return

	if ( !IsFiringRangeGameMode() )
		return

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}
#endif

#if SERVER || CLIENT
void function EntitiesDidLoad()
{

}
#endif                    


