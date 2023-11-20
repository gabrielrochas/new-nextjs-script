 <h1 align="center">BASH script to create a clean Next.js project with ESLint, Jest, and Prettier setup</h1>

> [!TIP]
>
> You can check each step of this script [here](https://github.com/gabrielrochas/new-nextjs-script/blob/main/manual-steps-guide.md#start-a-clean-nextjs-project-with-eslint-and-prettier)

## [Usage](#usage)

1. Create `create-next-app.sh` file

```bash
nano create-next-app.sh
```

2. Add the <a href='#script'>script</a> content to `create-next-app.sh` script
3. Run the script

```bash
bash create-next-app.sh
```

## [Script](#script)

```sh
#!/bin/bash

# Reset
Color_Off='\033[0m'
# Regular Colors
Blue='\033[0;34m'
Green='\033[0;32m'
Red='\033[0;31m'

printf "Start a clean Next.js project with ESLint, Jest, and Prettier setup\n\n"

# Prompt project name
read -p "Enter the project name: " PROJECT_NAME

# Check if the project name is empty
if [ -z "$PROJECT_NAME" ]; then
  printf "⛔ ${Red}Project name cannot be empty${Color_Off}\n"
  exit 1
fi

# Install Next.js
npx create-next-app@latest "$PROJECT_NAME" --use-yarn --ts --tailwind --eslint --app --src-dir --import-alias "@/*"
cd "$PROJECT_NAME"

read -p "Proceed with installation? (y/n): " PROCEED

while true; do
  case "$PROCEED" in
  [Yy]*)
    # Configuring ESLint
    printf "\n\n👉 Configuring ESLint...\n"
    yarn add --dev @typescript-eslint/eslint-plugin
    echo '{
        "plugins": ["@typescript-eslint"],
        "extends": "next/core-web-vitals",
        "rules": {
          "prefer-const": "warn",
          "@typescript-eslint/no-unused-vars": "error",
          "@typescript-eslint/no-explicit-any": "error"
        }
      }' >.eslintrc.json

    printf "\n\n${Green}ESlint configured successfully!${Color_Off}"

    # Configuring Prettier
    printf "\n\n👉 Configuring Prettier...\n"
    yarn add -D prettier eslint-config-prettier prettier-plugin-tailwindcss @trivago/prettier-plugin-sort-imports
    echo '{
        "semi": false,
        "trailingComma": "es5",
        "singleQuote": true,
        "tabWidth": 2,
        "useTabs": false,
        "importOrder": [
          "^react$",
          "^(next|next/.*)$",
          "<THIRD_PARTY_MODULES>",
          "@/(.*)",
          "^[./]"
        ],
        "importOrderSeparation": true,
        "plugins": [
          "@trivago/prettier-plugin-sort-imports",
          "prettier-plugin-tailwindcss"
        ],
        "pluginSearchDirs": false
      }' >.prettierrc.json

    printf "\n\n${Green}Prettier configured successfully!${Color_Off}"

    # Configuring VSCode
    printf "\n\n👉 Configuring VSCode settings..."
    mkdir -p .vscode
    echo '{
        "editor.codeActionsOnSave": {
          "source.fixAll.eslint": true,
          "source.organizeImports": true
        },
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode"
      }' >.vscode/settings.json

    printf "\n\n${Green}VSCode configured successfully!${Color_Off}"

    # Configuring Husky
    printf "\n\n👉 Configuring Husky...\n"
    yarn add -D husky
    yarn husky install
    mkdir -p .husky
    echo '#!/usr/bin/env sh
      . "$(dirname -- "$0")/_/husky.sh"

      yarn lint-staged' >.husky/pre-commit
    chmod +x .husky/pre-commit

    printf "\n\n${Green}Husky configured successfully!${Color_Off}"

    # Configuring LintStaged
    printf "\n\n👉 Configuring LintStaged...\n"
    yarn add -D lint-staged
    echo '{
        "**/*.(ts|tsx|js)": ["eslint --fix", "prettier --write"],
        "**/*.(md|json)": "prettier --write"
      }' >.lintstagedrc.json

    printf "\n\n${Green}LintStaged configured successfully!${Color_Off}\n\n"

    break
    ;;
  [Nn]*)
    printf "⛔ ${Red}Setup cancelled${Color_Off}\n"
    break
    ;;
  *)
    printf "Please answer 'y' or 'n': "
    read PROCEED
    ;;
  esac
done

# Configuring Jest (optional)
read -p "Do you want to configure Jest (optional)? (y/n) " INSTALL_JEST

while true; do
  case "$INSTALL_JEST" in
  [Yy]*)
    printf "\n\n👉 Configuring Jest...\n"

    yarn add -D jest @testing-library/jest-dom @testing-library/react eslint-plugin-testing-library eslint-plugin-jest-dom @types/jest

    # Create jest.config.js
    printf "\n\n👉 Creating jest.config.js...\n"
    echo 'const nextJest = require("next/jest");
        const createJestConfig = nextJest({
          dir: "./",
        });
        const customJestConfig = {
          moduleDirectories: ["node_modules", "<rootDir>/"],
          testEnvironment: "jest-environment-jsdom",
        };
        module.exports = createJestConfig(customJestConfig);' >jest.config.js

    echo '{
          "**/*.(ts|tsx|js)": [
            "eslint --fix",
            "prettier --write",
            "jest --bail --findRelatedTests --passWithNoTests"
          ],
          "**/*.(md|json)": "prettier --write"
        }' >.lintstagedrc.json

    printf "\n\n${Green}Jest configured successfully!${Color_Off}"

    break
    ;;
  [Nn]*)
    printf "Skipping Jest setup...\n"
    break
    ;;
  *)
    printf "Please answer 'y' or 'n': "
    read INSTALL_JEST
    ;;
  esac
done

printf "\n\n🎉 ${Green}Setup completed successfully!${Color_Off}\n\n"

# Thank you
printf "😎 Thank you for using this script!\n"
printf "⭐ Please give us feedback on GitHub!\n"
printf "👉 ${Blue}https://github.com/gabrielrochas/new-nextjs-script${Color_Off}\n\n"

# Open VSCode
read -p "Do you want to open your project in VSCode? (y/n) " VSCODE

while true; do
  case "$VSCODE" in
  [Yy]*)

    printf "Opening VSCode..."
    code .

    break
    ;;
  [Nn]*)
    break
    ;;
  *)
    printf "Please answer 'y' or 'n': "
    read VSCODE
    break
    ;;
  esac
done

exit 1

```
