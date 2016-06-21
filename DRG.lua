include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
 
-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.
 
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
     
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end
 
-- Setup vars that are user-independent.
function job_setup()
	state.WeaponMode = M{['description']='Weapon Mode', 'Polearm', 'Staff', 'Club', 'Dagger', 'Sword'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
	pick_tp_weapon()
end
 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	-- add_to_chat(122,'user setup')
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('Polearm')
	state.Stance:set('Offensive')
	Twilight = false

	select_default_macro_book()
end
 
-- Called when this job file is unloaded (eg: job change)
function file_unload()
    if binds_on_unload then
        binds_on_unload()
    end
 
    send_command('unbind ^`')
    send_command('unbind !-')
end
 
 
-- Define sets and vars used by this job file.
function init_gear_sets()
	-- add_to_chat(122,'init gear sets')
	-- Extra stuff (and new gear)
	organizer_items = {
		new1="",
		new2="",
		new3="",
		new5="",
		food1="Squid Sushi",
		food2="Red Curry Bun",
		food3="Akamochi",
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	-- Idle sets
	sets.idle = {head="Twilight Helm",neck="Twilight Torque",ear1="Ethereal Earring",ear2="Moonshade Earring",
			body="Twilight Mail",hands="Sulev. Gauntlets +1",ring1="Patricius Ring",ring2="Renaye Ring",
			back="Mecisto. Mantle",waist="Incarnation Sash",legs="Carmine Cuisses",feet="Sulev. Leggings +1"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {ammo="Potestas Bomblet",
			head="Valorous Mask",neck="Ganesha's Mala",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Emicho Haubert",hands="Emicho Gauntlets",ring1="Patricius Ring",ring2="Hetairoi Ring",
			back="Atheling Mantle",waist="Sarissapho. Belt",legs="Emicho Hose",feet="Valorous Greaves"}
	sets.engaged.Polearm = {}
	sets.engaged.Staff = {}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, { ammo="Amar Cluster",
			head="Sulevia's Mask +1",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
			body="Sulevia's Plate. +1",hands="Emicho Gauntlets",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			back="Updraft Mantle",waist="Olseni Belt",legs="Carmine Cuisses",feet="Sulev. Leggings +1"})
	sets.Mode.Att= set_combine(sets.engaged, {ammo="Potestas Bomblet",
			head="Sulevia's Mask +1",neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			body="Rheic Korazin +3",hands="Sulev. Gauntlets +1",ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Phalangite Mantle",waist="Zoran's Belt",legs="Emicho Hose",feet="Sulev. Leggings +1"})
	sets.Mode.Crit = set_combine(sets.engaged, {
			head="Valorous Mask",hands="Valorous Mitts",ring1="Hetairoi Ring",
			legs="Pelt. Cuissots +1",feet="Valorous Greaves"})
	sets.Mode.DA = set_combine(sets.engaged, { ammo="Focal Orb",
			head="Otomi Helm",neck="Ganesha's Mala",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Emicho Haubert",hands="Pel. Vambraces +1",ring1="Hetairoi Ring",
			back="Atheling Mantle",waist="Sarissapho. Belt",legs="Sulevi. Cuisses +1",feet="Ejekamal Boots"})
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Gavialis Helm",
			body="Porthos Byrnie",hands="Regimen Mittens",
			back="Grounded Mantle",waist="Zoran's Belt",legs="Phorcys Dirs",feet="Ejekamal Boots"})
	sets.Mode.Skill = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, { ammo="Ginsen",
			head="Sulevia's Mask +1",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Digni. Earring",
			body="Pelt. Plackart +1",hands="Emicho Gauntlets",ring1="Rajas Ring",ring2="K'ayres Ring",
			back="Laic Mantle",waist="Olseni Belt",legs="Phorcys Dirs",feet="Valorous Greaves"})
	sets.Mode.STR = set_combine(sets.engaged, {ammo="Amar Cluster",
			head="Valorous Mask",neck="Lacono Neck. +1",
			body="Sulevia's Plate. +1",hands="Sulev. Gauntlets +1",ring1="Rajas Ring",ring2="Apate Ring",
			back="Brigantia's Mantle",waist="Wanion Belt",legs="Valor. Hose",feet="Valorous Greaves"})
			
	sets.engaged.Polearm = set_combine(sets.engaged, {main="Reienkyo",sub="Bloodrain Strap"})
	sets.engaged.Polearm.Refresh = set_combine(sets.engaged.Polearm, {ear1="Ethereal Earring",ear2="Brutal Earring",
			body="Twilight Mail"})
	sets.engaged.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.Polearm.Att = set_combine(sets.engaged.Polearm, sets.Mode.Att)
	sets.engaged.Polearm.Crit = set_combine(sets.engaged.Polearm, sets.Mode.Crit)
	sets.engaged.Polearm.DA = set_combine(sets.engaged.Polearm, sets.Mode.DA)
	sets.engaged.Polearm.Haste = set_combine(sets.engaged.Polearm, sets.Mode.Haste)
	sets.engaged.Polearm.Skill = set_combine(sets.engaged.Polearm, {
			head="Peltast's Mezail +1",neck="Maskirova Torque",ear1="Tripudio Earring"})
	sets.engaged.Polearm.sTP = set_combine(sets.engaged.Polearm, sets.Mode.sTP)
	sets.engaged.Polearm.STR = set_combine(sets.engaged.Polearm, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main="Chatoyant Staff",sub="Bloodrain Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Reraise = set_combine(sets.engaged,{
			head="Twilight Helm",
			body="Twilight Mail"})
			
	-- Precast Sets
	-- Precast sets to enhance JAs
	sets.precast.JA.Jumps = { ammo="Amar Cluster",
			head="Peltast's Mezail +1",neck="Ganesha's Mala",ear1="Steelflash Earring",ear2="Bladeborn Earring",
			body="Pelt. Plackart +1",hands="Crusher's Gauntlets",ring1="Hetairoi Ring",ring2="K'ayres Ring",
			back="Brigantia's Mantle",waist="Sarissapho. Belt",legs="Pelt. Cuissots +1",feet="Pelt. Schyn. +1"}
	sets.precast.JA['Jump'] = set_combine(sets.precast.JA.Jumps, {
			body="Vishap Mail +1",hands="Vishap F. G. +1",
			feet="Vishap Greaves +1"})
	sets.precast.JA['High Jump'] = set_combine(sets.precast.JA.Jumps, {
			body="Vishap Mail +1",hands="Vishap F. G. +1",
			legs="Vishap Brais +1",feet="Cizin Greaves"})
	sets.precast.JA['Spirit Jump'] = set_combine(sets.precast.JA.Jumps, {
			legs="Pelt. Cuissots +1",feet="Pelt. Schyn. +1"})
	sets.precast.JA['Soul Jump'] = set_combine(sets.precast.JA.Jumps, {
			body="Pelt. Plackart +1",
			waist="Zoran's Belt",legs="Pelt. Cuissots +1",feet="Cizin Greaves"})
	sets.precast.JA['Super Jump'] = {
			head="Twilight Helm",
			body="Twilight Mail"}
	sets.precast.JA.Angon = {ammo="Angon",ear1="Dragoon's Earring",hands="Ptero. Fin. G. +1"}
	sets.precast.JA['Ancient Circle'] = {legs="Vishap Brais +1"}
	sets.precast.JA['Spirit Link'] = {head="Vishap Armet +1",ear2="Pratik Earring",hands="Pel. Vambraces +1",feet="Ptero. Greaves +1"}
	sets.precast.JA['Call Wyvern'] = {body="Ptero. Mail +1"}
	sets.precast.JA['Deep Breathing'] = {head="Ptero. Armet +1",hands="Ptero. Fin. G. +1"}
	sets.precast.JA['Spirit Surge'] = {body="Ptero. Mail +1"}
	
	-- Healing Breath sets
	sets.Breath = {
			head="Ptero. Armet +1",neck="Lancer's Torque",ear1="Dragoon's Earring",ear2="Lancer's Earring",
			body="Wyvern Mail",hands="Crusher's Gauntlets",ring1="Overbearing Ring",ring2="K'ayres Ring",
			-- back="Updraft Mantle",waist="Glassblower's Belt",legs="Vishap Brais +1",feet="Ptero. Greaves +1"}
			back="Brigantia's Mantle",waist="Glassblower's Belt",legs="Vishap Brais +1",feet="Ptero. Greaves +1"}
	sets.precast.Breath = set_combine(sets.Breath, {head="Vishap Armet +1",hands="Regimen Mittens"})
	sets.midcast.Breath = set_combine(sets.Breath, {head="Ptero. Armet +1"})
	sets.midcast.Breath.Food = set_combine(sets.Breath, {head="Ptero. Armet +1",body="Pelt. Plackart +1"})
	--sets.midcast.Breath = set_combine(sets.midcast.FastRecast, { head="Vishap Armet +1" })
			
	-- Waltz set (chr and vit)
	sets.precast.Waltz = { neck="Phalaina Locket",hands="Buremte Gloves"}
		   
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
   
	-- Fast cast sets for spells
	sets.precast.FC = {head="Vishap Armet +1",neck="Baetyl Pendant",legs="Limbo Trousers"}

	-- Midcast Sets
	-- sets.midcast.FastRecast = {head="Vishap Armet +1"}     
		   
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {head="Gavialis Helm"} 

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {
		neck="Fotia Gorget",
		body="Rheic Korazin +3",
		back="Brigantia's Mantle",waist="Fotia Belt",feet="Sulev. Leggings +1"})
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
   
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Light, STR 30% DEX 30%
	sets.precast.WS['Double Thrust'] = set_combine(sets.precast.WS, {})
		
	-- Light/Thunder, STR 40% INT 40%
	sets.precast.WS['Thunder Thrust'] = set_combine(sets.precast.WS, {legs="Limbo Trousers"})

	-- Light/Thunder, STR 40% INT 40% 
	sets.precast.WS['Raiden Thrust'] = set_combine(sets.precast.WS, {legs="Limbo Trousers"})

	-- Thunder, STR 100%
	sets.precast.WS['Leg Sweep'] = set_combine(sets.precast.WS, {})

	-- Darkness, STR 20% DEX 20% 
	sets.precast.WS['Penta Thrust'] = set_combine(sets.precast.WS, {})

	-- Light/Water, STR 50% AGI 50% 
	sets.precast.WS['Vorpal Thrust'] = set_combine(sets.precast.WS, {})

	-- Light/Thunder, STR 50%
	sets.precast.WS['Skewer'] = set_combine(sets.precast.WS, {})
	
	-- Light/Fire, STR 80% -->
	sets.precast.WS['Wheeling Thrust'] = set_combine(sets.precast.WS, {})

	-- Dark/Earth/Ice, STR 100% -->
	sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {})

	-- Light/Earth, STR 40% DEX 40%-->
	sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS, {})

	-- Dark/Earth/Light, STR 85% -->
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {})

	-- Water/Ice/Light, DEX 80% -->
	sets.precast.WS['Geirskogul'] = set_combine(sets.precast.WS, {head="Quiahuiz Helm",hands="Regimen Mittens",legs="Cizin Breeches",feet="Cizin Greaves"})

	-- Light/Fire, STR 50% -->
	sets.precast.WS['Drakesbane'] = set_combine(sets.precast.WS, {})

	-- Light/Wind/Thunder, STR 60%, VIT 60% -->
	sets.precast.WS["Camlann's Torment"] = set_combine(sets.precast.WS, {})

	-- Defense sets
	sets.defense = {}
	
	sets.defense.Evasion = {
			head="Gavialis Helm",ear1="Ethereal Earring",ear2="Assuage Earring",
			body="Ptero. Mail +1",hands="Regimen Mittens",ring1="Vengeful Ring",
			legs="Limbo Trousers",feet="Vishap Greaves +1"}

	sets.defense.PDT = {
			head="Sulevia's Mask +1",neck="Twilight Torque",
			body="Sulevia's Plate. +1",hands="Sulev. Gauntlets +1",ring1="Patricius Ring",
			legs="Sulevi. Cuisses +1",feet="Sulev. Leggings +1"}

	sets.defense.Reraise = {head="Twilight Helm", body="Twilight Mail"}

	sets.defense.MDT = {
			head="Sulevia's Mask +1",neck="Twilight Torque",
			body="Sulevia's Plate. +1",hands="Sulev. Gauntlets +1",ring1="Vengeful Ring",
			waist="Flax Sash",legs="Sulevi. Cuisses +1",feet="Sulev. Leggings +1"}

	sets.Kiting = {legs="Carmine Cuisses"}

	-- These sets use a piece of gear in specific situations, need to customize_idle_set or customize_melee_set
	sets.Assault = {ring2="Ulthalam's Ring"}
