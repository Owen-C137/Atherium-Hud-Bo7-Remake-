-- Aetherium Player Info Widget (Bottom Left - Main Player)
-- Uses: i_mtl_ui_hud_player_info_theme_aetherium
-- BO6 Pattern: Uses linkToElementModel for dynamic clientNum subscription

require( "ui.uieditor.widgets.HUD.AetheriumWidgets.AetheriumPlusPointsContainer" )
require("ui.uieditor.widgets.HUD.Mappings.AetheriumBBG")

CoD.AetheriumPlayerInfo = InheritFrom( LUI.UIElement )
CoD.AetheriumPlayerInfo.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	self:setUseStencil( false )
	self:setClass( CoD.AetheriumPlayerInfo )
	self.id = "AetheriumPlayerInfo"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	-- Main Player Info Background (elem7)
	self.player = LUI.UIImage.new()
	self.player:setLeftRight(true, false, 16, 360)
	self.player:setTopBottom(true, false, 595, 710)
	self.player:setImage( RegisterImage( "i_mtl_ui_hud_player_info_theme_aetherium" ) )
	self.player:setRGB( 1.000, 1.000, 1.000 )
	self.player:setAlpha( 1.0 )
	self:addElement( self.player )

	-- Salvage Icon (elem6)
	self.salvage_icon = LUI.UIImage.new()
	self.salvage_icon:setLeftRight(true, false, 89, 105)
	self.salvage_icon:setTopBottom(true, false, 662, 677)
	self.salvage_icon:setImage( RegisterImage( "i_mtl_ui_icons_zombie_squad_info_salvage" ) )
	self.salvage_icon:setRGB( 1.000, 1.000, 1.000 )
	self.salvage_icon:setAlpha( 1.0 )
	self:addElement( self.salvage_icon )

	-- Salvage Amount (elem3) - TEXT
	self.salvage_amount = LUI.UIText.new()
	self.salvage_amount:setLeftRight(true, false, 105, 178)
	self.salvage_amount:setTopBottom(true, false, 665, 676)
	self.salvage_amount:setTTF( "fonts/ltromatic.ttf" )
	self.salvage_amount:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.salvage_amount:setRGB( 1.000, 1.000, 1.000 )
	self.salvage_amount:setText( Engine.Localize( "500000" ) )
	self.salvage_amount:setAlpha( 1.0 )
	self:addElement( self.salvage_amount )

	-- Points Icon (elem5)
	self.points_icon = LUI.UIImage.new()
	self.points_icon:setLeftRight(true, false, 157, 173)
	self.points_icon:setTopBottom(true, false, 664, 677)
	self.points_icon:setImage( RegisterImage( "i_mtl_ui_icons_zombie_essence" ) )
	self.points_icon:setRGB( 1.000, 1.000, 1.000 )
	self.points_icon:setAlpha( 1.0 )
	self:addElement( self.points_icon )

	-- Points Amount (elem4) - TEXT (reactive to playerScore)
	self.points_amount = LUI.UIText.new()
	self.points_amount:setLeftRight(true, false, 172, 239)
	self.points_amount:setTopBottom(true, false, 666, 677)
	self.points_amount:setTTF( "fonts/ltromatic.ttf" )
	self.points_amount:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.points_amount:setRGB(0.984313725490196, 0.9725490196078431, 0.4745098039215686)
	self.points_amount:linkToElementModel( self, "playerScore", true, function ( model )
		local playerScore = Engine.GetModelValue( model )
		if playerScore then
			self.points_amount:setText( Engine.Localize( playerScore ) )
		end
	end )
	self.points_amount:setAlpha( 1.0 )
	self:addElement( self.points_amount )

	-- Player Name (elem28) - TEXT (reactive to playerName)
	self.player_name = LUI.UIText.new()
	self.player_name:setLeftRight(true, false, 98, 199)
	self.player_name:setTopBottom(true, false, 636, 647)
	self.player_name:setTTF( "fonts/ltromatic.ttf" )
	self.player_name:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.player_name:setRGB( 1.000, 1.000, 1.000 )
	self.player_name:linkToElementModel( self, "playerName", true, function ( model )
		local playerName = Engine.GetModelValue( model )
		if playerName then
			self.player_name:setText( Engine.Localize( playerName ) )
		end
	end )
	self.player_name:setAlpha( 1.0 )
	self:addElement( self.player_name )

	-- Shield Health Bar (Blue bar above normal health bar)
	self.shield_health_fill = LUI.UIImage.new()
	self.shield_health_fill:setLeftRight(true, false, 94, 221)
	self.shield_health_fill:setTopBottom(true, false, 641, 648)
	self.shield_health_fill:setImage( RegisterImage( "i_mtl_ui_hud_party_health_bar_fill" ) )
	self.shield_health_fill:setRGB( 0.4, 0.7, 1 )  -- Blue color for shield
	self.shield_health_fill:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.shield_health_fill:setShaderVector( 0, 0, 0, 0, 0 )  -- Start at 0 (hidden)
	self.shield_health_fill:setShaderVector( 1, 0, 0, 0, 0 )
	self.shield_health_fill:setShaderVector( 2, 1, 0, 0, 0 )
	self.shield_health_fill:setShaderVector( 3, 0, 0, 0, 0 )
	self.shield_health_fill:setAlpha( 0 )  -- Hidden by default (no shield)
	self:addElement( self.shield_health_fill )

	-- Health Fill (added BEFORE border so border renders on top)
	self.health_fill = LUI.UIImage.new()
	self.health_fill:setLeftRight(true, false, 94, 221)
	self.health_fill:setTopBottom(true, false, 649, 656)
	self.health_fill:setImage( RegisterImage( "i_mtl_ui_hud_player_health_bar_fill" ) )
	self.health_fill:setRGB( 1, 1, 1 )
	self.health_fill:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.health_fill:setShaderVector( 0, 1, 0, 0, 0 )
	self.health_fill:setShaderVector( 1, 0, 0, 0, 0 )
	self.health_fill:setShaderVector( 2, 1, 0, 0, 0 )
	self.health_fill:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.health_fill )

	-- Health Border (added AFTER fill - renders on top)
	self.health_border = LUI.UIImage.new()
	self.health_border:setLeftRight(true, false, 93, 222)
	self.health_border:setTopBottom(true, false, 648, 657)
	self.health_border:setImage( RegisterImage( "i_mtl_ui_hud_player_health_bar_border" ) )
	self.health_border:setRGB( 1, 1, 1 )
	self:addElement( self.health_border )

	-- Downed Indicator (Player 1 - Local Player)
	self.downedIcon = LUI.UIImage.new()
	self.downedIcon:setLeftRight(true, false, 223, 253)
	self.downedIcon:setTopBottom(true, false, 638, 668)
	self.downedIcon:setImage(RegisterImage("i_mtl_icon_ping_downed"))
	self.downedIcon:setRGB(1, 1, 1)
	self.downedIcon:setAlpha(0)  -- Hidden by default
	self:addElement(self.downedIcon)

	-- Player HP (elem29) - TEXT (reactive to player_health_X)
	self.player_hp = LUI.UIText.new()
	self.player_hp:setLeftRight(true, false, 190, 241)
	self.player_hp:setTopBottom(true, false, 640, 647)
	self.player_hp:setText( Engine.Localize( "" ) )
	self.player_hp:setTTF( "fonts/ltromatic.ttf" )
	self.player_hp:setRGB( 1.0, 1.0, 1.0 )
	self.player_hp:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	self:addElement( self.player_hp )
	
	-- Player Character Portrait (elem32) - IMAGE (reactive to zombiePlayerIcon)
	self.player_portrait = LUI.UIImage.new()
	self.player_portrait:setLeftRight(true, false, 36, 87)
	self.player_portrait:setTopBottom(true, false, 625, 684)
	self.player_portrait:setImage( RegisterImage( "blacktransparent" ) )
	self.player_portrait:linkToElementModel( self, "zombiePlayerIcon", true, function ( model )
		local zombiePlayerIcon = Engine.GetModelValue( model )
		if zombiePlayerIcon then
			-- Map character IDs to icon names
			if zombiePlayerIcon == "uie_t7_zm_hud_score_char1" then
				zombiePlayerIcon = "i_mtl_ui_icon_operators_nikolai"
			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char2" then
				zombiePlayerIcon = "i_mtl_ui_icon_operators_takeo"
			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char3" then
				zombiePlayerIcon = "i_mtl_ui_icon_operators_dempsey"
			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char4" then
				zombiePlayerIcon = "i_mtl_ui_icon_operators_richtofen"
			end
			self.player_portrait:setImage( RegisterImage( zombiePlayerIcon ) )
		end
	end )
	self:addElement( self.player_portrait )


	-- Dead State Overlay (Red X over portrait)
	self.deadOverlay = LUI.UIImage.new()
	self.deadOverlay:setLeftRight(true, false, 42, 91)
	self.deadOverlay:setTopBottom(true, false, 628, 686)
	self.deadOverlay:setImage(RegisterImage("i_mtl_image_4b496d8bd0369913"))
	self.deadOverlay:setRGB(1, 0.2, 0.2)  -- Red
	self.deadOverlay:setAlpha(0)  -- Hidden by default
	self:addElement(self.deadOverlay)
	
	-- Shield Icon (shows when shield is equipped)
	self.shield_icon = LUI.UIImage.new()
	self.shield_icon:setLeftRight(true, false, 230, 253)
	self.shield_icon:setTopBottom(true, false, 635, 658)
	self.shield_icon:setImage(RegisterImage("riotshield_zm_icon"))
	self.shield_icon:setRGB(1, 1, 1)
	self.shield_icon:setAlpha(0)  -- Hidden by default
	self:addElement(self.shield_icon)
	
	-- BO6 PATTERN: Dynamic health subscription based on clientNum
	-- This ensures each player viewing the HUD sees THEIR OWN health
	self:linkToElementModel( self, "clientNum", true, function ( clientModel )
		local clientNum = Engine.GetModelValue( clientModel )
		
		if clientNum then
			self.currentClientNum = clientNum
			
			-- Timer-based death detection
			self.deathCheckTimer = nil
			self.isDownedState = false
			self.isDeadState = false
			self.currentGobbleGum = nil  -- Track active gobblegum
			
			-- Subscribe to bgb_current model for this player to detect Coagulant
			local bgbModel = Engine.GetModel( Engine.GetModelForController( controller ), "bgb_current" )
			if bgbModel then
				self:subscribeToModel( bgbModel, function( model )
					local bgbIndex = Engine.GetModelValue( model )
					self.currentGobbleGum = bgbIndex
					-- Coagulant is index 3 in AetheriumBBG.lua
				end )
			end
			
			local controllerModel = Engine.GetModelForController( controller )
			local healthModel = Engine.GetModel( controllerModel, "player_health_" .. clientNum )
			
			-- Remove old subscription if it exists
			if self.healthSubscription ~= nil then
				self:removeSubscription( self.healthSubscription )
			end
			
			-- Subscribe to the correct health model for this player
			self.healthSubscription = self:subscribeToModel( healthModel, function ( model )
				local health = Engine.GetModelValue( model )
				if health then
					-- Update HP text (BO3 default: 100 base, 200 with Jug)
					local maxHealth = 100
					local currentHealth = math.ceil( health * maxHealth )
					self.player_hp:setText( Engine.Localize( currentHealth .. " HP" ) )
					
					-- Check if downed (HP = 0) or alive (HP > 0)
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
							
							-- Show downed visuals
							self.health_fill:completeAnimation()
							self.downedIcon:setAlpha(1)
							self.downedIcon:setRGB(1, 0.2, 0.2)
							self.health_fill:setRGB(1, 0.2, 0.2)
							self.health_fill:setAlpha(1)
							self.health_border:setAlpha(1)
							self.health_fill:setShaderVector( 0, 1, 0, 0, 0 )
							self.health_fill:beginAnimation("bleedout_timer", bleedoutTime, false, false, CoD.TweenType.Linear)
							self.health_fill:setShaderVector( 0, 0, 0, 0, 0 )
							self.deadOverlay:setAlpha(0)
							self.player_portrait:setRGB(1, 1, 1)
							self.player_name:setRGB(1, 1, 1)
							self.points_icon:setAlpha(1)
							self.points_amount:setAlpha(1)
							self.player_hp:setAlpha(1)
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
						
						-- Show alive visuals
						self.health_fill:completeAnimation()
						self.downedIcon:setAlpha(0)
						self.deadOverlay:setAlpha(0)
						self.downedIcon:setRGB(1, 1, 1)
						self.health_fill:setRGB(1, 1, 1)  -- Reset health bar to white
						self.player_portrait:setRGB(1, 1, 1)
						self.player_name:setRGB(1, 1, 1)
						self.health_fill:setAlpha(1)
						self.health_border:setAlpha(1)
						self.points_icon:setAlpha(1)
						self.points_amount:setAlpha(1)
						self.player_hp:setAlpha(1)
						
						-- Update health bar fill with smooth animation
						self.health_fill:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
						self.health_fill:setShaderVector( 0,
							CoD.GetVectorComponentFromString( health, 1 ),
							CoD.GetVectorComponentFromString( health, 2 ),
							CoD.GetVectorComponentFromString( health, 3 ),
							CoD.GetVectorComponentFromString( health, 4 ) )
					end
				end
			end )
			
			-- Subscribe to shield health (riot shield)
			local shieldHealthModel = Engine.GetModel( controllerModel, "zmInventory.shield_health" )
			
			-- Remove old shield subscription if it exists
			if self.shieldSubscription ~= nil then
				self:removeSubscription( self.shieldSubscription )
			end
			
			-- Subscribe to shield health model
			self.shieldSubscription = self:subscribeToModel( shieldHealthModel, function ( model )
				local shieldHealth = Engine.GetModelValue( model )
				if shieldHealth then
					-- Check if shield is actually equipped (showDpadDown > 0 means shield is held)
					local showDpadDown = Engine.GetModelValue( Engine.GetModel( controllerModel, "hudItems.showDpadDown" ) )
					
					-- Shield health is 0-1 range (0 = no shield, 1 = full shield)
					-- Only show if shield is equipped AND has health
					if showDpadDown ~= nil and showDpadDown > 0 and shieldHealth > 0 then
					-- Has shield equipped - show shield bar and icon
					self.shield_health_fill:setAlpha( 1 )
					self.shield_icon:setAlpha( 1 )
				
				-- Move player name UP to sit above shield bar (smooth animation)
				self.player_name:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
					self.player_name:setTopBottom(true, false, 630, 641)
				self.player_hp:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.player_hp:setTopBottom(true, false, 632, 639)				
				-- Move downed icon to RIGHT of shield icon to prevent overlap (smooth animation)
				self.downedIcon:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.downedIcon:setLeftRight(true, false, 257, 292)		
				self.downedIcon:setTopBottom(true, false, 628, 663)		
				-- Update shield bar fill immediately (no animation - shows every damage hit)
				self.shield_health_fill:setShaderVector( 0,
						CoD.GetVectorComponentFromString( shieldHealth, 1 ),
						CoD.GetVectorComponentFromString( shieldHealth, 2 ),
						CoD.GetVectorComponentFromString( shieldHealth, 3 ),
						CoD.GetVectorComponentFromString( shieldHealth, 4 ) )
					
					-- Color based on shield health (blue at full, red when low)
					if shieldHealth <= 0.33 then
						self.shield_health_fill:setRGB( 1, 0.4, 0.4 )  -- Red when low
					elseif shieldHealth <= 0.66 then
						self.shield_health_fill:setRGB( 1, 0.8, 0.4 )  -- Orange/Yellow when medium
					else
						self.shield_health_fill:setRGB( 0.4, 0.7, 1 )  -- Blue when high
					end
				else
					-- No shield equipped or no health - hide shield bar and icon
					self.shield_health_fill:setAlpha( 0 )
					self.shield_icon:setAlpha( 0 )
				
				-- Move player name back DOWN to original position
				self.player_name:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.player_name:setTopBottom(true, false, 636, 647)
				
				-- Move HP text back DOWN to original position
				self.player_hp:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.player_hp:setTopBottom(true, false, 640, 647)
				
				-- Move downed icon back to original position (smooth animation)
				self.downedIcon:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
				self.downedIcon:setLeftRight(true, false, 223, 253)
			end
				end
			end )
		end
	end )
	
	-- Timer event handler for death check
	self:registerEventHandler("death_check_timer", function()
		-- Get current client number and health
		if self.currentClientNum ~= nil then
			local healthModel = Engine.GetModel( Engine.GetModelForController( controller ), "player_health_" .. self.currentClientNum )
			if healthModel ~= nil then
				local health = Engine.GetModelValue(healthModel)
				if health ~= nil then
					local maxHealth = 100
					local currentHealth = math.ceil( health * maxHealth )
					
					if currentHealth <= 0 then
						-- Still HP=0 after timer = DEAD (bled out)
						self.isDeadState = true
						self.isDownedState = false
						
						-- Show dead visuals
						self.health_fill:completeAnimation()
						self.health_fill:setAlpha(0)
						self.health_border:setAlpha(0)
						self.points_icon:setAlpha(0)
						self.points_amount:setAlpha(0)
						self.player_hp:setAlpha(0)
						self.downedIcon:setAlpha(0)
						self.deadOverlay:setAlpha(1)
						self.player_portrait:setRGB(0.3, 0.3, 0.3)
						self.player_name:setRGB(1, 0.2, 0.2)
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
			end
		end
	end)

	-- Points Delta Container (holds dynamically created popups - vanilla BO3 pattern)
	self.pointsDeltaContainer = LUI.UIElement.new()
	self.pointsDeltaContainer:setLeftRight( true, false, 223, 273 )  -- Match reference position
	self.pointsDeltaContainer:setTopBottom( true, false, 664, 671 )
	self.pointsDeltaContainer.lastAnim = 0
	self:addElement( self.pointsDeltaContainer )

	-- Subscribe to score_cf models (vanilla BO3 pattern - damage, death, etc.)
	-- This triggers the points popups
	self:linkToElementModel( self, "clientNum", true, function ( clientModel )
		local clientNum = Engine.GetModelValue( clientModel )
		
		if clientNum then
			local controllerModel = Engine.GetModelForController( controller )
			local clientScoreModel = Engine.GetModel( controllerModel, "PlayerList.client" .. clientNum )
			
			if clientScoreModel then
				-- Score types from vanilla ZMScr (damage, death_normal, etc.)
				local scoreTypes = {
					damage = 10,
					death_normal = 50,
					death_melee = 130,
					death_torso = 60,
					death_neck = 100,
					death_head = 100,
					reward = 50
				}
				
				-- Subscribe to each score_cf model
				for scoreType, scoreValue in pairs( scoreTypes ) do
					local scoreModel = Engine.CreateModel( clientScoreModel, "score_cf_" .. scoreType )
					if scoreModel then
						self:subscribeToModel( scoreModel, function ( model )
							local modelValue = Engine.GetModelValue( model )
							if modelValue ~= nil and modelValue ~= 0 then
								-- Calculate points (with double points check)
								local points = scoreValue
								local doublePointsModel = Engine.GetModel( controllerModel, "hudItems.doublePointsActive" )
								if doublePointsModel and Engine.GetModelValue( doublePointsModel ) == 1 then
									points = points * 2
								end
								
								-- Create popup (vanilla BO3 pattern)
								if points ~= 0 and points >= -10000 and points <= 10000 then
									local popup = CoD.AetheriumPlusPointsContainer.new( menu, controller )
									
									-- Set text and color
									if points > 0 then
										popup.AetheriumPlusPoints.Label:setText( "+" .. points )
										popup.AetheriumPlusPoints.Label:setRGB( 0.9725, 0.9607, 0.4706 )  -- Yellow
									else
										popup.AetheriumPlusPoints.Label:setText( points )
										popup.AetheriumPlusPoints.Label:setRGB( 1, 0.3, 0.3 )  -- Red
									end
									
									-- Position popup at container location
									popup:setLeftRight( self.pointsDeltaContainer:getLocalLeftRight() )
									popup:setTopBottom( self.pointsDeltaContainer:getLocalTopBottom() )
									
									-- Close on animation complete
									popup:registerEventHandler( "clip_over", function ( element, event )
										element:close()
									end )
									
									-- Add to player widget (not container)
									self:addElement( popup )
									
									-- Play animation
									self.pointsDeltaContainer.lastAnim = self.pointsDeltaContainer.lastAnim + 1
									if self.pointsDeltaContainer.lastAnim > 1 then
										self.pointsDeltaContainer.lastAnim = 1
									end
									popup:playClip( "Anim1" )
									popup.AetheriumPlusPoints:playClip( "FadeOut" )
								end
							end
						end )
					end
				end
			end
		end
	end )

	return self
end
