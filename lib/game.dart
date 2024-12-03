import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:sea_battle/letter.dart';
import 'package:sea_battle/ship.dart';

import 'player.dart';

class Game {
  late Player player1;
  late Player player2;
  late String typeGame;
  int playerStep = 1;
  List<int> shipsSizes = [3];
  
  Game(this.typeGame) {
    player1 = Player("Капитан Крэк");
    player2 = typeGame == "pvp" ? Player("Капитан Токсик") : Player("Капитан Бот");
  }
  
  void start() {
    placementShips();
    playersShooting();
  }

  void playerTurn(Player main, Player opponent) {
    clear();
    print('Ваше поле, ${main.name}');
    main.field.draw();
    print('Поле противника, ${opponent.name}');
    opponent.field.drawEnemyField();
    opponent.field.draw();
    print('Введите поле обстрела');
    
    bool validInput = false;
    
    while (!validInput) {
      stdout.write("Формат ввода: A 1 (где A — это буква на латинице, а 1 — цифра): ");
      
      String? input = stdin.readLineSync();
      
      if (input != null) {
        List<String> choices = input.split(' ');
        
        if (choices.length == 2) {
          try {
            int x = int.parse(choices[1]) - 1;
            int y = Letter.values.indexWhere((l) => l.name == choices[0].toUpperCase());
            
            if (y == -1 || x < 0 || x >= 10) {
              print('Некорректные координаты. Попробуйте снова.');
            } else {
              opponent.field.takeshoot(y, x, main);
              validInput = true;
            }
          } catch (e) {
            print('Ошибка ввода. Проверьте формат и попробуйте снова.');
          }
        } else {
          print('Некорректный ввод. Формат: A 1');
        }
      }
    }
  }


  void placementShips(){
    placementShipsForPlayer(player1);

    if (typeGame == "pvp") {
      placementShipsForPlayer(player2);
    } else {
      print("Корабли бота размещены автоматически.");
      placementShipsForBot(player2);
    }

  }
  void placementShipsForPlayer(Player player){
    clear();
    var name = player.name;
    print("Привет, $name!");
    print("Вам необходимо сделать расстановку кораблей:");
    print("1 4-х палубный");
    print("2 3-Х палубных");
    print("3 2Х палубных");
    print("4 1-О палубных");

    for(var shipSize in shipsSizes){
      bool Isplacing = false;
      while(!Isplacing){
        print("Поле ${player.name}");
        player.field.draw();
        print("Формат ввода латиницей вертикальных кораблей (в виде A 1 v или A 1 h)");
        stdout.write('Разместите $shipSize палубный корабль: ');
        String? input = stdin.readLineSync();
        if (input != null){
          List<String> choices = input!.split(' ');
          if (choices.length == 3){
            try{
                int x = int.parse(choices[1]) - 1;
                int y = Letter.values.indexWhere((l) => l.name == choices[0].toUpperCase());
                bool isVertical = false;
                choices[2].toLowerCase() == 'v'? isVertical = true : isVertical = false;
                if ((isVertical && y + shipSize - 1 < 10) || (!isVertical && x + shipSize - 1 < 10)){

                  Ship ship = Ship(shipSize);
                  player.field.positionShip(ship, x, y, isVertical);
                  Isplacing = true;
                }
              
              
            }
            catch (e) {
              print('Ошибка ввода. Проверьте формат и попробуйте снова.');
            }
          }
          else{
            print('Некорректный ввод. Формат: A 1 v или A 1 v');
          }
        }
      }
    }
    print('Все корабли успешно размещены.');
    player.field.draw();
  }

  void placementShipsForBot(Player player) {
    Random random = Random();
    for (var shipSize in shipsSizes) {
      bool isPlacing = false;
      while (!isPlacing) {
        int x = random.nextInt(10);
        int y = random.nextInt(10);
        bool isVertical = random.nextBool();

        if ((isVertical && y + shipSize - 1 < 10) || (!isVertical && x + shipSize - 1 < 10)) {
          if (player.field.canPlacementShip(x, y, shipSize, isVertical)) {
            Ship ship = Ship(shipSize);
            player.field.positionShip(ship, x, y, isVertical);
            isPlacing = true;
          }
        }
      }
    }
  }



  void playersShooting() {
    while (!player1.isDefeated() && !player2.isDefeated()) {
      if (playerStep == 1) {
        playerTurn(player1, player2);
        playerStep = 2; 
      } else if (playerStep == 2) {
        if (checkType()) {
          playerTurn(player2,player1);
        } else {
          botTurn();
        }
        playerStep = 1;
      }

    }
    checkWinner();
  }

  void botTurn() {
    Random random = Random();
    int x = random.nextInt(10);
    int y = random.nextInt(10);
    int x_view = x;
    print('${player2.name} выстрелил в клетку (${Letter.values[y].name}, $x_view)');
    player1.field.takeshoot(y, x, player2);
  }
  void checkWinner() {
    if (player1.isDefeated()) {
      print('Победитель ${player2.name}');
    } else if (player2.isDefeated()) {
      print('Победитель ${player1.name}');
    }
    print('----------------------------------------------------------------------------');
    print('Таблица счета игроков');
    print('Игрок ${player1.name} произвел ${player1.amount_hits} успешных выстрела\n ${player1.amount_fails} промахов \nПотопил ${player1.amount_hitting_ships} кораблей из ${shipsSizes.length}\n');
    print('----------------------------------------------------------------------------');
    print('Игрок ${player2.name} произвел ${player2.amount_hits} успешных выстрела\n ${player2.amount_fails} промахов \nПотопил ${player2.amount_hitting_ships} кораблей из ${shipsSizes.length}\n');
    print('----------------------------------------------------------------------------');
    var data1 = 'Игрок ${player1.name} произвел ${player1.amount_hits} успешных выстрела\n ${player1.amount_fails} промахов \nПотопил ${player1.amount_hitting_ships} кораблей\n';
    var data2 = 'Игрок ${player2.name} произвел ${player2.amount_hits} успешных выстрела\n ${player2.amount_fails} промахов \nПотопил ${player2.amount_hitting_ships} кораблей\n';
    var data = data1 + data2;
    writingResult(data);
  }

  bool checkType() {
    return typeGame == "pvp";
  }

  void  writingResult  (var data) async{

    final resultDir = Directory('./Results');
    if (resultDir.existsSync()) resultDir.deleteSync(recursive: true);
    resultDir.createSync(recursive: true);

    final resultFile = File('${resultDir.path}/results.txt');
    if (resultFile.existsSync()) resultFile.deleteSync(recursive: true);
    resultFile.createSync(recursive: true);

    resultFile.writeAsStringSync(data.toString());


  }

  void clear(){
   for(int i = 0; i < stdout.terminalLines; i++) {
      stdout.writeln();
    }
  }
}