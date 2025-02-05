# zsh-switchenv

Simple ZSH plugin to seamlessly switch between environment variables across different contexts (staging, production, etc.)

## Usage

Use `switchenv` (or its alias `swenv`) to switch between environments. The plugin will:

1. Present a list of environments using `fzf` (falls back to standard selection if `fzf` isn't installed)
2. Set environment variables based on your selection
3. Automatically maintain a `~/.switchenv` file with your current environment

### Default Configuration

- **Environments**: production, staging, development
- **Prefixes**:
  - Production: `PRD_`
  - Staging: `STG_`
  - Development: `DEV_`

### Example

If you have these variables:
```zsh
PRD_API_KEY="prod-key"
PRD_ENDPOINT="https://api.prod"
STG_API_KEY="staging-key"
STG_ENDPOINT="https://api.staging"
```

Selecting "production" will set:
```zsh
API_KEY="prod-key"
ENDPOINT="https://api.prod"
```

## Setup

1. Clone this repo into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`):
```zsh
git clone https://github.com/rdeusser/zsh-switchenv ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-switchenv
```

2. Add the plugin to the list of plugins (inside `~/.zshrc`):
```zsh
plugins=(
    # other plugins...
    zsh-switchenv
)
```

## Configuration

### Basic Configuration

To customize the environments, set these overrides in your `~/.zshrc`:
```zsh
# Override environments
SWITCHENV_ENVIRONMENTS="production staging development testing"

# Override prefix mappings
SWITCHENV_PREFIX_MAP=(
    [production]="PROD_"
    [staging]="STAGING_"
    [development]="DEV_"
    [testing]="TEST_"
)

# Override colors
SWITCHENV_NEW_VAR_COLOR="cyan"
SWITCHENV_OLD_VAR_COLOR="yellow"
```

### Using ~/.switchenv

The `~/.switchenv` file is managed automatically by the plugin - you don't need to edit it manually.

To persist environment variables between sessions, add this to your `~/.zshenv` or `~/.zshrc`:
```zsh
[[ -f ~/.switchenv ]] && . ~/.switchenv
```

Note: Environment variables are exported in the current session regardless of whether you source
`~/.switchenv`. Without sourcing, changes will only persist for the current session.
