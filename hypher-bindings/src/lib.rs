use wasm_minimal_protocol::*;

initiate_protocol!();

fn assume_utf8(buf: &[u8]) -> Result<&str, String> {
    str::from_utf8(buf).map_err(|_| "Invalid UTF-8 sequence".to_string())
}

fn iso_lang(code: &[u8]) -> Result<Result<hypher::Lang<'static>, String>, String> {
    let s = assume_utf8(code)?;
    let lang = if s.len() == 2 {
        hypher::Lang::from_iso([code[0], code[1]])
    } else {
        None
    };
    Ok(lang.ok_or_else(|| format!("Invalid language: \"{}\"", s)))
}

#[wasm_func]
pub fn exists(lang: &[u8]) -> Result<Vec<u8>, String> {
    let ok = iso_lang(lang)?.is_ok();
    Ok(vec![ok as u8])
}

#[wasm_func]
pub fn syllables(word: &[u8], lang: &[u8]) -> Result<Vec<u8>, String> {
    let lang = if lang.len() <= 2 {
        iso_lang(lang)??
    } else {
        hypher::Lang::from_bytes((lang[0] as usize, lang[1] as usize), &lang[2..])
    };
    let word = assume_utf8(word)?;
    Ok(hypher::hyphenate(word, lang).join("\0").as_bytes().to_vec())
}

#[wasm_func]
pub fn build_trie(tex: &[u8]) -> Result<Vec<u8>, String> {
    let tex = assume_utf8(tex)?;
    let trie = hypher::builder::build_trie(&tex);
    Ok(trie)
}
