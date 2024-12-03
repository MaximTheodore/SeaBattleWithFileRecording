class Cell {
  var _alive_cell = '□';
  var _dead_cell = '╳';
  var _marker_cell = '•';
  var _emptyCell = '☷';
  bool _isHit = false;
  bool _isFail = false;
  bool _isAlive = false;
  bool hasShip = false;

  String getCell(){
    if (_isHit) return _dead_cell;
    else if(_isFail) return _marker_cell;
    else if(_isAlive) return _alive_cell;
    return _emptyCell;
  }
  void hit(){
    _isHit = true;
  }
  bool getIsHit(){ return _isHit;}
  bool getIsFail(){ return _isFail;}
  bool getIsAlive(){ return _isAlive;}
  void fail(){
    _isFail = true;
  }
  void alive(){
    _isAlive = true;
  } 

  void reset(){
    _isHit = false;
    _isFail = false;
    _isAlive = false;
  }
}