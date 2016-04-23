
-- Assault equip.
areas.Assault = S{
	"Mamool Ja Training Grounds",
	"Periqia",
	"Lebros Cavern",
	"Ilrusi Atoll",
	"Leujaoam Sanctum",
	"Arrapago Remnants",
	"Silver Sea Remnants",
	"Zhayolm Remnants",
	"Bhaflau Remnants",
	"Nyzul Isle",
	"The Ashu Talif"
}

-- Job info
jobs = {}

jobs.MP = S{
	"WHM",
	"RDM",
	"BLM",
	"BLU",
	"SMN",
	"GEO",
	"PLD",
	"DRK",
	"SCH"
}

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	-- add_to_chat(122,'job update')
	-- if buffactive['reive mark'] then
			-- add_to_chat(122,'In Reive')
			-- classes.CustomMeleeGroups:append('Reive')
	-- elseif areas.Adoulin:contains(world.area) and buffactive.ionis then
			-- add_to_chat(122,'IN Adoulin')
			-- classes.CustomMeleeGroups:append('Adoulin')
	-- end
	if areas.Assault:contains(world.area) then
			classes.CustomMeleeGroups:append('Assault')
	end
	pick_tp_weapon()
end

state.WeaponMode = M{['description'] = 'Weapon Mode'}
state.RWeaponMode = M{['description'] = 'RWeapon Mode'}
state.SubMode = M{['description'] = 'Sub Mode'}
state.Stance = M{['description'] = 'Stance'}
state.holdtp = M{['description'] = 'holdtp'}
state.loyalty = M{['description'] = 'loyalty'}
flag = {}

function set_stance()
	if state.Stance.value == 'Off' then
		state.Stance:set('None')
	elseif state.Stance.value == 'None' then
		state.Stance:set('Offensive')
	elseif state.Stance.value == 'Offensive' then
		state.Stance:set('Defensive')
	elseif state.Stance.value == 'Defensive' then
		state.Stance:set('Off')
	else
		state.Stance:set('None')
	end
end

function set_combat_weapon()
	if state.WeaponMode.value == 'Axe' then
		state.CombatWeapon:set('Axe')
	elseif state.WeaponMode.value == 'Club' then
		state.CombatWeapon:set('Club')
	elseif state.WeaponMode.value == 'Dagger' then
		state.CombatWeapon:set('Dagger')
	elseif state.WeaponMode.value == 'GreatAxe' then
		state.CombatWeapon:set('GreatAxe')
	elseif state.WeaponMode.value == 'GreatKatana' then
		state.CombatWeapon:set('GreatKatana')
	elseif state.WeaponMode.value == 'GreatSword' then
		state.CombatWeapon:set('GreatSword')
	elseif state.WeaponMode.value == 'H2H' then
		state.CombatWeapon:set('H2H')
	elseif state.WeaponMode.value == 'Katana' then
		state.CombatWeapon:set('Katana')
	elseif state.WeaponMode.value == 'Polearm' then
		state.CombatWeapon:set('Polearm')
	elseif state.WeaponMode.value == 'Scythe' then
		state.CombatWeapon:set('Scythe')
	elseif state.WeaponMode.value == 'Staff' then
		state.CombatWeapon:set('Staff')
	elseif state.WeaponMode.value == 'Sword' then
		state.CombatWeapon:set('Sword')
	else
		state.CombatWeapon:set('None')
	end
	-- add_to_chat(123, 'combat weapon set to '..state.CombatWeapon.value)
end

function set_combat_form()
	-- add_to_chat(123, 'Sub Mode set to  '..state.SubMode.value)
	if state.SubMode.value == 'DW' then
		state.CombatForm:set('DW')
	elseif state.SubMode.value == 'DWpet' then
		state.CombatForm:set('DWpet')
	elseif state.SubMode.value == 'Grip' then
		state.CombatForm:set('Grip')
	elseif state.SubMode.value == 'Shield' then
		state.CombatForm:set('Shield')
	elseif state.SubMode.value == 'TH' then
		state.CombatForm:set('TH')
	else
		state.CombatForm:set('None')
	end
	-- add_to_chat(123, 'combat Form set to '..state.CombatForm.value)
