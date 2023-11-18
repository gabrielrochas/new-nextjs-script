<h1 align='center'>Start a clean Next.js project with ESLint and Prettier</h1>

## Install Next.js

Replace `my-app` with your project name

```sh
npx create-next-app my-app --use-yarn --ts --tailwind --eslint --app --src-dir --import-alias "@/*"
```

> [!TIP]
>
> Learn more about `create-next-app` non-interactive [here](https://nextjs.org/docs/app/api-reference/create-next-app#non-interactive)

## Install and configure @typescript-eslint/eslint-plugin

Add @typescript-eslint/eslint-plugin

```sh
yarn add -D @typescript-eslint/eslint-plugin
```

> [!TIP]
> Learn more @typescript-eslint/eslint-plugin [here](https://www.npmjs.com/package/@typescript-eslint/eslint-plugin)

Update `.eslintrc.json`

```json
// .eslintrc.json
{
  "plugins": ["@typescript-eslint"],
  "extends": "next/core-web-vitals",
  "rules": {
    "prefer-const": "warn",
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/no-explicit-any": "error"
  }
}
```

---

## Install and configure Prettier

Add prettier, eslint-config-prettier, prettier-plugin-tailwindcss and @trivago/prettier-plugin-sort-imports

```sh
yarn add -D prettier eslint-config-prettier prettier-plugin-tailwindcss @trivago/prettier-plugin-sort-imports
```

> [!TIP]
> Learn more these libraries
>
> 1. [Prettier](https://www.npmjs.com/package/prettier)
> 2. [eslint-config-prettier](https://www.npmjs.com/package/eslint-config-prettier)
> 3. [prettier-plugin-tailwindcss](https://www.npmjs.com/package/prettier-plugin-tailwindcss)
> 4. [@trivago/prettier-plugin-sort-imports](https://www.npmjs.com/package/@trivago/prettier-plugin-sort-imports)

Create `.prettierrc.json` on the root of your project

```json
// .prettierrc.json
{
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
}
```

Create `.vscode/settings.json` and add the settings to auto-fix errors on save

```json
// .vscode/settings.json
{
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

---

## Add husky

### Husky check for errors, linting and formatting on commit

```sh
yarn add -D husky
```

> [!TIP]
> Learn more [Husky](https://github.com/typicode/husky)

Enable husky

```sh
yarn husky install
```

> [!IMPORTANT]
>
> Check the `.husky` folder on the root of the project

Add the git hook

```sh
yarn husky add .husky/pre-commit "yarn tsc --noEmit && yarn eslint . && yarn prettier --write ."
```

> [!IMPORTANT]
>
> Check the `pre-commit` file in `.husky` folder

### Add lint-staged

```sh
yarn add -D lint-staged
```

> [!TIP]
> Learn more [lint-staged](https://github.com/okonet/lint-staged)

Create `.lintstagedrc.json` and add the content below

```json
// .lintstagedrc.json
{
  "**/*.(ts|tsx|js)": ["eslint --fix", "prettier --write"],
  "**/*.(md|json)": "prettier --write"
}
```

Now, update the `.husky/pre-commit` file with the content below

```sh
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

yarn lint-staged
```

---

### Configure Jest (optional)

Add jest, @testing-library/jest-dom, @testing-library/react, eslint-plugin-testing-library, eslint-plugin-jest-dom and @types/jest

```sh
yarn add -D jest @testing-library/jest-dom @testing-library/react eslint-plugin-testing-library eslint-plugin-jest-dom @types/jest
```

> [!TIP]
> Learn more these libraries and plugins
>
> 1. [jest](https://www.npmjs.com/package/jest)
> 2. [eslint-plugin-testing-library](https://www.npmjs.com/package/eslint-plugin-testing-library)
> 3. [eslint-plugin-jest-dom](https://www.npmjs.com/package/eslint-plugin-jest-dom)
> 4. [@testing-library/jest-dom](https://www.npmjs.com/package/@testing-library/jest-dom)
> 5. [@testing-library/react](https://www.npmjs.com/package/@testing-library/react)
> 6. [@types/jest](https://www.npmjs.com/package/@types/jest)

Create the `jest.config.js` on the root of your project

```js
// jest.config.js
const nextJest = require('next/jest');
const createJestConfig = nextJest({
  dir: './',
});
const customJestConfig = {
  moduleDirectories: ['node_modules', '<rootDir>/'],
  testEnvironment: 'jest-environment-jsdom',
};
module.exports = createJestConfig(customJestConfig);
```

Now add `"jest --bail --findRelatedTests --passWithNoTests"` to the `.lintstagedrc.json` file

```json
{
  "**/*.(ts|tsx|js)": [
    "eslint --fix",
    "prettier --write",
    "jest --bail --findRelatedTests --passWithNoTests"
  ],
  "**/*.(md|json)": "prettier --write"
}
```