end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
 
-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
	-- add_to_chat(1,'pretarget stance is '..state.Stance.value)
	if state.Stance.value ~= 'Off' then
		if spell.english == "Spirit Jump" then
			if player.tp > 1000 then 
				cancel_spell()
			else
				if not pet.isvalid then
					cancel_spell()
					send_command('Jump')
				end
			end
		elseif spell.english == "Soul Jump" then
			if player.tp > 1000 then 
				cancel_spell()
			else
				if not pet.isvalid then
					cancel_spell()
					send_command("High Jump")
				end
			end
		end
	end
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	-- add_to_chat(2,'job precast')
    if spell.type == 'PetCommand' then
		if pet.isvalid == true then
			-- midcast delay
			if spell.name == "Smiting Breath" then
				-- add_to_chat(120,'smiting gear')
				equip(sets.precast.Breath)
			elseif spell.name == 'Restoring Breath' then
				-- add_to_chat(120,'restoring gear')
				equip(sets.precast.Breath)
			elseif spell.name == 'Steady Wing' then
				equip(sets.precast.JA["Steady Wing"])
			end
		else
			cancel_spell()
		end
	end
	if spell.action_type == 'Magic' then
		if pet.isvalid == true then
			if player.hpp < 55 or party.count > 1 then
				equip(sets.precast.Breath)
			end
		end	
    end
	check_ws_dist(spell)
