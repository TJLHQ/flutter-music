import 'dart:async';

RegExp timeExp = RegExp("[(\d{2,}):(\d{2})(?:\.(\d{2,3}))?]");
const STATE_PAUSE = 0;
const STATE_PLAYING = 1;

class LyricClass {
  final Function hanlder; // 回调函数
  List lines; // 数据
  int state; //播放状态
  int curLine;
  int pauseStamp; // 暂停时间

  int startStamp; // 开始时间
  int curNum; //当前多少行
  Timer _timer; //定时器

  LyricClass(
      {this.hanlder, this.lines, this.state = STATE_PAUSE, this.curLine = 0});

  _findCurNum(time) {
    for (int i = 0; i < this.lines.length; i++) {
      if (time <= this.lines[i].time) {
        return i;
      }
    }
    return this.lines.length - 1;
  }

  _callHandler(i) {
    if (i >= 0) {
      Map _item = Map();
      _item['txt'] = this.lines[i].txt;
      _item['lineNum'] = i; // 记录当前的item
      this.hanlder(_item);
    }
  }

  _playRest() {
    var line = this.lines[this.curNum];
    var delay =
        line.time - (DateTime.now().millisecondsSinceEpoch - this.startStamp);
    this._timer = Timer(Duration(milliseconds: delay), () {
      this._callHandler(this.curNum++);
      if (this.curNum < this.lines.length && this.state == STATE_PLAYING) {
        this._playRest();
      }
    });
  }

  play([int startTime = 0, bool skipLast = false]) {
    if (this.lines.length == 0) {
      return;
    }
    this.state = STATE_PLAYING;

    this.curNum = this._findCurNum(startTime); //当前多少行
    this.startStamp = DateTime.now().millisecondsSinceEpoch - startTime; // 获取当前播放时间

    if (!skipLast) {
      this._callHandler(this.curNum - 1);
    }

    if (this.curNum < this.lines.length) {
      this._timer?.cancel();
      this._playRest();
    }
  }

  togglePlay() {
    var now = DateTime.now().millisecondsSinceEpoch;
    if (this.state == STATE_PLAYING) {
      this.stop();
      this.pauseStamp = now; //记录暂停的时间
    } else {
      this.state = STATE_PLAYING;
      int _timeNumCurrent = (this.pauseStamp ?? now) - this.startStamp;
      this.play(_timeNumCurrent, true); //记录开始播放的时间;
      this.pauseStamp = 0;
    }
  }

  stop() {
    this.state = STATE_PAUSE;
    _timer.cancel();
  }

  seek(int offset) {
    this.play(offset);
  }

  complete() {
    this.pauseStamp = this.startStamp;
  }
}
