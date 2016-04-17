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
	state.WeaponMode = M{['description']='Weapon Mode', 'Scythe', 'GreatSword', 'GreatAxe', 'Sword', 'Club', 'Axe', 'Staff', 'Dagger'}
	state.SubMode = M{['description']='Sub Mode', 'Grip', 'DW', 'Shield'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Xbow'}
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
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.CastingMode:options('Normal')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('Scythe')
	state.Stance:set('Offensive')
	state.SubMode:set('Grip')
	state.RWeaponMode:set('Stats') 
	flag.sekka = true
	flag.med = true
	flag.berserk = true
	flag.defender = true
	flag.aggressor = true
	flag.warcry = true
	flag.thirdeye = true

	pick_tp_weapon()
	select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()

end

function init_gear_sets()
	organizer_items = {
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	-- add_to_chat(122,'init gear sets')
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	-- Sets to return to when not performing an action.
   
	-- Idle sets
	sets.idle = {head="Twilight Helm",neck="Twilight Torque",ear1="Ethereal Earring",ear2="Moonshade Earring",
			body="Twilight Mail",hands="Umuthi Gloves",ring1="Rajas Ring",ring2="Ulthalam's Ring",
			back="Atheling Mantle",waist="Swift Belt",legs="Crimson Cuisses",feet="Scamp's Sollerets"}

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
        head="Optical Hat",neck="Chivalrous Chain",ear1="Ethereal Earring",ear2="Brutal Earring",
        body="Scorpion Harness",hands="Chaos Gauntlets",ring1="Rajas Ring",ring2="Ulthalam's Ring",
        back="Amemet Mantle +1",waist="Swift Belt",legs="Homam Cosciales",feet="Bounding Boots"}
	sets.engaged.GreatAxe = {}
	sets.engaged.Axe = {}
	sets.engaged.GreatSword = {}
	sets.engaged.Scythe = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Yaoyotl Helm",neck="Iqabi Necklace",ear1="Heartseeker Earring",ear2="Steelflash Earring",
			body="Miki. Breastplate",hands="Buremte Gloves",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			back="Mauler's Mantle",waist="Nu Sash",legs="Wukong's Haka. +1",feet="Scamp's Sollerets"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Mekira-oto +1",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			body="Rheic Korazin +3",hands="Miki. Gauntlets",ring1="Excelsis Ring",ring2="Cho'j Band",
			back="Atheling Mantle",waist="Zoran's Belt",legs="Miki. Cuisses",feet="Mikinaak Greaves"})
	sets.Mode.Crit = set_combine(sets.engaged, {})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Otomi Helm",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Porthos Byrnie",
			feet="Ejekamal Boots"})
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Otomi Helm",ear1="Heartseeker Earring",ear2="Dudgeon Earring",
			body="Porthos Byrnie",hands="Umuthi Gloves",
			waist="Zoran's Belt",feet="Ejekamal Boots"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Yaoyotl Helm",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Brutal Earring",
			hands="Cizin Mufflers",ring1="Rajas Ring",ring2="K'ayres Ring",
			legs="Phorcys Dirs",feet="Mikinaak Greaves"})
	sets.Mode.STR = set_combine(sets.engaged, {
			head="Maat's Cap",
			body="Miki. Breastplate",hands="Enkelados's Brc.",ring1="Rajas Ring",ring2="Aife's Ring",
			waist="Wanion Belt",legs="Wukong's Haka. +1",feet="Scamp's Sollerets"})
			
	--Initialize Main Weapons
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub="Hatxiik"})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub="Viking Shield"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Kumbhakarna"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Viking Shield"})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Twilight Knife",sub="Kumbhakarna"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Twilight Knife",sub="Viking Shield"})
	sets.engaged.Grip.GreatAxe = set_combine(sets.engaged, {main="Ixtab",sub="Pole Grip"})
	sets.engaged.Grip.GreatSword = set_combine(sets.engaged, {main="Algol",sub="Pole Grip"})
	sets.engaged.Grip.Scythe = set_combine(sets.engaged, {main="Scythe of Trials", sub="Pole Grip"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Chatoyant Staff", sub="Pole Grip"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Usonmunku",sub="Kumbhakarna"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Usonmunku",sub="Viking Shield"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {ranged="",ammo="Olibanum Sachet"}
	sets.ranged.Xbow = {ranged="Tsoa. Crossbow",ammo="Bloody Bolt"}
	
	sets.engaged.DW.Axe.Xbow = set_combine(sets.engaged.DW.Axe, sets.ranged.Xbow)
	sets.engaged.DW.Axe.Stats = set_combine(sets.engaged.DW.Axe, sets.ranged.Stats)
	sets.engaged.Shield.Axe.Xbow = set_combine(sets.engaged.Shield.Axe, sets.ranged.Xbow)
	sets.engaged.Shield.Axe.Stats = set_combine(sets.engaged.Shield.Axe, sets.ranged.Stats)
	sets.engaged.DW.Club.Xbow = set_combine(sets.engaged.DW.Club, sets.ranged.Xbow)
	sets.engaged.DW.Club.Stats = set_combine(sets.engaged.DW.Club, sets.ranged.Stats)
	sets.engaged.Shield.Club.Xbow = set_combine(sets.engaged.Shield.Club, sets.ranged.Xbow)
	sets.engaged.Shield.Club.Stats = set_combine(sets.engaged.Shield.Club, sets.ranged.Stats)
	sets.engaged.DW.Dagger.Xbow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Xbow)
	sets.engaged.DW.Dagger.Stats = set_combine(sets.engaged.DW.Dagger, sets.ranged.Stats)
	sets.engaged.Shield.Dagger.Xbow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Xbow)
	sets.engaged.Shield.Dagger.Stats = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Stats)
	sets.engaged.DW.Sword.Xbow = set_combine(sets.engaged.DW.Sword, sets.ranged.Xbow)
	sets.engaged.DW.Sword.Stats = set_combine(sets.engaged.DW.Sword, sets.ranged.Stats)
	sets.engaged.Shield.Sword.Xbow = set_combine(sets.engaged.Shield.Sword, sets.ranged.Xbow)
	sets.engaged.Shield.Sword.Stats = set_combine(sets.engaged.Shield.Sword, sets.ranged.Stats)

	sets.engaged.Grip.GreatAxe.Xbow = set_combine(sets.engaged.Grip.GreatAxe, sets.ranged.Xbow)
	sets.engaged.Grip.GreatAxe.Stats = set_combine(sets.engaged.Grip.GreatAxe, sets.ranged.Stats)
	sets.engaged.Grip.GreatSword.Xbow = set_combine(sets.engaged.Grip.GreatSword, sets.ranged.Xbow)
	sets.engaged.Grip.GreatSword.Stats = set_combine(sets.engaged.Grip.GreatSword, sets.ranged.Stats)
	sets.engaged.Grip.Scythe.Xbow = set_combine(sets.engaged.Grip.Scythe, sets.ranged.Xbow)
	sets.engaged.Grip.Scythe.Stats = set_combine(sets.engaged.Grip.Scythe, sets.ranged.Stats)
	sets.engaged.Grip.Staff.Xbow = set_combine(sets.engaged.Grip.Staff, sets.ranged.Xbow)
	sets.engaged.Grip.Staff.Stats = set_combine(sets.engaged.Grip.Staff, sets.ranged.Stats)
	
	sets.engaged.Grip.GreatAxe.Acc = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Acc)
	sets.engaged.Grip.GreatAxe.Att = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Att)
	sets.engaged.Grip.GreatAxe.Crit = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Crit)
	sets.engaged.Grip.GreatAxe.DA = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.DA)
	sets.engaged.Grip.GreatAxe.Haste = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Haste)
	sets.engaged.Grip.GreatAxe.Skill = set_combine(sets.engaged.Grip.GreatAxe, {})
	sets.engaged.Grip.GreatAxe.sTP = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.sTP)
	sets.engaged.Grip.GreatAxe.STR = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.STR)

	sets.engaged.Grip.GreatSword.Acc = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Acc)
	sets.engaged.Grip.GreatSword.Att = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Att)
	sets.engaged.Grip.GreatSword.Crit = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Crit)
	sets.engaged.Grip.GreatSword.DA = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.DA)
	sets.engaged.Grip.GreatSword.Haste = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Haste)
	sets.engaged.Grip.GreatSword.Skill = set_combine(sets.engaged.Grip.GreatSword, {})
	sets.engaged.Grip.GreatSword.sTP = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.sTP)
	sets.engaged.Grip.GreatSword.STR = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.STR)
	
	sets.engaged.Grip.Scythe.Acc = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Acc)
	sets.engaged.Grip.Scythe.Att = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Att)
	sets.engaged.Grip.Scythe.Crit = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Crit)
	sets.engaged.Grip.Scythe.DA = set_combine(sets.engaged.Grip.Scythe, sets.Mode.DA)
	sets.engaged.Grip.Scythe.Haste = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Haste)
	sets.engaged.Grip.Scythe.Skill = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Skill, {})
	sets.engaged.Grip.Scythe.sTP = set_combine(sets.engaged.Grip.Scythe, sets.Mode.sTP)
	sets.engaged.Grip.Scythe.STR = set_combine(sets.engaged.Grip.Scythe, sets.Mode.STR)

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

	sets.engaged.DW.Sword.Acc = set_combine(sets.engaged.DW.Sword, sets.Mode.Acc)
	sets.engaged.DW.Sword.Att = set_combine(sets.engaged.DW.Sword, sets.Mode.Att)
	sets.engaged.DW.Sword.Crit = set_combine(sets.engaged.DW.Sword, sets.Mode.Crit)
	sets.engaged.DW.Sword.DA = set_combine(sets.engaged.DW.Sword, sets.Mode.DA)
	sets.engaged.DW.Sword.Haste = set_combine(sets.engaged.DW.Sword, sets.Mode.Haste)
	sets.engaged.DW.Sword.Skill = set_combine(sets.engaged.DW.Sword, {})
	sets.engaged.DW.Sword.sTP = set_combine(sets.engaged.DW.Sword, sets.Mode.sTP)
	sets.engaged.DW.Sword.STR = set_combine(sets.engaged.DW.Sword, sets.Mode.STR)
	sets.engaged.Shield.Sword.Acc = set_combine(sets.engaged.Shield.Sword, sets.Mode.Acc)
	sets.engaged.Shield.Sword.Att = set_combine(sets.engaged.Shield.Sword, sets.Mode.Att)
	sets.engaged.Shield.Sword.Crit = set_combine(sets.engaged.Shield.Sword, sets.Mode.Crit)
	sets.engaged.Shield.Sword.DA = set_combine(sets.engaged.Shield.Sword, sets.Mode.DA)
	sets.engaged.Shield.Sword.Haste = set_combine(sets.engaged.Shield.Sword, sets.Mode.Haste)
	sets.engaged.Shield.Sword.Skill = set_combine(sets.engaged.Shield.Sword, {})
	sets.engaged.Shield.Sword.sTP = set_combine(sets.engaged.Shield.Sword, sets.Mode.sTP)
	sets.engaged.Shield.Sword.STR = set_combine(sets.engaged.Shield.Sword, sets.Mode.STR)

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
	
	--------------------------------------
	-- Precast sets
	--------------------------------------
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {})
	sets.WSDayBonus = {head="Mekira-oto +1"} 
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {head="Yaoyotl Helm"})
   
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Earth, STR 100%
	sets.precast.WS['Slice'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Water, STR 40% INT 40%
	sets.precast.WS['Dark Harvest'] = set_combine(sets.precast.WS, {neck="Aqua Gorget",body="Rheic Korazin +3",waist="Aqua Belt"})

	-- Water/Ice, STR 40% INT 40%
	sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS, {neck="Aqua Gorget",body="Rheic Korazin +3",waist="Aqua Belt"})
	
	-- Earth/Dark, STR 60% MND 60%
	sets.precast.WS['Nightmare Scythe'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Earth/Water, STR 100%
	sets.precast.WS['Spinning Scythe'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Earth/Light, STR 100%
	sets.precast.WS['Vorpal Scythe'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})
	
	-- Ice, STR 30% MND 50%
	sets.precast.WS['Guillotine'] = set_combine(sets.precast.WS, {neck="Snow Gorget",body="Rheic Korazin +3",waist="Snow Belt"})
	
	-- Water/Ice, STR 60% MND 60%
	sets.precast.WS['Cross Reaper'] = set_combine(sets.precast.WS, {neck="Snow Gorget",body="Rheic Korazin +3",waist="Snow Belt"})

	-- Water/Earth/Ice, STR 50% INT 50%
	sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS, {neck="Snow Gorget",body="Rheic Korazin +3",waist="Snow Belt"})
	
	-- Fire/Light/Dark, STR 20% INT 20%
	sets.precast.WS['Insurgency'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})

	-- Thunder, STR 60% VIT 60%
	sets.precast.WS['Shield Break'] = set_combine(sets.precast.WS, {neck="Thunder Gorget",body="Rheic Korazin +3",waist="Thunder Belt"})

	-- Earth, STR 60% 
	sets.precast.WS['Iron Tempest'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})

	-- Earth/Water, STR 60% 
	sets.precast.WS['Sturmwind'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})

	-- Thunder, STR 60% VIT 60%
	sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS, {neck="Thunder Gorget",body="Rheic Korazin +3",waist="Thunder Belt"})

	-- Dark, STR 100%
	sets.precast.WS['Keen Edge'] = set_combine(sets.precast.WS, {neck="Dark Gorget",body="Rheic Korazin +3",waist="Dark Belt"})

	-- Thunder, STR 60% VIT 60%
	sets.precast.WS['Weapon Break'] = set_combine(sets.precast.WS, {neck="Thunder Gorget",body="Rheic Korazin +3",waist="Thunder Belt"})

	-- Ice/Water, STR 50% 
	sets.precast.WS['Raging Rush'] = set_combine(sets.precast.WS, {neck="Snow Gorget",body="Rheic Korazin +3",waist="Snow Belt"})
	
	-- Ice/Water, STR 50% VIT 50%
	sets.precast.WS['Full Break'] = set_combine(sets.precast.WS, {neck="Snow Gorget",body="Rheic Korazin +3",waist="Snow Belt"})
	
	-- Ice/Water/Wind, STR 60% VIT 60%
	sets.precast.WS['Steel Cyclone'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",body="Rheic Korazin +3",waist="Breeze Belt"})
	
	-- Earth/Thunder/Wind, STR 60%
	sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",body="Rheic Korazin +3",waist="Breeze Belt"})
	
	-- Fire/Light/Dark, STR 60%
	sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})
	
	-- Thunder/Wind, STR 60%
	sets.precast.WS['Raging Axe'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",body="Rheic Korazin +3",waist="Breeze Belt"})
	
	-- Ice/Water, STR 100%
	sets.precast.WS['Smash Axe'] = set_combine(sets.precast.WS, {neck="Aqua Gorget",body="Rheic Korazin +3",waist="Aqua Belt"})
	
	-- Wind, STR 100%
	sets.precast.WS['Gale Axe'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",body="Rheic Korazin +3",waist="Breeze Belt"})
	
	-- Earth/Thunder, STR 60%
	sets.precast.WS['Avalanche Axe'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Earth/Thunder/Fire, STR 60%
	sets.precast.WS['Spinning Axe'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Earth, STR 50%
	sets.precast.WS['Rampage'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Earth/Thunder, STR 50% VIT 50%
	sets.precast.WS['Calamity'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})

	-- Earth/Thunder, STR 50% 
	sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Fire/light/water, STR 50%
	sets.precast.WS['Decimation'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Rheic Korazin +3",waist="Light Belt"})
	
	-- Earth/Wind, DEX 100%
	sets.precast.WS['Bora Axe'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",body="Rheic Korazin +3",waist="Breeze Belt"})
	
	-- Earth/Wind, STR 73%
	sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",body="Rheic Korazin +3",waist="Breeze Belt"})
	
	-- Dark/Wind/Thunder, STR 40% MND 40%
	sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",body="Rheic Korazin +3",waist="Breeze Belt"})
	
	-- Earth/Wind/Thunder, STR 73%
	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",body="Rheic Korazin +3",waist="Breeze Belt"})

	-- Sets to apply to arbitrary JAs
	sets.precast.JA['Weapon Bash'] = {hands="Chaos Gauntlets"}
	
	-- Sets to apply to any actions of spell.type
    sets.precast['Enfeebling Magic'] = {
        body="Chaos Cuirass"}
    sets.precast['Elemental Magic'] = {
        ear1="Moldavite Earring"}
    sets.midcast['Enfeebling Magic'] = {
        body="Chaos Cuirass"}
 
    -- Sets for fast cast gear for spells
	sets.precast.FC = {ear2="Loquacious Earring"}

    -- Fast cast gear for specific spells or spell maps
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

	
	--------------------------------------
	-- Midcast sets
	--------------------------------------

    -- Generic spell recast set
	sets.midcast.FastRecast = {}
		
	-- Specific spells
	sets.midcast.Utsusemi = {}

	
	-- Defense sets
	sets.defense.PDT = {}

	sets.defense.MDT = {}
	
	sets.defense.Reraise = {head="Twilight Helm", body="Twilight Mail"}

    -- Gear to wear for kiting
	sets.Kiting = {}


end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)

end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end
 


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)

end

-- Runs when a pet initiates an action.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_midcast(spell, action, spellMap, eventArgs)

end

-- Run after the default pet midcast() is done.
-- eventArgs is the same one used in job_pet_midcast, in case information needs to be persisted.
function job_pet_post_midcast(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)

end

-- Run after the default aftercast() is done.
-- eventArgs is the same one used in job_aftercast, in case information needs to be persisted.
function job_post_aftercast(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_aftercast(spell, action, spellMap, eventArgs)

end

-- Run after the default pet aftercast() is done.
-- eventArgs is the same one used in job_pet_aftercast, in case information needs to be persisted.
function job_pet_post_aftercast(spell, action, spellMap, eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when the player's pet's status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if player.sub_job == 'SAM' then
		handle_sam_ja()
	end
	if player.sub_job == 'WAR' then
		handle_war_ja()
	end
end

-- Called when a generally-handled state value has been changed.
function job_state_change(stateField, newValue, oldValue)
	if stateField == 'Weapon Mode' then
		if newValue ~= 'Normal' then
			state.CombatWeapon:set(newValue)
		else
			state.CombatWeapon:reset()
		end
	end
	if stateField == 'Sub Mode' then
		if newValue ~= 'Normal' then
			state.CombatForm:set(newValue)
		else
			state.CombatForm:reset()
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	handle_twilight()
end

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)

end

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)

end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	return meleeSet
end

-- Modify the default defense set after it was constructed.
function customize_defense_set(defenseSet)
	return defenseSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	if areas.Assault:contains(world.area) then
			classes.CustomMeleeGroups:append('Assault')
	end
	pick_tp_weapon()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
	handle_flags(cmdParams, eventArgs)
end

-- Job-specific toggles.
function job_toggle_state(field)

end

-- Request job-specific mode lists.
-- Return the list, and the current value for the requested field.
function job_get_option_modes(field)

end

-- Set job-specific mode values.
-- Return true if we recognize and set the requested field.
function job_set_option_mode(field, val)

end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 14)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 14)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 14)
	else
		set_macro_page(1, 14)
	end
end

