///////////////////////////////////////////////////////////
// Object Control Panel scheme resource file
//
// sections:
//		Colors			- all the colors used by the scheme
//		BaseSettings	- contains settings for app to use to draw controls
//		Fonts			- list of all the fonts used by app
//		Borders			- description of all the borders
//
// hit ctrl-alt-shift-R in the app to reload this file
//
///////////////////////////////////////////////////////////
Scheme
{
	//////////////////////// COLORS ///////////////////////////
	// color details
	// this is a list of all the colors used by the scheme
	Colors
	{
		// base colors
		White					"255 255 255 255"
		OffWhite				"221 221 221 255"
		DullWhite				"211 211 211 255"
		Gray					"64 64 64 255"
		Orange					"255 155 0 255"
		Red						"255 0 0 255"
		LightBlue				"103 117 127 255"
		TransparentBlack		"0 0 0 100"
		Black					"0 0 0 255"
		Blank					"0 0 0 0"
		Green					"0 128 0 255"
		ScrollBarBase			"103 117 127 255"
		ScrollBarHover			"205 236 255 255"
		ScrollBarHold			"205 236 255 255"
		Disabled 				"0 0 0 150"
		TextBackground			"24 27 30 255"
	}

	///////////////////// BASE SETTINGS ////////////////////////
	// default settings for all panels
	// controls use these to determine their settings
	BaseSettings
	{
		// vgui_controls color specifications
		Border.Bright						"200 200 200 196"	// the lit side of a control
		Border.Dark							"40 40 40 196"		// the dark/unlit side of a control
		Border.Selection					"0 0 0 196"			// the additional border color for displaying the default/selected button
		Border.White						White

		Button.TextColor					White
		Button.BgColor						Blank
		Button.ArmedTextColor				White
		Button.ArmedBgColor					Blank
		Button.DepressedTextColor			"255 255 0 255"
		Button.DepressedBgColor				Blank
		Button.FocusBorderColor				Black
		Button.CursorPriority				1

		CheckButton.TextColor				OffWhite
		CheckButton.SelectedTextColor		White
		CheckButton.BgColor					TransparentBlack
		CheckButton.Border1  				Border.Dark 		// the left checkbutton border
		CheckButton.Border2  				Border.Bright		// the right checkbutton border
		CheckButton.Check					White				// color of the check itself

		ComboBoxButton.ArrowColor			DullWhite
		ComboBoxButton.ArmedArrowColor		White
		ComboBoxButton.BgColor				Blank
		ComboBoxButton.DisabledBgColor		Blank

		GenericPanelList.BgColor			Blank

		Frame.TitleTextInsetX				12
		Frame.ClientInsetX					6
		Frame.ClientInsetY					4
		Frame.BgColor						"80 80 80 255"
		Frame.OutOfFocusBgColor				"80 80 80 255"
		Frame.FocusTransitionEffectTime		0					// time it takes for a window to fade in/out on focus/out of focus
		Frame.TransitionEffectTime			0					// time it takes for a window to fade in/out on open/close
		Frame.AutoSnapRange					0
		FrameGrip.Color1					"200 200 200 196"
		FrameGrip.Color2					"0 0 0 196"
		FrameTitleButton.FgColor			"200 200 200 196"
		FrameTitleButton.BgColor			Blank
		FrameTitleButton.DisabledFgColor	"255 255 255 192"
		FrameTitleButton.DisabledBgColor	Blank
		FrameSystemButton.FgColor			Blank
		FrameSystemButton.BgColor			Blank
		FrameSystemButton.Icon				""
		FrameSystemButton.DisabledIcon		""
		FrameTitleBar.Font					DefaultLarge
		FrameTitleBar.TextColor				White
		FrameTitleBar.BgColor				Blank
		FrameTitleBar.DisabledTextColor		"255 255 255 192"
		FrameTitleBar.DisabledBgColor		Blank

		GraphPanel.FgColor					White
		GraphPanel.BgColor					TransparentBlack

		GridButtonListPanel.MaxScrollVel			1000.0
		GridButtonListPanel.JoystickDeadZone		0.15

		Label.TextDullColor					Black
		Label.TextColor						OffWhite
		Label.TextBrightColor				LightBlue
		Label.SelectedTextColor				White
		Label.BgColor						Blank
		Label.DisabledFgColor1				"117 117 117 0"
		Label.DisabledFgColor2				Disabled
		Label.RuiFont 						DefaultRegularFont
		Label.RuiFontHeight 				26
		Label.CursorPriority				-1

		ListPanel.TextColor					OffWhite
		ListPanel.BgColor					TransparentBlack
		ListPanel.SelectedTextColor			Black
		ListPanel.SelectedBgColor			"254 184 0 255"
		ListPanel.MouseOverBgColor			"128 128 128 255"
		ListPanel.SelectedOutOfFocusBgColor	"255 255 255 25"
		ListPanel.EmptyListInfoTextColor	LightBlue
		ListPanel.JoystickDeadZone			0.15
		ListPanel.MaxScrollVel				100.0
		ListPanel.CursorPriority			1

		ImagePanel.fillcolor				Blank

		Menu.TextColor						White
		Menu.BgColor						"160 160 160 255"
		Menu.ArmedTextColor					Black
		Menu.ArmedBgColor					LightBlue
		Menu.TextInset						6

		Panel.FgColor						DullWhite
		Panel.BgColor						Blank


		ProgressBar.FgColor					White
		ProgressBar.BgColor					TransparentBlack

		PropertySheet.TextColor				OffWhite
		PropertySheet.SelectedTextColor		White
		PropertySheet.TransitionEffectTime	0.25	// time to change from one tab to another
		PropertySheet.TabFont				DefaultLarge

		RadioButton.TextColor				DullWhite
		RadioButton.SelectedTextColor		White

		RichText.TextColor					OffWhite
		RichText.BgColor					TextBackground
		RichText.SelectedTextColor			OffWhite
		RichText.SelectedBgColor			LightBlue
		RichText.InsetX						20
		RichText.InsetY						0		[!$NX && !$NX_UI_PC]
		RichText.InsetY						15		[$NX || $NX_UI_PC]
		RichText.JoystickDeadZone		    0.15


		Chat.FriendlyFontColor				"55 233 255 255"
		Chat.EnemyFontColor					"230 83 14 255"
		Chat.NeutralFontColor				OffWhite
		Chat.RuiFont 						DefaultRegularFont
		Chat.RuiAsianFont					DefaultAsianFont
		Chat.RuiFontHeight					28
		Chat.RuiMinFontHeight				16
		Chat.RuiAsianBoxHeight				36

		ScrollBar.Wide						16

		ScrollBarButton.FgColor				"255 255 255 100"
		ScrollBarButton.BgColor				"0 0 0 65"
		ScrollBarButton.ArmedFgColor		White
		ScrollBarButton.ArmedBgColor		"0 0 0 80"
		ScrollBarButton.DepressedFgColor	White
		ScrollBarButton.DepressedBgColor	"255 255 255 100"

		ScrollBarSlider.FgColor				"255 255 255 100"	// nob color
		ScrollBarSlider.BgColor				"255 255 255 10"	// slider background color
		ScrollBarSlider.NobFocusColor		White
		ScrollBarSlider.NobDragColor		White
		ScrollBarSlider.Inset				0

		SectionedListPanel.HeaderTextColor				White
		SectionedListPanel.HeaderBgColor				Blank
		SectionedListPanel.DividerColor					"221 221 221 60"
		SectionedListPanel.TextColor					White
		SectionedListPanel.BrightTextColor				"255 255 255 255"
		SectionedListPanel.BgColor						TransparentBlack
		SectionedListPanel.SelectedTextColor			"255 255 255 255"
		SectionedListPanel.SelectedBgColor				"221 221 221 50"
		SectionedListPanel.OutOfFocusSelectedTextColor	"240 240 240 255"
		SectionedListPanel.OutOfFocusSelectedBgColor	"221 221 221 60"
		SectionedListPanel.MouseOverBgColor				"221 221 221 60"
		SectionedListPanel.ColumnBgColor				"221 221 221 30"
		SectionedListPanel.JoystickDeadZone				0.15
		SectionedListPanel.MaxScrollVel					1000.0
		SectionedListPanel.ButtonCursorPriority			1

		TextEntry.TextColor					OffWhite
		TextEntry.BgColor					"0 0 0 64"
		TextEntry.CursorColor				OffWhite
		TextEntry.DisabledTextColor			Disabled
		TextEntry.DisabledBgColor			Blank
		TextEntry.FocusedBgColor			"64 64 64 255"
		TextEntry.SelectedTextColor			Black
		TextEntry.SelectedBgColor			"0 0 0 255"
		TextEntry.OutOfFocusSelectedBgColor	LightBlue
		TextEntry.FocusEdgeColor			"0 0 0 196"
		TextEntry.LangIdBgColor				LightBlue
		TextEntry.LangIdFontHeight			16
		TextEntry.ButtonFontRui 			DefaultRegularFont
		TextEntry.ButtonFontHeightRui		16

		ToggleButton.SelectedTextColor		OffWhite

		Tooltip.TextColor					"0 0 0 196"
		Tooltip.BgColor						LightBlue

		TreeView.BgColor					TransparentBlack

		WizardSubPanel.BgColor				Blank

		Console.TextColor					OffWhite
		Console.DevTextColor				White

		//
		// portal2
		//
		Logo.X								75	[$GAMECONSOLE && ($GAMECONSOLEWIDE && !$ANAMORPHIC)]
		Logo.X								50	[$GAMECONSOLE && (!$GAMECONSOLEWIDE || $ANAMORPHIC)]
		Logo.X								75	[!$GAMECONSOLE && $WIN32WIDE]
		Logo.X								50	[!$GAMECONSOLE && !$WIN32WIDE]
		Logo.Y								35
		Logo.Width							240
		Logo.Height							60

		FooterPanel.ButtonFontRui 			DefaultRegularFont
		FooterPanel.ButtonFontHeightRui		40
		FooterPanel.TextFont				DialogButton
		FooterPanel.TextFontRui 			DefaultRegularFont
		FooterPanel.TextFontHeightRui		40
		FooterPanel.TextOffsetX				0
		FooterPanel.TextOffsetY				0
		FooterPanel.TextColor				"140 140 140 255"
		FooterPanel.InGameTextColor			"200 200 200 255"
		FooterPanel.ButtonGapX				12					[!$GAMECONSOLE]
		FooterPanel.ButtonGapX				20					[$GAMECONSOLE && ($ENGLISH || $GAMECONSOLEWIDE)]
		FooterPanel.ButtonGapX				16					[$GAMECONSOLE && (!$ENGLISH && !$GAMECONSOLEWIDE)]
		FooterPanel.ButtonGapY				25
		FooterPanel.ButtonPaddingX			20					[!$GAMECONSOLE]
		FooterPanel.OffsetY					8
		FooterPanel.BorderColor				"0 0 0 255"			[!$GAMECONSOLE]
		FooterPanel.BorderArmedColor		"0 0 0 255"			[!$GAMECONSOLE]
		FooterPanel.BorderDepressedColor	"0 0 0 255"			[!$GAMECONSOLE]

		FooterPanel.AvatarSize				32
		FooterPanel.AvatarBorderSize		40
		FooterPanel.AvatarOffsetY			47
		FooterPanel.AvatarNameY				49
		FooterPanel.AvatarFriendsY			66
		FooterPanel.AvatarTextFont			Default

		Dialog.TitleFont					DialogTitle
		Dialog.TitleColor					"0 0 0 255"
		Dialog.MessageBoxTitleColor			"232 232 232 255"
		Dialog.TitleOffsetX					10
		Dialog.TitleOffsetY					9
		Dialog.TileWidth					50
		Dialog.TileHeight					50
		Dialog.PinFromBottom				75
		Dialog.PinFromLeft					100	[$GAMECONSOLE && ($GAMECONSOLEWIDE && !$ANAMORPHIC)]
		Dialog.PinFromLeft					75	[$GAMECONSOLE && (!$GAMECONSOLEWIDE || $ANAMORPHIC)]
		Dialog.PinFromLeft					100	[!$GAMECONSOLE && $WIN32WIDE]
		Dialog.PinFromLeft					75	[!$GAMECONSOLE && !$WIN32WIDE]

		// Other properties defined in SliderControl.res
		SliderControl.InsetX				-68
		SliderControl.MarkColor				"105 118 132 255"
		SliderControl.MarkFocusColor		"105 118 132 255"
		SliderControl.ForegroundColor		"232 232 232 0"
		SliderControl.BackgroundColor		"0 0 0 0"
		SliderControl.ForegroundFocusColor	"255 255 255 0"
		SliderControl.BackgroundFocusColor	"0 0 0 0"
        SliderControl.CursorPriority        2

        // Other properties defined in ColorSlider.res
        ColorSlider.InsetX				    -30
        ColorSlider.MarkColor				"105 118 132 255"
        ColorSlider.MarkFocusColor		    "105 118 132 255"
        ColorSlider.ForegroundColor		    "232 232 232 0"
        ColorSlider.BackgroundColor	       	"0 0 0 0"
        ColorSlider.ForegroundFocusColor	"255 255 255 0"
        ColorSlider.BackgroundFocusColor	"0 0 0 0"
        ColorSlider.CursorPriority          2


		Slider.NobColor						"108 108 108 255"
		Slider.TextColor					"127 140 127 255"
		Slider.TrackColor					"31 31 31 255"
		Slider.DisabledTextColor1			"117 117 117 255"
		Slider.DisabledTextColor2			"30 30 30 255"

		LoadingProgress.NumDots				0
		LoadingProgress.DotGap				0
		LoadingProgress.DotWidth			18
		LoadingProgress.DotHeight			7

		ConfirmationDialog.TextFont			ConfirmationText
		ConfirmationDialog.TextFontRui		DefaultRegularFont
		ConfirmationDialog.TextFontRuiHeight	40
		ConfirmationDialog.TextOffsetX		5
		ConfirmationDialog.IconOffsetY		0

		KeyBindings.ActionColumnWidth		624
		KeyBindings.KeyColumnWidth			192
		KeyBindings.HeaderFont				DefaultBold_30
		KeyBindings.KeyFont					Default_23

		InlineEditPanel.FillColor			"221 221 221 60"
		InlineEditPanel.DashColor			White
		InlineEditPanel.LineSize			3
		InlineEditPanel.DashLength			2
		InlineEditPanel.GapLength			0

		//////////////////////// HYBRID BUTTON STYLES /////////////////////////////
		// A button set to use a specific style will use values defined by it, and will otherwise use the DefaultButton style.
		// If a style does not define all properties, HybridButton values will be used.
		// The .Style property tells code what type of behavior to apply to a button.

		HybridButton.TextColor						"255 255 255 127"
		HybridButton.FocusColor						Black
		HybridButton.SelectedColor					"255 128 32 255"
		HybridButton.CursorColor					"50 72 117 0"
		HybridButton.DisabledColor					Disabled
		HybridButton.FocusDisabledColor				Disabled
		HybridButton.Font							Default_28
		HybridButton.SymbolFont						MarlettLarge
		HybridButton.TextInsetX						0
		HybridButton.TextInsetY						16
		HybridButton.AllCaps						0
		HybridButton.CursorHeight					45
		HybridButton.MultiLine						56
		HybridButton.ListButtonActiveColor			"255 255 200 255"
		HybridButton.ListButtonInactiveColor		"232 232 232 255"
		HybridButton.ListInsetX						0
		// Special case properties for only a few menus
		HybridButton.LockedColor					Disabled
		HybridButton.BorderColor 					"0 0 0 255"
		HybridButton.RuiFont 						DefaultRegularFont
		HybridButton.RuiFontHeight 					25

		RuiLabel.CursorPriority						-1

		RuiButton.Style                             0
		RuiButton.CursorHeight		                0
		RuiButton.TextColor                         Blank
		RuiButton.LockedColor                       Blank
		RuiButton.FocusColor                        Blank
		RuiButton.SelectedColor                     Blank
		RuiButton.DisabledColor                     Blank
		RuiButton.FocusDisabledColor                Blank
		RuiButton.CursorPriority					1


		DefaultButton.Style							0   // BUTTON_DEFAULT
		DefaultButton.TextInsetX					79
		DefaultButton.TextInsetY					7

		//MainMenuButton.Style						1   // BUTTON_MAINMENU - Obsolete

		SliderButton.Style					    	2   // BUTTON_LEFTINDIALOG - inside a dialog, left aligned, optional RHS component anchored to right edge. Used primarily in slider controls
		SliderButton.CursorHeight			    	60		[!$NX && !$NX_UI_PC]
		SliderButton.CursorHeight			    	80 		[$NX || $NX_UI_PC]
		SliderButton.TextInsetX				    	12
		SliderButton.TextInsetY					    4
        SliderButton.CursorPriority                 1

		DialogListButton.Style						3   // BUTTON_DIALOGLIST - inside a dialog, left aligned, RHS list anchored to right edge
		DialogListButton.CursorHeight				60
		DialogListButton.TextInsetX					12
		DialogListButton.TextInsetY					12
		DialogListButton.TextColor					"255 255 255 127"
		DialogListButton.FocusColor					Black
		DialogListButton.ListButtonActiveColor		Black
		DialogListButton.ListButtonInactiveColor	"0 0 0 127"

		FlyoutMenuButton.Style						4   // BUTTON_FLYOUTITEM - inside of a flyout menu only
		DropDownButton.Style						5   // BUTTON_DROPDOWN - inside a dialog, contains a RHS value, usually causes a flyout
		//GameModeButton.Style						6   // BUTTON_GAMEMODE - not used, specialized button previously used in L4D game mode carousel
		//VirtualNavigationButton.Style				7   // BUTTON_VIRTUALNAV - does nothing in code
		//MixedCaseButton.Style						8   // BUTTON_MIXEDCASE - not used, menus where mixed case is used for button text (Steam link dialog)
		//MixedCaseDefaultButton.Style				9   // BUTTON_MIXEDCASEDEFAULT - not used
		//BitmapButton.Style						10  // BUTTON_BITMAP - not used or useful

		SmallButton.Style							0
		SmallButton.CursorHeight					40
		SmallButton.TextInsetX						12
		SmallButton.TextInsetY						4

		RuiFooterButton.Style						0
		RuiFooterButton.CursorHeight				36
		RuiFooterButton.TextInsetX					0
		RuiFooterButton.TextInsetY					0
		RuiFooterButton.TextColor                   Blank
		RuiFooterButton.LockedColor                 Blank
		RuiFooterButton.FocusColor					Blank
		RuiFooterButton.SelectedColor				Blank
		RuiFooterButton.DisabledColor				Blank
		RuiFooterButton.FocusDisabledColor			Blank

		PCFooterButton.Style						0
		PCFooterButton.CursorHeight					36
		PCFooterButton.TextInsetX					11

		GridButton.Style 							0
		GridButton.CursorHeight						30
		GridButton.TextInsetX						0
		GridButton.TextInsetY						0

		TitanDecalButton.Style 						0
		TitanDecalButton.CursorHeight				126
		TitanDecalButton.TextInsetX					79
		TitanDecalButton.TextInsetY					7

		Test2Button.Style 					    	0
		Test2Button.CursorHeight			    	96
	}

	//////////////////////// CRITICAL FONTS ////////////////////////////////
	// Very specifc console optimization that precaches critical glyphs to prevent hitching.
	// Adding descriptors here causes super costly memory font pages to be instantly built.
	// CAUTION: Each descriptor could be up to N fonts, due to resolution, proportionality state, etc,
	// so the font page explosion could be quite drastic.
	CriticalFonts
	{
		Default
		{
			uppercase		1
			lowercase		1
			punctuation		1
		}

		InstructorTitle
		{
			commonchars		1
		}

		InstructorKeyBindings
		{
			commonchars		1
		}

		InstructorKeyBindingsSmall
		{
			commonchars		1
		}

		CloseCaption_Console
		{
			commonchars		1
			asianchars		1
			skipifasian		0
			russianchars	1
			uppercase		1
			lowercase		1
		}

		ConfirmationText
		{
			commonchars		1
		}

		DialogTitle
		{
			commonchars		1
		}

		DialogButton
		{
			commonchars		1
		}
	}

	//////////////////////// FONTS /////////////////////////////
	// Font Options
	// tall: 		The font size. At 1080, character glyphs will be this many pixels tall including linespace above and below.
	// antialias: 	Smooths font edges.
	// dropshadow: 	Adds a single pixel thick shadow on the bottom and right edges.
	// outline: 	Adds a single pixel thick black outline.
	// blur: 		Blurs the character glyphs. The blur amount can be controlled by the value given.
	// italic: 		Generates italicized glpyhs by slanting the characters.
	// shadowglow: 	Adds a blurry black shadow behind characters. The shadow size can be controlled by the value given.
	// additive:	Renders the text additively.
	// scanlines: 	Adds horizontal scanlines. May need to be additive also to see the effect.
	// underline:	Adds a line under all characters. May no longer work.
	// strikeout: 	Adds a line across all characters. May no longer work.
	// rotary: 		Adds a line across all characters. Doesn't seem very useful.
	// symbol:		Uses the symbol character set when generating the font. Only used with Marlett.
	// bitmap: 		Used with bitmap fonts which is how gamepad button images are shown.
	// custom:		?
	//
	// By default, the game will make a proportional AND a nonproportional version of each
	// font. If you know ahead of time that the font will only ever be used proportionally
	// or nonproportionally, you can conserve resources by telling the engine so with the
	// "isproportional" key. can be one of: "no", "only", or "both".
	// "both" is the default behavior.
	// "only" means ONLY a proportional version will be made.
	// "no" means NO proportional version will be made.
	// this key should come after the named font glyph sets -- eg, it should be inside "Default" and
	// after "1", "2", "3", etc -- *not* inside the "1","2",.. size specs. That is, it should be
	// at the same indent level as "1", not the same indent level as "yres".

	Fonts
	{
		//////////////////////////////////// Font definitions referenced by code ////////////////////////////////////

		Default
		{
			"1"
			{
				name		Default
				tall		28
				antialias 	1
			}
		}

		DefaultBold
		{
			"1"
			{
				name		Default
				tall		12
				weight		1000
			}
		}

		DefaultUnderline
		{
			"1"
			{
				name		Default
				tall		12
				weight		500
				underline 	1
			}
		}

		DefaultSmall
		{
			"1"
			{
				name		Default
				tall		9
				weight		0
			}
		}

		DefaultSmallDropShadow
		{
			"1"
			{
				name		Default
				tall		10
				weight		0
				dropshadow 	1
			}
		}

		DefaultVerySmall
		{
			"1"
			{
				name		Default
				tall		9
				weight		0
			}
		}

		DefaultLarge
		{
			"1"
			{
				name		Default
				tall		13
				weight		0
			}
		}

		MenuLarge
		{
			"1"
			{
				name		Default
				tall		12
				weight		600
				antialias 	1
			}
		}

		ConsoleText
		{
			"1"
			{
				name		"Lucida Console"
				tall		22
				weight		500
			}
		}
		ConsoleTextSmall
		{
			"1"
			{
				name		"Lucida Console"
				tall		14
				weight		250
				antialias	1
			}
		}

		// Dev only - Used for Debugging UI, overlays, etc
		DefaultSystemUI
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		31
				antialias	1
			}
		}

		ChatFont
		{
			isproportional	no
			"1"
			{
				name		Default
				tall		13
				yres		"480 1079"
				antialias	1
				shadowglow	3
			}
			"2"
			{
				name		Default
				tall		16
				yres		"1080 1199"
				antialias	1
				shadowglow	3
			}
			"3"
			{
				name		Default
				tall		19
				yres		"1200 10000"
				antialias	1
				shadowglow	3
			}
		}

		ChatroomFont
		{
			isproportional	no
			"1"
			{
				name		Default
				tall		19
				yres		"480 1079"
				antialias	1
//				shadowglow	3
			}
			"2"
			{
				name		Default
				tall		24
				yres		"1080 1199"
				antialias	1
//				shadowglow	3
			}
			"3"
			{
				name		Default
				tall		28
				yres		"1200 10000"
				antialias	1
//				shadowglow	3
			}
		}

		// this is the symbol font
		MarlettLarge
		{
			"1"
			{
				name		Marlett
				tall		30
				weight		0
				symbol		1
				range		"0x0000 0x007F"	//	Basic Latin
				antialias	1
			}
		}

		// this is the symbol font
		Marlett
		{
			"1"
			{
				name		Marlett
				tall		16
				weight		0
				symbol		1
				range		"0x0000 0x007F"	//	Basic Latin
				antialias	1
			}
		}

		// this is the symbol font
		MarlettSmall
		{
			"1"
			{
				name		Marlett
				tall		8
				weight		0
				symbol		1
				range		"0x0000 0x007F"	//	Basic Latin
				antialias	1
			}
		}

		// the title heading for a primary menu
		DialogTitle
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		20
				antialias	1
			}
		}

		// an LHS/RHS item appearing on a dialog menu
		DialogButton
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		13
				antialias	1
			}
		}

		// text for the confirmation
		ConfirmationText
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		18
				antialias	1
			}
		}

		CloseCaption_Normal
		{
			"1"
			{
				name		Default
				tall		22
				weight		500
				antialias	1
			}
		}

		CloseCaption_Italic
		{
			"1"
			{
				name		Default
				tall		31
				weight		500
				italic		1
				antialias	1
			}
		}

		CloseCaption_Bold
		{
			"1"
			{
				name		DefaultBold
				tall		31
				weight		900
				antialias	1
			}
		}

		CloseCaption_BoldItalic
		{
			"1"
			{
				name		DefaultBold
				tall		31
				weight		900
				italic		1
				antialias	1
			}
		}

		InstructorTitle
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		13
				antialias	1
			}
		}

		InstructorKeyBindings
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		9
				antialias 	1
			}
		}

		InstructorKeyBindingsSmall
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		7
				antialias 	1
			}
		}

		CenterPrintText
		{
			"1"
			{
				name		Default
				tall		34
				antialias 	1
				additive	1
			}
		}

		//////////////////////////////////// Default font variations ////////////////////////////////////

		Default_9
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		9
				antialias	1
			}
		}

		Default_19_DropShadow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		19
				antialias	1
				dropshadow	1
			}
		}

		Default_21
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		21
				antialias	1
			}
		}
		Default_21_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		21
				antialias	1
				shadowglow	7
			}
		}

		Default_23
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		23
				antialias	1
			}
		}

		Default_27
		{
			isproportional	only
			"1"
			{
				name 		Default
				tall		27
				antialias	1
			}
		}
		Default_27_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		27
				antialias	1
				shadowglow	4
			}
		}

		Default_28
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		28
				antialias	1
			}
		}
		Default_28_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		28
				antialias	1
				shadowglow	4
			}
		}

		Default_31_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		31
				antialias	1
				shadowglow	7
			}
		}

		Default_34
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		34
				antialias	1
			}
		}
		Default_34_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		34
				antialias	1
				shadowglow	7
			}
		}

		Default_59
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		59
				antialias	1
			}
		}

		//////////////////////////////////// Default bold font variations ////////////////////////////////////

		DefaultBold_27_DropShadow
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		27
				antialias 	1
				dropshadow	1
			}
		}

		DefaultBold_30
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		30
				antialias	1
			}
		}

		DefaultBold_41
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		41
				antialias	1
			}
		}

		DefaultBold_65
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		65
				antialias	1
			}
		}

		DefaultBold_80
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		80
				antialias	1
			}
		}
	}

	//////////////////// BORDERS //////////////////////////////
	// describes all the border types
	Borders
	{
		ButtonBorder			NoBorder
		PropertySheetBorder		RaisedBorder

		FrameBorder
		{
			backgroundtype		0
		}

		BaseBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	Border.Dark
					offset	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Bright
					offset	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
		}

		RaisedBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Bottom
			{
				"1"
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
		}

		TitleButtonBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderDark
					offset 	"1 0"
				}
			}
			Top
			{
				"4"
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}

		TitleButtonDisabledBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	BgColor
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BgColor
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BgColor
					offset 	"0 0"
				}
			}

			Bottom
			{
				"1"
				{
					color 	BgColor
					offset 	"0 0"
				}
			}
		}

		TitleButtonDepressedBorder
		{
			inset 	"1 1 1 1"

			Left
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderBright
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
		}

		NoBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}

		ScrollBarButtonBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}
		ScrollBarButtonDepressedBorder ScrollBarButtonBorder

		ScrollBarSliderBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}
		ScrollBarSliderBorderHover ScrollBarSliderBorder
		ScrollBarSliderBorderDragging ScrollBarSliderBorder

		ButtonBorder	//[0]
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}

		TabBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Dark
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
		}

		TabActiveBorder
		{
			inset 	"0 0 1 0"

			Left
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Dark
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	ControlBG
					offset 	"6 2"
				}
			}
		}

		ToolTipBorder
		{
			inset 	"0 0 1 0"

			Left
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderDark
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}

		// this is the border used for default buttons (the button that gets pressed when you hit enter)
		ButtonKeyFocusBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				"2"
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				"2"
				{
					color 	Border.Bright
					offset 	"1 0"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				"2"
				{
					color 	Border.Dark
					offset 	"1 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				"2"
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
		}

		ButtonDepressedBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}

		ComboBoxBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderBright
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
		}

		MenuBorder
		{
			inset 	"1 1 1 1"

			Left
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderDark
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}
	}

	InheritableProperties
	{
		ChatBox
		{
			wide					630
			tall					155

			bgcolor_override 		"0 0 0 180"

			chatBorderThickness		3

			chatHistoryBgColor		"24 27 30 200"
			chatEntryBgColor		"24 27 30 200"
			chatEntryBgColorFocused	"24 27 30 200"
		}

		DefaultButton
		{
			wide					674
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					DefaultButton
			childGroupNormal		DefaultButtonNormalGroup
			childGroupFocused		DefaultButtonFocusGroup
			childGroupLocked		DefaultButtonLockedGroup
			childGroupNew			DefaultButtonNewGroup
		}

		RuiSmallButton
		{
			wide					540
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/test_button.rpak"
			labelText				""
			style					SmallButton
		}

		RuiDevMenuButton
		{
		    wide					405
            tall					40
            zpos					3 // Needed or clicking on the background can hide this
            visible					1
            enabled					1
            rui						"ui/test_button.rpak"
            labelText				""
            style					SmallButton
		}

		RuiGamepadBindButton
		{
			wide					500
			tall					60
			tall_nx_handheld		80		[$NX || $NX_UI_PC]
			zpos					3
			visible					1
			enabled					1
            rui						"ui/gamepad_bindlist_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiSkipLabel
		{
			wide					800
			tall					29
			visible					1
            rui						"ui/skip_label.rpak"
		}

		RuiDialogSpinner
		{
			wide					106
			tall					106
			visible					1
            rui						"ui/dialog_spinner.rpak"
		}

        FullSizer
        {
            //ControlName           Panel
            proportionalToParent    1
            xpos                    0
            ypos                    0
            zpos                    0
            enabled                 0
            wide                    %100
            tall                    %100
            rui                     "ui/basic_image.rpak"
            ruiArgs
            {
                basicImageAlpha     0.0
            }
            visible                 0
        }

        SettingsScrollFrame
        {
            xpos					0
            ypos					0
            wide					1064
            tall					704
            visible					1
            proportionalToParent	1
        }

        SettingsPanelFull
        {
		    classname				"TabPanelClass"
		    xpos					0
		    ypos					0
			wide					%100
			tall					1028
		    visible					0
		    controlSettingsFile		"resource/ui/menus/panels/settings.res"
		    clip                    1
            tabPosition				1
        }

        SettingsTabPanel
        {
            xpos                    64
            ypos					-128//-64
            wide					1728 //%100
            tall					836//740
            visible				    0
            clip                    1
            proportionalToParent	1
        }

        SettingsScrollBar
        {
            xpos                    8
            ypos                    0
            wide					24
            tall					836//740
            visible					1
            enabled 				1
            rui						"ui/survival_scroll_bar.rpak"
            zpos                    101
        }

        SettingsContentPanel
        {
            xpos					0
            ypos					0
            wide					%100
            tall					836//740
            visible					1
            proportionalToParent	1
        }

        SettingsDetailsPanel
        {
            xpos				    564//-1568
            ypos					-128//-64
            wide					548
            tall					836//740
            visible					1
            rui                     "ui/settings_details.rpak"
        }

		WideButton
		{
			wide					1040
			tall					60
			tall_nx_handheld		80 		[$NX || $NX_UI_PC]
			visible					1
			enabled					1
			style					SmallButton
            rui                     "ui/generic_item_button.rpak"
            clipRui					1
			labelText				""
			ypos                    4
		}

		ThinButton
		{
			wide					528
			tall					50
			visible					1
			enabled					1
			style					SmallButton
            rui                     "ui/generic_item_button.rpak"
            clipRui					1
			labelText				""
			ypos                    4
		}

		SettingBasicButton
		{
			font                    Default_28
			wide					1040
			tall					60
			tall_nx_handheld		80 		[$NX || $NX_UI_PC]
			zpos					3
			ypos                    2
			visible					1
			enabled					1
			rui						"ui/settings_base_button.rpak"
			clipRui					1
			labelText               ""
            cursorVelocityModifier  0.7

            sound_accept            "UI_Menu_Accept"
		}

		SwitchButton
		{
			font                    Default_28
			wide					1040
			tall					60
			tall_nx_handheld		80 		[$NX || $NX_UI_PC]
			zpos					3
			ypos                    2
			visible					1
			enabled					1
			style					DialogListButton
			rui						"ui/settings_base_button.rpak"
			clipRui					1
			labelText               ""
			nonDefaultColor	"244 213 166 255"
            cursorVelocityModifier  0.7
		}

		SwitchButtonCompact
        {
            font                    Default_28
            wide					512
            tall					60
            tall_nx_handheld		80 		[$NX || $NX_UI_PC]
            zpos					3
            ypos                    2
            visible					1
            enabled					1
            style					DialogListButton
            rui						"ui/settings_compact_button.rpak"
            clipRui					0
            labelText               "Test"
            nonDefaultColor	"244 213 166 255"
            cursorVelocityModifier  0.7
        }

        SwitchButtonClubInvite
        {
            font                    Default_28
            wide					414
            tall					50
            tall_nx_handheld		80 		[$NX || $NX_UI_PC]
            zpos					3
            ypos                    2
            visible					1
            enabled					1
            style					DialogListButton
            rui						"ui/settings_compact_button.rpak"
            clipRui					0
            labelText               "Test"
            nonDefaultColor	"244 213 166 255"
            cursorVelocityModifier  0.7
        }

		SliderControl
		{
			wide					1040
            tall					60
            tall_nx_handheld		80 		[$NX || $NX_UI_PC]
			zpos					3 // Needed or clicking on the background can hide this
			ypos                    2
			visible					1
			enabled					1
            cursorVelocityModifier  0.7
            soundRepeatsOnLeftRightHeld 1
		}
		ColorSlider
		{
            wide					858
            tall					76
            zpos					3 // Needed or clicking on the background can hide this
            ypos                    2
            visible					1
            enabled					1
            cursorVelocityModifier  0.7
	        controlSettingsName		ColorSlider
	        soundRepeatsOnLeftRightHeld 0
		}

		SliderControlTextEntry
		{
            xpos                    -8
            zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
            wide					48
            tall					48
            tall_nx_handheld		68 		[$NX || $NX_UI_PC]
            visible					1
            enabled					1
            textHidden				0
            editable				1
            maxchars				4
            NumericInputOnly		1
            textAlignment			"center"
            ruiFont                 TitleRegularFont
            ruiFontHeight           22
            ruiMinFontHeight        16
            keyboardTitle			"#ENTER_YOUR_EMAIL"
            keyboardDescription		"#ENTER_YOUR_EMAIL_DESC"
            allowRightClickMenu		0
            allowSpecialCharacters	0
            unicode					0
            showConVarAsFloat		1
            selectOnFocus           1
            cursorVelocityModifier  0.7
		}

		TabButtonLobby
		{
			classname				TabButtonClass
			wide					284
    		polyShape               "0.0 0.0 0.71 0.0 1.0 1.0 0.29 1.0" // height / width to determine offsets
			tall					84
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_lobby.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_focus             "UI_Menu_Focus_Large"
			sound_accept            "UI_Menu_ApexTab_Select"
		}

		TabButtonSeasonSubNav
		{
			classname				TabButtonClass
			wide					284
    		polyShape               "0.253 0.0 1.0 0.0 0.747 1.0 0.0 1.0" // height / width to determine offsets
			tall					72
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_season_subnav.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_focus             "UI_Menu_Focus_Large"
			sound_accept            "UI_Menu_ApexTab_Select"
		}

		TabButtonStore
		{
			classname				TabButtonClass
			wide					260
			wide_nx_handheld		280			[$NX || $NX_UI_PC]
			tall					44
			tall_nx_handheld		65			[$NX || $NX_UI_PC]
    		polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_store.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			zpos                    10
			sound_focus             "UI_Menu_Focus_Large"
			sound_accept            "UI_Menu_StoreTab_Select"
		}

		TabButtonCharacterCustomize
		{
			classname				TabButtonClass
			wide					260
			wide_nx_handheld		280			[$NX || $NX_UI_PC]
			tall					44
			tall_nx_handheld		65			[$NX || $NX_UI_PC]
			polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_character_customize.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_accept            "UI_Menu_LegendTab_Select"
		}

		TabButtonReticleCustomize
        {
            classname				TabButtonClass
            wide					260
            wide_nx_handheld		280			[$NX || $NX_UI_PC]
            tall					44
            tall_nx_handheld		65			[$NX || $NX_UI_PC]
            polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
            visible					1
            enabled					1
            style					RuiButton
            rui						"ui/tab_button_reticle_customize.rpak"
            labelText				""
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_LegendTab_Select"
        }
                         
        TabButtonLaserSightCustomize
        {
            classname				TabButtonClass
            wide					260
            wide_nx_handheld		280			[$NX || $NX_UI_PC]
            tall					44
            tall_nx_handheld		65			[$NX || $NX_UI_PC]
            polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
            visible					1
            enabled					1
            style					RuiButton
            rui						"ui/tab_button_laser_sight_customize.rpak"
            labelText				""
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_LegendTab_Select"
        }
      
		TabButtonGameModeRules
        {
            classname				TabButtonClass
            wide					260
            wide_nx_handheld		280			[$NX || $NX_UI_PC]
            tall					44
            tall_nx_handheld		65			[$NX || $NX_UI_PC]
            polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
            visible					1
            enabled					1
            style					RuiButton
            rui						"ui/tab_button_rules.rpak"
            labelText				""
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_LegendTab_Select"
        }
		TabButtonSettings
		{
			classname				TabButtonClass
			wide					284
    		polyShape               "0.0 0.0 0.71 0.0 1.0 1.0 0.29 1.0" // height / width to determine offsets
			tall					84
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_lobby.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_focus             "UI_Menu_Focus_Large"
			sound_accept            "UI_Menu_SettingsTab_Select"
		}

		TabButtonWeaponCustomize
		{
			classname				TabButtonClass
			wide					260
			wide_nx_handheld		280			[$NX || $NX_UI_PC]
			tall					44
			tall_nx_handheld		65			[$NX || $NX_UI_PC]
			polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_character_customize.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_accept            "UI_Menu_ArmoryTab_Select"
		}

		TabButtonClubLobby
        {
            classname				TabButtonClass
            wide					250
            tall					60
            polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
            visible					1
            enabled					1
            style					RuiButton
            rui						"ui/club_lobby_tab_button.rpak"
            labelText				""
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_LegendTab_Select"
        }

		InviteButton
		{
            wide					148
            tall					148
            rui                     "ui/invite_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7

            proportionalToParent    1

			sound_focus             "UI_Menu_Focus"
            sound_accept            "UI_Menu_InviteFriend_Open"
		}

		StoryButton
        {
            wide					180
            tall					148
            rui                     "ui/story_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7

            proportionalToParent    1

            sound_focus             "UI_Menu_Focus"
            sound_accept            "UI_Menu_InviteFriend_Open"
        }

		CornerButton
		{
			classname               MenuButton
            wide					60
			wide_nx_handheld		100 	[$NX || $NX_UI_PC]
            tall					60
            tall_nx_handheld		100 	[$NX || $NX_UI_PC]
            rui                     "ui/generic_icon_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7

            proportionalToParent    1

			sound_focus             "UI_Menu_Focus_Small"
		}

		LootInspectButton
		{
            wide					375
            tall					770
            zpos					3
            rui						"ui/loot_inspect_button.rpak"
            labelText				""
            visible					1
            enabled					0
            sound_accept            "UI_Menu_LootPreview"
        }

		GridButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
			labelText 				""
			childGroupAlways		GridButtonAlwaysGroup
			childGroupFocused		GridButtonFocusedGroup
			childGroupSelected		GridButtonSelectedGroup
//			childGroupLocked		GridButtonLockedGroup
			childGroupNew			GridButtonNewGroup
		}

		SurvivalInventoryGridButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/survival_inventory_grid_button_v2.rpak"
			rightClickEvents		1
			middleClickEvents       1

			cursorVelocityModifier  0.6

			sound_focus             "UI_InGame_Inventory_Hover"
			sound_accept            ""
			sound_deny              ""
		}

		SurvivalInventoryListButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					320
			tall					48
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/survival_inventory_list_button.rpak"
			clipRui					1
			rightClickEvents		1

			cursorVelocityModifier  0.6
		}

		SurvivalGroundListCategoryHeader
		{
			rui						"ui/survival_ground_list_category_header.rpak"
			xpos					0
			ypos					0
			wide                    0
			tall                    0
			zpos                    5
			enabled					1
			visible					0
			rightClickEvents		1
			cursorVelocityModifier  0.6
		}

		SurvivalGroundListItemButton
		{
			rui						"ui/survival_ground_list_item_button.rpak"
			xpos					0
			ypos					0
			wide                    0
			tall                    0
			zpos                    4
			enabled					1
			visible					0
			rightClickEvents		1
			cursorVelocityModifier  0.6
			hasScriptSound          1
		}

		SurvivalUpgradeCounter
		{
		    wide                    512
		    tall                    96
		    visible                 1
		    enabled                 1
		    rui						"ui/survival_upgrade_currency_counter.rpak"
            labelText 				""
		}

		SurvivalUpgradeButton
        {
            wide					512
            tall					96
            visible					1
            enabled					1
            style					RuiButton
            rui						"ui/survival_upgrade_purchase_button.rpak"
            labelText 				""

            cursorVelocityModifier  0.6
        }

		SurvivalEquipmentButton
		{
			wide					84
			tall					84
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/survival_equipment_button_v2.rpak"
			labelText 				""

			cursorVelocityModifier  0.6
		}

		SurvivalAttachmentButton
		{
			wide					68
			tall					68
			visible					1
			enabled					1
			style					RuiButton
			rui						"ui/survival_inventory_grid_button_v2.rpak"
			rightClickEvents		1

			cursorVelocityModifier  0.6
		}

		SurvivalWeaponButtonWide
		{
			wide					320
			tall					140
			visible					1
			enabled					1
			style					RuiButton
			rui						"ui/survival_equipment_button_wide.rpak"
			rightClickEvents		1

			cursorVelocityModifier  0.6
		}

        PaginationButton
        {
            classname               "PaginationButton MenuButton"
            rui                     "ui/generic_selectable_button.rpak"
            wide					48
            tall					48
            visible					1
        }

		FriendGridButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					400
			wide_nx_handheld		400			[$NX || $NX_UI_PC]
			tall					80
			tall_nx_handheld		86			[$NX || $NX_UI_PC]
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/generic_friend_button.rpak"
			rightClickEvents		1
			cursorVelocityModifier  0.7
            //sound_accept            "UI_Menu_InviteFriend_Send" // Buttons are always disabled?
		}

        StoreInspectGridButton
        {
            xpos					0
            ypos					0
            zpos					2
            wide					100
            tall					100
            visible					1
            enabled					1
            style					RuiButton
            textAlignment			left
            labelText 				""
            rui						"ui/store_inspect_grid_button.rpak"
            cursorVelocityModifier  0.7
        }

        ToolTip
        {
            classname               "ToolTip"
            zpos                    999
            wide					512
            tall					192
            visible				    0
            rui                     "ui/generic_tooltip.rpak"
            enabled                 0

            proportionalToParent    1
        }

		GridPageCircleButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					30
			tall					30
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			childGroupAlways		GridPageCircleButtonAlways
			childGroupFocused		GridPageCircleButtonFocused
			childGroupSelected		GridPageCircleButtonSelected
		}

		GridPageArrowButtonLeft
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					128
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_left.rpak"
		}

		GridPageArrowButtonRight
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					128
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_right.rpak"
		}

		GridPageArrowButtonUp
		{
			xpos					0
			ypos					0
			zpos					2
			wide					128
			tall					32
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_up.rpak"
		}

		GridPageArrowButtonDown
		{
			xpos					0
			ypos					0
			zpos					2
			wide					128
			tall					32
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_down.rpak"
		}

		UserInfo
		{
			classname               UserInfo
			rui                     "ui/userinfo.rpak"
			wide                    200
			tall                    84
			visible                 1
			sound_focus             ""
			sound_accept            ""
		}

		LobbyCharacterButton
		{
            classname               CharacterButtonClass
			wide					194
			wide_nx_handheld		237 		[$NX || $NX_UI_PC]
			tall					126
			tall_nx_handheld		154 		[$NX || $NX_UI_PC]
			visible					0
			enabled					1
            rui						"ui/lobby_character_button.rpak"
			labelText				""
			style					RuiButton
			polyShape               "0.375 0.0 1.0 0.0 0.625 1.0 0.0 1.0"
			rightClickEvents		1
			middleClickEvents       1
			sound_focus             "UI_Menu_Focus"
			sound_accept			""
            cursorVelocityModifier  0.7

            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_LEFT
		}

		MatchCharacterButton
		{
            zpos					10
			wide					194
			wide_nx_handheld		262 		[$NX || $NX_UI_PC]
			tall					126
			tall_nx_handheld		170 		[$NX || $NX_UI_PC]
			visible					0
			enabled					1
            rui						"ui/character_select_class_button_new.rpak"
			labelText				""
			style					RuiButton
			polyShape               "0.375 0.0 1.0 0.0 0.625 1.0 0.0 1.0"
			rightClickEvents		1
			enterClickEvents		0
			sound_focus             "UI_Menu_Focus_LegendSelectScreen"
			sound_accept			""
            cursorVelocityModifier  0.7

            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_LEFT
		}

		StoreCharacterButton
		{
			classname               CharacterButtonClass
			wide					194
			wide_nx_handheld		319 		[$NX || $NX_UI_PC]
			tall					126
			tall_nx_handheld		211 		[$NX || $NX_UI_PC]
			visible					0
			enabled					1
            rui						"ui/store_character_button.rpak"
			labelText				""
			style					RuiButton
			polyShape               "0.375 0.0 1.0 0.0 0.625 1.0 0.0 1.0"
			rightClickEvents		1
			cursorVelocityModifier  0.7

            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_LEFT
		}

		WeaponCategoryButton
		{
            wide					457
			wide_nx_handheld		550 		[$NX || $NX_UI_PC]
            tall					220
            tall_nx_handheld		264	 		[$NX || $NX_UI_PC]
			visible					1
			enabled					1
            rui						"ui/weapon_category_button.rpak"
			labelText				""
			style					RuiButton
			polyShape               "0.2725 0.0 1.0 0.0 0.7275 1.0 0.0 1.0"
			sound_focus             "UI_Menu_Focus"
			sound_accept            "UI_Menu_WeaponClass_Select"
			cursorVelocityModifier  0.7
		}

		Test2Button
		{
			wide					96
			tall					96
			visible					1
			enabled					0
			style					Test2Button
			labelText 				""
			childGroupAlways		Test2ButtonAlwaysGroup
			childGroupFocused		Test2ButtonFocusedGroup
			childGroupNew			Test2ButtonNewGroup
		}

		MenuTopBar
		{
			xpos					0
			ypos					130
			wide					%100
			tall					8
			image 					"ui/menu/common/menu_title_bar"
			visible					1
			scaleImage				1
		}

		MenuVignette
		{
			xpos					0
			ypos					0
			wide					%100
			tall					%100
			image 					"rui/menu/common/menu_vignette"
			visible					1
			scaleImage				1
			disableMouseFocus		1
		}

		MenuTitle
		{
			xpos					106 // include n pixels for the combo button inset
			ypos					54
			auto_wide_tocontents 	1
			tall					97
			visible					1
			font					DefaultBold_65
			allcaps					1
			fgcolor_override		"255 255 255 255"
			classname				MenuTitle
		}

		FooterButtons
		{
			xpos					0
			ypos					r90 //5% safe area plus this things height of 36
			zpos					20
			wide					f0
			tall					36
			visible					1
			controlSettingsFile		"resource/ui/menus/panels/footer_buttons.res"
		}

        DialogFooterButtons
        {
            xpos					-211
            ypos                    -32
            wide					f0
            tall					60
            visible					1
            controlSettingsFile		"resource/ui/menus/panels/dialog_footer_buttons.res"
        }

        DialogFooterButtonsHighPriority
        {
            xpos					-211
            ypos                    -32
            wide					f0
            tall					60
            visible					1
            controlSettingsFile		"resource/ui/menus/panels/dialog_footer_buttons_highpriority.res"
        }

        PromoFooterButtons
        {
            xpos					-211
            ypos                    -32
            wide					f0
            tall					60
            visible					1
            controlSettingsFile		"resource/ui/menus/panels/promo_footer_buttons.res"
        }

        DialogFooterButtonsR2
        {
            xpos					-368
            ypos                    -38
            wide					f0
            tall					56
            visible					1
            controlSettingsFile		"resource/ui/menus/panels/dialog_footer_buttons_r2.res"
        }

		R2_ContentDescription
		{
			visible					1
			font					Default_27
			allcaps					0
			fgcolor_override		"245 245 245 255"
		}

		AdvControlsLabel
		{
			font					Default_27
			allcaps					0
			auto_wide_tocontents 	1
			fgcolor_override		"244 213 166 255"
		}

		SubheaderBackgroundWide
		{
            wide 					%60
			tall					45
			tall_nx_handheld		65 		[$NX || $NX_UI_PC]
			visible					1
			image 					"ui/menu/common/menu_header_bar_wide"
			visible					1
			scaleImage				1
		}
		SubheaderText
		{
			zpos					3 // Needed or clicking on the background can hide this
			auto_wide_tocontents 	1
			tall					40
			tall_nx_handheld		60 		[$NX || $NX_UI_PC]
			visible					1
			font					DefaultBoldFont
			fontHeight 				30
			fontHeight_nx_handheld	45 		[$NX || $NX_UI_PC]
			allcaps					1
			fgcolor_override		"245 245 245 255"
		}

		LeftFooterSizer // TODO: Remove when old dialogs are gone
		{
			classname				LeftFooterSizerClass
			zpos					3
			auto_wide_tocontents 	1
			tall 					36
			labelText				"DEFAULT"
			font					DefaultRegularFont
			fontHeight 				32
			textinsetx				18
			use_proportional_insets	1
			enabled					1
			visible					1
			ruiVisible				0
		}

		LeftRuiFooterButton
		{
		    classname				LeftRuiFooterButtonClass
			style					RuiFooterButton
            rui						"ui/footer_button.rpak"
			zpos					3
			tall					36
			font                    Default_28
			labelText				"DEFAULT"
			enabled					1
			visible					1
			auto_wide_tocontents 	1
            behave_as_label         1
            ruiDefaultHeight        36
            fontHeight              32
		}
		
		RightRuiFooterButton
		{
		    classname				RightRuiFooterButtonClass
			style					RuiFooterButton
            rui						"ui/footer_button.rpak"
			zpos					3
			tall					36
			font                    Default_28
			labelText				"DEFAULT"
			enabled					1
			visible					1
			auto_wide_tocontents 	1
            behave_as_label         1
            ruiDefaultHeight        36
            fontHeight              32
		}
		
		MouseFooterButton
		{
			classname				MouseFooterButtonClass
			zpos					4
			auto_wide_tocontents 	1
			tall 					36
			labelText				"DEFAULT"
			font					Default_28
			textinsetx				22
			use_proportional_insets	1
			enabled					1
			visible					1
			IgnoreButtonA			1
			style					PCFooterButton
			childGroupFocused		PCFooterButtonFocusGroup
			activeInputExclusivePaint	keyboard
		}

		ButtonTooltip
		{
			classname				ButtonTooltip
			xpos					0
			ypos					0
			zpos					500
			wide					450
			tall					67
			visible					0
			controlSettingsFile		"resource/UI/menus/button_locked_tooltip.res"
		}

        TabButtonSeason
        {
            classname               TabButtonClass
            xpos					148
            ypos					0
            //zpos					10
            wide					636
            tall					84
            visible					1
            enabled					1
			style					RuiButton
            rui 					"ui/tab_button_season.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_focus             "UI_Menu_Focus_Large"
			sound_accept            "UI_Menu_ApexTab_Select"
        }

        Logo
        {
            classname               LogoRui
            xpos					-48
            ypos					0
            zpos					10
            wide					123
            tall					143
            visible					1
            proportionalToParent    1
            rui 					"ui/tab_logo.rpak"
        }

        MatchmakingStatus
        {
            classname		        MatchmakingStatusRui
            wide                    560
            wide_nx_handheld        644		[$NX || $NX_UI_PC]
            tall                    82
            tall_nx_handheld        94		[$NX || $NX_UI_PC]
            visible			        1
            rui                     "ui/matchmaking_status.rpak"
        }

		DeathScreenRecapBlock
		{
			wide					540
			tall					55
			tall_nx_handheld        33      [$NX || $NX_UI_PC]
			rui                     "ui/death_recap_damage_block.rpak"
			xpos                    0
			ypos                    3
			zpos                    0
			visible                 1
			enabled                 1
			cursorVelocityModifier  0.6
			pin_corner_to_sibling   BOTTOM
			pin_to_sibling_corner   TOP
		}
	}

	ButtonChildGroups
	{
		DefaultButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		DefaultButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
			}
		}
		DefaultButtonLockedGroup
		{
			LockImage
			{
				ControlName				ImagePanel
				xpos					12
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		DefaultButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					12
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// TODO: %100 should size automatically based on parent
		PCFooterButtonFocusGroup
		{
			Focus
			{
				ControlName				Label
				wide					674 //%100
				tall					36 //%100
				labelText				""
				visible					1
		        bgcolor_override		"255 255 255 127"
        		paintbackground 		1
			}
		}

		ChoiceButtonAlways
		{
            FULL
            {
                ControlName         RuiPanel
                InheritProperties   FullSizer
                zpos                -1
            }

            RightButton
            {
                ControlName				RuiButton
                rui						"ui/settings_choice_button.rpak"
                ruiArgs
                {
                    isRightOption       1
                }
                wide					178
                wide_nx_handheld		238 		[$NX || $NX_UI_PC]
                tall					60
                tall_nx_handheld		80 			[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                sound_accept			""

                command                 "DialogListSelect1"

                pin_corner_to_sibling	RIGHT
                pin_to_sibling			FULL
                pin_to_sibling_corner	RIGHT
            }

            LeftButton
            {
                ControlName				RuiButton
                rui						"ui/settings_choice_button.rpak"
                xpos                    4
                wide					178
                wide_nx_handheld		238 	[$NX || $NX_UI_PC]
                tall					60
                tall_nx_handheld		80 		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                sound_accept			""

                command                 "DialogListSelect0"

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			RightButton
                pin_to_sibling_corner	TOP_LEFT
            }

            ValueButton
            {
                ControlName				RuiPanel
                rui						"ui/settings_multichoice_value.rpak"
                wide					0
                tall					0
                visible					0
                enabled					1
                style					DefaultButton
                zpos                    4

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			LeftButton
                pin_to_sibling_corner	TOP_LEFT
            }
		}

		MultiChoiceButtonAlways
		{
            FULL
            {
                ControlName         RuiPanel
                InheritProperties   FullSizer
                zpos                -1
            }

            RightButton
            {
                ControlName				RuiButton
                rui						"ui/settings_change_button.rpak"
                ruiArgs
                {
                    isRightOption       1
                }
                wide					60
                wide_nx_handheld		90  	[$NX || $NX_UI_PC]
                tall					60
                tall_nx_handheld		80 		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                sound_accept			""

                command                 "DialogListNext"

                pin_corner_to_sibling	RIGHT
                pin_to_sibling			FULL
                pin_to_sibling_corner	RIGHT

                cursorVelocityModifier  0.7
            }

            LeftButton
            {
                ControlName				RuiButton
                rui						"ui/settings_change_button.rpak"
                wide					60
                wide_nx_handheld		90		[$NX || $NX_UI_PC]
                tall					60
                tall_nx_handheld		80		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4
                xpos                    4

                sound_accept			""

                command                 "DialogListPrev"

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			ValueButton
                pin_to_sibling_corner	TOP_LEFT

                cursorVelocityModifier  0.7
            }

            ValueButton
            {
                ControlName				RuiPanel
                rui						"ui/settings_multichoice_value.rpak"
                xpos                    4
                wide					232
                wide_nx_handheld		292  	[$NX || $NX_UI_PC]
                tall					60
                tall_nx_handheld		80 		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			RightButton
                pin_to_sibling_corner	TOP_LEFT
            }
		}

		MultiChoiceButtonWideAlways
        {
            FULL
            {
                ControlName         RuiPanel
                InheritProperties   FullSizer
                zpos                -1
            }

            RightButton
            {
                ControlName				RuiButton
                rui						"ui/settings_change_button.rpak"
                ruiArgs
                {
                    isRightOption       1
                }
                wide					60
                tall					60
                tall_nx_handheld		80 		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                sound_accept			""

                command                 "DialogListNext"

                pin_corner_to_sibling	RIGHT
                pin_to_sibling			FULL
                pin_to_sibling_corner	RIGHT

                cursorVelocityModifier  0.7
            }

            LeftButton
            {
                ControlName				RuiButton
                rui						"ui/settings_change_button.rpak"
                wide					60
                tall					60
                tall_nx_handheld		80		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4
                xpos                    4

                sound_accept			""

                command                 "DialogListPrev"

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			ValueButton
                pin_to_sibling_corner	TOP_LEFT

                cursorVelocityModifier  0.7
            }

            ValueButton
            {
                ControlName				RuiPanel
                rui						"ui/settings_multichoice_value.rpak"
                ruiArgs
                {
                    showWiderText           1
                }

                xpos                    4
                wide					400
                wide_nx_handheld		420  	[$NX || $NX_UI_PC]
                tall					60
                tall_nx_handheld		80 		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			RightButton
                pin_to_sibling_corner	TOP_LEFT
            }
        }

        MultiChoiceButtonClubsInviteSelectorAlways
        {
            FULL
            {
                ControlName         RuiPanel
                InheritProperties   FullSizer
                zpos                -1
            }

            LeftButton
            {
                ControlName				RuiButton
                rui						"ui/settings_change_button.rpak"
                wide					60
                tall					60
                tall_nx_handheld		80		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4
                xpos                    8

                sound_accept			""

                command                 "DialogListPrev"

                pin_corner_to_sibling	LEFT
                pin_to_sibling			FULL
                pin_to_sibling_corner	LEFT

                cursorVelocityModifier  0.7
            }

            RightButton
            {
                ControlName				RuiButton
                rui						"ui/settings_change_button.rpak"
                ruiArgs
                {
                    isRightOption       1
                }
                wide					60
                tall					60
                tall_nx_handheld		80 		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                sound_accept			""

                command                 "DialogListNext"

                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling			ValueButton
                pin_to_sibling_corner	TOP_RIGHT

                cursorVelocityModifier  0.7
            }

            ValueButton
            {
                ControlName				RuiPanel
                rui						"ui/settings_multichoice_value.rpak"
                ruiArgs
                {
                    showWiderText           1
                }

                wide					280
                wide_nx_handheld		345  	[$NX || $NX_UI_PC]
                tall					60
                tall_nx_handheld		80 		[$NX || $NX_UI_PC]
                visible					1
                enabled					1
                style					DefaultButton
                xpos                    0
                zpos                    4

                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling			LeftButton
                pin_to_sibling_corner	TOP_RIGHT
            }
        }

		GridPageCircleButtonAlways
		{
			ImageNormal
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos 					0
				ypos					0
				zpos					110
				image 					"vgui/combat_ring"
				visible					1
				scaleImage				1
			}
		}

		GridPageCircleButtonFocused
		{
			ImageFocused
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos 					0
				ypos					0
				zpos					110
				image 					"vgui/gradient_circle"
				drawColor				"255 255 255 64"
				visible					1
				scaleImage				1
			}
		}

		GridPageCircleButtonSelected
		{
			ImageSelected
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos 					0
				ypos					0
				zpos					110
				image 					"vgui/gradient_circle"
				visible					1
				scaleImage				1
			}
		}

		GridButtonAlwaysGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					101
				image 					"vgui/HUD/capture_point_status_a"
				visible					1
				scaleImage				1
			}

			ImageNormal
			{
				ControlName				ImagePanel
				wide					90
				tall					90
				xpos 					18
				ypos					18
				zpos					110
				image 					"vgui/HUD/capture_point_status_blue_a"
				visible					1
				scaleImage				1
			}
		}

		GridButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					102
				image 					"ui/menu/titanDecal_menu/decalSlot_hover"
				visible					1
				scaleImage				1
			}
		}

		GridButtonSelectedGroup
		{
			BackgroundSelected
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					103
				image 					"ui/menu/titanDecal_menu/decalSlot_selected"
				visible					1
				scaleImage				1
			}
		}

		GridButtonLockedGroup
		{
			BackgroundLocked
			{
				ControlName				ImagePanel
				wide					67
				tall					67
				xpos					0
				ypos					58
				zpos 					120
				image					"ui/menu/common/locked_icon"
				visible					1
				scaleImage				1
			}
		}

		GridButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				wide					58
				tall					58
				xpos					4
				ypos					63
				zpos 					119
				image					"ui/menu/common/newitemicon"
				visible					1
				scaleImage				1
			}
		}

		Test2ButtonAlwaysGroup
		{
			Background
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					101
				image 					"rui/menu/loadout_boxes/kit_box_bg"
				visible					1
				scaleImage				1
			}

			Item
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					110
				image 					"ui/test_button_item"
				visible					1
				scaleImage				1
			}
		}

		Test2ButtonFocusedGroup
		{
			Focused
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					102
				image 					"rui/menu/loadout_boxes/kit_box_bg_inverse"
				visible					1
				scaleImage				1
			}
		}

        Test2ButtonNewGroup
        {
			NewEffect
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					102
				image 					"ui/test_button_new"
				visible					1
				scaleImage				1
			}
        }
	}
}
