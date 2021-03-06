# lib/gemwarrior/entities/items/pond.rb
# Entity::Item::Pond

require_relative '../item'

module Gemwarrior
  class Pond < Item
    # CONTACTS
    NEEDED_ITEMS = ['dehumidifier', 'feather', 'gun', 'stalactite']

    def initialize
      super

      self.name         = 'pond'
      self.name_display = 'Pond'
      self.description  = 'This tiny pool of water self-ripples every minute or so. Small, floating insects buzz around merrily. A small plaque lays at the foot, reading: "If the right objects curious doth possess, touch the water\'s surface and you\'ll get redress."'
    end

    def use(world)
      puts 'You gently place your fingers on the pond\'s rippling surface.'

      if (NEEDED_ITEMS - world.player.inventory.items.map(&:name)).empty?
        Audio.play_synth(:uncover_secret)
        puts 'The pond water explodes with a force that knocks you back onto the ground. When you come to, you notice the depression in the ground where the pond once was now has a new curious object!'
        self.description = 'A barren depression in the ground is all that is left of the pond.'
        return { type: 'item', data: 'Opalaser' }
      else
        puts 'You graze your fingers within the pond for a moment, feeling the coolness. You feel zen.'
        return { type: nil, data: nil }
      end
    end
  end
end
