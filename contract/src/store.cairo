use starknet::ContractAddress;
use dojo::world::WorldStorage;
use dojo::model::ModelStorage;
use core::num::traits::zero::Zero;

use full_starter_react::models::hostage::Hostage;
use full_starter_react::models::target::Target;
use full_starter_react::models::elimination::Elimination;
use full_starter_react::models::ammo::Ammo;

#[derive(Copy, Drop)]
pub struct Store {
    world: WorldStorage,
}

#[generate_trait]
pub impl StoreImpl of StoreTrait {
    fn new(world: WorldStorage) -> Store {
        Store { world: world }
    }

    // --------- Getters ---------
    fn get_hostage(self: Store, address: ContractAddress) -> Hostage {
        self.world.read_model(address)
    }

    fn get_elimination_tracker(self: Store, game_id: u32) -> Elimination {
        self.world.read_model(game_id)
    }

    fn get_ammo_tracker(self: Store, game_id: u32) -> Ammo {
        self.world.read_model(game_id)
    }

    fn get_target(self: Store, game_id: u32, target_id: u32) -> Target {
        self.world.read_model((game_id, target_id))
    }

    // --------- Setters ---------
    fn write_hostage(mut self: Store, hostage: @Hostage) {
        self.world.write_model(hostage)
    }

    fn write_elimination_tracker(mut self: Store, elimination: @Elimination) {
        self.world.write_model(elimination)
    }

    fn write_ammo_tracker(mut self: Store, ammo: @Ammo) {
        self.world.write_model(ammo)
    }

    fn write_target(mut self: Store, target: @Target) {
        self.world.write_model(target)
    }

    // --------- Game Actions ---------
    fn create_hostage(mut self: Store, address: ContractAddress) {
        let new_hostage = Hostage { address: address, total_games: 0, games_won: 0 };
        self.world.write_model(@new_hostage);
    }

    fn start_new_game(mut self: Store, game_id: u32, hostage_address: ContractAddress) {
        // Skip hostage logic for now - just create game entities
        
        // Create elimination tracker
        let elimination_tracker = Elimination {
            game_id: game_id,
            eliminations_count: 0,
        };
        self.world.write_model(@elimination_tracker);
        
        // Create ammo tracker with 10 bullets
        let ammo_tracker = Ammo {
            game_id: game_id,
            ammo_remaining: 10,
        };
        self.world.write_model(@ammo_tracker);
    }

    fn shoot_target(mut self: Store, game_id: u32, hit_real_target: bool) {
        let mut elimination_tracker = self.get_elimination_tracker(game_id);
        let mut ammo_tracker = self.get_ammo_tracker(game_id);
        
        if hit_real_target {
            // Hit real target: +1 elimination, +1 ammo
            elimination_tracker.eliminations_count += 1;
            ammo_tracker.ammo_remaining += 1;
        } else {
            // Hit fake hostage: -1 ammo only
            ammo_tracker.ammo_remaining -= 1;
        }
        
        self.world.write_model(@elimination_tracker);
        self.world.write_model(@ammo_tracker);
    }

    fn complete_game(mut self: Store, hostage_address: ContractAddress, won: bool) {
        if won {
            let mut hostage = self.get_hostage(hostage_address);
            hostage.games_won += 1;
            self.world.write_model(@hostage);
        }
    }
}