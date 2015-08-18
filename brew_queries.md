## Brew - get details local installations

- ` brew info --json=v1 --all | jq "map(select(.installed != []))" > ~/Downloads `
- ` brew deps --tree --installed > ~/Downloads `

```bash
#!/bin/bash

# Save the status of brew
# => $
brew info --json=v1 --all | jq "map(select(.installed != []))" > ~/Downloads
# => $
brew deps --tree --installed > ~/Downloads
```
