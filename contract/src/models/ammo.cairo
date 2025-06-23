#[derive(Copy, Drop, Serde, IntrospectPacked, Debug)]
#[dojo::model]
pub struct Ammo {
    #[key]
    pub game_id: u32,
    pub ammo_remaining: u32,
}