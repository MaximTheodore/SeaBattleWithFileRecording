import 'dart:io';

import 'package:sea_battle/game.dart';

void main(List<String> arguments) {
  while(true){
    print('Добро пожаловать в игру "Морской бой"');
    print('Выберите режим:');
    print('1 - Игрок против игрока');
    print('2 - Игрок против бота');
    print('3 - Выйти');
    stdout.write('Выбор: ');
    String? choice = stdin.readLineSync();
    int? type = int.tryParse(choice!); 
      if (type == 1){
        Game game = Game("pvp");
        game.start();
      }
      else if (type == 2){
        Game("pvb");
        Game game = Game("pvb");
        game.start();
      }
      else if (type == 3){
        exit(0);
      }
      else {
        print('Неверный выбор. Попробуйте снова.');
      }
  }

}
