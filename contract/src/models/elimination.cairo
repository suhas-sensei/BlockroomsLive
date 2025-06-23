#[derive(Copy, Drop, Serde, IntrospectPacked, Debug)]
#[dojo::model]
pub struct Elimination {
    #[key]
    pub game_id: u32,
    pub eliminations_count: u32,
}