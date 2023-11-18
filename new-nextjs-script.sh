#!/bin/bash

echo "Start a clean Next.js project with ESLint, Jest, and Prettier setup"

# Prompt project name
read -p "Enter project name: " PROJECT_NAME

# Check if project name is empty
if [ -z "$PROJECT_NAME" ]; then
  echo "Project name cannot be empty"
  exit 1
fi

# Install Next.js
echo "Installing Next.js..."
npx create-next-app@latest "$PROJECT_NAME" --use-yarn --ts --tailwind --eslint --app --src-dir --import-alias "@/*"
cd "$PROJECT_NAME" || exit

# Configuring ESLint
echo "Configuring ESLint..."
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

# Configuring Prettier
echo "Configuring Prettier..."
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

# Configuring VSCode
echo "Configuring VSCode settings..."
mkdir -p .vscode
echo '{
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}' >.vscode/settings.json

# Configuring Husky
echo "Configuring Husky..."
yarn add -D husky
yarn husky install
mkdir -p .husky
echo '#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

yarn lint-staged' >.husky/pre-commit
chmod +x .husky/pre-commit

# Configuring LintStaged
echo "Configuring LintStaged..."
yarn add -D lint-staged
echo '{
  "**/*.(ts|tsx|js)": ["eslint --fix", "prettier --write"],
  "**/*.(md|json)": "prettier --write"
}' >.lintstagedrc.json

# Configuring Jest (optional)
echo "Configuring Jest (optional)..."
read -p "Do you want to configure Jest? (y/n) " ANSWER

if [ "$ANSWER" = "n" ]; then
  echo "Opeing VSCode..."
  code .
  exit 1
fi

yarn add -D jest @testing-library/jest-dom @testing-library/react eslint-plugin-testing-library eslint-plugin-jest-dom @types/jest

# Create jest.config.js
echo "Creating jest.config.js..."
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

echo "Setup completed successfully!"

# Open VSCode
read -p "Do you want to open VSCode? (y/n) " ANSWER

if [ "$ANSWER" = "n" ]; then
  echo "Thank you for using this script!"
  echo "Please give us feedback on GitHub!"
  echo "https://github.com/gabrielrochas/new-nextjs-script"
fi

echo "Opening VSCode..."
code .
