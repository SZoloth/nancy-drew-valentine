#!/usr/bin/env bash
set -euo pipefail

# Nancy Drew Valentine — Audio Asset Generator
# Calls ElevenLabs API to generate TTS, background music, and sound effects.
# Output: assets/audio/

API_KEY="sk_e4f419250074b076d9246e9f3d62d6812ccfe6276efc4e07"
VOICE_ID="OPZlc5F6onY4kTiuT1ZN"
MODEL="eleven_multilingual_v2"
OUT="assets/audio"

mkdir -p "$OUT"

# ──────────────────────────────────────────────
# Helper: generate TTS
# Usage: tts "output_file" "text"
# ──────────────────────────────────────────────
tts() {
  local file="$1" text="$2"
  if [[ -f "$OUT/$file" ]]; then
    echo "  SKIP $file (exists)"
    return
  fi
  echo "  TTS  $file"
  curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/$VOICE_ID" \
    -H "xi-api-key: $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg text "$text" --arg model "$MODEL" '{
      text: $text,
      model_id: $model,
      voice_settings: { stability: 0.5, similarity_boost: 0.75 }
    }')" \
    -o "$OUT/$file"
}

# ──────────────────────────────────────────────
# Helper: generate music
# Usage: music "output_file" "prompt"
# ──────────────────────────────────────────────
music() {
  local file="$1" prompt="$2"
  if [[ -f "$OUT/$file" ]]; then
    echo "  SKIP $file (exists)"
    return
  fi
  echo "  MUSIC $file"
  # Using sound-generation endpoint (music endpoint requires paid plan)
  curl -s -X POST "https://api.elevenlabs.io/v1/sound-generation" \
    -H "xi-api-key: $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg prompt "$prompt" '{
      text: $prompt,
      duration_seconds: 10
    }')" \
    -o "$OUT/$file"
}

# ──────────────────────────────────────────────
# Helper: generate sound effect
# Usage: sfx "output_file" "prompt" [duration_seconds]
# ──────────────────────────────────────────────
sfx() {
  local file="$1" prompt="$2" dur="${3:-2}"
  if [[ -f "$OUT/$file" ]]; then
    echo "  SKIP $file (exists)"
    return
  fi
  echo "  SFX  $file"
  curl -s -X POST "https://api.elevenlabs.io/v1/sound-generation" \
    -H "xi-api-key: $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg prompt "$prompt" --argjson dur "$dur" '{
      text: $prompt,
      duration_seconds: $dur
    }')" \
    -o "$OUT/$file"
}

# ══════════════════════════════════════════════
# 1. NARRATOR TTS LINES
# ══════════════════════════════════════════════
echo "=== Generating narrator TTS ==="

# Scene 1 dialog (lines 0-5, all narrator/casefile)
tts "s1-d0.mp3" "A new case file lands on your desk. The label reads: VALENTINE'S DAY - CLASSIFIED."
tts "s1-d1.mp3" "You open it. Inside, a note:"
tts "s1-d2.mp3" "Carter, something's been stolen. Five of our best memories have gone missing, scattered across the places that matter most to us. I need you to find them. Follow the clues. Trust your instincts. You've always been the smarter one anyway. I know how much you love a good puzzle."
tts "s1-d3.mp3" "-- Sam"
tts "s1-d4.mp3" "Pinned to the note: a photo of a pottery studio, a plane ticket stub, a dive log, a concert wristband, and a faded Polaroid of mountains at sunset."
tts "s1-d5.mp3" "Your journal is open. Your phone is charged. Let's get to work, detective."

# Scene 2 dialog (lines 0-3)
tts "s2-d0.mp3" "The first clue leads to a pottery studio in Denver. CITY MUD. The air smells like wet clay and coffee grounds."
tts "s2-d1.mp3" "Someone left a half-finished mug on the wheel. There's a note tucked inside it."
tts "s2-d2.mp3" "This is where it started. I saw you across the studio in overalls, hands covered in slip, and thought: okay, she's trouble. I like trouble. I needed an excuse to talk to you outside of the studio. So I came up with one."
tts "s2-d3.mp3" "Two puzzles guard the memory hidden here. Crack them both."
# Scene 2 success
tts "s2-success.mp3" "The locks click open. A memory surfaces, warm and specific, like clay still holding the shape of someone's hands."

# Scene 3 dialog (lines 0-3)
tts "s3-d0.mp3" "The next clue takes you across the Atlantic. London. A football stadium, an incredible restaurant, and a club with a stage."
tts "s3-d1.mp3" "On the table at Gymkhana, someone's left a menu with a question circled in pen."
tts "s3-d2.mp3" "London was a gamble. Early days. Lots of time together with nowhere to hide. But we crushed it. We traveled well together. We ate incredible food. I watched the Pats lose and I didn't care because I saw how happy you were."
tts "s3-d3.mp3" "We drank and danced and bar hopped till we found our way to a club and made our debut on the London stage."
# Scene 3 success
tts "s3-success.mp3" "The opening synth hits and the memory comes flooding back. Two people, deliriously tired, screaming into microphones like their lives depended on it."