end
 
-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
	-- add_to_chat(3,'post precast')
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	-- add_to_chat(4,'midcast')
end
 
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
   -- add_to_chat(5,'post midcast')
end
 
-- Runs when a pet initiates an action.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_midcast(spell, action, spellMap, eventArgs)
	-- add_to_chat(3,'pet midcast')
	if buffactive.food then
		-- add_to_chat(122,' food breath ')
		if spell.english:startswith('Healing Breath') or spell.english:startswith('Restoring Breath') or spell.english:startswith('Smiting Breath') then
			equip(sets.midcast.Breath.Food)
		end
	else
		-- add_to_chat(122,' breath no food ')
		if spell.english:startswith('Healing Breath') or spell.english:startswith('Restoring Breath') or spell.english:startswith('Smiting Breath') then
			equip(sets.midcast.Breath)
		end
	end
end

-- Handle notifications of user state values being changed.
function job_state_change(stateField, newValue, oldValue)
	-- add_to_chat(121,' job state change ')
	if stateField == 'Weapon Mode' then
		if newValue ~= 'Normal' then
			state.CombatWeapon:set(newValue)
		else
			state.CombatWeapon:reset()
		end
	end
end
 
-- Run after the default pet midcast() is done.
-- eventArgs is the same one used in job_pet_midcast, in case information needs to be persisted.
function job_pet_post_midcast(spell, action, spellMap, eventArgs)
    -- add_to_chat(122,'pet post midcast')   
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(6,'aftercast')
end
 
