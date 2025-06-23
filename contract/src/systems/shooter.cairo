#[starknet::interface]
pub trait IShooter<T> {
    fn start_game(ref self: T) -> u32;
    fn shoot_target(ref self: T, game_id: u32, hit_real_target: bool);
    fn end_game(ref self: T, game_id: u32, won: bool);
}

#[dojo::contract]
pub mod shooter {
    use super::IShooter;
    use full_starter_react::store::StoreTrait;

    #[allow(unused_imports)]
    use dojo::model::ModelStorage;
    #[allow(unused_imports)]
    use dojo::world::{WorldStorage, WorldStorageTrait};
    #[allow(unused_imports)]
    use dojo::event::EventStorage;

    use starknet::{get_block_timestamp, get_caller_address};

    #[abi(embed_v0)]
    impl ShooterImpl of IShooter<ContractState> {
        
        fn start_game(ref self: ContractState) -> u32 {
            let mut world = self.world(@"full_starter_react");
            let store = StoreTrait::new(world);
            let caller = get_caller_address();
            let game_id: u32 = get_block_timestamp().try_into().unwrap();

            // Start new game using store
            store.start_new_game(game_id, caller);

            game_id
        }

        fn shoot_target(ref self: ContractState, game_id: u32, hit_real_target: bool) {
            let mut world = self.world(@"full_starter_react");
            let store = StoreTrait::new(world);

            // Get current trackers to validate game state
            let elimination_tracker = store.get_elimination_tracker(game_id);
            let ammo_tracker = store.get_ammo_tracker(game_id);
            
            // Check if game is still active
            assert(ammo_tracker.ammo_remaining > 0, 'No ammo remaining');
            assert(elimination_tracker.eliminations_count < 16, 'Game already won');

            // Execute shot
            store.shoot_target(game_id, hit_real_target);
        }

        fn end_game(ref self: ContractState, game_id: u32, won: bool) {
            let mut world = self.world(@"full_starter_react");
            let store = StoreTrait::new(world);
            let caller = get_caller_address();

            // Complete game
            store.complete_game(caller, won);
        }
    }
}