-- Aetherium Party Players Widget - Dynamic positioning based on player index
-- Handles all 3 co-op party members (indices 1, 2, 3) with a single widget
-- Based on official BO3 pattern for dynamic player widgets

require("ui.uieditor.widgets.HUD.Mappings.AetheriumBBG")

local PostLoadFunc = function ( self, controller )
	-- Hide widget by default (only show when valid clientNum exists)
	self:setAlpha(0)
	
	-- Timer-based death detection
	self.deathCheckTimer = nil
	self.isDownedState = false
	self.isDeadState = false
	self.currentGobbleGum = nil  -- Track active gobblegum
	self.isPlayerSlotOccupied = false  -- Initialize visibility flag
	
	-- Subscribe to player health dynamically based on clientNum (BO6 Overhaul pattern)
	self:linkToElementModel( self, "clientNum", true, function ( clientModel )
		local clientNum = Engine.GetModelValue( clientModel )
		
		if clientNum ~= nil then
			self.currentClientNum = clientNum
			-- Note: lastHealthValue is NOT reset here to prevent health bar jumping on round change
			
			-- Remove old subscription if exists
			if self.healthSubscription ~= nil then
				self:removeSubscription( self.healthSubscription )
			end
			
			-- Subscribe to bgb_current model for this player to detect Coagulant
			local bgbModel = Engine.GetModel( Engine.GetModelForController( controller ), "bgb_current" )
			if bgbModel then
				self:subscribeToModel( bgbModel, function( model )
					local bgbIndex = Engine.GetModelValue( model )
					self.currentGobbleGum = bgbIndex
					-- Coagulant is index 3 in AetheriumBBG.lua
				end )
			end
			
			-- Subscribe to health model for this client number
			local healthModel = Engine.GetModel( Engine.GetModelForController( controller ), "player_health_" .. clientNum )
			if healthModel ~= nil then
				self.healthSubscription = self:subscribeToModel( healthModel, function ( model )
					local health = Engine.GetModelValue( model )
					if health ~= nil then
						local maxHealth = 100
						local currentHealth = math.ceil( health * maxHealth )
						
						if currentHealth <= 0 then
							-- DOWNED STATE
							if self.isDeadState then
								-- Already dead, keep dead visuals
							elseif not self.isDownedState then
								-- First time hitting 0 HP - start downed state
								self.isDownedState = true
								
								-- Check if player has Coagulant gobblegum (index 3)
								local bleedoutTime = 45000  -- Default: 45 seconds
								if self.currentGobbleGum == 3 then
									bleedoutTime = 135000  -- Coagulant: 135 seconds (3x longer)
								end
								
								-- Cancel any existing timer
								if self.deathCheckTimer ~= nil then
									self:removeElement(self.deathCheckTimer)
									self.deathCheckTimer = nil
								end
								
								-- Start death check timer (45s or 135s based on gobblegum)
								self.deathCheckTimer = LUI.UITimer.new(bleedoutTime, "death_check_timer", false)
								self:addElement(self.deathCheckTimer)
								
								-- Show downed visuals (only if player slot is occupied)
								self.health_fill:completeAnimation()
								if self.isPlayerSlotOccupied then
									self.downedIcon:setAlpha(1)
									self.health_fill:setAlpha(1)
									self.health_border:setAlpha(1)
									self.essence_icon:setAlpha(1)
									self.points:setAlpha(1)
								end
								self.downedIcon:setRGB(1, 0.2, 0.2)
								self.health_fill:setRGB(1, 0.2, 0.2)
								self.health_fill:setShaderVector( 0, 1, 0, 0, 0 )
								self.health_fill:beginAnimation("bleedout_timer", bleedoutTime, false, false, CoD.TweenType.Linear)
								self.health_fill:setShaderVector( 0, 0, 0, 0, 0 )
								self.deadOverlay:setAlpha(0)
								self.portrait:setRGB(1, 1, 1)
								self.name:setRGB(1, 1, 1)
							end
						else
							-- ALIVE STATE (HP > 0) - RESET everything
							-- Cancel timer if exists
							if self.deathCheckTimer ~= nil then
								self:removeElement(self.deathCheckTimer)
								self.deathCheckTimer = nil
							end
							
							-- Reset flags
							self.isDownedState = false
							self.isDeadState = false
							
							-- Show alive visuals (only if player slot is occupied)
							self.health_fill:completeAnimation()
							self.downedIcon:setAlpha(0)
							self.deadOverlay:setAlpha(0)
							self.portrait:setRGB(1, 1, 1)
							self.name:setRGB(1, 1, 1)
							self.health_fill:setRGB(1, 1, 1)  -- Reset health bar to white
							if self.isPlayerSlotOccupied then
								self.health_fill:setAlpha(1)
								self.health_border:setAlpha(1)
								self.essence_icon:setAlpha(1)
								self.points:setAlpha(1)
							end
							
							-- Update health bar fill with animation (BO6 Overhaul pattern - always animate)
							self.health_fill:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
							self.health_fill:setShaderVector( 0,
								CoD.GetVectorComponentFromString( health, 1 ),
								CoD.GetVectorComponentFromString( health, 2 ),
								CoD.GetVectorComponentFromString( health, 3 ),
								CoD.GetVectorComponentFromString( health, 4 ) )
						end
					end
				end )
				
				-- Timer expired - check if still downed (HP=0)
				self:registerEventHandler("death_check_timer", function()
					-- Get current health
					local health = Engine.GetModelValue(healthModel)
					if health ~= nil then
						local maxHealth = 100
						local currentHealth = math.ceil( health * maxHealth )
						
						if currentHealth <= 0 then
							-- Still HP=0 after timer = DEAD (bled out)
							self.isDeadState = true
							self.isDownedState = false

							self.health_border:setAlpha(0)
							self.essence_icon:setAlpha(0)
							self.points:setAlpha(0)
							self.downedIcon:setAlpha(0)
							self.deadOverlay:setAlpha(1)
							self.portrait:setRGB(0.3, 0.3, 0.3)
							self.name:setRGB(1, 0.2, 0.2)
						else
							-- Got revived before timer expired
							self.isDownedState = false
						end
						
						-- Cleanup timer
						if self.deathCheckTimer ~= nil then
							self:removeElement(self.deathCheckTimer)
							self.deathCheckTimer = nil
						end
					end
				end)
			end
		end
	end )