-- Run after the default aftercast() is done.
-- eventArgs is the same one used in job_aftercast, in case information needs to be persisted.
function job_post_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(7,'post aftercast '..spell.name)
	-- don't do anything after these conditions
	if spell.type == 'Trust' or spell.name == 'Jump' or spell.name == 'Spirit Jump' then
		return
	end
	if spell.type == 'WeaponSkill' then
		delay = 4
	else	
		delay = 1
	end
	if player.sub_job == 'SAM' then
		handle_sam_ja:schedule(delay)
	end
	if player.sub_job == 'WAR' then
		handle_war_ja:schedule(delay)
	end
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'pet aftercast')
end
 
-- Run after the default pet aftercast() is done.
-- eventArgs is the same one used in job_pet_aftercast, in case information needs to be persisted.
function job_pet_post_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'post pet aftercast')
end
 
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
 
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
	handle_twilight()
end
 
-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, action, spellMap)
	-- add_to_chat(122,'get custom wsmode')
end
 
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	-- add_to_chat(122,'customize idle set')
    return idleSet
end
 
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	-- add_to_chat(122,'customize melee set')
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end
    return meleeSet
end
 
-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
 
-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
	-- add_to_chat(122,'job_status_change')
end
 
-- Called when the player's pet's status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
 
end
 
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	determine_groups()
	-- if player.sub_job == 'SAM' then
		-- handle_sam_ja()
	-- end
	-- if player.sub_job == 'WAR' then
		-- handle_war_ja()
	-- end
end
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
 
-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
	handle_flags(cmdParams, eventArgs)
end
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	-- add_to_chat(121,'job update')
	pick_tp_weapon()
end
 
-- Job-specific toggles.
function job_toggle(field)
 
end
 
-- Request job-specific mode lists.
-- Return the list, and the current value for the requested field.
function job_get_mode_list(field)
 
end
 
-- Set job-specific mode values.
-- Return true if we recognize and set the requested field.
function job_set_mode(field, val)
 
end
 
-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
 
end
 
-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
 
end
 
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_groups()
	-- add_to_chat(122,' determine groups')
	classes.CustomMeleeGroups:clear()
	
	-- If sub job has MP then set refresh groups for refresh gear
	if jobs.MP:contains(player.sub_job) then
		-- add_to_chat(122,' using refresh because SJ: '..player.sub_job)
		classes.CustomMeleeGroups:append('Refresh')
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(2, 1)
	elseif player.sub_job == 'NIN' then
		set_macro_page(4, 1)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 1)
	elseif player.sub_job == 'WHM' then
		set_macro_page(3, 1)
		send_command('exec drgwhm.txt')
	else
		set_macro_page(1, 1)
	end
	send_command('exec drg.txt')
end

