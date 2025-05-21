;extends

(block_mapping_pair
  key:   (flow_node (plain_scalar (string_scalar) @_key)) (#eq? @_key "lint-command")
  value: (block_node (block_scalar) @injection.content)
         (#set! injection.language "bash")
         (#offset! @injection.content 0 1 0 0))
