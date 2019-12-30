import 'dart:async';
import 'dart:html';
import 'dart:web_audio';
import 'package:seaside_blocs/bloc/music_player.dart';

class MusicPlayerBlocImpl extends MusicPlayerBloc {
  MusicPlayerBlocImpl(String musicUrl) : super(musicUrl);
  AudioContext audioContext;
  AudioBufferSourceNode source;
  double startTime;
  AudioBuffer audioBuffer;
  bool isSeeking;
  void play() {
    if (source == null) _setupSource();
    source.start(audioContext.currentTime);
    _setStart();
    tick();
    add(NativeStateChangedEvent(NativePlayerState.playing));
  }

  void pause() {
    _updateTime();
    audioContext.suspend();
    add(NativeStateChangedEvent(NativePlayerState.paused));
  }

  void stop() {
    source.stop();
    source = null;
    add(NativeStateChangedEvent(NativePlayerState.stopped));
  }

  void resume() {
    audioContext.resume();
    _setStart(_getCurrentVal());
    tick();
    add(NativeStateChangedEvent(NativePlayerState.playing));
  }

  void seek(double val) {
    isSeeking = true;
    double wantedVal = (state.duration.inMilliseconds * val) / 1000;
    source.stop();
    _setupSource();
    _setStart(wantedVal);
    tick();
    source.start(audioContext.currentTime, wantedVal);
  }

  MusicPlayerState onLoaded(LoadedEvent event) =>
      state.duration != event.duration
          ? IdleMusicState(event.duration)
          : null;

  void tick() => Future.delayed(Duration(milliseconds: 100), () {
        if (state is PlayingMusicState && audioContext != null) {
          _updateTime();
          tick();
        }
      });

  _updateTime() => add(MusicProgressEvent(Duration(
      milliseconds: (1000 * (audioContext.currentTime - startTime)).floor())));
  _setStart([double extra]) =>
      startTime = audioContext.currentTime - (extra ?? 0.0);
  _setupSource() {
    source = audioContext.createBufferSource();
    source.buffer = audioBuffer;
    source.connectNode(audioContext.destination);
    source.onEnded.listen((e) {
      if (isSeeking == true) {
        isSeeking = null;
      } else {
        source = null;
        add(NativeStateChangedEvent(NativePlayerState.completed));
      }
    });
  }

  double _getCurrentVal() {
    if (state is ValuedMusicState) {
      return (state as ValuedMusicState).value.inMilliseconds / 1000;
    }
    return 0.0;
  }

  @override
  MusicPlayerState get initialState {
    audioContext = AudioContext();
    HttpRequest.request(musicUrl, responseType: 'arraybuffer')
        .then((HttpRequest request) {
      // decode it
      return audioContext
          .decodeAudioData(request.response)
          .then((AudioBuffer buffer) {
        audioBuffer = buffer;
        add(LoadedEvent(
            Duration(milliseconds: (1000 * audioBuffer.duration).floor())));
        _setupSource();
      });
    });
    return LoadingMusicPlayerState();
  }

  @override
  Future<void> close() async {
    if (source != null) source.stop();
    source = null;
    audioContext = null;
    startTime = null;
    audioBuffer = null;
    isSeeking = null;
    super.close();
  }
}
