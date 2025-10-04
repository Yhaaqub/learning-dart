// assignment one

import 'dart:io';
import 'dart:math';

// Game state variables
final rand = Random();
String player_name = '';
int health = 100;
int gold = 50;
List<String> inventory = ['sword'];
List<String> active_effects = [];

void main() {
  // Begin game
  stdout.write("Enter your name: ");
  player_name = stdin.readLineSync() ?? 'Hero';

  print("\nWelcome, $player_name, to the Dungeon of Syntax!\n");

  // Main game loop
  while (health > 0) {
    // Randomly select event
    int event = rand.nextInt(3); // 0 = monster, 1 = chest, 2 = nothing

    if (event == 0) {
      battle_monster();
    } else if (event == 1) {
      open_chest();
    } else {
      print("The room is empty.\n");
    }

    display_status();

    // Ask player what to do next
    stdout.write("[continue], [use item], or [quit]? ");
    String choice = (stdin.readLineSync() ?? '').toLowerCase().trim();

    if (choice == "use item") {
      use_item();
    } else if (choice == "quit") {
      print("You leave the dungeon with your loot!");
      break;
    }
  }

  if (health <= 0) {
    print("GAME OVER.");
  }
}

// Battle with monster
void battle_monster() {
  int monster_health = 20 + rand.nextInt(21); // 20–40

  while (monster_health > 0 && health > 0) {
    stdout.write("[attack] or [run]? ");
    String action = (stdin.readLineSync() ?? '').toLowerCase().trim();

    if (action == "attack") {
      int damage = 5 + rand.nextInt(11); // 5–15
      if (active_effects.contains("amulet")) {
        damage += 5;
        active_effects.remove("amulet");
      }
      monster_health -= damage;

      if (monster_health > 0) {
        int monster_damage = 5 + rand.nextInt(8); // 5–12
        if (active_effects.contains("shield")) {
          monster_damage ~/= 2;
          active_effects.remove("shield");
        }
        health -= monster_damage;
        print(
          "The monster hits you for $monster_damage damage. Your health: $health",
        );
      }
    } else if (action == "run") {
      return;
    } else {
      print("Invalid choice.");
    }
  }

  if (health <= 0) {
    return; // Main loop will handle Game Over When Health is 0
  } else {
    int reward = 10 + rand.nextInt(21); // 10–30
    gold += reward;
    print("You defeated the monster! You found $reward gold.\n");
  }
}

// Open chest event
void open_chest() {
  List<String> rewards = ["potion", "shield", "amulet"];
  String item = rewards[rand.nextInt(rewards.length)];
  inventory.add(item);
}

// Use item from inventory
void use_item() {
  if (inventory.isEmpty) {
    print("NO ITEMS.\n");
    return;
  }

  for (int i = 0; i < inventory.length; i++) {
    print("${i + 1}) ${inventory[i]}");
  }

  stdout.write("Choose an item number to use: ");
  int? choice = int.tryParse(stdin.readLineSync() ?? '');

  if (choice == null || choice < 1 || choice > inventory.length) {
    print("Invalid selection.\n");
    return;
  }

  String item = inventory[choice - 1];

  if (item == "potion") {
    health += 20;
  } else if (item == "shield") {
    active_effects.add("shield");
  } else if (item == "amulet") {
    active_effects.add("amulet");
  }

  inventory.removeAt(choice - 1);
}

// Display current status
void display_status() {
  print("\n--- Current Status ---");
  print("Health: $health   Gold: $gold");
  print("Inventory: ${inventory.isEmpty ? 'Empty' : inventory.join(', ')}");
  print(
    "Active Effects: ${active_effects.isEmpty ? 'None' : active_effects.join(', ')}\n",
  );
}
