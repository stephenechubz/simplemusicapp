import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:simplemusicapp/models/song.dart";

class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
  final List<Song> _playlist = [
    // song 1
    Song(
      songName: "Don Moen - Hungry Heart",
      artistName: "Doen Moen",
      albumArtImagePath: "assets/images/donmoen2.jpg",
      audioPath: "audio/Don Moen - Hungry Heart.mp3",
    ),
    // song 2
    Song(
      songName: "Don Moen - Return to Me (Official Lyric Video)",
      artistName: "Doen Moen",
      albumArtImagePath: "assets/images/donmoen.jpg",
      audioPath: "audio/Don Moen - Return to Me (Official Lyric Video).mp3",
    ),
    // song 3
    Song(
      songName: "Don Moen - Thank You Lord  Live Worship Sessions",
      artistName: "Doen Moen",
      albumArtImagePath: "assets/images/donmoen3.jpg",
      audioPath: "audio/Don Moen - Thank You Lord  Live Worship Sessions.mp3",
    ),
  ];

  // current song playlist index
  int? _currentSongIndex;

  // A U D I O P L A Y E R S

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;
  // initially not on repeat mode
  bool _isRepeatSong = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop playing music
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause the current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // repeat song
  void repeat() {
    _isRepeatSong = true;
    notifyListeners();
  }

  // shuffle all songs

  // seek to specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_isRepeatSong) {
        // play the same music repeatedly
        currentSongIndex = _currentSongIndex;
      } else if (_currentSongIndex! < _playlist.length - 1) {
        // go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // if it's the last song, loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    // if more than 2 secs have passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    // if it's within first 2 secs of the song, go to previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if it's the first song, loop back to the last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    // listen for the current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });
    // listen for the song completed
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // dispose audio player

  /*
  Getters
  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  bool get isRepeatSong => _isRepeatSong;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*
  Setters
  */

  set currentSongIndex(int? newIndex) {
    // update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // paly the song at new index
    }

    // update UI
    notifyListeners();
  }
}
