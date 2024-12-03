import 'package:sea_battle/player.dart';

import 'letter.dart';
import 'cell.dart';
import 'ship.dart';
import 'dart:io';

class Field {
  late List<Ship> ships;
  late List<List<Cell>> _map;
  int _size_x = 10, _size_y=10;
  Field(){
    _map = List.generate(_size_y, (y)=> List.generate(_size_x, (x)=> Cell()));
    ships=[];
  }

  void positionShip(Ship ship, int pos_x, int pos_y, bool isVertical) {
    if (isVertical) {
      for (int i = 0; i < ship.SIZE; i++) {
        _map[pos_y + i][pos_x].alive();
        ship.cells[i] = _map[pos_y + i][pos_x];
        ship.cells[i].hasShip = true;
      }
    } else{
      for (int i = 0; i < ship.SIZE; i++) {
        _map[pos_y][pos_x + i].alive();
        ship.cells[i] = _map[pos_y][pos_x + i];
        ship.cells[i].hasShip = true;
      }
    }
    ships.add(ship);
  }
  bool canPlacementShip(int x, int y, int size, bool isVertical) {
    for (int i = 0; i < size; i++) {
      int checkX = isVertical ? x + i : x;
      int checkY = isVertical ? y : y + i;

      if (checkX >= _size_y || checkY >= _size_x || _map[checkX][checkY].hasShip) {
        return false;
      }
    }
    return true;
  }


  
  void takeshoot(int x, int y, Player player){  
    Cell aim_cell = _map[x][y];  
    if (aim_cell.hasShip){
      for(var ship in ships){
        if(ship.cells.contains(aim_cell)){
          ship.hitCell(aim_cell);
          player.amount_hits++;
          if(ship.isSunk()){
            player.amount_hitting_ships++;
            markAroundSunkShip(ship);
          }
        }
      }
    }
    else{
      aim_cell.fail();
      player.amount_fails++;
    }
  }
  void markAroundSunkShip(Ship ship) {
    for (var cell in ship.cells) {
      int x = _map.indexWhere((row) => row.contains(cell));
      int y = _map[x].indexOf(cell);

      for (int i = x - 1; i <= x + 1; i++) {
        for (int j = y - 1; j <= y + 1; j++) {
          if (i >= 0 && i < _size_y && j >= 0 && j < _size_x && !_map[i][j].hasShip) {
            _map[i][j].fail(); 
          }
        }
      }
    }
  }
  
  
  void draw() {
    print('|  1  2  3  4  5  6  7  8  9  10');
    
    for (int i = 0; i < _size_y; i++) {
      stdout.write('${Letter.values[i].name} ');
      
      for (int j = 0; j < _size_x; j++) {
        stdout.write(' ${_map[i][j].getCell()} ');
      }
      print('');
    }
  }
  void drawEnemyField() {
    print('|  1  2  3  4  5  6  7  8  9  10');
    
    for (int i = 0; i < _size_y; i++) {
      stdout.write('${Letter.values[i].name} ');

      for (int j = 0; j < _size_x; j++) {
        Cell cell = _map[i][j];

        if (cell.getIsHit()) {
          stdout.write(' ${cell.getCell()} ');
        } else if (cell.getIsFail()) {
          stdout.write(' ${cell.getCell()} '); 
        } else {
          stdout.write(' ☷ ');
        }
      }

      print('');
    }
  }


}