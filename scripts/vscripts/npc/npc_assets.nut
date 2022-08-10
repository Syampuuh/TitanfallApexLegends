#if (CLIENT || SERVER)
global function SetNPCAsset
global function GetNPCAsset
#endif                      

global enum eNPC
{

                   
	PROWLER,
	DIRE_PROWLER,
      

                   
         
      

                   
	SPECTRE,
	DEATH_SPECTRE,
      

                           
                 
      

                   
         
                 
      

                    
          
           
      

                  
        
      

                         
	SPIDER_JUNGLE,
      

                         
               
      

                   
	MARVIN,
      

                      
             
           
      

                  
                   
          
            
        

                 
            

                 
      
             
          

             

                
              
                         

            
               

          
                  
                  
                 
                        

	_count
}


#if (CLIENT || SERVER)
global enum eNPCAsset
{
	BODY,
	WEAPON_0,
	WEAPON_1,

	WEAPON_OFFHAND,

	GIB_PIECE_0,
	GIB_PIECE_1,
	GIB_PIECE_2,
	GIB_PIECE_3,
	GIB_PIECE_4,

	_count
}

asset[eNPCAsset._count][eNPC._count] s_npcAssetMap

void function SetNPCAsset( int npcType, int npcAssetType, asset theAsset )
{
	Assert( (s_npcAssetMap[npcType][npcAssetType] == $""), format( "Asset type '%s' for npc type '%s' has already been registered with: '%s'", "xxxx", "yyyy", string( s_npcAssetMap[npcType][npcAssetType] ) ) )
	s_npcAssetMap[npcType][npcAssetType] = theAsset
}

asset function GetNPCAsset( int npcType, int npcAssetType )
{
	asset result = s_npcAssetMap[npcType][npcAssetType]
	Assert( (result != $""), format( "Asset type '%s' for npc type '%s' has not been registered.", "xxxx", "yyyy" ) )
	return result
}

#endif                      





