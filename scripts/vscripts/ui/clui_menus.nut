global function GetCharacterButtonRows
global function GetCharacterButtonRowSizes
global function LayoutCharacterButtons
global function SetNavUpDown
global function SetNavLeftRight
#if UI
global function LocalizeAndShortenNumber_Float
#endif
global function IsTenThousandOrMore


struct RowData
{
	int xPos
	int yPos
	bool hasLeadingSpace
}


array< array<var> > function GetCharacterButtonRows( array<var> buttons )
{
	array<int> rowSizes = GetCharacterButtonRowSizes( buttons.len() )
	array< array<var> > buttonRows

	int buttonIndex = 0
	foreach ( rowSize in rowSizes )
	{
		array<var> row
		int last = buttonIndex + rowSize

		while ( buttonIndex < last )
		{
			row.append( buttons[buttonIndex] )
			buttonIndex++
		}

		buttonRows.append( row )
	}

	                               
	   
	  	                                
	  		                                                                                           
	   

	return buttonRows
}


array<int> function GetCharacterButtonRowSizes( int numButtons )
{
	Assert( numButtons > 0 )

	int numRows = 1
	if ( numButtons > 18 )
		numRows = 4
	else if ( numButtons > 10 )
		numRows = 3
	else if ( numButtons > 5 )
		numRows = 2

#if NX_PROG || PC_PROG_NX_UI
	if( IsNxHandheldMode() && numButtons > 18 )
	{
		numRows = 3
	}
#endif
	int fullRowSize  = int( ceil( numButtons / float( numRows ) ) )
	int shortRowSize = fullRowSize - 1
	int remainingSlots = numButtons
	int numShortRows = 0

	while ( remainingSlots % fullRowSize )
	{
		numShortRows++
		remainingSlots -= shortRowSize
	}

	Assert( remainingSlots % fullRowSize == 0 )
	int numFullRows = remainingSlots / fullRowSize

	                            
	                                     
	                               
	                                       
	                                         
	                                       
	                                         

	array<int> rowSizes
	bool prepend = false

	for ( int i = 0; i < numFullRows; i++ )
		rowSizes.append( fullRowSize )

	for ( int i = 0; i < numShortRows; i++ )
	{
		if ( i > 0 )
			prepend = !prepend

		if ( prepend )
			rowSizes.insert( 0, shortRowSize )
		else
			rowSizes.append( shortRowSize )
	}

	                                  
	  	                          

	return rowSizes
}


                                       
void function LayoutCharacterButtons( array< array<var> > buttonRows )
{
	Assert( buttonRows.len() && buttonRows[0].len() )
	int buttonWidth        = Hud_GetWidth( buttonRows[0][0] )
	int buttonHeight       = Hud_GetHeight( buttonRows[0][0] )
	                                                          
	                                       

	                                                                                          
	                                                                                         
	                                       
	                                   

	int spaceShift         = int( buttonWidth * 0.6237113402061856 )
	int rowShift           = int( buttonWidth * 0.2061855670103093 )
	                                     
	                                 

	array<RowData> rowData
	foreach ( row in buttonRows )
	{
		RowData data
		rowData.append( data )
	}

	foreach ( rIndex, row in buttonRows )
	{
		foreach ( bIndex, button in row )
		{
			                                                  
			if ( bIndex == 0 )
			{
				                                                                           
				rowData[rIndex].yPos = buttonHeight * -1 * rIndex
			}
			else
			{
				Hud_SetPinSibling( button, Hud_GetHudName( row[bIndex - 1] ) )
				Hud_SetX( button, (spaceShift * -1) )
				Hud_SetY( button, 0 )
			}
		}
	}

	array<int> rowSizes
	foreach ( row in buttonRows )
		rowSizes.append( row.len() )

	int baseRowIndex = int( floor( (rowSizes.len() - 1) / 2.0 ) )
	array<var> baseRow = buttonRows[baseRowIndex]

	                                                                                             
	int baseRowScreenWidth = buttonWidth + ((baseRow.len() - 1) * spaceShift)
	int baseRowXPos = baseRowScreenWidth / 2

	foreach ( rIndex, row in buttonRows )
	{
		bool hasLeadingSpace = rIndex > baseRowIndex && row.len() < baseRow.len()

		rowData[rIndex].hasLeadingSpace = hasLeadingSpace
		rowData[rIndex].xPos = baseRowXPos + (rowShift * (rIndex - baseRowIndex)) + (hasLeadingSpace ? (spaceShift * -1) : 0 )

		foreach ( bIndex, button in row )
		{
			if ( bIndex == 0 )
			{
				Hud_SetPinSibling( button, "Anchor" )
				Hud_SetX( button, rowData[rIndex].xPos )
				Hud_SetY( button, rowData[rIndex].yPos )
			}
		}
	}

	foreach ( row in buttonRows )
		SetNavLeftRight( row )

	array< array<var> > buttonColumns
	int numColumns = baseRow.len()

	                                                                        
	for ( int cIndex = 0; cIndex < numColumns; cIndex++ )
	{
		array<var> column
		foreach ( rIndex, row in buttonRows )
		{
			int desiredIndex = rowData[rIndex].hasLeadingSpace ? cIndex - 1 : cIndex
			if ( desiredIndex >= 0 && desiredIndex < row.len())
				column.append( row[desiredIndex] )
		}

		buttonColumns.append( column )
	}

	foreach ( column in buttonColumns )
		SetNavUpDown( column )
}


