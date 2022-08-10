#if SERVER || CLIENT
global function AbilityCosmetics_Apply
#endif

                       
                       
                       
                       
                       


                        
                        
                        
                        
                        


                        
                        
                   
                        
                        

#if SERVER || CLIENT
void function AbilityCosmetics_Apply( entity ability, string skinName, int camoIndex )
{
	if ( IsValid( ability ) )
	{
		int skinIndex = ability.GetSkinIndexByName( skinName )
		if ( skinIndex == -1 )
		{
			skinIndex = 0
			camoIndex = 0
		}

		if ( camoIndex >= CAMO_SKIN_COUNT )
		{
			Assert ( false, "Tried to set camoIndex of " + string(camoIndex) + " but the maximum index is " + string(CAMO_SKIN_COUNT) )
			camoIndex = 0
		}

		ability.SetSkin( skinIndex )
		ability.SetCamo( camoIndex )
	}
}
#endif