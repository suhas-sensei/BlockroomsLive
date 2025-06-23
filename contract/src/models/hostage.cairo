use starknet::ContractAddress;
use core::num::traits::zero::Zero;
use full_starter_react::constants;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug)]
#[dojo::model]
pub struct Hostage {
    #[key]
    pub address: ContractAddress,
    pub total_games: u32,
    pub games_won: u32,
}

#[generate_trait]
pub impl HostageImpl of HostageTrait {
    fn new(address: ContractAddress, total_games: u32, games_won: u32) -> Hostage {
        Hostage {
            address: address,
            total_games: total_games,
            games_won: games_won,
        }
    }

    fn add_game(ref self: Hostage) {
        self.total_games += 1;
    }

    fn add_win(ref self: Hostage) {
        self.games_won += 1;
    }
}

#[generate_trait]
pub impl HostageAssert of AssertTrait {
    #[inline(always)]
    fn assert_exists(self: Hostage) {
        assert(self.is_non_zero(), 'Hostage: Does not exist');
    }

    #[inline(always)]
    fn assert_not_exists(self: Hostage) {
        assert(self.is_zero(), 'Hostage: Already exist');
    }
}

pub impl ZeroableHostageTrait of Zero<Hostage> {
    #[inline(always)]
    fn zero() -> Hostage {
        Hostage {
            address: constants::ZERO_ADDRESS(),
            total_games: 0,
            games_won: 0,
        }
    }

    #[inline(always)]
    fn is_zero(self: @Hostage) -> bool {
       *self.address == constants::ZERO_ADDRESS()
    }

    #[inline(always)]
    fn is_non_zero(self: @Hostage) -> bool {
        !self.is_zero()
    }
}