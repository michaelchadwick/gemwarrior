# lib/gemwarrior/evaluator.rb
# Evaluates prompt input

require_relative 'arena'
require_relative 'game_assets'
require_relative 'game_options'

module Gemwarrior
  class Evaluator
    # CONSTANTS
    PROGRAM_NAME                          = 'Gem Warrior'
    QUIT_MESSAGE                          = 'Thanks for playing the game. Until next time...'
    RESUME_MESSAGE                        = 'Back to adventuring!'

    GO_PARAMS                             = 'Options: north, east, south, west'
    CHANGE_PARAMS                         = 'Options: name'
    DEBUG_LIST_PARAMS                     = 'Options: players, creatures, items, locations, monsters, weapons, armor'
    DEBUG_STAT_PARAMS                     = 'Options: hp_cur, atk_lo, atk_hi, experience, rox, strength, dexterity, defense, inventory'

    ERROR_COMMAND_INVALID                 = 'That is not something the game yet understands.'
    ERROR_LOOK_AT_PARAM_MISSING           = 'You cannot just "look at". You gotta choose something to look at.'
    ERROR_TALK_PARAM_INVALID              = 'Are you talking to yourself? That person is not here.'
    ERROR_TALK_PARAM_UNTALKABLE           = 'That cannnot be conversed with.'
    ERROR_TALK_TO_PARAM_MISSING           = 'You cannot just "talk to". You gotta choose someone to talk to.'
    ERROR_GO_PARAM_MISSING                = 'Just wander aimlessly? A direction would be nice.'
    ERROR_GO_PARAM_INVALID                = 'Something tells you that is not a way to go.'
    ERROR_DIRECTION_PARAM_INVALID         = 'You cannot go to that place.'
    ERROR_ATTACK_PARAM_MISSING            = 'You cannot just "attack". You gotta choose something to attack.'
    ERROR_ATTACK_PARAM_INVALID            = 'That monster does not exist here or can\'t be attacked.'
    ERROR_BREAKTHRU_PARAM_MISSING         = 'You cannot just "breakthru". You gotta specify a location name.'
    ERROR_BREAKTHRU_PARAM_INVALID         = 'You cannot breakthru to that place.'
    ERROR_BREAKTHRU_INEXPERIENCED         = 'You are not experienced enough to perform that feat.'
    ERROR_TAKE_PARAM_MISSING              = 'You cannot just "take". You gotta choose something to take.'
    ERROR_USE_PARAM_MISSING               = 'You cannot just "use". You gotta choose something to use.'
    ERROR_USE_PARAM_INVALID               = 'You cannot use that, as it does not exist here or in your inventory.'
    ERROR_USE_PARAM_UNUSEABLE             = 'That is not useable.'
    ERROR_DROP_PARAM_MISSING              = 'You cannot just "drop". You gotta choose something to drop.'
    ERROR_EQUIP_PARAM_MISSING             = 'You cannot just "equip". You gotta choose something to equip.'
    ERROR_UNEQUIP_PARAM_MISSING           = 'You cannot just "unequip". You gotta choose something to unequip.'
    ERROR_CHANGE_PARAM_MISSING            = 'You cannot just "change". You gotta choose something to change.'
    ERROR_CHANGE_PARAM_INVALID            = 'You cannot change that...yet.'
    ERROR_LIST_PARAM_MISSING              = 'You cannot just "list". You gotta choose something to list.'
    ERROR_LIST_PARAM_INVALID              = 'You cannot list that...yet.'
    ERROR_DEBUG_STAT_PARAM_MISSING        = 'You cannot just "change stats". You gotta choose a stat to change.'
    ERROR_DEBUG_STAT_PARAM_INVALID        = 'You cannot change that stat...yet.'
    ERROR_DEBUG_STAT_INV_PARAM_INVALID    = 'You cannot add that to your inventory...yet.'
    ERROR_DEBUG_GLOBAL_VAR_INVALID        = 'That global variable does not exist.'
    ERROR_DEBUG_TELEPORT_PARAMS_MISSING   = 'You cannot just "teleport". You gotta specify an x AND y coordinate, at least.'
    ERROR_DEBUG_TELEPORT_PARAMS_NEEDED    = 'You cannot just "teleport" to an x coordinate without a y coordinate.'
    ERROR_DEBUG_TELEPORT_PARAMS_INVALID   = 'You cannot teleport there...yet.'

    attr_accessor :world,
                  :commands,
                  :aliases,
                  :extras,
                  :cmd_descriptions,
                  :devcommands,
                  :devaliases,
                  :devextras,
                  :devcmd_descriptions

    def initialize(world)
      self.world = world

      self.devcommands  = %w(god beast constants list vars map stat global teleport spawn levelbump restfight)
      self.devaliases   = %w(gd bs cn ls vs m st gl tp sp lb rf)
      self.devextras    = %w()
      self.devcmd_descriptions = [
        'Toggle god mode (i.e. invincible)',
        'Toggle beast mode (i.e. super strength)',
        'List all GameAssets',
        'List all instances of a specific entity type',
        'List all the variables in the world',
        'Show a map of the world',
        'Change player stat',
        'Change world global variable',
        'Teleport to coordinates (5 0 0) or name (\'Home\')',
        'Spawn random monster',
        'Bump your character up *n* levels',
        'Rest, but ensure battle for testing'
      ]

      self.commands     = %w(character look rest take talk inventory use open drop equip unequip go north east south west attack breakthru change version checkupdate help quit quit!)
      self.aliases      = %w(c l r t tk i u o d eq ue g n e s w a br ch v cu h q qq)
      self.extras       = %w(exit exit! x xx fight f ? ?? ???)
      self.cmd_descriptions = [
        'Display character information',
        'Look around your current location',
        'Take a load off and regain HP',
        'Take item',
        'Talk to person',
        'Look in your inventory',
        'Use item (in inventory or environment)',
        'Open item (in inventory or environment)',
        'Drop item',
        'Equip item',
        'Unequip item',
        'Go in a direction',
        'Go north (shortcut)',
        'Go east (shortcut)',
        'Go south (shortcut)',
        'Go west (shortcut)',
        'Attack a monster (also fight)',
        'Teleport to a location (if you are experienced enough)',
        'Change attribute',
        'Display game version',
        'Check for newer game releases',
        'This help menu (also ?)',
        'Quit w/ confirmation (also exit/x)',
        'Quit w/o confirmation (also exit!/xx)'
      ]
    end

    def parse(input)
      case input
      # Ctrl-D or empty command
      when nil, ''
        return
      # real command
      else
        return ERROR_COMMAND_INVALID.colorize(:red) unless input_valid?(input)
      end

      tokens = input.split
      command = tokens.first.downcase
      param1 = tokens[1]
      param2 = tokens[2]
      param3 = tokens[3]

      # helpful
      player_cur_location = world.location_by_coords(world.player.cur_coords)

      # dev commands
      if GameOptions.data['debug_mode']
        case command
        when 'god', 'gd'
          GameOptions.data['god_mode'] = !GameOptions.data['god_mode']
          return "God mode set to #{GameOptions.data['god_mode']}"
        when 'beast', 'bs'
          GameOptions.data['beast_mode'] = !GameOptions.data['beast_mode']
          return "Beast mode set to #{GameOptions.data['beast_mode']}"
        when 'constants', 'cn'
          puts 'GameCreatures'.colorize(:yellow)
          puts GameCreatures.data
          STDIN.getc
          puts 'GameMonsters'.colorize(:yellow)
          puts GameMonsters.data
          STDIN.getc
          puts 'GamePeople'.colorize(:yellow)
          puts GamePeople.data
          STDIN.getc
          puts 'GameItems'.colorize(:yellow)
          puts GameItems.data
          STDIN.getc
          puts 'GameArmor'.colorize(:yellow)
          puts GameArmor.data
          STDIN.getc
          puts 'GameWeapons'.colorize(:yellow)
          puts GameWeapons.data
        when 'vars', 'vs'
          if param1
            world.print_vars(param1)
          else
            world.print_vars
          end
        when 'list', 'ls'
          if param1.nil?
            puts ERROR_LIST_PARAM_MISSING
            return DEBUG_LIST_PARAMS
          else
            return world.list(param1, param2)
          end
        when 'map', 'm'
          world.print_map(param1)
        when 'stat', 'st'
          if param1.nil?
            puts ERROR_DEBUG_STAT_PARAM_MISSING
            return DEBUG_STAT_PARAMS
          else
            case param1
            when 'hp_cur', 'hp'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  if param2 > 0
                    world.player.hp_cur = param2
                  end
                end
              end
            when 'atk_lo'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  if param2 >= 0
                    world.player.atk_lo = param2
                  end
                end
              end
            when 'atk_hi'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  if param2 >= 0
                    world.player.atk_hi = param2
                  end
                end
              end
            when 'strength', 'str', 'st'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  if param2 >= 0
                    world.player.atk_lo = param2
                    world.player.atk_hi = param2
                  end
                end
              end
            when 'dexterity', 'dex'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  if param2 >= 0
                    world.player.dexterity = param2
                  end
                end
              end
            when 'defense', 'def'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  if param2 >= 0
                    world.player.defense = param2
                  end
                end
              end
            when 'rox', 'r', '$'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  if param2 >= 0
                    world.player.rox = param2
                  end
                end
              end
            when 'experience', 'xp'
              unless param2.nil?
                param2 = param2.to_i
                if param2.is_a? Numeric
                  if param2 >= 0
                    world.player.xp = param2
                  end
                end
              end
            when 'inventory', 'inv'
              unless param2.nil?
                begin
                  item_const_name = Gemwarrior.const_get(Formatting.upstyle(param2, no_space: true))
                  item = item_const_name.new
                  world.player.inventory.items.push(item)
                  return "#{item.name.colorize(:yellow)} added to player inventory."
                rescue
                  return ERROR_DEBUG_STAT_INV_PARAM_INVALID
                end
              end
            else
              return ERROR_DEBUG_STAT_PARAM_INVALID
            end
          end
        when 'global', 'gl'
          if param1.nil?
            return world.instance_variables.join(', ')
          elsif world.instance_variable_get("@#{param1}").nil?
            return ERROR_DEBUG_GLOBAL_VAR_INVALID
          elsif param2.nil?
            return world.instance_variable_get("@#{param1}").to_s
          else
            val = false
            val = param2.eql?('true') ? true : val

            world.instance_variable_set("@#{param1}", val)
            return "Instance variable #{param1} has been set to #{val}."
          end
        when 'spawn', 'sp'
          player_cur_location = world.location_by_coords(world.player.cur_coords)
          player_cur_location.populate_monsters(GameMonsters.data, true, param1)
          return world.describe(player_cur_location)
        when 'teleport', 'tp'
          if param1.nil?
            return ERROR_DEBUG_TELEPORT_PARAMS_MISSING
          else
            if (param1.to_i.to_s == param1)
              # we got at least an x coordinate
              if (param2.to_i.to_s == param2)
                # we got a y coordinate, too
                x_coord = param1.to_i
                y_coord = param2.to_i
                # grab the z coordinate, if present, otherwise default to current level
                z_coord = param3.to_i.to_s == param3 ? param3.to_i : world.player.cur_coords[:z]

                # check to make sure new location exists
                if world.location_by_coords(x: x_coord, y: y_coord, z: z_coord)
                  world.player.cur_coords = { x: x_coord, y: y_coord, z: z_coord }
                else
                  return ERROR_DEBUG_TELEPORT_PARAMS_INVALID
                end
              else
                # we only got an x coordinate
                return ERROR_DEBUG_TELEPORT_PARAMS_NEEDED
              end
            else
              # we got a place name instead, potentially
              place_to_match = tokens[1..tokens.length].join(' ').downcase
              locations = []
              world.locations.each do |l|
                locations << l.name.downcase
              end
              if locations.include?(place_to_match)
                world.player.cur_coords = world.location_coords_by_name(place_to_match)
              else
                return ERROR_DEBUG_TELEPORT_PARAMS_INVALID
              end
            end

            # stats
            world.player.movements_made += 1

            Animation.run(phrase: '** TELEPORT! **', speed: :insane)
            player_cur_location = world.location_by_coords(world.player.cur_coords)
            return world.describe(player_cur_location)
          end
        when 'levelbump', 'lb'
          new_level = param1.nil? ? 1 : param1.to_i
          world.player.update_stats(reason: :level_bump, value: new_level)
        when 'restfight', 'rf'
          result = world.player.rest(world, 0, true)

          if result.eql?('death')
            player_death_resurrection
          end
        end
      end

      # normal commands
      case command
      when 'character', 'c'
        # bypass puts so it prints out with newlines properly
        print world.player.check_self
      when 'inventory', 'i'
        if param1
          world.player.inventory.describe_item(param1)
        else
          world.player.list_inventory
        end
      when 'look', 'l'
        if param1
          # convert 'look at' to 'look'
          if param1.eql?('at')
            if param2
              param1 = param2
            else
              return ERROR_LOOK_AT_PARAM_MISSING
            end
          end
          world.describe_entity(player_cur_location, param1)
        else
          world.describe(player_cur_location)
        end
      when 'rest', 'r'
        tent_uses = 0
        player_inventory = world.player.inventory

        if player_inventory.contains_item?('tent')
          player_inventory.items.each do |i|
            if i.name.eql?('tent')
              if i.number_of_uses > 0
                result = i.use(world)
                tent_uses = i.number_of_uses
                i.number_of_uses -= 1

                puts ">> tent can be used when resting #{i.number_of_uses} more time(s)."
              end
            end
          end
        elsif player_cur_location.contains_item?('tent')
          player_cur_location.items.each do |i|
            if i.name.eql?('tent')
              if i.number_of_uses > 0
                result = i.use(world)
                tent_uses = i.number_of_uses
                i.number_of_uses -= 1

                puts ">> tent can be used when resting #{i.number_of_uses} more time(s)."
              end
            end
          end
        end

        result = world.player.rest(world, tent_uses)

        if result.eql?('death')
          player_death_resurrection
        else
          result
        end
      when 'take', 't'
        if param1.nil?
          ERROR_TAKE_PARAM_MISSING
        else
          world.player.inventory.add_item(param1, player_cur_location, world.player)
        end
      when 'talk', 'tk'
        if param1.nil?
          return ERROR_TALK_TO_PARAM_MISSING
        elsif param1.eql?('to')
          if param2
            param1 = param2
          else
            return ERROR_TALK_TO_PARAM_MISSING
          end
        end

        talkable_name = param1

        player_inventory = world.player.inventory

        if player_inventory.contains_item?(talkable_name)
          player_inventory.items.each do |person|
            if person.name.eql?(talkable_name)
              if person.talkable
                return self.parse("use #{talkable_name}")
              else
                return ERROR_TALK_PARAM_UNTALKABLE
              end
            end
          end
        elsif player_cur_location.contains_item?(talkable_name)
          player_cur_location.items.each do |person|
            if person.name.eql?(talkable_name)
              if person.talkable
                return self.parse("use #{talkable_name}")
              else
                return ERROR_TALK_PARAM_UNTALKABLE
              end
            end
          end
        elsif player_cur_location.has_monster?(talkable_name)
          player_cur_location.monsters_abounding.each do |monster|
            if monster.name.eql?(talkable_name)
              if monster.talkable
                return self.parse("use #{talkable_name}")
              else
                return ERROR_TALK_PARAM_UNTALKABLE
              end
            end
          end
        elsif player_cur_location.has_boss?(talkable_name)
          player_cur_location.bosses_abounding.each do |boss|
            if boss.name.eql?(talkable_name)
              if boss.talkable
                return self.parse("use #{talkable_name}")
              else
                return ERROR_TALK_PARAM_UNTALKABLE
              end
            end
          end
        end
      when 'use', 'u', 'open', 'o'
        if param1.nil?
          ERROR_USE_PARAM_MISSING
        else
          item_name = param1
          result = nil

          player_inventory = world.player.inventory

          if player_inventory.contains_item?(item_name)
            player_inventory.items.each do |i|
              if i.name.eql?(item_name)
                if i.useable
                  if !i.number_of_uses.nil?
                    if i.number_of_uses > 0
                      result = i.use(world)
                      i.number_of_uses -= 1
                      puts ">> #{i.name} can be used #{i.number_of_uses} more time(s)."
                      break
                    else
                      return ">> #{i.name} cannot be used anymore."
                    end
                  elsif i.consumable
                    result = i.use(world)
                    world.player.inventory.remove_item(i.name)
                    break
                  else
                    result = i.use(world)
                    break
                  end
                else
                  return ERROR_USE_PARAM_UNUSEABLE
                end
              end
            end
          elsif player_cur_location.contains_item?(item_name)
            player_cur_location.items.each do |i|
              if i.name.eql?(item_name)
                if i.useable
                  if !i.number_of_uses.nil?
                    if i.number_of_uses > 0
                      result = i.use(world)
                      i.number_of_uses -= 1
                      puts ">> #{i.name} can be used #{i.number_of_uses} more time(s)."
                      break
                    else
                      return ">> #{i.name} cannot be used anymore."
                    end
                  elsif i.consumable
                    result = i.use(world)
                    location.remove_item(i.name)
                    break
                  else
                    result = i.use(world)
                    break
                  end
                else
                  return ERROR_USE_PARAM_UNUSEABLE
                end
              end
            end
          elsif player_cur_location.has_monster?(item_name)
            player_cur_location.monsters_abounding.each do |i|
              if i.name.eql?(item_name)
                return i.use(world)
              end
            end
          elsif player_cur_location.has_boss?(item_name)
            player_cur_location.bosses_abounding.each do |i|
              if i.name.eql?(item_name)
                return i.use(world)
              end
            end
          end

          if result.nil?
            ERROR_USE_PARAM_INVALID
          else
            case result[:type]
            when 'move'
              world.player.cur_coords = world.location_coords_by_name(result[:data])
              player_cur_location = world.location_by_coords(world.player.cur_coords)
              world.describe(player_cur_location)
            when 'move_dangerous'
              dmg = rand(0..2)
              puts ">> You lose #{dmg} hit point(s)." if dmg > 0
              world.player.take_damage(dmg)

              world.player.cur_coords = world.location_coords_by_name(result[:data])
              player_cur_location = world.location_by_coords(world.player.cur_coords)
              world.describe(player_cur_location)
            when 'dmg'
              result = world.player.take_damage(result[:data])

              if result.eql?('death')
                player_death_resurrection
              end
            when 'rest', 'health'
              world.player.heal_damage(result[:data])
              return
            when 'xp'
              world.player.update_stats(reason: :xp, value: result[:data])
              return
            when 'tent'
              world.player.rest(world, result[:data])
            when 'action'
              case result[:data]
              when 'map'
                world.print_map(world.player.cur_coords[:z])
              end
            when 'arena'
              arena = Arena.new(world: world, player: world.player)
              result = arena.start

              if result.eql?('death')
                player_death_resurrection
              end
            when 'item'
              player_cur_location.add_item(result[:data])
              return
            when 'purchase'
              result[:data].each do |i|
                world.player.inventory.items.push(i)
              end
              return
            else
              return
            end
          end
        end
      when 'drop', 'd'
        if param1.nil?
          ERROR_DROP_PARAM_MISSING
        else
          world.player.inventory.drop_item(param1, player_cur_location)
        end
      when 'equip', 'eq'
        if param1.nil?
          ERROR_EQUIP_PARAM_MISSING
        else
          world.player.inventory.equip_item(param1)
        end
      when 'unequip', 'ue'
        if param1.nil?
          ERROR_UNEQUIP_PARAM_MISSING
        else
          world.player.inventory.unequip_item(param1)
        end
      when 'go', 'g'
        if param1.nil?
          puts ERROR_GO_PARAM_MISSING
          GO_PARAMS
        else
          direction = param1
          try_to_move_player(direction)
        end
      when 'n'
        if param1
          ERROR_DIRECTION_PARAM_INVALID
        else
          try_to_move_player('north')
        end
      when 'e'
        if param1
          ERROR_DIRECTION_PARAM_INVALID
        else
          try_to_move_player('east')
        end
      when 's'
        if param1
          ERROR_DIRECTION_PARAM_INVALID
        else
          try_to_move_player('south')
        end
      when 'w'
        if param1
          ERROR_DIRECTION_PARAM_INVALID
        else
          try_to_move_player('west')
        end
      when 'attack', 'a', 'fight', 'f'
        if param1.nil?
          if GameOptions.data['fight_completion']
            if player_cur_location.has_any_monsters?
              monster_param = player_cur_location.monsters_abounding[0].name
              self.parse("attack #{monster_param}")
            else
              ERROR_ATTACK_PARAM_INVALID
            end
          else
            ERROR_ATTACK_PARAM_MISSING
          end
        else
          monster_name = param1
          if world.has_monster_to_attack?(monster_name)
            monster = player_cur_location.monster_by_name(monster_name)
            result = world.player.attack(world, monster, param2)

            if result.eql?('death')
              return player_death_resurrection
            elsif result.eql?('exit')
              return 'exit'
            end

            unless result.nil?
              case result[:type]
              when 'message'
                result[:data]
              when 'move'
                world.player.cur_coords = world.location_coords_by_name(result[:data])
                player_cur_location = world.location_by_coords(world.player.cur_coords)
                world.describe(player_cur_location)
              end
            end
          else
            ERROR_ATTACK_PARAM_INVALID
          end
        end
      when 'breakthru', 'br'
        if world.player.special_abilities.include?(:breakthru)
          if param1.nil?
            return ERROR_BREAKTHRU_PARAM_MISSING
          else
            place_to_match = tokens[1..tokens.length].join(' ').downcase
            locations = []
            world.locations.each do |l|
              locations << l.name.downcase
            end
            if locations.include?(place_to_match)
              world.player.cur_coords = world.location_coords_by_name(place_to_match)
            else
              return ERROR_BREAKTHRU_PARAM_INVALID
            end
          end

          # stats
          world.player.movements_made += 1

          Animation.run(phrase: '** BREAK THROUGH! **')
          player_cur_location = world.location_by_coords(world.player.cur_coords)
          return world.describe(player_cur_location)
        else
          ERROR_BREAKTHRU_INEXPERIENCED
        end
      when 'change', 'ch'
        if param1.nil?
          puts ERROR_CHANGE_PARAM_MISSING
          CHANGE_PARAMS
        else
          case param1
          when 'name'
            world.player.modify_name
          else
            ERROR_CHANGE_PARAM_INVALID
          end
        end
      when 'help', 'h', '?', '??', '???'
        list_commands
      when 'version', 'v'
        Gemwarrior::VERSION
      when 'checkupdate', 'cu'
        'checkupdate'
      when 'quit', 'exit', 'q', 'x'
        print 'You sure you want to quit? (y/n) '
        answer = gets.chomp.downcase

        case answer
        when 'y', 'yes'
          puts QUIT_MESSAGE.colorize(:yellow)
          return 'exit'
        else
          puts RESUME_MESSAGE.colorize(:green)
        end
      when 'quit!', 'exit!', 'qq', 'xx'
        puts QUIT_MESSAGE.colorize(:yellow)
        return 'exit'
      else
        return
      end
    end

    private

    def try_to_move_player(direction)
      if world.can_move?(direction)
        world.player.go(world, direction)
        player_cur_location = world.location_by_coords(world.player.cur_coords)
        player_cur_location.checked_for_monsters = false

        if player_cur_location.name.include?('pain_quarry')
          if player_cur_location.has_boss?('garynetty')
            roll = rand(0..100) + world.player.dexterity
            roll_display = roll < 25 ? "#{roll}".colorize(:red) : "#{roll}".colorize(:green)
            puts "[Pain Quarry Garynetty Roll: #{roll_display}]" if GameOptions.data['debug_mode']
            if roll < 25
              self.parse("attack garynetty is_ambush")
            else
              puts 'You nearly got attacked by a vicious Garynetty! Be careful, your next move might not be as lucky.'.colorize(:yellow)
            end
          end
        end

        world.describe(player_cur_location)
      else
        return ERROR_GO_PARAM_INVALID.colorize(:red)
      end
    end

    def player_death_resurrection
      Audio.play_synth(:player_resurrection)

      puts 'Somehow, though, your adventure does not end here!'.colorize(:yellow)
      puts 'Instead, you are whisked back home via some magical force.'.colorize(:yellow)
      puts 'A bit worse for the weary and somewhat poorer, but you are ALIVE!'.colorize(:yellow)
      puts

      world.player.hp_cur = 1
      world.player.rox -= (world.player.rox * 0.1).to_i
      if world.player.rox < 0
        world.player.rox = 0
      end
      world.player.cur_coords = world.location_coords_by_name('Home')
      player_cur_location = world.location_by_coords(world.player.cur_coords)
      world.describe(player_cur_location)
      world.player.deaths += 1
      return
    end

    def list_commands
      i = 0
      Hr.print('=')
      puts ' COMMAND     | ALIAS | DESCRIPTION '
      Hr.print('=')
      commands.each do |cmd|
        puts " #{cmd.ljust(11)} | #{aliases[i].ljust(5)} | #{cmd_descriptions[i]}"
        i += 1
      end
      Hr.print('=')

      if GameOptions.data['debug_mode']
        puts ' DEBUG COMMANDS'
        Hr.print('=')
        i = 0
        devcommands.each do |cmd|
          puts " #{cmd.ljust(11)} | #{devaliases[i].ljust(5)} | #{devcmd_descriptions[i]}"
          i += 1
        end
        Hr.print('=')
      end
    end

    def input_valid?(input)
      tokens = input.split
      command = tokens[0]
      commands_and_aliases = commands | aliases | extras

      if GameOptions.data['debug_mode']
        commands_and_aliases = commands_and_aliases | devcommands | devaliases | devextras
      end

      if commands_and_aliases.include?(command.downcase)
        if tokens.size.between?(1, 4)
          return true
        end
      elsif tokens.empty?
        return true
      end
    end
  end
end
