// Half Leak Devloper : ^AF^#8585
const Discord = require('discord.js');
var client = new Discord.Client;
const config = require('./config.json');
var CurrentChannel = false;
var RefreshBot = false;

const fivem = require("discord-fivem-api");
const server = new fivem.DiscordFivemApi("45.156.185.57:30120");



RefreshWhitelist = () => {
     console.log('^1 [AfshAr] ^4Refreshing BOT^0')
     CurrentChannel && CurrentChannel.send(SendEmbed({
          description: 'Refreshing Bot',
          color: "#47ff00",
          author: 'Refresh Whitelist'
     }))
     client.destroy(config.token);
     setTimeout(() => { }, 0);
     client = new Discord.Client;
     RefreshBot = true;
     StartBot();
}
// Half Leak Devloper : ^AF^#8585
StartBot = () => {
     client.on('ready', () => {
          !RefreshBot && console.log('^1 [AfshAr] ^2Bot Is Ready^0')
          if (RefreshBot) {
               console.log('^1 [AfshAr] ^6Refreshed Bot^0')
               CurrentChannel && CurrentChannel.send(SendEmbed({
                    description: 'Refreshed Bot',
                    color: "#0094ff",
                    author: 'SUCCESS'
               }))
               RefreshBot = false;
          }
          exports['AF-servermanbot'].GetConfig(config);
          client.user.setActivity('Half Leak Rp ✅', {type: 'WATCHING'});
     })

     client.on('message', msg => {
          CurrentChannel = msg.channel;
          var embed = new Discord.MessageEmbed()
               .setFooter('Made By ^AF^#8585')
          if (msg.content.startsWith(config.prefix)) {
               var args = msg.content.substring().split(" ");
               if (msg.member.roles.find((search) => search.id == config.admin_roleid)) {
                    if (args[0] == config.prefix + 'ban') {
                         // Half Leak Devloper : ^AF^#8585
                         if (args[1] && args[2] && args[3]) {
                              emit('AF-serverman:Ban', msg.member.user, args[1], args, (Number(args[2]) && args[2] || 0))
                              return false;
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .addField('id or identifier', '**if player is online use id. Or if player is offline use identifier**', true)
                                   .addField('time', '**Second**', true)
                                   .addField('reason', '**Write a reason**', true)
                                   .setTitle('Example \n!ban `1` `3600` `BYE BYE :)` \n!ban `steam:2131231` `3000` `BYE BYE :)`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'kick') {
                         // Half Leak Devloper : ^AF^#8585
                         if (args[1] && args[2]) {
                              emit('AF-serverman:Kick', msg.member.user, args[1], args)
                              return false;
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Usage: !kick `id` `reason`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'inventory') {
                         // Half Leak Devloper : ^AF^#8585
                         if (args[1]) {
                              return exports['AF-servermanbot'].GetInventory(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Usage: !inventory `id` or `identifier`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'accounts') {
                         // Half Leak Devloper : ^AF^#8585
                         if (args[1]) {
                              return exports['AF-servermanbot'].GetMoney(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Usage: !accounts `identifier` or `id`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'addmoney') {
                         // Half Leak Devloper : ^AF^#8585
                         if (args[1] && args[2] && args[3]) {
                              if (args[2] == 'money' || args[2] == 'bank' || (args[2] == 'black_money' || args[2] == 'crypto')) {
                                   return exports['AF-servermanbot'].addmoney(args[1], args[2], (Number(args[3]) && args[3] || 0));
                              } else {
                                   embed
                                        .setColor('#ff0000')
                                        .addField('id or identifier', '**if player is online use id. Or if player is offline use identifier**', true)
                                        .addField('type', '**bank, money or black_money || crypto**', true)
                                        .addField('amount', '**Write a amount**', true)
                                        .setTitle('Examples \n!addmoney `1` `bank` `3600` \n!addmoney `steam:2131231` `bank` `3600`')
                                        .setAuthor('Incorrect Command Usage.')
                                   msg.channel.send(embed)
                                   return false;
                              }
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .addField('id or identifier', '**if player is online use id. Or if player is offline use identifier**', true)
                                   .addField('type', '**bank, money or black_money || crypto**', true)
                                   .addField('amount', '**Write a amount**', true)
                                   .setTitle('Examples \n!addmoney `1` `bank` `3600` \n!addmoney `steam:2131231` `bank` `3600`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'giveitem') {
                         // Half Leak Devloper : ^AF^#8585
                         if (args[1] && args[2] && args[3]) {
                              if (Number(args[3]) != null) {
                                   return exports['AF-servermanbot'].GiveItem(args[1], args[2], Number(args[3]));
                              } else {
                                   embed
                                        .setColor('#ff0000')
                                        .setTitle('!giveitem `id or identifier` `item name` `item count` \nExamples \n!giveitem `1` `bread` `3` \n!giveitem `steam:12312321` `bread` `3`')
                                        .setAuthor('Incorrect Command Usage.')
                                   msg.channel.send(embed)
                                   return false;
                              }
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('!giveitem `id or identifier` `item name` `item count` \nExamples \n!giveitem `1` `bread` `3` \n!giveitem `steam:12312321` `bread` `3`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'setjob') {
                         // Half Leak Devloper : ^AF^#8585
                         if (args[1] && args[2] && args[3]) {
                              if (Number(args[3]) != null) {
                                   return exports['AF-servermanbot'].SetJob(args[1], args[2], Number(args[3]));
                              } else {
                                   embed
                                        .setColor('#ff0000')
                                        .setTitle('!setjob `id or identifier` `jobname` `grade` \nExamples \n!setjob `1` `police` `2` \n!setjob `steam:12312321` `police` `2`')
                                        .setAuthor('Incorrect Command Usage.')
                                   msg.channel.send(embed)
                                   return false;
                              }
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('!setjob `id or identifier` `jobname` `grade` \nExamples \n!setjob `1` `police` `2` \n!setjob `steam:12312321` `police` `2`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'setperm') {
                         // Half Leak Devloper : ^AF^#8585
                         if (args[1] && args[2] && args[3]) {
                              if (Number(args[3]) != null) {
                                   return exports['AF-servermanbot'].Setperm(args[1], args[2], Number(args[3]));
                              } else {
                                   embed
                                        .setColor('#ff0000')
                                        .setTitle('!setperm `id` `group` `perm`')
                                        .setAuthor('Incorrect Command Usage.')
                                   msg.channel.send(embed)
                                   return false;
                              }
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('!setperm `id` `group` `perm`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'setgang') {
                         if (args[1] && args[2] && args[3]) {
                              if (Number(args[3]) != null) {
                                   return exports['AF-servermanbot'].Setgang(args[1], args[2], Number(args[3]));
                              } else {
                                   embed
                                        .setColor('#ff0000')
                                        .setTitle('!Setgang `id` `Gang` `Rank`')
                                        .setAuthor('Incorrect Command Usage.')
                                   msg.channel.send(embed)
                                   return false;
                              }
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('!Setgang `id` `Gang` `Rank`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'removemoney') {
                         if (args[1] && args[2] && args[3]) {
                              if (args[2] == 'money' || args[2] == 'bank' || args[2] == 'black_money') {
                                   return exports['AF-servermanbot'].RemoveMoney(args[1], args[2], (Number(args[3]) && args[3] || 0));
                              } else {
                                   embed
                                        .setColor('#ff0000')
                                        .addField('id or identifier', '**if player is online use id. Or if player is offline use identifier**', true)
                                        .addField('type', '**bank, money or black_money**', true)
                                        .addField('amount', '**Write a amount**', true)
                                        .setTitle('Examples \n!removemoney `1` `bank` `3600` \n!removemoney `steam:2131231` `bank` `3600`')
                                        .setAuthor('Incorrect Command Usage.')
                                   msg.channel.send(embed)
                                   return false;
                              }
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .addField('id or identifier', '**if player is online use id. Or if player is offline use identifier**', true)
                                   .addField('type', '**bank, money or black_money**', true)
                                   .addField('amount', '**Write a amount**', true)
                                   .setTitle('Examples \n!removemoney `1` `bank` `3600` \n!removemoney `steam:2131231` `bank` `3600`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'checkban') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].GetBannedPlayer(args[1])
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Usage: !checkban `identifier` or `id`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'playerinfo') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].GetGeneralInformations(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Usage: !playerinfo`id`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'wipe') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].Wipe(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Example usage: !wipe `identifier` or `id`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'reviveall') {
                         return exports['AF-servermanbot'].ReviveAll();
                    } else if (args[0] == config.prefix + 'refreshwhitelist') {
                         return RefreshWhitelist();
                    } else if (args[0] == config.prefix + 'charmenu') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].Charmenu(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Example usage: !charmneu `id`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'giftall') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].GiftAll(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Example usage: !giftall `amount`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'revive') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].Revive(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Example usage: !revive `id`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                         // Half Leak Devloper : ^AF^#8585
                    } else if (args[0] == config.prefix + 'freeze') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].Freeze(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Example usage: !Freeze `id`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'slay') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].Slay(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Example usage: !slay `id`')
                                   // Half Leak Devloper : ^AF^#8585
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'help') {
                         embed.setColor('0094ff')
                              .setAuthor('Sky Life Fivem Bot.')
                              .setDescription('``To Use Any Command Send Perfix + Command.``')
                              .addField('prefix', '**' + config.prefix + '**', true)
                              .addField('inventory', '**Show Player Inventory**', true)
                              .addField('accounts', '**Show Player Accounts.**', true)
                              .addField('playerinfo', '**Show Player Info**', true)
                              .addField('kick', '**Kick Player**', true)
                              .addField('wipe', '**Wipe Player**', true)
                              .addField('addmoney', '**Add Money**', true)
                              .addField('removemoney', '**Remove Money**', true)
                              .addField('players', '**Get Online Players**', true)
                              // Half Leak Devloper : ^AF^#8585
                              .addField('giftall', '**Giftall Player Money**', true)
                              .addField('setjob', '**Set Job**', true)
                              .addField('setgang', '**Set Gang**', true)
                              .addField('setduty', '**Set Adimin Duty**', true)
                              .addField('setperm', '**Set Player Pem And Group**', true)
                              .addField('charmenu', '**Charmenu Player**', true)
                              .addField('revive', '**Revive Player**', true)
                              .addField('reviveall', '**Revive All Players**', true)
                              .addField('slay', '**Slay Player**', true)
                              .addField('freeze', '**Freeze Player**', true)
                              .addField('giveitem', '**Add Item**', true)
                              .addField('giveweapon', '**Give Weapon**', true)
                              .addField('setcoords', '**Set Player Coords / Teleport**', true)
                              .addField('car', '**Give Car**', true)
                              .addField('carAll', '**Give a vehicle to all players**', true)
                              // .addField('start', '**Start Script**', true)
                              // .addField('stop', '**Stop Script**', true)
                              // .addField('refresh', '**Refresh Scripts**', true)
                              // .addField('refreshwhitelist', '**Refresh Whitelist**', true)
                              // .addField('bannedplayers', '**Show Banned Players**', true)
                              // .addField('ban', '**Ban Player**', true)
                              // .addField('checkban', '**Check Ban For Player**', true)
                         msg.channel.send(embed);
                         return false;
                    } else if (args[0] == config.prefix + 'bannedplayers') {
                         return exports['AF-servermanbot'].GetBannedPlayers();
                    } else if (args[0] == config.prefix + 'players') {
                         return exports['AF-servermanbot'].GetPlayers();
                    } else if (args[0] == config.prefix + 'jobs') {
                         return exports['AF-servermanbot'].Jobs();
                    } else if (args[0] == config.prefix + 'car') {
                         if (args[1] && args[2]) {
                              return exports['AF-servermanbot'].spawnCar(args[1], args[2]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   // Half Leak Devloper : ^AF^#8585
                                   .setTitle('Example usage: !car `id` `name`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'setduty') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].setduty(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Example usage: !setduty `id`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'carAll') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].spawnAllPlayersCar(args[1]);
                         } else {
                              // Half Leak Devloper : ^AF^#8585
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Example usage: !car `name`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefix + 'giveweapon') {
                         if (args[1] && args[2] && args[3]) {
                              return exports['AF-servermanbot'].giveWeapon(args[1], args[2], args[3]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Example usage: !giveweapon `id` `name` `ammo || count`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefixdevloper + 'setcoords') {
                         if (args[1] && args[2] && args[3] && args[4] && Number(args[2]) && Number(args[3]) && Number(args[4])) {
                              return exports['AF-servermanbot'].SetCoords(args[1], args[2], args[3], args[4]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Usage: !setcoords `id` `x` `y` `z` Example !setcoords 1 123 123 462')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    }
               } else {
                    embed
                         .setColor('#ff0000')
                         .setDescription('You are not authorized')
                         .setAuthor('WARNING')
                    msg.channel.send(embed)
                    // Half Leak Devloper : ^AF^#8585
                    return false;
               }
          }else if (msg.content.startsWith(config.prefixdevloper)) {
               var args = msg.content.substring().split(" ");
               if (msg.member.roles.find((search) => search.id == config.devloper_roleid)) {
                    if (args[0] == config.prefixdevloper + 'start') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].start(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Usage: !start `script name`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefixdevloper + 'stop') {
                         // Half Leak Devloper : ^AF^#8585
                         if (args[1]) {
                              return exports['AF-servermanbot'].stop(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Usage: !stop `script name`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefixdevloper + 'restart') {
                         if (args[1]) {
                              return exports['AF-servermanbot'].restart(args[1]);
                         } else {
                              embed
                                   .setColor('#ff0000')
                                   .setTitle('Usage: !restart `script name`')
                                   .setAuthor('Incorrect Command Usage.')
                              msg.channel.send(embed)
                              return false;
                         }
                    } else if (args[0] == config.prefixdevloper + 'help') {
                         embed.setColor('0094ff')
                              .setAuthor('Sky Life Fivem Bot.')
                              .setDescription('``To Use Any Command Send Perfix + Command.``')
                              .addField('prefix', '**' + config.prefixdevloper + '**', true)
                              .addField('start', '**Start Script**', true)
                              .addField('stop', '**Stop Script**', true)
                              .addField('restart', '**Restart Script**', true)
                              .addField('refresh', '**Refresh Scripts**', true)
                              .addField('Devloper :', '**^AF^&^HM^**\n<@900342630825742397>&<@919510117777539132>', true)
                              // .addField('bannedplayers', '**Show Banned Players**', true)
                              // .addField('ban', '**Ban Player**', true)
                              // .addField('checkban', '**Check Ban For Player**', true)
                         msg.channel.send(embed);
                         return false;
                    } else if (args[0] == config.prefixdevloper + 'refresh') {
                         return exports['AF-servermanbot'].refresh(args[1]);
                    }else{
                         embed
                         .setColor('#ff0000')
                         .setTitle('Usage:Heloooo Moder Fuck Up')
                         .setAuthor('Incorrect Command Usage.')
                    msg.channel.send(embed)
                    return false;
                    }
               }
               // Half Leak Devloper : ^AF^#8585
          }
     })
     client.login(config.token)
}

RegisterNetEvent('AF-serverman:SendEmbed')
on('AF-serverman:SendEmbed', embed => {
     (CurrentChannel && CurrentChannel.send(SendEmbed(embed)))
});

SendEmbed = (embed) => {
     var CreateEmbed = new Discord.MessageEmbed()
          .setFooter('Made By ^AF^#8585')
     embed.description && CreateEmbed.setDescription(embed.description)
     embed.author && CreateEmbed.setAuthor(embed.author)
     embed.color && CreateEmbed.setColor(embed.color)
     embed.title && CreateEmbed.setTitle(embed.title)
     if (embed.fields) {
          for (x in embed.fields) {
               CreateEmbed.addField(embed.fields[x].name, embed.fields[x].value, embed.fields[x].inline || false)
          }
     }
     // Half Leak Devloper : ^AF^#8585
     return CreateEmbed
}
StartBot();
