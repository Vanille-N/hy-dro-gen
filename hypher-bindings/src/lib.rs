use wasm_minimal_protocol::*;

initiate_protocol!();

fn assume_utf8(buf: &[u8]) -> Result<&str, String> {
    str::from_utf8(buf).map_err(|_| "Invalid UTF-8 sequence".to_string())
}

fn iso_lang(code: &[u8]) -> Result<Result<hypher::Lang, String>, String> {
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
    let lang = iso_lang(lang)??;
    let word = assume_utf8(word)?;
    Ok(hypher::hyphenate(word, lang).join("-").as_bytes().to_vec())
}
