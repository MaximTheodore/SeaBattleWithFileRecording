
import 'cell.dart';

class Ship {
  int SIZE = 0;
  late List<Cell> cells;

  Ship(this.SIZE){
    cells = List.filled(SIZE, Cell());
  }
  bool isSunk() {
    return cells.every((cell) => cell.getIsHit());
  }
  void hitCell(Cell hit_cell) {
    if (cells.contains(hit_cell)) {
      int index = cells.indexOf(hit_cell);
      cells[index].hit();
    }
  }
  
}