end

function set_ranged_weapon()
	-- add_to_chat(123, 'custome melee groups '..CustomMeleeGroups)
	if state.RWeaponMode.value == 'Stats' then
		classes.CustomMeleeGroups:append('Stats')
	elseif state.RWeaponMode.value == 'Boomerrang' then
		classes.CustomMeleeGroups:append('Boomerrang')
	elseif state.RWeaponMode.value == 'Bow' then
		classes.CustomMeleeGroups:append('Bow')
	elseif state.RWeaponMode.value == 'Gun' then
		classes.CustomMeleeGroups:append('Gun')
	elseif state.RWeaponMode.value == 'Xbow' then
		classes.CustomMeleeGroups:append('Xbow')
	elseif state.RWeaponMode.value == 'Shuriken' then
		classes.CustomMeleeGroups:append('Shuriken')
	else
		classes.CustomMeleeGroups:append('None')
	end
	-- add_to_chat(123, 'Ranged weapon set to '..state.RWeaponMode.value)
end

function is_sc_element_today(spell)
	if spell.type ~= 'WeaponSkill' then
		return
	end
	local weaponskill_elements = S{}:
	union(skillchain_elements[spell.skillchain_a]):
	union(skillchain_elements[spell.skillchain_b]):
	union(skillchain_elements[spell.skillchain_c])
	if weaponskill_elements:contains(world.day_element) then
		return true
	else
		return false
	end
end

function is_magic_element_today(spell)
	-- if spell.skill ~= 'Elemental Magic' then
		-- return
	-- end
	-- add_to_chat(103,'spell'..spell.element..'weather'..world.weather_element..'day'..world.day_element)
	if spell.element == world.day_element then
		-- add_to_chat(101,'true')
		return true
	else
		-- add_to_chat(102,'false')
		return false
	end
end

function is_magic_element_weather(spell)
	-- add_to_chat(103,'spell'..spell.element..'weather'..world.weather_element..'day'..world.day_element)
	if spell.element == world.weather_element then
		-- add_to_chat(101,'true')
		return true
	else
		-- add_to_chat(102,'false')
		return false
	end
end


-- avoid losing tp
function check_tp_lock()
	if state.holdtp.value == 'true' then
		disable('main','sub','range')
	else
		if player.tp > 1000 then
			disable('main','sub','range')
		else
			enable('main','sub','range')
		end
	end
end

