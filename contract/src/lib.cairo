pub mod store;
pub mod constants;

pub mod achievements {
    pub mod achievement;
}

pub mod helpers {
    pub mod timestamp;
}

pub mod systems {
    pub mod shooter;
}

pub mod models {
    pub mod hostage;
    pub mod target;
    pub mod elimination;
    pub mod ammo;
}

#[cfg(test)]
pub mod tests {
    pub mod test_game;
    pub mod utils;
}
