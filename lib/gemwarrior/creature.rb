# lib/gemwarrior/creature.rb
# Creature base class

require_relative 'constants'
require_relative 'inventory'

module Gemwarrior
  class Creature
    attr_reader :name, :description
    
    def initialize(id, name = 'Creature', face = 'calm', hands = 'smooth', mood = 'happy', level = 1, hp_cur = 10, hp_max = 10, atk_lo = 1, atk_hi = 3, inventory = Inventory.new, rox = 1)
      @id = id
      @name = name
      @face = face
      @hands = hands
      @mood = mood

      @level = level
      @hp_cur = hp_cur
      @hp_max = hp_max

      @atk_lo = atk_lo
      @atk_hi = atk_hi

      @inventory = inventory
      @rox = rox
    end
    
    def status
      puts "The #{name}'s face is #{@face}, hands are #{@hands}, and general mood is #{@mood}."
    end
    
  end
end