-- flags for when JA are up
function handle_flags(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'reset_sekka_flag' then
        flag.sekka = true
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'reset_med_flag' then
        flag.med = true
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'reset_thirdeye_flag' then
        flag.thirdeye = true
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'reset_berserk_flag' then
        flag.berserk = true
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'reset_defender_flag' then
        flag.defender = true
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'reset_aggressor_flag' then
        flag.aggressor = true
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'reset_warcry_flag' then
        flag.warcry = true
        eventArgs.handled = true
    end
end

-- job automation if stance is set correctly (outside of town)
function handle_war_ja() 
	if not areas.Cities:contains(world.area) and not (buffactive.Sneak or buffactive.Invisible) then
		if state.Stance.value == 'Offensive' then
			if not buffactive.Berserk and flag.berserk then
				windower.send_command('@input /ja "Berserk" <me>; wait 300; gs c reset_berserk_flag')
				flag.berserk = false
			end
			if not buffactive.Warcry and flag.warcry and player.status == "Engaged" and player.tp > 900 then
				windower.send_command('@input /ja "Warcry" <me>; wait 300; gs c reset_warcry_flag')
				flag.warcry = false
			end
			if not buffactive.Aggressor and flag.aggressor then
				windower.send_command('@input /ja "Aggressor" <me>; wait 300; gs c reset_warcry_flag')
				flag.aggressor = false
			end
		end
		if state.Stance.value == 'Defensive' then
			if not buffactive.Defender and flag.defender then
				windower.send_command('@input /ja "Defender" <me>; wait 300; gs c reset_defender_flag')
				flag.defender = false
			end
		end
	end
end

off_ja_tables = {}
off_ja_tables.SAM = {"Hasso","Meditate","Sekkanoki","Third Eye"}

-- the id #s for each abil come from the index value in resources.xml
function handle_sam_ja() 
	if not areas.Cities:contains(world.area) and not (buffactive.Sneak or buffactive.Invisible) then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		-- for __,spells in pairs(off_ja_tables) do
			-- for ___,spell in pairs(spells) do
				-- add_to_chat(2, 'sam-ja recast '..abil_recasts[spell.recast_id])
				 -- for k in pairs(abil_recasts) do
					-- add_to_chat(2, 'k '..k)
					-- add_to_chat(2, 'both '..abil_recasts[k])
				-- end
				-- add_to_chat(2, 'sam-ja recast '..spell)
			-- end
		-- end
		-- for spell in off_ja_tables.SAM do
			-- add_to_chat(2, 'sam-ja recast '..abil_recasts[spell.recast_id])
		-- end
		if state.Stance.value == 'Offensive' then
			if not buffactive.Hasso and abil_recasts[138] == 0 then
				-- add_to_chat(122,'no hasso ')
				windower.send_command('@input /ja "Hasso" <me>')
				-- add_to_chat(1,'sleeping ')
				-- user_sleep(2)
				-- add_to_chat(3,'done sleeping ')
			end
			if player.tp < 400 and abil_recasts[134] == 0 then
				-- add_to_chat(122,'low tp ')
				-- windower.send_command('@input /ja "Meditate" <me>; wait 180; gs c reset_med_flag')
				windower.send_command('@input /ja "Meditate" <me>')
				-- user_sleep(1)
				-- flag.med = false
			end
			if player.tp > 2000 and abil_recasts[140] == 0 and player.status == "Engaged" then
				-- add_to_chat(122,'high tp ')
				-- windower.send_command('@input /ja "Sekkanoki" <me>; wait 300; gs c reset_sekka_flag')
				windower.send_command('@input /ja "Sekkanoki" <me>')
				-- user_sleep(1)
				-- flag.sekka = false
			end
			if not buffactive.ThirdEye and abil_recasts[133] == 0 then
				-- windower.send_command('@input /ja "Third Eye" <me>; wait 60; gs c reset_thirdeye_flag')
				windower.send_command('@input /ja "Third Eye" <me>')
				-- user_sleep(1)
				-- flag.thirdeye = false
			end
		end
		if state.Stance.value == 'Defensive' then
			if not buffactive.ThirdEye then
				windower.send_command('@input  /ja "Seigan" <me>; wait 1.5; input /ja "Third Eye" <me>')
			end
		end
	end
end


-- override Mote's defaults
function global_on_load()
	send_command('bind f9 gs c cycle OffenseMode')
	send_command('bind @f9 gs c cycle HybridMode') 
	send_command('bind !f9 gs c cycle RangedMode') --alt
	send_command('bind ^f9 gs c cycle WeaponskillMode') --ctrl
	send_command('bind f10 gs c cycle WeaponMode')
	send_command('bind !f10 gs c cycle PhysicalDefenseMode') --alt
	send_command('bind !f10 gs c toggle Kiting') --ctrl
	send_command('bind f11 gs c cycle SubMode')
	send_command('bind ^f11 gs c cycle CastingMode') --ctrl
	send_command('bind !f10 gs c cycle MagicalDefenseMode') --alt
	send_command('bind f12 gs c cycle RWeaponMode')
	send_command('bind ^f12 gs c cycle IdleMode') --ctrl
	send_command('bind !f12 gs c cycle DefenseMode') -- alt

	send_command('bind ^- gs c toggle selectnpctargets')
	send_command('bind ^= gs c cycle pctargetmode')
end

function handle_twilight()
	if player.hpp <= 11 or buffactive['Weakness'] then
        Twilight = true
        equip(sets.defense.Reraise)
		disable('head','body')
		-- add_to_chat(1,'equip rr')
    else
        Twilight = false
		enable('head','body')
		-- add_to_chat(2,'rr off')
    end
end

function pick_tp_weapon()
	-- add_to_chat(122,' pick tp weapon '..state.WeaponMode.value)
	set_combat_weapon()
	set_ranged_weapon()
	-- add_to_chat(123, 'combat weapon set to '..state.CombatWeapon.value)
end

function check_ws_dist(spell)
	if player.status == 'Engaged' then
		if spell.type == 'WeaponSkill' and spell.target.distance > 5.1 then
			cancel_spell()
			add_to_chat(123, 'WeaponSkill Canceled: [Out of Range]')
		end
	end
end

degrade_tables = {}
degrade_tables.Aspir = {"Aspir","Aspir II","Aspir III"}
degrade_tables.Aero = {"Aero","Aero II","Aero III","Aero IV","Aero V","Aero VI"}
degrade_tables.Blizzard = {"Blizzard","Blizzard II","Blizzard III","Blizzard IV","Blizzard V","Blizzard VI"}
degrade_tables.Fire = {"Fire","Fire II","Fire III","Fire IV","Fire V","Fire VI"}
degrade_tables.Stone = {"Stone","Stone II","Stone III","Stone IV","Stone V","Stone VI"}
degrade_tables.Thunder = {"Thunder","Thunder II","Thunder III","Thunder IV","Thunder V","Thunder VI"}
degrade_tables.Water = {"Water","Water II","Water III","Water IV","Water V","Water VI"}
degrade_tables.Cure = {"Cure","Cure II","Cure III","Cure IV","Cure V","Cure VI"}
degrade_tables.Aeroga = {"Aeroga","Aeroga II","Aeroga III"}
degrade_tables.Blizzaga = {"Blizzaga","Blizzaga II","Blizzaga III"}
degrade_tables.Firaga = {"Firaga","Firaga II","Firaga III"}
degrade_tables.Stonega = {"Stonega","Stonega II","Stonega III"}
degrade_tables.Thundaga = {"Thundaga","Thundaga II","Thundaga III"}
degrade_tables.Waterga = {"Waterga","Waterga II","Waterga III"}
degrade_tables.Aera = {"Aera","Aera II","Aera III"}
degrade_tables.Blizzara = {"Blizzara","Blizzara II","Blizzara III"}
degrade_tables.Fira = {"Fira","Fira II","Fira III"}
degrade_tables.Stonera = {"Stonera","Stonera II","Stonera III"}
degrade_tables.Thundara = {"Thundara","Thundara II","Thundara III"}
degrade_tables.Watera = {"Watera","Watera II","Watera III"}

function handle_spells(spell)
	-- add_to_chat(2, 'Casting '..spell.name)
    local spell_recasts = windower.ffxi.get_spell_recasts()
    if (spell_recasts[spell.recast_id]>0 or player.mp<actual_cost(spell)) and find_degrade_table(spell) then      
        degrade_spell(spell,find_degrade_table(spell))
    end
end
 
function find_degrade_table(lookup_spell)
    for __,spells in pairs(degrade_tables) do
        for ___,spell in pairs(spells) do
            if spell == lookup_spell.english then
                return spells
            end
        end
    end
    return false
end
 
function degrade_spell(spell,degrade_array)
    local spell_index = table.find(degrade_array,spell.english)
    if spell_index>1 then        
        local new_spell = degrade_array[spell_index - 1]
        change_spell(new_spell,spell.target.id)
        add_to_chat(140,spell.english..' has been canceled. Using '..new_spell..' instead.')
    end
end
 
function change_spell(spellName,target)
    cancel_spell()
    send_command(spellName..' '..target)
end
 
function actual_cost(spell)
    local cost = spell.mp_cost
    if spell.type=="WhiteMage" then
        if buffactive["Penury"] then
            return cost*.5
        elseif buffactive["Light Arts"] or buffactive["Addendum: White"] then
            return cost*.9
        elseif buffactive["Dark Arts"] or buffactive["Addendum: Black"] then
            return cost*1.1
        end
    elseif spell.type=="BlackMagic" then
        if buffactive["Parsimony"] then
            return cost*.5
        elseif buffactive["Dark Arts"] or buffactive["Addendum: Black"] then
            return cost*.9
        elseif buffactive["Light Arts"] or buffactive["Addendum: White"] then
            return cost*1.1
        end   
    end
    return cost
end