#[derive(Copy, Drop, Serde, IntrospectPacked, Debug)]
#[dojo::model]  
pub struct Target {
    #[key]
    pub game_id: u32,
    #[key]
    pub target_id: u32,
    pub position_x: u32,
    pub position_y: u32,
    pub position_z: u32,
    pub is_fake: bool,
    pub is_alive: bool,
}