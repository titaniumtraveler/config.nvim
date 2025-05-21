;extends

((command
  name:     (command_name (word) @_command (#eq? @_command "jq"))
  argument: (raw_string) @injection.content)

  (#set! injection.language "jq")
  (#offset! @injection.content 0 1 0 -1))

((heredoc_redirect
  (heredoc_body) @injection.content
  (heredoc_end) @injection.language)

  (#downcase! @injection.language)
  (#set! injection.include-children))

