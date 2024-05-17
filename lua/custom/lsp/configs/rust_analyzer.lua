return {
  opts = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          features = "all",
        },
        check = {
          command = "clippy",
          features = "all",
        },
      },
    },
  },
}
