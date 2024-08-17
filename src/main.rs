mod model;
fn main() {
    colog::init();
    log::info!("Starting workers...");
    let (folder_send, folder_recv) = std::sync::mpsc::channel();
    let (file_send, file_recv) = std::sync::mpsc::channel();
    {
        let folder_send = folder_send.clone();
        std::thread::spawn(move || loop {
            let folder: std::path::PathBuf = folder_recv.recv().unwrap();
            log::info!("Entering {}.", folder.display());
            for f in folder.read_dir().expect("Cannot read directory") {
                if let Ok(f) = f {
                    let t = f.file_type().unwrap();
                    if t.is_file() {
                        file_send.send(f.path()).unwrap();
                    } else if t.is_dir() {
                        folder_send.send(f.path()).unwrap();
                    }
                }
            }
        });
    }
    {
        std::thread::spawn(move || loop {
            let file: std::path::PathBuf = file_recv.recv().unwrap();
            std::thread::spawn(move || {
                log::info!("Analysing {}.", file.display());
                let data = std::fs::read(&file).unwrap();
                let hash = blake3::hash(&data);
                log::info!("{} is {:?}", file.display(), mimetype::detect(&data));
                log::debug!("Hash for {} is {}.", file.display(), hash);
            });
        });
    }
    folder_send.send(std::path::PathBuf::from(
        std::env::args().nth(1).expect("Start with path"),
    ));
    loop {
        std::thread::sleep(std::time::Duration::from_secs(60));
    }
}