end

CoD.AetheriumPartyPlayers = InheritFrom( LUI.UIElement )
CoD.AetheriumPartyPlayers.new = function ( menu, controller, playerIndex )
	local self = LUI.UIElement.new()

	self:setUseStencil( false )
	self:setClass( CoD.AetheriumPartyPlayers )
	self.id = "AetheriumPartyPlayers"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	-- DYNAMIC POSITIONING BASED ON PLAYER INDEX
	-- Player index 1 (bottom):  Y 524-611  (BG height: 87px)
	-- Player index 2 (middle):  Y 481-568  (offset: -43px from index 1)
	-- Player index 3 (top):     Y 439-526  (offset: -42px from index 2)
	local baseYTop = 524  -- Player 1 base position
	local yOffset = (playerIndex == 2 and -43) or (playerIndex == 3 and -85) or 0
	local bgTop = baseYTop + yOffset
	local bgBottom = bgTop + 87  -- Height is 87 pixels

	-- Background
	self.bg = LUI.UIImage.new()
	self.bg:setLeftRight( true, false, 43, 319 )
	self.bg:setTopBottom( true, false, bgTop, bgBottom )
	self.bg:setImage( RegisterImage( "i_mtl_ui_hud_party_member_theme_aetherium" ) )
	self.bg:setRGB( 1, 1, 1 )
	self.bg:setAlpha( 0 )
	self:addElement( self.bg )

	-- Player Portrait (offset from BG top)
	local portraitTop = bgTop + 19
	local portraitBottom = portraitTop + 40
	self.portrait = LUI.UIImage.new()
	self.portrait:setLeftRight( true, false, 64, 99 )
	self.portrait:setTopBottom( true, false, portraitTop, portraitBottom )
	self.portrait:setImage( RegisterImage( "blacktransparent" ) )
	self.portrait:setAlpha( 0 )
	self:addElement( self.portrait )

	-- Player Name (offset from BG top)
	local nameTop = bgTop + 34
	local nameBottom = nameTop + 9
	self.name = LUI.UIText.new()
	self.name:setLeftRight(true, false, 107, 199)
	self.name:setTopBottom(true, false, nameTop, nameBottom)
	self.name:setText( Engine.Localize( "Player" ) )
	self.name:setTTF( "fonts/ltromatic.ttf" )
	self.name:setRGB( 1, 1, 1 )
	self.name:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.name:setAlpha( 0 )
	self:addElement( self.name )

	-- Health Fill (offset from BG top) - 1px insets
	local healthFillTop = bgTop + 45
	local healthFillBottom = healthFillTop + 5
	self.health_fill = LUI.UIImage.new()
	self.health_fill:setLeftRight(true, false, 108, 221)
	self.health_fill:setTopBottom(true, false, healthFillTop, healthFillBottom)
	self.health_fill:setImage( RegisterImage( "i_mtl_ui_hud_party_health_bar_fill" ) )
	self.health_fill:setRGB( 1, 1, 1 )
	self.health_fill:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.health_fill:setShaderVector( 0, 1, 0, 0, 0 )
	self.health_fill:setShaderVector( 1, 0, 0, 0, 0 )
	self.health_fill:setShaderVector( 2, 1, 0, 0, 0 )
	self.health_fill:setShaderVector( 3, 0, 0, 0, 0 )
	self.health_fill:setAlpha( 0 )
	self:addElement( self.health_fill )

	-- Health Border (offset from BG top)
	local healthBorderTop = bgTop + 44
	local healthBorderBottom = healthBorderTop + 7
	self.health_border = LUI.UIImage.new()
	self.health_border:setLeftRight(true, false, 107, 222)
	self.health_border:setTopBottom(true, false, healthBorderTop, healthBorderBottom)
	self.health_border:setImage( RegisterImage( "i_mtl_ui_hud_player_health_bar_border" ) )
	self.health_border:setRGB( 1, 1, 1 )
	self.health_border:setAlpha( 0 )
	self:addElement( self.health_border )

	-- Essence Icon (offset from BG top)
	local essenceTop = bgTop + 39
	local essenceBottom = essenceTop + 15
	self.essence_icon = LUI.UIImage.new()
	self.essence_icon:setLeftRight(true, false, 223, 240)
	self.essence_icon:setTopBottom(true, false, essenceTop, essenceBottom)
	self.essence_icon:setImage( RegisterImage( "i_mtl_ui_icons_zombie_essence" ) )
	self.essence_icon:setRGB( 1, 1, 1 )
	self.essence_icon:setAlpha( 0 )
	self:addElement( self.essence_icon )

	-- Points (offset from BG top)
	local pointsTop = bgTop + 41
	local pointsBottom = pointsTop + 11
	self.points = LUI.UIText.new()
	self.points:setLeftRight(true, false, 239, 325)
	self.points:setTopBottom(true, false, pointsTop, pointsBottom)
	self.points:setText( Engine.Localize( "0" ) )
	self.points:setTTF( "fonts/ltromatic.ttf" )
	self.points:setRGB(0.9803921568627451, 0.9686274509803922, 0.4666666666666667)
	self.points:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	self.points:setAlpha( 0 )
	self:addElement( self.points )

	-- Downed Icon (offset from BG top)
	local downedTop = bgTop + 15
	local downedBottom = downedTop + 24
	self.downedIcon = LUI.UIImage.new()
	self.downedIcon:setLeftRight(true, false, 173, 197)
	self.downedIcon:setTopBottom(true, false, downedTop, downedBottom)
	self.downedIcon:setImage(RegisterImage("i_mtl_icon_ping_downed"))
	self.downedIcon:setRGB(1, 1, 1)
	self.downedIcon:setAlpha(0)  -- Hidden by default
	self:addElement(self.downedIcon)

	-- Dead State Overlay (offset from BG top)
	local deadOverlayTop = bgTop + 20
	local deadOverlayBottom = deadOverlayTop + 38
	self.deadOverlay = LUI.UIImage.new()
	self.deadOverlay:setLeftRight(true, false, 66, 98)
	self.deadOverlay:setTopBottom(true, false, deadOverlayTop, deadOverlayBottom)
	self.deadOverlay:setImage(RegisterImage("i_mtl_image_4b496d8bd0369913"))
	self.deadOverlay:setRGB(1, 0.2, 0.2)  -- Red
	self.deadOverlay:setAlpha(0)  -- Hidden by default
	self:addElement(self.deadOverlay)
	
	-- Portrait - reactive subscription
	self.portrait:linkToElementModel( self, "zombiePlayerIcon", true, function ( model )
		local zombiePlayerIcon = Engine.GetModelValue( model )
		if zombiePlayerIcon then
			if zombiePlayerIcon == "uie_t7_zm_hud_score_char1" then
				zombiePlayerIcon = "i_mtl_ui_icon_operators_nikolai"
			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char2" then
				zombiePlayerIcon = "i_mtl_ui_icon_operators_takeo"
			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char3" then
				zombiePlayerIcon = "i_mtl_ui_icon_operators_dempsey"
			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char4" then
				zombiePlayerIcon = "i_mtl_ui_icon_operators_richtofen"
			end
			self.portrait:setImage( RegisterImage( zombiePlayerIcon ) )
		end
	end )

	-- Name - reactive subscription (BO6 Overhaul pattern)
	self.name:linkToElementModel( self, "playerName", true, function ( model )
		local name = Engine.GetModelValue( model )
		if name then
			self.name:setText( Engine.Localize( name ) )
		end
	end )

	-- Score - reactive subscription
	self.points:linkToElementModel( self, "playerScore", true, function ( model )
		local playerScore = Engine.GetModelValue( model )
		if playerScore then
			self.points:setText( Engine.Localize( playerScore ) )
		end
	end )

	-- Visibility - reactive subscription (controlled by BO3 engine - hides in solo)
	self:linkToElementModel( self, "playerScoreShown", true, function ( model )
		local playerScoreShown = Engine.GetModelValue( model )
		-- Track if player slot is occupied
		self.isPlayerSlotOccupied = (playerScoreShown and playerScoreShown ~= 0)
		local alpha = self.isPlayerSlotOccupied and 1 or 0
		self.bg:setAlpha( alpha )
		self.portrait:setAlpha( alpha )
		self.name:setAlpha( alpha )
		self.health_fill:setAlpha( alpha )
		self.health_border:setAlpha( alpha )
		self.essence_icon:setAlpha( alpha )
		self.points:setAlpha( alpha )
	end )

	-- Visibility controlled by health subscription - widget shows when clientNum is assigned
	-- All element alpha is managed in the health subscription above

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.bg:close()
		element.portrait:close()
		element.name:close()
		element.health_fill:close()
		element.health_border:close()
		element.essence_icon:close()
		element.points:close()
		element.downedIcon:close()
		element.deadOverlay:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end

	return self
end
