/// One index base per test binary. The variable is process-wide, so a per-test
/// directory could be deleted under a test running in parallel; the index path
/// already differs per journal.
pub fn shared_index_dir() {
    std::env::set_var("DAYFILE_INDEX_DIR", std::env::temp_dir().join(format!("dayfile-test-index-{}", std::process::id())));
}
