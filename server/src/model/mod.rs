pub struct User<I> {
    id: I,
    groups: std::collections::HashSet<String>,
    name: String,
    surname: String,
    email: String,
}

pub struct Album<I> {
    pub name: String,
    pub creation_date: u64,
    pub rw_users: std::collections::HashSet<I>,
    pub ro_users: std::collections::HashSet<I>,
}
