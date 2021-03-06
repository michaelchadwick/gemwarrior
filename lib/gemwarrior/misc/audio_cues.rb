﻿# lib/gemwarrior/misc/audio_cues.rb
# Audio cue symbol -> notes/wav_file

module Gemwarrior
  module AudioCues
    def self.add key, val
      @@cues ||= {}
      @@cues[key] = val
    end

    def self.cues
      @@cues ||= {}
    end

    self.add :bg1, {
      synth: [
        { frequencies: 'C4', duration: 400 },
        { frequencies: 'C5', duration: 400 },
        { frequencies: 'C4', duration: 400 },
        { frequencies: 'C5', duration: 400 },
        { frequencies: 'C4', duration: 400 },
        { frequencies: 'C5', duration: 400 },
        { frequencies: 'G4', duration: 400 },
        { frequencies: 'A4', duration: 400 },
        { frequencies: 'C4', duration: 400 },
        { frequencies: 'C5', duration: 400 },
        { frequencies: 'C4', duration: 400 },
        { frequencies: 'C5', duration: 400 },
        { frequencies: 'C4', duration: 400 },
        { frequencies: 'C5', duration: 400 },
        { frequencies: 'B4', duration: 400 },
        { frequencies: 'A4', duration: 400 },
      ],
      sample: 'bg1.wav'
    }

    self.add :battle_start, {
      synth: [
        { frequencies: 'G4',  duration: 50 },
        { frequencies: 'G#4', duration: 50 },
        { frequencies: 'G4',  duration: 50 },
        { frequencies: 'G#4', duration: 50 },
        { frequencies: 'G4',  duration: 50 },
        { frequencies: 'G#4', duration: 50 }
      ],
      sample: 'battle_start.wav'
    }

    self.add :battle_player_attack, {
      synth: [{ frequencies: 'A4,E4,B5', duration: 75 }],
      sample: 'battle_player_attack.wav'
    }

    self.add :battle_player_miss, {
      synth: [{ frequencies: 'A4', duration: 75 }],
      sample: 'battle_player_miss.wav'
    }

    self.add :battle_monster_attack, {
      synth: [{ frequencies: 'B4,E#5,A5', duration: 75 }],
      sample: 'battle_monster_attack.wav'
    }

    self.add :battle_monster_miss, {
      synth: [{ frequencies: 'B4', duration: 75 }],
      sample: 'battle_monster_miss.wav'
    }

    self.add :battle_win_boss, {
      synth: [
        { frequencies: 'E5', duration: 50 },
        { frequencies: 'F5', duration: 50 },
        { frequencies: 'E5', duration: 100 },
        { frequencies: 'E5', duration: 50 },
        { frequencies: 'F5', duration: 50 },
        { frequencies: 'E5', duration: 100 },
        { frequencies: 'E4,A4', duration: 50 },
        { frequencies: 'E4,A4', duration: 200 }
      ],
      sample: 'battle_win_boss.wav'
    }

    self.add :battle_win_monster, {
      synth: [
        { frequencies: 'D5', duration: 50 },
        { frequencies: 'E5', duration: 50 },
        { frequencies: 'D5', duration: 100 },
        { frequencies: 'D4', duration: 50 },
        { frequencies: 'D4', duration: 200 }
      ],
      sample: 'battle_win_monster.wav'
    }

    self.add :intro, {
      synth: [
        { frequencies: 'C4,G4',  duration: 350 },
        { frequencies: 'D3,A4',  duration: 85 },
        { frequencies: 'E3,B4',  duration: 85 },
        { frequencies: 'F3,C5',  duration: 170 },
        { frequencies: 'F3,C5',  duration: 170 },
        { frequencies: 'F3,C5',  duration: 170 },
        { frequencies: 'G3,B4,D5',  duration: 350 }
      ],
      sample: 'intro.wav'
    }

    self.add :player_level_up, {
      synth: [
        { frequencies: 'D4,A4,D5,A5,D6', duration: 100 },
        { frequencies: 'D4,A4,D5,A5,D6', duration: 350 },
        { frequencies: 'E4,B4,E5,B5,E6', duration: 500 }
      ]
    }

    self.add :player_resurrection, {
      synth: [
        { frequencies: 'D#5', duration: 100 },
        { frequencies: 'A4',  duration: 150 },
        { frequencies: 'F#4', duration: 200 },
        { frequencies: 'F4',  duration: 1000 }
      ],
      sample: 'player_resurrection.wav'
    }

    self.add :player_travel, {
      synth: [
        { frequencies: 'C4', duration: 75 },
        { frequencies: 'D4', duration: 75 },
        { frequencies: 'E4', duration: 75 }
      ],
      sample: 'player_travel.wav'
    }

    self.add :player_travel_east, {
      synth: [
        { frequencies: 'E4', duration: 75 },
        { frequencies: 'G4', duration: 75 },
        { frequencies: 'E4', duration: 75 }
      ],
      sample: 'player_travel_east.wav'
    }

    self.add :player_travel_north, {
      synth: [
        { frequencies: 'C4', duration: 75 },
        { frequencies: 'D4', duration: 75 },
        { frequencies: 'E4', duration: 75 }
      ],
      sample: 'player_travel_north.wav'
    }

    self.add :player_travel_south, {
      synth: [
        { frequencies: 'E4', duration: 75 },
        { frequencies: 'D4', duration: 75 },
        { frequencies: 'C4', duration: 75 }
      ],
      sample: 'player_travel_south.wav'
    }

    self.add :player_travel_west, {
      synth: [
        { frequencies: 'C4', duration: 75 },
        { frequencies: 'A3', duration: 75 },
        { frequencies: 'C4', duration: 75 }
      ],
      sample: 'player_travel_west.wav'
    }

    self.add :resume_game, {
      synth: [
        { frequencies: 'C4', duration: 75 },
        { frequencies: 'D4', duration: 75 },
        { frequencies: 'E4', duration: 75 },
        { frequencies: 'F#4', duration: 75 },
        { frequencies: 'G#4', duration: 75 },
        { frequencies: 'A#4', duration: 75 },
        { frequencies: 'C5', duration: 75 },
        { frequencies: 'D5', duration: 75 },
        { frequencies: 'E5', duration: 75 },
        { frequencies: 'F#5', duration: 75 }
      ],
      sample: 'test.wav'
    }

    self.add :test, {
      synth: [
        { frequencies: 'F4', duration: 75 },
        { frequencies: 'E5', duration: 75 },
        { frequencies: 'C5', duration: 75 },
        { frequencies: 'E5', duration: 75 }
      ],
      sample: 'test.wav'
    }

    self.add :uncover_secret, {
      synth: [
        { frequencies: 'F5', duration: 150 },
        { frequencies: 'E5', duration: 150 },
        { frequencies: 'C#4', duration: 150 },
        { frequencies: 'C4', duration: 150 },
        { frequencies: 'D#5', duration: 150 },
        { frequencies: 'F#5', duration: 150 },
        { frequencies: 'A5', duration: 150 }
      ],
      sample: 'uncover_secret.wav'
    }

    self.add :win_game, {
      synth: [
        { frequencies: 'G3',  duration: 250 },
        { frequencies: 'A3',  duration: 50 },
        { frequencies: 'B3',  duration: 50 },
        { frequencies: 'C4',  duration: 50 },
        { frequencies: 'D4',  duration: 250 },
        { frequencies: 'E4',  duration: 50 },
        { frequencies: 'F#4', duration: 50 },
        { frequencies: 'G4',  duration: 50 },
        { frequencies: 'A4',  duration: 250 },
        { frequencies: 'B4',  duration: 50 },
        { frequencies: 'C5',  duration: 50 },
        { frequencies: 'D5',  duration: 50 },
        { frequencies: 'E5',  duration: 50 },
        { frequencies: 'F#5', duration: 50 },
        { frequencies: 'G5',  duration: 1000 }
      ],
      sample: 'win_game.wav'
    }
  end
end
