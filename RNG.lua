include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff.Barrage = buffactive.Barrage or false
	state.Buff.Camouflage = buffactive.Camouflage or false
	state.Buff['Unlimited Shot'] = buffactive['Unlimited Shot'] or false
	state.WeaponMode = M{['description']='Weapon Mode', 'Axe', 'Dagger', 'Staff', 'Club'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Bow', 'Xbow', 'Gun'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('Axe')
	state.Stance:set('Offensive')
	state.SubMode:set('DW')
	state.RWeaponMode:set('Bow') 
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	
	gear.default.weaponskill_neck = "Ocachi Gorget"
    gear.hercTH = { name="Herculean Helm", augments={'Attack+13','"Snapshot"+3','"Treasure Hunter"+1','Accuracy+5 Attack+5',}}
    gear.hercAcc = { name="Herculean Helm", augments={'Accuracy+29','STR+6','Attack+3',}}
	
	DefaultAmmo = {['Yoichinoyumi'] = "Achiyalabopa arrow", ['Annihilator'] = "Achiyalabopa bullet"}
	U_Shot_Ammo = {['Yoichinoyumi'] = "Achiyalabopa arrow", ['Annihilator'] = "Achiyalabopa bullet"}

	set_combat_form()
	pick_tp_weapon()
	select_default_macro_book()

	send_command('bind f9 gs c cycle RangedMode')
	send_command('bind ^f9 gs c cycle OffenseMode')
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind f9')
	send_command('unbind ^f9')
end


-- Set up all gear sets.
function init_gear_sets()
	organizer_items = {
		new1="Thereoid Greaves",
		new2="Hippomenes Socks",
		new3="Mummu Gamash. +1",
		new4="Mummu Wrists +1",
		new5="Mummu Bonnet +1",
		new6="Mummu Kecks +1",
		new7="Mummu Jacket +1",
		new8="Sailfi Belt +1",
		new9="Cacoethic Ring +1",
		new10="",
		new11="",
		new12="",
		new13="",
		new14="",
		new15="",
		new16="",
		new17="",
		new18="",
		new22="",
		new23="",
		new24="",
		new25="",
		new26="Belenus's Cape",
		new27="",
		new28="",
		-- echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	-- Idle sets
	sets.idle = {
		head="Meghanada Visor +1",neck="Twilight Torque",ear1="Infused Earring",ear2="Etiolation Earring",
		body="Meg. Cuirie +1",hands="Meg. Gloves +1",ring1="Defending Ring",ring2="Patricius Ring",
		back="Solemnity Cape",waist="Flax Sash",legs="Carmine Cuisses +1",feet="Herculean Boots"}

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
	sets.engaged = {
			head="Meghanada Visor +1",neck="Sanctity Necklace",ear1="Ethereal Earring",ear2="Suppanomimi",
			body="Meg. Cuirie +1",hands="Herculean Gloves",ring1="Epona's Ring",ring2="Hetairoi Ring",
			back="Ground. Mantle +1",waist="Sarissapho. Belt",legs="Carmine Cuisses +1",feet="Herculean Boots"}
	sets.engaged.Axe = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
		head="Meghanada Visor +1",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
		body="Meg. Cuirie +1",hands="Meg. Gloves +1",
		waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Meg. Jam. +1"})
	sets.Mode.Att= set_combine(sets.engaged, {
		head="Meghanada Visor +1",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
		body="Meg. Cuirie +1",hands="Meg. Gloves +1",
		back="Phalangite Mantle",waist="Eschan Stone",legs="Carmine Cuisses +1",feet="Meg. Jam. +1"})
	sets.Mode.Crit = set_combine(sets.engaged, {head="Adhemar Bonnet",body="Meg. Cuirie +1",ring1="Hetairoi Ring",legs="Jokushu Haidate"})
	sets.Mode.DA = set_combine(sets.engaged, {
		ring1="Epona's Ring",ring2="Hetairoi Ring",
		waist="Sarissapho. Belt",legs="Meg. Chausses +1"})
	sets.Mode.Haste = set_combine(sets.engaged, {
		head="Thur. Chapeau +1",
		body="Herculean Vest",hands="Meg. Gloves +1",
		legs="Jokushu Haidate",feet="Herculean Boots"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {ear2="Digni. Earring",body="Herculean Vest",back="Laic Mantle"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Lilitu Headpiece",neck="Lacono Neck. +1",
		body="Meg. Cuirie +1",hands="Herculean Gloves",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",waist="Wanion Belt",legs="Herculean Trousers",feet="Meg. Jam. +1"})
			
	--Initialize Main Weapons
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Perun +1",sub="Hawker's Knife +1"})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Perun +1",sub=""})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Hawker's Knife +1"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub=""})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Hawker's Knife +1",sub="Perun +1"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Hawker's Knife +1",sub=""})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Chatoyant Staff", sub="Pole Grip"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Bow = {range="Hangaku-no-Yumi",ammo="Horn Arrow"}
	sets.ranged.Xbow = {range="Tsoa. Crossbow",ammo="Sleep Bolt"}
	sets.ranged.Gun = {range="Holliday",ammo="Bronze Bullet"}
	
	sets.engaged.DW.Axe.Xbow = set_combine(sets.engaged.DW.Axe, sets.ranged.Xbow)
	sets.engaged.DW.Axe.Bow = set_combine(sets.engaged.DW.Axe, sets.ranged.Bow)
	sets.engaged.DW.Axe.Gun = set_combine(sets.engaged.DW.Axe, sets.ranged.Gun)
	sets.engaged.Shield.Axe.Xbow = set_combine(sets.engaged.Shield.Axe, sets.ranged.Xbow)
	sets.engaged.Shield.Axe.Bow = set_combine(sets.engaged.Shield.Axe, sets.ranged.Bow)
	sets.engaged.Shield.Axe.Gun = set_combine(sets.engaged.Shield.Axe, sets.ranged.Gun)
	sets.engaged.DW.Club.Xbow = set_combine(sets.engaged.DW.Club, sets.ranged.Xbow)
	sets.engaged.DW.Club.Bow = set_combine(sets.engaged.DW.Club, sets.ranged.Bow)
	sets.engaged.DW.Club.Gun = set_combine(sets.engaged.DW.Club, sets.ranged.Gun)
	sets.engaged.Shield.Club.Xbow = set_combine(sets.engaged.Shield.Club, sets.ranged.Xbow)
	sets.engaged.Shield.Club.Bow = set_combine(sets.engaged.Shield.Club, sets.ranged.Bow)
	sets.engaged.Shield.Club.Gun = set_combine(sets.engaged.Shield.Club, sets.ranged.Gun)
	sets.engaged.DW.Dagger.Xbow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Xbow)
	sets.engaged.DW.Dagger.Bow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Bow)
	sets.engaged.DW.Dagger.Gun = set_combine(sets.engaged.DW.Dagger, sets.ranged.Gun)
	sets.engaged.Shield.Dagger.Xbow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Xbow)
	sets.engaged.Shield.Dagger.Bow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Bow)
	sets.engaged.Shield.Dagger.Gun = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Gun)
	
	sets.engaged.DW.Axe.Acc = set_combine(sets.engaged.DW.Axe, sets.Mode.Acc)
	sets.engaged.DW.Axe.Att = set_combine(sets.engaged.DW.Axe, sets.Mode.Att)
	sets.engaged.DW.Axe.Crit = set_combine(sets.engaged.DW.Axe, sets.Mode.Crit)
	sets.engaged.DW.Axe.DA = set_combine(sets.engaged.DW.Axe, sets.Mode.DA)
	sets.engaged.DW.Axe.Haste = set_combine(sets.engaged.DW.Axe, sets.Mode.Haste)
	sets.engaged.DW.Axe.Skill = set_combine(sets.engaged.DW.Axe, {})
	sets.engaged.DW.Axe.sTP = set_combine(sets.engaged.DW.Axe, sets.Mode.sTP)
	sets.engaged.DW.Axe.STR = set_combine(sets.engaged.DW.Axe, sets.Mode.STR)
	sets.engaged.Shield.Axe.Acc = set_combine(sets.engaged.Shield.Axe, sets.Mode.Acc)
	sets.engaged.Shield.Axe.Att = set_combine(sets.engaged.Shield.Axe, sets.Mode.Att)
	sets.engaged.Shield.Axe.Crit = set_combine(sets.engaged.Shield.Axe, sets.Mode.Crit)
	sets.engaged.Shield.Axe.DA = set_combine(sets.engaged.Shield.Axe, sets.Mode.DA)
	sets.engaged.Shield.Axe.Haste = set_combine(sets.engaged.Shield.Axe, sets.Mode.Haste)
	sets.engaged.Shield.Axe.Skill = set_combine(sets.engaged.Shield.Axe, {})
	sets.engaged.Shield.Axe.sTP = set_combine(sets.engaged.Shield.Axe, sets.Mode.sTP)
	sets.engaged.Shield.Axe.STR = set_combine(sets.engaged.Shield.Axe, sets.Mode.STR)
	
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.DW.Club.Att = set_combine(sets.engaged.DW.Club, sets.Mode.Att)
	sets.engaged.DW.Club.Crit = set_combine(sets.engaged.DW.Club, sets.Mode.Crit)
	sets.engaged.DW.Club.DA = set_combine(sets.engaged.DW.Club, sets.Mode.DA)
	sets.engaged.DW.Club.Haste = set_combine(sets.engaged.DW.Club, sets.Mode.Haste)
	sets.engaged.DW.Club.Skill = set_combine(sets.engaged.DW.Club, {})
	sets.engaged.DW.Club.sTP = set_combine(sets.engaged.DW.Club, sets.Mode.sTP)
	sets.engaged.DW.Club.STR = set_combine(sets.engaged.DW.Club, sets.Mode.STR)
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.Att = set_combine(sets.engaged.Shield.Club, sets.Mode.Att)
	sets.engaged.Shield.Club.Crit = set_combine(sets.engaged.Shield.Club, sets.Mode.Crit)
	sets.engaged.Shield.Club.DA = set_combine(sets.engaged.Shield.Club, sets.Mode.DA)
	sets.engaged.Shield.Club.Haste = set_combine(sets.engaged.Shield.Club, sets.Mode.Haste)
	sets.engaged.Shield.Club.Skill = set_combine(sets.engaged.Shield.Club, {})
	sets.engaged.Shield.Club.sTP = set_combine(sets.engaged.Shield.Club, sets.Mode.sTP)
	sets.engaged.Shield.Club.STR = set_combine(sets.engaged.Shield.Club, sets.Mode.STR)

	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	sets.engaged.DW.Dagger.Haste = set_combine(sets.engaged.DW.Dagger, sets.Mode.Haste)
	sets.engaged.DW.Dagger.Skill = set_combine(sets.engaged.DW.Dagger, {})
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	sets.engaged.Shield.Dagger.Haste = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Haste)
	sets.engaged.Shield.Dagger.Skill = set_combine(sets.engaged.Shield.Dagger, {})
	sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
			
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {} 
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",ear2="Ishvara Earring",
		hands="Meg. Gloves +1",waist="Fotia Belt"})    
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Bounty Shot'] = {hands="Syl. Glvltte. +2"}
	sets.precast.JA['Camouflage'] = {body="Hunter's Jerkin"}
	sets.precast.JA['Scavenge'] = {feet="Hunter's Socks"}
	sets.precast.JA['Shadowbind'] = {hands="Hunter's Bracers"}
	sets.precast.JA['Sharpshot'] = {legs="Hunter's Braccae"}


	-- Fast cast sets for spells
	sets.precast.FC = {
		head="Herculean Helm",neck="Baetyl Pendant",ear1="Etiolation Earring",
		hands="Leyline Gloves",legs="Limbo Trousers"}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

	-- Ranged sets (snapshot)
	sets.precast.RA = {
		head="Sylvan Gapette +2",
		body="Sylvan Caban +2",hands="Iuitl Wristbands",
		back="Lutian Cape",waist="Yemaya Belt",legs="Nahtirah Trousers",feet="Meg. Jam. +1"}


	--------------------------------------
	-- Midcast sets
	--------------------------------------

	-- Fast recast for spells
	-- sets.midcast.FastRecast = {}

	sets.midcast.Utsusemi = {}

	-- Ranged sets, use Ratt by default and can switch Racc as needed
	sets.midcast.RA = {
		head="Meghanada Visor +1",neck="Sanctity Necklace",ear1="Infused Earring",ear2="Suppanomimi",
		body="Meg. Cuirie +1",hands="Meg. Gloves +1",ring1="Behemoth Ring",ring2="Cacoethic Ring +1",
		back="Lutian Cape",waist="Eschan Stone",legs="Meg. Chausses +1",feet="Meg. Jam. +1"}
	
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA,
		{head="Meghanada Visor +1",neck="Iqabi Necklace",
		body="Meg. Cuirie +1",hands="Meg. Gloves +1",ring1="Behemoth Ring",ring2="Prouesse Ring",
		back="Lutian Cape",waist="Eschan Stone",legs="Meg. Chausses +1",feet="Meg. Jam. +1"})

	-- Defense sets
	sets.defense.Evasion = {
		head="Herculean Helm",ear1="Infused Earring",ear2="Assuage Earring",
		body="Herculean Vest",hands="Herculean Gloves",
		legs="Herculean Trousers",feet="Herculean Boots"}
	
	sets.defense.PDT = {
		head="Meghanada Visor +1",neck="Twilight Torque",
		body="Meg. Cuirie +1",hands="Meg. Gloves +1",ring1="Defending Ring",ring2="Patricius Ring",
		back="Solemnity Cape",legs="Meg. Chausses +1",feet="Thur. Boots +1"}

	sets.defense.MDT = {
		head="Herculean Helm",neck="Twilight Torque",ear1="Etiolation Earring",
		body="Herculean Vest",hands="Leyline Gloves",ring1="Defending Ring",ring2="Vengeful Ring",
		back="Solemnity Cape",legs="Feast Hose",feet="Herculean Boots"}
		
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)

	sets.Kiting = {legs="Carmine Cuisses +1",feet="Skd. Jambeaux +1"}

	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	sets.buff.Barrage = set_combine(sets.midcast.RA.Acc, {hands="Orion Bracers +1"})
	sets.buff.Camouflage = {body="Orion Jerkin +1"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		state.CombatWeapon:set(player.equipment.range)
	end

	if spell.action_type == 'Ranged Attack' or
	  (spell.type == 'WeaponSkill' and (spell.skill == 'Marksmanship' or spell.skill == 'Archery')) then
		check_ammo(spell, action, spellMap, eventArgs)
	end
	
	if state.DefenseMode.value ~= 'None' and spell.type == 'WeaponSkill' then
		-- Don't gearswap for weaponskills when Defense is active.
		eventArgs.handled = true
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' and state.Buff.Barrage then
		equip(sets.buff.Barrage)
		eventArgs.handled = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	handle_debuffs()
	if buff == "Camouflage" then
		if gain then
			equip(sets.buff.Camouflage)
			disable('body')
		else
			enable('body')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Check for proper ammo when shooting or weaponskilling
function check_ammo(spell, action, spellMap, eventArgs)
	-- Filter ammo checks depending on Unlimited Shot
	if state.Buff['Unlimited Shot'] then
		if player.equipment.ammo ~= U_Shot_Ammo[player.equipment.range] then
			if player.inventory[U_Shot_Ammo[player.equipment.range]] or player.wardrobe[U_Shot_Ammo[player.equipment.range]] then
				add_to_chat(122,"Unlimited Shot active. Using custom ammo.")
				equip({ammo=U_Shot_Ammo[player.equipment.range]})
			elseif player.inventory[DefaultAmmo[player.equipment.range]] or player.wardrobe[DefaultAmmo[player.equipment.range]] then
				add_to_chat(122,"Unlimited Shot active but no custom ammo available. Using default ammo.")
				equip({ammo=DefaultAmmo[player.equipment.range]})
			else
				add_to_chat(122,"Unlimited Shot active but unable to find any custom or default ammo.")
			end
		end
	else
		if player.equipment.ammo == U_Shot_Ammo[player.equipment.range] and player.equipment.ammo ~= DefaultAmmo[player.equipment.range] then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122,"Unlimited Shot not active. Using Default Ammo")
					equip({ammo=DefaultAmmo[player.equipment.range]})
				else
					add_to_chat(122,"Default ammo unavailable.  Removing Unlimited Shot ammo.")
					equip({ammo=empty})
				end
			else
				add_to_chat(122,"Unable to determine default ammo for current weapon.  Removing Unlimited Shot ammo.")
				equip({ammo=empty})
			end
		elseif player.equipment.ammo == 'empty' then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122,"Using Default Ammo")
					equip({ammo=DefaultAmmo[player.equipment.range]})
				else
					add_to_chat(122,"Default ammo unavailable.  Leaving empty.")
				end
			else
				add_to_chat(122,"Unable to determine default ammo for current weapon.  Leaving empty.")
			end
		elseif player.inventory[player.equipment.ammo].count < 15 then
			add_to_chat(122,"Ammo '"..player.inventory[player.equipment.ammo].shortname.."' running low ("..player.inventory[player.equipment.ammo].count..")")
		end
	end
end

function job_handle_equipping_gear(playerStatus, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
end

function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	pick_tp_weapon()
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 16)
end
