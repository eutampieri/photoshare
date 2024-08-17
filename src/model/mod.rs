pub struct User<I> {
    id: I,
    groups: std::collections::HashSet<String>,
    name: String,
    surname: String,
    email: String,
}

pub struct Album {}
