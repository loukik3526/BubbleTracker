import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // Singleton instance
  static final AudioManager _instance = AudioManager._internal();
  static AudioManager get instance => _instance;

  AudioManager._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMuted = false;

  Future<void> init() async {
    // 1. Set the Audio Context to allow 'Mixing' (playing together)
    await AudioPlayer.global.setAudioContext(AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {AVAudioSessionOptions.mixWithOthers},
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: true,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.none,
      ),
    ));

    // 2. Setup Music Player
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setPlayerMode(PlayerMode.mediaPlayer);

    // 3. Ensure SFX is ready for quick firing
    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  Future<void> playMusic() async {
    if (_isMuted) return;
    try {
      await _musicPlayer.play(AssetSource('audio/space_ambient.mp3'), volume: 0.3);
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  Future<void> playPop() async {
    if (_isMuted) return;
    try {
      await _sfxPlayer.play(AssetSource('audio/pop.mp3'), volume: 1.0);
    } catch (e) {
      print('Error playing pop sound: $e');
    }
  }

  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  void toggleMute(bool isMuted) {
    _isMuted = isMuted;
    if (_isMuted) {
      _musicPlayer.setVolume(0);
      _sfxPlayer.setVolume(0);
    } else {
      _musicPlayer.setVolume(0.3);
      _sfxPlayer.setVolume(1.0);
    }
  }
}
