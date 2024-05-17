; extends

(minted_environment
  begin: (begin language: (curly_group_text (text) @_lang))
  code: (source_code) @injection.content (#set-lang-from-info-string! @_lang)
) @capture