void function SetNavUpDown( array<var> buttons )
{
	Assert( buttons.len() > 0 )

	var first = buttons[0]
	var last  = buttons[buttons.len() - 1]
	var prev
	var next
	var button

	for ( int i = 0; i < buttons.len(); i++ )
	{
		button = buttons[i]

		if ( button == first )
			prev = last
		else
			prev = buttons[i - 1]

		if ( button == last )
			next = first
		else
			next = buttons[i + 1]

		Hud_SetNavUp( button, prev )
		Hud_SetNavDown( button, next )

		                                                                                    
		                                                                                      
	}
}


void function SetNavLeftRight( array<var> buttons )
{
	Assert( buttons.len() > 0 )

	var first = buttons[0]
	var last  = buttons[buttons.len() - 1]
	var prev
	var next
	var button

	for ( int i = 0; i < buttons.len(); i++ )
	{
		button = buttons[i]

		if ( button == first )
			prev = last
		else
			prev = buttons[i - 1]

		if ( button == last )
			next = first
		else
			next = buttons[i + 1]

		Hud_SetNavLeft( button, prev )
		Hud_SetNavRight( button, next )

		                                                                                    
		                                                                                      
	}
}


                                                                              
#if UI
string function LocalizeAndShortenNumber_Float( float number, int maxDisplayIntegral = 3, int maxDisplayDecimal = 0 )
{
	printf( "ShortenNumberDebug: Shortening %f with max Integrals of %i and max decimals of %i", number, maxDisplayIntegral, maxDisplayDecimal )

	if ( number == 0.0 )
		return "0"

	string lang = GetLanguage()                                                     
	string thousandsSeparator = lang == "english" || lang == "korean" || lang == "schinese" || lang == "tchinese" || lang == "thai" || lang == "japanese" ? "," : "."                                                      
	string decimalSeparator = thousandsSeparator == "," ? "." : ","                                                    
	string integralString = ""
	string integralSuffix = ""

	float integral = floor( number )
	int digits = int( floor( log10( integral ) + 1 ) )

	if ( digits > maxDisplayIntegral )
	{
		printf( "ShortenNumberDebug: Number too large for display (%i digits). Shortening to 3 digits", digits )
		float displayIntegral = integral / pow( 10, (digits - 3) )
		displayIntegral = floor( displayIntegral )
		integralString = format( "%0.0f", displayIntegral )

		printf( "ShortenNumberDebug: Number shortened to %s", integralString )

		if ( digits/16 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_QUADRILLIONS" )
		else if ( digits/13 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_TRILLIONS" )
		else if ( digits/10 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_BILLIONS" )
		else if ( digits/7 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_MILLIONS" )
		else if ( digits/4 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_THOUSANDS" )
	}
	else
	{
		integralString = format( "%0.0f", integral )
	}

	if ( integralString.len() > 3 )
	{
		string separatedIntegralString = ""
		int integralsAdded = 0

		printf( "ShortenNumberDebug: Adding integral separators to %s", integralString )

		for ( int i = integralString.len(); i > 0; i-- )
		{
			string num = integralString.slice( i-1, i )
			if ( (separatedIntegralString.len() - integralsAdded) % 3 == 0 && separatedIntegralString.len() > 0 )
			{
				integralsAdded++
				separatedIntegralString = num + thousandsSeparator + separatedIntegralString
			}
			else
			{
				separatedIntegralString = num + separatedIntegralString
			}

			printf( "ShortenNumberDebug: Separated Integral Progress: %s", separatedIntegralString )
		}

		printf( "ShortenNumberDebug: Separated Integral String Complete: %s", separatedIntegralString )
		integralString = separatedIntegralString
	}

	if ( integralString.len() <= 3 && integralString != "0" && digits > 3 )
	{
		printf( "ShortenNumberDebug: Four or larger digit number shrunk to 3 or fewer digits! Making the number a decimal and adding a suffix (value = %s, digits = %i, maxDisplayIntegral = %i)", integralString, digits, maxDisplayIntegral )

		int separatorPos
		if ( maxDisplayIntegral == 3 )
			separatorPos = (digits - maxDisplayIntegral) % 3
		else
			separatorPos = ((digits - maxDisplayIntegral) % 3) + 1

		if( separatorPos != 0 && separatorPos != 3 )
			integralString = integralString.slice( 0, separatorPos ) + decimalSeparator + integralString.slice( separatorPos, integralString.len() ) + integralSuffix
		else
			integralString += integralSuffix
	}

	float decimal = 0.0
	string decimalString = ""

	decimal = number % 1
	decimalString = string( decimal )
	printf( "ShortenNumberDebug: decimalString = %s", decimalString )
	if ( decimalString.find( "0." ) != -1 )
		decimalString = decimalString.slice( 2 )

	if ( decimalString.len() > maxDisplayDecimal )
		decimalString = decimalString.slice( 0, maxDisplayDecimal )

	string finalDisplayNumber = integralString

	if ( maxDisplayDecimal > 0 && decimal != 0.0 )
	{
		printf( "ShortenNumberDebug: Attaching decimal value %f/%s to final display %s (original number = %f)", decimal, decimalString, finalDisplayNumber, number )
		finalDisplayNumber += decimalSeparator + decimalString
	}

	return finalDisplayNumber
}
#endif


bool function IsTenThousandOrMore( var value )
{
	return value >= 10000
}