# Scene 4 dialog (lines 0-3)
tts "s4-d0.mp3" "The trail leads to Thailand. Koh Tao. Warm water. Sunlight cutting through the surface in shafts."
tts "s4-d1.mp3" "A dive log is open on the boat. The entry reads:"
tts "s4-d2.mp3" "It was like another planet down there, and exploring it with you is like a dream come true."
tts "s4-d3.mp3" "The reef is alive with creatures. Find all five things Sam remembers from the dive."
# Scene 4 success
tts "s4-success.mp3" "All five found. The dive log entry completes itself, ink spreading across the page like watercolor."
# Scene 4 found_text lines
tts "s4-found0.mp3" "I think this is my favorite fish. It felt so alien and so much like a UFO, and it was so cool to see Toni excited about it."
tts "s4-found1.mp3" "Little manta ray, it was just hiding in a cave."
tts "s4-found2.mp3" "This one looked personally offended that we were in its neighborhood. Gave us the dirtiest look a fish can give."
tts "s4-found3.mp3" "Absolutely massive. After finding out how much it's worth, we definitely should have tried to steal it."
tts "s4-found4.mp3" "Remember seeing them move? Remember seeing Toni pick one up with his hands?"

# Scene 5 dialog (lines 0-3)
tts "s5-d0.mp3" "The final clue brings you home. Colorado. Dillon Amphitheater. The sun is going down behind the mountains and the lake is catching the last of the light."
tts "s5-d1.mp3" "Vampire Weekend is playing. The air is warm and the crowd is swaying and someone left a note folded under your seat."
tts "s5-d2.mp3" "This is the night I knew. Not 'liked you' knew. Really knew. The sun was doing that thing behind the mountains and you were standing there and I just thought: yeah. This one's different."
tts "s5-d3.mp3" "Carter baked Sam something special for his birthdays. What were they? Put the words together."
# Scene 5 success (2 lines)
tts "s5-success0.mp3" "The answer clicks into place. Brownies and carrot cake. Two birthdays, two batches of love — one of them ding-dong ditched."
tts "s5-success1.mp3" "Brownies and carrot cake."

echo ""
echo "=== Generating background music ==="

music "music-scene1.mp3" "Noir detective office ambience, moody jazz piano, low tension, smoky atmosphere, mysterious, loopable background music"
music "music-scene2.mp3" "Warm pottery studio, gentle acoustic guitar, earthy and cozy, handcraft vibes, soft percussion, loopable background music"
music "music-scene3.mp3" "London nightlife energy, upbeat indie rock, lively bar atmosphere, electric guitar, fun and energetic, loopable background music"
music "music-scene4.mp3" "Underwater ambient, ethereal oceanic pads, gentle water sounds, mysterious deep sea, calming and magical, loopable background music"
music "music-scene5.mp3" "Sunset amphitheater, warm indie folk, Vampire Weekend vibes, jangly guitar, golden hour feeling, optimistic, loopable background music"
music "music-scene6.mp3" "Emotional romantic finale, tender piano, building warmth, heartfelt, intimate love theme, gentle strings, loopable background music"

echo ""
echo "=== Generating sound effects ==="

sfx "sfx-letter-place.mp3" "Soft ceramic click, pottery shard placed gently on stone surface, subtle satisfying snap" 1
sfx "sfx-letter-wrong.mp3" "Gentle error buzz, soft wrong answer tone, light rejection sound" 1
sfx "sfx-puzzle-complete.mp3" "Satisfying lock mechanism unlocking, click and release, achievement unlock sound" 2
sfx "sfx-transition.mp3" "Page turn whoosh, smooth scene transition, cinematic swoosh" 1
sfx "sfx-item-found.mp3" "Underwater discovery chime, sonar ping, magical find sound" 2
sfx "sfx-inventory.mp3" "Item collected sparkle, brief magical shimmer, inventory pickup sound" 1
sfx "sfx-dialog-advance.mp3" "Subtle paper rustle, gentle page turn, soft parchment flip" 1
sfx "sfx-song-correct.mp3" "Triumphant karaoke hit, crowd cheer, victory fanfare short" 2
sfx "sfx-song-wrong.mp3" "Light comedy buzzer, gentle wrong answer, soft game show wrong" 1
sfx "sfx-word-place.mp3" "Word tile snap into slot, satisfying magnetic click, puzzle piece placed" 1
sfx "sfx-word-remove.mp3" "Word tile lift off, gentle release, soft detach sound" 1
sfx "sfx-hearts.mp3" "Gentle romantic shimmer, love sparkle, dreamy tinkling bells, heartwarming chime" 3

echo ""
echo "=== Done ==="
echo "Files generated in $OUT/:"
ls -la "$OUT/"
echo ""
echo "Total files: $(ls "$OUT/" | wc -l | tr -d ' ')"
