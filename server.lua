Config = nil
exports('GetConfig', function (config)
    Config = config
end)
exports('GetBannedPlayers', function()
    local fetch = [[SELECT * FROM bannedplayers]]
    local result = FetchAll(fetch)
    local embed = {
        fields = {},
        color = "#0094ff", -- blue
        author = 'PLAYERS',
    }
    if #result > 0 then
        for i = 1, #result do
            local admin
            if result[i].admin then
                admin = tonumber(result[i].admin) and '<@'..result[i].admin..'>' or result[i].admin
            else
                admin = '...'
            end
            table.insert(embed.fields, {name = 'Player', value = result[i].identifier or '...', inline = true})
            table.insert(embed.fields, {name = 'Admin', value = admin, inline = true})
            table.insert(embed.fields, {name = 'Reason', value = result[i].reason or '...', inline = true})
            if #embed.fields >= 24 then
                TriggerEvent('AF-serverman:SendEmbed', embed)
                embed.fields = {}
            end
        end
        TriggerEvent('AF-serverman:SendEmbed', embed)
    else
        local embed = {
            description = "Not banned players found",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)
exports('GetBannedPlayer', function(id)
    if GetPlayerName(id) then
        id = tonumber(id)
        local fetch = [[SELECT * FROM bannedplayers WHERE identifier = @id;]]
        local fetchData = {['@id'] = Identifier(id)}
        local result = FetchAll(fetch, fetchData)
        if result and result[1] then
            local admin
            if result[1].admin then
                admin = tonumber(result[1].admin) and '<@'..result[1].admin..'>' or result[1].admin
            else
                admin = '...'
            end
            local embed = {
                fields = {
                    {name = 'identifier', value = result[1].identifier or '...', inline = true},
                    {name = 'admin', value = admin, inline = true},
                    {name = 'discord', value = result[1].discord and '<@'..string.gsub(result[1].discord, 'discord:', '')..'>' or '...', inline = true},
                    {name = 'rockstar', value = result[1].rockstar or '...', inline = true},
                    {name = 'steam', value = result[1].steam or '...', inline = true},
                    {name = 'xbox', value = result[1].xbox or '...', inline = true},
                    {name = 'live', value = result[1].live or '...', inline = true},
                    {name = 'ip', value = result[1].ip or '...', inline = true},
                    {name = 'reason', value = result[1].reason or '...', inline = true},
                    {name = 'time', value = os.date('%d.%m.%Y %H:%M', result[1].time), inline = true}
                },
                color = "#0094ff", -- blue
                author = result[1].name or 'Name Is NULL'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    else
        local fetch = [[SELECT * FROM bannedplayers WHERE identifier = @id;]]
        local fetchData = {['@id'] = id}
        local result = FetchAll(fetch, fetchData)
        if result and result[1] then
            local admin
            if result[1].admin then
                admin = string.match(result[1].admin, 'discord:') and '<@'..result[1].admin..'>' or result[1].admin
            else
                admin = '...'
            end
            local embed = {
                fields = {
                    {name = 'identifier', value = result[1].identifier or '...', inline = true},
                    {name = 'admin', value = admin, inline = true},
                    {name = 'discord', value = result[1].discord and '<@'..string.gsub(result[1].discord, 'discord:', '')..'>' or '...', inline = true},
                    {name = 'rockstar', value = result[1].rockstar or '...', inline = true},
                    {name = 'xbox', value = result[1].xbox or '...', inline = true},
                    {name = 'steam', value = result[1].steam or '...', inline = true},
                    {name = 'live', value = result[1].live or '...', inline = true},
                    {name = 'ip', value = result[1].ip or '...', inline = true},
                    {name = 'reason', value = result[1].reason or '...', inline = true},
                    {name = 'time', value = os.date('%d.%m.%Y %H:%M', result[1].time), inline = true}
                },
                color = "#0094ff", -- blue
                author = result[1].name or 'Name Is NULL'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        else
            local embed = {
                description = "Player is not banned.",
                color = "#33ff00",
                author = 'INFORM'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end
end)
exports('GetDiscordFromId', function (id)
    id = tonumber(id)
    for _,v in ipairs(GetPlayerIdentifiers(id)) do
        if string.match(v, 'discord:') then
            return string.gsub(v, 'discord:', '')
        end
    end
    return false
end)
exports('Wipe', function (id)
    if GetPlayerName(id) then
        local fetch = [[SELECT identifier FROM users WHERE identifier = @id]]
        local fetchData = {['@id'] = Identifier(id)}
        local result = FetchAll(fetch, fetchData)
        if result and result[1] then
            for _, v in pairs(Config.wipe_tables) do
                MySQL.Async.execute('DELETE FROM addon_account_data WHERE owner = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM addon_inventory_items WHERE owner = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM billing WHERE identifier = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM billing WHERE sender = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM datastore_data WHERE owner = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM owned_properties WHERE owner = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM rented_vehicles WHERE owner = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('UPDATE users SET bank = 0 WHERE identifier = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('UPDATE users SET money = 0 WHERE identifier = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('UPDATE users SET job = "unemployed" WHERE identifier = @identifier', { ['@identifier'] = Identifier(id) })
                MySQL.Async.execute('UPDATE users SET job_grade = 0 WHERE identifier = @identifier', { ['@identifier'] = Identifier(id) })
            end
            local embed = {
                description = GetPlayerName(id).." Wiped",
                color = "#33ff00",
                author = 'SUCCESS'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
            DropPlayer(id, 'Your character has been deleted.') 
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    else
        local fetch = [[SELECT identifier FROM users WHERE identifier = @id;]]
        local fetchData = {['@id'] = id}
        local result = FetchAll(fetch, fetchData)
        print(result)
        if result and result[1] then
            for _, v in ipairs(Config.wipe_tables) do
                MySQL.Async.execute('DELETE FROM addon_account_data WHERE owner = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM addon_inventory_items WHERE owner = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM billing WHERE identifier = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM billing WHERE sender = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM datastore_data WHERE owner = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM owned_properties WHERE owner = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM rented_vehicles WHERE owner = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('UPDATE users SET bank = 0 WHERE identifier = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('UPDATE users SET money = 0 WHERE identifier = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('UPDATE users SET job = "unemployed" WHERE identifier = @identifier', { ['@identifier'] = id })
                MySQL.Async.execute('UPDATE users SET job_grade = 0 WHERE identifier = @identifier', { ['@identifier'] = id })
            end
            local embed = {
                description = id.." Wiped",
                color = "#33ff00",
                author = 'SUCCESS'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end
end)
exports('GetInventory', function (id)
    if GetPlayerName(id) then
        id = tonumber(id)
        local embed = {
            fields = {},
            color = "#0094ff", -- blue
            author = 'SUCCESS'
        }
        TriggerEvent('esx:getSharedObject', function(ESX)
            local inventory = ESX.GetPlayerFromId(id).inventory
            if inventory and next(inventory) then
                for i = 1, #inventory do
                    if inventory[i].count > 0 then
                        table.insert(embed.fields, {name = ESX.Items[inventory[i].name] and ESX.Items[inventory[i].name].label or inventory[i].name, value = inventory[i].count, inline = true})
                        if #embed.fields >= 24 then
                            TriggerEvent('AF-serverman:SendEmbed', embed)
                            embed.fields = {}
                        end
                    end
                end
            else
                embed.description = 'Doesn\'t have an item'
            end
            if #embed.fields == 0 then
                embed.description = 'Doesn\'t have an item'
            end
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end)
    else
        local fetch = [[SELECT inventory FROM users WHERE identifier = @id;]]
        local fetchData = {['@id'] = id}
        local result = FetchAll(fetch, fetchData)
        if result and result[1] then
            local embed = {
                fields = {},
                color = "#0094ff", -- blue
                author = 'SUCCESS'
            }
            local inventory = json.decode(result[1].inventory)
            if next(inventory) then
                for k,v in pairs(inventory) do
                    embed.fields[#embed.fields+1] = {name = k, value = v, inline = true}
                    if #embed.fields >= 24 then
                        TriggerEvent('AF-serverman:SendEmbed', embed)
                        embed.fields = {}
                    end
                end
            else    
                embed.description = 'Doesn\'t have an item'
            end
            TriggerEvent('AF-serverman:SendEmbed', embed)
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end
end)
exports('SetCoords', function (id, x, y, z)
    if GetPlayerName(id) then
        TriggerClientEvent('esx:teleport', id, {x = tonumber(x), y = tonumber(y), z = tonumber(z)})  
    	TriggerClientEvent('chat:addMessage', id, { args = { '^1SYSTEM', '^6Shoma Az Tarig Discord Set Coords Shodid.' } })
        local embed = {
            color = "#0094ff", -- blue
            author = 'SUCCESS',
            title = '`'..GetPlayerName(id)..'` Coords has been set. \n**Teleported coords** \nx = `'..x..'` \ny = `'..y..'` \nz = `'..z..'`'
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    else
        local embed = {
            description = "Player Is Not Online",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)
exports('GetMoney', function (id)
    if GetPlayerName(id) then
        id = tonumber(id)
        TriggerEvent('esx:getSharedObject', function(ESX)
            local xPlayer = ESX.GetPlayerFromId(id)
            local embed = {
                fields = {
                    {name = 'Bank', value = xPlayer.money, inline = true},
                    {name = 'Money', value = xPlayer.bank, inline = true},
                    -- {name = 'Black Money', value = xPlayer.black_money, inline = true}
                },
                color = "#0094ff", -- blue
                author = 'SUCCESS'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end)
    else
        local fetch = [[SELECT accounts FROM users WHERE identifier = @id;]]
        local fetchData = {['@id'] = id}
        local result = FetchAll(fetch, fetchData)
        if result and result[1] then
            local embed = {
                fields = {},
                color = "#0094ff", -- blue
                author = 'SUCCESS'
            }
            if result[1].accounts and json.decode(result[1].accounts) then
                local accounts = json.decode(result[1].accounts)
                if accounts.bank then
                    table.insert(embed.fields, {
                        name = 'Bank',
                        value = accounts.bank
                    })
                end
                if accounts.black_money then
                    table.insert(embed.fields, {
                        name = 'Black Money',
                        value = accounts.black_money
                    })
                end
                if accounts.money then
                    table.insert(embed.fields, {
                        name = 'Cash',
                        value = accounts.money
                    })
                end
                TriggerEvent('AF-serverman:SendEmbed', embed)
            else
                local embed = {
                    description = "[DATABASE] Not finded accounts",
                    color = "#ff0000",
                    author = 'WARNING'
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            end
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end
end)
exports('GetGeneralInformations', function (id)
    TriggerEvent('esx:getSharedObject', function(ESX)
        local xPlayer = ESX.GetPlayerFromId(id)
        local jailPlayerData = ESX.GetPlayerFromId(jailPlayer)
        if GetPlayerName(id) then
            local dutystaff = ''
            local adutystaff = ''
            local adutystaff1 = 0
            if xPlayer.get('aduty') then
                dutystaff = 'On Duty Admini'
                adutystaff1 = 1
            else
                dutystaff = 'Off Duty Admini'
            end
            if xPlayer.get('aa') then
                dutystaff = 'On Duty AA'
            end
            local embed = {
                fields = {
                    {name = 'Identifier', value = GetPlayerIdentifier(id), inline = true},
                    {name = 'playerName    ', value = GetPlayerName(id), inline = true},
                    {name = 'Perm', value = xPlayer.perm_level, inline = true},
                    {name = 'Aduty', value = dutystaff, inline = true},
                    {name = 'Job', value = xPlayer.job.name, inline = true},
                    {name = 'Grade', value = xPlayer.job.grade, inline = true},
                    {name = 'Group', value = xPlayer.group or '...', inline = true},
                    {name = 'Money', value = xPlayer.money, inline = true},
                    {name = 'Bank', value = xPlayer.bank, inline = true},
                },
                color = "#0094ff", -- blue
                author = 'SUCCESS'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end)
end)
exports('addmoney', function (id, type, amount)
    if GetPlayerName(id) then
        TriggerEvent('esx:getSharedObject', function(ESX)
            local xPlayer = ESX.GetPlayerFromId(id)
            if xPlayer then
                local oldMoney = xPlayer.money
                -- xPlayer.addAccountMoney   (itemName, amount)
                -- xPlayer.setMoney(amount)
                xPlayer.addMoney(tonumber(amount))
                local embed = {
                    color = "#0094ff", -- blue
                    title = '`'..GetPlayerName(id)..'` Aded Money `'..amount..'` \nOld Balance: `'..oldMoney..'` \nNew Balance: `'..oldMoney+amount..'` \nType: `'..type..'`',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            else   
                local embed = {
                    description = "[ESX] Not Finded Player",
                    color = "#ff0000",
                    author = 'WARNING'
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            end
        end)
    else    
        local fetch = [[SELECT accounts FROM users WHERE identifier = @id]]
        local fetchData = {['@id'] = id}
        local result = FetchAll(fetch, fetchData)
        if result and result[1] then
            if result[1].accounts and json.decode(result[1].accounts) then
                local accounts = json.decode(result[1].accounts)
                local oldMoney = accounts[type]
                accounts[type] = math.floor(accounts[type] + tonumber(amount))
                Execute('UPDATE users SET accounts = @accounts WHERE identifier = @id', {['@accounts'] = json.encode(accounts), ['@id'] = id})
                local embed = {
                    color = "#0094ff", -- blue
                    title = '`'..GetPlayerName(id)..'` gived `'..amount..'` \nOld Balance: `'..oldMoney..'` \nNew Balance: `'..accounts[type]..'` \nType: `'..type..'`',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            else
                local embed = {
                    description = "[DATABASE] Not finded accounts",
                    color = "#ff0000",
                    author = 'WARNING'
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            end
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end 
end)
exports('SetJob', function(id, job, grade)
    TriggerEvent('esx:getSharedObject', function(ESX)
        if ESX.DoesJobExist(job, grade) then
            if GetPlayerName(id) then
                local xPlayer = ESX.GetPlayerFromId(id)
                if xPlayer then
                    local beforeJob = xPlayer.job.name
                    local beforeJobGrade = xPlayer.job.grade
                    xPlayer.setJob(job, grade)
                    local embed = {
                        color = "#0094ff", -- blue
                        title = GetPlayerName(id)..' setted job \nOld Job: `'..beforeJob..'`\nNew Job: `'..job..'` \nOld Grade: `'..beforeJobGrade..'` \nNew Grade: `'..grade..'`',
                    }
                    TriggerEvent('AF-serverman:SendEmbed', embed)
                else   
                    local embed = {
                        description = "[ESX] Not Finded Player",
                        color = "#ff0000",
                        author = 'WARNING'
                    }
                    TriggerEvent('AF-serverman:SendEmbed', embed)
                end
            else    
                local fetch = [[SELECT job, job_grade FROM users WHERE identifier = @id]]
                local fetchData = {['@id'] = id}
                local result = FetchAll(fetch, fetchData)
                if result and result[1] then
                    Execute('UPDATE users SET job = @job, job_grade = @grade WHERE identifier = @id', {
                        ['@job'] = job,
                        ['@grade'] = grade,
                        ['@id'] = id
                    })
                    local embed = {
                        color = "#0094ff", -- blue
                        title = id..' setted job \nOld Job: `'..result[1].job..'`\nNew Job: `'..job..'` \nOld Grade: `'..result[1].job_grade..'` \nNew Grade: `'..grade..'`',
                    }
                    TriggerEvent('AF-serverman:SendEmbed', embed)
                else
                    local embed = {
                        description = "Not finded player",
                        color = "#ff0000",
                        author = 'WARNING'
                    }
                    TriggerEvent('AF-serverman:SendEmbed', embed)
                end
            end 
        else    
            local embed = {
                description = "[ESX] The job, grade or both are invalid",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end)
end)
exports('Setperm', function(id, group, perm)
    TriggerEvent('esx:getSharedObject', function(ESX)
        if GetPlayerName(id) then
            local xPlayer = ESX.GetPlayerFromId(id)
            if xPlayer then
                local beforeperm = xPlayer.perm_level
                local beforegroup = xPlayer.group
                xPlayer.setPerm(tonumber(perm))
                xPlayer.setGroup(group)
                local embed = {
                    color = "#0094ff", -- blue
                    title = GetPlayerName(id)..'Seted :\n'..'Before Group :`'..beforegroup..'`  New Group :`'..group..'`\nBefore Perm :`'..beforeperm..'`New Perm :`'..perm..'`',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            else   
                local embed = {
                    description = "[ESX] Not Finded Player",
                    color = "#ff0000",
                    author = 'WARNING'
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            end
        
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end)
end)
exports('Setgang', function(id, gang, grade)
    TriggerEvent('esx:getSharedObject', function(ESX)
        if GetPlayerName(id) then
            local xPlayer = ESX.GetPlayerFromId(id)
            if xPlayer then
                local beforegang = xPlayer.gang.name
                local beforerank = xPlayer.gang.grade
				xPlayer.setGang(gang, tonumber(grade))
                local embed = {
                    color = "#0094ff", -- blue
                    title = GetPlayerName(id)..'Seted :\n'..'Before Gang :`'..beforegang..'`  New Group :`'..gang..'`\nBefore Rank :`'..beforerank..'`New Perm :`'..grade..'`',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            else   
                local embed = {
                    description = "[ESX] Not Finded Player",
                    color = "#ff0000",
                    author = 'WARNING'
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            end
        
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end)
end)
exports('RemoveMoney', function (id, type, amount)
    if GetPlayerName(id) then
        TriggerEvent('esx:getSharedObject', function(ESX)
            local xPlayer = ESX.GetPlayerFromId(id)
            if xPlayer then
                local oldMoney = xPlayer.money
                -- xPlayer.removeAccountMoney(type, tonumber(amount))
                xPlayer.removeMoney(tonumber(amount))
                local embed = {
                    color = "#0094ff", -- blue
                    title = '`'..GetPlayerName(id)..'` taked `'..amount..'` \nOld Balance: `'..oldMoney..'` \nNew Balance: `'..xPlayer.money..'` \nType: `'..type..'`',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            else   
                local embed = {
                    description = "[ESX] Not Finded Player",
                    color = "#ff0000",
                    author = 'WARNING'
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            end
        end)
    else    
        local fetch = [[SELECT accounts FROM users WHERE identifier = @id]]
        local fetchData = {['@id'] = id}
        local result = FetchAll(fetch, fetchData)
        if result and result[1] then
            if result[1].accounts and json.decode(result[1].accounts) then
                local accounts = json.decode(result[1].accounts)
                local oldMoney = accounts[type]
                accounts[type] = math.floor(accounts[type] - tonumber(amount))
                Execute('UPDATE users SET accounts = @accounts WHERE identifier = @id', {['@accounts'] = json.encode(accounts), ['@id'] = id})
                local embed = {
                    color = "#0094ff", -- blue
                    title = '`'..id..'` taked `'..tonumber(amount)..'` \nOld Balance: `'..oldMoney..'` \nNew Balance: `'..accounts[type]..'` \nType: `'..type..'`',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            else    
                local embed = {
                    description = "[DATABASE] Not finded accounts",
                    color = "#ff0000",
                    author = 'WARNING'
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            end
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end 
end)
exports('GiveItem', function (id, name, count)
    count = tonumber(count)
    if GetPlayerName(id) then
        TriggerEvent('esx:getSharedObject', function(ESX)
            ESX.GetPlayerFromId(id).addInventoryItem(name, count)
            local embed = {
                color = "#0094ff", -- blue
                title = '`'..GetPlayerName(id)..'` gived item. \nItem name:`'..name..'` \nCount: `'..count..'`',
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end)
    else
        local fetch = [[SELECT inventory FROM users WHERE identifier = @id]]
        local fetchData = {['@id'] = id}
        local result = FetchAll(fetch, fetchData)
        if result and result[1] then
            if result[1].inventory then
                local inventory = json.decode(result[1].inventory)
                inventory[name] = inventory[name] >= 0 and count + inventory[name]
                Execute('UPDATE users SET inventory = @inv WHERE identifier = @id',  {
                    ['@id'] = id,
                    ['@inv'] = json.encode(inventory)
                })
                local embed = {
                    color = "#0094ff", -- blue
                    title = '`'..id..'` gived item. \nItem name:`'..name..'` \nCount: `'..count..'`',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            else
                Execute('UPDATE users SET inventory = @inv WHERE identifier = @id',  {
                    ['@id'] = id,
                    ['@inv'] = json.encode({name = count})
                })
                local embed = {
                    color = "#0094ff", -- blue
                    title = '`'..id..'` gived item. \nItem name:`'..name..'` \nCount: `'..count..'`',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            end
        else
            local embed = {
                description = "Not finded player",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end
end)
exports('GetPlayers', function ()
    local embed = {
        color = "#0094ff", -- blue
        author = 'PLAYERS',
    }
    TriggerEvent('esx:getSharedObject', function(ESX)
        local players = ESX.GetPlayers()
        embed.title = '`'..#players..'` Online Player(s)'
        if next(players) then
            embed.fields = {
                {name = '[ID] | NAME | Ping | Perm', inline = true, value = ''},
                {name = 'DISCORD', inline = true, value = ''},
                {name = 'IDENTIFIER', inline = true, value = ''}
            }
            for i = 1, #players do
                local xPlayer = ESX.GetPlayerFromId(players[i])
                local discord = GetDiscord(players[i]) or 'Not Finded'
                embed.fields[1].value = embed.fields[1].value..' ['..players[i]..'] | '..GetPlayerName(players[i])..'\n'..'PING : '..GetPlayerPing(players[i])..' | Perm :'..xPlayer.perm_level..'\n------------------------------\n'
                embed.fields[2].value = embed.fields[2].value..'<@'..discord..'>\n\n------------------------------\n'
                embed.fields[3].value = embed.fields[3].value..'(ID :'..players[i]..')  |  '..xPlayer.identifier..'\n------------------------------\n'
            end
        end
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end)
end)
exports('Jobs', function ()
    local embed = {
        color = "#0094ff", -- blue
        author = 'PLAYERS',
    }
    TriggerEvent('esx:getSharedObject', function(ESX)
        local xPlayer = ESX.GetPlayerFromId(source)
        local pdha,mecha,taxiha,medha,sheriff,Weazel = 0,0,0,0,0,0
            local xPlayers = ESX.GetPlayers()
                    for i=1, #xPlayers, 1 do
            local xP = ESX.GetPlayerFromId(xPlayers[i])
            if xP.job.name == 'police' then
            pdha = pdha + 1
            elseif xP.job.name == 'mechanic' then
            mecha = mecha + 1
            elseif xP.job.name == 'taxi' then
            taxiha = taxiha + 1
            elseif xP.job.name == 'ambulance' then
            medha = medha + 1
            elseif xP.job.name == 'sheriff' then
            sheriff = sheriff + 1
            elseif xP.job.name == 'nojob' then
            Weazel = Weazel + 1
            end
            
            end
        local Jobs = pdha+mecha+taxiha+medha+sheriff
        embed.title = '`'..Jobs..'` Online Job(s)'
        embed.fields = {
            {name = ':police_officer_tone1:Police:police_officer_tone1:', inline = true, value = '`'..pdha..'`'},
            {name = ':ambulance:Medic:ambulance:', inline = true, value = '`'..medha..'`'},
            {name = ':taxi:Taxi:taxi:', inline = true, value = '`'..taxiha..'`'},
            {name = ':mechanic_tone1:Mechanic:mechanic_tone1:', inline = true, value = '`'..mecha..'`'},
            {name = ':man_guard_tone1:Sheriff:man_guard_tone1:', inline = true, value = '`'..sheriff..'`'},
            {name = ':newspaper:Weazel News:newspaper:', inline = true, value = '`'..Weazel..'`'}
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end)
end)
exports('Revive', function (id)    
    if GetPlayerName(id) then
        TriggerClientEvent('esx_ambulancejob:revive', id)
        local embed = {
            color = "#0094ff", -- blue
            title = '`'..GetPlayerName(id)..'` Revived.',
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    else    
        local embed = {
            description = "Player is not ingame",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)
local frozen = {}
exports('Freeze', function (id)    
	if id then
		if(tonumber(id) and GetPlayerName(tonumber(id)))then
			local player = tonumber(id)

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				if(frozen[player])then
					frozen[player] = false
				else
					frozen[player] = true
				end

				TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])

				local state = "unfrozen"
				if(frozen[player])then
					state = "frozen"
				end

                local embed = {
                    color = "#0094ff", -- blue
                    title = '`'..GetPlayerName(id)..'`'..state..'.',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)

				TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "You have been " .. state .. " by ^2 Discord"} })
			end)
		else
            local embed = {
                description = "Player is not ingame",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
		end
	else
        local embed = {
            description = "Player is not ingame",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
	end
end)
exports('GiftAll', function (id)    
    if id ~= nil then
        local playerstedad = 0
        TriggerEvent('esx:getSharedObject', function(ESX)
            local xPlayers   = ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                playerstedad = playerstedad + 1
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                xPlayer.addMoney(tonumber(id))
                TriggerClientEvent('esx:ShowNotification', xPlayer.source, 'shoma $'.. id .. ' jayze gereftid')
            end
        end)
        local embed = {
            color = "#0094ff", -- blue
            title = 'Gift All Be `'..playerstedad..'` Tedad Player Dade Shod',
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    else    
        local embed = {
            description = "Player is not ingame",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)
exports('Slay', function (id)    
    if GetPlayerName(id) then
        TriggerClientEvent('es_admin:kill', id)
        local embed = {
            color = "#0094ff", -- blue
            title = '`'..GetPlayerName(id)..'` Slayed.',
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    else    
        local embed = {
            description = "Player is not ingame",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)
exports('Charmenu', function (id)    
    if GetPlayerName(id) then
        TriggerClientEvent('skincreator:newChar', id)
        local embed = {
            color = "#0094ff", -- blue
            title = '`'..GetPlayerName(id)..'` Charmenu Khord.',
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    else    
        local embed = {
            description = "Player is not ingame",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)
exports('start', function(name)
    local find = false
    for i = 1, GetNumResources() do
        local resource_id = i - 1
		local resource_name = GetResourceByFindIndex(resource_id)
        if name == resource_name then
            find = true
            break
        end
    end
    if find then
        local embed = {
            color = "#0094ff", -- blue
            title = name..' Started.',
        }
        ExecuteCommand('ensure '..name)
        TriggerEvent('AF-serverman:SendEmbed', embed)
    else
        local embed = {
            color = "#0094ff", -- blue
            title = 'Script not found!',
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)
exports('start', function(name)
    local find = false
    for i = 1, GetNumResources() do
        local resource_id = i - 1
		local resource_name = GetResourceByFindIndex(resource_id)
        if name == resource_name then
            find = true
            break
        end
    end
    if find then
        local embed = {
            color = "#0094ff", -- blue
            title = name..' Started.',
        }
        ExecuteCommand('restart '..name)
        TriggerEvent('AF-serverman:SendEmbed', embed)
    else
        local embed = {
            color = "#0094ff", -- blue
            title = 'Script not found!',
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)
exports('stop', function(name)
    local find = false
    for i = 1, GetNumResources() do
        local resource_id = i - 1
		local resource_name = GetResourceByFindIndex(resource_id)
        if name == resource_name then
            find = true
            break
        end
    end
    if find then
        if GetResourceState(name) ~= 'stopped' and name ~= 'AF-servermanbot' then
            local embed = {
                color = "#0094ff", -- blue
                title = name..' Stopped.',
            }
            ExecuteCommand('stop '..name)
            TriggerEvent('AF-serverman:SendEmbed', embed)
        else
            local embed = {
                color = "#0094ff", -- blue
                title = 'The script is already closed!',
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    else
        local embed = {
            color = "#0094ff", -- blue
            title = 'Script not found!',
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)
exports('refresh', function ()
    local embed = {
        color = "#0094ff", -- blue
        title = 'Scripts have been refreshed.',
    }
    ExecuteCommand('GetAllR')
    TriggerEvent('AF-serverman:SendEmbed', embed)
end)
exports('ReviveAll', function ()
    TriggerEvent('esx:getSharedObject', function(ESX)
        local players = ESX.GetPlayers()
        for i = 1, #players do
            TriggerClientEvent('esx_ambulancejob:revive', players[i])
        end
        if next(players) then
            local embed = {
                color = "#0094ff", -- blue
                title = 'All Players Revived. Total:`'..#players..'`',
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        else    
            local embed = {
                color = "#0094ff", -- blue
                title = 'Not player found.',
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end)
end)
exports('spawnCar', function (id, name)
    if GetPlayerName(id) then
        TriggerClientEvent('esx:spawnVehicle', id, name)
        local embed = {
            color = "#0094ff", -- blue
            title = ' `'..name..'` given to `'..GetPlayerName(id)..'`',
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    else    
        local embed = {
            description = "Player is not ingame",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('AF-serverman:SendEmbed', embed)
    end
end)

exports('setduty', function (id)
    TriggerEvent('esx:getSharedObject', function(ESX)
        local xPlayer = ESX.GetPlayerFromId(id)
        if GetPlayerName(id) then
            if xPlayer.perm_level > 0 then
                if xPlayer.get('aduty') then
                    xPlayer.set('aduty', false)
                    TriggerClientEvent('chat:addMessage', id, { args = { '^1SYSTEM', '^6Shoma Az Tarig Discord Off Duty Admini Shodid.' } })
                    local embed = {
                        color = "#0094ff", -- blue
                        title = ' `'..GetPlayerName(id)..'` Aduty Set To **Off**',
                    }
                    TriggerEvent('AF-serverman:SendEmbed', embed)
                else
                    xPlayer.set('aduty', true)
                    TriggerClientEvent('chat:addMessage', id, { args = { '^1SYSTEM', '^6Shoma Az Tarig Discord On Duty Admini Shodid.' } })
                    local embed = {
                        color = "#0094ff", -- blue
                        title = ' `'..GetPlayerName(id)..'` Aduty Set To **On**',
                    }
                    TriggerEvent('AF-serverman:SendEmbed', embed)
                end
            else
                local embed = {
                    color = "#0094ff", -- blue
                    title = ' `'..GetPlayerName(id)..'` Player Is Not Admin**',
                }
                TriggerEvent('AF-serverman:SendEmbed', embed)
            end
        else    
            local embed = {
                description = "Player is not ingame",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end)
end)
exports('spawnAllPlayersCar', function (name)
    TriggerEvent('esx:getSharedObject', function(ESX)
        local players = ESX.GetPlayers()
        if #players > 0 then
            for i = 1, #players do
                TriggerClientEvent('esx:spawnVehicle', players[i], name)
            end
            local embed = {
                color = "#0094ff", -- blue
                title = ' Total Gived Vehicle: `'..#players..'`',
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        else    
            local embed = {
                description = "Player No player found on the server.",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end
    end)
end)
exports('giveWeapon', function (id, name, ammo)
    ammo = tonumber(ammo)
    TriggerEvent('esx:getSharedObject', function(ESX)
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
            xPlayer.addWeapon(name, ammo)
            local embed = {
                color = "#0094ff", -- blue
                title = ' `'..name..'` given to `'..GetPlayerName(id)..'`',
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        else    
            local embed = {
                description = "Player is not ingame",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('AF-serverman:SendEmbed', embed)
        end  
    end)
end)
function Identifier(player)
    for _,v in ipairs(GetPlayerIdentifiers(player)) do
        if Config.identifier == 'steam' then  
             if string.match(v, 'steam') then
                  return v
             end
        elseif Config.identifier == 'license' then
             if string.match(v, 'license:') then
                  return string.sub(v, 9)
             end
        end
    end
    return ''
end
function GetDiscord(id)
    for _,v in ipairs(GetPlayerIdentifiers(id)) do
        if string.match(v, 'discord:') then
            return string.gsub(v, 'discord:', '')
        end
    end
    return false
end
function GetJobProps(name, grade)
    local fetch = [[SELECT label FROM job_grades WHERE job_name = @name AND grade = @grade;]]
    local fetchData = {
        ['@name'] = name,
        ['@grade'] = grade
    }
    local result = FetchAll(fetch, fetchData)
    return result
end
function FetchAll(query, params)
    return MySQL.Sync.fetchAll(query, params)
end
function Execute(query, params)
    return MySQL.Sync.execute(query, params)
end