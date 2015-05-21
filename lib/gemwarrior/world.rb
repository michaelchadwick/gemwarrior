# lib/gemwarrior/world.rb
# World where the locations, monsters, items, etc. exist

require_relative 'defaults'
require_relative 'monster'
require_relative 'item'
require_relative 'location'

module Gemwarrior
  class World
    # CONSTANTS
    ## DEFAULTS
    include Entities::Monsters
    include Entities::Items
    include Entities::Locations
    
    ## ERRORS
    ERROR_LIST_PARAM_INVALID = 'That isn\'t something that can be listed.'
  
    attr_accessor :monsters, :items, :locations
  
    def initialize
      @monsters = init_monsters
      @items = init_items
      @locations = init_locations
    end

    def list(param)
      case param
      when "monsters"
        return "The world's monsters consist of #{@monsters.map(&:name).join(', ')}"
      when "items"
        return "The world's items consist of #{@items.map(&:name).join(', ')}"
      when "locations"
        return "The world consists of #{@locations.map(&:name).join(', ')}"
      else
        ERROR_LIST_PARAM_INVALID
      end
    end
    
    def mob_by_id(id)
      @monsters.each do |mob|
        if mob.id.to_i.equal? id
          return mob
        end
      end
      return nil
    end
    
    def item_by_id(id)
      @items.each do |item|
        if item.id.to_i.equal? id
          return item
        end
      end
      return nil
    end

    def loc_by_id(id)
      @locations.each do |loc|
        if loc.id.to_i.equal? id
          return loc
        end
      end
      return nil
    end
 
    private
    
    def init_monsters
      @monsters = []
      @monsters.push(Monster.new(
          MOB_ID_ALEXANDRAT, 
          MOB_NAME_ALEXANDRAT, 
          MOB_DESC_ALEXANDRAT,
          'ugly', 
          'gnarled', 
          'unsurprisingly unchipper', 
          MOB_LEVEL_ALEXANDRAT,
          MOB_LEVEL_ALEXANDRAT * 5,
          MOB_LEVEL_ALEXANDRAT * 5,
          MOB_LEVEL_ALEXANDRAT * 2,
          MOB_LEVEL_ALEXANDRAT * 2,
          Inventory.new,
          rand(0..10)
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_AMBEROO, 
          MOB_NAME_AMBEROO, 
          MOB_DESC_AMBEROO,
          'punchy', 
          'balled', 
          'jumpy',
          MOB_LEVEL_AMBEROO,
          MOB_LEVEL_AMBEROO * 5,
          MOB_LEVEL_AMBEROO * 5,
          MOB_LEVEL_AMBEROO * 2,
          MOB_LEVEL_AMBEROO * 2,
          Inventory.new,
          rand(0..10)
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_AMETHYSTLE, 
          MOB_NAME_AMETHYSTLE, 
          MOB_DESC_AMETHYSTLE,
          'sharp', 
          'loose', 
          'mesmerizing',
          MOB_LEVEL_AMETHYSTLE,
          MOB_LEVEL_AMETHYSTLE * 5,
          MOB_LEVEL_AMETHYSTLE * 5,
          MOB_LEVEL_AMETHYSTLE * 2,
          MOB_LEVEL_AMETHYSTLE * 2,
          Inventory.new,
          rand(0..10)
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_AQUAMARINE, 
          MOB_NAME_AQUAMARINE, 
          MOB_DESC_AQUAMARINE,
          'strained', 
          'hairy', 
          'tempered',
          MOB_LEVEL_AQUAMARINE,
          MOB_LEVEL_AQUAMARINE * 5,
          MOB_LEVEL_AQUAMARINE * 5,
          MOB_LEVEL_AQUAMARINE * 2,
          MOB_LEVEL_AQUAMARINE * 2,
          Inventory.new,
          rand(0..10)
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_APATIGER, 
          MOB_NAME_APATIGER, 
          MOB_DESC_APATIGER,
          'calloused', 
          'soft', 
          'apathetic',
          MOB_LEVEL_APATIGER,
          MOB_LEVEL_APATIGER * 5,
          MOB_LEVEL_APATIGER * 5,
          MOB_LEVEL_APATIGER * 2,
          MOB_LEVEL_APATIGER * 2,
          Inventory.new,
          rand(0..10)
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_BLOODSTORM, 
          MOB_NAME_BLOODSTORM, 
          MOB_DESC_BLOODSTORM,
          'bloody', 
          'bloody', 
          'boiling',
          MOB_LEVEL_BLOODSTORM,
          MOB_LEVEL_BLOODSTORM * 5,
          MOB_LEVEL_BLOODSTORM * 5,
          MOB_LEVEL_BLOODSTORM * 2,
          MOB_LEVEL_BLOODSTORM * 2,
          Inventory.new,
          rand(0..10)
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_CITRINAGA, 
          MOB_NAME_CITRINAGA, 
          MOB_DESC_CITRINAGA,
          'shiny', 
          'glistening', 
          'staid',
          MOB_LEVEL_CITRINAGA,
          MOB_LEVEL_CITRINAGA * 5,
          MOB_LEVEL_CITRINAGA * 5,
          MOB_LEVEL_CITRINAGA * 2,
          MOB_LEVEL_CITRINAGA * 2,
          Inventory.new,
          rand(0..10)
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_CORALIZ, 
          MOB_NAME_CORALIZ, 
          MOB_DESC_CORALIZ,
          'spotted', 
          'slippery', 
          'emotionless',
          MOB_LEVEL_CORALIZ,
          MOB_LEVEL_CORALIZ * 5,
          MOB_LEVEL_CORALIZ * 5,
          MOB_LEVEL_CORALIZ * 2,
          MOB_LEVEL_CORALIZ * 2,
          Inventory.new,
          rand(0..10)
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_CUBICAT, 
          MOB_NAME_CUBICAT, 
          MOB_DESC_CUBICAT,
          'striking', 
          'grippy', 
          'salacious',
          MOB_LEVEL_CUBICAT,
          MOB_LEVEL_CUBICAT * 5,
          MOB_LEVEL_CUBICAT * 5,
          MOB_LEVEL_CUBICAT * 2,
          MOB_LEVEL_CUBICAT * 2,
          Inventory.new,
          rand(0..10)
        )
      )
      @monsters.push(Monster.new(
          MOB_ID_DIAMAN, 
          MOB_NAME_DIAMAN, 
          MOB_DESC_DIAMAN,
          'bright', 
          'jagged', 
          'adamant',
          MOB_LEVEL_DIAMAN,
          MOB_LEVEL_DIAMAN * 5,
          MOB_LEVEL_DIAMAN * 5,
          MOB_LEVEL_DIAMAN * 2,
          MOB_LEVEL_DIAMAN * 2,
          Inventory.new,
          rand(0..10)
        )
      )
    end
    
    def init_items
      @items = []
      @items.push(Item.new(
          ITEM_ID_STONE, 
          ITEM_NAME_STONE, 
          ITEM_DESC_STONE,
          true
        )
      )
      @items.push(Item.new(
          ITEM_ID_BED, 
          ITEM_NAME_BED, 
          ITEM_DESC_BED,
          false
        )
      )
      @items.push(Item.new(
          ITEM_ID_STALACTITE, 
          ITEM_NAME_STALACTITE, 
          ITEM_DESC_STALACTITE,
          true
        )
      )
      @items.push(Item.new(
          ITEM_ID_FEATHER, 
          ITEM_NAME_FEATHER, 
          ITEM_DESC_FEATHER,
          true
        )
      )
      @items.push(Item.new(
          ITEM_ID_GUN, 
          ITEM_NAME_GUN, 
          ITEM_DESC_GUN,
          true
        )
      )
    end
  
    def init_locations
      @locations = []
      @locations.push(Location.new(
          LOC_ID_HOME, 
          LOC_NAME_HOME, 
          LOC_DESC_HOME, 
          LOC_CONNECTIONS_HOME,
          :none,
          [item_by_id(0), item_by_id(1)],
          @monsters
        )
      )
      @locations.push(Location.new(
          LOC_ID_CAVE_ENTRANCE, 
          LOC_NAME_CAVE_ENTRANCE, 
          LOC_DESC_CAVE_ENTRANCE,
          LOC_CONNECTIONS_CAVE_ENTRANCE,
          :low,
          [],
          @monsters
        )
      )
      @locations.push(Location.new(
          LOC_ID_CAVE_ROOM1, 
          LOC_NAME_CAVE_ROOM1, 
          LOC_DESC_CAVE_ROOM1,
          LOC_CONNECTIONS_CAVE_ROOM1,
          :moderate,
          [item_by_id(2)],
          @monsters
        )
      )
      @locations.push(Location.new(
          LOC_ID_FOREST, 
          LOC_NAME_FOREST, 
          LOC_DESC_FOREST,
          LOC_CONNECTIONS_FOREST,
          :low,
          [item_by_id(3)],
          @monsters
        )
      )
      @locations.push(Location.new(
          LOC_ID_SKYTOWER, 
          LOC_NAME_SKYTOWER, 
          LOC_DESC_SKYTOWER,
          LOC_CONNECTIONS_SKYTOWER,
          :assured,
          [item_by_id(4)],
          @monsters
        )
      )
    end
  end
end
